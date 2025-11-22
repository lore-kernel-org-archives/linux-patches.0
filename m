Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F6D221FCB
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 04:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763786475; cv=none; b=bSwHiGhyvVuW8aYfN2GfJtMdpqCO4epDMY2FwvzTqt/AwWosoxIXTQI/D3WjM3C/0WzJ2d3sRoC8g3JsFUhJOzfhcfE518ybvLrvfQ2fpxC57MZD6ggNPf3yHfFMfXuDZ2w6brAq4Gq4Tx0utk44TYrzAiEFbZLarUx0MlZD6M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763786475; c=relaxed/simple;
	bh=h9VyW+WQyP6sSOegdIOdImrqU/TplUV3/Z9dqepUB1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIWmRxXFVKMnaS9kvJei7raz0MDGGQk/1FE+AjkhzZo7lZrdcAGiXsskmX/yvTPemL8rZMlyMgbBjwAHAeLK/6pP/7KM8S54fKMwpjB8FhrfXhVUA653barDtvk3fPbM0vqqf5fNh0mBwrO9O+vFdEUUKW8+KuLaMLeQCxtZo/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sc1gFIE9; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sc1gFIE9"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bd1b0e2c1eeso2011124a12.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 20:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763786473; x=1764391273; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P2OfHfYMQD7BIWZ550zETvyeOjFs/FkoMlr0NVso26A=;
        b=Sc1gFIE9nmUs/pMn8PsRHU/gzXTbAI8OOcV5xlBE8m9pHJi3TwuBhiJfOWQnxonKhr
         mZctUIDZGcNweJ72RytKpnXKYWHgQLiqhPZf5Hxhe9y2w9Lz9Pp2uFSo5TcR1qyaTe4u
         sAyZTDciH3vK/NPHkI+OZGN4fJmOitVYjASbMKVOkRvtw0kmozYE+uBQ3jxh48wmyszx
         vTXs20s6Ah2gSSZ6kYSmT5S/M1swoL4zkVeK4Dm9gA3Tjm2pUvev+QQjK1RphVi8Jl2J
         r05/sIbYnPtqfLXtSxYxGViqf3oXeveDEDo0PduIS9/q4VPhQt/cFsIc3lT2b193RkMm
         QahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763786473; x=1764391273;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2OfHfYMQD7BIWZ550zETvyeOjFs/FkoMlr0NVso26A=;
        b=goYKC5kSEOauGcZEGKx+BXqPyU8sfQJHlkaxov8yhaKyTHKa7zuJkLKYhA400HkGU3
         LL86zzHtEaLjmukl9FYNpDDcE3V/TR/R7FyIdkhE7m4nQDj1oRhnyo2R+7FoBiYs86nA
         k/cNypaWqlYf34FddOqyCjYaOsl1Yj/nbwjHocmKNTNEworbRpAMAtzP2j6UbgnpSplr
         MuVI8SAYp2wXrc9muij/JQRZ419gQn/nihNk3/YbVlyxmRt5iLZjzQPtXf62mmNIsP3s
         lXpNToodnWQezpSWDGGQs7lBGJORc1+cvR3FKslKKW3VhDwCFkt5zrUUugkyaFbr7uBQ
         e0cg==
X-Forwarded-Encrypted: i=1; AJvYcCXmEgjNrf1SpMCmp695JOa1GSC1+DKB0l3Pskw81MGKVhtlrzUCcAbPHkbmHqQbfvoQN2mZa0F7@lists.linux.dev
X-Gm-Message-State: AOJu0YyzOrfySNxRJFIVLy3lPxgEiIrNWjTsY7ucLNFpXB3M9O2k2pDa
	91hMU8aAHY4/XCwLi3cZu/Lgmhsrd8w9D4P8V7nVdPxrf/pcf2CJo/xsMSwZiPobYw7IGcCypeI
	y+L37DSzFnmZI1XjzjsprmrLwRke8CvsgRKPwOEn7lg==
X-Gm-Gg: ASbGncv5/IuFE4WJaLhdIOiTxkn6gnnXtZ6gBPsamD/SCmDD46YrBupDKrJAiP+pWgL
	bkEhwvnOx3/PFByfw2N2J301tfLCaKVAkKeSeDEIoHXx93ITxFgvNwcZwvpuYEDs0W7f5ayii5t
	9gGj+x98eBDGODV5KUGJGKqx7K3NlW0/5KHhwbZcQITnZcaqoQFGmBX/35VOL6rfzO9P1b0jNbQ
	GUR0ncx1KMBPWosKFDNh0ib8StPk7qd2heJ1SCCjQsErw54dO+C7hXMi54NO7iyXfQ067ObvjpV
	SvVmIEepJbYWO0F1CSz91FMw+53hvZAueO176cs=
X-Google-Smtp-Source: AGHT+IE8oEB0Bk/WUV316rX6l836nB/xJn7OLenveTC22jF0e+Qj166dl6/klF8TEtvtM/R/zQi99gF2oec8bULJg6k=
X-Received: by 2002:a05:7300:b593:b0:2a4:617a:419f with SMTP id
 5a478bee46e88-2a7194a9af6mr2638588eec.2.1763786472525; Fri, 21 Nov 2025
 20:41:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121160640.254872094@linuxfoundation.org>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 22 Nov 2025 10:11:01 +0530
X-Gm-Features: AWmQ_bnWr_rQO39FsnhRRTwXh3oyCJ2CUpy3Um6q10yQWTSxEQLiDtW17Wfwwms
Message-ID: <CA+G9fYsomsM_07yAZ=MShyjFRXLe26Vm+-tPv81YLOO-SPqo6Q@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, LTP List <ltp@lists.linux.it>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Nov 2025 at 21:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The LTP syscalls listmount04 failures noticed across the 6.18.0-rc6,
Linux next-20251120, stable-rc 6.17.9-rc1, 6.17.9-rc2 and 6.12.59-rc1.

First seen on 6.17.9-rc1
Good: v6.17.6
Bad: 6.17.9-rc1

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
* kernel: 6.17.9-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: ddfe918dc24b5818022af062d1685d31fcdb8b3b
* git describe: v6.17.6-1131-gddfe918dc24b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17.6-1131-gddfe918dc24b

## Test
* Test details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.17.y/v6.17.6-1131-gddfe918dc24b/ltp-syscalls/listmount04/
* Test log: https://lkft.validation.linaro.org/scheduler/job/8533736#L25762
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/35nQWH8wgEwiOrUmrLn0I3NGkyh
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/35nQUZuM39Pa120Y5iFXGyRw4Or/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/35nQUZuM39Pa120Y5iFXGyRw4Or/config

--
Linaro LKFT
https://lkft.linaro.org
