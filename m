Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D17D52F6D
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709062696; cv=none; b=bfHplvurfCylqz/Ke2OuK9gchUts5gkHVX/nzqCJlNw4qXhdgkZH2s9QhaGDTUMGJiOw10UGNRfXz5iGq8UxitARZMuGnvY1T+oLL2TCv/8Xgld2vR1KfW3sGjN4IRlrBjLWO65Bja1PFLzkGvZIkgI2HCKY+6MgBjmZ5UhXBho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709062696; c=relaxed/simple;
	bh=uXGgIR6AlyuVRK/MpaWhS5RpNMdPXETDnhac0JBD9Iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ecXUq+6qXE3id3dEJz50f1GpAlPwgyavX6RN1jVs8N0VX865VoCvmMQWIa1+lGp1if30jwv3WXpDndWE62fZmqH1oO9ylETAAnm5mcQ7sgcEY13qBs3pDL7sM0CMj3amUfKXqORT1LYLDE+q8zugyrvTyTf4LeYtdFVyK72Nvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ooUXiX/M; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ooUXiX/M"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4129a5f7b54so10245e9.1
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709062693; x=1709667493; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oshdnUJfJnWYqjpxJrbBngXlFKiFKoDWj+mV4FoHF3Y=;
        b=ooUXiX/MZp+snwbtYNdm44nwzdt2ZfC8ZsvaeZlErtXEG5kSR9tPpH9vMyrkQ8vmaD
         ACo3i3N6/0Jn349DIKOZTvskQkumbFULLYXBjBRRnFAgXeBvfvGRjBOWdcm4AHYn4Dm5
         rAav5AgD6e1tVG531R16w8nzcz5qBOMtmDj4pOhkCdocLADqWiIhit6jmPnbSLotrdIT
         xNJVJB5hFsm977KMW4/GwhnrZjHdh2VYBgkRZirHoJVuHce3bTcyl9oc4oiquepTzCN7
         gTi+FV+DonqtxJnxFLaOb2zOjVmM6vWioDEutLRiEav9DxobpGtE1aRvIFNMvaBzSJoD
         PI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709062693; x=1709667493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oshdnUJfJnWYqjpxJrbBngXlFKiFKoDWj+mV4FoHF3Y=;
        b=E28GpnGAbAcZqAWC4hAX/WYwSg/FDYTsiXpay5bTFXaVIqeH5m/GFhcBPWTemNe7VM
         a3RfEQ/+IgtrOtIJqIGBqVgABYyjj0VT9T3jjS80p2ut3zPC2MJQig6js8/pT988B56P
         XJyYqXg4m9PswVWov35syhSW+6CZckzCEEbOb887KTbrFcdy0yaOXpeUCIkEOf1QIMv7
         8SiKi7QW7CEXkQ9QKXF/XXhVDfLM92lkPguP4EX/5J16vCMWPTugksK5Zba5ZvA5uezg
         ZHcJW42y+0IfY+WzxgJJdKsYOK1eMl+b8eTSGP4bqNMKdfXEYfpL7gka5peEzFPN8Xmp
         VomA==
X-Forwarded-Encrypted: i=1; AJvYcCXRC+GsGi5rX5jK+TxZJSM5zYfXQ15r3E1K8ZnaXv+FiWmxJ+lFajX02vHU+eABHvknzegKYXiPqBrb2OcAXJXPu1dRKaJJ5Q==
X-Gm-Message-State: AOJu0Yy8R/7V9mxqUNAJQaTCTQDz3uAfXvxk+wwCkVGmgssNJOpB3EHd
	PqsE0hHICOUZ+8xQxYpAwqk+nl6Z2lsfucbBJUFZ9oDeL6v2SAzlib5HLbm+osZ/bhLW+DnNnr+
	JBuvJmM4Us/BD3ZHK3Ch4qBHHjfIBL1Y5qXw=
X-Google-Smtp-Source: AGHT+IGgE7pybhMGkAZbJpOdx6GdA8Gm2qtbM4A7vr/iWITTqkgKV0bwFGCof3F2RyX1iI9NK48sH3pjL4VfXaAkawU=
X-Received: by 2002:a05:600c:a3a3:b0:412:9829:2dd5 with SMTP id
 hn35-20020a05600ca3a300b0041298292dd5mr231716wmb.7.1709062692681; Tue, 27 Feb
 2024 11:38:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131552.864701583@linuxfoundation.org> <20240227131554.144760148@linuxfoundation.org>
In-Reply-To: <20240227131554.144760148@linuxfoundation.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 27 Feb 2024 11:38:01 -0800
Message-ID: <CANDhNCoGL7voc11QFt5rBXXibMSvDM2YxZ8ocV1fkGYh=Mm0nA@mail.gmail.com>
Subject: Re: [PATCH 5.4 39/84] driver core: Set deferred_probe_timeout to a
 longer default if CONFIG_MODULES is set
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-pm@vger.kernel.org, 
	Linus Walleij <linus.walleij@linaro.org>, Thierry Reding <treding@nvidia.com>, 
	Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>, Saravana Kannan <saravanak@google.com>, 
	Todd Kjos <tkjos@google.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@kernel.org>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Rob Herring <robh@kernel.org>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, John Stultz <john.stultz@linaro.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 5:27=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: John Stultz <john.stultz@linaro.org>
>
> [ Upstream commit e2cec7d6853712295cef5377762165a489b2957f ]
>
> When using modules, its common for the modules not to be loaded
> until quite late by userland. With the current code,
> driver_deferred_probe_check_state() will stop returning
> EPROBE_DEFER after late_initcall, which can cause module
> dependency resolution to fail after that.
>
> So allow a longer window of 30 seconds (picked somewhat
> arbitrarily, but influenced by the similar regulator core
> timeout value) in the case where modules are enabled.
>
> Cc: linux-pm@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Saravana Kannan <saravanak@google.com>
> Cc: Todd Kjos <tkjos@google.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Kevin Hilman <khilman@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Rob Herring <robh@kernel.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Link: https://lore.kernel.org/r/20200225050828.56458-3-john.stultz@linaro=
.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/base/dd.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

This change ended up being reverted upstream in ce68929f07de

Is there some specific reason it got selected to be pulled into -stable?

thanks
-john
