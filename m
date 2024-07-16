Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0B528DD0
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721160075; cv=none; b=lzkbYUaxAvACHvcL0OtBs/+8abqT4hOip8T5wCwLRfvIMBSgtkuJ+EvSsHBzRBN8qxTmstjtuZUucicKnfS1GcijV5G0igo95ss3TPyoCYtPEQVCA4ZOZgwAC07ce/L/odDnc7D8wIF1tYq1DO5r3Wv4RKV5h+ltf6nWYWhf2as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721160075; c=relaxed/simple;
	bh=whvliUinTfvpRULhiqxTc3170YH5GGakjEVEdN9JnaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ffJ5V3EN95v4+sSc14EGIvYHJqZR1B2bAcI1Nma+r0S+36c9QZNOqALypBmw/aqdzrB9Mv1/Y0v7IZD4y49TfUSU055cSfNgbuJxchV617j2d/pF2iP2vo+4GozRUcHM2xfT6ok2Mhe4aSHsbucc0R6Wx+zdFxe35NDV9U3jGio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SKgzZt1J; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SKgzZt1J"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4f2f24f6470so210115e0c.1
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 13:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721160072; x=1721764872; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OoruTelNDegikEEcrJjnoc1yMF1fBFSJP2+Q2GOdqdM=;
        b=SKgzZt1JFJcF4N9CcJfEYjobiBYYeXO0KX4A/D29tLsFoY4Nj2SGj6LE1ocx2Y31EH
         No/RME/bwM3i7XCAtLYsiS8bdt0OoSsCN9ohhzVKUf/k2ysoRbguP34FBMAwFjQBoN0J
         Cez1fiRUEskVSyRV9IsvWglAwrZUPjOjyT2ZharRwxj4ySa7k4GUrX9ovTJEv+cms4Z5
         wEqSSwPX4ju9WCeOdsPbTnY3sj6ItSW6lQ5drdtlnuSJhwI19Nc88jaK+ydFhA7hvnaV
         gT7dZpEcWR98r6knnJfUNb0vx1frvvKV3d3QMYrj1qG1W5PEnyXQCf4PeSHTFtYKJjVf
         9SOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721160072; x=1721764872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OoruTelNDegikEEcrJjnoc1yMF1fBFSJP2+Q2GOdqdM=;
        b=glPCRk9UABEaROzIh1hihJ8qrG49qaUVDasrgAC21jbn6pUaX3km/uQOkcMiSWDz+P
         G31yT325spL22szBXo4GpcBy8ry7WO8M8lhfsJ2ihpv+HvN9pqf3xketzNvLan7Ggt9H
         UqSZLp+fjVJ62uIi+31xr3hdP91J1iQBbI6dv6blRTSfoB3pm5DoIEGDVcr+6pjJc5If
         hL/6AyjqcJmprDvkDYdEeMLjbnu4bcs3G4tMiQHWNaAj4dCX+IBshvH2b2NGf8qSvi4L
         yrz7MUk0KYMiRMJOZH5mvtFQyfh7QVBFkkwXj2nsrO2NM/mPJ8dMLTqVXVO+y1yOEfq2
         KPGg==
X-Forwarded-Encrypted: i=1; AJvYcCV7GpeNEqXi+Wk9mxm0Nsm6hcdPPiVjH8SPBnk0bS+Y0/w0fZKpy3yCqJU4eFqbPRA2xyamepHLD34F9pNV06Lo7xjG58O0BQ==
X-Gm-Message-State: AOJu0Ywp+9k/1peTk/07G9xuPFJeKfWKKwppmnUeDpYm9GCMb8lnmuAO
	U/h6Oo4TDu19WryWx+mnD2p618hKF85uvW8+544ya+FNYCNHqLDt259wvmCNo42fMb+D2d5pShz
	RKtlKeiFf9PINHvIzpeZrYvpxG/fYNZ6uCy4N7Q==
X-Google-Smtp-Source: AGHT+IF68HCygtFqq/rcGOKVvFd5SgfZ2cxp60pGpeacplZON7Ei2UAeaMsu+za8s0vvKbAzkBV4Bdcaj2sB6pKofbs=
X-Received: by 2002:a05:6122:4685:b0:4ef:3a26:6eb5 with SMTP id
 71dfb90a1353d-4f4d6d4821dmr2237072e0c.0.1721160071957; Tue, 16 Jul 2024
 13:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152751.312512071@linuxfoundation.org>
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 01:30:59 +0530
Message-ID: <CA+G9fYspx-bBGD6A7Z7BL8+ZxZson5os6=gVSWSry1dQE4yZVg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 21:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 builds failed on stable-rc 6.6 branch due to following build
warnings / errors.

This is not a new regression, this has been reported on last round of stable-rc
6.6.39-rc1 review.

* s390, build
  - clang-18-allnoconfig
  - clang-18-defconfig
  - clang-18-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
----------
arch/s390/include/asm/processor.h: In function '__load_psw_mask':
arch/s390/include/asm/processor.h:311:19: error: expected '=', ',',
';', 'asm' or '__attribute__' before '__uninitialized'
  311 |         psw_t psw __uninitialized;
      |                   ^~~~~~~~~~~~~~~
arch/s390/include/asm/processor.h:311:19: error: '__uninitialized'
undeclared (first use in this function)
arch/s390/include/asm/processor.h:311:19: note: each undeclared
identifier is reported only once for each function it appears in
arch/s390/include/asm/processor.h:314:9: error: 'psw' undeclared
(first use in this function); did you mean 'psw_t'?
  314 |         psw.mask = mask;
      |         ^~~
      |         psw_t


metadata:
---------
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrJxxJX8PC3B3Py92l53Th4Vf/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrJxxJX8PC3B3Py92l53Th4Vf/
  git_describe: v6.6.38-260-gfb57426efe05
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: fb57426efe05b3f2f49a914e3da34e3c9d61c69a
  git_short_log: fb57426efe05 ("Linux 6.6.41-rc1")


Steps to reproduce:
-----
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig tinyconfig


--
Linaro LKFT
https://lkft.linaro.org
