Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B943F18C27
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 12:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B3C433D2;
	Mon, 12 Jun 2023 12:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686571837;
	bh=woWcCxLImDvq1oizXs1M0cVggKJm/m5bOTJ+QkYngls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qm0K0duwDljOJSNBNPM8i+fABmP44/OHut3UUIFic76sSye+CBsGzQXQukvfs2eKI
	 icIzgR+Y5eywQM7QrnenwTO2UnAg6mYV743ENQKMKTdxCk2jWg6Gv8/3zFwdFj1GUd
	 9DuB73M7yAM0KRF4ACRSNwzDmGw9Xj3DFT62pL2Q=
Date: Mon, 12 Jun 2023 14:10:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory
 disconnect
Message-ID: <2023061216-pry-mournful-beed@gregkh>
References: <20230612101715.129581706@linuxfoundation.org>
 <20230612101716.793331479@linuxfoundation.org>
 <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23db24e1efd0ce7904d0e57289009852cd58e29b.camel@sipsolutions.net>

On Mon, Jun 12, 2023 at 01:43:23PM +0200, Johannes Berg wrote:
> On Mon, 2023-06-12 at 10:26 +0000, Greg Kroah-Hartman wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > [ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]
> > 
> > This should use wiphy_lock() now instead of requiring the
> > RTNL, since __cfg80211_leave() via cfg80211_leave() is now
> > requiring that lock to be held.
> 
> You should perhaps hold off on this. While all this is correct, I missed
> something that Dan found later:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=996c3117dae4c02b38a3cb68e5c2aec9d907ec15
> 
> I'll have this in the next pull request.
> 
> I suppose _both_ should go to stable, and nobody ever seems to run into
> this patch (at least lockdep would loudly complain), but stills seems
> better in the short term to have missing locking than a deadlock.

Thanks for letting me know, I've dropped this from all queues now.

greg k-h
