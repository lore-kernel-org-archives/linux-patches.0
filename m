Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5345D2D59E8
	for <patches@lists.linux.dev>; Sat, 25 Jul 2026 01:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784942662; cv=pass; b=uC091bVg5JzLgW9bhIeZWOWgN+zSX2r7Aoqn+amJNYxl9QZQb0A8DAjCee95/MGuIH6jNDWELLruXlQb13a/EIKbN12AZQPODH1uCzRBZJgexX1+eqeKnffkK9IPtvwcH70oFL+0YmaaslAL+mOlbvw11wAlGml+TIv65Y2vc9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784942662; c=relaxed/simple;
	bh=RR/N+7U6HxpMfVUnwIY2W1vRNETeHCqGINXb3mjcJBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3xgG+fAqrml3raUKbdpd960vOL3QFAqR07x5VEQjCUSsAolMKNdmWsSTuDX2HLRhcmLxNwwU6kYz0oXdNekMozm/ea/JqNPDNQjJuVWiTzaFwfdrY5GbvJEECuVXIi3AuVs1Xtusb59XdcDmbP6+nimE2BjJtuYVLGnjV+Malg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWhluK5r; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWhluK5r"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39c9452243cso8754171fa.3
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 18:24:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784942659; cv=none;
        d=google.com; s=arc-20260327;
        b=b9iSnTvicCTi55cOj+/FpVS2tefJpHVTaqHYace2MtJDGd3VvDf+3N2sD0H2iZz2Rd
         NtxfIgFBKeAmDqzgZ1z6itbwneSAzbLmhKMB3RrzuR/iZxkgxh6EG4yvuxrST4cOO6hY
         YZd1PFB7HoPzwRgRO6NEP1+GgRQ7CIRIVSFkjM42g2ryPykfdySOxOOJacPa+jbSWgmT
         huIhb7NfeiBtkoj0vRdKC9n05iWMP7G284sibXhMivDHmT6OXWx2YaqRAadnmKXcj4Jl
         VIKdEJeT/qsHYdzlBWmrMLX4ZAvySbc78vhJwIHhLIskyUqx+kpzQ0Eucg71gGxPNPRB
         580Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N/CJCfH0/SDNKO9hky1DdcwmPfaS2frL/4dsCfTjLhg=;
        fh=l9t1Y5gyGe80cy0apAQWfvEJz7SSYLd5B82HwOyn7Mo=;
        b=qmJVewyT8xCuGo8rdbqmQGbUQ074e5b4YBoYXExM9/LxRxu/CvaeqyoKV3kotCjHK3
         6OTDIORNnFVy2tkzaaklHwDv+72IT9Bwbv6z6+nrQbddtlCa+7JAogsXeM0XmmScSaXq
         nUzFAtnOrjc5PZNR/iIVoRbniqJDZpUwn+0NWHiNrg9DcmzFhpUoKRuaxllcDnDZQSKF
         O8qF2CaI47ph+YwBdYvLMyy+SXlW/0i2zCEC6uPQsPyC0L0isq8Q1uE2jqSLFtFUNwoM
         SBRPAhwYnAhqklZR0R8Xxkg35AxVynfLJ6HFgISO2qdA6xBfNZgl1ht9OjHisfcqDIUX
         DxUg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784942659; x=1785547459; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N/CJCfH0/SDNKO9hky1DdcwmPfaS2frL/4dsCfTjLhg=;
        b=YWhluK5r/m9FYLcM1UALllBd8wbPrqZi8OltyNy8toSsonyae9ZCLKx9aNKltVW060
         0fMxrxJ3DakFwQe5880ig10U3XjF8HgtF9KvEXneoWt5X12OqPxymGLxrzJ2nDkmQGPd
         nmv+sKDTDEBwZexQKz2/4HaQe7cgTWvReaJc45kGExafb4Q5ys438p7/X8/m1PpG4htj
         etufeLUMd89qtqEGdtEcMmdZ+G/eE2WPQ6ZBdZVFp0dCNCZ61082cAUauGQfB+pwws24
         oYdOd4OHlk2wmfP2noQO3drAktan5EiQs1T4ZUs9AIkwO+e9lRC5MgTskgb2pKe0pOCR
         ANYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784942659; x=1785547459;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N/CJCfH0/SDNKO9hky1DdcwmPfaS2frL/4dsCfTjLhg=;
        b=DBEHSfhB0qfAkwhCCp4Itp/YTKfCA8nbWaJIixbeNUj15x5MTbl/GZos/apbWL2eAo
         s+0GncyJer8apxfm1+EtclPAJQuAVbR+c1P8DSsU44cFwWyRL7+D0yZ4LyAsa/3/nzi6
         kwtc7FtPdn+2Jna6PWbwxu+abj8FE3egh5nGpxI+H6EASmnDh6VGDQTsqsmzhHu8K8CB
         wSiXg9vHcAMzf8rc5EKD86dT5x3QqTvKhFycIriES0bA4NX1e60vJu0UPacyxdUN56fW
         Ug8CFAGwAzjBWkgQowlw69LL/kadM5ErnoJ5tqJDPZpNWy/9avqL+W9AqZxVwiX0xmrz
         RD7w==
X-Forwarded-Encrypted: i=1; AHgh+RqlmgFzKcAiHtfAHLG9DTISy+f++J02Xlv4UorlJ3oFrpIhuLVI8EgoXKInjULt9/0gKF0H4j9k@lists.linux.dev
X-Gm-Message-State: AOJu0YyXYuMtWXC0D3PF+vDaq0OXQcCm4KX7600Y6qEupvLF3JeQrtZ3
	UbMGX+Vg7E9kmVt2eCNHlm82GFPKn8MhaBl20BiRq9HoCQVT/Ebn+Xy1eSYZwNrvpxk0gn9i6ZG
	jyMzBHWVJuidzivEmThJ8N7EfxAKO59s=
X-Gm-Gg: AR+sD12tzONfOHfKm9eyzOj4ycqupAc4JEHePk3IVVRlwwJAW/6saZcsqivpeV24yvH
	b5TTKX4O2GXB1AvjxuzykWV0u1Ok1ZSj0CaCCgyAMu9+XRgzWz6yUuVr6PE7n+8eV6+FUBNI83e
	mT1tFxpopTj50scWg24DdDev7UHaSvc/AfBPMkiMSEM4uo7Wo+mWTUiCXJYig+5fSCdYYuKi68S
	MoUq8wUIZ6ha5qmpTGfscfNK2KZ1XvagHR1B6SVJJRGgxucQoVKl/NgYvrfwRUvSTsvGXvdm1AO
	WO/zs0+5H430CblQ6wQ=
X-Received: by 2002:a05:6512:3d21:b0:5ae:b75d:8c0d with SMTP id
 2adb3069b0e04-5b2c1afecd8mr59784e87.12.1784942659075; Fri, 24 Jul 2026
 18:24:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722142947.085426486@linuxfoundation.org>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sat, 25 Jul 2026 06:54:06 +0530
X-Gm-Features: AUfX_mzIyZ3MrkOex7XlD4dMeTTVkltiwhpKNUAGs3b5-mmzTOIMJycxWGA2hag
Message-ID: <CAC-m1rryTBYDDfroX1kuLa262NaMh4ppoFr=m7RaNpoUYVxMoA@mail.gmail.com>
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
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

On Wed, Jul 22, 2026 at 8:09=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report  7.1.5-rc2

I built and tested Linux kernel version 7.1.5-rc2 using the default
configurations
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 7.1.5-rc2
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: ad98fbfe8a23687c534125422868b050b67eb6ad

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
