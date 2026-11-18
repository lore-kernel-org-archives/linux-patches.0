Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020478;
	b=BhCMvDF3HiKvJHozkfb/JlZUxy+iw6VtwpiIukcgJUIgC4NMQAWUd25m+OGxPgWfFGbs
	 VD0BPiasZ0r6cRKNOovbiIMNyVOUPWrmy6+YfNB+mhZBipFsUqSYCGi3AC9W36Vfz786z
	 f7B0+D+uC9uTB42bR+/zdhtpE4DMLRgaY/Ut0+yNegfRkTNmq9in2fELn24nde2tp6idF
	 FuxAKNyVDycSSQdRSk3mvGfrQyFfWAtpklby0LNP7b9c0yMFmVyxQb/Yk9Y5pZR6RIK2J
	 vnHSmSO+ksuYBbZ8F91fJHvne8MghVaKM/6gHILuc0vCGkfYNYh2fWhb0Bnw9L8GVoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dDpXKG3VJdSkxrdUjCHlP7HBU+iHpzNrxVeOE2vuQ4=;
	b=1o3QQCmZRoX4bG9VgtrTNJWRWLPjrhXp9F6cstcu4XKyR4UhVLEt2/W6cMI06UKGfZlr
	 ogvwEHe3QtpEA1MqVfe1+pPJ6zvsIQ0hSWpwHT0tzQq85PVGsGe9+5Kb0HJpQOtw6HsCX
	 3Ub8eMdbSldews5AwUh7NamD7WTYxwoeOEvizZ9Pe9GAXGtIjMz/71qoHowWthNWWhHBY
	 u7QW48hiZmhvj8wap+PLQPfDwMaqycLRSAhukZWpil49feOoHg/eFM1WmyUCT29FI3Cdp
	 6w5LGvq71i/et1CWNWQYL35JBtyGMGfzFOCZAHR85Kjt/USw7rSgYmupav7WAh/ZGlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcHnHGpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B02606A31C;
	Wed, 18 Nov 2026 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcHnHGpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C031F000C4;
	Wed, 18 Nov 2026 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020478;
	bh=5dDpXKG3VJdSkxrdUjCHlP7HBU+iHpzNrxVeOE2vuQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcHnHGpwQx+dnaL2Z5StAETYS9pJtQUjR+//tSdwcbJL0v5XTj5HXyIHD2adfAW8c
	 QQjp6creNHim2xGTWWzNJOxqPywQIqciHIZ38Day7TwmuJyBRFmVt3j1MzEDI1cwuc
	 pRiQ4kUa+DOt95tgo9cTWFoWtkQcKQQyLCRrOqxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1964/2651] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150357.215774335@linuxfoundation.org>
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
index e57861a628236..9a8e96dfb792d 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -185,6 +185,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



