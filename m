Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CC113CA8D
	for <patches@lists.linux.dev>; Fri, 23 Aug 2024 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724446048; cv=none; b=ucpXVm3FFTm7PGh+vRFXeuGE1HbxAE1WFWbDx7mbFAm0KsBZP3mwz1gp532MnCMB1duVM1WScK3sbuff1Q2fWhUzK8ynFJaixcrLvmwPpaa74SWgRDJPvYMhCuaF4kAeDocee9vyDK5UdCaobgocO2uvdXPIBcsvz9vI0NGaZsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724446048; c=relaxed/simple;
	bh=0/5plbUShzyN0Lwayk1yBVoG0xyAy2FiSidykukxaik=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcZ/U5mj+S3CcILFaF9aGVchHWr//bt2DsqWGogwjttlXGP3j73YiOTL0S/whA6JqNVIOkv+JyLTEpfAdYbVpMwfRhQV3Z0vAXnU/cGPFqUBkw+t57S9e7p9ZOw2uYVNJMYtYo6NMdIIepEBsa842RxXH6H1dPa75sckMOMXhuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jezZBnet; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jezZBnet"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-27045e54272so1784724fac.0
        for <patches@lists.linux.dev>; Fri, 23 Aug 2024 13:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724446044; x=1725050844; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZiKFaKcOy5uMCUP9iI4bnV8rWlMx58uhQ+Bp65JxBY=;
        b=jezZBnetKX+qYzYoiv8U9AiKJQOTB2izcRKveNZKC6yrPju/c7AhQiuVZKLpHuuLo4
         GSb18QpfJ9zrliC3UoR55AyRS53HZXRVzAOzI9Rey4YVzAjVsDSoFEzCv4XBKsPNeFRX
         EX6GPNeuumdoMAvZGB8ZD/XNlbLu+C1eAIsCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724446044; x=1725050844;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZiKFaKcOy5uMCUP9iI4bnV8rWlMx58uhQ+Bp65JxBY=;
        b=Z10Q6ydk2tIYOw9vBTbI3kWHvvE8PxDIBJokzn+FPDDVnBX/szCK/nFnrMEVz9JRP4
         9/xur/gi92BbWlvo93Nqt3I7nslHsl++wVmHwln1YLyzNMRv3bhNHE/m8PKaxLZ/hPUF
         tB6m0UGeVvvVDq5ze+TG2BowU2rsOnvluHqUDQyBeShPMSQHJgkR/JdI0s0JWfLcT3CS
         nSmB+zQq4uNc35JWs0HnH0pS5qK3RU8HPAGeGnasATGD/OmvwawKWbM3amN9mX0KD+eK
         /dX5DD6ohjqagEoIyUEEsNY3Wxb2sw41sLuZ0hPoADCoLKe5CjEkZUOv5J6Gr4h8lD65
         QLoA==
X-Forwarded-Encrypted: i=1; AJvYcCUE02UNHNcvA3lI9SGfXkaOKN2F7T4bkRWaU2D4lQN6HgNOrXfniM0BOp7WDkXV453PsLmGp3j6@lists.linux.dev
X-Gm-Message-State: AOJu0YwV9S/WBIpIc0D39eEGlDr/Gf42Dnc2bUFv+RSi1HD8A6ud5T0Z
	77B6DOkRWUopzW4yaoN6+6nqzVPbcEoGK4LBEV6hlJB5aiSu4ei6wXiNwV8gxarfXR6ryV2Mvkn
	Hxmzh3GH7RsRg/rfKC3CxZqC2CpVeoxs0b+gk
X-Google-Smtp-Source: AGHT+IGtmJ+gyuELHaRH+RZ4qvsU8Rp6JLHoxTqxGD2FO8wzaNQZtxGnVU0BhE1HT6iEWRSosj9gW6Yp+4g8GcNpGbY=
X-Received: by 2002:a05:6358:248b:b0:1b1:aca7:dad6 with SMTP id
 e5c5f4694b2df-1b5c3a4e8abmr336937055d.11.1724446044234; Fri, 23 Aug 2024
 13:47:24 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Aug 2024 13:47:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZsdMoRpwv5twOwqx@tzungbi-laptop>
References: <20240819223834.2049862-1-swboyd@chromium.org> <20240819223834.2049862-16-swboyd@chromium.org>
 <ZsdMoRpwv5twOwqx@tzungbi-laptop>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 23 Aug 2024 13:47:23 -0700
Message-ID: <CAE-0n50MVaU2dmRLdLVFWT9KWPO_BK-L7eEqGRSb8TKm1KtPNQ@mail.gmail.com>
Subject: Re: [PATCH v3 15/17] platform/chrome: cros_ec_typec: Add support for
 signaling DP HPD via drm_bridge
To: Tzung-Bi Shih <tzungbi@kernel.org>
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
	Thomas Zimmermann <tzimmermann@suse.de>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Tzung-Bi Shih (2024-08-22 07:35:13)
> On Mon, Aug 19, 2024 at 03:38:29PM -0700, Stephen Boyd wrote:
> > +struct cros_typec_dp_bridge {
> > +     struct cros_typec_data *typec_data;
> > +     struct drm_dp_typec_bridge_dev *dev;
> > +};
>
> It looks like structs are all defined in cros_ec_typec.h.  I think this struct
> definition can be also moved there.

I put it here because it wasn't used by any other driver. Maybe I can
skip the entire struct though and add what I need directly to 'struct
cros_typec_data'.

>
> > diff --git a/drivers/platform/chrome/cros_ec_typec.h b/drivers/platform/chrome/cros_ec_typec.h
> > index deda180a646f..73d300427140 100644
> > --- a/drivers/platform/chrome/cros_ec_typec.h
> > +++ b/drivers/platform/chrome/cros_ec_typec.h
> > @@ -27,6 +27,8 @@ struct cros_typec_altmode_node {
> >       struct list_head list;
> >  };
> >
> > +struct cros_typec_dp_bridge;
>
> If the struct definition moves here, it doesn't need to declare forward.

But then we have to forward declare 'struct cros_typec_data'? There's no
escape.
