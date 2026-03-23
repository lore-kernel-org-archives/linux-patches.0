Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C87329D267;
	Mon, 23 Mar 2026 12:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774267768; cv=none; b=TV4fyH1BzbzDS1WZVIfYDHMx6HQVekcDS7xdKe8YcC7iYHrmen9rpJqOcJYGQhnxdQ6sz+85rQY2rU1YKsNzswPEkVinNO3NFiN7QxeXC4CbdhKfdyfPtvUxt2zrAxmjwqZC2JvmtN+n1Pnoa6nTPjP2fI5dk9hGQ3irYM3nggw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774267768; c=relaxed/simple;
	bh=NombPNG79gufUelXYFJwjfH9RYaPYkV0p9rJSU7GHzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6NGug9oq+WUMoruA47Apk6xjInW8+O6WmjV2K8vtVujh+1lC7jU0MzF5s4vMQjHMD9A3NiJP1vopJW6bFcFIYVVRxNIC+98G9O28TBjt/CsubAR5D8nEpr9e1PKVK0QqvuRCL8exoeIVzqK7vp5aQkCc+41EqO64povp4b4JGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/0eRk0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/0eRk0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C362C4CEF7;
	Mon, 23 Mar 2026 12:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774267767;
	bh=NombPNG79gufUelXYFJwjfH9RYaPYkV0p9rJSU7GHzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A/0eRk0Z+UBsVmcPs+Oe59kR91fYMmOQH6mw80m5O+UI6xlt9Ye0ZvLRn7pLiJZnT
	 Tp3vTzIQfUmCEucCpsGKXKj/mX+LPsKJpp2Gujd19OXHZhJcZYvwPxnpGPRDhpS2hV
	 pGkVu+y9FKLKY0/ncGSHbe3zxpPRVyZsPSgIWtrWWWSNJ+QBNzSxemXd1IxhAAtRgr
	 pZcNd5oPQcO0cUTtBNsfYTr3N1960kbzz9maDcGh3RiMEo9sLSQ7dHUde1tExUOzuB
	 +71gCF2RydXtjA77GN3sjdPKXGzl3zDQ+ALp2TQOV+BrHrYPRKpzuq1i9ca0DLdGKJ
	 gGjoYzGqk+HWg==
Date: Mon, 23 Mar 2026 13:09:23 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] init/initramfs.c: trivial fix: FSM -> Finite-state
 machine
Message-ID: <20260323-tierisch-schnupfen-5ff1d33507fc@brauner>
References: <20260319232721.452950-1-safinaskar@gmail.com>
 <20260320144635.GA6202@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260320144635.GA6202@frogsfrogsfrogs>

On Fri, Mar 20, 2026 at 07:46:35AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 19, 2026 at 11:27:21PM +0000, Askar Safin wrote:
> > FSM means "finite-state machine", but I think this is not obvious to
> > everyone.
> > 
> > Signed-off-by: Askar Safin <safinaskar@gmail.com>
> > ---
> >  init/initramfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/init/initramfs.c b/init/initramfs.c
> > index 139baed06..d29fe0a5c 100644
> > --- a/init/initramfs.c
> > +++ b/init/initramfs.c
> > @@ -212,7 +212,7 @@ static void __init parse_header(char *s)
> >  	hdr_csum = parsed[12];
> >  }
> >  
> > -/* FSM */
> 
> ...and here I thought all along that the initramfs code had been blessed
> by the flying spaghetti monster! ;)

I've touched it a lot recently and the urge to massage it is getting
stronger but I have too much other stuff to do...
