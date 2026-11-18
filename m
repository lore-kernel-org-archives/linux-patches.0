Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040438;
	b=0QH3Tch0sScRlYnXotQkvoQiygku1bkLoW706r3qdX3phx5m/wlaFpGa0FhXbTZsR5Bt
	 8mHw+EYTPjc6Zxhp8PRLf7IyIC5mMO1LtT+zumjnUudyFKtm6FSNPr74k4Bkn0M4ep20B
	 8LdjxeyicnKZD6tpusEtjDXPn6RPKJbVpGrxoi6CRvsvx6QFKZbXOaR5dXcqo6FUusc3T
	 UfMFavpqskLbODTbGxmCiO4FlINUE+MW2CsB5Ni8N0HNsokKDKvOAWyYiWuMEkHdKFxea
	 ze5PohOfNxi4hTAbnYTHrQUrO2jx4aU2H6bimcSZ4fpHOXz43WJeWNt5MLyp5R+CXzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ngtiDnqIkCDekPqnRl6ZkMv60q2vmcYa3zAyzH/Cfi0=;
	b=ToDSSbowuu2SryIhOHQ53oBFl3nESwtprlUiVDLdyt49+PSSmOdUxWPEnI5gluVmsjcl
	 i21g+dVvOM9lWo6FAoNMmpZrBg6SxKzIdJ65qM2pTkd1azNYUoZkA12wfux6EHmaKQsZo
	 kC94jhysejjsFRLC1o3tG1JeMNRsf0ZuGMKqTcSkhwtacsXKF2IWuD04FcY2pDamwnIRb
	 JC8wR7MhhclT8GzVML714A7QokpLKe4wEPhYlhKnkOJL2yYWQsNTldx9EXo2zbwZju/C2
	 gVCWtdg+/37FB9KNJvG50Cn1x+jq15cj27YXOM1eYJ48GYy1BTcMWCNuSoBCkhYsNEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVHSa1MU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F95F606A31C;
	Wed, 18 Nov 2026 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVHSa1MU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2221F000C4;
	Wed, 18 Nov 2026 22:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040438;
	bh=ngtiDnqIkCDekPqnRl6ZkMv60q2vmcYa3zAyzH/Cfi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVHSa1MU5cK/uTBWYFMMcHhHSG/llMJVH2fMvAtc3CWN/w6eHMQLUIOWDzeKDfBbJ
	 L9ZNl1Lf3uUjp7FmWRGHTgPJ++anE4+i+JL32hfr0r8YK4TV1sCp0JcCxA7tzYs8NW
	 RcLsENte1MZp4wpf8XW0KpIXPEwJ54A0Rlr9ViCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2458/3318] RDMA/mlx4: Do not allow the user to write to the clock page
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150435.172326903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1bbdcff631d5..27bd03078d3c2 100644
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



