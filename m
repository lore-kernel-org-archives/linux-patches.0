Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619259;
	b=nSBKu/Z/mJ64pXEHDX/R7jICjSIUoQdtJYdiHVkLc5+s5UK1bVnlC0Ld4ck3aMGRQdz1
	 bU/bHPgHeBHCQqZswVSNAYTXVBSoEl0lryr3X6xyDJ/7h53sECslq86/9yS5pHFkI27P3
	 YwqSGE4SV1ZmiYsw9QLF+UUj79rp24wC7VEMfhta9VGnD7mHsBaKPZR5+zaSMpAGGsyDN
	 CtMiG689LDo17hRDSFIMBy2xEQzmE79Ro98SAp6cMQiOt+aV6ohcUNbfiNd+5xNnniVOw
	 tUc0w0RiD+kIXaJoYWAQXCCU3OLMaNi/fZ033JXqIWMk5u9g1IwTWBebNDI/qR+Ccxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5kbHWpocIk9Ezu5/G37x39ZmEMEC2TPoDCItXYJIRE=;
	b=PFsYXBuJ3qjzHWnYNouUOcUMbgu/cBQoN4p36Du26Y+h7V9pZwDXTwcXWFFQNBrRC4qq
	 db5bmo836I2tbBDsXwm41npRBgMctWXNHPMHb9abkD4Vndo7yilRFSQb/sivDXnUBXFVt
	 udad3fMxOvEO8uYb4HbQDM3Bd0pFnCY8oJ7J1I3iR+nSiuYHrJgmop5TFVsARCEcW7YT3
	 QG6e2blAz832Kxc0LlooXolI6DHrCX33cmBWfiaytIaR8dFx2P42euHHXANzZJ/2qBi2Z
	 LL8z+vxuW8mMFcX/ckvQxIbcR+QGhILKG9YDkksRsyxSmg35UjtYFc8LFV2P6HMvTMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvKuPflB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BB6606A326;
	Wed, 25 Nov 2026 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvKuPflB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E57B1F00AD3;
	Wed, 25 Nov 2026 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619259;
	bh=q5kbHWpocIk9Ezu5/G37x39ZmEMEC2TPoDCItXYJIRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvKuPflBK0q4PcG7cWyXExLWcinuc6Ycug3GZjtfMd88IoFPW3IyRDb3hPW6ywIMw
	 Qv5alZfy7yv4YsUpaXOo+0HmcurJ2OwFKWq4wuRH/dRnjiYHGf4DDHzkmWKbk8topm
	 haq5bMsudFQUibzVVdxyShTw5NtkggI9ROiV10g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0539/1005] udp_tunnel: dont treat IPv4 sockets bound to an address as wildcard
Date: Wed, 25 Nov 2026 15:31:17 +0100
Message-ID: <20261125143834.371855287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@mandelbit.com>

[ Upstream commit 612b8376e8112a6f9caaedc25fa48ac42e02826d ]

With IPv6 enabled, sk_saddr_any() checks sk_v6_rcv_saddr also for
AF_INET sockets, where it is always zero. An IPv4 tunnel socket bound to
a specific address (e.g. fou or geneve with "local") ends up in the GRO
lookup fast path, although another socket may bind the same port on a
different address: GRO then hands that socket's packets to the tunnel's
gro_receive.

Check the IPv6 address only for AF_INET6 sockets.

Fixes: a36283e2b683 ("udp_tunnel: create a fastpath GRO lookup.")
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261110113306.3698438-1-antonio@mandelbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index a128fe85620d3..29581c94fdcf8 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -62,10 +62,10 @@ EXPORT_SYMBOL(udp_sock_create4);
 static bool sk_saddr_any(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return ipv6_addr_any(&sk->sk_v6_rcv_saddr);
-#else
-	return !sk->sk_rcv_saddr;
+	if (sk->sk_family == AF_INET6)
+		return ipv6_addr_any(&sk->sk_v6_rcv_saddr);
 #endif
+	return !sk->sk_rcv_saddr;
 }
 
 void setup_udp_tunnel_sock(struct net *net, struct sock *sk,
-- 
2.53.0



