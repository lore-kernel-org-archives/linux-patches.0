Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825543;
	b=GtBM4/E4k88dpMlVEt41s0m2is6vYXhmYh8ABBvtOjAztqxcSuvHdDQkZ3wY3IYR6q7G
	 5ZWP51L4pRgyMXtNQFJUkxMNynyeGB2/wZUVD/vpdTIRwTVzE83nOTHJFn1PzxAbL/40C
	 zaX5l955DQOwkkG7lBfKL1+4Ul7OHE+tx8lYZH8q+Y+gLQrORZEVjfiS3LVTU87zd0xDL
	 FvrBRl/D+R1j3VppwJSOpvxkGSdRI8BFz2ISMrdU/m5S/BB9nKN5KTqVvZd1sT4iFXpIV
	 P7R9f7B0zJZBm7N2J4825bl2jWydrm8Vz7AzcvUOD6PeTVJrzykEWunDJmpqUpqW+Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825543;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6xD81lAG6UeXkEreuShp+JJaj+9y4oCBxhpOeIMXWAs=;
	b=0IklUqUp9uJrNJ7GOjtz6+CpuW77Cx2ciIauzF7zTT6QAtTGO9IKVGH+4gD8M2tgWt45
	 8R98BHnP4mnMv5Tg9GsqQ269ilgxhEFTg2+zsrroGvlsd8pnv2NvHX+vg6ruFE5nn0Y7H
	 ywO1oRxWqqsF2UKcP6QF4/mDju4ql1IHC+BeQaVtfL0eKsw/g7HZCdaWW8vMPlFMp46Gp
	 z/tUlsPwGMJkg0Eclj3LHmH2QjXQeXgRIzUeIyWvH9I7iZ386UHoZtXDIfXW4+hlBI9c0
	 lK58XRE7lfN59MV5b4n9p8hIO9Zh0cMoDlCgv/IVrQOk/4ka8aSQcc1YqE/8xxxG1SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKn0+6ig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68FF6078147;
	Wed,  4 Nov 2026 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKn0+6ig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8291F000C1;
	Wed,  4 Nov 2026 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793825542;
	bh=6xD81lAG6UeXkEreuShp+JJaj+9y4oCBxhpOeIMXWAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RKn0+6igfgmEszjRwFLPQY0bX4nEyQ4tGkDZ4qrsOyUNlp3WX6J8Sc8wUJV4mrjog
	 A+W1GCWBa0iMzwAEhX6sG1Oy73Jyu1jY2+YO1Pc3iPpvyoRc2BOSaLHs+muQAlRUOm
	 s2tVwKvMAHhCvPeJdeHbeBmfFgvkCcZJ9zfEb9kM=
Date: Wed, 4 Nov 2026 15:52:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ralph Siemsen <ralph.siemsen@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 159/595] gpio: dwapb: Mask interrupts at hardware
 initialization
Message-ID: <2026110444-preshow-shelter-42d2@gregkh>
References: <20260930152347.700140858@linuxfoundation.org>
 <20260930152351.156698628@linuxfoundation.org>
 <auj7ZUcOlNC-rEnk@maple.netwinder.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auj7ZUcOlNC-rEnk@maple.netwinder.org>

On Mon, Nov 02, 2026 at 04:06:45PM -0500, Ralph Siemsen wrote:
> Hello Greg,
> 
> This caused a small regression on 5.10, details below.
> 
> On Wed, Sep 30, 2026 at 05:20:52PM +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Liang Hao <haohlliang@gmail.com>
> > 
> > [ Upstream commit aaf7766ba3b99a3834319e7cf939838afc705574 ]
> > 
> > GPIO interrupts may retain stale state across warm reboots when
> > peripherals remain powered. If a GPIO line is not explicitly
> > configured for interrupts, this can result in interrupt storms
> > due to missing handlers.
> > 
> > Fix this by ensuring all interrupts are masked and disabled at
> > hardware initialization time via the init_hw() callback. Pending
> > interrupts are also cleared to start from a known-safe state.
> > 
> > Interrupts will be unmasked only when explicitly configured by
> > userspace or kernel drivers.
> > 
> > Signed-off-by: Liang Hao <haohlliang@gmail.com>
> > Link: https://patch.msgid.link/20260705074759.47863-1-haohlliang@gmail.com
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> > drivers/gpio/gpio-dwapb.c | 17 +++++++++++++++++
> > 1 file changed, 17 insertions(+)
> > 
> > diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> > index ea2e2618b7945..d6240ae0f87ca 100644
> > --- a/drivers/gpio/gpio-dwapb.c
> > +++ b/drivers/gpio/gpio-dwapb.c
> > @@ -189,6 +189,22 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
> > 	dwapb_write(gpio, GPIO_INT_POLARITY, pol);
> > }
> > 
> > +static int dwapb_irq_init_hw(struct gpio_chip *gc)
> > +{
> > +	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
> > +
> > +	/*
> > +	 * GPIO interrupts may retain stale state across warm reboots when
> > +	 * peripherals stay powered. Force a known-safe state before the GPIO
> > +	 * irqchip and irq domain are set up.
> > +	 */
> > +	dwapb_write(gpio, GPIO_INTEN, 0);
> > +	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
> > +	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
> > +
> > +	return 0;
> > +}
> > +
> > static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
> > {
> > 	struct gpio_chip *gc = &gpio->ports[0].gc;
> > @@ -428,6 +444,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
> > 	girq = &gc->irq;
> > 	girq->handler = handle_bad_irq;
> > 	girq->default_type = IRQ_TYPE_NONE;
> > +	girq->init_hw = dwapb_irq_init_hw;
> > 
> > 	port->pirq = pirq;
> > 	pirq->irqchip.name = DWAPB_DRIVER_NAME;
> > -- 
> 
> This causes a small regression in 5.10: the gpio-dwapb controller no longer
> produces interrupts, because nothing undoes the GPIO_INTMASK added in this
> commit.
> 
> Only 5.10 is affected, because the following commit was not backported:
> 1cc3542c76ac ("gpio: dwapb: mask/unmask IRQ when disable/enale it")
> 
> The earlier commit does not apply cleanly, due to changes in the context,
> but it is straightforward to apply by hand. For reference I tested with the
> following and it restored the interrupts.

Can you provide this in a format which we can apply it in?

thanks,

greg k-h
