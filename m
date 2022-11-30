Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A1C43150;
	Wed, 30 Nov 2022 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834102;
	bh=Vl+l30PNm7DGAvMfDdo/f6LIv20ZQSLQ2bzBnUgKRR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2veLknRwZbIWOw7c5fmjA6NeGhNvj/LHh3x/DgeZ5defuP7JL52JD/vuSFpyjEYD
	 oHbQhBxemtstE8Xw+OgwJokhxDWGaCSdhO3RD80v6C2kocLzZ0gR0KbJergcdl+F9y
	 FJTOVCxUtUiYjTQ0Vi2PRpY/ZkbSCUdgHYSRHTsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 129/289] netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface
Date: Wed, 30 Nov 2022 19:21:54 +0100
Message-Id: <20221130180547.064477700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 6a66ce44a51bdfc47721f0c591137df2d4b21247 ]

The commit 510841da1fcc ("netfilter: ipset: enforce documented limit to
prevent allocating huge memory") was too strict and prevented to add up to
64 clashing elements to a hash:net,iface type of set. This patch fixes the
issue and now the type behaves as documented.

Fixes: 510841da1fcc ("netfilter: ipset: enforce documented limit to prevent allocating huge memory")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 3adc291d9ce1..7499192af586 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -916,7 +916,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
-		else if (h->bucketsize < multi)
+		else if (h->bucketsize <= multi)
 			h->bucketsize += AHASH_INIT_SIZE;
 #endif
 		if (n->size >= AHASH_MAX(h)) {
-- 
2.35.1



