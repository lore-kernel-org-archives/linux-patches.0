Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043754;
	b=WUb3efckJ6JcOqGJqJm0PrbR5HTYnsanxXGUdaWYtd0ogTGs83yxotodKWs1ltLoXfhn
	 TwUP539X+Fkkc7VkSwodw0ELP4pA0YKnS+b+5QnneCbzqMrmVw/vRg/dUapk8cjVXQitC
	 xcaxX+5tVEtdOCb+cV05au0rUqBMN2exVESOJw3PYjaaClzCLzNGISnHrUr6dPzOVy9Ls
	 fnzDfn1UvjEO8zJHvnITQUSP5NFsaUzBMD0ED8ASbivN9CGh/bAFv59AO5x4gpAytF5Tz
	 k1FyxK8fq9voEDx0X/y6yYpqqoh7L1UOy/VcBGguJ35j+SU6Nxs9WKIPJ8e52+mZ/IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6UOI+VtTHQhacEu30mUXsnWPl41kFu7PmBAxGlgOtiI=;
	b=PKuL/tkwZxdl9xmyTIziInQJlOJz/2yskOgVKz9rRLtyEqc191EAxV1VhzaznFllSpIY
	 SKnq8LKIQuvtdy5/gykwqXCzVM+RRvwe5TYW+KcviUw1xNZQp5+/uQlYKg71ldzu2JK2j
	 mJOZ5AtmIHpsLo+IyGKwpwX4ylcKz02jG8R1ufYbnN+7EB2RaJ7IB55oqc96RgLSi+6Rb
	 Qc2MKhTzNgKU8YlM0lH7Spc59MDoSYHl111pbBPbIp1NuYi9M8L2O4X98psktjSOFOG6I
	 g8hyOQWir790rozhPPc0vXCV+JrArAj15wJ4lT+VQ6swLOA9ktKtD9bsgDoDio4Yc8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zti6MEWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857B606A32A;
	Wed, 18 Nov 2026 23:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zti6MEWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3761F000C4;
	Wed, 18 Nov 2026 23:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043754;
	bh=6UOI+VtTHQhacEu30mUXsnWPl41kFu7PmBAxGlgOtiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zti6MEWc31SrhpU7dDYFxgLtixFH+O5XOiaIb1I+DPhFMyw2wU5ObrN+7xKboQjsq
	 ekXDuYmq/IewBGEUJrugEvcD9hZfNqvIDZvv3V6GHM3YGfWeosn0gk9qPcszA4i0N4
	 lidTV9udHjKgY6HBNtTZRXPbqVYtKuZAt8BXkFB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0282/2857] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Wed, 18 Nov 2026 15:21:56 +0100
Message-ID: <20261118150211.583048010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73e66a088e25e..9b51e84606040 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -138,7 +138,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 52f828bb5a83d..ead5d161464cb 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.53.0



