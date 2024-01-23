Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369FC664AC;
	Tue, 23 Jan 2024 01:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975108; cv=none; b=tV44WfOJyT7HaaqjNUGGh7UEEzmZAkVWfhOKZyNMOXyTIvpfbismFYLOS8QMwrYX67ZBQ9kLgUJywkObdN8aL74mgQxAlObMu8notIhygYtNpK6KadwlcgDwEF/6ZDwEz5djgZLa/Onq2zJ44GHstORCxNenL5W64VdNtX1vAjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975108; c=relaxed/simple;
	bh=nFzK8O2nvdgo/CXZolOShYrBGfrBAq5r6wJO4Y+k+jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJWRiv95DZ494cK3likoYtKxBZeTnIcfJVs+ngnNkY3xYb8syvQSidMgbpx3AzVNgZddX6uL/YlQix47W03HfPOmtIN2Zr4FmoE43RZZOFd4i4upl7tyTNaE7B/URgUVe3As3f6xO2wGpQjDfppdp1u4VJux3YlXLJEWAymq7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zn5n9eW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn5n9eW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA446C43399;
	Tue, 23 Jan 2024 01:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975108;
	bh=nFzK8O2nvdgo/CXZolOShYrBGfrBAq5r6wJO4Y+k+jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zn5n9eW+KHwQjl3s5zGrFSLd5YTnZOTCIWYCVUwWQVzJdk3GPcm09DoKEL4oyMSBp
	 NGRh+wD9zvRrmA31MyOE2ZLsyGxDaZu+hqYyK2I12jiW8LUh5fEkIPWfCGTuLCQawv
	 mrGd7eVsXynGXM03ttVzBWqQPTiRa74Lhl5O+jOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Wiedmann <jwiedmann.dev@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 369/374] netfilter: nf_tables: typo NULL check in _clone() function
Date: Mon, 22 Jan 2024 16:00:25 -0800
Message-ID: <20240122235757.805164682@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 51edb2ff1c6fc27d3fa73f0773a31597ecd8e230 upstream.

This should check for NULL in case memory allocation fails.

Reported-by: Julian Wiedmann <jwiedmann.dev@gmail.com>
Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/r/20220110194817.53481-1-pablo@netfilter.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_connlimit.c |    2 +-
 net/netfilter/nft_last.c      |    2 +-
 net/netfilter/nft_limit.c     |    2 +-
 net/netfilter/nft_quota.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -206,7 +206,7 @@ static int nft_connlimit_clone(struct nf
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
 	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
-	if (priv_dst->list)
+	if (!priv_dst->list)
 		return -ENOMEM;
 
 	nf_conncount_list_init(priv_dst->list);
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -106,7 +106,7 @@ static int nft_last_clone(struct nft_exp
 	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
-	if (priv_dst->last)
+	if (!priv_dst->last)
 		return -ENOMEM;
 
 	return 0;
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -150,7 +150,7 @@ static int nft_limit_clone(struct nft_li
 	priv_dst->invert = priv_src->invert;
 
 	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), GFP_ATOMIC);
-	if (priv_dst->limit)
+	if (!priv_dst->limit)
 		return -ENOMEM;
 
 	spin_lock_init(&priv_dst->limit->lock);
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -237,7 +237,7 @@ static int nft_quota_clone(struct nft_ex
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
-	if (priv_dst->consumed)
+	if (!priv_dst->consumed)
 		return -ENOMEM;
 
 	atomic64_set(priv_dst->consumed, 0);


