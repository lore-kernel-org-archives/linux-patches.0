Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A082E7BDA
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844620; cv=none; b=AkXOTK/DBS9+cpV3w6PksYC8OwsR/Azfsle9lphAPY6vlEg8gDaOUfPAq+3kF/gIaEljGlKm+swSez8nWPH7ABMc+LAQw//3XcklsSLXnH25gBb+po4MAKYD0dUd+D8KyiM53849BiAEkfQLGKEcHnohmAtUeQ7F0fNJN0LZxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844620; c=relaxed/simple;
	bh=lrjZPFjgyVL44DP0moQzfy6qI7PEQfOdr5dPz8u7Tv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RG9CWCM+TgqVaVkCLK1c7TnQNDyjJ7HargqhZXG9laVEU46g/7LH+MKwCJNr0Ukhp5nwW0bELyBwENzViuaP14umfa/0JBYOypY15gE+gvrvzi6cz6p+a/iDfoxaH8+ebges+8Qwi2eIdCceZepKokTSpsZPt7OWCGbEdWxMEYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eq5IbfKo; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eq5IbfKo"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5959105629bso739871e87.2
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 02:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764844617; x=1765449417; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rz/DUdZu/VR0x2tWVsO5f455WgB1CFxzk30p+t2jHuU=;
        b=eq5IbfKoYrG3RrISFUIzF/9XH047aymhYtx063Qg6mNKS/NHNk78SMmoy+8DMFIrne
         RmJoztwNdhui2l/0VMzvnBl4MpLoHkSow1x+7NA9DjzIMYbii1bzPaG5Pq/9meH2ZHB6
         2Rbsqbig/mq+x9fK+XQ+L2kc9qpZUevV57E8pVCH8J3AJYm/D/zy8zUxZ3AtGeUSBxVV
         /GHdJmIbKUziELHu+i+HYLLXOr2rRCBni+Wu5kcYAioLT6PQuSK+piw9YGxgYRTwTDbp
         RkBjaOcZvgHKOmQfHYL9+oEDXgUi0mZijP1+F50OZjKcScBC/PVQcSuP5wBmr1oqvbAB
         2wSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764844617; x=1765449417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rz/DUdZu/VR0x2tWVsO5f455WgB1CFxzk30p+t2jHuU=;
        b=v4gVDmO2m4TKInOHsuBZOrFiCsUl83IhavLo2kqIn86g9TsC4sa+9qya+EbOlGuLtu
         zsqwnjmS2IU2stO3X6s7UXL0Dqplow98X351xCIzsAcnUsn+aUSY3+zB8E7eNkbAv9zc
         bz3SzC9gZbDsTgGw7JhRZfsH/HtXoBL7Cm245qoJmYBr8w15N7ws1sEbGBMgt3OU4ugR
         6Whr7xDTawtfbKI0/tvxmTndBDEIw6B4f2aO9rhbYKh/YUPkArd2VbaX2Mt/xeCiBPDi
         IN9UCanKIHXIdHjHYISIFnHRn2YhlENmGRjZNSbaGTBJtBC+u7thLAZh+AWub6+xdwPZ
         Wynw==
X-Forwarded-Encrypted: i=1; AJvYcCXTs7D2qhZ07srw5sWteM1caXccEgdEdMKznuF+rvN9sNcXqXrpBUYSvPwxLf7giMKpgAdu+qLN@lists.linux.dev
X-Gm-Message-State: AOJu0YxA8wSyNZmckUH8ndbQX7I2Uwadezld3owQpUC1iS3eYLt6HwLg
	MUD4FIfBuEHPvkVTe+HquFXbppSJwEibLF2HKPHYgL2IMCko2FMQG7bwSXSsnex0//IfxHKWcqs
	eE6RtFNzD5hxrj2MQmKXCulBAYZTx2IM=
X-Gm-Gg: ASbGncs8nKnfLvLAAhF+Pu5tS5vlqz8kbPxgvD97E7OQ9cX3fclrox/SiY6rDqmWBaC
	ZahQCpMZ6LkqAeuy+arNEaeUKQYLHcdmtAEaBi7CmDVq1NLANZ3d6hDysT5l5s2OPk/q5UuFcsv
	nGDNyzuixAq/foP1j3j/6VubiqyxMoOZj/DPbKWSfoONycMepiN9/wyS/LVUFk6YwLj0/uLsXf5
	jLC4iyKrxRNAfne3Ja3aNq8+t548ZaDhcrGacOtbLQT4e+gL1P11Bry/Z++mt+jgiOizfnBUIvv
	fM29yPxS9FKisV2pHelrnR6CTyA=
X-Google-Smtp-Source: AGHT+IGCDplgOWSHwWEUtYZYEpDzV8McadoBxWWzIbpwjt53uVEbDGIeTBPh1m7eaEHjlgibDwuIGfHYvo7rYHhEvsU=
X-Received: by 2002:ac2:4f0e:0:b0:592:f818:9bde with SMTP id
 2adb3069b0e04-597d66828eemr855045e87.1.1764844616416; Thu, 04 Dec 2025
 02:36:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152346.456176474@linuxfoundation.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 4 Dec 2025 16:06:44 +0530
X-Gm-Features: AWmQ_bnG3sVwyWhsRMRVaD9us28WTWuQXY2pjHQwmf455QkfvCZNcKk-6fGTdts
Message-ID: <CAC-m1rpCXmbMOS0AgZYq_f40om-UK2r=RCh=k-TfhGYhUtHm5g@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
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

On Wed, Dec 3, 2025 at 9:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and Boot Report for 6.17.11-rc1

The kernel version 6.17.11 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.11
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit :

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
