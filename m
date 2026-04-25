Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15EE225397
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777153067; cv=pass; b=Zz68f7KJQLyGfROS34uIE030KvmLHzHft2YyuoAsqDovCFABb4oEV3gFFm7zFDuZTAll3wGVyEauVs12i1169kQKGz5dIIh6+B01YDj5TKnurby2B5cQLkz5cyuHI2RwDu57IyDPkc6VKAlQbF83r6ShQKyV1C+1bnxNMM0Mi5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777153067; c=relaxed/simple;
	bh=fVwaHjADj7hD0E27HijGqOG0DzLsu1OtbPTvKi5vgdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PnBbS9BQRBwlit1b/l/mfr8JGilugT6RGvZPbOHXkz3/Viuw6wNFf2tdzkmsicf9WV+7h8ZvqUF79MXJiHU7PTnpPZ5DZs12HdayuiRMCOYp/geP2iiB3APLa0Jdi8tS7roEusFei3ZHJQqHgYA1zpGaFjTIo2GA3FEKF+AkX2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCeBaGwq; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCeBaGwq"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a2b5ea59a1so13140741e87.1
        for <patches@lists.linux.dev>; Sat, 25 Apr 2026 14:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777153064; cv=none;
        d=google.com; s=arc-20240605;
        b=j5wQrP/Wlz8HtKU9WactoNeC+vMBrK3S/rrxMl+WitdZMF7lNCiJAtMEfzT4E5XA+n
         V+katlKVEL3n+h5DAydFj30hMLbw1orIJUK29mN2EhYLPA+SeI/PtoI6epLebheoavnX
         UE2PuYheqe28UAH9726g2dK/PgDeroe3w6RK+WDRElkKn1AtEQzbN4YrC/mqpIAfdbYM
         68xSR8iZJB7PZkzd2RVWzBfOpV9MDTgHX+lubi8IHRyo8VOLR2Sf+iQizul+98l5j6QZ
         eVX8jPfUsFCTrsfSdJO2wCK6/CMXnTnlfRHPygkmLVtyADRZjp1Lst8puQJ3VBKwFqxg
         p/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TlFiMgzCvG8jVhDs0P645nDIJhplhuxTfjuhUWHaUpc=;
        fh=O/9QfsU3ZuOYXxC9ZCNiFfc0dvqa3ukXTfhdvxiCtaQ=;
        b=TdTQcheg/QQ0ieOoLYEeKRROIT3hGStVMS/EtpRzNUd5PmTN/K4LLIi/TH0W3egF8Y
         hE5DfpktVW3AMgn34BSQmiDdoqguAavQSCFG3YBoZtneNz557iVNzbJL9hGqMNbd9jMH
         lTtZwAUIt0h21SQA377fdpxIVQbY3Tve/1Fd20yS+5Ct90wOTx1KSuLum01RE63KU4sT
         g7gQt3uU3TEs4L9Z1agsDVO7uShey/4Qdf5zX6tosHQtlIyEmQLMrPSWixWYZ5+e/Lbp
         8Z0INLVx4j1Y0WArOEI9xQcXszEs0Uzr/mWBOsoOhS7fsiNFq+XstArrHtDHlwZlx5oK
         R8pQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777153064; x=1777757864; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlFiMgzCvG8jVhDs0P645nDIJhplhuxTfjuhUWHaUpc=;
        b=OCeBaGwqQOQkZJ7Yhd9ZnGUqkAMb8C36TG2kjmVzCkWBzY86/FBdowFPFsOLgYxm2v
         BdbsQ+47+2OCKNzQM8i7mb0CaJzUztOWuRS5F03yteDSxZUKQaxUrYmVwDIrN7rujI+Q
         VTh7D5lT7dFDwLCfPaifCWUf/Ubbn/RZjXEEPO4wBdLQhlXiUsBTi6RQa+QWxHAa63oQ
         0FWpq2ga2pzYqqCKBnPALfV36dbpiMYhYP/S92cBx1TY491jkhDESNX3X4oM87mMyo6k
         6I2Y7GK91/nhUJDbTf4eO98OT5KZKB8k5YP6yzA/9Ndm9toaGw1Tff1n2/b1VF0+JXI3
         Us5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777153064; x=1777757864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TlFiMgzCvG8jVhDs0P645nDIJhplhuxTfjuhUWHaUpc=;
        b=AeSP5WRbgm/NHHjuOhJ+Mb5lOKlgoADrilwgZBUg90nVetyHks20bCT1El02bbzMjB
         1rERidV41CSYbnVVT+31Nq97wQar2JfWIIMy1eRF1Q4bqGSlvyz32dZsxTaz3wXlj4fp
         nvutxThFh091eMKebsEaeRoiyceXS2I2uyQWv62YJrY7syill6xp8yvW1YqpkSG/5yq5
         l2z3bELtDSs1ABFpYFJOex6qXkqGfxcweq0tUi8wVqKU65diWfuXD04YUPpkmj4Hyuwg
         ZGG8ezCXbLCrSc0EvvF7FDgmRBzTEyuXiLNCbH8iDNYs+J69yOIJYtZwnG0equYYl0zi
         fhyA==
