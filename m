Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE3F17107A;
	Tue, 30 Apr 2024 12:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480851; cv=none; b=h5AkGyiMZVdkmKZC9MNkv5+iZ6g75fHuVQDfXVdJnSEPBK5RmSNyzUPosLQzjYG7qC3ax9+hvp6vZEQp5kncgL2DitevEE4q/s9Mg28HeRHm9z8eZjrAzVMWx1OWvCtbQJ8DBXeOLbX+qJM41WoQuRaT1AzQbyT/GcuggHLvjQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480851; c=relaxed/simple;
	bh=lKF5yYwf45tf/pLmCzzpRrx+avgtdDcGZOBBNdlOw9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNsLL7ukOcIF43rZ41p6OE9zCvYrHJo2WoQoPuQxoIsyp3ZlMKMwxlWdvWCMXFF/AGxV8MgBGTVDD3a+R7cSqGB6TbbqcDYUD9PGmg8aJD8ad8zPOVSH1qKAqtCZBL9YQLgzJoE1fJ7WDez4B81v+VkzxJu3Ya+jlwW7rsi2oHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ky4Qyp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ky4Qyp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0549C2BBFC;
	Tue, 30 Apr 2024 12:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714480850;
	bh=lKF5yYwf45tf/pLmCzzpRrx+avgtdDcGZOBBNdlOw9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2ky4Qyp61k6tz0U+Zau6xqQPvPj+s6oAO8++qtRfhQ+KS/auhA2nFpo0ptAfS9VtG
	 O6rXPURcPVf06Gw4NnIpb2G4ZVc37ZUWEqH60zmMxkry0Le5hMz+MX88Kg36DbRaXM
	 WFvGrmmcwsIcqklZBpOKWb5ORr3FgdMBq2UDdMv4=
Date: Tue, 30 Apr 2024 14:40:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Ogness <john.ogness@linutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 53/77] serial: core: Provide port lock wrappers
Message-ID: <2024043021-dried-ferocious-dd3c@gregkh>
References: <20240430103041.111219002@linuxfoundation.org>
 <20240430103042.703277875@linuxfoundation.org>
 <87y18v5dlo.fsf@jogness.linutronix.de>
 <87r0en59vg.fsf@jogness.linutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0en59vg.fsf@jogness.linutronix.de>

On Tue, Apr 30, 2024 at 02:16:43PM +0206, John Ogness wrote:
> On 2024-04-30, John Ogness <john.ogness@linutronix.de> wrote:
> > On 2024-04-30, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >> 4.19-stable review patch.  If anyone has any objections, please let me know.
> >
> > The port lock wrappers are only needed for the new threaded/atomic
> > consoles that are still being developed for mainline. I would not
> > recommend backporting all of that work when it is done and therefore I
> > see no reason to backport the port lock wrappers.
> 
> I took a look at the full series and noticed you are pulling in some
> uart fixes that are using the port lock wrappers. In that case I suppose
> it makes sense to include the port lock wrappers.
> 
> So I am fine with this going back to 4.19. It has no functional change
> anyway.

Yes, that's why this was taken, you beat me to the response :)

This makes backporting things easier.

thanks for the review!

greg k-h
