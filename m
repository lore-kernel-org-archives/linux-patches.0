Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB927A446
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753205802; cv=none; b=iflYwPndByL8O14a7hiXIr88D9AQwZ4FAvIJrpb7MRqbED/XMBwNEdULiBani+9xRghmtd3q/UlfqNoRqW4JrlF6MIa3HNDp8GKg3Do1T5r2linWBjog/OfhOv1BqezXSN+bP/FgAusAwOOX6zl9QgdxJnUBsVpqdQN/sDurYAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753205802; c=relaxed/simple;
	bh=2axkp3f5ddX04ujyqEGdONBW5Q8IRjQZN01M0cDJ1hI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KH6/UirHGvCJHxJ+vlAe/Y8uv8+n3DJHzIPzzR97zVfyYEMR+ukftCGorF0QB12TYJqepUYOSp/H8aEKdd4dlPwwyeqiNXsiXdLOVhMh95hf2hWqu+ePm+JLra4kliEyom7QYArMfzT8LI5MjVlQOazhQOWGFy8babkuUOKnyLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kaj1P7+V; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kaj1P7+V"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2353a2bc210so52226955ad.2
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 10:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753205798; x=1753810598; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WWXPzZR17yVeEQvaLavPxiayGN5aPr+0vFgreyi823Q=;
        b=kaj1P7+VrsYzlxu502+OLZww1xnIPMD2+KUCkY4woiGqH7KtHY3Zdz2MsFjcSXEoY8
         OqiAQ1EF7aJds6Vs8Y3CxdHVfrK1GE0tEX4IgGSFHB5P5Jgx9S8uPPwRfd3IvwpqCW+c
         uu8Abs38X8/7GMnalUg8rRuQh18VPB7y8EEz5BSepVBPLNN7i0oS1VP730XaXnkfs48d
         OzJYCLuAEcALdbd+Bz8NQqPsaW4gLu5+eaIR0+jap7gqU1zay4Ta4cIt4xkedEIywTyn
         zh8MaEaYQwelVJ1wZjsYPAT9BEbqnrTMAio01r/TnLFaNcJD+MgBJ+cKnDN6KMRhFrdd
         gpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753205798; x=1753810598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWXPzZR17yVeEQvaLavPxiayGN5aPr+0vFgreyi823Q=;
        b=SIx/XVEk0QhhTDKj0dnWHPtSMgzaE/2hBmPQbpOHTZwDei9lx/MaaeSiM6L8ZFnkyV
         cHLZjhE8I1GtGnXBEkHozehNqD6uOM496cjVeQGoHxmpdAHaJciMHiRontKhyc9TMTe7
         JlsAPIkHNOheokLJzxQkQyjDJszeFO9LUGO+r7TBIvvB7jxTpRvSCbbqNhb5bbOkNZ7Z
         gpgJSuaAr5MHBpM5/gKy4DIVlqnnWGLqAPxA3tYk9abfupMUwMRI49GU4M5XAp8aPtYp
         Hi6xpJFPiTvT1GldMgaiSO+gf+eQbOiY3s3zzrf7IX0RP79TGI6W6RPNUQN89TQHqGek
         afog==
X-Forwarded-Encrypted: i=1; AJvYcCVuMYJgxB3XM3KeF1Qh1q3oFz8GrndPOXPU2T0kdp83D8nKvxzc4R8olvoSo8jEMN4IyDd79pKs@lists.linux.dev
X-Gm-Message-State: AOJu0YwNcR/NjOXyhpsNFp+pGfSouDFxM5O7l2ceB8xZxmqISyuw8MZV
	xniu/c4PStFtkv1yV3oAZ6Wf8P3/uGxatyrOHdqidgMqud60jM7Jfxta+FF1J78111VA/IyCtEq
	GbqxFm+mxfb53UYSY6HimXDgY+UerZD8I5o0lGGKvXg==
X-Gm-Gg: ASbGncuLG1MkGGRbamrgfTt/mWjPNFWSzNR/Ez8K/uSPgR2I7cT5J6GjUr8em0y4jn6
	TzoCtPCsFP3O2PBp8u2T4HusuKJst9WtmTW6Yq2aAEx+DIH2oCVtyXRAiYBojLIpnHRb/4AnT/G
	JdoUGq95BLv+VJv2gc1k0pGPYQWHBT6CwPyTZN5Qz8Toei8qrOfxZAxo+s/9tj3GO2dyd/iBhDa
	0ALf37Ta9aItFjVXxPqsOkItwn4GuZQtb/Dl1/1g0p8O0Z6
