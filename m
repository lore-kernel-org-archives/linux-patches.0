Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B251C0DCE
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174391; cv=none; b=ftnu1O/c/7w324DL5yvS3QZnMYwD57BDsup3g/4ePcElvutwuKEo20zxeUxMI9kkpzMOnny7yDnknjWY/nafiro79zc2UUB47udDsdDMUT0I5rFPP3stSdxjFi+Ld7HQF/lR9nvNE1Yun0kMAVoOB+8z70w8j9I2ZaDsU9OrgZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174391; c=relaxed/simple;
	bh=iDraRUjl5oL1xgN68Huw+NH/26MmOw5WLPqUrN6J8gU=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwQdd0Umlg1IY+SM0WyId35jbXdTTaHCvU+k7m3RN0HxoYtZr0G2TR1kHcWADBBUxMmnHhDdCPvxpSD4zDd8RUU6hN102lj6dREcR6shY5D0dzQucOEJLx10O8y+NnSuvbmEgEZqPkHMY6u+Yc757XzwC6TxxxkWRa+fUkvZZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FayJ9jfW; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FayJ9jfW"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7a1e31bc1efso368086285a.3
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 10:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724174389; x=1724779189; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TiyLbBScoOEAyh1b94eZlYoF11C+Y/bEKpA+kMzIp/4=;
        b=FayJ9jfWClRnaJMgQU21m2BVAi4vfYz1pAdnAl1CxZ2dH+Kl41YlVyMd9+st4y0K85
         FaS2rcXmyHKH/+U7Y7tseanpSoNC34NLDnshBm5bTk00ffjAT1YkeyuQJFtXMgCeZ/pW
         7SkSELbycUcd1Jw9bpFmTkhEnksQJ8Fge0UlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174389; x=1724779189;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TiyLbBScoOEAyh1b94eZlYoF11C+Y/bEKpA+kMzIp/4=;
        b=TS1e1KZOBIHmMqdSE2P8ba4a5QLTOWc6BJuFUoiNPgmWXAUep11iYtHPBFS+zYSRgq
         AOA/RSazTx3Y4tByHwaaqoLXOFB5WuE5WhZ8k3P68KogtI/PqmosDfF5Y51DCiooXCyx
         44t64sEYV2QTFxK76lR3R8GVjMiUHVBkzAUoc9tT8O8dY/Pnsjw+uzwy8NOYuXoQfdwz
         iq75CvJMeMVdGdvpl6foXlAQC4I9P1JqdfTuPF7gCu0unZXAnC+mW++35oHY3Tu5VQvc
         1VJl9Cw75ap7bWBKH+Prx05mACP2Mg4xIrlsoFrLcVEGHcn6lmxnWvPcH0S45ojCLjId
         6j1g==
X-Forwarded-Encrypted: i=1; AJvYcCXvHpihSM55lkoQT2dJxWaTX5LQwTnqBoyt2cPycd8kg58h1uYJduIHz6jXP/unSlLiO3MT2gHP@lists.linux.dev
X-Gm-Message-State: AOJu0Yzowk3DFeBbf3fJWcqJa3Mp4VKnXEOf6l4RfN6K1vAURS48qpe3
	/M8t6Fy9W6ghYTUwSf3H5cgw0Ln9+L/nDlZ2iRnONI6WBhy08auvEj8aaA++rEbcP9t0TeslInr
	JcI4ROKPqXrXfwucNwbYUb0/ZoFnalxLeflcf
X-Google-Smtp-Source: AGHT+IGvb1y8J9GbBVxSnRA9EXCz4Y2dTYC1BxL8SdlIGlM8BUVy3xXqhZZEkOLtGvt/v6Ls5degXKbKQR8XD+zhGss=
X-Received: by 2002:a05:620a:2943:b0:7a3:49dd:2002 with SMTP id
 af79cd13be357-7a5069d5c63mr1695634285a.55.1724174388818; Tue, 20 Aug 2024
 10:19:48 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 20 Aug 2024 10:19:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZsTPeEsS1m4Y8imq@smile.fi.intel.com>
References: <20240819223834.2049862-1-swboyd@chromium.org> <20240819223834.2049862-6-swboyd@chromium.org>
 <ZsRs6d6uOMb4DqQQ@smile.fi.intel.com> <CAE-0n52O01UgrDT2=-JJpZj39BOJNyyQC4w_pgDUmKDmcN=8Yw@mail.gmail.com>
 <ZsTPeEsS1m4Y8imq@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 20 Aug 2024 10:19:48 -0700
Message-ID: <CAE-0n52FSUFictNQ9kotgFAZPYnJpy+3Ad__QeUN+EiJuBWGwQ@mail.gmail.com>
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

Quoting Andy Shevchenko (2024-08-20 10:16:40)
> On Tue, Aug 20, 2024 at 10:01:07AM -0700, Stephen Boyd wrote:
> > Quoting Andy Shevchenko (2024-08-20 03:16:09)
> > > On Mon, Aug 19, 2024 at 03:38:19PM -0700, Stephen Boyd wrote:
> > > > +     ptr = devres_alloc(devm_typec_switch_unregister, sizeof(*ptr), GFP_KERNEL);
> > > > +     if (!ptr)
> > > > +             return ERR_PTR(-ENOMEM);
> > > > +
> > > > +     switch_dev = typec_switch_register(parent ,desc);
>
> (Side note: wrong location of the white space)

Thanks.

>
> > > > +     if (!IS_ERR(switch_dev)) {
>
> (Side note: positive conditional is okay)
>
> > > > +             *ptr = switch_dev;
> > > > +             devres_add(parent, ptr);
> > > > +     } else {
> > > > +             devres_free(ptr);
> > > > +     }
> > >
> > > devm_add_action_or_reset() ?
> >
> > No. We don't want to call the 'action' devm_typec_switch_unregister()
> > when it fails because that would unregister a switch that has never been
> > registered.
>
> Hmm... With devm_add_action_or_reset() we first do things and then try to add
> them to the managed resources. In that case it won't be like you described.
>
> What do I miss?
>

I believe you've missed that this is a wrapper around struct device and
the error path is different (put_device() vs. device_unregister()).
