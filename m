Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017962;
	b=JtJ/oEbLV2tp1EJh6s1kykQMvelIx/y3T8Dy21EJ4ftMhBZOlE9tV3pR5/Lw+ca9kEau
	 1aux6UCak1rk2tmZdvwAb+HkvAXYLNPx7cnFPFq1QW/1FHdxYu3a4813oscG6OKa+VZkf
	 T0Sm5QRN9aBAqUQ4EuDceNYY+XhdEeQi8hp/GH6wn3aOriCXA2ehQr5uXsFXNHYdbK355
	 DL+zN707C06j8URb1skW9V7928b9WmIWVUSt1Cc0NkqEtTT0H0/tee0Vr3lzQzUynUe0e
	 we/80in+EApZSHlCEFSJFX0H3EClNtk6gAL/59iL3OfGLJdmS+AHJk62zuPMTqRxUYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ngc1rbmTNavykjef/ZTp2+0DPtosbIDlpdUpnlkF8cY=;
	b=oaUSNASYJZhw5IG/Uf/D91nL/MhdYdepg1ogM/iDtezkBqh8FKITunWRGqOiLmhmX3bK
	 FZ5sYbvYhlQEvjvrk+JJTze+GGWtNfjpjvBO2BdTYmOk+ghJ4p69V+PimtC6VcKJ0XRF9
	 KsvvmLaQToT1Rlg6PbveNWYepzNWSQ1/iGoVWphB3XIDkTiqHaINzENs+I/eEvk++EkWR
	 16RKDi2GNhdaEqu6K4TOmFllpHT6x6V8ir7ldsyqSeDX7783rnUqwpQCvxIuaaNi1bzq8
	 0bF4idLJOXI0G9Ehnrn8XgzxElWT1bBPDfc8TT34GnLe5hq5793W2JzgjzU2DPMZmxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwF5o2Gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30628606A320;
	Wed, 18 Nov 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwF5o2Gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C31B1F000C5;
	Wed, 18 Nov 2026 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017962;
	bh=ngc1rbmTNavykjef/ZTp2+0DPtosbIDlpdUpnlkF8cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwF5o2Gwu9rFCbDFCbCc7Bz507acHMypZkDpxIfIvIidT/EOfKOfG578A/YVHYhQH
	 9rBVWg/257Rk9KPTFD77hKgNOT+xrMzup0pbHrPQHmSUYgx9FrsTfR4oUzRloH7ACT
	 QsRP1lHmk1gyakye6ZoA5nB11i4IXsc5J34lh3rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1044/2651] RDMA/mlx4: Do not allow the user to write to the clock page
Date: Wed, 18 Nov 2026 15:38:04 +0100
Message-ID: <20261118150325.551252816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 33db1d9683b8fb00bc233d0bea093e694ed9afc5 ]

mlx4_ib_mmap() maps the internal clock page to userspace through
rdma_user_mmap_io(), which does not restrict write access. Userspace can
request PROT_WRITE directly, or upgrade a read-only mapping later with
mprotect() because VM_MAYWRITE remains set.

Reject VM_WRITE, VM_EXEC and clear VM_MAYWRITE, applying the same read-only
policy as commit c660133c339f ("RDMA/mlx5: Do not allow the user to write to the
clock page"). The rdma-core mlx4 provider requests this mapping with
PROT_READ, so its existing behavior is unchanged.

Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926111150.3197004-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7266a61419440..1594e6407b6c6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1169,6 +1169,10 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		struct mlx4_clock_params params;
 		int ret;
 
+		if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+			return -EPERM;
+		vm_flags_clear(vma, VM_MAYWRITE);
+
 		ret = mlx4_get_internal_clock_params(dev->dev, &params);
 		if (ret)
 			return ret;
-- 
2.53.0



