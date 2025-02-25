Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7D255E22;
	Tue, 25 Feb 2025 06:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466041; cv=none; b=C4ifdRWf72SdL+Nuv5BXmeknSgF22odQ0jd7YwF6oD74W8mR6PuhDQYfsPx1ylU5WXE1YTwzuPajujwAnnnoVmIxU9uN/8eO65Qrs60CzE+R1G0851C55OA6Fra6DX7N87WGTr5PwshZsxrH4s4rqmO4Lx5MB/f3dAwFECjEKFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466041; c=relaxed/simple;
	bh=FVocQIgiyg3Z+U+/cX3Th1z6u6eRQOPH3nijUjDbz4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUnmY6sdZyhMQbUUeQLeAzBu7gjh1WEUkgOW3KV7oaz6s7txrmabvzdQugI4ItE5XjxT5fxOLpwJmw/b1PAl6l37vmv77x73laUBJZ2OW66sh3ntMBTkPsnX0yj5VmFmKnWnAp8ZHlwff1fagMrAKLCBe+tY+4ecqlEda1lNXsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh9D7m7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh9D7m7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE1BC4CEDD;
	Tue, 25 Feb 2025 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740466040;
	bh=FVocQIgiyg3Z+U+/cX3Th1z6u6eRQOPH3nijUjDbz4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lh9D7m7kRhraBXrpjXh7bJrvjoI2QaWHakvegnYrJR9S6Y95xSYEQv72lGg2W5JRh
	 WjKI5mNIYYzJ4Uf1GXZ2A6XTo8TbvHI8cXdlnumQHwIhc0b06noUHFCH2lIs/jAbGL
	 Jn4ZQdEkNB60dRFgZ/78G6Cwtux5MSuClJpLLQik=
Date: Tue, 25 Feb 2025 07:46:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
Message-ID: <2025022548-swiftness-supervise-ae80@gregkh>
References: <20250224142604.442289573@linuxfoundation.org>
 <9a18b229-f8b7-4ce2-8fe0-4fabd7aa6bd2@sirena.org.uk>
 <CACMJSeuQkzvi5j975bbb6gF=+NMz0Aw-X5xLXR=8rMUjeQUoZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMJSeuQkzvi5j975bbb6gF=+NMz0Aw-X5xLXR=8rMUjeQUoZg@mail.gmail.com>

On Mon, Feb 24, 2025 at 08:57:10PM +0100, Bartosz Golaszewski wrote:
> On Mon, 24 Feb 2025 at 20:52, Mark Brown <broonie@kernel.org> wrote:
> >
> > On Mon, Feb 24, 2025 at 03:33:50PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.13.5 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> >
> > This and 6.12 are broken on several platforms by "gpiolib: check the
> > return value of gpio_chip::get_direction()", as reported upstream
> > several drivers break the expectations that this commit has.
> > 96fa9ec477ff60bed87e1441fd43e003179f3253 "gpiolib: don't bail out if
> > get_direction() fails in gpiochip_add_data()" was merged upstream which
> > makes this non-fatal, but it's probably as well to just not backport
> > this to stable at all.
> 
> Agreed, this can be dropped. It never worked before so it's not a
> regression fix.

Ok, thanks, I'll drop it from all stable queues and push out some new
-rc2 releases.

greg k-h
