Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054990;
	b=Y15QeJy0i0g3iWAkZxPKiUyjtaTA4T7hPZvuLOk7Oo3wSDyS38K01SdzNJUE6auxI2O1
	 8OcZcqms+MsQCnAWXQuH0lSUmgTKqKNetuc6EX9NddLl5QyWikiSg5eamT1eSoSt3OsmF
	 GplXrj8bj2f2V6+CC7yWWm2LBxEsPoxoJQFIdQZhLc2pWEGp9lhN7ZNHrKgO5BL50Frxk
	 xPFZBIXhMQXl9GL+mQH5rxjDWVAqiiLewQeLMAWhcASOrjchhYKV40Xj7G9dAhHmyhpq5
	 ttZnXLRG+L+WEMco/6OEBZxgNv6wZdQRx4D6jlsrZl2f4nwwSih1iLzei9iwk5WoXww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZGTn17PBqFLJO074SphLjhVvNvs3tEDQzB4NTh0O6k=;
	b=xeWaFmEis6/Cak2l2RvChTP316ietkur+XR4NlLWfPJMaYBT28ZOo51SKbEr2L/UZf7h
	 9kARaechSLAoDcfSyB8smhB6MVPwOBObao9bElzZKV+kGdUsQRI7cbuJi5mq9tqJ+xxp3
	 mgqHV+5CquvT/T3PdadvbtbXm8kFMAoZZC/4RpCf47tKVDKaaIAcmKGeYlONVI/N0FYDK
	 8qxpLxBFxC+w6+EX5Zde6SUDdN2SuE1VYLD4FR+lrT5Ru8z5CaTCUKC56yl7zTwaZaiAU
	 3P8WGKMfucnjoqUsnZaS7wD4ODSsLMnepYdcea5XhHVWlSjrLZHNbjCbC6luc1FAgIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQTyte+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05798606A331;
	Thu, 19 Nov 2026 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQTyte+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A271F000C4;
	Thu, 19 Nov 2026 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054989;
	bh=uZGTn17PBqFLJO074SphLjhVvNvs3tEDQzB4NTh0O6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQTyte+9RrWm5A6MAvLaNLHfvKB3En5ZOVR4IdslquF6cnwfAMCTYm48I21SiwQQh
	 Iynwm7SgKxCNU0RQGrbXzYnk3N8OvSYQZOv7PCvLoAYl4fdLt/9vKsR/BFA5VCmItQ
	 ugT6HiIqzjCzWlFFjOIqZUHOHK9OoGOl041fIBUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1472/2214] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:52:28 +0100
Message-ID: <20261118150110.063828291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 88b84cae6b94087d3a9679845fe28ad19c7bef8b ]

Update ip_tunnel_encap_setup() to use WRITE_ONCE() when writing
to encap fields (type, sport, dport, flags) and hlen fields.
This ensures that concurrent lockless readers (like fill_info)
do not see torn writes.

Also remove the unsafe memset() on t->encap which could cause
concurrent readers to transiently see zeroed fields.
Removing it also fixes a bug where t->encap was left cleared
even if ip_encap_hlen() failed, resulting in partial configuration.

Fixes: 56328486539d ("net: Changes to ip_tunnel to support foo-over-udp encapsulation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260907075846.2913645-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index cbc3f8bdf0cb4..62fdfdbec7845 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -476,19 +476,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
 {
 	int hlen;
 
-	memset(&t->encap, 0, sizeof(t->encap));
-
 	hlen = ip_encap_hlen(ipencap);
 	if (hlen < 0)
 		return hlen;
 
-	t->encap.type = ipencap->type;
-	t->encap.sport = ipencap->sport;
-	t->encap.dport = ipencap->dport;
-	t->encap.flags = ipencap->flags;
+	WRITE_ONCE(t->encap.type, ipencap->type);
+	WRITE_ONCE(t->encap.sport, ipencap->sport);
+	WRITE_ONCE(t->encap.dport, ipencap->dport);
+	WRITE_ONCE(t->encap.flags, ipencap->flags);
 
-	t->encap_hlen = hlen;
-	t->hlen = t->encap_hlen + t->tun_hlen;
+	WRITE_ONCE(t->encap_hlen, hlen);
+	WRITE_ONCE(t->hlen, hlen + t->tun_hlen);
 
 	return 0;
 }
-- 
2.53.0



