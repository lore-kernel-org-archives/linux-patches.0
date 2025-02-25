Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533F52586CD
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 07:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740468559; cv=none; b=HcxXmY5yUDyLg0ZOSYmKhN5bIKsanFTueawDuBsnLdp3rLgCUgZS3n2+8wJHbi5YNJDA5AI8HNZoeWkRGlfgy/6V/f/CIl2CcH5e3wfkiIkmzWMB0cXjelh40HO/zm8ZmTFlR3OpKvQ351N9S1yu0EblDK4apYdBbcSSK1jU4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740468559; c=relaxed/simple;
	bh=zIvaaoQGm7KtfdZ12vZ6A5bV0odA8xANuXpTVcfAHfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+QjnFMKdpPBkyLW05Hh4EMJmsPnY6QmnF/MfRw1tEnsqKUR+Ca9DmQ/kyZIzOtktZpLCplb+SDmBZ1b6oyTP54uWmrEJGOehHquEGS/60oqHgbIJ2Lx7HDatQQno0t6H1yWA1VVraLY2q48OFeMbwfC0Fv03esIBNafd0CxXU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tUwH7Ws5; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tUwH7Ws5"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6fb6c36ba25so45956107b3.1
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 23:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740468557; x=1741073357; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YmLM7oHR00hoPy5F7b3VDNoInC9XlQISOKmVVqo7gNI=;
        b=tUwH7Ws5iP7a2o/jFzeYF6YIISwPH/UIZEEqKVtzlovZ7IpiH9vqqAjcNq8XvwwjdW
         jpsD5NbTgu/HqMWFyk5uy1sAh+Lvm0ftkXrSZe/suCXhQLxORp9o/2i5ritlX8berzSU
         UhrS6lCehGUQfxOe9wji1icMbov7D4/jYQS90713Msn+IbSOJe7keJO9pLcprwFbTOdq
         nOnxm7BRL4oWhjJFSfKYO7RsbC6SvHfPfZE66D6HBDVP9cdPGGhJGjjWfNrC3dZpb2Bi
         RmQZjtxXQTUHBRHI6b90e80YcUxCwwDg2BD0t90U0B25Y5XO37BJLWGRbridqdhLnoSN
         +ong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740468557; x=1741073357;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YmLM7oHR00hoPy5F7b3VDNoInC9XlQISOKmVVqo7gNI=;
        b=OAUw5LVHQoo+/O3XLhHfLqTcQx+i06ncczZHC8pJtX4y4kBozb+jO2hVbMbaoaKMDc
         R3gkXStP/J3Q1+t2iGTz3BUzq/UuVqf3Z4yYWoXLZS+JxQbA8BcyebdkRgRkOuZpynXl
         Y3vRvqqVN2Pwg37CWy8D6zTP1tAw/Dp//Q7A2ZncjjPihC2A4Af0F/HDgGRwubxMskjG
         RecdEXc034PZtMoT3tcEdU4Ir7uKrR4zc7bsCWLTdC9zxoOqxXeHYdmldYcrrq1TLNtI
         cjF8acKjp1zsvlVXscLfRjJ3op3QpJlwHQSrHFQbKXPSMOXkVlauK7Bwju6CEGfS6ePb
         Zu7g==
X-Forwarded-Encrypted: i=1; AJvYcCVauMp5JUY9vRHrSmqEwU/GIsJkRaPmz5dNN7bLh2K9s7HX1nC8iKA//ds4XoOVWUH0McaO1PzL@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/VRWRr4ePDC7Hq7ZIRmBrPe3/q4AXTCn81Qhnzq3cRqUkFP2W
	+uNDAkclP2oHiwdeD/t+QF3yd5G/Tkief5r5CTG/PINnpLcG+GDb4PNgltcR507sgH5vT5SpBt5
	y2iof9NpPlfCecv0ZrrIG+m8dyqsD9M6LGsYuhQ==
X-Gm-Gg: ASbGncuyP4ztJ9WHXyje+AONra1NI/QivUX9lspFui2UrnyDizUSgCNmp/iUbb41JcE
	weiCpfs3l1bEDXfm/9QreFx5KLAZ025gQ7AJ60sgy0uJI94pJCKsK65ykPjt01RHSTsJ0ujXz8z
	w2hPIJljX5Lz/aVypFprbh+X0naJeyGmoWKidzkh0=
X-Google-Smtp-Source: AGHT+IF9jdcF1gQYWcqJRP7dskBg5Xa5PlysLeHiljmo+uvVBKR+01JJ5+3ZW148YC22+F7vV3ocHacmYQVxaxc3wzI=
X-Received: by 2002:a05:690c:3687:b0:6f9:4c00:53ae with SMTP id
 00721157ae682-6fbcbc8c426mr119358127b3.8.1740468557236; Mon, 24 Feb 2025
 23:29:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250224142604.442289573@linuxfoundation.org> <9a18b229-f8b7-4ce2-8fe0-4fabd7aa6bd2@sirena.org.uk>
 <CACMJSeuQkzvi5j975bbb6gF=+NMz0Aw-X5xLXR=8rMUjeQUoZg@mail.gmail.com> <2025022548-swiftness-supervise-ae80@gregkh>
In-Reply-To: <2025022548-swiftness-supervise-ae80@gregkh>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 25 Feb 2025 08:29:06 +0100
X-Gm-Features: AWEUYZnvrzYRtYLYeSfKngXkQZhA38Ce1zhEnS7-WwuvLBTGBLkn-dt-SFzkyZ4
Message-ID: <CACMJSesFVOp2t5C0mhB-=8m3reUtuBnMrcTShj-duEpPX1iocg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Feb 2025 at 07:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 24, 2025 at 08:57:10PM +0100, Bartosz Golaszewski wrote:
> > On Mon, 24 Feb 2025 at 20:52, Mark Brown <broonie@kernel.org> wrote:
> > >
> > > On Mon, Feb 24, 2025 at 03:33:50PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.13.5 release.
> > > > There are 138 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > >
> > > This and 6.12 are broken on several platforms by "gpiolib: check the
> > > return value of gpio_chip::get_direction()", as reported upstream
> > > several drivers break the expectations that this commit has.
> > > 96fa9ec477ff60bed87e1441fd43e003179f3253 "gpiolib: don't bail out if
> > > get_direction() fails in gpiochip_add_data()" was merged upstream which
> > > makes this non-fatal, but it's probably as well to just not backport
> > > this to stable at all.
> >
> > Agreed, this can be dropped. It never worked before so it's not a
> > regression fix.
>
> Ok, thanks, I'll drop it from all stable queues and push out some new
> -rc2 releases.
>
> greg k-h

My bad, I should have just queued it for v6.15 without the stable tag.

Bartosz