X-Forwarded-Encrypted: i=1; AFNElJ8fwhOW/CQYE2Z/xl+FPAMbRVv/IeLX6TEI9f2DSYWF/y+VKAlTkNmugPVz7hXhHUydau8HZO2Y@lists.linux.dev
X-Gm-Message-State: AOJu0YwF8PvFPE7NkwJwOjqGMympabl3iFi8B+cSSVZ/IuBAclLQoUBc
	4GVEyXeiwyKZvKh4lQe17HhSTvhgLDGMzYXgPHlxOJK+0CyZ8G3BGlQTwUCJ0YtxASWPClJhJTh
	J8pYkqz08tICMeBnqmR3tCITjJFCkzLM=
X-Gm-Gg: AeBDieshnNwbvihssy7Z/q+MOgiHbKT5HAJ92JHkSR2Q9NSb+GwXzkVdUX/HIrw8gdv
	ef5bpNwT63fCuKLO8oRXf7G5q8u2asYx7uH5yTHebcvM2tZ1RazK1QMmbk6cdCSIxWOIVtAzQHf
	w3sCz8vTGzEoZraQyCWLZzh+v0iUrp0cuNoqHXFmlOxK+P4VVAULBDSSA4zofmDOYPPnYOOVSoD
	EUfmGFIeaZ2jDfx5CzH2EAWp+HPcfS8zAFtD1LsiENTwvj3A8I///xAd2sZTI/24OeNU9LOOQnV
	Xt8ZMN/YCL4NwK+bRxmNeskqBiJks7cRalhY1Ddg2PzN3W6d51I=
X-Received: by 2002:a05:6512:1046:b0:5a4:113a:aef7 with SMTP id
 2adb3069b0e04-5a4172cc4d0mr11858454e87.17.1777153063484; Sat, 25 Apr 2026
 14:37:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260424132430.006424517@linuxfoundation.org>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sun, 26 Apr 2026 03:07:31 +0530
X-Gm-Features: AVHnY4J3No40B__j-9cDKQcum-5gJcF82PrcVNRfXqVzMuoEsRBx8u3rKx_G8pk
Message-ID: <CAC-m1rp8b3+sR9svJFeuPRZOfF0GekbDySQnpUTG=LzEHcYpSg@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
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

On Fri, Apr 24, 2026 at 7:19=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.25-rc1.gz
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

I tested kernel version 6.18.25-rc1 by building and booting it in
a virtual environment on both x86_64 and arm64 architectures.

Build and boot testing was performed on version 6.18.25-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.18.25-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 2bba374400df741071c2c40c53e8d4b8254899f2


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Regards,
Dileep Malepu
