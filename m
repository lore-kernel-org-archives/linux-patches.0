Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043826;
	b=ppvYXYXY3XFPsAi+E3JZos6FEVLDOLgPT309583w+SoyHGvl1tCa6A5OUBZCAbne2KjQ
	 NdcXUIPFUcsAR+uQwwNn4EkOfJO8x2V0J63OQeSZDFUE1FnYnhgHkg1b5c6wyrFXnWit/
	 gBEyRNNVD2UckrVuiIliK7s1UQBwMgiWg0hpq76eaio2V/vKqSDDhjuaHOxp/W9KF4CfQ
	 gFSE7ZF+jglcKh6HiawyO+Q+BjiiwN1MI3qP0GkEywQDfNiRB5XTPKHH0HdtIFyiop11w
	 H7p8PMSIO69eiE8zjFNbL4qG7mKMUryXLI8O6CsPLfz7bBDTG+F/nSoa8jWVz7SEj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fn2+z07HmsgQzqfR7QECMWfbdzSjVmV0UuyQIBr+BhI=;
	b=NvdLG7JcLnSo0kNgiOFcQO8m7bpr5BYUpgZIUhTeU/g7+DldNL3cy0uSjHjPjCTtrA8q
	 QLTbMDogk9Le2GIgkJ0YXC2uWjNB4f2UfIaPRRiCDBlgILDcSLb8GYo3YOthzpHmEpfj4
	 IZgzPJhVe1ASilGtC37HuXdyFk4zc9LoqdDZd+a1vRFWBqqUWQvNzwB21IR6vi5vO1qWg
	 4Sclj3nqJmyUxi88QLwFGDXbKSI31aLY4OOaZH81m/1uczomu6eXPKXy290iwnR9osK7V
	 JCKtFpDUGCMjWP+cHlIA6A+nIFgaCDeYnwBoHGFRZ/RTIx2Q9xKeHW1xtNvziMnHDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NkpjJTy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D023160A2605;
	Wed, 18 Nov 2026 23:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkpjJTy/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF01B1F000C4;
	Wed, 18 Nov 2026 23:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043826;
	bh=fn2+z07HmsgQzqfR7QECMWfbdzSjVmV0UuyQIBr+BhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkpjJTy/2Q+T4XoJ5eL44rsTtGZeDSMv1G6hC1U/Bo6Sp3F7SrUWYUar7qMIfB3Uc
	 Qt/5jx8PDWp+IgW3uzj0Qj6gCiJYy6QR9AeVdrZ6w6lUiXMY7XNMpW/wU+Vr+J1ICX
	 kOGW0kzew44/QufIWKYKd4um0Z+fPWQStNmFgRzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0322/2857] sctp: auth: discard auth_chunk when skb_clone fails
Date: Wed, 18 Nov 2026 15:22:36 +0100
Message-ID: <20261118150213.038741470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit 9ae7ed101cf28613071ebfbc42668c8917a670cf ]

When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
due to memory pressure, chunk->auth_chunk is NULL. The original
code still sets chunk->auth = 1 and continues, leaving the
COOKIE-ECHO to be processed without a valid auth_chunk for
deferred verification.

Discard the AUTH chunk early via pdiscard when skb_clone() fails,
so that the receive loop can continue processing remaining chunks
in the inqueue instead of stalling the entire packet.

Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260723061107.384106-1-l1138897701@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c   | 4 ++++
 net/sctp/endpointola.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a957142672cb2..5149f744eaf21 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1029,6 +1029,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 							      GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index efffde7f2328e..2313ea9fbe065 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -362,6 +362,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 								GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
-- 
2.53.0



