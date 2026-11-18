Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034457;
	b=HZdWM6AicrmgbWasuIDEGVxtgoIhUcFPY7Dylu/mp81Pm2TjnSRGVJHnPbpKeXDLwMSn
	 LCzbBRfXvyyz4YcoOqrLB3mpaNdC+7mYJw5hrBGbHyu4/66u8XBIDK03tIQ/08AepqKHj
	 PiegbkQEUBePEv3J+OkPAws8Z0lFTv/ijPlcfSs6/hKUSeGg+NuHJhWdC6TOVnE94A08F
	 V9FOsMoqiBUcGsBxThNInr2RxoCbmuxGyULA+P+ZKw+d89t+7yusWODhvzNPRVAqE2qWx
	 LESLWxuWLR7ZMZumPU8NzYFiBSSLeMBGOSZWzlIe4gXawOSMMaK6WyuP6vhPErklx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7GqgDXTol3EVVL1/T9meISdUhEDDG93NQSBBPvQGuw=;
	b=HLVyEcwPPT0qlQcvnQOJDQvcZyuFQL6ltAg7/+SAlWzni2rSp2UhBKAwCOyhA9hmVX1O
	 myy9j8ZQEBnIT8RxuNqSEnEgdE2/EfOjfpJ8WpA0plC2V5bw49VdhfvKSgmflRc95/v8X
	 D71gxoK/mfFXy4fgxbDOWKk3FOsW4JzcEdaH3nuSyG4xNDNbFxSUqK7f/djT88OsTWTob
	 smE6VvpDJ1xB1KhNvQaehepW0dbtwSJ0yOJGbPTvpQ38qw5A6LVaEu7oBvl6f77T3MKIa
	 n0pY5FfigG2I3IlYdxBaYdL7djIFB7NOgBbGSv/LFfLCgzHvA0XQ3rGfZw6lBWD+eRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J2vpi3zz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A922606A31C;
	Wed, 18 Nov 2026 20:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J2vpi3zz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F2B1F000C4;
	Wed, 18 Nov 2026 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034456;
	bh=q7GqgDXTol3EVVL1/T9meISdUhEDDG93NQSBBPvQGuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2vpi3zzacB+eRgpRypiGI1ifnwAmK4hJYHHN4GG5Sdj5uE9/Q4ZIe3vmDla2kzbe
	 JHU2OpUklmEVf2uW4Yrmc3sxgn7+yJEagPEkOk0fH3zJOHdpZHRgjA19/Tf+4MNNx/
	 6cjfIyq8fnyf3HOaHS+vkV9AAWvEs+2bBGGP6Dbw=
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
Subject: [PATCH 6.6 0374/3318] sctp: auth: discard auth_chunk when skb_clone fails
Date: Wed, 18 Nov 2026 15:16:36 +0100
Message-ID: <20261118150327.441861283@linuxfoundation.org>
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



