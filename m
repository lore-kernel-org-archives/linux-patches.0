Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE253AA183
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774028293; cv=pass; b=b9dut0JbEQGWyY2BAA+nsLBMBO8eOmhh7O900HsPWpPhrwhxHNy/2eY7jcVWsygEeoqoUJvOtbe+Go0RZDgwkF0M2VvFnR3ZKkloOjJK7rOvx2zy3B5zvNNg4PXDowS9St18tOQkMMJNJcv/7o6sz0CiiFVWywk68KkKUTsRHvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774028293; c=relaxed/simple;
	bh=vyzcxyLiua+aJmZ4gYNX1LoXWiN3e5CwNMBv7DWxiuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZTNARcNG+RW1nVE43LPoqCwEgp1d9bRydyA9KvWPTTjZYPwJgwKD0AaC21pcgS/qbhIcHu1C7vK315uliFEDr+xZ8i0p2AZE8EPFKt+Lh7tspD7+aoOeRKi1aPLQigqHHXnwyDrPN14sCVJk0EVAzeDusugXNA6dxSrTiaPNI/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+pehEVO; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+pehEVO"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-38a01c80c34so15811751fa.0
        for <patches@lists.linux.dev>; Fri, 20 Mar 2026 10:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774028289; cv=none;
        d=google.com; s=arc-20240605;
        b=lSI8KA2krM2z6gdkDevzXgX9aveFViWNJYEphKxK6EMPeSqZcHit8u9GvGBf1m8T8e
         UPFCJw+1jwuRAdmkTDZXiIokuKCGkz7HbJWR81+zDzC51FMuhiXfKYVbqI6tNjAnJYp6
         kQKpmnn/4qFw0mvuyT6Rh05HijI67P6GIpCczKQkPnse2gUOCeXK3jR0bkkEXWBD/A9Z
         Wb7zzYk3+mr4HU3X3iAiX7vNN1sNVPJr5wcyvNJB6iWmHEuyv80muOoxa6mnkNyKqK/r
         cL4XF5Q30WidN0ISaNtrddrnBAhQWv+yjP6ZxgIM9utchal1FEqRB8I08O+eMIh1UkWs
         Yayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pmt9ZSMy1khDGG6bbXx05FDoyR/j6jvheT25ANDu+v0=;
        fh=NsesSdqNr+7o8AtIpzFzaNpzEJiS45ZlE4hGORqbGfk=;
        b=SF5r5AL5WWUrBumEIUMJjjrviUSWRrhx20LFMCEgvPwxq/3ZqsZ2WLIrw/b8b2sUrS
         qRn0RzVG7UkD2ZlOI8tjVTH+XE/MDoIngIQrX9XrAqq9A4yPQY4nwtrdOwOMrAZovc7f
         81fEL2srT7dDGCmo46NYYuLoeqSKyb34kyXuntqGmtLSo6xFYbeNqshAV+KizVrJZ1Ww
         cO5Gr0OaiuyASHj4fcxik213plg/ggHEVU7oxTOURSbSA58EMNnVpnOMxClkDBKsx3v/
         4a1SdRj5BUchNiJB5NR8A45BjOk1DPRyRODvOySSBvN872Cwp0pRdtj4D7+QxkhNCBqC
         CZng==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774028289; x=1774633089; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmt9ZSMy1khDGG6bbXx05FDoyR/j6jvheT25ANDu+v0=;
        b=c+pehEVO582uevjineHP1Wrehi328mFO1kjC7DMY5/p73vbgwxgyO0PDCBnymlZtVP
         x6ROUa8BE2tHLlgTw8zR0ngMiWKB5M8Z5yvqggZ4Zmb6nbqYIrADzA62Y3pve6cbmJSG
         XU96aYemByzxiY4aUAFTBN72jzYhz7G8n86+nZ5SUoKPL5eEAkerqEXUrvrZNVc/VFL/
         X2qtsYAJCmHLjfXvn80UgFBTPdpk9AF4heXHdq3YICxQ4ngCbzg/St5e6SH2U2oe3D1b
         CECEHmVPqqkbHGrRNUETBVJsQMTG1pYp5DOqSeRNjbJEeQHUtnQqhUPGaCC7obJ2Mr8A
         n90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774028289; x=1774633089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pmt9ZSMy1khDGG6bbXx05FDoyR/j6jvheT25ANDu+v0=;
        b=PtasjBLdfb27f7sYu8fhxkXEs71qLlhz12JgU2/TobEfKPuuJEiXjfbJVwiCOG2Iyq
         HG4eBgWYdkZJyy9jnZxKiArAmmJfEA+iercSKOhsLQgXvqQpxLEV3cVEpdBfql69JKKm
         vh0A9w48C38f00QUGcU61irHsdMJIgBD46bXA3OLOisGl7sYAqmFhd5mmHJSMEQZrFrN
         /IOfEC53opWwpawF2HHPQQP113g5EqgZgCWQRf8oPZIfwZuMEXko8tUeRhyXeMIxuevC
         V/UCr13bW1J175lIM3AXXodnnJChEOKUI1skAKSbgvBi7AR55mExogJboZGnFILTlhv3
         ZwkA==
