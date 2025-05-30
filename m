Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8111E515;
	Fri, 30 May 2025 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748619502; cv=none; b=pO4uE1hwWukv1+cPR8u11IiuO6oOaCti35/8lYK3O0QQp4EmNwfa8bdLwMpZpe+47Gn/c+ByxTY7iqKEQTkvgoJ2XQPwn7yDE0Ic1upvtQrd1VX3u82Fuwnyqt3fQ6zYzXsgL8WNCILzlt0cGVJtj6+KECePhe8eMJ2qZevu8xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748619502; c=relaxed/simple;
	bh=qhqXFKgewFJlv3njmlpisyNPzmmvgMzshmgXgrH9w9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7TDL34nw+B8bRGO3FLCL+OHAH5iuSKn6sd/pP333wGHlBw1esSxnVPNPSJn/Hv/9wGO0E8sNzS+QxSnKoyPjqor/ucwHPCvuPDApoRy/cpmG7e5aPqPxuh+IFN9+FRTE73nRDnH33JCEUgayWroI2OzOyJJ4gw+xbFBy2QdBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALJ4a2ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALJ4a2ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBD3C4CEE9;
	Fri, 30 May 2025 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748619501;
	bh=qhqXFKgewFJlv3njmlpisyNPzmmvgMzshmgXgrH9w9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ALJ4a2ssLSnh784QJlO0ANc1++8RQGKV2FpBT/HcBFnT4IqL5AiHmmSJ9zRapGp2y
	 WgkSBcrfbJhI1+WYo4U8+gP9OI7wB6b0JyPm+b3t4jUaGlzulzdprHPzO/73vkSAlU
	 Bc1tjEgBNzC44AOcCwPj6wiRzkRuCC/e3VBXrfrM=
Date: Fri, 30 May 2025 17:38:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kate Hsuan <hpa@redhat.com>
Cc: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>, Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 645/783] HID: Kconfig: Add LEDS_CLASS_MULTICOLOR
 dependency to HID_LOGITECH
Message-ID: <2025053057-velcro-uncut-c818@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162539.405868106@linuxfoundation.org>
 <27b9765e-c757-41c7-9cbe-fe1c915fdf2b@web.de>
 <2025053022-crudeness-coasting-4a35@gregkh>
 <2025053000-theatrics-sleep-5c2e@gregkh>
 <f2e2eb44-ea55-46ef-83b4-207b5906f887@web.de>
 <CAEth8oFU8Kn_RWDe84MLi8s-kQfTWYBk2knsxZx8mrKo6uooYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEth8oFU8Kn_RWDe84MLi8s-kQfTWYBk2knsxZx8mrKo6uooYw@mail.gmail.com>

On Fri, May 30, 2025 at 10:56:15PM +0800, Kate Hsuan wrote:
> On Fri, May 30, 2025 at 10:51 PM Jörg-Volker Peetz <jvpeetz@web.de> wrote:
> >
> > Thanks for looking into this.
> > I should have asked more specific:
> >
> > Greg Kroah-Hartman wrote on 30/05/2025 16:09:
> > > On Fri, May 30, 2025 at 04:08:40PM +0200, Greg Kroah-Hartman wrote:
> > >> On Fri, May 30, 2025 at 03:44:22PM +0200, Jörg-Volker Peetz wrote:
> > >>> With 6.14.9 (maybe patch "HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dependency
> > >>> to HID_LOGITECH") something with the configuration of "Special HID drivers"
> > >>> for "Logitech devices" goes wrong:
> > >>>
> > >>> using the attached kernel config from 6.14.8 an doing a `make oldconfig` all
> > >>> configuration for Logitech devices is removed from the new `.config`. Also,
> > >>> in `make nconfig` the entry "Logitech devices" vanished from `Device Drivers
> > >>> -> HID bus support -> Special HID drivers`.
> > >>
> > >> Did you enable LEDS_CLASS and LEDS_CLASS_MULTICOLOR?
> > >
> > > To answer my own question, based on the .config file, no:
> > >       # CONFIG_LEDS_CLASS_MULTICOLOR is not set
> > >
> > > Try changing that.
> >
> > Yes, enabling these makes the "Logitech devices" entry appear again.

Great!

> > My concern is more about the selection logic. The "Logitech devices" entry
> > should not vanish.
> > How would one know that "LEDS_CLASS_MULTICOLOR" is required to configure
> > Logitech devices, e.g., a wireless keyboard?

That's the "joy" of our build system, dependencies are rough.  You can
search in the config tools and it will tell you that dependency if you
are wondering why something went away.

> I switched the driver to use the standard multicolour LED APIs to
> manage the keyboard backlight color, for example Logitech G510
> keyboard.
> So, LEDS_CLASS_MULTICOLOR is required.
> Should I submit a fix patch to switch to using "selects LEDS_CLASS_MULTICOLOR" ?

Please no.  depends is the proper way here.

thanks,

greg k-h
