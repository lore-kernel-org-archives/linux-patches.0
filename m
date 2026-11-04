Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831038;
	b=ySE1Cdz5SuWii/72JgYnbfpWhQvOW51xdX31L/CeBOYjBgs9tiWa6OKtn5WTffrzqCg2
	 UxBD5gQKFDr6blBleBwaYHeCEBmzzVdxJVLStvIX++FySjQ3i0LvLXArh9XEolmThe6MJ
	 NBWhcb79jenlZHJWIZ4daZ5h3mQgXotwh8r1sE026fcuJOqnCqXNsajgf7yvD2Jpjs6sL
	 +52hgvHJH+P7V1csu8yMEick/OlyO0NAfxTLBHFbGY8nQCBSqXOXUf2dwlX0TTkwdBgbJ
	 SE6LwAMLlwR+bLIJd7h7MrPKTVBRosrUvJIond8SdYLH4OC7o1sojSxfMtuby9vZZ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDnyQdeddYEpMpkrhMGQkrjaFcIyflmFaZIRMQ7Q5x0=;
	b=Urtuudu/9cxSD/RJ2/0AR+0RZcSRSkM3DsVBzygCmfOgY6KeHMW6gnjgE/ALaFrMHSkA
	 h/N2Tw9U2SIRL1BIzGfCSdpTwXJoofcS1FKa6isEn86WjFVRwHUxxJh3KBEEZ/eFyTYYf
	 SAphV+QZ+/9k/SWSYfYo3bWgdW8LHaTh10U0US98BgdQoJWGJkUZ2hD0WKHRYQ6fdq6dz
	 raCt/vOP1CKuJdOfLpRCzqMtL7NqvJTH+l0GRQQ30rK9Dmq5SWe+CFUy3qWvk+XJB7QK+
	 s19RNZxsndIf60rjg0yLgkeI/OPzLSvu2dxuMsvAcbY8BSo1GpvNExnDyH0yd8OGtAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K8z/OAq5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA248606B385;
	Wed,  4 Nov 2026 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8z/OAq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420221F000C1;
	Wed,  4 Nov 2026 22:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831037;
	bh=xDnyQdeddYEpMpkrhMGQkrjaFcIyflmFaZIRMQ7Q5x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8z/OAq5slt32FwjvqvxLCiz1+2UVQJRM0XOWMuKmIY38AKK+g8VyEdBaQyP5NAp2
	 +p//EjTAaIFb3CJ2wKt5ixPhsC3d9R6K04G/0Wa/QAx8LUrVQMH0enr6CTbhn1arkE
	 CRGbaj5a3S9EqqwH8MM0t492OR8txguodCppYyxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0473/1005] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Wed,  4 Nov 2026 16:03:26 -0500
Message-ID: <20261104211057.255682510@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 1f0391aea883e99d402d0f77ba3530e4e879350d ]

Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
are already safely handled by returning a NULL socket pointer. This
prevents unnecessary system panics when panic_on_warn=1 is enabled in
production systems.

Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 041c3f37f237b..5eab7a2dc8ef2 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index b2f59ed9d7cc0..12ec36a6be2e1 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -136,7 +136,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.53.0



