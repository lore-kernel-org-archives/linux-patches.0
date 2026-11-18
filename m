Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024881;
	b=Cy94lo5OnwltP/KMAW2JrgTvo8yHMoTVtmyqrX2w/l8NisTNkaWt0uqA5B4z9IjP9XPe
	 GXMhQioQeLO2lmDGcrmYRjunIc0FIVXSHXzZ8o0LfH23FUlBfZO+pwEiNgq2pw6sYjMvJ
	 L/fiuyTkZ3ydskNDfGebDLlDlr+GFeyHJDMvCMkhDuwHk9PUTyaHrw9QxQpeuj2ZZK3zw
	 MFFiie5jvasJS95CcfQZDzQ9go5SISTtivRHYCio84Cry+2L5fFCU2GXZX7VhIXi9NM1e
	 65ocL7Bj5qHa21uJPTwVvgGyDC0Iqe8KtwAidXZxoO5YpSWUT5ncW7gJ3rYdtKu9ugw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8uTYx4pBvxflOjVNHq0XDzQwcQIM8LWOJHEZWU37h6E=;
	b=WDXqY58V3K88An3dS7MQWzPscSDa+sb5tc4gNvgK4t6Sicsnxno0AOBAwmfIXJWxG+GU
	 5pzEgG50SInb64olxDXJnIgcV6tfztGpg8naIacToVXIKZvh6hls9NnAIIHQvlb622EPh
	 ogMIhSa4CdercgYcb5CZbozwZOcQUnWKOAEXh+HOZIG0P2DwtxEcOrNTw6LhUgzVEmgVg
	 DVCkFvJrMh6po8+TmSJpcFPDSuIENXk0DLPNSfCd7+kOFPNt1898RenUD2gX1M/6r2mYU
	 GmTdbcBfqn0CZX77xfrr0M4ek/KTW49ds8qg2xHNuU+1Y8tvjUGV/JPtVIeP8En6exg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hve2xkJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D06F606A320;
	Wed, 18 Nov 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hve2xkJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E914C1F000C4;
	Wed, 18 Nov 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024881;
	bh=8uTYx4pBvxflOjVNHq0XDzQwcQIM8LWOJHEZWU37h6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hve2xkJ7NRSpNRxp4t+xdnjMQ6sO8yxjQz7esSTSDGQB23DlKFvjb6ptpxJkk3gdq
	 hBsQt3iEXFiAjjdL7BKZ9zLCRnOhziWSYXnMMCiHUhPV5ahaRChYaKWhuZ8ysN71zU
	 T0X0KW54tqGQuHEoeiKRYGla9TCCbJWkgMwLq/IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0883/2151] RDMA/mlx4: Do not allow the user to write to the clock page
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150154.468572299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dd35e03402ab4..164f34e887552 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1176,6 +1176,10 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
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



