Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B182E2EE5
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751990728; cv=none; b=ulfAj/7CDSqL4TrkdgL1hnyYzAaLtxCMgGSn3VFI2hzqhQWgJXwKlkAQ0chz8fznb2oubyEd1kbOD+YDXJNXWe3gbqal2Fx8/cATCVfZq8Sf3+/26nDHbNr3EzT1ny8c4L55ZHXksWDE3BtWRLOzewpjwb5EqHTmJx3gWJOsgCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751990728; c=relaxed/simple;
	bh=njlSf049HgeVwS1qYFLjUyYCR3cWn88GL4Ar2RuTuFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r0tAw13Xyo/yP4LlvxHdNnOiR7OehyMujew/9LWYTRoFlpmJIB9vbfTH8eGCkzMCM55TidUGC3O83tftICKLw9jsFy86N3IhXnF1wHmhhujorOjw3bfC+x9Sqf9sBP1h9q0WpihxHpWxen1ICtpwYFk1nhH+lwVVf4CewWSHUws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VAlnu7J9; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VAlnu7J9"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-236377f00easo58381515ad.1
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1751990726; x=1752595526; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcrq9Px5GbWJiB5AxSdJQdkhbTPu1vrVrShHO1zRmfQ=;
        b=VAlnu7J9PTF3q1d+E/zMck5uZ7t67zX7PServbFeLm1Wl56AJ/lvPCHKJOYsW3DZHM
         6e3NYPnoisaVr3T7P2rlW3dtFQ2tmr0Lt3VYVkQaZ7/PSzwqsZhxT88UTeIXuXyZJTTV
         31oQgUxCI9Wr3UoUXkzNk+/ZmoybpT+xU3kqLE69QmHVq/ZyM1MMY8O5/5yp/t5QR+0S
         vZbyzyu4jdgwKLoXaJdA7sL+m7WTFiEQVYSEsuiK29LAdYggXESdPBuuuPPHqHnw0jSl
         S1uC1YawCO7tvcwQVE4qqa9ZcX9706G54+RXFXiI6PQYveaNSjXxQetnz7u9mzDmtwjO
         hJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751990726; x=1752595526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pcrq9Px5GbWJiB5AxSdJQdkhbTPu1vrVrShHO1zRmfQ=;
        b=b+TT51UUqcMZ2nTYSJgU0G/HnN4TVGOSSha/L/sqA+I7zSWeiAyqpqkqFo0SvE7zcQ
         JgXJKOwMtkyUHlUsmtgM8S+hty0K0bfQswCki6qZA2OKcbrnj8GjHtJY/zceQiiKN9Qd
         zxQ24yLtoZpFzPy0IdbRj6O4VaBW/7EWcJrxp69utCTcuqy2etFZfZF9/VvAv1V6KdJ+
         R1sycfezna1/eR2AhbJn+3FEvc2OyImhsGP0ehtVufXde0LyZIxoSalk8tuBfQ5pf4Th
         LyLxiqLGKNqPv5y0oiGjxk8EP+FyzrVZ0TPLsNrjnubS/9Avyg0UecCevKteLCAQ42Xi
         quwg==
X-Forwarded-Encrypted: i=1; AJvYcCWBMyf0YiBGCW6df6GqH7s4mxFzhdpxaRxgboTyj7tzar5AuOCHj/6z5vISGWh4oxb9NcIV+goH@lists.linux.dev
X-Gm-Message-State: AOJu0YxXYIAq2zHPwVZTQBkUW4ODRrSp3Ua7eA64/mwJ08VjplQ+epp/
	P3HWYfk4WUa/LDajXsBGF9jYwAUHOJaqoffPI3SakwIyuS+zDiX/RcJ6fxoA5hAm9fLnnLHVb1C
	n1VJr5USacIDpILPNuNvMiAtfyCrJHGA=
X-Gm-Gg: ASbGncv/Q1H3ygLbbI1DETz0Dg+4skOu5AygTB0UatfJ4f79wIlkQQd9UID44u2eze0
	PSx21GS/QdsiWRF57z4D+fgy1zWZClAXenbxPSHN51mHN7TvDcQ6tQbXpCo/Np1AJnRIgUluyjr
	I01h1kZF9SlHZ2zuciIX+nNNvUYRvd9aCvsTknZJmSwBhaGbGcqOBDtG8K/VgyZ6drnjm0Ocu1i
	mw=
X-Google-Smtp-Source: AGHT+IEKVOlvfwl4eeYBuBVlq9Q5WesCQhGMUTJNOVwhBmexAudJe11ZvEDS+PJxNLKpg7tENHSnBWeB5BP04yZ+yrM=
X-Received: by 2002:a17:902:ffc7:b0:235:f4f7:a654 with SMTP id
 d9443c01a7336-23c85e2be38mr294917555ad.22.1751990725856; Tue, 08 Jul 2025
 09:05:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130632.993849527@linuxfoundation.org> <70823da1-a24d-4694-bf8a-68ca7f85e8a3@roeck-us.net>
In-Reply-To: <70823da1-a24d-4694-bf8a-68ca7f85e8a3@roeck-us.net>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 8 Jul 2025 18:05:14 +0200
X-Gm-Features: Ac12FXyLKp-u4KETpYgI7t1oSJJS9hnhBb6_II1awELD-8NQbOBh3d0_lW58pb8
Message-ID: <CAFBinCD8MKFbqzG2ge5PFgU74bgZVhmCwCXt+1UK8b=QDndVuw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, Jul 7, 2025 at 8:05=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> w=
rote:
>
> On Mon, Jun 23, 2025 at 03:02:24PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.186 release.
> > There are 411 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > Anything received after that time might be too late.
> >
> ...
> > Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> >     drm/meson: use unsigned long long / Hz for frequency types
> >
>
> This patch triggers:
>
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/meson/meson_vclk.c:399:17: error: this decimal constant i=
s unsigned only in ISO C90 [-Werror]
>   399 |                 .pll_freq =3D 2970000000,
>
> and other similar problems. This is with gcc 13.4.0.
Sorry to hear that this is causing issues.
Are you only seeing this with the backport on top of 5.15 or also on
top of mainline or -next?

If it's only for 5.15 then personally I'd be happy with just skipping
this patch (and the ones that depend on it).
5.15 is scheduled to be sunset in 16 months and I am not aware of many
people running Amlogic SoCs with mainline 5.15.


Best regards,
Martin
