Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531481A76BB;
	Wed, 17 Sep 2025 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113510; cv=none; b=DTi3lOvQ3iaYI+WCsBeXQh/yuPycO0TTgQsq+J/mHqfebb3hD9W7BDyZKb6r/Y7raLChcXVfbVSnRyks6nssZv6bxhn/IKaYXEiRdIW5EYZIkEISL9xZNqHlDM7rQ9sZytl1WkUujXKvsM1lDJUbIqDJfQV3OPWlxYu9RJr3dhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113510; c=relaxed/simple;
	bh=+pjb5EOJIwCmdLi8Mt8CApy8ZESg96Lnk6rm81pNisI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzUrbEbLeS/S8i9ZHja/6OfJ0RaQ9wowuxtjT0UGJcxeZUrDxbKwjBXUk0I6b3O5R6cb9ne/cN1ICZJ6DJ49ZHoOlQGXdvLMDkkvffV2MdZXpGsztpoI8AQyd/oXxsU51Dk0/OItqcKeAex4HaHEIye4UcMUsGB5AKb0dTM3wxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfq3/x1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfq3/x1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17A0C4CEF0;
	Wed, 17 Sep 2025 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113510;
	bh=+pjb5EOJIwCmdLi8Mt8CApy8ZESg96Lnk6rm81pNisI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfq3/x1lcHLfATGUzvPYCIlWGt4Dt4SwoV3ehQH6FAh+xIMMuT+LknyFabBZOScqc
	 2TjDFrqtbn1yyN0nchyfVVnZuDP2ZNPpiTDhr3XHuyA/uasP+uJM+nNXDwLJzJGMKV
	 ga2wTIaIdwEvt7psgkUQfILHUtK6BVXZUpqUHA9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/140] netfilter: nft_set_pipapo: remove unused arguments
Date: Wed, 17 Sep 2025 14:34:39 +0200
Message-ID: <20250917123346.924708995@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7792c1e03054440c60d4bce0c06a31c134601997 ]

They are not used anymore, so remove them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c4eaca2e1052 ("netfilter: nft_set_pipapo: don't check genbit from packetpath lookups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9e4e25f2458f9..9ac48e6b4332c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -502,8 +502,6 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 
 /**
  * pipapo_get() - Get matching element reference given key data
- * @net:	Network namespace
- * @set:	nftables API set representation
  * @m:		storage containing active/existing elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
@@ -516,9 +514,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  *
  * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
  */
-static struct nft_pipapo_elem *pipapo_get(const struct net *net,
-					  const struct nft_set *set,
-					  const struct nft_pipapo_match *m,
+static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp, gfp_t gfp)
 {
@@ -615,7 +611,7 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = rcu_dereference(priv->match);
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net), get_jiffies_64(),
 		       GFP_ATOMIC);
 	if (IS_ERR(e))
@@ -1344,7 +1340,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, m, start, genmask, tstamp, GFP_KERNEL);
+	dup = pipapo_get(m, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1366,7 +1362,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, m, end, nft_genmask_next(net), tstamp,
+		dup = pipapo_get(m, end, nft_genmask_next(net), tstamp,
 				 GFP_KERNEL);
 	}
 
@@ -1913,7 +1909,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 	if (!m)
 		return NULL;
 
-	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
+	e = pipapo_get(m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
-- 
2.51.0



