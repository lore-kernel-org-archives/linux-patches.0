Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B1F59154
	for <patches@lists.linux.dev>; Sun, 11 Feb 2024 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707642043; cv=none; b=HdVxTQO+zbZvUWyI/xCB7obk7noHzMBkPfM7ZTCKhkzrEHMgUBx1o8k9aN+eDh0Fq/QgafYXrufqVtgHy2YHT9ZSNHm3my65+HPTvM1YAHZcFMOVvUx15b86GUUgRs3hmYY4wuAlb9lnCZ4ZTFer3Hy39SYbd5u/RIjkqtpaoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707642043; c=relaxed/simple;
	bh=XrHwrzxKGSdwsco+wfaSYcU3QfPkEgggvtskzGwRyCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QE/h6DbiSNkOuwSyHyEfy71/R6tIH8trVWwZgxFtUaz3ksaxYEuzGKlO8erQ5UxRkYZkxHCAMyMeAVikXoz6hygFuJr6P2hK/d5IQ3SznWLpumWX3rlfMX+q5EzpSrJMmQLT2kmK2pctepVWt4jKUKMvlULje5VQ/dm/oaZGvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q0NBVIRJ; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q0NBVIRJ"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dc23bf7e5aaso2125382276.0
        for <patches@lists.linux.dev>; Sun, 11 Feb 2024 01:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707642040; x=1708246840; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mi/SpXz7LSnm9nqKcH5GMvmtd5xZKu9gLFg7P9Q1mlg=;
        b=q0NBVIRJdiIh3g/u9lS5i08BiOR01xwz8fgm6ehYNG54+hToVMouVNSDtO1d/ZqeIf
         o+KHTxVXH1+Pix/DlNl42S6FUS9iew0hYnlxbIaG+I0OVvyOaLV4nLCTQCGsmKcqYro6
         67gTIPSSR4MeKfgp6fnEtTf/B0TC4FZq1ZxrLXAyPSxCxdajDtxH+M+2gy0eMTtE/DnM
         Ig2qG0JuM4t3SDR8w0ns3tvZKfbMwH2Soaet8ipnIxHwaGrog0NieC3zIJ2vG45/1cSv
         sFDIGDulth6eVAZxQhcp799nBaeJv5Ez9cNcNKTvNyN4DEkpfAuID5VUcpDWId2tE62C
         Kcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707642040; x=1708246840;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mi/SpXz7LSnm9nqKcH5GMvmtd5xZKu9gLFg7P9Q1mlg=;
        b=m85tMMFOinl5HrX6ratNU6vaoC4Kc2oeruU+w5//tBe/0dskx1rxZoMXtV/ZwfKP4j
         Rg2iVzMoP95WkaBIzr91alY0J4urgC86pXtbB5zvJjKmBfxctXUt9oZv2afuEWUfAZ/J
         CGHsvUeR8eDZFCi0Eg5/FUoLCJEhsViitMBoLkLVFJ10tNx/uErkR5I/pjBqsgBpK2UJ
         +BXNcfcnLAthDRlPn2rkSF/LvXkk/JGdDZI35s78HuBA7BnscRWmH4XmQ6FRDxb+H+v3
         g/4+PmlbObRlgchzDO0bXwvgUAD1D5blKWaL9nZfESfFLpweH3gzhq3hJWDsA+H4xK63
         5Fhg==
X-Gm-Message-State: AOJu0YzfR/f6EBzt1+i3pzwZkF7Iz/+kiVmtu5Ldlh8Y6j+ef7Ehc8eI
	7MZaleGq7BufGqPq9Vh+tY8biF/cMFgNqG4FYkH1ctUf1djuQNy8cOw/5JYnbVpxnVoU/Drsm1y
	GjyPue3fmAGUoPLuhXbuLcMngbpN//sUrCtlu+w==
