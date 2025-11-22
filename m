Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31171EEE6
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 04:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763786786; cv=none; b=QiWhsU9DnyUvgjKs7jY36fSRdCYCVitCpRBDqvjT02dtww04LTfdhTQijsWx8kSNqyZCuxXJMMzCw7WFiF8V1uyuIsHvigo9rIX25qXwp9DRROsB23stiriBq0nlULEU3UbNi3wgtR25hNIj9QZjtoj+xheVUZ9HogPp6xaIle0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763786786; c=relaxed/simple;
	bh=fNOZXHfJRCZg56SrQDUBpc1032dLG/xeP8MlTEGiRG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FB3Fi1b946h/E/7ttTI+X0VB8PvS+/U7FjOTzXHtY8FG5g3/3dUpILT8vc2xrZSGdyy2e8i8LD5OQNGJFrjIhY+SZTmeoxJhKtcWi7PBxj17sUIV7bhYuIJAnrf1Xe7mpv1srzqJLEePc/UrzN30hocKi/z7BqLfxVhGDJpergs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T8ko0tdj; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T8ko0tdj"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-bc0e6d91222so2435625a12.2
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 20:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763786781; x=1764391581; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jFD4F63S1jKHIhSd+FauKFk8n/SSK6ModuLxc9Mx/wI=;
        b=T8ko0tdjjmbRQO8eNcDxoXpyXu6HE/PIuGdg4LQE05DShWGYUi0EPhmkyhTC01y/Hw
         Jgf2Q3WXILGeOek9z7qgEIXX+5q9UpfLBRw0PwAehpa81hCRtIM4fzxw9q54D0Iqmmv7
         LZ50eRZp425+qTPnNgt98CrWdz1bfYtlxyD6uyVUxgVbxYQn0VHqQBpW8AAU8ndpdyx+
         InAzngwR6GwZIf/duP/ow8kB4pKnjZSsIlyKgXbhr3C2ZeM5tHrwdMnlXoKillvdbAnT
         LbvZ7gtV3MZPcVMqsWnWSyGARmAMpaNKYOLvW5xq6Bx1zLbzGAI3iMkp+YhNZ3EpB929
         gjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763786781; x=1764391581;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFD4F63S1jKHIhSd+FauKFk8n/SSK6ModuLxc9Mx/wI=;
        b=f3xT3w3M1xJOtL9Adm635y/iISGUAUcVeKNFwftApguv5IIsw4gAhyz/D3TS8r0Qmw
         JjHrEkbTWTiQFUHRgRO5SjneysrDwcRW/KxHldbFrnxlrmiFFLoOuihAypRiEgtzd60v
         gdp6KUII5bNWXZjiyFVqFBf7UDBGoIpBV+82ZzzDugflfgJA7NQOKn+zFAfpLCgelJHI
         SZwbfkozTtnJLMQCQVSu7bUcm9uypYlqBnNOUr2TVb+rvpIvKDoRdeTMYcj2pfQQtJOH
         92cgUCdaKjAWHKvOBfQG+eib7SO2uGKTUucbOPI7DunkwEGOWdtsRyDuAO1gxuc7x8FK
         KwcA==
X-Forwarded-Encrypted: i=1; AJvYcCW534QRGxttCVGoFOtPGCQtUM1YpVWDjTM/VmdsDzFrETIoWLmOb5CmzYV1w3Wx08+a7MUmh0Hv@lists.linux.dev
X-Gm-Message-State: AOJu0YxOGtXtxfVjFeCLFPDn6GfX+hJBHxWdMCXfMMSey/aMNYc/J5vC
	yGEXblS9P76w95lRCkK7jKlV5B+KMmosQ1/FXw7AQwM9PaDsRkNvO9tdAIeEILJNulFQEibamc+
	27975n0IYm8EAlPhS2hT8Ga2ZvTH2Kx00ZHWsQvICWQ==
