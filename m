Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030532;
	b=pkOEpauXmdxWe6mJPPFhw9T+N8ak2odIxJXjQPcbw4XHgdzXL93XWFrAJ8oeNeSJ+qAi
	 dUMTFQ5IihAS/ybNBuXq/z+jJ/zcKdcXDEJR8qCrehs/5JjgsiIQEFIidHPSMYjohYh58
	 7xBbaBK34l8288sjXRx7uCwLN4z4OrKjWKNGRF0/u6dM7B5ziyuXTDDdL1MZVT70Z+B6z
	 +9eZWmFoIkMUeI/EOv/3HB3obmXQVHmCq3+x3J6y4notbwnwUlYQYBO00aoBUsBSKBumf
	 LrYIZwOzbukegwq1DLp8Pmz7kTl/DbFYdcTMaH4Uw3d1mF0qLK528G571p0zYbsDTow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1eOLTe6IA9gqraEDvzY43n8v5KEoFbTEFAVPX1jaQ24=;
	b=Nb2XruCu37p+fiSbROd6DqS5o+oS4K0QypkNS1Zg771688YEK0TaoP1wt4M1YGY23JSk
	 Hebz/fvsiwuddI0eUHz16RY6sEFt/wZ6/Kqu2RZD2/++mHn2MEHx3cr9lmR9iJrFizeUd
	 4x8ViriEs3w60WBx4oomiH+kQViov6x9e/rMz1Jp6/r6V0vh5NTANs3rYQwuTW7HhKih3
	 86NsgHDU2b4jYiEZ8Wa7VMzxNNpQbZf7ZnCkdrZ8AFhJbzagIiCQXVHZ5JU/RJivMTMeN
	 KxM19K1FZPYocHqMGlcY9zkZBuu1c8nunDPngkyQaKHKcuBCwrwTyIwmYMZewg5PL3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SP7TZwtP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623C2606C43D;
	Wed, 18 Nov 2026 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SP7TZwtP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC21F000C8;
	Wed, 18 Nov 2026 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030532;
	bh=1eOLTe6IA9gqraEDvzY43n8v5KEoFbTEFAVPX1jaQ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP7TZwtPJAfPCwUxVr/NL0ZHv6TESPxAJ9p46v4cA6QClriGB2AzHERKvgBnoaKM0
	 wIUj3ned4+8P7VYSoG/543DWdNTpNn0mDzukqGwHPZ5TE+kLTMmdzsCAMjtGVxgNGU
	 hblweK5Dw6L6RWEQZolOmDpsaza9QNaTEhYdNhIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0697/1756] RDMA/mlx4: Do not allow the user to write to the clock page
Date: Wed, 18 Nov 2026 15:47:04 +0100
Message-ID: <20261118150036.942635735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