X-Google-Smtp-Source: AGHT+IGnqXQT+rt8SOauyM3KPLwqHogauXwMjge393R11SwTd2z8GYYPmJjOl9GRzbCoKIahL5xtbQ4ROEMUeKHCI2Q=
X-Received: by 2002:a25:2fc2:0:b0:dc7:4c52:38f7 with SMTP id
 v185-20020a252fc2000000b00dc74c5238f7mr3396239ybv.40.1707642040036; Sun, 11
 Feb 2024 01:00:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-15-swboyd@chromium.org>
 <CAA8EJpo1g9QKq1skibqSj9yc3mNSfkcts9oVf_vGjVjDzVZwiA@mail.gmail.com> <CAE-0n50xu83yYoXoFYEDrkuMw_exS=UGqsU+EwtTOGZyNW+k=Q@mail.gmail.com>
In-Reply-To: <CAE-0n50xu83yYoXoFYEDrkuMw_exS=UGqsU+EwtTOGZyNW+k=Q@mail.gmail.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sun, 11 Feb 2024 11:00:28 +0200
Message-ID: <CAA8EJpp7NW0nT5vWdZcQ+A9GjreO9b20wfFBBnOZe6E6GcTNYg@mail.gmail.com>
Subject: Re: [PATCH 14/22] platform/chrome: cros_typec_switch: Add support for
 signaling HPD to drm_bridge
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Prashant Malani <pmalani@chromium.org>, Benson Leung <bleung@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 11 Feb 2024 at 10:52, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Dmitry Baryshkov (2024-02-10 06:10:31)
> > On Sat, 10 Feb 2024 at 09:14, Stephen Boyd <swboyd@chromium.org> wrote:
> > > diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
> > > index 769de2889f2f..d8fb6662cf8d 100644
> > > --- a/drivers/platform/chrome/cros_typec_switch.c
> > > +++ b/drivers/platform/chrome/cros_typec_switch.c
> > > @@ -18,6 +19,15 @@
> > >  #include <linux/usb/typec_mux.h>
> > >  #include <linux/usb/typec_retimer.h>
> > >
> > > +#include <drm/drm_bridge.h>
> > > +#include <drm/drm_print.h>
> > > +
> > > +struct cros_typec_dp_bridge {
> > > +       struct cros_typec_switch_data *sdata;
> > > +       bool hpd_enabled;
> > > +       struct drm_bridge bridge;
> > > +};
> >
> > Is there any chance that you can use drm_dp_hpd_bridge_register() /
> > drm_aux_hpd_bridge_notify() instead of implementing another
> > drm_bridge?
> > If something is missing from the existing implementation we can
> > probably work that out.
>
> Yeah I think that can work. I had put the drm_bridge in this driver
> because I needed a 'struct device' per DP phy, but I think that problem
> goes away with an auxiliary device, so that is nicely solved.
>
> I'll have to add logic about typec ports to that auxiliary driver
> though, like mapping data-lanes and handling lane assignments. And then
> I'll move this code from the cros_typec_switch driver to the
> cros_ec_typec driver so it can be called outside of the typec mux set
> path. That's probably better because it's sort of bolted on to the
> cros_typec_switch driver. We'll need to know if the DP phy needs to
> handle orientation or if the EC is doing that somehow, so probably I'll
> need to add a DT property to the google,cros-ec-typec binding to
> indicate that orientation control is needed.

I still haven't fully got into your usage of data-lanes. I hope to be
able to comment on that part and on the ports / endpoints tomorrow.

>
> It looks like I should add a new auxiliary device, like
> 'dp_typec_bridge', and have some other function like
> drm_dp_typec_bridge_register() for that. I can wrap the 'struct
> drm_aux_hpd_bridge_data' with a 'struct drm_aux_typec_bridge_data' and
> then the typec port information can live there. HPD can still be
> signaled with drm_aux_hpd_bridge_notify() but other functions can be
> used to set the active typec port, e.g.
> drm_aux_typec_bridge_set_active_port(), and then get orientation with
> typec_get_orientation() in the atomic_check().



-- 
With best wishes
Dmitry
