Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027033;
	b=lfIXxEyU+6JDiOZ8Z7uY+AXh+gmnTC7K22HZDR53/366T/O3KBBSsnol2+6ytj5OpPEE
	 0Wq7a+uSzzdXaDvo8sWGPjoh8xTzazQ4K/i3dOm1kzxX/3wusIn0vL58mavKxJu4EmGyk
	 gPiIsDWCwPhu6Nd7IAEF3eXE4QdTMcIEW2WFBT/enlSnf9nR4vgwZeqMCGQyHnPewBGgQ
	 jNp6mimoTBspVETChoAQcQQBr3HXoi+hVyyLKFWGvDZ4jcnDrxMyS3JV+dZciOeX8Vzvc
	 KSwOOAFL+X8442avCrMhssaMTwEqQDuvxk9vnDRpgFxutjUlRkMm2qCcROub9Azyp0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=peM7eQyD1/0CEnm9Jxew/ZMdnepOIjx0I09ZN/nE5rc=;
	b=T94K7tqQwXI5wdZ5me0hwYywdOH/EtnEXEAPpWMWE38GKNdrPz4EILrjRq3XnLJGKUxj
	 yyKjK0HNXNwf6BjFlcPf4qPIoGLXg2r5K2PiAJXX4Q9Ph78o9npW4A1Ev7VhZFp5LEtKJ
	 NEEUu+mHteh5wItpCShXEasNBNo9B/vk1amkZu89FgxegT3gEd2Kbv4VtaC+MGGNtbS61
	 pj/dtupvdxxhYBzz+GEq9rL98xUBoMEWy0lG6Zo+wFeRLvBkueDBhOoemasZLLTHF1iPN
	 OhhBf5ay3cg1PwswGfqShD8bmrTb8LNez2FovTE1ir1CUcgjpFFb6dsPHZgpTkebVqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwdgVWON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425AE606A325;
	Wed, 18 Nov 2026 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwdgVWON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E8B1F000C4;
	Wed, 18 Nov 2026 18:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027033;
	bh=peM7eQyD1/0CEnm9Jxew/ZMdnepOIjx0I09ZN/nE5rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwdgVWONZy/AQVO5gEQLXQPxcB8/Jcro2zPuIgJkjkSHYl7haODLXskWzTzssEUsp
	 Fo9HO0jmat/p5tCkHVtLWT3G59L8L4ifgMuKXa3QG9WFvkHz2l1urWQoyIaKx9i5/p
	 p9CWhG1hvkMa/nCVN3dyhj1Sv3cDEt/c9xZPbugA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1604/2151] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 15:55:39 +0100
Message-ID: <20261118150220.299180850@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit c887e53e1c852b88bd5442d1bf4717ee3e7aadda ]

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
a caller-supplied opcode and no bounds check. For a user QP the WQE
comes from an mmap'd SQ ring, so wqe->wr.opcode is an
attacker-controlled __u32 read back by the requester
(req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
qp->is_user branch and never runs validate_send_wr(), whose only
opcode check is itself !wr_opcode_mask() (it indexes before it
checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
so an out-of-range opcode reads out of bounds and the result is used
as a mask and dereferenced; observed as a KASAN global-out-of-bounds
"Read of size 4" and a wild-pointer oops.

Return a zero mask for an out-of-range opcode, matching how
validate_send_wr() already treats a zero mask (an invalid WR), so no
path indexes the array out of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261002164552.294749-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 18c7284d0e575..a3538a82ada76 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -188,6 +188,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



