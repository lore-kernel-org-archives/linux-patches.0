Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDFF2F7ABF;
	Wed, 17 Sep 2025 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113169; cv=none; b=Ls1zTVz66XuLqFxCQ4HXFATjQeR5zTPu6UXalIatwyShs82fcCwEoHc0HD7iFt9rM8NwFvS5NR2gB6g8JOAy25vmpNF8yrm+Tp/ErDPWxA208bw4nY7MWIhN9Y93rFrol94+7JzTCOecw9t5S9e8twbCxp9SSeNYfygKCA7r+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113169; c=relaxed/simple;
	bh=79hCcZEEq6rqIG+onGhDvDvFipKxkqyLegp4boJyqVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6MTTjvbDvJQif4UYAzu+/3nxHEfpVQBUwFH40y3fi7MMCG+KRqxN/TMGwHHZAqFUMPP8ixj/yyxFyLRrbsDGTNjfMgPf0XVRd9XD3N6b0zVGRw5RgDvfDB6w3+TQPANu/908vHbBNXMixDuHubHcim7yP1HYX1PqbKYnPfJpGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKDsHxcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKDsHxcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFD4C4CEFA;
	Wed, 17 Sep 2025 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113169;
	bh=79hCcZEEq6rqIG+onGhDvDvFipKxkqyLegp4boJyqVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKDsHxcTN+p+ZmcOKjWl8DSeDE1l478M4TX0nG/lzdyyE6PL1UlcNLCPQu92Ky8Ap
	 brGkmt+Cw98GZ360nNHpvBjbUm3H8Lz7NMOhfjXz/52O0VshXXEe5Vtq/VIgQEJTVm
	 x9g3PExZAv+UMawYkZELP61YkXrDVxWZeuxns6a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 156/189] netfilter: nft_set_pipapo: dont return bogus extension pointer
Date: Wed, 17 Sep 2025 14:34:26 +0200
Message-ID: <20250917123355.685751180@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c8a7c2c608180f3b4e51dc958b3861242dcdd76d ]

Dan Carpenter says:
Commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
lookup and update functions") [..] leads to the following Smatch
static checker warning:

 net/netfilter/nft_set_pipapo_avx2.c:1269 nft_pipapo_avx2_lookup()
 error: uninitialized symbol 'ext'.

Fix this by initing ext to NULL and set it only once we've found
a match.

Fixes: 17a20e09f086 ("netfilter: nft_set: remove one argument from lookup and update functions")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/netfilter-devel/aJBzc3V5wk-yPOnH@stanley.mountain/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c4eaca2e1052 ("netfilter: nft_set_pipapo: don't check genbit from packetpath lookups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 6c441e2dc8af3..2155c7f345c21 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1151,12 +1151,12 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	const struct nft_set_ext *ext = NULL;
 	struct nft_pipapo_scratch *scratch;
 	u8 genmask = nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	const u8 *rp = (const u8 *)key;
-	const struct nft_set_ext *ext;
 	unsigned long *res, *fill;
 	bool map_index;
 	int i;
@@ -1247,13 +1247,13 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			goto out;
 
 		if (last) {
-			ext = &f->mt[ret].e->ext;
-			if (unlikely(nft_set_elem_expired(ext) ||
-				     !nft_set_elem_active(ext, genmask))) {
-				ext = NULL;
+			const struct nft_set_ext *e = &f->mt[ret].e->ext;
+
+			if (unlikely(nft_set_elem_expired(e) ||
+				     !nft_set_elem_active(e, genmask)))
 				goto next_match;
-			}
 
+			ext = e;
 			goto out;
 		}
 
-- 
2.51.0