X-Gm-Gg: ASbGncvKXs9m+TizxmEwM9ILut4H38aF4jsBoKiu8GR0vPktBhnDR/Qlm+0qNCHwMMP
	80cGND+Cjxiepn8NlYSpCkeRD5FyCQkdjqaytLL5rTAZvNxcKaw8XWMkUreS81q9qO9O+S1st/q
	LoBlnwOKNjll1ECOydZRhrztiXDWRpuyN7qM38thzQ6iKtnFXU7jBmG4UVRPkZhTqeC6dfH8vAg
	MjGFHX/TwNZ8dzxpQbrHpcACm1tHDnazCb0qBC/PdIov5lnyoegFGyuAZzLtpv53JFRfAVVAR7Z
	+/PmvjPr2+ri+f0WDGDr/dBfnQ2O
X-Google-Smtp-Source: AGHT+IF7Ky6fXLLPTBbyKFdOUnaF5L5Jmh6zpXpleeR/UXJjpMyZWNLPmIdueA/UUorx2LfkZ2wN6SM8GdJbO61H920=
X-Received: by 2002:a05:7301:d189:b0:2a4:3593:6468 with SMTP id
 5a478bee46e88-2a719296c49mr1718921eec.24.1763786780767; Fri, 21 Nov 2025
 20:46:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121130143.857798067@linuxfoundation.org>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 22 Nov 2025 10:16:09 +0530
X-Gm-Features: AWmQ_bkopVWMkJW5a1VrVVai9150DadJbk_p7WPf2ggQRUZW-tDWIpMe9O62a0s
Message-ID: <CA+G9fYvyiLxwGFN-3QuK4PR2nAmFSp8whe6yfTMXB+FoKHhjrw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Nov 2025 at 18:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The LTP syscalls listmount04 failures noticed across the 6.18.0-rc6,
Linux next-20251120, stable-rc 6.17.9-rc1, 6.17.9-rc2 and 6.12.59-rc1.

First seen on 6.12.59-rc1
Good: v6.12.56
Bad: 6.12.59-rc1

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Test regression: listmount04.c:128: TFAIL: invalid mnt_id_req.spare
expected EINVAL: EBADF (9)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log,
<8>[  467.451816] <LAVA_SIGNAL_STARTTC listmount04>
tst_buffers.c:57: TINFO: Test is using guarded buffers
tst_test.c:2021: TINFO: LTP version: 20250930
tst_test.c:2024: TINFO: Tested kernel: 6.17.9-rc1 #1 SMP PREEMPT
@1763732790 aarch64
tst_kconfig.c:88: TINFO: Parsing kernel config '/proc/config.gz'
tst_kconfig.c:676: TINFO: CONFIG_TRACE_IRQFLAGS kernel option detected
which might slow the execution
tst_test.c:1842: TINFO: Overall timeout per run is 0h 21m 36s
listmount04.c:128: TPASS: request points to unaccessible memory : EFAULT (14)
listmount04.c:128: TPASS: mnt_ids points to unaccessible memory : EFAULT (14)
listmount04.c:128: TPASS: invalid flags : EINVAL (22)
listmount04.c:128: TPASS: insufficient mnt_id_req.size : EINVAL (22)
listmount04.c:128: TFAIL: invalid mnt_id_req.spare expected EINVAL: EBADF (9)
listmount04.c:128: TPASS: invalid mnt_id_req.param : EINVAL (22)
listmount04.c:128: TPASS: invalid mnt_id_req.mnt_id : EINVAL (22)
listmount04.c:128: TPASS: non-existant mnt_id : ENOENT (2)

Summary:
passed   7
failed   1
broken   0
skipped  0
warnings 0

## Build
* kernel: 6.12.59-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 92f6b4140c17182e28e19312fce7c6ee90cd3077
* git describe: v6.12.56-790-g92f6b4140c17
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.56-790-g92f6b4140c17


## Test
* Test details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.56-790-g92f6b4140c17/ltp-syscalls/listmount04/
* Test log: https://lkft.validation.linaro.org/scheduler/job/8532397#L26259
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/35n4IGltUEJH9dNtMu47XsPdqo4
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/35n4GHe84Of9RjprzsxRkq6NEho/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/35n4GHe84Of9RjprzsxRkq6NEho/config

--
Linaro LKFT
https://lkft.linaro.org
