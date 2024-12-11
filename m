Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02A1EC4C7
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 21:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952120; cv=none; b=Sv45JMerK5j46AXMOYo526hanW1fmdlkBIh9WMekq8a8rh2TH9aN6NSfil2zxXZkBVYEpDUmlt320yH6DSLysX7Zy2Gy0e+xnm8306tgitaD7coXJ8TOuQg9QwMjq0bWNDH/V1HfvMm3+M/0I+/OlWqBmwDvrPacxtU0OPTjiO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952120; c=relaxed/simple;
	bh=n0KCyGqSL5oapRSBhlfukCbAuOyAuMPivoVisArJl+M=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tUZudF86ekBbsCK7kLRdV6hjCoxnpX1HQJ8Tf/x76HDGtkG9nrgWTV/Hq2SDPvFEEZLBaON7rYvuvoVLrLyl8eOVqXfKepzI/+eHY4BI5LTSn/RMS33072Ll9ZS9Vk8IvZ3NfxUmTNRLVhrd0hP1TDxUxVQfLqACx6SDJFjEV1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=nD1xElWy; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nD1xElWy"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6ef7640e484so85372307b3.3
        for <patches@lists.linux.dev>; Wed, 11 Dec 2024 13:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733952117; x=1734556917; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n0KCyGqSL5oapRSBhlfukCbAuOyAuMPivoVisArJl+M=;
        b=nD1xElWyUilBJQY4dzSwW7ydIH3peg6tITKhKljyc4DQEHZaNR27z2bzhBFAqlgH3x
         XKNf+iO0Q5e9pwk/a+hwv0l94acJZsA0D/c3SznbdDDCSTov4qvgup4G2uGmDjWv6Gdj
         6WkrcSW5BPr5FJIT2IZzTof860hB/DwOj9SoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733952117; x=1734556917;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0KCyGqSL5oapRSBhlfukCbAuOyAuMPivoVisArJl+M=;
        b=pJU6ed2f0bd/rip6CnX6Upulf6yrZ30AMIGqb92UlfGJ7Ja+6lYWiUw/UcGsTndm1r
         pAkv8HS6X38oTtXBK+Dc3N2vRgtOQXeZRPgfZSzy4FZgCQ6qXsFRTumzRED6/IpzDpau
         gIlez/qI8PGSUGroKl+MBwovx7ISMzDn40wBFi/ccdsKUmGbxI8reApZZBIk0C8Hpota
         WOuYxhOUky1qe/bJAcc04J4sgCL3nLQwwArJtBpUMCgDReTt42VP7zoKzUhtzgLHlnOR
         /Wbl/epEAuASjXApr9t68M9JB8KQqBmPiFPus01+ol1hKAzlzkbSjb9GmSYLVrKagfRF
         sXQA==
X-Forwarded-Encrypted: i=1; AJvYcCXqEYZ/OnKkOMXxyIrlwY/x0Z4t/81/NJDUdhgpjWsNjnkgt9UIzJNaU+2RJ6dp9QBJ/r7TfgUE@lists.linux.dev
X-Gm-Message-State: AOJu0YxDjHLLN4tHxgzEgC0MMCkvXGRI+Iyyjk8BlzyyaR0mPfILpj9p
	lhwiBU8H9Mssq395wozgW6D16+FHiHm+2wVpMDJR93SQmHXuMHm6MHHwoXabh3b33DRh9mKjXNz
	avnnOIabV+UQtD3Eeqcp+6T2WdH0HzyckNdFf
X-Gm-Gg: ASbGncurdyqwSyvuGeHs6tt5d2/Qih+4Loq0jqQJbzUo28KewpBuiFvvMHduWCUjHPK
	sX3leu0SbDYjISVwrQBcJh2WYS9k8fMyahl2o2XdncOtRHULBJ8Wm5ymMneIkgww=
X-Google-Smtp-Source: AGHT+IEOpRCkZGb0mjL6N5K1OyWZ7lwzUq/9xZP89m+PnB//8BwUpGSf7eNg+mNPOjGTasCVPWXdK3o+/j/FVah3RXc=
X-Received: by 2002:a05:690c:ecc:b0:6ea:7afd:d901 with SMTP id
 00721157ae682-6f19e4fe961mr11687997b3.18.1733952117669; Wed, 11 Dec 2024
 13:21:57 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 Dec 2024 13:21:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAA8EJppVgw1Qb4kGY1Y-A3-KrinKfX2zGUuwMCY_-gG96fgocA@mail.gmail.com>
References: <yk3xidaisbd56yndaucax7otijjauqmm7lqm6q4q633kdawlqo@qaq27lwxmvwd>
 <hqmx7jtkvrwvb27n56hw7rpefhp37lhr3a5fawz7gsl76uuj5s@h7m6wpdhibkk>
 <CAE-0n50y1O2C47zOGJPmMjKXK_m6a=jhpEAP4nW+RymZbo2xyg@mail.gmail.com>
 <5kisfv22tgqwzjpxqrbx56ywr7l4r7pny3pl2r7crv4rijqbwk@azricdasttg7>
 <CAE-0n50Bxi2GfnxOmMwe-F+k5jMSiyAVPDb6K8pYm-i6hpJTOA@mail.gmail.com>
 <cartdeijkv6z23dgm7uif4lti3lahfqmuyxcmruzqbefhsp6yk@m6ocjhncs2ko>
 <CAE-0n51-QLLje0f7T4p3xK6Q-FRk4K0NUrVVm4cxkKoevuzktw@mail.gmail.com>
 <kidsjzklpxvvamct3glvoawavoi5mjuyh3on5kbtfp6gavwxxn@eack224zuqa3>
 <CAE-0n52F+cvVyXm8g8idN2eMfx4bpaEpWQRchr8=AO87N7E3fg@mail.gmail.com> <CAA8EJppVgw1Qb4kGY1Y-A3-KrinKfX2zGUuwMCY_-gG96fgocA@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.12.dev1+gaa8c22fdeedb
Date: Wed, 11 Dec 2024 13:21:56 -0800
Message-ID: <CAE-0n50D40VWOsgnNqKzJR=GG44SKcps5mZb-HM=aix7XYn2hg@mail.gmail.com>
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

Quoting Dmitry Baryshkov (2024-12-11 13:16:56)
> On Wed, 11 Dec 2024 at 23:11, Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > It is pure DP. Maybe we can have a google,cros-ec-usbc-hdmi compatible
> > string here because this is a weird design.
>
> Just google,cros-ec-hdmi for the corresponding connector?
>

Sure.
