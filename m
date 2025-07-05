Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0E188000
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 03:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751685184; cv=none; b=u1u5brP1IWzK9Q+bVzcTSDdpKJRW31Qia+rkSs0s5nmsFnqMiXOc7sAuFSI2GYpggcKPnBziv30PIEIfvQlVjZHUw+8Iiseu7nNC0ZddNZnOQJi8nkW9RSTUwrkWmBcWDFMkHWFElPc+OwUlenfWhAwm3OFs+5Q4Edu3QfclMOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751685184; c=relaxed/simple;
	bh=DEgrMsqG6/81IQwcVT/EV/oJMUsYcrrAGjo5olWT+6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l41iQxvwUdKRtMlLI49HFlsxralolGYGcMxTY6XHQiAuLx2yXST8AzAvOsjs+03aYfbbeZ+d3w9+ZU+o4RMwgsDQaufXWbP33mH9OkEayi9W8ZSwDCNVWWO0gvlLii4AWPeprweH8AKrccSKTPecjgm8Dmq5IcadNgnTWsn9i5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pxnz2kc9; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pxnz2kc9"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-313f68bc519so1175405a91.0
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 20:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751685181; x=1752289981; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FY/r4k7To9wzgbUQkWyprZDjGaEv6yD5m4oe3Q+2M7c=;
        b=pxnz2kc9x6bXfqNyV5F5Cd9WGyKmf4A7G9D3tKWPowC5KxkvuAs8bg574KSKF+Rbat
         5Ww0+srDp6JcKNf/ava8uYTsbnCQqwfGd6HeULTLTc35pJF1AyB8CMsw/Ne0+0+BJPb6
         wdOXXyChL30jCOFLqoi2MXmO+hfGTeDxPcp7HCgWTqg8/wEcxIvtL08QrlmUlv82lnOV
         qVVcjII6IsazoyVWIrFrJU5K8SywJqcRHN3GgvWH6TbmLniS6G23qR8nJtPciFMQ0el+
         RB0IMUbg8ClkdF5idq00pHBtlw/lKEEGudsstRgI9bFBkRNAUQvUOIpTmHExmfucPEQQ
         MebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751685181; x=1752289981;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FY/r4k7To9wzgbUQkWyprZDjGaEv6yD5m4oe3Q+2M7c=;
        b=aq1mig8h43G6QmW/WhmLL33uqlzJI+Wqmp0RjFRToyjOWEcIRgKTMpCCah2QGOi703
         U7ZWfokEqLCfs5JOdmYWZGxrrEp87Q68oNIEHCYMKqV5rXsZURbsnqwyxNT0o84i3ikn
         t0L1q/cGOUfSBP8KYM4iJQdd94gFi0kIh0g6TVP00HjBhqdDnUHTRmLH2HemGHAz9ue1
         0SESizUfkO918MeVVHQcbNcZRYwAeu37ydhLFbkBRXm3X4HzorQhFULTvU44f3Kr1BYT
         1NCv6cPqFnuzPDK2CJAZcOs2m4FnJyORSn6mK9Rur4+CPCTPfGJzHyVKEH41BeMPDntD
         Tkaw==
X-Forwarded-Encrypted: i=1; AJvYcCXvQAuouf8YIRqCw3ZGEsVPwvstgnqSredDdbAbVr9Qz4X4pLvdNdcBowf4nly4VR5uZ6iqbazP@lists.linux.dev
X-Gm-Message-State: AOJu0YyUnMWRHGX/618Zf78TfB7+Ss+0lcJd8ADM8K6QS/sWYyzyp0aM
	5nszgXBYScsVRpkpzrg5jr3iDlS/XvwxNi92D7fwz1u4SzNfBHPE69EbTpQswrqP0WoZhQsQlQv
	OOqlqhwBZJiRDWNc3xTHWTlIYLkZmNt3BkwIpxstwiw==
X-Gm-Gg: ASbGncuOZ1wqu4mfZ1/q74RwhQIxoD/+AkNgyhYgBeFvuKT4RKvIADPKYWBE5LhbO/N
	SSDyhaSLMcGKePGwFGKRcoc+C+SG5LO9u60Vabt9BKYpP0QMdl601ElKOMOJEjaEPFqYh1Np2+F
	4rHRN0wsjQXKLq/9fpkh41APX0yUJ4TaJbQIvFeYuC0OyyHHbdqNgtcdmJMWuEDBnM4q7vNlm1y
	bZi
X-Google-Smtp-Source: AGHT+IGflJd1JaTbpa/qzIA7n7sOZJ4lzJGI9r7FMuK2hOKRMEiMcWrwu7I3vhUYaLXYhtjFFgqeZkJRoJXRteTbCI0=
X-Received: by 2002:a17:90b:3fcd:b0:312:959:dc49 with SMTP id
 98e67ed59e1d1-31aadcf7abemr5905357a91.13.1751685181476; Fri, 04 Jul 2025
 20:13:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703143941.182414597@linuxfoundation.org> <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
In-Reply-To: <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 5 Jul 2025 08:42:49 +0530
X-Gm-Features: Ac12FXydE-DpGIZ-SmYQ24iTSR8CT1Qg6kyUB_tQ54bVVr8vDj-OLA5wJ2J8fr0
Message-ID: <CA+G9fYv4UUmNpoJ77q7F5K20XGiNcO+ZfOzYNLQ=h7S3uTEc8g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Jul 2025 at 18:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 3 Jul 2025 at 20:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.96 release.
> > There are 139 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The following build errors were noticed on arm with gcc-13 and clang-20 on
> the stable-rc 6.6.96-rc1.
>
> Test environments:
> - arm
>
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
>
> Test regression: 6.6.96-rc1: coresight-core.c error implicit
> declaration of function 'FIELD_GET'
>

Bisection results pointing to,

    coresight: Only check bottom two claim bits
     [ Upstream commit a4e65842e1142aa18ef36113fbd81d614eaefe5a ]

The following patch needs to be back ported ?
   b36e78b216e6 ("ARM: 9354/1: ptrace: Use bitfield helpers")


> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Test log
> drivers/hwtracing/coresight/coresight-core.c: In function
> 'coresight_read_claim_tags':
> drivers/hwtracing/coresight/coresight-core.c:138:16: error: implicit
> declaration of function 'FIELD_GET'
> [-Werror=implicit-function-declaration]
>   138 |         return FIELD_GET(CORESIGHT_CLAIM_MASK,
>       |                ^~~~~~~~~
> cc1: some warnings being treated as errors
>
> ## Build
> * kernel: 6.6.96-rc1
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * git commit: e950145d456d01fa4e589d5e6183c2f8f0676743
> * git describe: v6.6.95-140-ge950145d456d
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.95-140-ge950145d456d
>
> ## Test Regressions (compared to v6.6.94-289-g33e06c71265b)
> * arm, build
>   - clang-20-lkftconfig
>   - clang-20-u8500_defconfig
>   - clang-nightly-lkftconfig
>   - clang-nightly-u8500_defconfig
>   - gcc-13-allmodconfig
>   - gcc-13-lkftconfig
>   - gcc-13-lkftconfig-debug
>   - gcc-13-lkftconfig-kasan
>   - gcc-13-lkftconfig-kunit
>   - gcc-13-lkftconfig-libgpiod
>   - gcc-13-lkftconfig-perf
>   - gcc-13-lkftconfig-rcutorture
>   - gcc-13-u8500_defconfig
>   - gcc-8-u8500_defconfig


- Naresh
