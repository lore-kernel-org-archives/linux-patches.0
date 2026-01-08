Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A299A3BF30D;
	Thu,  8 Jan 2026 09:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767863577; cv=none; b=qlm5++F8Y3UmuKY+WSGK9hlMpvHC8yiewaOUWozOVlVKWH7W089N1m7aST2fAEFUHwY7YvFptsl2jS7C6e8Bh4RcI6MuuoMKR6RZvFA5fKOu+QobPvDdQ+G/hbHiS2r3Qgs1R/YgBjKulvVZW2IF1WEDmal1bf0cIjYOTYh6Wag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767863577; c=relaxed/simple;
	bh=9qlvP8EfY2nVe3SrDRFWWW/X4lQllrd7hIAYmtsxO1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwuKpglYNTYMrLCsikK23LtfS6Wl+Xa4y2G6upk9xIchaVD+LuYIu2rzn7N3Eths5B8ZE9WcH1c2W4ZHCAFD2/tbo+Cr1zW33n5q5Ibaq0rLITi0aoghPMfJGkFYJ3rnYx3KXCuxEYXbgnqY4JwdsSGiblELmRVh59I3RylQlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKHAfeGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKHAfeGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EA9C16AAE;
	Thu,  8 Jan 2026 09:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767863576;
	bh=9qlvP8EfY2nVe3SrDRFWWW/X4lQllrd7hIAYmtsxO1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TKHAfeGXBbHu1CVrrltS4zgDgUihAo7aiNX6Pi9Bwt1SNufTZBgcELZzBX7lJmu+S
	 M9D3vdgm8/q8JDvH9i+t70xyiEP0Gls50PiZk1hP735NtMdji4lxru7KFV0rWcqc5Z
	 /0oEuk4yqMAtm+ZCRylMocP8vH4kBERjDo48eFuc=
Date: Thu, 8 Jan 2026 10:12:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?Q?=C5=81ukasz?= Bartosik <ukaszb@chromium.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 493/567] xhci: dbgtty: fix device unregister: fixup
Message-ID: <2026010832-scrutiny-talisman-cdf9@gregkh>
References: <20260106170451.332875001@linuxfoundation.org>
 <20260106170509.599329945@linuxfoundation.org>
 <CALwA+NZCSz26m96R0gjKP7=O3Z_kWmnt82SiaqvOukR9vFxv2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALwA+NZCSz26m96R0gjKP7=O3Z_kWmnt82SiaqvOukR9vFxv2A@mail.gmail.com>

On Wed, Jan 07, 2026 at 01:04:37AM +0100, Łukasz Bartosik wrote:
> On Tue, Jan 6, 2026 at 6:43 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Łukasz Bartosik <ukaszb@chromium.org>
> >
> > [ Upstream commit 74098cc06e753d3ffd8398b040a3a1dfb65260c0 ]
> >
> > This fixup replaces tty_vhangup() call with call to
> > tty_port_tty_vhangup(). Both calls hangup tty device
> > synchronously however tty_port_tty_vhangup() increases
> > reference count during the hangup operation using
> > scoped_guard(tty_port_tty).
> >
> > Cc: stable <stable@kernel.org>
> > Fixes: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
> > Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
> > Link: https://patch.msgid.link/20251127111644.3161386-1-ukaszb@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/usb/host/xhci-dbgtty.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/drivers/usb/host/xhci-dbgtty.c
> > +++ b/drivers/usb/host/xhci-dbgtty.c
> > @@ -522,7 +522,7 @@ static void xhci_dbc_tty_unregister_devi
> >          * Hang up the TTY. This wakes up any blocked
> >          * writers and causes subsequent writes to fail.
> >          */
> > -       tty_vhangup(port->port.tty);
> > +       tty_port_tty_vhangup(&port->port);
> 
> The function tty_port_tty_vhangup does not exist in the 6.12 kernel.
> It was added later.
> 
> I sent updated patch
> https://lore.kernel.org/stable/20260106235820.2995848-1-ukaszb@chromium.org/T/#mb46d870145474d04aaabeccc76aaf949b34bbf86

The patch before this one added that new api, so all is fine here.

thanks,

greg k-h
