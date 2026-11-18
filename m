Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029447;
	b=0snfBfnh0NOZvjvC0KNdDwspGoIacx0fP0fSHTfC1cX96PV9n1/LENUsx+10yCWUDrCV
	 Q9rjiaFmIfjC1iUwr3n1r/ge+WkP2l5dM1HvC6ivi+tljpCwv++3t1A7URMGXVZaYYr2l
	 SbJp9fDhzA5G+49fzaYIr/ScihoUfp/SfZS7MFtf2VhAnMcKE0y3Iant08AzeEDxpTYDX
	 nfDh9LUiHlBMhD0+HqR4kl3KAD3PcRvuiELTSmWKi6YE+H4+SBPCBsfOMfjNZ9e+MXi8y
	 SWkUTsn32W8N2WkBwoplKQ6NONpPR97RzJ0KFZNdLBtmTHh/meb6S993fhliyYpi/kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eeln0DTei0td9zvGSlQeMIQ1EY0StvqZhoJESbfWSMI=;
	b=PvvKB5ojt8A7euLesTLAa8g5s1xjTh69EolmrkNONjjJNXaqFQuxBCaeWhXeoSdjDr1u
	 UOxGNWY0WG/g2u8WEBAEo+PSb7BUZaSKCz89DpGW3I5epLRLm47SPkssSzLix6C6E9wpI
	 Wy+c/8g+PyLZ+FP1ybuXPq00UadFFf/H0erha5EqO89FbVXjHGNhJZvbX3LoT14iipBEc
	 wRL2ZVheilDrjIhMjd8hBTpLqO+AF71vH4Yv9o+bVGWI78NgbA/WqrbAzCyOwWmeFLfjl
	 ZT3t9o1MHFks7eOFJjYXylr3onDlicK/nakRbaMhprq5+mW99Y4etREvOYKIm4rZPBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="roPoV/Jv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269DA606A325;
	Wed, 18 Nov 2026 19:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roPoV/Jv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755E31F000C4;
	Wed, 18 Nov 2026 19:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029447;
	bh=Eeln0DTei0td9zvGSlQeMIQ1EY0StvqZhoJESbfWSMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roPoV/Jvz8MT6V4b7mD5tGXt0+XJOjVRcEG7jk7wq5EEalHZttGVxaliCAfv3umo1
	 N5JCMx4aLGe533sBjoG83paEx505E1a4mVtjtIvn6OX6TnJ9tRVhq9uOZRI3pLaBq7
	 Tvq/LkkDn3frLErBIO1E85aTPEHO5LWecu+vzIDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0352/1756] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118150022.369208610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ed7bcd70f0c84..978fd583428ea 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -490,19 +490,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
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



