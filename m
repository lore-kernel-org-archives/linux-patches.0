Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6812C374F6;
	Sun,  9 Jun 2024 11:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931047; cv=none; b=uv9WOAXS2yXRIUCHG88SCDPMaWFh5iVUUaP1+7ydfU8Q64EtnbWfOLr+PUZXMoCifbZoxi6h+Rbc0KuNMpGLiEQe0bEbVPmtdFSwJhBtgjYszI/QoGIbIlFoZ2B+TXqPUozp2zLNv6l8WvsocHM7XLueNI56fOnX4o28F3W1QuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931047; c=relaxed/simple;
	bh=/Hgx1vbOs/R+tHaSnGVhz0XvHUBYfgU9p4BRaHHLSkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDTVNBgi9/fs97XmkvJd/RK3zaDEXvl9SdZSlhoaEUhpJCXh6MRmuYQxz/OAXTuG2LJ9gC8i+Vs41FM2gH3sIqS3pLm4+Jbm9XfZAM58CIzz01vlJArSQPyQtC0t4WLaG36sdn0lckxhS69THeAkyQM/WyrFnisLR2OKRXiqqfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfqjMmXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfqjMmXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F17EC2BD10;
	Sun,  9 Jun 2024 11:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931047;
	bh=/Hgx1vbOs/R+tHaSnGVhz0XvHUBYfgU9p4BRaHHLSkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LfqjMmXutuO1atlbDQsyhVUQk08KYrqEuwxYPoTBbJE3KnHmYM2kjzhG7DQEPGArz
	 uMTTrFbJ23zlHwb6tDJfWJSXAubaaEhi7hz5PHDQAlPOL/nESC20wgF6G2go7qC0o2
	 bwOxDskDzzERQB6mB3gRTB7v5V7ijykyUabXz0Ao=
Date: Sun, 9 Jun 2024 13:04:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 6.6 438/744] ovl: add helper ovl_file_modified()
Message-ID: <2024060951-angelic-bladder-13ab@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131746.528729378@linuxfoundation.org>
 <CAOQ4uxhwgGKf0=y4LTst5ExDVO0c0HWeZ=3iRK63t8GW9zBzbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhwgGKf0=y4LTst5ExDVO0c0HWeZ=3iRK63t8GW9zBzbA@mail.gmail.com>

On Thu, Jun 06, 2024 at 05:41:35PM +0300, Amir Goldstein wrote:
> On Thu, Jun 6, 2024 at 5:18 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> 
> As I wrote here:
> https://lore.kernel.org/stable/CAOQ4uxj6y0TJs9ZEzGCY4UkqUc1frcEOZsnP4UnWvGtQX89mRA@mail.gmail.com/
> 
> No objection to this patch, but this patch in itself is useless for stable.
> It is being backported as
>  Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
> and I think the decision to backport 7c98f7cb8fda is wrong.
> I think that the Fixes: tag in 7c98f7cb8fda is misleading to think that this
> is a bug fix - it is not.

THanks for the review, now dropped from both 6.9 and 6.6 queues.

greg k-h
