Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C2F2DBF76
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767865526; cv=none; b=maKlEA5ohCiyzRkFBYdz9L1AfiT1DhSdzEVVZspoWLF5ikwN9xhZflbRNklV6AjQEhGvzhRoGtch9PEGkjn7VzajFIYAzqhjhd5bMA+HzVJkt+65pqIoAd1mXkOdPBJMUmAws7ZmVi4kTV59XAlhVrsfuhoHj/Bhq3jV8PPJ8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767865526; c=relaxed/simple;
	bh=wLIWL74uqRZ0MG32DtebybhVE04jaG3SotfUJ3nbQKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QyylO9wrZyRht6v6GDXtV+2Uo8xO49/4zSvZeT3WF3c1kKJRxdxzszdvKur7ESpjea/G2/xHKP63oSb77cS7QtXq8JUT4aZOK1ykHcBoL7pXCweQLKGSKN0oGIqQeJWhiVxy/YTfThiqDTjjsF1gHCk4aKR8ejcVLoVIXBDick0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=heZVvjwx; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="heZVvjwx"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-382fa66fa9dso16701991fa.0
        for <patches@lists.linux.dev>; Thu, 08 Jan 2026 01:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767865517; x=1768470317; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3e6OTtKJfcSSJP7UkAzuBTTHphz/T3Qg2RIC0GLIQoE=;
        b=heZVvjwxYrvLtUArJPm7YWk5OeJEy01MjvCtb7OhvS1M+CQdajs/W9FwVaeYzQc5e4
         q3R1R4BV9FQjWc71HN1FQTsd5VbBVVqO4veJFZP/aOjNBfSvTIasPQTIS7n3V2uiXMYb
         yZ/IQx2B+K/cq9DeXOcOGFM+oov2FS69NvHvw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767865517; x=1768470317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3e6OTtKJfcSSJP7UkAzuBTTHphz/T3Qg2RIC0GLIQoE=;
        b=BU6bkOFliZ4E3Z+a5N22SP7ww41L8GQ6jWzBz604JRWX9JAd47T3YOuOgJLJhp2bc3
         grLbYde5waeNLuQ/mKyNZ6Lx+JG9mNXrEYDf61bxemOSX0T/if4bZSoEL6tgVraUC4ww
         poynDfwP5+9w8lN6GdfRPd3/b55yaw/7GNuIUshq0VtPjTtAJvxY5uO2q9cKqqIBtpOi
         jG2BlZs4JCzvbsNwQLfgrXqIXSw6MTgSftB5zXKZcoqeoXTPDPDw2qBc8/UWoBx63zNK
         8TxNTzDfJNqCtL8OSeK6igNspIdNSlHtA4aHU1/Tm6N1L57kZB/pZ/ci18Ur2wNHGFlF
         zqFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+nfmC4CZQBt+xogdw96Vz4md0OxZrtZhBkIpAhYwWVPRjWClJ0y941ihfv8LrJ1QtNbMSgkHq@lists.linux.dev
X-Gm-Message-State: AOJu0YzXagebLvMxSGhoOT7v0fI9zjGL5dkG8yi4ngEb24Ie1vOwR/dD
	BRmCIHhmR0SUYuivtdvnB0U3OO33CMEX7B5FgPPJLLfdjnb7WHH2VE6EBcg2OOvenMMK6+6JUgE
	PvYx6BFDqX3ZFy+hMCTCiTrndbryyYB3QbYUQ8+uDYgRslLPZ9g==
X-Gm-Gg: AY/fxX6mqupAGtvvSYQiCnmtmyuPiic7jWdcdwGbHWSuDqevU49GS9k2peBVTYd5Cvo
	pGeJ2hM8yvk8HLkQHeuuR4jwx76Eg4AxK0kQX1UOsP1po+2pERdZmobrLmdWMmUveGvxUPMK9Mp
	BcMljIrGOKaqake1faBzaD7/kVSBOk9NHR6rtf96fNfv2ZGL8v38zEHpx1iQy685RyUk9UPkCWZ
	kPpJbTeslVEVrdA5rxpqksZ632PxOrs3AgtaVk7aXxrrL3LLxvC0VBFG6shpITiK91kuzFJ
X-Google-Smtp-Source: AGHT+IEs4fUUJ3pMxRRABtOPO0u5xxTJc4YzICb1/S7PSESPqUAIhX1ox4ouAAkJqWhP4/naw6JYVwyiFT9m9r0uiPc=
X-Received: by 2002:a05:651c:3050:b0:37b:9977:7e4f with SMTP id
 38308e7fff4ca-382ff708909mr14541401fa.28.1767865516669; Thu, 08 Jan 2026
 01:45:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170451.332875001@linuxfoundation.org> <20260106170509.599329945@linuxfoundation.org>
 <CALwA+NZCSz26m96R0gjKP7=O3Z_kWmnt82SiaqvOukR9vFxv2A@mail.gmail.com> <2026010832-scrutiny-talisman-cdf9@gregkh>
In-Reply-To: <2026010832-scrutiny-talisman-cdf9@gregkh>
From: =?UTF-8?Q?=C5=81ukasz_Bartosik?= <ukaszb@chromium.org>
Date: Thu, 8 Jan 2026 10:45:05 +0100
X-Gm-Features: AQt7F2oaaaOl7LEle_7kOIQFDOKt78J4Pqiy8M9UNyuYXa2v72nmHPp7fh7Tzq8
Message-ID: <CALwA+NYNHGN3p5s6tgCkkUm=1sxQPYbBir6U=gnXtfCkCBRb6g@mail.gmail.com>
Subject: Re: [PATCH 6.12 493/567] xhci: dbgtty: fix device unregister: fixup
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 10:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jan 07, 2026 at 01:04:37AM +0100, =C5=81ukasz Bartosik wrote:
> > On Tue, Jan 6, 2026 at 6:43=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.12-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: =C5=81ukasz Bartosik <ukaszb@chromium.org>
> > >
> > > [ Upstream commit 74098cc06e753d3ffd8398b040a3a1dfb65260c0 ]
> > >
> > > This fixup replaces tty_vhangup() call with call to
> > > tty_port_tty_vhangup(). Both calls hangup tty device
> > > synchronously however tty_port_tty_vhangup() increases
> > > reference count during the hangup operation using
> > > scoped_guard(tty_port_tty).
> > >
> > > Cc: stable <stable@kernel.org>
> > > Fixes: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
> > > Signed-off-by: =C5=81ukasz Bartosik <ukaszb@chromium.org>
> > > Link: https://patch.msgid.link/20251127111644.3161386-1-ukaszb@google=
.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/usb/host/xhci-dbgtty.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- a/drivers/usb/host/xhci-dbgtty.c
> > > +++ b/drivers/usb/host/xhci-dbgtty.c
> > > @@ -522,7 +522,7 @@ static void xhci_dbc_tty_unregister_devi
> > >          * Hang up the TTY. This wakes up any blocked
> > >          * writers and causes subsequent writes to fail.
> > >          */
> > > -       tty_vhangup(port->port.tty);
> > > +       tty_port_tty_vhangup(&port->port);
> >
> > The function tty_port_tty_vhangup does not exist in the 6.12 kernel.
> > It was added later.
> >
> > I sent updated patch
> > https://lore.kernel.org/stable/20260106235820.2995848-1-ukaszb@chromium=
.org/T/#mb46d870145474d04aaabeccc76aaf949b34bbf86
>
> The patch before this one added that new api, so all is fine here.
>

Thank you for pointing that out.

Thanks,
=C5=81ukasz

> thanks,
>
> greg k-h
