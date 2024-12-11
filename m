Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D820A5F9
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 21:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951477; cv=none; b=btF6f3Q15bMM6TD4Ns7/0yxd8QZFIAUoCLpmu0m99TnQSzafOgQB/FYlr5JDDPClhWD3vLlewJ7JT4dln3hVd3GQteUZVKLgn+iWlZUkLhuZwsaSaNGesec9inKNLmda59MYPBl5u1ekW6q9FhE88Vt56RdCJtWja1PSHk237SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951477; c=relaxed/simple;
	bh=fL4AZO7DuUqncD1hviX7Ju8fEoY0KFiDTXpqXPG3i0I=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nVl0LSxg2/8dDRGTHzGM4+FfBKxNR7ZE74YoVlQI3bMhugPluxPvJkOCDW3DLR2B8SpFzn7QMmZBDbCU1OoossXarbr4F196Ejl/mLfqRFFKpeV8JetbN5QJg5Z/b3dkIXSBacEGRkFzE3EvgULzxDKBgKVjylruU587fnMdS/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=nT6157Yc; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nT6157Yc"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6ef60e500d7so49692197b3.0
        for <patches@lists.linux.dev>; Wed, 11 Dec 2024 13:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733951475; x=1734556275; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fL4AZO7DuUqncD1hviX7Ju8fEoY0KFiDTXpqXPG3i0I=;
        b=nT6157Yc2zQV8aM71/ayOS7+mkGq+UQOsDYVsKHWKFDXfyBxD1OLcFoBG9eCgGKgHE
         MlAZZlWZNT5PMv9WlITd2bf2pZ0Nr+e8j+axizqeIpAAMe2nLOwXwA1SM9yvIyksWsyD
         XwYMR0R5pJIeqcQm0/A/oOL1Z/YtfQ7VRmLw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733951475; x=1734556275;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL4AZO7DuUqncD1hviX7Ju8fEoY0KFiDTXpqXPG3i0I=;
        b=ZN5x92oYpjOzK3kjv6EF9u4WSiUbDo1eBofb2ktTEiT/YlTi7Lmv61dlMZZH9oYc56
         nTkCJ+FuzdwUVWFck0HDokCvFVtzOpX+66hNH1jrOGcbUBY0JvvmDJgDJxggak8nNJnG
         6XPQWX0pB2GybClcxR1sPbmsIdorxEVW0s8PEk0MLC+HIGMaYmPIGKHc788h9B4o8/Fg
         QvOUfc+snLMyPRbPGHws7qOAwFUR/PkK3ZfeVCcpa7Q6WxH/XRh3dA0xxnfyccDMqeST
         cCUJENYxXsOR98jxh8F1fDrEoN+8KbGBxBcfvVXPCOgPseeYIcldGA9bqGTmHM/jmIha
         cBnA==
X-Forwarded-Encrypted: i=1; AJvYcCU/TQaXFGxvi0Gb9SBu7AU6WOkdMwS/mHJP3RRLTB+VOwYqCTqN3MsOcTKlY6i5wyj/aGPJdYXe@lists.linux.dev
X-Gm-Message-State: AOJu0YyzKXAupLQSyAwRXF7gf86SsyM6HFm3EZ+Qdrjdqx6UkjwZHVB1
	8hmk7aba5NQJhN78U/ZaO6dPE/UN72yfh7jQIGhmNiKtWNH6gQSr9ufzE0llH0yEFDG84CPJmGP
	qduiMH2SlWUNyvmcFQZeqSfwUqZvBG6Mbks1s
X-Gm-Gg: ASbGncvneupWXHOsL526LEbdW3vgBeMp5mJ69865R9LkoYnQ8psX9+NRJcnxvJHaxIt
	FkTRs+uE9/aN/bPQAbpFqwIOEAXuDQ6vej7hYy0X6INrsDCNQQ6iWP6x9h44JCPE=