X-Google-Smtp-Source: AGHT+IEy1xm2TqQlOmdtPxzMMBfyqW6NBLNLnRvTRydQhFeyBv42+TUFYyc4kk26QAuv/J3OEh9WLD0WjO4Y+jfMmNk=
X-Received: by 2002:a17:903:166e:b0:235:c9a7:d5f5 with SMTP id
 d9443c01a7336-23e256adfcfmr297545055ad.13.1753205798348; Tue, 22 Jul 2025
 10:36:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722134345.761035548@linuxfoundation.org>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Jul 2025 23:06:26 +0530
X-Gm-Features: Ac12FXyiK9qISUvF_HIZvmbjmo4biYOCInngZ1yVyGInVK5qVkduAH0VIdLJwh8
Message-ID: <CA+G9fYs_6KYHSF6eyeFmewDxYGqqD70kO1DuB0_1qwCPV2LjOg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, clang-built-linux <llvm@lists.linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Jul 2025 at 19:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions while building allyesconfig build for arm64 and x86 with the
toolchain clang-nightly version 22.0.0.

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: arm64 x86 mm ksm.c error variable 'output' is used
uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
Build regression: arm64 x86 samsung s5p_mfc_cmd_v6.c error variable
'h2r_args' is uninitialized when passed as a const pointer argument
here
Build regression: arm64 x86 mediatek mcu.c error variable 'hdr' is
uninitialized when passed as a const pointer argument here
Build regression: arm64 x86 broadcom phy_lcn.c error variable
'diq_start' is uninitialized when passed as a const pointer argument
here
Build regression: arm64 x86 usb cxacru.c error variable 'bp' is used
uninitialized whenever 'if' condition is false
Build regression: arm64 x86 drm dpu_plane.c error variable
'crtc_state' is used uninitialized whenever 'if' condition is false
Build regression: arm64 x86 drm amdgpu imu_v12_0.c error variable
'data' is uninitialized when used here

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
mm/ksm.c:3674:11: error: variable 'output' is used uninitialized
whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
 3674 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:45:7: error:
variable 'h2r_args' is uninitialized when passed as a const pointer
argument here [-Werror,-Wuninitialized-const-pointer]
   45 |                                         &h2r_args);
      |                                          ^~~~~~~~

drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:133:7: error:
variable 'h2r_args' is uninitialized when passed as a const pointer
argument here [-Werror,-Wuninitialized-const-pointer]
  133 |                                         &h2r_args);
      |                                          ^~~~~~~~

drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:148:7: error:
variable 'h2r_args' is uninitialized when passed as a const pointer
argument here [-Werror,-Wuninitialized-const-pointer]
  148 |                                         &h2r_args);
      |                                          ^~~~~~~~

drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:3365:21: error:
variable 'hdr' is uninitialized when passed as a const pointer
argument here [-Werror,-Wuninitialized-const-pointer]
 3365 |         skb_put_data(skb, &hdr, sizeof(hdr));
      |                            ^~~

drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:1875:21: error:
variable 'hdr' is uninitialized when passed as a const pointer
argument here [-Werror,-Wuninitialized-const-pointer]
 1875 |         skb_put_data(skb, &hdr, sizeof(hdr));
      |                            ^~~

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2728:13:
error: variable 'diq_start' is uninitialized when passed as a const
pointer argument here [-Werror,-Wuninitialized-const-pointer]
 2728 |
&diq_start, 1, 16, 69);
      |                                                       ^~~~~~~~~

drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used
uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
 1104 |         if (instance->modem_type->boot_rom_patch) {
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1066:6: error: variable
'crtc_state' is used uninitialized whenever 'if' condition is false
[-Werror,-Wsometimes-uninitialized]
 1066 |         if (plane_state->crtc)
      |             ^~~~~~~~~~~~~~~~~

drivers/gpu/drm/amd/amdgpu/imu_v12_0.c:374:30: error: variable 'data'
is uninitialized when used here [-Werror,-Wuninitialized]
  374 |                         program_imu_rlc_ram(adev, data, (const
u32)size);
      |                                                   ^~~~


## Source
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 81bcc8b99854ba689a8c85fb1d39d5acdce0385a
* Git describe: v6.15.7-188-g81bcc8b99854
* Architectures: arm64 x86
* Toolchains: Debian clang version 22.0.0
(++20250721112855+43a829a7e894-1~exp1~20250721112913.1588)
* Kconfigs: allyesconfig

## Build
* Build log: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.7-188-g81bcc8b99854/build/clang-nightly-allyesconfig/
* Build run:  https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.7-188-g81bcc8b99854/testruns/1699830/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30EaSfe4S6Pi4zE2kv1TGQcGByr/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/30EaSfe4S6Pi4zE2kv1TGQcGByr/config

## Steps to reproduce
* tuxmake --runtime podman --target-arch arm64 --toolchain
clang-nightly --kconfig allyesconfig LLVM=1 LLVM_IAS=1


--
Linaro LKFT
https://lkft.linaro.org
