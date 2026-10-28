Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210913;
	b=Qp6dvrxLiUjDHg2XNAx1rfsqndxqzBBrrB4bwXExFNaNQQRNLfOJRpgFWH6uYTwK/MV6
	 W5PtYypn/2ElCWNb63SlhenRb6410Q0fsF89xCCA71rGVNVwaauTc4BnJMHIiOaaEI1gR
	 BgWvtc1964W0IaxcavRU4rBtASA/JrDGfV1kS2F7qlQmfqj57h6v67yFUYSqr189SpmRU
	 mRJJxYX6JroP7tNOgxREi0Va4jEF3yT4YH+gDB71ejHLnQD02C6h26eYDnQ/mrAwVhf7E
	 FshjC/IyCbT4X1HDOzsZrQXw+A1eNKOmASNkYPe7c2MuV+DV/BmNsCV0pZbwpjyfW/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+E64/F0Gy+LDuXAowuHNuML0EJaH6N7f19oaCRa98Pk=;
	b=pL6ISFXNhx+QcrJ6OqP+Emvlt6husgMnVYzzqEglhYkhS+5AiBNLt3VEeaXhRxnLmkiV
	 7k5/ohQsGQlXEy6vbn16j9Jzj9PizDFza2HFQ3x87xOjGMfXWjy+Z+ykfI9mjG66Pqss2
	 bTu10OgiBcRsxVv56i3FToe/V7Ozi0LyL2trjqIGZC5yhE17Vrdyy+4lGIjD+woUJFQp1
	 mprYlRD66TH+5KeX58kkoGf1cY0gFg6ADFmUl+Rdyibe1ah7xIg+/xPxV4IOP5nnz9dUq
	 LhQG1ajePIYDmGqC4TnmGOIGKMcM9X0tlQhqjAwXTIGmXbfHE7IBsGie8GZfYjrdT5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfLjmHWa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98829606A31A;
	Wed, 28 Oct 2026 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfLjmHWa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BB81F01825;
	Wed, 28 Oct 2026 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210913;
	bh=+E64/F0Gy+LDuXAowuHNuML0EJaH6N7f19oaCRa98Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfLjmHWaa8ztWAx5ysg+ivOQzDD0beOs5HHhEuxIQIa4J7HlsgxrXP17aRsweYznl
	 kc9TccithBfggH0fVTYZLeFccn964XhPZ539VERM4QKzUrVpqfYEkmamqSEwBLTiOS
	 x2vqYFnHKrZqlofUp6qmsToB761mimcbVWIuUaYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/571] netfilter: ipset: do not update comments from kernel-side adds
Date: Wed, 28 Oct 2026 17:55:23 +0100
Message-ID: <20261028170012.189542554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a442c8a89fb9c531f9d6ab86120c31decd778d51 ]

'Fixes' commit stopped calling ip_set_init_comment() for hash types
from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:

   "The kadt functions don't use the comment extensions in any way."

But bitmap set type calls the function from kadt cb too.

While this appears to be safe (serialized via the set spinlock), it seems
better to not call the init function either, least of all to keep
behaviour consistent.

ip_set_list calls ip_set_init_comment() only from uadt cb, it can be
kept as-is.

This was triggered by yet another LLM review, hinting that the existing
rcu_dereference_protected() cannot be downgraded to only check if the
nfnl mutex is held.

Fixes: f30415929be8 ("netfilter: ipset: do not update comments from kernel-side hash adds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 9523104a90da4..8a2beac5a53e3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -157,7 +157,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
-- 
2.53.0



