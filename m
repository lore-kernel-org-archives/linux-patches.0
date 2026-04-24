Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0B53D9DA0
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 16:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777047611; cv=pass; b=F28M0N3Bi+Ri6PKKgQBIInaIBroH4CRL2ltHNYA4rOCwQV9Wk0QjBmCZWhTN25ObwhaG+MGVBxhF1zOVzDxZaRA5DZxml9h7abVKDns5p0NwCXX+Bz/Kzn2qASxZPVhG3cPOZ5E77zO6eMv716GtshIjatiweTq5EnkqyWMgBow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777047611; c=relaxed/simple;
	bh=uAHtlsVN96Sq+N4GugntRyO6Yy2LIY7UXKYaV91ExO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkzVFfXcK+kMr/Q930xCwrH8XglPmLE0Dr8TO/QqohVtbXRl2u2Y8/+mmtPn2O/rmURFEOlI1ksBcytwCbf/dRh0fuOS/lsV+Daha9EgviGiuyTnic9nDk25rKrH8umk21CjeAevz0MeYfOM5UfNlseijikOe3d+p5cu7S5uG3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Or+Md5wi; arc=pass smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Or+Md5wi"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c70e27e2b74so3054791a12.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 09:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777047609; cv=none;
        d=google.com; s=arc-20240605;
        b=W1b0JJwg+u1VQoIOOXjSazssG8tBBuzFtHQLI2iCSx5uYBeYkj6SRI3aJ6BvZE4pTO
         q7B68kAyeIdjmGWDRQhWNTRmP7IYReFf8uiQgIb2oyw4Ugp6giutEzS14TYfY+SWZMWO
         iu4gJhVVXWMu4wgtSMQ6zgM6qKvd6QxUSJOuOQTa75bHMLuwitkqZQD6rx+X31k0EASf
         nodUojUOqEUZhqQsMvuc9KLNWLCBfbzspRZtyIggOQdvg8wqQPzglBvX8P14Sur4nt7x
         gUK2wJcSK3FjtV+Vb26oPeCd5hfi3uY3RFSLxYsK5XCShdS1KX+49madSXgA6wwob/fK
         L0Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QesipSYB2lynBtk6mNpF2Ov2dBclRS4CJkeDY60ZVB0=;
        fh=5gKJw7L+iMjNGf3i7hO8XbaZxiHB2yK7Q4zc2ni/Kuk=;
        b=DhxAeO9VuVuGPRPH3xJ8G9FNCJNdnYQDfDXhncvd6QIfQmFae4OMVkb9VSH6GCsYtP
         yPGCrCbDA8l4/SWYmChYjyGKb35VA8f4127ATuJPn3BQTzF+L3pDw6FRuiS2G3UIfY7s
         NCmkM4zKgtee4JOU5aMvK1s2qWotAfS4UfNtpVUdHCqdyk3Z8FqTTJg1bvVxk5aFZLd2
         +KiGGknIUuNRCCabX0ANaHqsRJXb+CxQ8c+qJBCf8XldtBJmQTExyOznvWnR/ZOuvBF5
         b/GgEVkkFT2VPC4CUVxI9OjsQQSM/88sPddbhOJfyq0sUWrS8HQ1j4ERQsbsKOYSNevd
         w22g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1777047609; x=1777652409; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QesipSYB2lynBtk6mNpF2Ov2dBclRS4CJkeDY60ZVB0=;
        b=Or+Md5wipXxm/+AfW6+WgS7XfQwmbYq9GCs4BAE1JrEFIxbpR6+HL9Hn8BbRUmkHqw
         aLs5WUpIRORe8Gt1fE1PsyczL2qWDNrMcY2O/CX4ze7bbr2x3y+zvT3/SJ9NyG2U3pnp
         /jdnqpeECdxThfB6RL9SMzpW+fSln4YvQrby5m5uAew6OTi2H+4pTR+PepYiC5cEtRRS
         d5N6Cmt1PegZamJJ5LFJ/dXiKzsZSGzjfT/55d/i815n2hs0bCek0VQE07Gp7Z4UKrts
         HXV3nKrzO9Zd3Wp72z24wTp3SNFZysq6dU5c7/3UW82JwiUbpm9idGbCVlmOw8mSnZo1
         c5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777047609; x=1777652409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QesipSYB2lynBtk6mNpF2Ov2dBclRS4CJkeDY60ZVB0=;
        b=eGY8grQHujCnvOWwYP43rSqcwMFiDha1/En3iWMsCtJIQQy23OCMX4tfbUrF0ulDKy
         KgMzjgFNNtoCW1/3Qmwl3h/ViThx8icHAINrxmfXHyE2fl5lTb5Ck6yWb5+AUEKmTzOe
         i201eFRQIbZp+PjcrneC7jjl1LKmj8Xf0F7fXklpMu3gPinmRJyenyP4AwA2ar2TKmMl
         xM4FgihzohWo8GhxIL47YShtYrakPvHRjIzzAlWnwUy+InXIL2n6GYH3ZRVj4i9UclQc
         M1Z8N5WTdl6vjYQu9Seuix7+c8i1sGH0zPpFuy0Ln8kRWVYLpd2i6+omTbmTT40woXfw
         aoiA==
X-Forwarded-Encrypted: i=1; AFNElJ9AQLXlLpYxzbEOVbYG0j7mm8r3O4TMJ6jBv1fjnZzHuBAHvCsLqzlC9eSqkexUP+o6rWsBlnSZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yx95dQX8wF8yWDgT9c0YiTCbOvE1iQcPDa3LgkHVtMsO/klza1w
	j+p04A9qr0m72d8m9O+JjPTCPLOu+S9nyeAtXAntLCwKYh9rj7WJVNm7LBbvE4pRzWDkVyXMF09
	16aMdUa6zAQmG5sJkmvm/RbRsaWMlEN1zZvj2kF5cZw==
X-Gm-Gg: AeBDietgpPbu6L0UTBOjmyEbBrBJwkQFN14Q+GgBdKo9GEHEa6mK6Dt9nt7WnfwnyLi
	Tq03CmmNRZ11F+MecsHOGYh1bMZ8r1eZbMBt28QZlW10a8afg5y2uAs4Wfyi/Z/yytCYHT9cAIU
	WYPw39cUMwSaCi6NPKB54aLdInoWNqwt5inrQFmYLN74g102bfnt/05OAecbKm9dxO9v6lJN+Gi
	QMG5ZvKPfDnEcsXtCcitHkdKnwUlHBBD5SHl624OmLswPZoVpgB/Svie3/qHuUseNRgRo2L6vsb
	KHhY2gbQZvdA24RMiOk=
X-Received: by 2002:a05:6a20:4309:b0:3a2:dc51:449 with SMTP id
 adf61e73a8af0-3a2dc510702mr22625990637.12.1777047609361; Fri, 24 Apr 2026
 09:20:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260424132420.410310336@linuxfoundation.org>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 25 Apr 2026 01:19:53 +0900
X-Gm-Features: AQROBzDhRqXSu2ARS4P9QlA5h7yA2wX07eL7EIpw_Pu0v7OVGEWCHBQ7H9BnTtc
Message-ID: <CAKL4bV7Ed-KnojutZwCnsNgg6iv9J22QDAayN1kWGeJ8c+9ZbA@mail.gmail.com>
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Apr 24, 2026 at 10:33=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.0.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.2-rc1rv-gce7a64af92ed
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Sat Apr 25 00:53:31 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
