Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0760C25A358
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282190; cv=none; b=EhSB28nDcpDaoF+DBJ4M5A71fhK6hJerCGu1XvfDWuShmNXAYNSiwz0xYtNJiDhl0aFzCxNLNqkA+AgW+kqNthcOOD+FJLY7bFwC4hN1Ydju/3lHdcwUc9ipCgaDSCoRB0si2XaqR4xjQqYDdhT98j1gyQbyOxf+ynNj3+HpiMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282190; c=relaxed/simple;
	bh=JiXBBKulzpm1G4toJd+w3rK2oa2JI2KBaqVst92x83g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MJj5hx385V4bbDt06E1Xu+AXJ1ZDIVSe7dIbDDXbNAt52UN/EvMwGQZokWnpoU12J2r056lRMIwJkVIvzp1fbsmLnJz8Eh7U6zQkUQlD4RMl8aWcBHhV/4gV75LM3B0AkPXw2JlTdFkvTCFuLmMm6OQjAtnX69jaCA9o0wN7R8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cCfSmLId; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cCfSmLId"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-86d36e41070so314075241.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 09:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741282188; x=1741886988; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pXtLFB7rHzBBDM/TAUEEN+9FpT67VqyHhiDM0Anig2k=;
        b=cCfSmLIdwkeDpb+IKwWwzDkA9XpKw5I8ds4d1J/9FhRheWA6+SBcCMuhhluwVFtWuE
         /SJy796QBExSephiyaaYfowEmpWVci9u6/EPuBWuYIiufjsgiH9f1ezVjV8xcFLm2nQY
         dztUcEQP+NEhQd3JXEVS8svSPTclD2M/hIIpco0quLFoTl9PKYrpYhGz6eTxKbK8kpsL
         boHRT6PSxXl5swT9Jht807NPv8GUumdK/nFJ62P6Er1yRzSCUAZLgwqokJZOb9hwcudw
         ur/YIxAXocGlUDXHKcbIndrzq88JlAtN6jqlXLSwVhN+hzVsK/i84ecyA4apvyOw/2dY
         uEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741282188; x=1741886988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXtLFB7rHzBBDM/TAUEEN+9FpT67VqyHhiDM0Anig2k=;
        b=A5R7XcpZdEXjnQPW2HSn9XBxMsmz+zmYG0pi9eZWWZBXdgGdcWe/Yp2W60+KxHXfUy
         GpJ8KRKz0VlvXbyLuYi0YOPfVYJWBmL30PBkZstG/4iwsDYPvS8jC+Fwh0pLDpB8XrfA
         X21KQ57+tZrokBEepIc0rsGrTpl2euUj4uCr6u3PkCD/vyrMlalucqhj/HCXwIP4G4LP
         o/y7wwM0PSXas5KbUdBcZ2Nfrubbe2DSCMNecCoYZe3IQ9JLZuI1iaCZPfIl8U0RKtpi
         PlmhnUGTq5VW8qFW3QqcpHnE4T7ViLpBQfIJd0GcXPQYEaAi6IGPlrgrYHezcCPzeFz1
         msQw==
X-Forwarded-Encrypted: i=1; AJvYcCVbU96AY9/Ivk9RqCAuHlvgaXYXFUwWbxBmDBuPHNnd+yshDl0DEaDnidkMv3LtA35fkkjALhBB@lists.linux.dev
X-Gm-Message-State: AOJu0YwhcI7/kQ1VA3Kst/CnDkqeboG1PvmohsbbQtfBT1alYEgay7u5
	d+bbju6hGpn8SDD8Et3OgRrYEoKzQWZzO9m1nkF+7vmLtzIbSpgLhNcGFF6xpl1SGfXQJSYao7j
	WZCyY5WfhUQh5/MXeC89eHBWpuEtkMxaCEvegtA==
X-Gm-Gg: ASbGncsIkOng9apnNd7apY+kh0d5oUFsvrJgbxOgrK8GoWylEE0dB6rdt8AlOhW6H5C
	ssTdc3MvKMepvFZ3HOt/5AXzscZ7/ZTmGRafBsz7BtGGECUfCbgez7CplB/sqIEX3BkZcT5s+xY
	NW/sWtvQRre/B/pBc5C2RtFHrj8AHmQXbJgGVRwAu7awp9VKnFHIdzQnzIk9E=
X-Google-Smtp-Source: AGHT+IFNXCtuHq8zvVxiVQYiR8dorrj9uyzpsQMGx5pTaYKW3Lqu3uOnXFHmE6jvJxArEtny4FPQcKgSRyM9FNa8LGA=
X-Received: by 2002:a05:6102:3594:b0:4c1:90ee:ab2 with SMTP id
 ada2fe7eead31-4c2e2815489mr5712797137.14.1741282187745; Thu, 06 Mar 2025
 09:29:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250306151412.957725234@linuxfoundation.org>
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Mar 2025 22:59:35 +0530
X-Gm-Features: AQ5f1Jo2c_NWeRxraJqOe3rUK2VTQXZDSVRCocH07muKH4PVHGeh0vesJBzv5Ho
Message-ID: <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	nik.borisov@suse.com, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Mar 2025 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regressions on i386 the defconfig builds failed with clang-20
and gcc-13 the stable-rc 6.6.81-rc2.

First seen on the
 Good: v6.6.78
 Bad: v6.6.78-442-g8f0527d547fe

* i386 build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: i386 microcode core.c use of undeclared identifier
'initrd_start_early'
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
arch/x86/kernel/cpu/microcode/core.c:198:11: error: use of undeclared
identifier 'initrd_start_early'; did you mean 'initrd_start'?
  198 |                 start = initrd_start_early;
      |                         ^~~~~~~~~~~~~~~~~~
      |                         initrd_start
include/linux/initrd.h:18:22: note: 'initrd_start' declared here
   18 | extern unsigned long initrd_start, initrd_end;
      |                      ^
1 error generated.

## Source
* Kernel version: 6.6.81-rc2
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 8f0527d547fe50fe08bab12d39c9a2cfb4f6ef3f
* Git describe: v6.6.78-442-g8f0527d547fe
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.78-437-g9f243f9dd268

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.78-442-g8f0527d547fe/testrun/27525967/suite/build/test/clang-20-lkftconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.78-442-g8f0527d547fe/testrun/27526163/suite/build/test/clang-20-lkftconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.78-442-g8f0527d547fe/testrun/27526163/suite/build/test/clang-20-lkftconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2twuoLsehi5aV5tpYyqa6pqU9cZ/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2twuoLsehi5aV5tpYyqa6pqU9cZ/config

## Steps to reproduce
- tuxmake --runtime podman --target-arch i386 --toolchain clang-20
--kconfig defconfig LLVM=1 LLVM_IAS=1


--
Linaro LKFT
https://lkft.linaro.org
