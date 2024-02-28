Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72170034
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 21:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709155701; cv=none; b=h1ZsxOTaFpZdsy7e3xQJcCXpPXG5m1r/3J9CJ3jlo1DlwiemsOG/hZ0snOoX9++7ZSAtw7M34x7losnEtzAVLdUFXHX54yvLifBlsk6V41sERsLi7PpelbBNRG0RSlTMdqAsMwya9aboMlTFJhb1IbyWJZKgsb3j4tGVGSpbSyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709155701; c=relaxed/simple;
	bh=Vf0do4mWmyzl8Py+ttYn8ggj8OVTVR5qdBW3AzesKNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sMweog9f06tsw8PbtItTYUudTZ/gnPFGcaOm7j+4oZeJL1XNJJKCTCgEVPIhunrUBABsqWDFZYZjOpkdhKUwAqRkwOpibAUI/72QsxV1zl2mVSCCy+zG55BZz89SwxI3GpXcBMkVId+kLRxQDgoqUFbcp3bHb1M8uzbU89S0als=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=r1I2XPlH; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="r1I2XPlH"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4cba3807eedso129790e0c.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 13:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1709155699; x=1709760499; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P37DoC18sNGnImdksJqYN4+snHz4hsIQQAlSBf7O+w0=;
        b=r1I2XPlHh2ZABfLC/uWgiO3mt0xVm5Kmfy4HJqwC8g9UZsJUM5Dbz+n5p/OGI7zBGg
         BeQop5bwsVzFzaCUZDad56MK3/XbNaxzSQzvxIG2htAcZUJDzDtmiaWFK6Liq4jPkBsO
         HrV15aI77lV+IX59jNsfBGYMkhReYnALZoIeUm4X6FQa4ktJyM/0l5V2LtypETjaNzWM
         FRU9tFEtDQSbcvond3a02bDqp0cOPBXQJKsp7NUpf+1wvJoMCVTaECdGCPDIMeaeKLxS
         z3CAP+Y4HlEW/LmnMsUNPUUBvnH+f3BgCGZ81QZAE7rDSmLOptlH7n3klQBjhzHP0swe
         nM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709155699; x=1709760499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P37DoC18sNGnImdksJqYN4+snHz4hsIQQAlSBf7O+w0=;
        b=WopuSCmcZdUZ82vwicTKK86SJeRy2mm22TNU0DtDEj+Wv56OkvpOdKsIIfT/oNOvQd
         QOOF50LvHWmetL6wbYbbG69aBz8m1/jS0d6Lmp5M/9o5uPwLElPxmHd3dR+PV87uwdsn
         rQml7PIV3UH24pO3ZHfs8bPKsR3clOL00Zi82cQFZ/iqANo7fjMFR8+jShVc8dqCrlQj
         x51QXldu3K462/1OkjCvoB7P4lqX7hIHOXJ97MEAGzXQwYj8TKZnnnguEZizecy1FgUs
         gXXpgCVyMrOK/pslw9Y1mQAIDupG5PxeaO4mPj4i7j92PezWLBsbDPiO+T/YJ7vjf6Us
         +0Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXy6LYWM7HIcDONdtb6bPT8OaihejNlB12oC8E+eYdrC8ZYSy3aAvuyEziZOgzjnwU+Lyk4mz3wbuQxrpZ7wSfVKNNe8E3zsA==
X-Gm-Message-State: AOJu0YwEtFjD95RcsbB9LnKRWXigWH3VYbJfdKfBlCNUJUWZbb46cEyj
	JBqi1qcSKH3y6AC45hBmscWQbE25pWKecmtumYqcAdk7dVmB4S3pKTeJoRwLKfnqDZHBzA8W4Ni
	bBAMoSB+55IDrDAXARzs6KJThyqeZL+2kMdRC1g==
X-Google-Smtp-Source: AGHT+IFQ8d10DnLbr45njbzPMBBRyKRbmpCeLUJYbzk8tW1MlnCX8W5wV56Kff7cnWjI+7dxb7hh1ZtoRVhOrJxf+4k=
X-Received: by 2002:a05:6122:2891:b0:4cf:da07:fb01 with SMTP id
 fl17-20020a056122289100b004cfda07fb01mr617399vkb.8.1709155698890; Wed, 28 Feb
 2024 13:28:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240223065254.3795204-1-swboyd@chromium.org> <Zd-CJHkCHpuIEnWh@smile.fi.intel.com>
In-Reply-To: <Zd-CJHkCHpuIEnWh@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 28 Feb 2024 22:28:07 +0100
Message-ID: <CAMRc=Mdapd2jTACGqm-ujZrAunRmNeJ8_3+bpsN4ieCre52yrg@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: Pass consumer device through to core in devm_fwnode_gpiod_get_index()
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Linus Walleij <linus.walleij@linaro.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-gpio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 7:57=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Thu, Feb 22, 2024 at 10:52:53PM -0800, Stephen Boyd wrote:
> > This devm API takes a consumer device as an argument to setup the devm
> > action, but throws it away when calling further into gpiolib. This lead=
s
> > to odd debug messages like this:
> >
> >  (NULL device *): using DT '/gpio-keys/switch-pen-insert' for '(null)' =
GPIO lookup
> >
> > Let's pass the consumer device down, by directly calling what
> > fwnode_gpiod_get_index() calls but pass the device used for devm. This
> > changes the message to look like this instead:
> >
> >  gpio-keys gpio-keys: using DT '/gpio-keys/switch-pen-insert' for '(nul=
l)' GPIO lookup
> >
> > Note that callers of fwnode_gpiod_get_index() will still see the NULL
> > device pointer debug message, but there's not much we can do about that
> > because the API doesn't take a struct device.
>
> Have you seen this?
> https://lore.kernel.org/r/20231019173457.2445119-1-andriy.shevchenko@linu=
x.intel.com

Clearly yes as I queued the first one in that series. The rest did not
make its way upstream for whatever reason. What is your point? You
want to respin it?

Bart
