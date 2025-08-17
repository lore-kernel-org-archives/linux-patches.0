Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEFB1FFC49;
	Sun, 17 Aug 2025 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755453663; cv=none; b=kFxUi9A1zOedwcoIgI3fWQsCHqOeBQzAwKugRL2j4+NS5fCFp4XwR1KJcyrpV6LBw9Cc9DQRdByc07eywQ/iEIjUx192RzK8z43/rjzu48gMe1BArKe6axdb89qv0wVQaYboYcU5mDjHifqmmGWB3zEXEYicyoD2iL06wP1Tktw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755453663; c=relaxed/simple;
	bh=5G8wDbGUwIBciPcf06PoCtuYzmZOgEBaS6ztpmz5bHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAs+hACXPnojjS2M5OQAWF6KK9xC3O0xkiFQ7Ep4lOaMjuUV8NlBUOGI/OQA3PDEfIHgAENRzkAtwjoyxLeZM4+px+H+JWiq5/aOVN9Hehwyx7Ck7rqOycdUTy/457T7aXFhcy+ImtnH28EcoMAruGqtmAoNJ36b6Q0Cv86MmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ct4tyTp5; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ct4tyTp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=khGrxNAJPB9gBEYB/7VaQ6Jo4BeO32XSLT8lL6wysdw=; b=ct4tyTp5ZBhb0ioWgZXWe4G3Yw
	8Ik0lmw3509y+PqO54lrgMVKxNAKHr3qQ2Howrf6r1VVU5LShreRYKzUpJrhoUk40ifla620Fwd4a
	zRdoWj08LPzeaRYpa6TwQVWKiuJcFRyNr1cg5F8wGz5UcLRVM6623XOzreynOuKuPvdW7tdBsDFdC
	WgX0uefluNJIOg4mYYJ9MtDiIfaalgSz+qCQYq1riRF+ohahB7L5zK4ypsFBGMHHHTkqjIFGGd+RL
	GSaXf7cJSm4Rh4WJTtcFgqboYiUMgcM8d9Z6e9nlzi8VXanctBGbUV9StE19/4gLt/qA0RXraj16S
	wRvvvBkg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unhgf-0000000BZpU-3CcG;
	Sun, 17 Aug 2025 18:00:57 +0000
Date: Sun, 17 Aug 2025 19:00:57 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Askar Safin <safinaskar@zohomail.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	cyphar@cyphar.com, Ian Kent <raven@themaw.net>,
	linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>,
	autofs mailing list <autofs@vger.kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/4] vfs: fs/namei.c: remove LOOKUP_NO_XDEV check from
 handle_mounts
Message-ID: <20250817180057.GA222315@ZenIV>
References: <20250817171513.259291-1-safinaskar@zohomail.com>
 <20250817171513.259291-3-safinaskar@zohomail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817171513.259291-3-safinaskar@zohomail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Aug 17, 2025 at 05:15:11PM +0000, Askar Safin wrote:
> This is preparation to RESOLVE_NO_XDEV fix in following commits.
> No functional change intended
> 
> Signed-off-by: Askar Safin <safinaskar@zohomail.com>
> ---
>  fs/namei.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1e13d8e119a4..00f79559e135 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1635,10 +1635,8 @@ static inline int handle_mounts(struct nameidata *nd, struct dentry *dentry,
>  			return -ECHILD;
>  	}
>  	ret = traverse_mounts(path, &jumped, &nd->total_link_count, nd->flags);
> -	if (jumped) {
> -		if (!unlikely(nd->flags & LOOKUP_NO_XDEV))
> -			nd->state |= ND_JUMPED;
> -	}
> +	if (jumped)
> +		nd->state |= ND_JUMPED;

I'd add something along the lines of "the only place that ever looks at
ND_JUMPED in nd->state is complete_walk() and we are not going to reach
it if handle_mounts() returns an error" to commit message.
