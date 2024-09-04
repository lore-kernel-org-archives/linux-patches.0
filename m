Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71255E093
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725470239; cv=none; b=Y5IZqMer15kq2IDh2ZbCB0lRluhtCBY5zVCDq5upCcjKS6XGG6e2/0wRjSM4wpZbxdCDjYOmYKQGr4PzmvoypAQ6U1lk9Ba9cDi8VELNJKwbNI1aeLWs9d6U2YOkq4z5kzI25WA5qix6/xceTCoMgGR9D3ARWnKsQkGD9uIhPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725470239; c=relaxed/simple;
	bh=t65s4nNcRGc9mCe7+o0bYGJaz4sl89r+MRqyyhR0kno=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WFm++diabmzULjaJGWCOc+gzXNQfPwxYFm3NMCYTjBPT2R9w3a6UdTQC8F44h7Mh3cvKsBTL3ckDfOOgAl4KRzJXmFS80eVCai5P43niJO6yQ3W0PMk4WmFS0BBBwmpSWqbmve/jUPWLMbCC7JGGVaeWkLW/da++InFvt12DCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iGsGa3zf; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iGsGa3zf"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6c354415c19so24377196d6.2
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 10:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725470236; x=1726075036; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3OSNlGLBd8NLSWyCnfTJEaUwWihfhoQwqRJWu1zx2FI=;
        b=iGsGa3zfqRVQcSk/l6hc69cmEvhVyRSXRXh3Mgi9V9Qjh4E29akaQE113kMO2UNJ6+
         a9hqvkjDtg1cS00ZXeo0pmPhWiIUwjpGNDUiOPjCyTNZ+kU0OOz9+BsHWjezG3wVLLGm
         khQxumlzSRjg1ZKIz2Nwb+3TmuqKB1lo6aZJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725470236; x=1726075036;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OSNlGLBd8NLSWyCnfTJEaUwWihfhoQwqRJWu1zx2FI=;
        b=vAPStS2kDlg0gwfbX6GEMd3VhSG1w4GKjfXw45P0pbLS4Rmgkyda+xkr/nlRHJ6f+n
         d1nqR1/xRbSagqzM+6XAtqFVeYhEKBz5AAyi4YYlrQTJ0DmlmMF+29ul4WAvWEcTSNJc
         5K5n2IYpzFMInZWtVD10ONM4K0tuV8mEkVjB/nlzgLEgMqCAYfGOkna79b2sXC/bZerZ
         s65WdLAunTQkh3yjgT+8h1EcOnBe+ZudjeT5yEgZjxYnX7v0q28qVlxeBLTofgVCuDSR
         /fLNBG4DNUuhDlyojaxp3xtZK0qs6IhMWFsgaw12i45xR+3EikEQLQAZfKKk1amS8w9G
         41XA==
X-Forwarded-Encrypted: i=1; AJvYcCVVrzBpOvr6Q7DRyYHxAK+mtgxVwozN0F1u70zwZZvKiA2n9GOlIYBIeWrM2hegwnMHYiCnU8PO@lists.linux.dev
X-Gm-Message-State: AOJu0YzvoHYR//DIQ2E4PTr8oPga7YhfQPev2Jfg0ICZaJfBxSpm+tbs
	gMQYANP5svOpG2UlessdjAQQQ02rfeOPVd3kJokwHGk9ezjuR8/Ya3+gWhF7JbWORCA39+0Vmn2
	KkxEtTytmRZA6V8Zwaok0zuFJ63Tx1MCQwHmm
X-Google-Smtp-Source: AGHT+IEVE/zja0Ta9Tz96mzKz/L550YBB+VoIesNmcQXcpg7Z7ieAwebVwSfXt2IZeQcblS1lNC8BSuXnTTjD/SJFRM=
X-Received: by 2002:a05:6214:3104:b0:6c3:5f8f:2745 with SMTP id
 6a1803df08f44-6c510a93bc4mr62896466d6.27.1725470236496; Wed, 04 Sep 2024
 10:17:16 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Sep 2024 13:17:15 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZthaCQel2aHhyIu4@smile.fi.intel.com>
References: <20240901040658.157425-1-swboyd@chromium.org> <20240901040658.157425-7-swboyd@chromium.org>
 <ZtWjEudmlR51zkU9@smile.fi.intel.com> <CAE-0n51eSxxvnJXwnfPrXx1=rei=8OGGEtCAgw6nhCktZ0iQDw@mail.gmail.com>
 <ZthaCQel2aHhyIu4@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 4 Sep 2024 13:17:15 -0400
Message-ID: <CAE-0n52PxnSMGn3TVt3iiq_3Bimnd4JPoeZ1F6XB1o4itiykUQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/18] drm/bridge: aux-hpd: Support USB Type-C DP
 altmodes via DRM lane assignment
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

Quoting Andy Shevchenko (2024-09-04 06:00:57)
> On Tue, Sep 03, 2024 at 06:20:14PM -0400, Stephen Boyd wrote:
> > Quoting Andy Shevchenko (2024-09-02 04:35:46)
> > > On Sat, Aug 31, 2024 at 09:06:44PM -0700, Stephen Boyd wrote:
>
> > > > +     adev->dev.of_node = of_node_get(parent->of_node);
> > >
> > > device_set_node() ?
> >
> > Or device_set_of_node_from_dev()?
>
> This is quite unclear to me. The second one bumps the reference count IIRC
> for no reason (in usual cases). Also only few drivers use that, I would hear
> what OF people can tell about this API and its usage scope.

Sure, but to be equivalent to the existing code from which this has been
copied it should use device_set_of_node_from_dev(). Seems fine to just
use that.

> > > > +static int dp_lane_to_typec_lane(enum dp_lane lane)
> > > > +{
> > > > +     switch (lane) {
> > > > +     case DP_ML0:
> > > > +             return USB_SSTX2;
> > > > +     case DP_ML1:
> > > > +             return USB_SSRX2;
> > > > +     case DP_ML2:
> > > > +             return USB_SSTX1;
> > > > +     case DP_ML3:
> > > > +             return USB_SSRX1;
> > > > +     }
> > >
> > > > +     return -EINVAL;
> > >
> > > Hmm... This can be simply made as default case.
> >
> > And then the enum is always "covered" and the compiler doesn't complain
> > about missing cases (I don't think we have -Wswitch-enum)? Seems worse.
>
> Hmm... You mean if I remove one of the above cases I will get the warning?
>

Yes.
