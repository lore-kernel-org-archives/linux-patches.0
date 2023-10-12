Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B21262B2
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="j4HOvHct"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-533c5d10dc7so2134553a12.3
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 09:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697129055; x=1697733855; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z24YZGqTCXcSjZw7pVvFeMUQZsyzVXoHF/bkKgAPfjE=;
        b=j4HOvHct7R+phqTNy9xJ5a3WJ4DeCRdA5k/HweyKTRitnPkwvmoqVR4cEDsicOR8vZ
         4MKukIjzil3ZgHcFkQA11qtzQLEzRBHZe4bM0/pvMSN3CwtjLsP6YAe1I0Oqi0HCuIfW
         B56CboEWxoFzHngFq+xE3vyf8v4YqWzWlGYSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697129055; x=1697733855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z24YZGqTCXcSjZw7pVvFeMUQZsyzVXoHF/bkKgAPfjE=;
        b=p2RtLGNMWJaXpLwxrxLassYPjFqMZLiYTNKPoAWZRkHrEo5Q+oYSeAWReUxxRKQCpi
         NFMZErpVH0sxMQRBYBmRkBzDZo8TgAdc23BGT6J9ePNB3ggabDbtr25TQKkPKFkEnTFZ
         WzN6PjwiPINADA84N8qayQntlqwdusnkGF3IbwAsSCD3ZoWlmffjUz0piJ5z5qb9zUDu
         p3ieysXidYT3WRf9hyNoM76EUQo1BkJhg+j9tYKkegTrL//DSRfFZJrxPuQdNMa5N1cv
         FlxdnYjjixqK3otixivqAEMzzLgNP4yDZk9asAKZWBMyqi5k9rxRfbx2KwURTWOt6DOZ
         0mGA==
X-Gm-Message-State: AOJu0Yxvxp8AnL3WC/jKgSsSlZiGiUngUqJ6SO1Ty8vn1RGvY/DOCuZc
	DSier9s1rktWXKSE4doQe3hH3HScNPy7io8UTGUzVg==
X-Google-Smtp-Source: AGHT+IEE1lQ2a4XFTa6fs02M6fPA/U7+RVUadlT8dW3OMrIMuWFjfHtwOyU8fHvVoOKlW/oN46LccQ==
X-Received: by 2002:a17:907:2cd4:b0:9ba:3f18:8ae5 with SMTP id hg20-20020a1709072cd400b009ba3f188ae5mr6473068ejc.60.1697129054993;
        Thu, 12 Oct 2023 09:44:14 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id u20-20020a17090657d400b009b97aa5a3aesm11277580ejr.34.2023.10.12.09.44.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 09:44:14 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4053f24c900so225e9.1
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 09:44:14 -0700 (PDT)
X-Received: by 2002:a05:600c:1d10:b0:404:7462:1f87 with SMTP id
 l16-20020a05600c1d1000b0040474621f87mr293864wms.6.1697129053819; Thu, 12 Oct
 2023 09:44:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002235407.769399-1-swboyd@chromium.org> <CAD=FV=U2dza-rxV=YtcfJwUY-gZw5FrCyn0NahOxvXJW2J2-vg@mail.gmail.com>
 <CAE-0n51LJDgop-Nh+Aq1CTiu7xJZOqOsdSvHMmXzshkRKM3dgg@mail.gmail.com>
In-Reply-To: <CAE-0n51LJDgop-Nh+Aq1CTiu7xJZOqOsdSvHMmXzshkRKM3dgg@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 12 Oct 2023 09:43:57 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UGP9L341iDd44rUPKf_jZ5Y6qodPKZ_BLgMq-HnkBmbQ@mail.gmail.com>
Message-ID: <CAD=FV=UGP9L341iDd44rUPKf_jZ5Y6qodPKZ_BLgMq-HnkBmbQ@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: ti-sn65dsi86: Associate DSI device lifetime
 with auxiliary device
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Robert Foss <rfoss@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, Maxime Ripard <maxime@cerno.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 5, 2023 at 10:18=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> Quoting Doug Anderson (2023-10-02 17:31:41)
> > Hi,
> >
> > On Mon, Oct 2, 2023 at 4:54=E2=80=AFPM Stephen Boyd <swboyd@chromium.or=
g> wrote:
> > >
> > > The kernel produces a warning splat and the DSI device fails to regis=
ter
> > > in this driver if the i2c driver probes, populates child auxiliary
> > > devices, and then somewhere in ti_sn_bridge_probe() a function call
> > > returns -EPROBE_DEFER. When the auxiliary driver probe defers, the ds=
i
> > > device created by devm_mipi_dsi_device_register_full() is left
> > > registered because the devm managed device used to manage the lifetim=
e
> > > of the DSI device is the parent i2c device, not the auxiliary device
> > > that is being probed.
> > >
> > > Associate the DSI device created and managed by this driver to the
> > > lifetime of the auxiliary device, not the i2c device, so that the DSI
> > > device is removed when the auxiliary driver unbinds. Similarly change
> > > the device pointer used for dev_err_probe() so the deferred probe err=
ors
> > > are associated with the auxiliary device instead of the parent i2c
> > > device so we can narrow down future problems faster.
> > >
> > > Cc: Douglas Anderson <dianders@chromium.org>
> > > Cc: Maxime Ripard <maxime@cerno.tech>
> > > Fixes: c3b75d4734cb ("drm/bridge: sn65dsi86: Register and attach our =
DSI device at probe")
> >
> > Even before that commit I think it was using the main "dev" instead of
> > the auxiliary device's "dev" for some "devm" stuff. I guess the
> > difference is that it wouldn't mess with probe deferral? Searching
> > back, I think the first instance of a case that was using "devm_" with
> > the wrong device was commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86:
> > Wrap panel with panel-bridge")? Would it make sense to use that as a
> > Fixes, you think?
>
> The problem for me is that the dsi device is registered twice. That
> happens because probe for the auxiliary device happens twice. I was
> cautious about the fixes tag here because it didn't look like probe
> deferral was happening before commit c3b75d4734cb.
>
> >
> > In any case, this looks reasonable to me:
> >
> > Reviewed-by: Douglas Anderson <dianders@chromium.org>
> >
> > I'll give it a week and then apply to "-fixes" if everything is quiet.
>
> Thanks!

Pushed to drm-misc-fixes leaving your existing "Fixes" line:

7b821db95140 drm/bridge: ti-sn65dsi86: Associate DSI device lifetime
with auxiliary device

-Doug
