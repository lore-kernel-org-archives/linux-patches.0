Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208571;
	b=TJ3ZEVr4XFK2wPWEIdNzDHxmUitwteH9VEVHJsX9E+cnJUkGJ4BsExxoUkrKd4IOjTfC
	 4MNVj11QX2RqEuEfZ5wy6PchRyXfdVVK/ok2JMJfE0mFkdtyLqDSsGL5YT6qU+0Her//K
	 tEZIW/FgKpzYYj+kmra00jR7EfUUaego6+PDPSyCvusnH41fku5Y9itewosH7YNcyr83j
	 pD1WcQaWBSormNgEmEQG9Hix4V+MYDJY0GgOBxhX2MRN91Lk8jcElCDtzyG2jQzNVC0hV
	 yzTTpR0xlhB+zlDk5NKc2VKjvpNO/t5oXO8zDfdlT3eSc/rr1/v6MH4tfqsXbJ2QtDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVO6qZvcbrzbRiErqqy/gM8MVeM+gdL6nwABxJywHEI=;
	b=NnDXdffUdoUyL1NEqeu32+36d0OrbpApDJT1qNQrBGh3Mxxa3P5Sl1hlicq0Plrvyt7r
	 da/aLqyP76dO+bXdNU+VnPqL4kayWAL6ZMcju2ms38u/u2kPTiB2lnfi17aFmQ+ouW78g
	 oN3vT4L8xlIGRJPz1MKo6Vih0/WIi7xXmWZMuHrTsfIjZoBpHqJAKcjjskyYaWXFl01Ig
	 heDvOhYmHOr9AG3G0TH9o+9N9xLp3aV6NugJUFai1LcioTw4i2wdZzwa5Q1icBwTcvuZ8
	 ofNffQpPJkywyHEcY0Z+mAjZ3svhiz3QtMyab8ve2KYc99cVZzx9QttYCFR5zzP5BTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMzWrhq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0376606A31C;
	Wed, 28 Oct 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMzWrhq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A4C1F01828;
	Wed, 28 Oct 2026 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208570;
	bh=dVO6qZvcbrzbRiErqqy/gM8MVeM+gdL6nwABxJywHEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMzWrhq2/v6+zpqgzSgngzq7lwWah63bWfjtD6tBhRgPzhxMyFsINz9Wfrgvvo6Uh
	 W5RCdYwD4o5XGk0Cn+yqE/rydrUrkLO+veGp/vdGChkg+VOjcBni4WXq5tX+i5XZUH
	 cqSvwFi/U+8CKA8XUy2xUVl6KPC2o75Vxdy5dMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/516] netfilter: ipset: do not update comments from kernel-side adds
Date: Wed, 28 Oct 2026 17:55:18 +0100
Message-ID: <20261028170007.437763073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



