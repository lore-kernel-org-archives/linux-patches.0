Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6004670838
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 19:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740427044; cv=none; b=F9Cspn1Ahuqu23wbJWCQg/qmKvhVUj90Kkod5CCw8uVvNxnbgvxgke+6r37It+QeCwzmFeQbtP8idKfEokma0hu/KYQodUQqmj+siINz5U8ktGnnvd84Ep/iypI10Ib5J1vGYrXwSgqG4u/EZDtTGrDYRomxTN/AX8BVYxBKTrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740427044; c=relaxed/simple;
	bh=CDuJLlzBuj/3fmoBDS8v5Wx3cO3oqtn/G5iAqHz7QEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BF0oDJD9HyRuvyW+dBk+5C5serCKHmTgxmbIduz9jifZ9tTl8U9Jm9Y9dry3lknQr8ESNvusPHxI+vzkPRxsJu6BmqcE4yUV6/xjhswA/yR65ystKMmsw7u3ckCERYYYViM8k2Vqb65G7ZwmKcJFURzFQTw1lOgamglniNE45L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KarJqjij; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KarJqjij"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e5dbdbdaeedso4373242276.2
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 11:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740427041; x=1741031841; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qJE0/sfBAYyFpeapvbHG+qTDD6Fu2nTNP3MAIEqRYyI=;
        b=KarJqjijr5BlVc+7RMEBDyexD+r2sHtkqkR1PZDqGFo8EvQN/hbwiYKAMCJNoFUEWu
         C3grixgqEog5Q+oGrxRi5bf+XwRY8+2LPZeQZ+FTH+C/Ap4KuMYSW4WcB/S+1P/NgSxb
         JtZeDrITwFT+MeASFfpirhoMn/4zu7z5iuGpZmm7iB3ubDMbusQs8/qfogmApS6UaANk
         IhMevC5QHttfvQyvYoP14anPKDPnODHFQq03cTqabRCdOs0I5bbNnPqHKgPOIZ1FSrku
         T2zRAfRfa5Frl5yEZqDmzHObc8XdN52jcrzo8oHnLk7v7lK0hifEe85a+hKvhLDAqeMF
         4JKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740427041; x=1741031841;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJE0/sfBAYyFpeapvbHG+qTDD6Fu2nTNP3MAIEqRYyI=;
        b=cecjB1SCx2MoIkz0AFr2o+wP8iDyI2tMQmQXg0L3tzw3xc5s3G0jf42IonbY09O53E
         Q8pIZ1RolHDiZnSiGsESQWkod7VhWmTgs9XwUmF5hfzD+nYDxtl/ewvzePuGcIRNWOTY
         R8jtbM9XWdVUc7fXHjUzk2+gvi3ZoimvCIFT4cv7FcYlK37Te25FE2wJruan+tiWdPIG
         kdhkFBeWvAP7hdlDgQpC5YLZYuST4CdOhOAfKqD3C5ctcIQBKbIlsghpNROUp5VLAzMv
         BO5r+IySnbjA4mVCgYI65qIIZfHq9wgBjFIt5NsYkpzCtqd2t04MBmna1fj+YtSeQsZq
         7BGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhm+oqTKSYRUnF8grhPfpTHcrEEstdOa7posfI6c5tHBZfBq+RFdxXu7iDoYMaFAgAeuv9t2xQ@lists.linux.dev
X-Gm-Message-State: AOJu0YysbmsL0pUXO15KnVyL9ZrLdzA5HkozX9yIptdaChVxco/2bc/+
	UU02dTQKg0bjsRIvFsPZoiLobZ+J4Xo9r0mdekcZnl3m2nXPnpXB1N+OBpDuWIQgDOOJ0bYW4CG
	KMqxyBDvsgvqjFG6x8slFeIiqa+Qo7L98atwpoQ==
X-Gm-Gg: ASbGncvdo+1EnwYen830CUxttaojoG7cKHmF9g0tezqe7OJlaOMl5eRJS+pJ11Y1vsi
	Re3U86Jg8ZilEczgOh57Xy3qfNVcVpoPEgEfYtajjQ+Xarf8ged0rEnzJxRJggEoXYansLUc2Jm
	f0gPNbdpQ0svRZuEIF39eDnWngf0WE7Qcq6ygeCQ==
X-Google-Smtp-Source: AGHT+IGELIDMwjIBCztxs5836xqFuRiiPvU5KI02gA1b7TYU46jeylRaYFpxIGIqNf/544TC+dFaH1RhudEr9sGkaEc=
X-Received: by 2002:a05:690c:6306:b0:6f9:3e3d:3f2e with SMTP id
 00721157ae682-6fbcc39206bmr131218317b3.33.1740427041314; Mon, 24 Feb 2025
 11:57:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250224142604.442289573@linuxfoundation.org> <9a18b229-f8b7-4ce2-8fe0-4fabd7aa6bd2@sirena.org.uk>
In-Reply-To: <9a18b229-f8b7-4ce2-8fe0-4fabd7aa6bd2@sirena.org.uk>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Mon, 24 Feb 2025 20:57:10 +0100
X-Gm-Features: AWEUYZlQ4PohouoGz9euT-b3auLmwSPp2vyoSdlob91LHpZWlNyBUXX55Rfeoeg
Message-ID: <CACMJSeuQkzvi5j975bbb6gF=+NMz0Aw-X5xLXR=8rMUjeQUoZg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Feb 2025 at 20:52, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Feb 24, 2025 at 03:33:50PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.5 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> This and 6.12 are broken on several platforms by "gpiolib: check the
> return value of gpio_chip::get_direction()", as reported upstream
> several drivers break the expectations that this commit has.
> 96fa9ec477ff60bed87e1441fd43e003179f3253 "gpiolib: don't bail out if
> get_direction() fails in gpiochip_add_data()" was merged upstream which
> makes this non-fatal, but it's probably as well to just not backport
> this to stable at all.

Agreed, this can be dropped. It never worked before so it's not a
regression fix.

Bartosz
