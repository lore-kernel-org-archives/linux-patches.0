Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212664;
	b=hzxrCgl2poqa2zdkNOipLL/9N2h3n5EV3rdDroCilSP5F9HVhz5Vr5CMi6fE97F0JGML
	 GZ/hpYOeuk4z23zupHewOUV5CbPZHJ5+x243sKNpwZM16CD3/vdO20uMqep/ToiI0j6cI
	 BpGEx84DLwG4lzPp3WTgxJltwBjpm7/ww0cG6VxL3b7LVPvvDi1gJRXG11+Zz92ny88ah
	 JrLazkpi2FLx75ohxItOLcMgHFYF+wv4K2qrXT0WaTekJO9RM5bpl4em3xxKVRFt6ne2X
	 EkYPQYWWmo4SDq5nNzOJM3xAQRKDMxkwmJ355I6pOl/D7I4XtS6nZu3T8+GzhLWsN0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q0MusYc/5Mdr6xz14BGkbPpOYYchRBDfUae1r81B76U=;
	b=Q/RywOuujNqJ3pUNRee9Bczj0ZCRRO0v9Y1SK96715kI1UfEubxkNcM3PhQ+jWpEH+Wm
	 HkHo9D3p37LNW3ehO7SusIabvJk3BajwPTMhhgFpI/7ReIwvv8cwo9Lx0qnYipoNolTuO
	 l8quQNoA0k8IRjcc9caMAmJn+7MZipvExxA5d61T+P3/NGM6FqPaJ3UZ0402emWfresIx
	 X4Me/Mmt4FzUQb9pnZCpANnyR4Tqx1I/zavsvIvOZ1oqk0A6Kt2PblM6n4/SikczY/mMN
	 OFAYy0To/fHDj5oz6/gJm0uBoTQUUqU4JOU33lCTcfE98TR/Qp2SVt6Ml4LB54iDMzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVjGqLHe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E1606A31A;
	Wed, 28 Oct 2026 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVjGqLHe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD1D1F01825;
	Wed, 28 Oct 2026 18:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212663;
	bh=Q0MusYc/5Mdr6xz14BGkbPpOYYchRBDfUae1r81B76U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVjGqLHebKx/6o0EpfvVMC6k9/sS4cdBXT6gNjdjM/m6Xg4zVzbvtC8W7Y26TKdkq
	 VGRQhIDz75DMRzYjZ35ZvXgAzODH/LVjshiU8pAWxI1E3McsM5+V67w81/EXkyZBCm
	 qbIOBfxG7yusOZvu8YuUsTA3mg3xOlhrAr8FZXN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0232/1887] netfilter: ipset: do not update comments from kernel-side adds
Date: Wed, 28 Oct 2026 17:38:48 +0100
Message-ID: <20261028170504.510896027@linuxfoundation.org>
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
index 605d54d2bd7e6..3dc2ebbe4800c 100644
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



