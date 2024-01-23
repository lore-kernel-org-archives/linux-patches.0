Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FDD5F542
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 13:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706015634; cv=none; b=C7MP3eoeMJGT+45q4RYRu4MIZCyDm4DQqIaxTM0xYeCr8D+KI4cvDpDUbxCbS0jaNt6OSbPmYCiPbCnjH3RbWdcJiaVPbD39sxHXo4LyaLOW3GIfufVpqqqWZIUA2mR1gLiV91W06Wufx/9NszINGFeCWjV2xp7zhYq+yu3CQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706015634; c=relaxed/simple;
	bh=J0H1M0wTy6ZAjcB8gwE0Ape9n7NPht8jS6c983A5reU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nrXoxuMr0ypke77g0LnmqLSI2YevrJS5E9g4Z6giGB8wPyzLiGpIsxhqVcDlv0lh7T98aGA+e15tbkFULpTvZkdaK18vXNXUB8jPtO5zDYeym79WfAjJEAwxJvfzwHmrHX/m+oqgmM8VTz79TZJ/NbLjXMiPWq6m36ix8c8wdl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W1wf/sEQ; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W1wf/sEQ"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc256e97e0aso2627429276.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 05:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706015631; x=1706620431; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDso/2Y80kbqbJKefAGut4d9dRp1m/o06w1Bs0lmtgg=;
        b=W1wf/sEQLs7/slffQFLewCz0FDBaL/+3HO9xwMlHNzv1iwCQZeLn28libMkFe9xny5
         Gy+dZbSzC3lkb0DmIQMgS7DJDbJegaRkHYPZwr051uwuXxOGeYo+sfc/0ZypXwmEz9Un
         qchieJFVvmxsDwjT9RdyoKLB/77Rpk6/Le/VQUkUmX2FuIaOJtZqJOJWIxqv3Begve3S
         0D1fdjXazN60RP+5vIfsoS416lSHFz95zNllk+vc75KaaPxelK/7rZj16EVLEq3y5uol
         qIEoboeYeTcC+sJxrZGonWZZP6Y8cupMJV5VRVmh79OtvOQRvfitYVaQ8NXWTBZIEwMH
         5elQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706015631; x=1706620431;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDso/2Y80kbqbJKefAGut4d9dRp1m/o06w1Bs0lmtgg=;
        b=CzTpiJXeIcug/Mt3isgHcmajGAP944g43i+f9P9xS+FXpJAa7/CcVqUR6TNWhTj+xW
         eYzLBfL1s14fsC6a0lIW+SFvviQH8VzkVTzoPjL31bs2VabP+6oJEU77/qauZJB+vtHo
         3UurkvqtkyzIWl88+IbQspuA3lpnP/RBybb24UH5R9cuWCeOUcPRvNdvDcIP+78V4ynP
         v0JJt7gcz9e2UeouZx3C3vThZlYPfIPP+Gox9N9mziSVrfxN6ZzCtchGhBQUSLuaTwqw
         jPH43f2OGGpLhgA0q2djooPYhwUY4hAa5HZCcn5TE0qtLZLxzIvAPwj/DP3appf30obH
         NimA==
X-Gm-Message-State: AOJu0YyvrUv0pyh8b01fE0kgoI1/RV3p8fPCmkkmfwIAfGEL0rrxD1Q9
	X1JIBK4d8ugGUJ0pR73F+oYDRqHkjIkax7qpLQCVSWFZEEGKz+CkpEUBsqnfG5tkO4nHWwAGDpM
	9d9eZ84hfSz/xUNPm6vUqO4yq+D9FS/Eyx49+7Q==
X-Google-Smtp-Source: AGHT+IHw/YsJzgw2ky7VF9P7A+DY41B8Ee51i5bTyK1wO8/iF6Ar/aP/6+RDlrSbAisT5mdkfql4kJB3twIZkNJcukY=
X-Received: by 2002:a81:ab4c:0:b0:5f8:b42d:4707 with SMTP id
 d12-20020a81ab4c000000b005f8b42d4707mr4363579ywk.101.1706015631168; Tue, 23
 Jan 2024 05:13:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235812.238724226@linuxfoundation.org> <20240122235822.085816226@linuxfoundation.org>
 <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com> <2024012314-distill-womanlike-77bb@gregkh>
In-Reply-To: <2024012314-distill-womanlike-77bb@gregkh>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 23 Jan 2024 14:13:40 +0100
Message-ID: <CACMJSevTCk+HkeBC4YbmiRrzViwBNi9r30wdDKrB8J92YBcu4A@mail.gmail.com>
Subject: Re: [PATCH 6.6 328/583] gpiolib: provide gpio_device_find()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Linus Walleij <linus.walleij@linaro.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jan 2024 at 13:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 23, 2024 at 10:56:50AM +0100, Bartosz Golaszewski wrote:
> > On Tue, 23 Jan 2024 at 03:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > ------------------
> > >
> > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > >
> > > [ Upstream commit cfe102f63308c8c8e01199a682868a64b83f653e ]
> > >
> > > gpiochip_find() is wrong and its kernel doc is misleading as the
> > > function doesn't return a reference to the gpio_chip but just a raw
> > > pointer. The chip itself is not guaranteed to stay alive, in fact it can
> > > be deleted at any point. Also: other than GPIO drivers themselves,
> > > nobody else has any business accessing gpio_chip structs.
> > >
> > > Provide a new gpio_device_find() function that returns a real reference
> > > to the opaque gpio_device structure that is guaranteed to stay alive for
> > > as long as there are active users of it.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> >
> > Greg,
> >
> > I think there's something not quite right with the system for picking
> > up patches into stable lately. This is the third email where I'm
> > stopping Sasha or you from picking up changes that are clearly new
> > features and not fixes suitable for backporting.
> >
> > Providing a new, improved function to replace an old interface should
> > not be considered for stable branches IMO. Please drop it.
>
> Even if it is required for a valid bugfix that affects users?  This is a
> dependency of the commit 48e1b4d369cf ("gpiolib: remove the GPIO device
> from the list when it's unregistered"), shouldn't that be backported to
> all affected kernels properly?
>
> thanks,
>
> greg k-h

Eh... It is technically a fix but also this has been like it since
2014 and nobody ever hit the bug (or bothered to report it). Ok do as
you wish with this one.

Bartosz
