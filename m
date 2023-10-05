Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFBC37C9D
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X+RSKIEV"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b9c907bc68so13919281fa.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 10:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696526336; x=1697131136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4qtwUC5OWXLWsxsdHc8Vyp8jChtnD5xWpTwtPZAf1Y=;
        b=X+RSKIEVg+RDdRit+d9sIPX8/92sYOzO0+Gkn9V3z/Cuns2DFbToEXBAstb0UxQ2kO
         cjV0sv43eZyUQFBnr09spxPgl2eNsoZToTIcL7CM2wVNATF5eVghom4EHj0IPhEvkywI
         a13MlkGvwR3Ciwpqd9V4S2FJp+oHFQIQ2cvz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696526336; x=1697131136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K4qtwUC5OWXLWsxsdHc8Vyp8jChtnD5xWpTwtPZAf1Y=;
        b=d+VDPLUS6c7q3j4c5YWEzAT8MAkxo8l/Pyyh+yuWdx+rADxY7HLV+49XUMEcHjVqkf
         ICo8ZnrmTcPT70QTJhGc+Mxr5NvOHHmMKq9BmoBG+XOfLjc/XiRellQJeKLrbA9KMBH1
         MwZzlU55BjznNIH/GCFyBWwu7mmNoxpob0+pQY1V8IdicvF1YkvOIAyxLdW1y2jZN4O8
         LCux+LGzOU1FWWEti4mf7Q7653ccrdw1UA5Kxdql6BKL0e0ejlOLXR6AgAj8xYtSAkpn
         akDWc4qZX43CizgPOGcGbrmAbYdVRmf84/R7He3rdiW31HkHPZn03MaBr8jK+0V8q6+O
         YoPQ==
X-Gm-Message-State: AOJu0YxmUdBMYv5WIr6jYagiPZ8pFVajdlFzqu49cyqNt/CCQsqqtr5z
	J+HnXUIELLYV4XTpr+w4Y9EZ2155utU6RA/VjTbhWA==
X-Google-Smtp-Source: AGHT+IGz3dfXxzyBA3mj6bpkuScOj2CsByPZVzGVOuypWZVASQXSq77oLaNIiQZy12jlFuvTXd6MBb+9Nrb2xXw8Z0k=
X-Received: by 2002:a05:6512:2030:b0:503:258f:fd15 with SMTP id
 s16-20020a056512203000b00503258ffd15mr4793359lfs.20.1696526335763; Thu, 05
 Oct 2023 10:18:55 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 5 Oct 2023 12:18:55 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U2dza-rxV=YtcfJwUY-gZw5FrCyn0NahOxvXJW2J2-vg@mail.gmail.com>
References: <20231002235407.769399-1-swboyd@chromium.org> <CAD=FV=U2dza-rxV=YtcfJwUY-gZw5FrCyn0NahOxvXJW2J2-vg@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 5 Oct 2023 12:18:55 -0500
Message-ID: <CAE-0n51LJDgop-Nh+Aq1CTiu7xJZOqOsdSvHMmXzshkRKM3dgg@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: ti-sn65dsi86: Associate DSI device lifetime
 with auxiliary device
To: Doug Anderson <dianders@chromium.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Robert Foss <rfoss@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, Maxime Ripard <maxime@cerno.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Quoting Doug Anderson (2023-10-02 17:31:41)
> Hi,
>
> On Mon, Oct 2, 2023 at 4:54=E2=80=AFPM Stephen Boyd <swboyd@chromium.org>=
 wrote:
> >
> > The kernel produces a warning splat and the DSI device fails to registe=
r
> > in this driver if the i2c driver probes, populates child auxiliary
> > devices, and then somewhere in ti_sn_bridge_probe() a function call
> > returns -EPROBE_DEFER. When the auxiliary driver probe defers, the dsi
> > device created by devm_mipi_dsi_device_register_full() is left
> > registered because the devm managed device used to manage the lifetime
> > of the DSI device is the parent i2c device, not the auxiliary device
> > that is being probed.
> >
> > Associate the DSI device created and managed by this driver to the
> > lifetime of the auxiliary device, not the i2c device, so that the DSI
> > device is removed when the auxiliary driver unbinds. Similarly change
> > the device pointer used for dev_err_probe() so the deferred probe error=
s
> > are associated with the auxiliary device instead of the parent i2c
> > device so we can narrow down future problems faster.
> >
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Cc: Maxime Ripard <maxime@cerno.tech>
> > Fixes: c3b75d4734cb ("drm/bridge: sn65dsi86: Register and attach our DS=
I device at probe")
>
> Even before that commit I think it was using the main "dev" instead of
> the auxiliary device's "dev" for some "devm" stuff. I guess the
> difference is that it wouldn't mess with probe deferral? Searching
> back, I think the first instance of a case that was using "devm_" with
> the wrong device was commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86:
> Wrap panel with panel-bridge")? Would it make sense to use that as a
> Fixes, you think?

The problem for me is that the dsi device is registered twice. That
happens because probe for the auxiliary device happens twice. I was
cautious about the fixes tag here because it didn't look like probe
deferral was happening before commit c3b75d4734cb.

>
> In any case, this looks reasonable to me:
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
>
> I'll give it a week and then apply to "-fixes" if everything is quiet.

Thanks!
