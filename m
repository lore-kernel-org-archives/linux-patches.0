Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CEE5224
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 06:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EdP1DyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25DBC433C7;
	Wed,  1 Nov 2023 06:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698819818;
	bh=3k1kIXs8/Sab6mIRDPXr9UXI6P2gje3fykJ1YNTcOWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0EdP1DyXIbFT3nB5BcrovwbuRYpDmzC7SCNdrs3Z7tRDOXpgWxQ7zoBXi3XlPnjji
	 Uu9u9d+MmLxBa8/vvw9yH7EOzeytFk9AyIyOThlkRnzcKzqce+33XzAmyKeedatuG0
	 bKDnKC23euFkGbvDbj8/uupIys9/dSme8RUjr59w=
Date: Wed, 1 Nov 2023 07:23:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 05/86] ASoC: codecs: wcd938x: Convert to platform
 remove callback returning void
Message-ID: <2023110122-verify-goldmine-1ea7@gregkh>
References: <20231031165918.608547597@linuxfoundation.org>
 <20231031165918.777236098@linuxfoundation.org>
 <958957ff-bbaa-4fbc-a796-30e2fdf61453@sirena.org.uk>
 <2023103133-skating-last-e2f6@gregkh>
 <8744aeca-36cb-4d47-86f9-92fa70a234e1@sirena.org.uk>
 <20231031204123.thehtrqhmludytt6@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231031204123.thehtrqhmludytt6@pengutronix.de>

On Tue, Oct 31, 2023 at 09:41:23PM +0100, Uwe Kleine-König wrote:
> On Tue, Oct 31, 2023 at 05:49:03PM +0000, Mark Brown wrote:
> > On Tue, Oct 31, 2023 at 06:44:52PM +0100, Greg Kroah-Hartman wrote:
> > > On Tue, Oct 31, 2023 at 05:11:27PM +0000, Mark Brown wrote:
> > 
> > > > This doesn't seem like obvious stable material - it's not fixing any
> > > > leaks or anything, just preparing for an API transition?
> > 
> > > It was taken to make the patch after this one apply cleanly, that's all.
> > 
> > Ah, I see.
> 
> The patch has a footer:
> 
> 	Stable-dep-of: 69a026a2357e ("ASoC: codecs: wcd938x: fix regulator leaks on probe errors")
> 
> to make this point explicit. I really like the addition of this
> information to the stable backports.
> 
> Thanks to whoever had the idea and implemented that!

Sasha did that, it's been invaluable!
