Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215896;
	b=I7F/o6pRBcJdEBbY4uEgn6mjYj5tgrhoRPjY/iQ/AHBl59qwfVJ9zEsiVb+7M8I/D4nr
	 PDJzuoDmJXeQ8xqEiPPfsm1pHiCNb3+ghrnRy/rB8rsESVFwh004kkbWW9Kg1GvcuUFNe
	 DKbXabf2/tfhHnNcd97Ik+IRJG2GIb1/8oktXvDt1fTGBD0piplyyPNWyahWgUwTkvsbR
	 vqUBTcvofU8WMNdYRlM29wihaSa0a40YZD/d0EFQL74IKamdRnuAgQzhi+3MVwWVd0uXV
	 pPNXLnHuyJlf7DIDNd2F4h9ru4Zy34ePURO5zizXy4gGhFzIXqM1Rf+iLU+ZTv04X7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RybddAd3TFxdeIJ7Kuk1vTKAC/yLJUjK6JBmsuSxL3E=;
	b=ibDEfzu4EWYHQsGHk0mNcHhsCw3mLIjasZ9Nvhnb41p6Tydc6x545etX4oNa/BzxTYXz
	 D1zhRvKr4k5ObzZ6YoO9p1yH6YufqSFoagLLERMCJd/BKmKY2n618pl/rutspt4lWl1RO
	 TMcZnrI5I/jPGOt9HDoLUKxgj0eaQ2VmLyxOxMVKe8H6QfjZ7RsK/8XdGMtvVFUyV4Zn9
	 odi2KwOJ8ieFuFYJ+/swT59Nx8xUNfcEfLH8itI5aw75OLVQPOuYs5hCMqOGmTnzz3UkI
	 d12W98xVEhtDl+YkQDD/wPi8NJs1UO20ZS+UescqTiDoNA2DsjBF0Plj9U113dU6nTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F2jsSZ/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A738606A31F;
	Wed, 28 Oct 2026 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2jsSZ/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBD11F01825;
	Wed, 28 Oct 2026 19:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215896;
	bh=RybddAd3TFxdeIJ7Kuk1vTKAC/yLJUjK6JBmsuSxL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2jsSZ/pxaKWQeSwcEpmMA682YJ0B5z2yniNiMI/sdT2u0/uKVDbEKyzLPyfPQ1NG
	 s2lzr9oS+Ns/ELyd5qr91YDrQQYQQxgTYYOhK8JTI/RnuTQ0jJz0rn+V4X2R8JkOx1
	 YkUeT2Ruvmot7jO6TJyidYb6yyjwIUTA4V5KE2bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1326/1887] netfilter: synproxy: adjust duplicate timestamp options
Date: Wed, 28 Oct 2026 17:57:02 +0100
Message-ID: <20261028170529.604478536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 22bb132cfb9b94847d52d73614284b8c5ea8d36e ]

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 992c20bc8a4a ("netfilter: synproxy: fix unaligned memory access in timestamp adjustment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index fb071401d5c33..52f1f30f95add 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -232,7 +232,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



