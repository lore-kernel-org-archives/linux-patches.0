Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B40B5380F
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 21:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709156257; cv=none; b=Bs0VXDxElhbTX8hILEdjEXSMdjeetjdJk47NAV2hhiu/bFChO2d9YOQrYtHrw0kxktZ3vCqNoralrmynocZ4ZmS1tpfac392jn33roYh4noLSBurKhBV7pwwEeYPWD8cDZzE/tJGwtM5cREesZKgIdSFr5hqV3Ufn2LhkF/sAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709156257; c=relaxed/simple;
	bh=7MtaPH4mmZq/nGRB+yz9PCBbXAr4P3Ky9sNTUu/ul50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otN52gbZ1KBHMfUcw5OSSTYkJiVsxP4mtPfKRGGS/50aZyPrVU5IvrooM8r7KWYGn1z39DkA8ndVrT2QHyyBdifUjav5RZyexdAo2H8CjC6rLG8GDNm+9MIiUD+YeskZAkbMdT1rW31SLVyNwp3gk2i8W2rGIGsXa6KwjUnmHbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=nGfia+h7; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="nGfia+h7"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7da9bec3038so642469241.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 13:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1709156255; x=1709761055; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4qG/E7ig3urgZzazatHSTWk740qedvnHhyssGrklwE=;
        b=nGfia+h7MiFjK5H6kzvwfXZdTq7U72D/wZ24EjjEmU7rTs/u4HsAn39Q4Ot4S2/cn1
         VKn2RlUQlQWpJXNms3vroPC8FM+fvAYtx26/YqUH9Fl2rikEkpLCtWPiSWyHhN2sNHSJ
         OfC+g5dc59VKmAYX5wXnZ3tqOjgDwAJ8uMPUlNhXn6hEdxiCt2TcHItknjbdf3m9oVjU
         5cJHijKte/LziFJC8g7D5nHx+/JJ7ovLx+PVEygEyQaXwHzacL4X0HRdg6CQKPmg4m0u
         DMyXEY4oeVlxHY6lBpOOpB9oD0iwW8dIEczsofqa1+QEEJU7LKvf8QeOdFp2h4GBIef+
         wUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709156255; x=1709761055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4qG/E7ig3urgZzazatHSTWk740qedvnHhyssGrklwE=;
        b=on3ujWBxmVS9rnQc82LkqiSe9g08ZE1Cm0U8fhnRSd+i85ncY/wJ8emsRsKqrb7EcK
         OQFYLjfEaHy8s9AD/JSuNBgjMsIJZkc9yBvOZDTu0LD8C7GcO+CbluOHWb3VlsmTgkVw
         Fn2KobsRrJxFQOiegrPLojJSUHv+/sqDhrfqu9d6R6h4iX4AVAPljoDH3RfwcLGeo6L7
         dKbqEIDYj45g7xT1//lp1+KO5GCKPgv9y4TChOLhD0kqodTGma/vVh+eAMSdeh5k7XOp
         Ev5eYraaWTZpxxGTtkKofYRycpsHnZj0zYnWDsO2NzzOYgPn+1z3TW6k3VWRU8E1BWH5
         HF4w==
X-Forwarded-Encrypted: i=1; AJvYcCW4j1K28alFVWbViHNEf8kwEeJzSEhhcxaigaw+Gt8/VhZW3j56VuXnVmxZehqrUu9U3zJsE5rLaX0zEtlRo957otK5NG3tOg==
X-Gm-Message-State: AOJu0YwbFXkdZ5aAgTIMAsTF1tK4c4VmtUpTt5BHiRAmi3m0DgqDe00u
	+FDQAoxnvew/yP4G6FyqvTfauXKwca/tYRCQj2n6pl0Ir+N6SFsqxF+Zx2csoY+iX+TB6lJ7ufh
	fJI6DGi+Q5fyWbP5VhfAeuk+bCFApVPc9872c5A==
X-Google-Smtp-Source: AGHT+IGq+lHEgVzWoso5P1DGLN7doXiaFOo7RFZl+mOvfNuP7w1nVXfOoqkOmZ008ts9c9Z306x1EbAyL3+iorZ4ops=
X-Received: by 2002:a05:6102:21c6:b0:470:4088:fdc0 with SMTP id
 r6-20020a05610221c600b004704088fdc0mr329127vsg.2.1709156255343; Wed, 28 Feb
 2024 13:37:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240223065254.3795204-1-swboyd@chromium.org> <Zd-CJHkCHpuIEnWh@smile.fi.intel.com>
 <CAMRc=Mdapd2jTACGqm-ujZrAunRmNeJ8_3+bpsN4ieCre52yrg@mail.gmail.com> <Zd-nI9XoYW3hrPXx@smile.fi.intel.com>
In-Reply-To: <Zd-nI9XoYW3hrPXx@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 28 Feb 2024 22:37:24 +0100
Message-ID: <CAMRc=Meh4LCqdfuVhp89Xb=QVWt13a-Ynp+8PPvNEyykvUsnug@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: Pass consumer device through to core in devm_fwnode_gpiod_get_index()
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Linus Walleij <linus.walleij@linaro.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 10:35=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Wed, Feb 28, 2024 at 10:28:07PM +0100, Bartosz Golaszewski wrote:
> > On Wed, Feb 28, 2024 at 7:57=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > > On Thu, Feb 22, 2024 at 10:52:53PM -0800, Stephen Boyd wrote:
> > > > This devm API takes a consumer device as an argument to setup the d=
evm
> > > > action, but throws it away when calling further into gpiolib. This =
leads
> > > > to odd debug messages like this:
> > > >
> > > >  (NULL device *): using DT '/gpio-keys/switch-pen-insert' for '(nul=
l)' GPIO lookup
> > > >
> > > > Let's pass the consumer device down, by directly calling what
> > > > fwnode_gpiod_get_index() calls but pass the device used for devm. T=
his
> > > > changes the message to look like this instead:
> > > >
> > > >  gpio-keys gpio-keys: using DT '/gpio-keys/switch-pen-insert' for '=
(null)' GPIO lookup
> > > >
> > > > Note that callers of fwnode_gpiod_get_index() will still see the NU=
LL
> > > > device pointer debug message, but there's not much we can do about =
that
> > > > because the API doesn't take a struct device.
> > >
> > > Have you seen this?
> > > https://lore.kernel.org/r/20231019173457.2445119-1-andriy.shevchenko@=
linux.intel.com
> >
> > Clearly yes as I queued the first one in that series. The rest did not
> > make its way upstream for whatever reason. What is your point? You
> > want to respin it?
>
> It was a reply to Stephen. :-)
>

Ah, fair enough.

Bart
