Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE5313B285
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709039918; cv=none; b=hzQbBJKSHHpLCxwS+vF+bd+SA+QT4wYWEn4hI5OrUiPkVG+tS6FNzNg2G8pf4Y/TiYICPoO9zEqn52EDMVeQ1FqhSoZi1w+NVlY7owvT/j/OP4LiLEHdC4JJIF359omwuNEhcVtqtLq7SqSm3sIwmW3h2LP1t+5nC0VnQytN5tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709039918; c=relaxed/simple;
	bh=XIdqyDQpxejpU6Xbxt+vThMLN3OZbO3x1VzJ061nang=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M4MYakWLLZx2+Tl5KtnjDVFVSV2XUpw16IX/el5ROxczY0kmjiQHZEj8H65+qOF9Z7gtwMUhkXsv0vUEOgwysqAacbwErFaHvZEUNafGMmqCv/mnQKqv3rfQzYIRa2jJEofv082nmZ8XsU4Eh95AC5yMXpjXoc7bFnT2yi4UZLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=hwwDUtYU; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="hwwDUtYU"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7d2940ad0e1so2539365241.1
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 05:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1709039914; x=1709644714; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MJvKpz29jkQyBneNtGPQJRAHLJnHtGshFmhRL3AhTM=;
        b=hwwDUtYUX5FdbVBdqv1O03PA0HdzkTXwL8P2a+eDGIr0rHJG0pVioHhMqgWUKNl9TS
         t2xCfa+fPDfnIrtcYTorUQBAyxUiasuYApiTYm6jXDjfucewDbGuGX/O0IDuS4D6xS0Y
         SyOJa6s98HrrByTJPTWo8HLl1cCQ/RzNR/75xvyanU7vPsCx0avP/jnQq98Pu2RqEhqK
         S29Gn5wmnWl6w0QzdMTwSuRsPAXz9QG/P1DEJhkxht2TigzsDV+Z2IuT6d3hu4Q9pG41
         K4ce63qqEF9SkePY7WHo4azhJ8MKWpoNHfhCTwVyghjPfSxBNQlNW1Nw7Mqn464azRd2
         halQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709039914; x=1709644714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MJvKpz29jkQyBneNtGPQJRAHLJnHtGshFmhRL3AhTM=;
        b=shzO8NBVZNN1qbOBjPOhJRDNyIqOc73fTzKWU8RgEqS/FUmh8BB5LI44/wK84XMAkw
         QtKSM3GntxSFjsXtPQ45dT1Nf4ll2EiqFjrLrTyEaBpiNPIvauHg4N2YatCQ0b2Fgfxz
         tvr9dXFRApIigqBtYFqnJgB6yfOA+vVLftI3FrqokEV6sL/CAXXOmsK7RBSUMbt5nSF2
         gaVcrQxV0Y0Y26vbhm18M/SqE2x3L/uWTAiOq46nseFqWV6eY8VbHFczt+OEqp45Sglx
         b4tpCBA9DsPhQbhWsU1ctjc3DOF1Zccx/qAzlPaUCQ5wlEDb2ON1gm/Pmcsb+gBtwHsv
         Ehyw==
X-Forwarded-Encrypted: i=1; AJvYcCW6LNf0banD8ihteo4VIHDU8SMzsks6khotpp9To3GFPQQPPU3oSoSBdfghlDvCNojD1diLc2fdOu9wAnx43T+6y3Blt2vkgA==
X-Gm-Message-State: AOJu0YyAuDRyXROwxwpktQjVlWLSh/06Um8NKHQrPPZ7WChKY8/qeQm4
	xivz8e+tUp4wnu0TcUFheI3/5+NBkO/MIKeSYxw7BRXY1QytO62nzhGfgPzoILxu9CQJEteZc3L
	H2TEslrUrD6/IsTLkxt8ECwFmOyvHy0bYDALI4w==
X-Google-Smtp-Source: AGHT+IGFmZ4niK8yNBEqazbNpJaXrpKFX2pVzYNeNDBMOldwUgZekD8G6UAhaKmwhhECxJf9gr9cCnrgYNlum2RUL8o=
X-Received: by 2002:a1f:e602:0:b0:4d0:36e3:40c3 with SMTP id
 d2-20020a1fe602000000b004d036e340c3mr7050322vkh.13.1709039914615; Tue, 27 Feb
 2024 05:18:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240223065254.3795204-1-swboyd@chromium.org>
In-Reply-To: <20240223065254.3795204-1-swboyd@chromium.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 27 Feb 2024 14:18:22 +0100
Message-ID: <CAMRc=McvYEuK-0bfF67qDbb5FS017NcMkOGaLtWucx3LYL0DMQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: Pass consumer device through to core in devm_fwnode_gpiod_get_index()
To: Stephen Boyd <swboyd@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-gpio@vger.kernel.org, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 7:52=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This devm API takes a consumer device as an argument to setup the devm
> action, but throws it away when calling further into gpiolib. This leads
> to odd debug messages like this:
>
>  (NULL device *): using DT '/gpio-keys/switch-pen-insert' for '(null)' GP=
IO lookup
>
> Let's pass the consumer device down, by directly calling what
> fwnode_gpiod_get_index() calls but pass the device used for devm. This
> changes the message to look like this instead:
>
>  gpio-keys gpio-keys: using DT '/gpio-keys/switch-pen-insert' for '(null)=
' GPIO lookup
>
> Note that callers of fwnode_gpiod_get_index() will still see the NULL
> device pointer debug message, but there's not much we can do about that
> because the API doesn't take a struct device.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Fixes: 8eb1f71e7acc ("gpiolib: consolidate GPIO lookups")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

Applied, thanks!

Bart
