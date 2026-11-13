Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585403;
	b=xnNH8uNso2Yf9wC3Wj/QUAIHUg2GwsEvtEgr/WggPIN6GsjEtHM1K/kafegyxvnixown
	 YmrbPQ/raQQqVUtedIEQok1IYBAbseKXV5j12KJcBgexNkjCddk/WGoaEqklEhTgA/qQe
	 LV5M+OY24XwOnodtsOXs417CPrZfY1/I1m27L2BnXWwsD6xsWA9R8MNFAkO+L8Nc3uaBq
	 L89GUEQZVDnR2a+Yn+FRf/rAJAAq8fDW2gfMCjPOLpRaD2fVGNjoXDFN3tC2Yweb4UIYX
	 4DW6NiyrxT0qqjOeDhKfYQfF1e79vl6Q3vbmQ2jjdVFEuAY/M52DiUM0F+ErFIN1MTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d4J4pdMPbHeZN8zWvVJJBh+88LmalqX9VMktCExGoVk=;
	b=dtfZJU3erZFxP3fj4TjrUvMRawjV7N5wgZaUDz5nUZ0Rwpgbl531ISWTvR6WZK6X1MVC
	 NJ99bR+k25VB//fT6EkklumJmOk4MvqbeyoOkq+h8hDQMG92j12VVlws2NJqZsmF5HU5W
	 Ky5LuVSbfhJRSGqt9RaJW26T2cgNnxRqRxajGAAP29ROo/X8BLWB5mtoKmnQGCRli11I3
	 GQydNQXMB/1G032tfPwXfNYfPM/grcpr2133OQySb2AbUkSmXwx8xCF5nmUk4Kb9bkP7G
	 mBu31Gym76PccWznOHNzMG8GAqh8miKNG2ddjVGMvtoVtMn+W85LLvHKr+Jvb2YrOKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NzXaQCD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC1E6070FF1;
	Fri, 13 Nov 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzXaQCD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395031F000D0;
	Fri, 13 Nov 2026 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585403;
	bh=d4J4pdMPbHeZN8zWvVJJBh+88LmalqX9VMktCExGoVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzXaQCD/enmhG1HBUO5bqx32xzswS6KLISQepaOwYrqCNCi4xppT7pBjcajOUas1z
	 +6hjq+b/3k6DpJFQ4K6+bkPP0UBdFK1LNOQRl56Kzwc2e/NOr36vmrN6utHeNlbr+O
	 lIR8HtGFP4zCXTIlKrG4JMEDvw6ZZoA9tQNaBdhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Fourie Zhang <fouriezhang@tencent.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 072/507] xfrm4: use a full socket for local errors
Date: Fri, 13 Nov 2026 10:46:16 -0500
Message-ID: <20261113153756.013214002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Fourie Zhang <fouriezhang@tencent.com>

[ Upstream commit 5def91015ba7b59de62a81384572da7281b8a033 ]

xfrm4_local_error() passes skb->sk to inet_sk() and ip_local_error()
without ensuring it points to a full socket. TCP SYN-ACK skbs can be owned
by TCP_NEW_SYN_RECV request sockets.

xfrm4_tunnel_check_size() already checks sk_fullsock() since commit
1620c88887b1 ("xfrm: Fix the usage of skb->sk"), so iptfs_is_too_big() is
the only remaining IPv4 caller passing a request socket here: the sk it
tests is the listener, while skb->sk is the request socket.

When IP-TFS rejects such an skb because it exceeds its payload MTU, the
local error path treats the request socket as a struct inet_sock. KASAN
reports a slab-out-of-bounds read in ip_local_error() beyond the
request_sock_TCP allocation.

Resolve the skb owner with skb_to_full_sk() before accessing inet_sock
state or reporting the error. This maps a request socket to its listener
and rejects sockets that cannot be used as full sockets, matching what
commit 6973a21ee73c ("ipv6: xfrm: use full sockets in local error paths")
did for xfrm6_local_error().

Fixes: 0e4fbf013fa5 ("xfrm: iptfs: add user packet (tunnel ingress) handling")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260908224856.1591189-1-kuba@kernel.org/
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Assisted-by: tencentos-corvus-ai:hy4-preview
Signed-off-by: Fourie Zhang <fouriezhang@tencent.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_output.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 0ae67d537499a..fffa3c4f456ee 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -38,9 +38,12 @@ int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 void xfrm4_local_error(struct sk_buff *skb, u32 mtu)
 {
+	struct sock *sk = skb_to_full_sk(skb);
 	struct iphdr *hdr;
 
+	if (!sk)
+		return;
+
 	hdr = skb->encapsulation ? inner_ip_hdr(skb) : ip_hdr(skb);
-	ip_local_error(skb->sk, EMSGSIZE, hdr->daddr,
-		       inet_sk(skb->sk)->inet_dport, mtu);
+	ip_local_error(sk, EMSGSIZE, hdr->daddr, inet_sk(sk)->inet_dport, mtu);
 }
-- 
2.53.0



