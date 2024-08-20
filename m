Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377201C4602
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174589; cv=none; b=r9/49qT6uDSPSIPpsdkDU5BKL/cSiK+He1V5hqUp95aLnRL1VSz0zmo//5nSYYsODwE7G5PqnMdK+scZA+gHBmDgsVi62ILR8+D1qrEkyC8M+QpwdsAeZA7pDTIFiKDueKQHyWMSmOqgjrdMzry2Esu+QSN+QXglz7ogpmQc8eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174589; c=relaxed/simple;
	bh=J/J+/+oGhoE+/tah11bxsaeUZE1I08hXwOLSwZwosUI=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEVyucuW39nPQlqG1Ooenvvk5cZZdL+y16mO5pLjTJnXdhSbeVS0Pe+YC3cE3VPLapni9E20NBW7xLh36uOs+CpYZREZAO/B3+iTuzVlyqy/sySB6yFD90ZIfW5mmR15SwyYrguzYiTdpzOgKBXtweytHwROQM1Up1w2e0HYvM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ga2oR3QT; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ga2oR3QT"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-843046a99e3so1215281241.1
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 10:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724174587; x=1724779387; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjiHfu5pkFzqUOsx+SOY2D+4odBwVmyecYJTsluInAs=;
        b=ga2oR3QTePi29gsaN4FOHiDf3M2XW3G43RmPYpY1JuJ8zonExDTTuPgvhQ1fYI7cfX
         W9sh74kxIvlfmaRvlvi5KZorYT8xTcLRJy6OifVwJUAPdC3h11wjSw3jhr/bMSAF3wvU
         mB+QY39dOou8N6DONgdNT6FNSTfUbbY3MXoAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174587; x=1724779387;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjiHfu5pkFzqUOsx+SOY2D+4odBwVmyecYJTsluInAs=;
        b=Ofm+9z2WbrdyVOAXHiHUYcjFLCf0iRRzw+2dPZTUFBkCuiuXY1E/ELGe1eD6+rSfBt
         VyysmqonWar+49TO/DWZAItwaB/wr05dx+4oHLVOo0qvz69W7jlKlc1EtxPM6wF2hS0G
         VTKr1XqWmR7AIae2ilP3o1J2ofodM2w7/+mUs753pFXp8ix/brxkn5YHaLR1HrW91kba
         TsbbkqoC0SurAmLHWDnrckLYXTlCgXP2kvy3JfjI0SPikNtC9ZtZiZ8432Ph3m32uDHU
         MoIpCq+5QNs9DsVV/SlRqqdHuIsDyYRVT0UiM9jxqAC7rG6WKh3emL2LFGS6tdryI/5X
         KCrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkGHgSLG5vIdz9z1ug5ja2wjQRe4O3PscETWETFuWV5X/AGQlKjs0Fgc77S7qvNXxYxxVlBUWeuUa8hpnFlz1e83o6V2G9IQ==
X-Gm-Message-State: AOJu0Yx3vSIXLqrhBHUfxPoJw6pftX53bHPs6Xi4Wx7JVtdLIR/S0v7e
	dsjz5vdQiUJb4ZYvST2fqhJFmhFTwFYJ1NAQGOXRSCAOv2C5WE/s/trClgrPCflqj00Dt2CnsYj
	HuXIKtSFsWUHdDaUQ5vCwQQ7gX4WV7lqNHXof
X-Google-Smtp-Source: AGHT+IGfqseqp4mRIKADD9bykOeA01y+4F/62kKEBLZLbbbLI1oVDw9K0JgFNuY/9j8342Q36vrpqnXZCv1APwGTLdw=
X-Received: by 2002:a05:6102:f13:b0:493:d1c3:1aef with SMTP id
 ada2fe7eead31-4977990c46fmr12594753137.14.1724174586925; Tue, 20 Aug 2024
 10:23:06 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 20 Aug 2024 10:23:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n52FSUFictNQ9kotgFAZPYnJpy+3Ad__QeUN+EiJuBWGwQ@mail.gmail.com>
References: <20240819223834.2049862-1-swboyd@chromium.org> <20240819223834.2049862-6-swboyd@chromium.org>
 <ZsRs6d6uOMb4DqQQ@smile.fi.intel.com> <CAE-0n52O01UgrDT2=-JJpZj39BOJNyyQC4w_pgDUmKDmcN=8Yw@mail.gmail.com>
 <ZsTPeEsS1m4Y8imq@smile.fi.intel.com> <CAE-0n52FSUFictNQ9kotgFAZPYnJpy+3Ad__QeUN+EiJuBWGwQ@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 20 Aug 2024 10:23:06 -0700
Message-ID: <CAE-0n50uOcCHHaw=opEY089ymPBER2H7QLtORFzD6ypwHEKUJw@mail.gmail.com>
Subject: Re: [PATCH v3 05/17] usb: typec: Add device managed typec_switch_register()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Andrzej Hajda <andrzej.hajda@intel.com>, Benson Leung <bleung@chromium.org>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, dri-devel@lists.freedesktop.org, 
	Guenter Roeck <groeck@chromium.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Jonas Karlman <jonas@kwiboo.se>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Lee Jones <lee@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Prashant Malani <pmalani@chromium.org>, 
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Daniel Scally <djrscally@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2024-08-20 10:19:48)
> Quoting Andy Shevchenko (2024-08-20 10:16:40)
> > On Tue, Aug 20, 2024 at 10:01:07AM -0700, Stephen Boyd wrote:
> > > Quoting Andy Shevchenko (2024-08-20 03:16:09)
> > > > On Mon, Aug 19, 2024 at 03:38:19PM -0700, Stephen Boyd wrote:
> > > > > +     ptr = devres_alloc(devm_typec_switch_unregister, sizeof(*ptr), GFP_KERNEL);
> > > > > +     if (!ptr)
> > > > > +             return ERR_PTR(-ENOMEM);
> > > > > +
> > > > > +     switch_dev = typec_switch_register(parent ,desc);
> >
> > (Side note: wrong location of the white space)
>
> Thanks.
>
> >
> > > > > +     if (!IS_ERR(switch_dev)) {
> >
> > (Side note: positive conditional is okay)
> >
> > > > > +             *ptr = switch_dev;
> > > > > +             devres_add(parent, ptr);
> > > > > +     } else {
> > > > > +             devres_free(ptr);
> > > > > +     }
> > > >
> > > > devm_add_action_or_reset() ?
> > >
> > > No. We don't want to call the 'action' devm_typec_switch_unregister()
> > > when it fails because that would unregister a switch that has never been
> > > registered.
> >
> > Hmm... With devm_add_action_or_reset() we first do things and then try to add
> > them to the managed resources. In that case it won't be like you described.
> >
> > What do I miss?
> >
>
> I believe you've missed that this is a wrapper around struct device and
> the error path is different (put_device() vs. device_unregister()).

Or you're suggesting devm_add_action_or_reset() after registering the
switch? Sorry it wasn't clear to me.
