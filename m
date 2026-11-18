Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057825;
	b=edbzzTiYsLWCtrX4yl7OuAainwBk7Y1aJss6iF0/jM4y8ZVAKVtYpRE8jAZMO8dUZue6
	 0Va7Zmuz2hLM3kNV/QMpMSR8xCEZLX+uDi7+GCY/F1UiBgGd5pEde0ZZ0h+X/U1x3tGpW
	 nw/RLPdG7P5jZ8YGpgEh9wavGCJpB1Kpra13BPKPKxMgsD5Szv2RzLQrEXlKWH2YFAGdD
	 1UnByeXHBk8WmcuqDYOkPcRPCffADp4RevoR4q8OEZKtCTGfJ8gKsQq25EBwAhsYkAiAB
	 N9wj4yZTHyzAD1/wthKkpOXD/4E8vQ80gl/F5HLPIEU1IWnGix6tITNV8ompoX/uBAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKcOc2qsCVyIEtuuYqtedCOX2fz20C9wRhjHyUMvTC8=;
	b=u/Pri1SJe9bKTlHJaMSjLpMvjB7T2n7kbV8/scRjQvuXSB9pRq+5DstQchPP/dUveiYu
	 8ieZmCxvrqHEA1dcDWUMzkZHFMO9/D1LE5RCuq20NZN4oDjYTC3QkvAtsDsO7O6TxTgw/
	 tK/tDDfGO/lzQsGz5uhcH+IKNQHaWZ8ATr0Ievk4ekEw3mpzc4V91UNgKzMauYcQXeuW3
	 VMXwfqxx+Pw7g9ESOuTQ8kqQCGFYah+e0vIAalg3t4u5zVz7gRd4A40pWsP0ERDujGnWs
	 RZu6fhAnsqufFBq+bvS+iRGginfynJbNKt4hqe4umRNDFR9ElQuCUU3Oz3TrNs3mPoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1DtEpJ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED441606A31C;
	Thu, 19 Nov 2026 03:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b1DtEpJ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0EB1F000C8;
	Thu, 19 Nov 2026 03:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057824;
	bh=cKcOc2qsCVyIEtuuYqtedCOX2fz20C9wRhjHyUMvTC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1DtEpJ08GkK7ipHV6QbdxJ5tAfl779RqgI91WRlKZ3TVi52+P0EwAinqBDtRv1Mh
	 CeOg+T3+QeZ5r8XISfJKm/KYw4Ax+ZVfsLwNQCirJ5xwEhktX9MAuubxk77U98VihE
	 PIS3w+QJpFIe9jQuUE6PGD8XoHpq56QnaPS1sjY4=
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
Subject: [PATCH 5.10 0226/1848] sctp: auth: discard auth_chunk when skb_clone fails
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118145921.424570737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ad1a7368f6ab0..13a3cb5c95ae0 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1019,6 +1019,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
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



