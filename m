Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1930AD00
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768600704; cv=pass; b=BOsp3pYWsNTfBJ3utM2STkK+LZTYCJR7xxSZhu0LAJwjPvFiF2m1yu6XsULejpWnMfmgn7aeWIHPDk3MuoyRD8Ehk8tQDEQpkaEGlre1WpzwIADE8jcG3DjyFgdlpWonLeb4spMjplWaWEUvDfN/H7QBDZm+MZk56eqFgL8VcO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768600704; c=relaxed/simple;
	bh=bPaRwJS1RrJBMlnVDNPm7dxe49RmumTjqinBhkL9jf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aP9stMEBbg32GgZ7pV40t2PcX4YX49drAoKnV/mD3znp9dz4ReefFxBuqFuv7IBNzy/tePjp/dLJVKPdNYs4L70ak5JwRVxYDbEGijx3hFWq9ZHgAem6yBodW0Jxn+kMtBZocqg2NLAs+zWeWSiNx/ffAlqoOkWB+Y+xiGyUvB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=JNpZbMq6; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="JNpZbMq6"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8888a444300so25916886d6.1
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 13:58:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768600702; cv=none;
        d=google.com; s=arc-20240605;
        b=FxayZCUp7xipceId8fra5+dXoETHHpyfZmZ6/UFq+Ob1aZwt+LdTrphr3cTD1PLLmP
         KNEp2/x6yam3M8pKRiaijyGBf2r6pe7GTplfGNBzSHTmcFaGypOnACqiqibXpdWNuNjw
         EwRAG9xJVQV5DriqywFF9Cuz5pLf7StxF/LefLcSyst+S7iij6RyX7u3O8II1wQG1A1f
         03C+a4BsrV+K+7luW0HScd8h0SzrLQok9T5VA80pHu/rfKqm/STFjqQlCrh/jJJ29rgw
         Ko/zgkJI3IXJdG05vQpQ3Z2GTElp/uBjGv2zxpq1ZZ8bBvWDTKUHInaOyDkyFhT6JtEo
         Pg7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ci3VzwquJj/225WD6QeakQESZUt5GcqZi1oxdxkAGbA=;
        fh=n5vA6HcO2rirgWrB6URQJHySMu/ArEKtgUNtR7Kpppk=;
        b=N7GnE7wFOrgiONPgkPi17oJPoD5DK3V/v02EYhpY2GY+z6dVPJA038FwRxSvnTg6aR
         ZEDxf2fvByDiWg+LxD9d33OGHek6qda8BOpSoInnXnLeyc9Ip0kQRG9uvX5ugg38hO3/
         dmfv8ZyJhucRJ/tmWyjVzDr4UMcrUyQo05AzNWN/6yP1K8EW6hhUQaxI9NQKYAeS5lqa
         8bLSHxLLJ7uyX0Xi0rVP6uygLidlmIFjV/6jKG+u4s4SyOjTPMg6FwDf9xTS8wgaVGS8
         2cTx4a+8kWfISdggHZec8yQYDykJlvW8sbI1F9euNfTlRepDCYMFn1M7yHE//Mtwo295
         Qskw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1768600702; x=1769205502; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ci3VzwquJj/225WD6QeakQESZUt5GcqZi1oxdxkAGbA=;
        b=JNpZbMq645GGNbcv90WKJpv7tLNoTbt3IOP9R/xLeWIzc0Zs67kg1VJnkTu7wubH+8
         gAypYCivpEUvCvWfNsM+nQ6MY0URBo5RxMKCRuiX3cglg9lWYu25r5zGRHMtKxa2AhUS
         Jr4J3Lsjn5cwhJTOlSUxix48l6d8QOCu6U8ZT/yAjd26vFAGmoejWWxk1E5NpW23z/js
         lgqvgNG7H5EXSiBFoIr6/K0RRD63wJg65ywZnUcj/yA77zs1v4JmCY65T2+q5qg4I0+Z
         v6AuPwqVO10Ia5CHZHjA9Gj5pJZGldUZqJb3cTmfQOevbl/XPP0ylh8WY17KGJBYsrO7
         dnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768600702; x=1769205502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ci3VzwquJj/225WD6QeakQESZUt5GcqZi1oxdxkAGbA=;
        b=GFAQZgpDRuxPyNNGJceuOKnt0J4kYPGHWC6jAvupi0wRFatnMhWNuslKqQrpF/2Fw5
         r8+dM4LZeJkOER2DyaluO1Xp2QAzQcpMzrxfw0Oaso8YfBDT6Sn8WRJ7HetKhgYAY9yT
         TXfP1yt9nwaENyDbH/gtQqIEG1yZYVHcfJ9mt7uMi24o4GUobTcbg8chqdw/DjN6tHQP
         IKcHT8dxe6+8klO3pbq7ylYPRHyKlDzFG81BStW7e276lS5vrjZCMtKWsj+ezzmmkRJj
         WY4N4fht6yqxw4Mq+xPS2Y8a2ipW+2IvVmjTFq73xcIuDMoevryeMKF7ymiTOldy9tzZ
         FJGw==
X-Forwarded-Encrypted: i=1; AJvYcCWwtNXgydBhpRc/uNsxSZMDdGVvHKu2cMxClEZAXXAHDl+C91okZQk+cNkV3Lp/i3wd7NMC9div@lists.linux.dev
X-Gm-Message-State: AOJu0YxRrEa4kB6taqNzS5FvfzUCPvtZ3hwWEQ764lsX14JYGPl7Hw3f
	chNpw+kT85TA882TbMZTbxBetj93vWpQtHqdkhbs910BDVwCo/CB8HLMaJU0CemZp0US67BafiT
	UI1y0guYl9GYrwM7M76O4QXCyKLZivWbkRqjE9XapVA==
X-Gm-Gg: AY/fxX4YYSmPu1SsaTZCWppvRMw3vRYH3wIJ/sjkHi8PGN0Ww5VgfuDxBzvIY77ElqY
	+OBsFq0lY5h/TvHvU7S+smEUknBkOYQT08PZzsCV2xbIJqzZc1rN8LCZ090TYnGxFbs/N4QyvDM
	8XQQOX77hKD7+ljt6nQboxeOnWcbBcecGY9rYWuMBD2RXxhbgmfLqImf2vSETCoTw91mfhP9JLL
	RUFV4GF9zIBKg3vKbh0IN0IR7BjNR8ECYwtKp6d+kdP/yiUNAUPGfean+rb1OFTFWuyAkpQ
X-Received: by 2002:a05:6214:1d22:b0:888:57f3:ac07 with SMTP id
 6a1803df08f44-8942dd9d671mr63198166d6.54.1768600702129; Fri, 16 Jan 2026
 13:58:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164151.948839306@linuxfoundation.org>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 16 Jan 2026 16:58:11 -0500
X-Gm-Features: AZwV_QgX9Dh_WA66C1bE9X16GWaQKsScdv4wLDbHYHjFqcvYSeDOuQ1DXsIvl9A
Message-ID: <CAOBMUvgaE4fiZw=d9jWNxvcYQuFtifR5AqL-nCDDR=aS4bXTNg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 12:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.66-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
