Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020461;
	b=sFKQskkln3RttPR9PqskEWFYS/LasrL0ra1+OJf4iptv+ztcJt4CUlVxfQjpI2j/DJub
	 tuAHq2g3if/8ZbmIV1BMNKzhAIeBtOxYiJpn2WVkjlDw6biSF6Dl6gLkJhr4HEghZBGOh
	 33+KiFDTHQDnYEr7sEc2DBvOlUrOafMg2/86KmADZJwhvJLB2Ewud7U6cZvZhfB51QJGN
	 Xo34939oksYaF1uXCrW5EDtC0pJ+zNdw4giIqBkg2oPJD6HXlU+xpuczqCkcDB7n0xxrh
	 36uuDsL7OsYlpsvXlYnUeW1lWqbKvXclfke51VagHf8X8nh00tGH4KTw61eUmG9iULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xfrL19TihJCWTSlCmE/ps8vU3lVoZjDmub/buvjUcv8=;
	b=mgtMz4B1A8ObZtxzQCkapXWo3SYQ5QzS5k8nklu7tLoNMUsDJgBV6RmBz5qRQaeQJ7Rt
	 wzGGkPLpqrIh708tsktvnZRjG/LDvrfl0Qe33tYVvkER9hsv2eO27gese2///Vc3bRhVW
	 V5LABJgwm80MDG14wq1QP9iFOZOiRtThzxPUI20a8ZaUhNhVzqDRG1aCbWg7hb0z+q6UQ
	 Idighw6qfbpbhPEFs5If9Um2xMuhz6ca9HvKd+JPZzU1CXoahUhfwIXC3NVU/rUIf9sG0
	 5Ve6+Gu6mxBPdHxGmzs8UHeYMOtjE6/TG2LMo+E6B20qdjUAnKHaH8IEbT6/QqGMgWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GF5UsXX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA84606A32F;
	Wed, 18 Nov 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GF5UsXX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1011F000C4;
	Wed, 18 Nov 2026 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020461;
	bh=xfrL19TihJCWTSlCmE/ps8vU3lVoZjDmub/buvjUcv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GF5UsXX14MOPR2JoOciv4FoO7XjxsPmyw12Z+1AEVn+bizSZ3Kz8TBN6p4GmkBQXS
	 P3jPv9g1AxkuWmV0iKyPWpqNJNVUGJWy6Gaai+N+xGkLGTVMG7rA0HLG4rr+aaZZ7z
	 4dV/3xpJDXEpKdxGDvTzjJ+DCUHcd7BpYdW4TbfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1959/2651] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150357.060756007@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 33afe9909f213d8bb8e80f0b93382dde0f56e2c7 ]

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152426.3259522-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea4772890..3a914c2438294 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -777,6 +777,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
-- 
2.53.0



