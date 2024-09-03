Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1B19CC25
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 22:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725402947; cv=none; b=ZUh2lX5G23nBqYn6dF1fKVbEJVLwlAAe1+0gduJZ+1lVm3Kdofz3TLVrZVJsqqCLRfA37lRIq4WmBLLDjBCwUXao5T3B3gLWyNzeq8YEzZCEZXE9s+jyD7mBSPEchDqqX7pg4wuQ78IhbUJYDOStQr6pjGMBqrKwmg8ejRCljdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725402947; c=relaxed/simple;
	bh=Np+Q0wHOCgirMFjVPl8Z6i7/K3O+RkvC3vKi9xQ+BOA=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gyd2Fh4n9et1bnYaDx6DMT2c6S6BOrCEuvCbd2DvyYH7nX1IEsqkg3KACP8gc2aDGc/HtdV7JMy33J7EoMnr4VUJvE2E3aKecDxluUKxlBias2EBf2GjF8wL+WtHZJMlsTHXIiVAIby142QmC0tEIJvWs2HrGK06fOD5642HsAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=H+32Mf4w; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H+32Mf4w"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a81309072dso288730185a.0
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 15:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725402944; x=1726007744; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Np+Q0wHOCgirMFjVPl8Z6i7/K3O+RkvC3vKi9xQ+BOA=;
        b=H+32Mf4w85KbDUW+1lL7W/wLdCSraLJ5zOxfqfFYR+AyBqLdrdUGbt32l+DWU6F8aw
         ch7cA6rgsJHIuZxTz123dTaSqDqIYW6QWu4tdYLTN3jgVxpoA8B0c0BYXMsemIyh32bN
         YO5Qb0JPYd5Q78Kx/FKnHSMp+gKb6ChH08o/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725402944; x=1726007744;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Np+Q0wHOCgirMFjVPl8Z6i7/K3O+RkvC3vKi9xQ+BOA=;
        b=w7iaWMC1X9o7O1KnZq1WHrJydeSuMD+eelpJ7WNuSdfDToDqIAUCHs4nsy3hYPzFpq
         dxAu5wLXfHSmTdLhBnY/k3KDFOiM8GNsKXUWVJ9R6vzak+MKlOL0BhosMiPP6InmcXYm
         xjjFrVumwI4z3WWn6T9J2V8JunFO0at7hXnUIjHxawCTAuhlvNAqe4GGoIaZGH4pvjsw
         82DP0+iZyBChRohjpkwtgKc9bQ+HNL4xXarZZ7zJLsdgY5MPlo7pMuHpHepJT1C+gRWo
         d0IIv2EkDFBI04s76CUMdda8o3nAPHdqZ6ziZ3Kag/XjvhSxx97RE2iGaXzq090DCuFH
         lDdA==
X-Forwarded-Encrypted: i=1; AJvYcCXre7ziA3d/fTtO4q2D3zps5TQn0d+W/b0kub0WKfrGSZXVf1lQtC2WOic7o3L8e8ZJ/apAEsG8@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3AnmjQQZm/ikk0/YE/jYtc7dwpLAb86Hwt4Cgu4eqKDOo/fvt
	W3woxYKodUVqmxjWblgUQTFfDcXtWlPkan5czBZoaE8ye2Fn62J/CVqIHIF4BPgUn6vKVnc1OQ2
	WjHb+m6/CjG2Vg4YMJ9vwN2P0K1E+jNphsYmI
X-Google-Smtp-Source: AGHT+IHROkfnEqJwyKjhAgQRGsJgxkFB29+Yc6u1MFfoALprduJBtTl2Q7hk3LAUymLuEO32wO/aAKlH5269r5m9+pM=
X-Received: by 2002:a05:620a:28c8:b0:7a6:6fd6:9d6a with SMTP id
 af79cd13be357-7a8f6b767cemr1583962985a.5.1725402944498; Tue, 03 Sep 2024
 15:35:44 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Sep 2024 15:35:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZtWeuFUEgnF9e2S4@smile.fi.intel.com>
References: <20240901040658.157425-1-swboyd@chromium.org> <20240901040658.157425-11-swboyd@chromium.org>
 <ZtWeuFUEgnF9e2S4@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 3 Sep 2024 15:35:44 -0700
Message-ID: <CAE-0n51nLCNJxhxMr3EmqoWz=3dLU-ckfSwgEUtrhBRZchLu_w@mail.gmail.com>
Subject: Re: [PATCH v4 10/18] devcon property: Document devcon_match_fn_t
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

Quoting Andy Shevchenko (2024-09-02 04:17:12)
> On Sat, Aug 31, 2024 at 09:06:48PM -0700, Stephen Boyd wrote:
> > The usage of this match function is hard to understand at a glance.
> > Document the arguments and the return value so it is clear how to
> > implement the function.
>
> Thank you for the patch!
>
> ...
>
> I believe we still use "device property:" in the subject for this header file changes.
> $ git log --oneline --no-merges -- include/linux/property.h
>

Ok.

>
> > +/**
> > + * devcon_match_fn_t - device connection match function
> > + * @fwnode: Remote connection's device node
> > + * @con_id: Identifier for the connection
> > + * @data: Match function caller specific data
> > + *
> > + * Implement a callback with this function signature to search a fwnode's
> > + * connections for a match with a function like device_connection_find_match().
> > + * This function will be called possibly multiple times, once for each
> > + * connection. The match function should inspect the @fwnode to look for a
> > + * match. The @con_id and @data provided are the same as the @con_id and @data
> > + * arguments passed to the functions that take a devcon_match_fn_t argument.
>
> > + * Note: This function can be called multiple times.
>
> As noted in the next patch, this would be nice to elaborate (at least to me
> this sounds like declaration of idempotency which is unlikely what is
> meant, or am I mistaken?).

I based this on something that I've already forgotten! :)

It's saying that the function you implement shouldn't have side-effects
because it will be called many times. I actually wrote above that it
will be called "possibly multiple times, once for each connection". Let
me try to remove "multiple times".
