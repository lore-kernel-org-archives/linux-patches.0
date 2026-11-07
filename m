Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061141;
	b=LZEbhi+Wmd5p+qXrnvDlRRKo4weOWMZTOd9Vo2tv23flxSCDQ8Cw6nf56627MtAVqoIZ
	 pG5oajECZC33K4ZV4tH5QQJbbQqGOSGDxDxvNQTrx/AKT/IKFgBIkwuHej//j64l5cuoc
	 5dhhqxJCkHA5sq4IKpT8DUFVb6qgluxuqu7EBQeEiHPLBEJtrlrj9LXtX29Gh/okSvXWF
	 mkoY8z772YPqqrvQF0RkcopM/Tf7pWe9XBUJZZIs1+MbXDJWrspxRQunucfWXj48flgnr
	 sNvQd0bx9IVnIzJDmIxHaKkBYSZz8Fncjj7wtuhyZF2RCiXaYpPzIWkGr0Hr8PWsIzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dldri0ByhDnLR9zOjtLLS7oUjhq+RB8NrLFugqH/Cd0=;
	b=GblunanXwlgjsvCvc/mMaqq0ziay3sZzBCTlzdlX24XVAQfYp+oLQJkThoT9qOX171e8
	 ll73bI1NV+fD8S0x1o9IKujGiYOZXTIpUZwMM38zjUnXAbyWd5+P7gwA+4ZeSR5SDzdqR
	 qZERu7g6hB8RnHjJ6ktUwkf64J15kRERY0hioHZIDhorITl5m1YTdOIibyAcOvII8SNs1
	 MeUk6G+cF31DZ+jkhU47KfaQfKToXWrqp/zcLwaSYct4Sb3Kl5sEvfgVBMqgmpTg32THC
	 ns+GE2+DtjCNWBpTdVgP2YW57TMGeDLqSJjY21biLD4OcPBAj+hEQ9SCkuo6CaFsBcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipeQWI+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E13A606A336;
	Sat,  7 Nov 2026 14:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipeQWI+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD9A1F0089F;
	Sat,  7 Nov 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061141;
	bh=Dldri0ByhDnLR9zOjtLLS7oUjhq+RB8NrLFugqH/Cd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipeQWI+L2ectjsbXdY9YtcsBNhWMFXn7xyLXcAYSAf505ftBEc/1jGbTpOCq5cPip
	 tJ9YFOQwE46BghiWxKJsXMjCjXXEOoR4xpl55cSF3s/hvm1FxJVXLbIsdgjdP9+ij+
	 3kMWaYkYykzmvSCvYpXt5Nd65vk6IG/gNNjwYKqk=
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
Subject: [PATCH 6.12 0449/1536] sctp: auth: discard auth_chunk when skb_clone fails
Date: Sat,  7 Nov 2026 08:41:05 -0500
Message-ID: <20261107135010.144585467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0a19aea3b5246..9f90cf8f95988 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1027,6 +1027,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
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
index 7e77b450697c0..ffb7e722c9eae 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -367,6 +367,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
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



