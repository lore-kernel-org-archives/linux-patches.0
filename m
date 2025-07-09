Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B97242D60
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 20:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752091482; cv=none; b=AC97ly8TAu+gUxxDzPMsBrbmWbrvpqMtUneFAadcHFSM+wP3iQOLc6SBsocU2N6RmI1UIbK1A+eGollfxE4ed1SJCbJvJvGNjOUhIZQPDrYCw6goUZVhUHEjOqICHOLSEmXnoNyGkfp/CQE11J04LR86z3LTPIDj/zLg8cU00bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752091482; c=relaxed/simple;
	bh=6oyYM6Bzq6DIFEVKD4PZ0b1pUz22xCymj9g6kLJahpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZtaM2zo4mNYbPTI7+zXsaldTOMzPIRhzgK9TfbJC1hrH2ea6Y0Ky21sq/uOMeV6OSBJiZpRBCJ81NXNHAJDknFhczCP1zecjTid1YIu4Fv4G7gRr9r/ItN4yjo/9lIFFqIoC70jJoQqO9iEk6EprGXAmGyg7jk5CpEef3VNVUfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G+01bcwS; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G+01bcwS"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-313f68bc519so317027a91.0
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752091480; x=1752696280; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Suysl+uy0WOM5aXjtyyo3S8JCmjXJX0wRi5U/ew7K4k=;
        b=G+01bcwSGJa/gISXIsP2vZygQ3bHJ3uKWqT8q/60kWVokIfWgDmnQVT6VtUGaHr3FB
         sR4T4HL4uGRhTRK/0T5GyCU429VvR9SpDE7WQTlmmPq3LUcd8E2tlMru5eE9aKWgrB4t
         k+aMvWHzuvzLysUkNAs5+oRwKqG1hjH85cWEm4ql0QoyGGE+9zKtWFuCAmH2Q4fQB2FZ
         6MElNkxoque//RG80bweP/4NsyH7LEFGNovhIcvL2WTFlPWv9TFdr4gcPYGPd8U9RdY/
         R9s540UxXt//WHiTkTGzhQk9Q48JDV3e8l4H9XBJp4znfDEejSB2ihprAMWf0HNeYI5a
         jvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752091480; x=1752696280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Suysl+uy0WOM5aXjtyyo3S8JCmjXJX0wRi5U/ew7K4k=;
        b=Hv7vmq//7x7ZT7qcz9ZeklxPn9ISAwntRqBDdXMV+S8hVAdyvpvPZRZQXWlzhMcHEk
         kET61wEzbHPofvMlHJYRS+o0TO8uAxglF9OOQW83h21KZW0m4ZW9sA3Jf97HJwfijJ0P
         lB+vp0mtgqrTVigflhnlvRNJ8VAPPnO9UJK1avtUTnjc/kB2sVIaQmiOOHzxe5dGdRTk
         7oqpsYxBztlrA8AdM15mNKALC0rkBQgy5S6TPTfOg3MT19uaV18o+oq9wCZH7IROxPRf
         ETRnyCxreQA5qcq5EYVC+w6adAAqfS1UKAptXYdDSod11WG/tb603URoCcSYLMyuvvwR
         0+GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUypXkA/2jNjEOHPMA1tncI61FymSszrRkQeFDIVhA/1MSgXYBl5astT1ma+pNp/HWY03bRqzA1@lists.linux.dev
X-Gm-Message-State: AOJu0YzdFLvw46CxgsbEVo/AI3cjq1W96pGUJ5T18jgkoFymdqqjpVb5
	CPXaIfYhwmppjBi8AmQ8Ct1OrUOlwX+AVXCEJeuLI/TBkcyf0pkxOryLuDoPtmB8Z6eNyibGqac
	Naciki9R6hx9GWdH9XeSnUZp4iDw9YHjtwpaA7VU1Ng==
X-Gm-Gg: ASbGncvbUa1kL8/0F+6hYKGNTgxmaMu3McWTBhjBZBMXOrEg9pgqnlChSD/o27b0ofZ
	LzCh4sM4o+XQWG4ar65vrq5Bc3V2H58ggySLi9GsA7a3CR0sVHd/PO2m03Yk02xTlq+jVJoJafG
	3Lewp1mgihN/2fax4woT2wMARkHAaQvYzyUuFn6ZGFZSZhGoyeKQmEV7R2Lf3Nw2VRNVVnPEBwO
	aA=
X-Google-Smtp-Source: AGHT+IHyb7AodBmFQk72shSQkiCXZlrFkQoW4uGqYTIWPeAZ+h2iGsmtVGE4J9dRdDa0kWaEz27u2ChQkJDWDPr3dqU=
X-Received: by 2002:a17:90b:55d0:b0:31c:3c45:87c with SMTP id
 98e67ed59e1d1-31c3c45088cmr1530172a91.13.1752091479654; Wed, 09 Jul 2025
 13:04:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708180901.558453595@linuxfoundation.org>
In-Reply-To: <20250708180901.558453595@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Jul 2025 01:34:28 +0530
X-Gm-Features: Ac12FXwQoTBN3H_JtJVT5-ethl5wWUwGHDE-rzunC_bB-mbB4lZM0MGm0RgxXb8
Message-ID: <CA+G9fYtkGSe0MP7+vXEcLxg80VC4-yHtme_xjnK-Dg8LkN1VAQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, alifm@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Jul 2025 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:08:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regression on the stable-rc 6.1.144-rc2 s390 builds failed with clang-20
and gcc-13 toolchains with following build warnings / errors.

* s390, build
  - clang-20-allmodconfig
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: stable-rc 6.1.144-rc2 s390 pci_event.c:269:21:
error: no member named 'state_lock' in 'struct zpci_dev'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log

arch/s390/pci/pci_event.c:269:21: error: no member named 'state_lock'
in 'struct zpci_dev'
  269 |                 mutex_lock(&zdev->state_lock);
      |                             ~~~~  ^
arch/s390/pci/pci_event.c:272:24: error: no member named 'state_lock'
in 'struct zpci_dev'
  272 |                         mutex_unlock(&zdev->state_lock);
      |                                       ~~~~  ^
arch/s390/pci/pci_event.c:279:24: error: no member named 'state_lock'
in 'struct zpci_dev'
  279 |                         mutex_unlock(&zdev->state_lock);
      |                                       ~~~~  ^
arch/s390/pci/pci_event.c:285:23: error: no member named 'state_lock'
in 'struct zpci_dev'
  285 |                 mutex_unlock(&zdev->state_lock);
      |                               ~~~~  ^
4 errors generated.

## Source
* Kernel version: 6.1.144-rc2
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 10392f5749b37d327ec5529958e9d5d27cf07b6e
* Git describe: v6.1.143-82-g10392f5749b3
* Project: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.143-82-g10392f5749b3
* Architectures: s390
* Toolchains: gcc-13, clang-20
* Kconfigs: defconfig

## Build
* Build log: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.143-82-g10392f5749b3/testruns/1565938/
* Build plan:  https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/2zbVlOqL24w4NUJUSg3nXcHGVZ2
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2zbVlOqL24w4NUJUSg3nXcHGVZ2/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2zbVlOqL24w4NUJUSg3nXcHGVZ2/config

## Steps to reproduce
* tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig


--
Linaro LKFT
https://lkft.linaro.org
