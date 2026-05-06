Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28DD3DE425
	for <patches@lists.linux.dev>; Wed,  6 May 2026 08:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778056594; cv=pass; b=QCAfOGLr4FZ30v/EGUrWuYJWDwSHfb0D/U2FPaEx5TUAcM7/3KV/5NtKfF6NH2Wgir2PKbih7UsDmgTqqSzq2DsLOlzwssP8+vw2eMwRN46+N4ByulShJz50WaJTR4c2osU4RzJwUC30zUYHANdlVaLi/2QOrbD2+WNhV2uMsI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778056594; c=relaxed/simple;
	bh=dS9TgirgJNLrunDgjKnae2iSJPF2xTNwFtcU0v2imFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QdSC4vhyToIpUBTxDtOhuwVQWlBekC07HDw+cpl4yyzNnWR7jcS9uwUiDuVW+A825ZYrmBY7TQDg/vD8yWfluCPeJ+pKpLzWsPpnUbodGB/Jjl2OLNuLzhIXbI9OqbZiwwrMFaxz9CEbro4Bo+t/w79rB8Py6f3zY0P8xbGuKS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMHbtM7y; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMHbtM7y"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a4113ab355so5922978e87.1
        for <patches@lists.linux.dev>; Wed, 06 May 2026 01:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778056591; cv=none;
        d=google.com; s=arc-20240605;
        b=EeaCKoihD8dfFg+B82AQC21fhPa2ZltRvAP6tumqaxVWfiAz0JB3hxquEvqp2J3U5k
         9r+nM3nLI55eIgvues8Eet6i9wBAnDozIg0fCPDA/azkT5JPPOZClfDfYTrpxCqbOzGS
         szFucxsj/e/dBdP6rFNOiy4+o2Smdal0MHHHJdUOPc23/qjRBFhJILLvKyjUHVK4oCQA
         fTfsF2eFyGKWHIQ0nUkfx1rLl5/SZHrzHQ86kKU5Idk2OZUlYHjl+FlYKqLWic8he76a
         IE8ZsYT3pyqfuSAfuVL8TJiSUk6buYbsbBNtwoWhDwprGYpeijolfCSZBwd2oJVzFpRR
         3iMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iJN1jCsJkBciMc+1+SZHTiIpvUTkbx/J2kTZk80x++A=;
        fh=I5h1T7iq60/TpeX2QeUQ8pxn/B0VJijBv4eBRal7TsQ=;
        b=SbK8ccMA8wRteJYHnN3ZHDivSGnDgmldFSCXQGM1PdqWV4FNZ8TfxyJtHPbQTBFVg2
         tVX+ATzGNSUngUxq71QTKSQ9Yu/YGsXk1DK2pcEJHeDuMEnBohedKmmctl9xToR4o0VP
         AYgqYjDKdZraSNWT0dgNwuGMbPee72m2qSVvw3PmpRotqy0fvdt3Ncj0Kn8ePwKjoYFi
         MGdstGW4z6GtNG/jJHItbuSW0d5zN/LTWOCT1zU9hu4nVqG67xVZON62/Awu5qJ979we
         4SgBEFdKwImErOmZvqQVtCMUnmLUFoxGUbm3GfgmUMlV3Rt6FM2s14/mkvz6rqeEhZ7y
         C6jg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778056591; x=1778661391; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJN1jCsJkBciMc+1+SZHTiIpvUTkbx/J2kTZk80x++A=;
        b=fMHbtM7yUNjpxUbycoNKRrvCF3aA/P/bD6HzPJdAdqOyt7CfjaB1C0cmsfFUzAMYqi
         nQv6T+CwNwNGru/ngKF/6baq4sns5KpfvDw13UMhPGW7EIFPTFuqHsbj7BRMyCBiQAqq
         QnTSQ0GeuFVwPfPdz84N7HvSS+jj2n19tVxL4ZWwytdlPOSiuFWfSRgb4eaJIZq6YyU4
         waX9mOC16PhG8e3jRmXtyw/s14ZNeGezRF9mnaSBQX5lRixMftqFeZUBscdsFoabYdpn
         83v7szn1qDbcPmuHJOJ0DdJRxUIfBRxxSJHucEBrwq8bBU4tShuh5+jiUZ4wUiyFj0dV
         l+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778056591; x=1778661391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iJN1jCsJkBciMc+1+SZHTiIpvUTkbx/J2kTZk80x++A=;
        b=oXEiFxkZhTce47f/0ByedLiS/q1/H0hgx/b4iajfOmw92T/QumTo3OBTVAFhFf5DQl
         bgAK1U3Hi8KmAqmU9I57/gRiec7ejTDKVxoJCD1cu1whGTTPdDUeYWPa8poCnVIbhtQ1
         WCbuoy+xentMYMfEYABxP8AdBmkGmcELbqlMjQsONAETWw/dLeaaHWMe7bw7TdfFbYLz
         7LcFaaRSgU78Zp40wrJLsNQK+2shR05ZwmEV1mKcvNk4zV4q1k1T8gxU6zQ/7FNrwHeL
         AAh/O0mZmHQU7R2YWklWW4mQ3G3iY4J6UarT1TV/OQsthbM+AoETcEr9rcb1LkvWeRHO
         wzbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/sNIqLfOmYr8IChxw2OWK3pA4z0Sqoc587i+Xj8hJNjWbx/HjCeiAiBjH5yzSkDpxXWILyXWNF@lists.linux.dev
X-Gm-Message-State: AOJu0Yy71t2UhbpzIfgR8aHNa3PMZFwbSWvx3g9IVlBMU0N1pIQB/e35
	nEWpFVbaQXNQeQ2SLdbAyiJlDqSvQlNOMfgwDYDP01wMiKeXFEntde0+uMpmqLWKYBHRQYmWvgm
	xfXg9KYnqJe7t4Qmx3wjBisVWf8YGBgc=
X-Gm-Gg: AeBDietw4BgItALHO+IkIdZ9eDyQhWK0Gya8cMFr1MVg3AqRwoaj045hiEazSzBkb3M
	G9F12vq0HdcjemUdyUlKJM9AXhUIHCcUlB44VkD/na3YzhSZBieCPc/oGBudvTx43ICjlJZsArp
	SZUvqkjKcV51tFwQlWD7UuerGvwU8lVYY7m5EpuSTTdgxvB6qvaTZPawT3pqyTDzqdHWImHUvzq
	5fmMcLV39bJdg70NDGv+wtOZuH6fRJRVj/MZtE9TFuf0GnofET4ODmj1kGMpBZQMs+VrDn0VV2a
	NQXeCQoCV5Re8GtnIL+c/MWSiO6Mma1ZlIX/4DRrbzqxXVQIaw==
X-Received: by 2002:a05:6512:1191:b0:5a3:fd83:13f7 with SMTP id
 2adb3069b0e04-5a887ad8e1bmr915708e87.6.1778056590402; Wed, 06 May 2026
 01:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504135142.814938198@linuxfoundation.org>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 6 May 2026 14:06:17 +0530
X-Gm-Features: AVHnY4LEVPqLoosgK7r6DTP2iJjJh7U5EtQ3o6nZFcoMMJm4VKaytZNR80oKBBU
Message-ID: <CAC-m1rpwoyMAGfh3Rhj6Yo4CR16fZ4V9SEum06jOcM1yr=BzoA@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
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

On Mon, May 4, 2026 at 7:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

The kernel was built successfully and booted without any issues
in the virtual environment. No dmesg regressions were observed
during testing.

kernel version: 7.0.4-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 4a299534048e330448f6cd13a87bb7d23549b6d6


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Regards,
Dileep Malepu.
