Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039629;
	b=pcARChx7U9pMrVWfXTlyQS/raASsw7hmVH29bbMgiz+BSOn7rc6Q8U+UZ1Lhq1+1vQsN
	 H1mhWwQilNNdDBGPWcdSWUxRG/biFhTGI6gjlszo2fdyq1t3aXjXqxxonhUSdGxLUx+H3
	 i3yLxRVqYZAi+Qyvd+360whgfROUdHmqKysZNyEMZQIyLaTPAQ0PGkj/DiwbckURp3W3G
	 VE4Lp6kUlvMVAAK9DwI23XC8X0wUJ7KMXDTN2gjSx7v78Du6uABXrVqU0i+dNHgEbk3pu
	 Z0d2Uh+Dxo9m9wGDKYkAaKc7fplXg8C7uzbuSF/p/ka9DftGKde1s8421P6Sm8QeFzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cTKP+e6Y3qdQJvc48HES1j4Xk9zTlb3FT1z/CRGFC9g=;
	b=X3DJ7slEXxWCOfr+RW9S9el8uFD/2j9L9PhH5/x66GW0TaG72LqlwugjuCeVzBwQAXM8
	 LHq0RcRHP21SZ+oBqNx3BiZxbSD/D2CF7KHbLj/0hviFZ0yhJ6rHZUoC75MTWPQuNU6ik
	 8U/X1h5GZIgWuvMAPSuNenYuKSeHnnbBYBSgN8HGmAkG0oq0mH+skv3UEzj/ZwaBrWn3t
	 YYxMYxLAI/niMezLfxNDLMkfSfRapBxAeQWlGFxp9BYf/kkJvkZlTh9/yukBUfAacauC3
	 OVuwgfJTjkBa0QKfIY3EWNllTpnoCzHECBIsfR5QKIlfMemhcYYAcS/iZ2xmUt/H7Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdgXLhIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0BA606A320;
	Wed, 18 Nov 2026 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdgXLhIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFD21F000C4;
	Wed, 18 Nov 2026 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039629;
	bh=cTKP+e6Y3qdQJvc48HES1j4Xk9zTlb3FT1z/CRGFC9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdgXLhIUpTHMKGNGgAYciZflrC+9kv7g0ZNUccc3+zpkAhGVTzlgpfs52Yo9v/CMB
	 bjMRrRHVpOBAsJlVeh/67RjRuE1Q2tnNddg7WI+DQqpmowK+D4lPzgHx08OVHKzVv/
	 14oeZ/HTd35ivTXGc9Bp4L6mh+uLFYQpgmHwJmto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2168/3318] ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
Date: Wed, 18 Nov 2026 15:46:30 +0100
Message-ID: <20261118150427.035579020@linuxfoundation.org>
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
index d250ed84f32b4..77376d0241232 100644
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



