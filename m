Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A477078F4F
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 19:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750706190; cv=none; b=prM0dEFuAZQ+oiZ0sXM6kCHz4K58Gjgn3iudVuIN8tsn6cIppC/fhukw2iKn0JsbcKkcpdT4NmCPehvTOSmuRNPlkztgOh19khZlrCK9x0WpP1c1bzYKsHDosntPtpr89E4ODRBU5EIJugPW/KQBtccOHxagpDfUosq3xHYAjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750706190; c=relaxed/simple;
	bh=16ajhQv5os3Fe8HPOj3wleQOPP9qIpb/CjsQFZOKpuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WfSYNLe3TSR9aS03LT46nzZKOodOnTJuLxlqEhuRapcxS69F2bNxbKVSpepMDp574gyjMeIW2N+TK75sNrNTdFAJS0F9x8hezviwu309CG2TOGziLXSM+/USxdXMF9LV5YQdUmR/bVrFmubbuj1ij3eUHyd43xy0/JoT28Q+VVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nvXXqPS6; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nvXXqPS6"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2363616a1a6so36845505ad.3
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 12:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750706188; x=1751310988; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wKugEmOPj2OnBJsKBHzxcLtnIp31cFhUKP6WHxuOkns=;
        b=nvXXqPS6ASOCP5SQh5S4SkvDD4gBIJPLkKL8newHFgmqHZPphihg84cqpTdvHR9zAg
         68KRgXXWuo40fYh6dcN5UZ00PnNIcTmgN1llqW1W/KcorUmev2i7BOTwa4mWkghXTgnp
         ZrD8gMkjl4byhK7Hzi/g3FJ8p4hanR71ptKIQU8G9s7CO4MEJm5S+VfLOY3DGaSliFj/
         ec4I3iyrpwsKBB3prwb2fkMAL2DC29ZzXNNI0rZBLppl1PD+PBSxp88RONqN3XeWJd0U
         enUbXFgTmdacwahDnTD5GPt645qPunrCMFhe7ccSrTuqRUEcPJllnkPqSGfSOPNeg8fo
         Mk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750706188; x=1751310988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKugEmOPj2OnBJsKBHzxcLtnIp31cFhUKP6WHxuOkns=;
        b=kM7M/909hcbRPmhUn5eWu2cfDro5a+UvX3LMb9rnf9qiM7wOFjGnRD4wW+RbAGYqQP
         4lHCvcVHSysynWfvv2O17vL9EDh0RnZvQh84cgGOBFHF4tFGw9pux5beGielRt4ASRjB
         rokFKSQCP3mu8VttUSvc4YxfV9Q4ym4DP5WREWi0nngbrJX3xG3oA3tCAiXpv+lWYeVn
         AQRcGVuwEORWpuAppN6vzwXzSlB0GWr+NE/ITH0xfu/j9v0w16XNdv9vYAUtKr+vn5ab
         jSv5nED9L+D2M7PeDmCNV+BswWTXo54TTTJ5R71FNsQ7fQr9q5xHeEcshkzLR802e6mx
         7MoA==
X-Forwarded-Encrypted: i=1; AJvYcCWCuuTIDUuPjB3aXuKEpjV9y6DINOdcB2eaKn5Kg7fSxLvO7F7y8DnMbPS1mbIRnNhEiKKoXH5a@lists.linux.dev
X-Gm-Message-State: AOJu0YzuqVwt39qgw02GxkVcGGqM0hYyuqEtvSp7A7Xc3P5ac5vKWeTT
	l2wiGx2NyGp3ul8k9iNRZLocRRnuK+B5td3eEBtz4m19TRubpVO+V5TAjIH2mgfgsgAZ/5H6aLa
	/8c6n1xMfoBc5vIkm5xwAeUl/aGwERtqbqWtGsxgo6g==
X-Gm-Gg: ASbGncsKBiRPbaJm2yHh8Y4H37iVS1g7uqKuKfpPpjUEeZQ4enLSSsHY7AYHBu1i9A0
	moMTELbBwWfg+Z2tuiuxDSCo1iQ98RcsWbtttOiisZbQQaYPEvLJMaEBV4qr79BG0doJWVtOrPs
	c79ItHD2IfTGKNHWjuQmJDlgWgU87gRgUpFB9bY7hl8bIundDuAXsx/IkB/AohByK7Fyx3t9kFk
	ZVh
