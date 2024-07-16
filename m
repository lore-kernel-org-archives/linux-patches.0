Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EDF19AD46;
	Tue, 16 Jul 2024 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144919; cv=none; b=Pmo508L4hTfP95lewmFqS6ijZu/1dG9P2eQPDk7DWLvyeVep5cYCdWpS+52MNQb6UXeglZRlqEXddrGhl8LqlhtfPyxdkmVTPmzdfrnsAF8C0hkaRFadBNSO9dt0GzWuXgHYYDF0mmaiscarQq6MniSiwl5Gz5xfgA0+mz+/s8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144919; c=relaxed/simple;
	bh=nYcS2vy4aWmKBusZtIa8jmIBijIDI5YQJVRWrI8j8ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO/YeA1ZyhR2JhYAyxggxTXFIBX1kNFgjx9frqVVQuG4+pIAeneXcrmx0MuJDC6vF8KNLZbysbn7Me48d3FHXmg+HMezzURv3KluUQKQEfKbGMGIclKv8gM3+DmoZFeFzj9y03I9VULf9AeeCe7iD51ogRKhn4yQsnCeAIgFeTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJs9M3YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJs9M3YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87A0C116B1;
	Tue, 16 Jul 2024 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144919;
	bh=nYcS2vy4aWmKBusZtIa8jmIBijIDI5YQJVRWrI8j8ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJs9M3YAk7/cp0HB4bqtUjeuLqeP7j6dCsfSpFELaxJd+YwcUw3vUPgDB8xy7WBx3
	 KLglnK0hSug2jzFtf1YOuyATdoP9KHOWDgO31HElNRZcERx6o7lJvaw6OzHXL0U6d0
	 RLRtJn4+NoIyXfFq6CiAfriLdGY6zSm6Dds6vm0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 040/143] netfilter: nfnetlink_queue: drop bogus WARN_ON
Date: Tue, 16 Jul 2024 17:30:36 +0200
Message-ID: <20240716152757.530595479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 631a4b3ddc7831b20442c59c28b0476d0704c9af ]

Happens when rules get flushed/deleted while packet is out, so remove
this WARN_ON.

This WARN exists in one form or another since v4.14, no need to backport
this to older releases, hence use a more recent fixes tag.

Fixes: 3f8019688894 ("netfilter: move nf_reinject into nfnetlink_queue modules")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407081453.11ac0f63-lkp@intel.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f1c31757e4969..55e28e1da66ec 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -325,7 +325,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
-	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
+	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		return;
-- 
2.43.0



