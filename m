Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831171;
	b=G/n+Abd5vpq7swnmteqwjL8kG9RYWtTo0pJLoM1jjH3DfOvD9cwHEVuSI9HFc/aMOXIj
	 sS+h/H8Q/DCghobP2ADUCgPtRaHiehpNxrRGouvMmPmjI5D5lCuRcDDFsxMEOckqG4YPE
	 iwjv4PtTC+yVFjQxB3lELN8MzQD0DNJ/9txR3rgaeaXfze3V+mkApNfu8sy0krXXSKUPR
	 DtBfXnv6yLKaHbbBQoGFQCa/zMsxiROTLKxbYl/yxxiUJKTSCVm1deoOpZnXEedqDymqg
	 0HsrkZr8y9g8dWdqDxpThmGA8MughVks5FEQdRbRiKKBw3KIr6Xu5XI6UXntZ1bb2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G/URIuRhAUje1UGwigQkqqpW98WzBGN+hUkpvlLvGOU=;
	b=w079zU9lIMYbODsB6dpyFcElXddrAGtsmg7+hU8OeQgNUhYKLX6fXI8e+6fU7WLqKt2c
	 TREF+lgCemNsLjaaHXlu5oG2iaKU9W8OOVwNBNklQbI5DQQ1CidV2U/ZVV6Gf95iBL02E
	 MsJfE9Dc2wEAatCcoZjs9Zxbz9gPCOpkBMoEYC6zk5dTlAf0BmgyXNzKuvH5omRudkZYF
	 diVWdD8QG9tgb1UH/8yC81pPXvIcpdF/X9g3sx9jg0ErDIMl8WjRdz1ARrgkW/j/B4Ewo
	 ySKyLD7V7HTxihWyvEqtXjd+TDx1RYQiL5j/MNioJz3eeDUUqer+akZW2JM/y25uC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0bbqaEv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF5F606A33C;
	Wed,  4 Nov 2026 22:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0bbqaEv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9201F00919;
	Wed,  4 Nov 2026 22:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831171;
	bh=G/URIuRhAUje1UGwigQkqqpW98WzBGN+hUkpvlLvGOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0bbqaEvdkPF96BN1dKihL30/x75hAU6zoGLV/oiJDVlql64zNkGJBTNu5oLDF06y
	 wGZIHg4vgIxYkmDQV8WhoWI4rDwFP4vlOq3CeAn0FkE7xvaVRrOizhcHFPURWLxVdf
	 xaGLOPyMhIOrYr8GIro42QG2FPlL2WgAdlGyuWek=
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
Subject: [PATCH 6.18 0540/1005] sctp: auth: discard auth_chunk when skb_clone fails
Date: Wed,  4 Nov 2026 16:04:33 -0500
Message-ID: <20261104211059.018327555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ca55be94e8d4d..db339618ba55f 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1009,6 +1009,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
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
index 31e989dfe8466..be2e2bb2c1173 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -368,6 +368,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
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