X-Google-Smtp-Source: AGHT+IGR6ED4gGgHGmi77s2dwB+gnLghGdTv2zo6xXg1u+pxnZVS/4VVQlWKhmq+504JY9ZZ4GSEuX2qWpyqxoxUo7A=
X-Received: by 2002:a05:6902:1b87:b0:e39:7a24:a5c3 with SMTP id
 3f1490d57ef6-e3da1eed190mr753786276.32.1733951475289; Wed, 11 Dec 2024
 13:11:15 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Dec 2024 13:11:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <kidsjzklpxvvamct3glvoawavoi5mjuyh3on5kbtfp6gavwxxn@eack224zuqa3>
References: <yk3xidaisbd56yndaucax7otijjauqmm7lqm6q4q633kdawlqo@qaq27lwxmvwd>
 <gstohhcdnmnkszk4l2ikd5xiewtotgo5okia62paauj6zpaw7y@4wchyvoynm2p>
 <CAE-0n50z6MNa7WOsg-NU7k8BpFeJJyYfHX3ov6DsthLWauSNpA@mail.gmail.com>
 <hqmx7jtkvrwvb27n56hw7rpefhp37lhr3a5fawz7gsl76uuj5s@h7m6wpdhibkk>
 <CAE-0n50y1O2C47zOGJPmMjKXK_m6a=jhpEAP4nW+RymZbo2xyg@mail.gmail.com>
 <5kisfv22tgqwzjpxqrbx56ywr7l4r7pny3pl2r7crv4rijqbwk@azricdasttg7>
 <CAE-0n50Bxi2GfnxOmMwe-F+k5jMSiyAVPDb6K8pYm-i6hpJTOA@mail.gmail.com>
 <cartdeijkv6z23dgm7uif4lti3lahfqmuyxcmruzqbefhsp6yk@m6ocjhncs2ko>
 <CAE-0n51-QLLje0f7T4p3xK6Q-FRk4K0NUrVVm4cxkKoevuzktw@mail.gmail.com> <kidsjzklpxvvamct3glvoawavoi5mjuyh3on5kbtfp6gavwxxn@eack224zuqa3>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.12.dev1+gaa8c22fdeedb
Date: Wed, 11 Dec 2024 13:11:14 -0800
Message-ID: <CAE-0n52F+cvVyXm8g8idN2eMfx4bpaEpWQRchr8=AO87N7E3fg@mail.gmail.com>
Subject: Re: [PATCH v4 15/18] dt-bindings: usb: Add ports to
 google,cros-ec-typec for DP altmode
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Andrzej Hajda <andrzej.hajda@intel.com>, Benson Leung <bleung@chromium.org>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>, 
	dri-devel@lists.freedesktop.org, Guenter Roeck <groeck@chromium.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Jonas Karlman <jonas@kwiboo.se>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Lee Jones <lee@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Prashant Malani <pmalani@chromium.org>, 
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Vinod Koul <vkoul@kernel.org>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Dmitry Baryshkov (2024-12-05 10:47:08)
> On Tue, Dec 03, 2024 at 03:50:58PM -0800, Stephen Boyd wrote:
> >
> > The easiest way to imagine this is that we took the usb-c-connector and
> > jammed an HDMI dongle in there with some glue so that it can never be
> > removed. There isn't any USB going there either because it can't be
> > used. I suppose we can continue to describe this with an
> > altmodes/displayport node but then add some compatible like
> > "usb-c-hdmi-connector" or another property to the altmodes/displayport
> > node like "type = hdmi" that signifies this is a connector that only
> > outputs HDMI.
>
> Does that DP-to-HDMI bridge talk USB-C or just pure DP? In other words,
> will it be properly discovered and handled if we just leave it as a
> weird usb-c-connector (maybe with an additional annotation, we have
> USB_PORT_CONNECT_TYPE_HARD_WIRED for USB ports, we might have something
> similar for Type-C connectors).

It is pure DP. Maybe we can have a google,cros-ec-usbc-hdmi compatible
string here because this is a weird design.
