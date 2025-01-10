Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF332746E;
	Fri, 10 Jan 2025 05:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736488702; cv=none; b=jfych3EHEmzNa/GMzM7hv6th30GFYBAz9y0s2+elgu2+7fTSK1JaqZryjUIZaL9xvM8Z02rVrmk5o4pPakij105V9Aoqwfbt/Ac9yB1liyG6gpN81ddVPKNQzrDMslkXDkzWPFkxjfoJKpsMkpPNP2+pKS/KQv+dpAdsXFYBkF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736488702; c=relaxed/simple;
	bh=topItqtKknIOfGfDvD6hJmVGF0nqfjtCb0Tg+rQ6JRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+++UG4nEXEI7nVZfBLHhenKrS1xkxQ3MfMSBQZC8KQU4nouGKKBB8P+qodbpehHeoBI9ep6n67ytQsAMRss0z1wCiKvzWBl9C9yzLE70/efkzu0xiuJrPLuj7H/ENjdmmibDSsDJWh4c786lWadx2tTGzJD4pFr5QKsmbRNyrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODmweQsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODmweQsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6332C4CED6;
	Fri, 10 Jan 2025 05:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736488701;
	bh=topItqtKknIOfGfDvD6hJmVGF0nqfjtCb0Tg+rQ6JRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ODmweQsa5xleKsvn9A5Z9z+glAaSP0+FygCatONTeLkcZmLIExVbAgVtYw7lz+Q4o
	 55FLUgYRPq7sYLXvqcGqjpCoj/2iwK93kd449g26NJu8sfn03rfKtwblI5aHTfnPAL
	 Um/zgoKn/U6zTWG22jS1uOg6BFWeScl+RUw5IaTw=
Date: Fri, 10 Jan 2025 06:57:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 5.15 6.1] zram: check comp is non-NULL before
 calling comp_destroy
Message-ID: <2025011052-backpedal-coat-2fec@gregkh>
References: <Z3ytcILx4S1v_ueJ@codewreck.org>
 <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
 <2025010929-nutmeg-lustiness-f433@gregkh>
 <2025010916-janitor-matching-0136@gregkh>
 <Z4CEt5k3DWz4J9SK@atmark-techno.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4CEt5k3DWz4J9SK@atmark-techno.com>

On Fri, Jan 10, 2025 at 11:23:51AM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Thu, Jan 09, 2025 at 11:09:38AM +0100:
> > On Thu, Jan 09, 2025 at 11:09:02AM +0100, Greg Kroah-Hartman wrote:
> > > > Before 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
> > > > device") that was indeed not a problem so I confirm this is a
> > > > regression, even if it is unlikely.
> > > > It doesn't look exploitable by unprivileged users anyway so I don't have
> > > > any opinion on whether the patches should be held until upstream picks
> > > > this latest fix up as well either.
> > > 
> > > Looks like Sasha just dropped the offending commit from the 5.10 and
> > > 5.15 queues (but forgot to drop some dep-of patches, I'll go fix that
> > > up), so I'll also drop the patch from the 6.1.y queue as well to keep
> > > things in sync.
> > > 
> > > If you all want this change to be in 6.1.y (or any other tree), can you
> > > provide a working backport, with this patch merged into it?
> > 
> > Oops, nope, this was already in a 6.1.y release, so I'll go apply this
> > patch there now.  Sorry for the noise...
> 
> Thank you! I hadn't even noticed the patch had made it to 6.1.122
> earlier, good catch.
> 
> So to recap:
> - 6.1 is now covered;
> - for 5.15/5.10, you suggested squashing this prereq directly into the
> 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
> device") backport ; given the patch got merged to 6.1 as is does it
> still make sense?
> I can resend both patches together as a set if it's become more
> preferable.
> (... Perhaps adding a tag like [ v6.1 tree commit xyz123 ] even if I
> doubt it's standard)
> - (for completeness I checked 5.4, 74363ec674cb doesn't apply so I won't
> bother)

A patch set is fine, as that would match what 6.1.y has now.

thanks,

greg k-h
