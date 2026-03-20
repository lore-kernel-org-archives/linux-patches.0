Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC38A283C89
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774024458; cv=pass; b=mVUnMD3zbzUUofsHdeseYnyGoT300yRWK6WEWJBly3Ucd6nl1gcWAOw7fNg1fpvqPDHRHzFE4fVAw1Z2hVtWpbRkh85V7VcanWYCuJvusoudfrBXoGm3QEMXmmzyDnkbFdzSuMLGjGl8HnBc3vbtnJhYLo1jqY3wluCUeaS/HHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774024458; c=relaxed/simple;
	bh=DOphXfirH2F31WL2uqYucmME86XcMutyVUWtIXPl7gc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kop9WP0Gy6J6Uhreht+KuLmgWVeMgVCBhoKDRlHuSTd4FFn9WQuYi8CBqN0w9UCjTmRn04GVBY0TpWLoVjNiCkoRV5Umb+pSoT9WY2nkd9W0FjMkEuj58/bDLlgR5LnPsmxzT1Z8I2eb4VxvLIqfScMB/u/t4PifiqmhNfxOl1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwS1Zlja; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwS1Zlja"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so1968051e87.0
        for <patches@lists.linux.dev>; Fri, 20 Mar 2026 09:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774024454; cv=none;
        d=google.com; s=arc-20240605;
        b=B6oHgzwl0+ukKcpyAhT3sh3K6a7/dpRgTMXFiz6bETARzHIEsc0PZh4BT15nb1N98f
         1kqRAz2YlTGiYDJe60LIWBsWdFUolUjP3HXzxzqGIanR4izAa9epu61Z/X8/TfE8AtaA
         nnmNE4AwfH5h2lXc9YhZCLYM0wPOe2jhcMy9Jc4pvpN6Q7kLQNQFhVIN1vYXWWiNfr4r
         FD4tfpO/RYIqI82yHtdbzLUR2gxGKnlVWdec1dw3flq0WlIAZv/pTPFkRNCv4u+0ITXw
         PT5sOalxFG72Ef92yTf+cMsCzw/XtUV0yJ1Jxf5QGYA2mMpH9PvpFj+Km6t/EYCYOjCa
         OArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H8qpsLo6JCO1BfmoZlP2l5F+fI7lej/in3jWBkiFLwg=;
        fh=yLesxvH5IGADwGUrH6IAfecSYf6YmE/UR+ZMnnzgp6A=;
        b=eO+pDl16m/bgeRpAbzJAw+Eq9rCrln2rA74MIsIM/0Zek1O7s/o4YatLv8UlaLP9Rb
         wrv2mhfFHiw6PfevxV6SloE4LUjY93r7/ne8vjIuplSzjDLYneUK0dfhUzExRg94MsjE
         MuhZ4zQzPKH5TafMU6N8gEQAoqi/EbkvYcDsZkSGQ0/rrbvGHD4dmClvBHLBYfv2ihl3
         QQqLkdOCcvbx5yULwCsWVxeddacK1GZglfBFKD86TpBHnj0cAuOuyFaqI2STnDsYPAUv
         Z9a2uDz+BUBsPESeZeXb8G0p1qy0R7xnDFD7mC5ShzKBZm8y7VRkWSb8+kiTpm8ZDPAd
         Q9ng==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774024454; x=1774629254; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8qpsLo6JCO1BfmoZlP2l5F+fI7lej/in3jWBkiFLwg=;
        b=DwS1ZljaXSkGnjL53Hii2EHfc5FAe5/uymkfBcJuhZqcsHHGyxl8zQklovD3dOwmBD
         OJ5Bje4eKOFyCf6aHj6oUeTs1Dr/G/P5uJBQUgxorFcWnnFVGNbT6PrByOfG5nhM9+jo
         92+GqFbXENFp2sV1PVoVmN208Amgewi61qYsMr68mNaF7KE4duChRrn0s2enBSIldkyY
         T7K/Tn6dsrPJjPL9HnKjgXKiOgM57uS+2kuXN9oeI0ohu/oUWb103dBBfltMfNHwT0iE
         kLazKy2/mwtXsztcohGuvZqZf/7Agxby2JLh+PN0FGe4qQUWfDuAVEhAM4/V+xrZUfg9
         MwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774024454; x=1774629254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H8qpsLo6JCO1BfmoZlP2l5F+fI7lej/in3jWBkiFLwg=;
        b=Wp858oKyVBFjl/tLhv02vvOqZp6mQ6N7hFFzg7u7JmPH20vn8kpbFC+Ihv/0nZn7hK
         aEGbeoJ454I6QvmilVkv+INTx+MAG5i+cMYpv/Hd+MXNPyx0FHm2whvfgsQ5Hi+n6XQx
         jZ1B5AAX9iRkKxu/OqN6UdaZU8h+/Y48JrPe4w1ocNcTbnXxLescb9ZWcR69LnhbaPZG
         03Aaz+xfCsAI65OuT1RbNprhGm+j4qy4wpKxj/p+JAOs4lTsC0yi8qYtC1+/jjUgED7f
         UPlAaO+TUKiSNiOH5vrFNonCWLELB5tS46NjOrERfxUbp7YVCyzWZx17VGHc+5uyLBDn
         atmw==
X-Forwarded-Encrypted: i=1; AJvYcCVT/kdF3DIbjGf5Z374SUBg61zkCUg1+7KhLdQtP68JAvdid2dwwKxNQO1zEtaiNjDrxcM3GqK1@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy7FPAmOoMPsBrOioFZVRKpxAkVhT15PrRH0/ccNl4vnONbzlA
	qvfGT4LKZY/VFtRwfLBWQR3BL2eN8Xx+KsjCALzUM5KxdGqa7bguLblzcIJppvMA0R2nnyVY2vv
	TE5lnC6TQuSfNDF/EoCZe4buHFohWyoI=
X-Gm-Gg: ATEYQzyGOc3lswNHc14tCRtEIILjOyJFmWiJjY3No2dtHmovCrAN4IArfkAAryL3wVP
	8EyMDb0XpYU0kvL/t3RtUHFJ5AJCBoaGtVY2n4DhyqwL6RqmVJWSCKX+maiN9Zc4lZLK48RZG2m
	YolspURkUK46bGTzSx+rWRxG9ao73COfUOF6w8pS9UOJrdW6HrqeM5lmWpoTJDLeBGwGm0AyWNp
	MKq/CHHqdvL82vikTcc2RsF8F7EFyngRs8hgNrNkp6nahxXvXYrD2OoY8ytz9DhUc6KMq1qgc8s
	i5aWZFaE5sH6uMIRlXPe4zXF2/9F1ESWMMyncbAz
X-Received: by 2002:a05:6512:3193:b0:5a2:820a:3844 with SMTP id
 2adb3069b0e04-5a285b5d3b8mr1572683e87.38.1774024453737; Fri, 20 Mar 2026
 09:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318122547.233850204@linuxfoundation.org>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 20 Mar 2026 22:04:00 +0530
X-Gm-Features: AaiRm51G2yy0fhKyarz6O_yzpjAq25qCzPl_UUVFnMjAb1fnUFGyEBW_Tgqmt7c
Message-ID: <CAC-m1roU9AoCk6Eo+C9xB1o1XCKtSoeb+nU0M304iQYJ8ckwsw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
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

On Wed, Mar 18, 2026 at 5:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.19.9

Build and boot testing was performed on version 6.19.9 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 08e4691d3bc050704d7ef71a30f4143485833f1e

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
