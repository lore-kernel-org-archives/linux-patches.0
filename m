Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016162;
	b=q9bMqxa+P3sElJG1RulI8a8eMLEsDzoeRzdFz/A7IQIQ7qhNXqh5sw0OMsxYkZwvw+kS
	 8dZ8asHMcoKQ1556EZD1pS9AFut5GHzskUzSV/JuTKsc43hbYPK054xQGNnBSvscnsd3W
	 jI4QSfvhZhpWcfFLMyfKlBiTp0yp9mojWqcBnQFjfC+dSn6+8hd0xAxAiS5c4uy/M39nj
	 /lKlhPaqUsSn+UHFfxhVqZnvaEoXlxBFmBZ27TJocNyfaEZ7/49uW6tjjug0fzl0TgcDV
	 2O7+tfRRfcrZ3o1NAYpC1gxCBFYzWDfbYnVBNpd8yTtb7BHedm8H+yciPv3zXXaPv2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3M9T2sT1Q5gsOkxyA8WaYCFJ6FaEksl4oTU1ZxSvSwQ=;
	b=w131Yq2ZWapwGmMhw6pdY2oCryGFyuG+5bko6ACOZiLHx0diuZsKThl1vrc5FlPm4N73
	 orFNSu1OSipJ106vWa/OhnfWRZR53ifkP4e73ghq0TMa83X3e2W3hqJFYBu2hh5L7l3Rh
	 Y8sv/XmYCznK/PMR+s/QwODf7PNhjOmciJ/gzn6gBCYKtoYW4vLqa3Pgl0VIkAmigFane
	 e+ms6YXm6jiGgjxRoBAL9lw3I2MQVZwY7ZBAd5AQbkvaE0iv7w1t+VkUWztzIk95GhX8y
	 wD0AyxEMoYFaNMwrac3ODSYyUROQNaxA1p+liNIHph65SKJoS5yQm5YUzqo+w45Cj7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erGjbwBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B89A606A31C;
	Wed, 18 Nov 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=erGjbwBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12D41F000C4;
	Wed, 18 Nov 2026 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016162;
	bh=3M9T2sT1Q5gsOkxyA8WaYCFJ6FaEksl4oTU1ZxSvSwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erGjbwBIOD4Ibxs7J87TWh1rJ6j1H+YCs3uqaEP6UN60HIK/W272bV6vVFSDjcmIZ
	 ZJ71qb3ZLRckIzDqT9EQpEV7WaNPeKjr41TE6VLZ9ENO8AyOytS9yHRQY0FFKfENGU
	 iyi9lmGSTEUqIzqy6fjARHO2bL0bu2mPjU7ohwOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0389/2651] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:27:09 +0100
Message-ID: <20261118150301.835088169@linuxfoundation.org>
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
index e6bcf01411d0b..13b5e35e8790b 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -491,19 +491,17 @@ int ip_tunnel_encap_setup(struct ip_tunnel *t,
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



