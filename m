Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2222E3A1C9
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 04:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726027385; cv=none; b=l567xmDHZKPbjSfQTYLj27X7GVgflTLFsDaiLmDsarTQKGb+yy9YlYOzN8JvqB6zHZmyDfCOfBQBWswMk5Cy65RYADNjI170BlKtpkNks1khLx1Q4xeMu2ob6uPxm9Mx8YAQGSrcSPcwVcvMcneK3miUBbgi0cznGKmCvQ7dcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726027385; c=relaxed/simple;
	bh=7jRIESI28vc2IwuINcmvQcRSKoOwYYNre2FNHnHRBb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKJ+6qujWU4LNtqGrXswOgbmf6/fElihQ1QvkqebdlrMh+ajS6DnF7TOPId2PeqcZaMACjNkOYUqc8ig+dzIitW7oBlbzq7oBQcnYTD2ikVInS71meF2LSbEB86lsk2+qSBDXfdIFKE1dLk6QX2DBbr6De4+7qyIi4DTbs6oS8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=DDUXBgxh; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="DDUXBgxh"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 298C514C1E1;
	Wed, 11 Sep 2024 06:02:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1726027375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+7R/umzBoSPkJzUQofCvf7cDhPwvj1bDwUnnPr1rnd8=;
	b=DDUXBgxhcOrKNBwuEKAk1Ro/1pHlwg3BDnfFMQ4vgOPiKoqOZixd1Vi3V5OUZnA3+/6Hbx
	kjpTKI/TOhOzR7y7Vd4gyW/ghurbbnrjzP38CIQLrJUs/7ddSbx+kLc9KY0OMdz9FUQEzu
	bpBJ5E5lQwwyswhB2V+cdWOcAmu42AEFcHDAHyBKzPNnKhHLD3OQS+lkbErWw4jT87STze
	XbC/HPJIGpX8BDGzOHLIZ+hO28xa1I7x7SdCKFTSzcFNsPFPkgadkOb4J8Pe+t5EW5KQqE
	E1YY9q/khg6nq6X4Pom8yx7J8v1cAvDwuQNLKe49h15pIaBncDyMJ08laYxoIw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id ac6668da;
	Wed, 11 Sep 2024 04:02:51 +0000 (UTC)
Date: Wed, 11 Sep 2024 13:02:36 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: David Sterba <dsterba@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 064/151] btrfs: change BUG_ON to assertion when
 checking for delayed_node root
Message-ID: <ZuEWXHMn09_17Nxr@codewreck.org>
References: <20240901160814.090297276@linuxfoundation.org>
 <20240901160816.526197570@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901160816.526197570@linuxfoundation.org>

(this patch was already merged to stable last window, I was late on
review -- this is more feedback for master that has the same code)

Greg Kroah-Hartman wrote on Sun, Sep 01, 2024 at 06:17:04PM +0200:
> From: David Sterba <dsterba@suse.com>
> 
> [ Upstream commit be73f4448b607e6b7ce41cd8ef2214fdf6e7986f ]
> 
> The pointer to root is initialized in btrfs_init_delayed_node(), no need
> to check for it again. Change the BUG_ON to assertion.
> 
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/delayed-inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index cdfc791b3c405..e2afaa70ae5e5 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -986,7 +986,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
>  
>  	if (delayed_node &&
>  	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
> -		BUG_ON(!delayed_node->root);
> +		ASSERT(delayed_node->root);

Note that if !delayed_node->root we will bug on a null deref immediately anyway.

This patch was missing just one line of context, I've added it below:
>  		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
>  		delayed_node->count--;
>  
> 		delayed_root = delayed_node->root->fs_info->delayed_root;

So, ASSERT doesn't feel appropriate -- if you want to protect
non-developers from BUGs then the check needs to be spelled out and
return early or not enter the if; or it really cannot happen (it used to
be a BUG...) and the check can be removed altogether.

-- 
Dominique Martinet | Asmadeus
