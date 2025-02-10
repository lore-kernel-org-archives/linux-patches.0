Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6A223C8A6;
	Mon, 10 Feb 2025 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739201568; cv=none; b=TO8e6dEFMEgZixxv9EjWK9FIXMgrc0Op+/rD0M5/oRaY8hOiGPAtB7ASabtyV9uMHfbVv/G2n+ZAKxhF5y4ywMvASef6DRC1dCMsSZKA/XR+Dq/riHFq/KIc4oDv7bGW8hpmAShZG4d9rVP7nRydqnYMqApRVUAnK+7JsWQ3rj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739201568; c=relaxed/simple;
	bh=5FWueVqEZx4BMXghA4HKvnexLXhwaHEUDzs1PUwVEU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKlNoZ35HhKX+V9gdsJkDT/i19GZOCXsOOqhx2ScfzfNu4QlYKZ3UBhGZ++tymMgtXTrAFFqGjvsxTxVilb2wXKPSJ8CTOniNyW/T053jcYt4XrZCiOfqvyT2NC1khvU+jQ2mDN1f6Oi264rbvMVqAX/qv6iT/xqo+p5AmLx3Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J082z4xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J082z4xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4766EC4CED1;
	Mon, 10 Feb 2025 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739201567;
	bh=5FWueVqEZx4BMXghA4HKvnexLXhwaHEUDzs1PUwVEU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J082z4xupvWovzsCPEMcJ6eqmjpmRiIF1LkEhjJ85lB7ecbYXBOMC4+62xB6Z4BWz
	 HHvQDwiOOEuIOJ/8p8D7TRZ1pLcwnN+bIKh+Ke09zwzoqobw6/JZAvJIDM+8LYDqBk
	 N4AN+2+hyE+6Izh8YhCKOQpA6VwRFsAp5kGQLZasvxlmi1HOovdOlsEiG5NBi6FVTO
	 Hwk371wOhpbdTSRIQDkWG8MCjrBUMOfEoXPgIj6KSo/C5QaMb77obaPQ1bjYVTCQCJ
	 /l0kZjZFYYDepcs5ZHE6rt1xkt0voUoJvpmFJzs+fBUz/703DWCs4onQwTGhDT1vnp
	 Fsn2clRKzbwTQ==
Date: Mon, 10 Feb 2025 07:32:45 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v2 0/4] enable bs > ps device testing
Message-ID: <Z6ocHUjsykrqx7sU@bombadil.infradead.org>
References: <20250204225729.422949-1-mcgrof@kernel.org>
 <ny65lqco7qjaahrthyvmlgz26jb3w7jsqxdm6c7vz4qni2x2jd@n2v2jfxwicyh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ny65lqco7qjaahrthyvmlgz26jb3w7jsqxdm6c7vz4qni2x2jd@n2v2jfxwicyh>

On Fri, Feb 07, 2025 at 11:24:10AM +0000, Shinichiro Kawasaki wrote:
> On Feb 04, 2025 / 14:57, Luis Chamberlain wrote:
> > This v2 series addresses the feedback from the first series [0], namely:
> > 
> >   - uses less device specific names
> >   - checks for fio arguments --filename or --directory to extract the
> >     min io target or path
> >   - adds a new patch to verify the sector size will work before creating
> >     a filesystem
> >   - a diagram is provided to help easily disect why we use statx
> >     blocksize, although not included in the docs we could later if
> >     it helps
> 
> Thanks for this v2 series. I ran the tests, and they look working. Good.
> I also ran "make check" and saw shellcheck warnings. Could you address them?
> 
> $ make check
> shellcheck -x -e SC2119 -f gcc check common/* \

I fixed them, will submit shortly.

> > This goes tested against a 64k sector size NVMe drive, the patches for
> > which will be posted soon rebased on v6.14-rc1.
> > 
> > [0] https://lkml.kernel.org/r/20241218112153.3917518-1-mcgrof@kernel.org
> > [1] https://docs.google.com/drawings/d/e/2PACX-1vQeZaBq2a0dgg9RDyd_XAJBSH-wbuGCtm95sLp2oFj66oghHWmXunib7tYOTPr84AlQ791VGiaKWvKF/pub?w=1006&h=929
> 
> I'm interested in the link [1]. I guess it is the diagram noted, isn't it?
> But it looks like I can not access it. I just see a blank page.

That's so odd, I embedded this document here too:

https://kernelnewbies.org/KernelProjects/large-block-size

It is below the "stat --print=%o" example:

Can you see that image?

  Luis
