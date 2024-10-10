Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08001E491B
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 22:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728600218; cv=none; b=lnLctVeP1NuOdPNXICtU/YyNVYCyEUmVzHXqhDQnLEIT+IMom4ybzqXwh80nB0Y/BkCETtGvL6YlLH9CJ4PwceORcZRZvx5uxjQzbNaNzDEZ+jZO1q5bTGe+I3bMQJgFOvDbQNRscnTBSFJnqDjPiTfEjQwmRb35N/4EaowBMBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728600218; c=relaxed/simple;
	bh=rRcI0RUw1Jag1h85kqXKMUNy1mgQSNv3nPlsJjUAN+8=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bBe+JiZWD1o3emR93/ZDjZ1tqzT1PHW+octzQG/8l3j+NLqszivrsvpRSDozWJYaxkCsSfdb1rROl44YzNSdKYRrs93dsJoGew1aqJXqZLZrS7M2OVoFBi8j99v2+bVmEwx50mViZLt/4mmeB0aXM4F0ZHE0eZKWZ48Hqql0ElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oMM74/JL; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oMM74/JL"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7b1123f8f9bso123723385a.1
        for <patches@lists.linux.dev>; Thu, 10 Oct 2024 15:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1728600216; x=1729205016; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+7kS0OwpIJ8lzGVa/z5he+FP7V/PyYuqC5d6o/YyS+0=;
        b=oMM74/JLCMmYnC4JuL2ijZgPnkYvVn7S/wl+KdrN/4IOE1nZMAT73WXpkw2MriZFEC
         BaQRG9YOHf29PHuTJnU3kPZArNSm8pr7nJ+I3Lo+uEZaap8j8gSZ9HFoazl2aTeblY+Z
         SZJlx6JE3MS1QlaeV+LZcpQfeQuSXbtdfYOQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728600216; x=1729205016;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7kS0OwpIJ8lzGVa/z5he+FP7V/PyYuqC5d6o/YyS+0=;
        b=VzzzjT1hv+J7dJ/RoFdgFHeR6F8pm9T/A3ZeboBCTNyh+LevyTgj0bFiTb4NyXA8FU
         mnXdYYXbZkmAvjiSwYJK5R1Pgeo78spcPkX37v94TDPKrVDK6GRH5HZ/uXmh6H4gNMkN
         l04+1F6AtUWrYWY0AivRQKpw1JhGw7YiMIVJdb0IiLp0JV500Y5vPSzAgctomK4Ezkdh
         3wHXnrlnJ7s92IQoEgcEL8WTayxGovVypmFIKHKQUnB+ixNyC8lBic1Yy1odG+DfRbVY
         rvMcwhcUzkiMskQItwUJMZuEqXjwu+YBo1gjPUU7wvM4JEShZYM295nDUrolxhFYqCJA
         LaMg==
X-Forwarded-Encrypted: i=1; AJvYcCX0y9Tfu6klw1ys4eGbFqbqM1gi3cTzQ23Tnx3Og/7Tz4pjrLW0yYS4KVPbPx+epynhBQmFu1ku@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy1Mt9AVwztBdmv2nneamBFf3HljuChgc98ZnDIF+BXnEVyzPP
	ti/7grdCCYc07zuLTD2RhEwERAf1d060lOuQdMQbjw5rSCsu3VT9Yv18RWzp2ePiqtCHOm9ONqV
	GovwcmHHJwuPAv6/uSy9k0YYsLjyYjODy/pOj
X-Google-Smtp-Source: AGHT+IGgeD8OWkjTN2+txsFq08VyD7ih43EBc2xXYlKwMPaCKAPaVrQbOpHLD8TgOLBOWOgI5H4Qck7keHxdPo9DUQ0=
X-Received: by 2002:a05:620a:460f:b0:7a9:aba6:d012 with SMTP id
 af79cd13be357-7b11a37c515mr97106885a.22.1728600215870; Thu, 10 Oct 2024
 15:43:35 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 10 Oct 2024 18:43:35 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <27acewh6h2xcwp63z5o3tgrjmimf4d3mftpnmkvhdhv273zgsp@i6i5ke4btdqx>
References: <20240901040658.157425-1-swboyd@chromium.org> <20240901040658.157425-14-swboyd@chromium.org>
 <27acewh6h2xcwp63z5o3tgrjmimf4d3mftpnmkvhdhv273zgsp@i6i5ke4btdqx>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 10 Oct 2024 18:43:35 -0400
Message-ID: <CAE-0n53S2dFz74_rgx22_1i_bbEC6kj1SL5LAEq_F2wrdCgBNg@mail.gmail.com>
Subject: Re: [PATCH v4 13/18] dt-bindings: usb-switch: Extend for DisplayPort altmode
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

Quoting Dmitry Baryshkov (2024-09-19 03:40:19)
> On Sat, Aug 31, 2024 at 09:06:51PM GMT, Stephen Boyd wrote:
> > diff --git a/Documentation/devicetree/bindings/usb/usb-switch.yaml b/Documentation/devicetree/bindings/usb/usb-switch.yaml
> > index f5dc7e23b134..816f295f322f 100644
> > --- a/Documentation/devicetree/bindings/usb/usb-switch.yaml
> > +++ b/Documentation/devicetree/bindings/usb/usb-switch.yaml
> > @@ -52,6 +52,14 @@ properties:
> >            endpoint:
> >              $ref: '#/$defs/usbc-in-endpoint'
> >
> > +      port@2:
> > +        $ref: /schemas/graph.yaml#/$defs/port-base
> > +        unevaluatedProperties: false
> > +
> > +        properties:
> > +          endpoint:
> > +            $ref: '#/$defs/dp-endpoint'
>
> Is it a separate port or is it an endpoint of the same upstream-facing
> (non-connector-facing) SS port?

I don't quite follow this comment. This is an input DP endpoint/port.

>
> > +
> >  oneOf:
> >    - required:
> >        - port
> > @@ -65,6 +73,19 @@ $defs:
> >      $ref: /schemas/graph.yaml#/$defs/endpoint-base
> >      description: Super Speed (SS) output endpoint to a type-c connector
> >      unevaluatedProperties: false
> > +    properties:
> > +      data-lanes:
> > +        $ref: /schemas/types.yaml#/definitions/uint32-array
> > +        description: |
> > +          An array of physical USB Type-C data lane indexes.
> > +          - 0 is SSRX1 lane
> > +          - 1 is SSTX1 lane
> > +          - 2 is SSTX2 lane
> > +          - 3 is SSRX2 lane
> > +        minItems: 4
> > +        maxItems: 4
> > +        items:
> > +          maximum: 3
>
> What is the usecase to delare less than 4 lanes going to the USB-C
> connector?

I'm not aware of any usecase. The 'maximum: 3' is the max value in the
cell, i.e. 0, 1, 2, or 3.