X-Forwarded-Encrypted: i=1; AJvYcCXdXC96qoWDc+yq+ExBAuWlSKUZ3UbWf0FsecGm3WOTPtYZ4zxh+q+eSelTCndrI9TaGY5bZRIg@lists.linux.dev
X-Gm-Message-State: AOJu0YyVEZzjWHWzZrqowoWn94e4qFsX8lqvAaQ+eCJtOXF02TuRkPL5
	X4qNRv7UxmYWvDcGq4qsZi0ObuSuY0bxrSLd0txslu5Tn1/CJgblWYz+YV0PPQUMo7S8V2E/FlV
	cCnd4wH0ygLVPyGz31QctkqDFDEQtqAM=
X-Gm-Gg: ATEYQzyKSLUOWTbKbCoKbbVET7JyprgLTQZWGN5de+hIF9WOI5mg+i7sgl1dvCZ8xJQ
	gy4Xj7MlCEL4lBV+ld/gjpiT6Y2Q+T5TM/tz0zoayIrRni91dRifWaojbAS/oaOUz9rhPiYWBqk
	ylAH1Eg3bWGCTdohATik/I4Nk8SXbWaFA5jW/9PJLspo8Neqf/9KjTQ/MX1AzpK9LSiQDBXvMZi
	ZMfFypZufaAL+1dekrfvwrP2Ixnf9Pgtzuo51D2Mln8Ga+X0tOV5yVfkQF1UKaJ35aLKM2ZU92+
	xrressjvkcez23RsOgJP1DxGG5FRogOr8zReKnS3
X-Received: by 2002:a05:6512:3b24:b0:5a2:7ba1:493b with SMTP id
 2adb3069b0e04-5a285b61bb2mr1577073e87.33.1774028288656; Fri, 20 Mar 2026
 10:38:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318122621.714862892@linuxfoundation.org>
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 20 Mar 2026 23:07:56 +0530
X-Gm-Features: AaiRm52FvB6NLw_9Q9BMVK_7A-AjCHzUsNbZa9STwksvXwApxvnFr9Vap1kNFUw
Message-ID: <CAC-m1rryq6wtLUmuFALWiyrRNroqN5fOgXhhFOfysLDcRT4F5g@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
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

On Wed, Mar 18, 2026 at 6:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Mar 2026 12:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.19-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.18.19

Build and boot testing was performed on version 6.18.19 using the
default configuration on both x86_64 and arm64 architectures in a
virtual environment. The kernel built and booted successfully, and
no dmesg regressions were observed.

Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 1cc312cd040851e0a56d3ce1f0f92cd232ab5cb0

Tested-by: Dileep Malepu dileep.debian@gmail.com

Best regards,
Dileep Malepu
