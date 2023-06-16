Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A291428F
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 18:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B9DC433C8;
	Fri, 16 Jun 2023 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686941331;
	bh=5BYukNuE46B5WJslTSIxIIPnV1IlIfSwwR0vY1vU9mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xmHpYTFGrjfzOWqlIaJoyEJBDGRLX+Hmm4wEpiLMSQms80NGDo5AEIpxclhwYWNa5
	 QAxSAYxNTrJhWii7S0W1lwwKOBWdZNOP6wXutNZXx8dCnG33pdlS2JXz3rIdrAM22X
	 KgSblhUsHBuqT5ZsvBaZeT4zGlariwRhDYD5k4VA=
Date: Fri, 16 Jun 2023 20:48:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory
 disconnect
Message-ID: <2023061628-nimbly-ebook-3635@gregkh>
References: <20230612101715.129581706@linuxfoundation.org>
 <20230612101716.793331479@linuxfoundation.org>
 <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>
 <2023061216-pry-mournful-beed@gregkh>
 <1bcc48094ecae8b810e394abb7101bb8f4acb860.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bcc48094ecae8b810e394abb7101bb8f4acb860.camel@sipsolutions.net>

On Fri, Jun 16, 2023 at 06:51:15PM +0200, Johannes Berg wrote:
> On Mon, 2023-06-12 at 14:10 +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 12, 2023 at 01:43:23PM +0200, Johannes Berg wrote:
> > > On Mon, 2023-06-12 at 10:26 +0000, Greg Kroah-Hartman wrote:
> > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > 
> > > > [ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]
> > > > 
> > > > This should use wiphy_lock() now instead of requiring the
> > > > RTNL, since __cfg80211_leave() via cfg80211_leave() is now
> > > > requiring that lock to be held.
> > > 
> > > You should perhaps hold off on this. While all this is correct, I missed
> > > something that Dan found later:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=996c3117dae4c02b38a3cb68e5c2aec9d907ec15
> > > 
> > > I'll have this in the next pull request.
> > > 
> > > I suppose _both_ should go to stable, and nobody ever seems to run into
> > > this patch (at least lockdep would loudly complain), but stills seems
> > > better in the short term to have missing locking than a deadlock.
> > 
> > Thanks for letting me know, I've dropped this from all queues now.
> > 
> 
> The above commit has landed in Linus's tree, and I think you actually
> should pick up both of these now - there's a lockdep assertion there and
> locking issues triggered that I (if erroneously) fixed. Seems that we
> hardly ever get to that code though.
> 
> Should I send those patches individually?

I can pick them up from here, as the git ids are present and that's all
I need, right?

thanks,

greg k-h
