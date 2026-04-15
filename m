Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D2F3803F5
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278302; cv=pass; b=kVsMD7YM5LLFCMaklhbUU112zICk6UvjQCmSEL6CssMICZkWRzPRk/f8w8zYGe9xausaP7JJ0/5ad0ZSjabNPaWVWfZL20apPbqvbNMXZLLRcd+MuRs9970f0Oba+GxHYALNi7NG1PPYo5wuxsQi3r0JwS3YcZS1jlUP3abU/OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278302; c=relaxed/simple;
	bh=slPVH7KAT97uurf4DQhYJlACVgz1LZV94Jrmei9PVtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMShtAP6a6sz7AzxFFSvCWO3gq40zhZ8gA01tJiR7tS2jm9B+jAC8c1oNkvjxK+yci9qc75+98h/e2Sn6k5PRH/S2yiU5lKL8mHICxrI6KAiFIoofQgUaom79H+mXfqMTq0GIoESlaN+O9UDxGNRNb+vHctUREV9gPZN5zjjt48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhG0+lCF; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhG0+lCF"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a2beddab48so818496e87.1
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 11:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776278298; cv=none;
        d=google.com; s=arc-20240605;
        b=Ojr5DMgUva2p85mS3N5cLQILjuVeR8F7JXMRgmub3zA3hR9SmYZ+3mY9rdcTnwRR6j
         Awe1YiDUaomuu5O0FP5HmmqRBC01G+4bd82qSv4HVUyiEyamjv7tSjy10YtYVAK9uhkF
         z8IGYPSVSlKoZLNXurGu/PU3XX0DWzd0D00yeOM9xcZo+bvmBW0plE44GkyoRbFENuSS
         f/bxy+CYmE8TAwSo/ErL91OaY1Ucaety/quxJA5i10I4/EaxBMgavHVtldQzdLZKRe0y
         /76Tu4brqq1pYvYux7BDCqgP5b4BXr6rpXb6KX7co/Gv1ed6K2nRV8kAZsi1Fr8HOTQ0
         qZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QlbkPCKz5ORUtXZreA85qlZUJ7MloMRBic9U1KgrnA8=;
        fh=r41QFGPIgMN9cajEQB3BqGUf6wOlAKG9Ei3LFyi46iw=;
        b=eogqLVh2BM+EreWb+GvTEd2+yhluahIAMSYeHIiny/cAZfCfl/UVctcCRj7zCll+f2
         DpnACr+yGaHq1PsgmifFJ/sc35G+xUivkME+telJl0d3Ct8UenjMlS9Dz1RDMbl9FGHs
         SU6rFfO+fqG1q4fpv0pwc8iq4z7/4M2LaXr4cnh0H6Uw62xdBeBHVwmdNgoSvW6VVksj
         Uvo5hWsdS/6IcsPVpBkwbhU+F+2qbHwDfCEZuzYizGFjAbj7WkVtx/O0H7cydwJgfL5M
         uOBEmO8gxebEFmTK3t+UtFdjJFqIx/kdFmde7Zp/RuAA3/htzViZk5b/z7tr+zsjZXev
         DoHA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278298; x=1776883098; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlbkPCKz5ORUtXZreA85qlZUJ7MloMRBic9U1KgrnA8=;
        b=HhG0+lCFVFKv7e5EkIRqIZS00k8BSiPS0Or0FXBdUM3F6/bvEgCUEQOZLvqNB1EZ89
         h9cx9zXWSSkZpJFe9Q4bDrP21b1EewdFxojhlWoteDprBt1v/U6LvV0JB55jUWQB6Mdi
         e/OSFLLFSaPZft6pE3MvdtMp0lSoAuxrGIRWVkDefjrE7dD4vdwIFCDzN7UXvAO6PhrZ
         Vl8wUqH52jlQVxlj5/cafiEXV2XJgh9pwZ9SZfFV/lVRnBMwIoSB+gxfogS86jHwwVz7
         DfCcS80LMD7UmZK9NB8pcrByCiIpRSVwUE51EO/5pH3CyBhDIKd0u+BkchcS80XIk6Cb
         QRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278298; x=1776883098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QlbkPCKz5ORUtXZreA85qlZUJ7MloMRBic9U1KgrnA8=;
        b=jw8aMm7AO1E8/ahAS9MAAOzTHs3VitoVBPIRTK9owDwStwCoLgCVZjAuDNnq+ZO/Sg
         2+azOFC9Ql0YhIdi8drYxDr8M1aEAiMH7J1CFv3coZT2phOPI1/yNQTjzPdrn5qNYg2Z
         7ACipepBzGCvZ/tAwfjlIPL83I/+GRdQNzOIK/I1AGSpWkR6tlLulw6oP9rtDxBWuzqP
         PNF7rAyaKd78RtJOQCXoDHHPbp6e1pxmJc07AxX5T44ExtViyIOl2BGPQpR1o8LRPJVV
         2KURVbFxrljVZzAZ9+VJQF0uYr6iaqIOLLVNqBNkdsNHjWP+SBPi66Jr9GiQMufSQ+CU
         qsFA==
X-Forwarded-Encrypted: i=1; AFNElJ9ljGFYZcsL+/nIp1OTmY8nVE5SxVYVrmj9APCgGP6kK45s8+pvdZOFFOE/PORoUApaLrjKJcTk@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsc9fdxCyWeq1vtsWJAMQQsXa14if9yeZNdAMTtcpYgOaYYqZJ
	mFKqjIclwdAeR4WZ8Arv2CrsyWgm5yoO4neybv6gB1DlYTaNS/ORwlGz4vHiSoj09cHNj82vaBI
	/65DVuwewcifiLykupk0lsnhiN16AVyc=
X-Gm-Gg: AeBDiesx4VaI4DYG5bOduXxl1pHbRrZd7bv4yedWlYwlog1s0hP0BY1qg/RQICV3+iM
	9VzAikOx8z8KVYOA9Ei9TnRZWXbPdMH710fMOBk0jGEmrVuC+NTDdsLiz5uTZn14bsj4N9wtTso
	wCj7BOMK/+InD0dVVES2Dp+f9dM9Kh4HVnJvB9WsUNxktODuXQA+IA5zyaFdzc0Ymib8Cxd2mAz
	1SX6cwtWIj4ddj7qE9ie/JIoyHdXtLcz9JTozikbjOf7Gv2FrTxT2roprdjvjWGGfRL7fT4QHyo
	DPBhLNbSv2oZSVnbrv/vBNWo94Ij7dtICk8p6PfO
X-Received: by 2002:a05:6512:15a8:b0:5a4:6a5:9910 with SMTP id
 2adb3069b0e04-5a406a5d109mr1888946e87.23.1776278298070; Wed, 15 Apr 2026
 11:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155731.019638460@linuxfoundation.org>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 16 Apr 2026 00:08:04 +0530
X-Gm-Features: AQROBzAL9aoOyA0zvUT9GzQWdqIEYbCWhFrCe0kQZglDihJh8HkzlZ5f8JSvzGo
Message-ID: <CAC-m1roQqpjNpUqiGeMXQyvAs7tAVEH-+-iJWOV3BfCgxs9tSQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
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

On Mon, Apr 13, 2026 at 10:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.23-rc1.gz
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

Build and Boot Report  6.18.23-rc1

I built and tested Linux kernel version 6.18.23 using the default configura=
tions
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 6.18.23-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: c600baa82c20a9a0840400b7f5117753647ff9d7

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
