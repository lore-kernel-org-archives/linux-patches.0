Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041746;
	b=pyJORDLwnFbh/9Eu+sjc2df46r9BBad25PaMo6PgPVBr4c79urbi/XQ5tW3x1RFX2Qml
	 6e2VOAbWPOQErqmcl9npdMMTGgMLAr04dPXgBB06qhaupOULfYiUNS0PHwl7ZI4ghtlwQ
	 gcoSuZw5TXIwo88f5fq2WYtAMRy/PUXi1rSGvDdLts+VwVAuAd6lTNXYlXIPZMQKp+qpK
	 ka94PHfDN2u7shyboVzGyUVI3lwtqy9KxoxAOVkE7JpDnv+0YrBTJdy77/NkAW2d1bRSj
	 ks6UMlLrEJ2QB9HGXsz9/YFuABK1Owy7d59wrIfhX33t6vmBFlZFyUGO6iGkdtGPoJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fn9BiOhGXKcztFQ3ZqMB0sLC8E6wanxDOKsyGTSRiLI=;
	b=St0PZLfJRJJjhrXxAU2aKPhP9Dm8x1+7RWc2NXCjU2OHz6dnyOx5ebZe6q+V144bUwcg
	 cwJIg0RB8W4zkPWoQPX2QNX1KBR2UpP7XLZ5kO1TrkONEdDTBjQPiMWRGVmDj5svHAqxl
	 LatghnJqixTo18ueFvzSXAY9znO1MRiJxalwJ8sb8Y8KOE7ONjaS/Fh1n9/8tKfz2S4HB
	 1wzwxLqWDkGLcin4qv+097FiaxFKQdTZ+p9yQAEF2kgr2nxQw6ZH8yahjhsD7m+Ekp6+q
	 +S3jSrsde6BUsJ4XCb3mQqiC+FM6b4k7nraHsKonCDTEYIa+sXx5rAq+BQHN59nbjhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHswPDDq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D42606A320;
	Wed, 18 Nov 2026 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHswPDDq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285491F000C4;
	Wed, 18 Nov 2026 22:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041746;
	bh=Fn9BiOhGXKcztFQ3ZqMB0sLC8E6wanxDOKsyGTSRiLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHswPDDq/qsqthFrgDLzB5aji9A2o6tEcb2j5kd/Y0VtJgytwBPfkto8NbSbeAXS2
	 zV5dnoJyiriN8OH1yTFsKGwamzFD+J9WSiDT08meaxrA9HGcMcRNeNiBJsfwNBYgXb
	 zBQvIyZLj8Q1crfbEiGYt7Jhr886WpcHGJdh1BSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2923/3318] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150448.098659334@linuxfoundation.org>
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
index f86778678cce7..5f4c19a581b5a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -179,6 +179,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