X-Google-Smtp-Source: AGHT+IGrFhsWx2APvDHc9B+I1PGJySlyZAw1hj5EW5+boxTCTPHRxriv2teURnE3JpRUpFRPlT0ckZzm8x0oUDOBFUE=
X-Received: by 2002:a17:902:e842:b0:234:b41e:37a4 with SMTP id
 d9443c01a7336-237d977534dmr170095205ad.6.1750706187876; Mon, 23 Jun 2025
 12:16:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130611.896514667@linuxfoundation.org>
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 00:46:15 +0530
X-Gm-Features: Ac12FXz30P3_qgT_WSMm7LFk36zn-jf-1_pKeKeTrImJ1UENQPJh4UpyKNWKP7U
Message-ID: <CA+G9fYvpJjhNDS1Knh0YLeZSXawx-F4LPM-0fMrPiVkyE=yjFw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	kvmarm@lists.cs.columbia.edu, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Russell King <linux@armlinux.org.uk>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Andy Gross <agross@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Jun 2025 at 18:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm defconfig builds with gcc-12 and clang failed on
the Linux stable-rc 5.4.295-rc1.

Regressions found on arm
* arm, build
  - clang-20-axm55xx_defconfig
  - clang-20-defconfig
  - clang-20-lkftconfig
  - clang-20-lkftconfig-no-kselftest-frag
  - clang-nightly-axm55xx_defconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig
  - gcc-12-axm55xx_defconfig
  - gcc-12-defconfig
  - gcc-12-lkftconfig
  - gcc-12-lkftconfig-debug
  - gcc-12-lkftconfig-kasan
  - gcc-12-lkftconfig-kunit
  - gcc-12-lkftconfig-libgpiod
  - gcc-12-lkftconfig-no-kselftest-frag
  - gcc-12-lkftconfig-perf
  - gcc-12-lkftconfig-rcutorture
  - gcc-8-axm55xx_defconfig
  - gcc-8-defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 5.4.295-rc1 arm kvm init.S Error selected
processor does not support `eret' in ARM mode

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build errors
arch/arm/kvm/init.S: Assembler messages:
arch/arm/kvm/init.S:109: Error: selected processor does not support
`eret' in ARM mode
arch/arm/kvm/init.S:116: Error: Banked registers are not available
with this architecture. -- `msr ELR_hyp,r1'
arch/arm/kvm/init.S:145: Error: selected processor does not support
`eret' in ARM mode
arch/arm/kvm/init.S:149: Error: selected processor does not support
`eret' in ARM mode
make[2]: *** [scripts/Makefile.build:345: arch/arm/kvm/init.o] Error 1

and
/tmp/cc0RDxs9.s: Assembler messages:
/tmp/cc0RDxs9.s:45: Error: selected processor does not support `smc
#0' in ARM mode
/tmp/cc0RDxs9.s:94: Error: selected processor does not support `smc
#0' in ARM mode
/tmp/cc0RDxs9.s:160: Error: selected processor does not support `smc
#0' in ARM mode
/tmp/cc0RDxs9.s:296: Error: selected processor does not support `smc
#0' in ARM mode
make[3]: *** [/builds/linux/scripts/Makefile.build:262:
drivers/firmware/qcom_scm-32.o] Error 1


## Source
* Kernel version: 5.4.295-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 7ff2d32362e444f6459597db979cab7af498cdf3
* Git describe: v5.4.294-223-g7ff2d32362e4
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.4.y/v5.4.294-223-g7ff2d32362e4/
* Architectures: arm
* Toolchains: gcc-13
* Kconfigs: defconfig

## Build arm
* Build log: https://qa-reports.linaro.org/api/testruns/28837192/log_file/
* Build log 2: https://qa-reports.linaro.org/api/testruns/28841756/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.4.y/v5.4.294-223-g7ff2d32362e4/build/gcc-12-axm55xx_defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYHH1epMqFqeFlNFUWiMeDjEz/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYHH1epMqFqeFlNFUWiMeDjEz/config


--
Linaro LKFT
https://lkft.linaro.org
