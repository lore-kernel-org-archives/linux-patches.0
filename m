Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E926830C34F
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 13:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758202095; cv=none; b=dX7zzdrHgaqwkfn08tkY0ZLLC6H5U96VBnvEzPXxFm/ijnklD368cF9UIsGkwu6VQYCRyUMTGdbzbwky6yZk5he/oTqqWQQVwBYjOP2Tlymm1TkUxt1Ijp44Zbqn6ayMxnwHszqWULWz6sJX3tM8x/d/HItrGeGnGZqTEz1PLyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758202095; c=relaxed/simple;
	bh=Uo4HGmijL1iQgbMg4uhdWXoXsg7KT6SAxbbAAkAr18g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gemPfVNJAx/ANjxs/fjWeg9KZFLWSfC1pK7ndJbybiyRf6nrU6wkPJveu2MiV7fHM+qKvWGyhF7WzHSq834E6rhL7vRK4mNuktfy1XcszE4s48sUn/j3E1a5kA153uE8qN0l0wP+Aasot2TxzpT1D76sWc87HSwy6gyKLU7mx28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P26oj/Ns; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P26oj/Ns"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b606291fddso562051cf.2
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 06:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758202093; x=1758806893; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tUNolTQcgouJkWXCDG6MbN3B7+59q/SI4c38sI/f7/8=;
        b=P26oj/Ns41sR0TVuQ4ASm06DB8+g2vTcbGCQF7a4MDafhXor7K/K2ib3B6VuDxMUmS
         d25YySwUSBX0bA+m29QckQyf3Knq7DkshpeFb9GROWKVlTRf3AGo+afBcwSex3RlSiDP
         b3zkrX4uUM3/NG5s5+nvRR7Amxq22xeEPUmSM4WTKVat4RSelCQvEonIUFi4ZQSE4Flm
         7MGPvVPK3vRDsXM7npHFf7bdO54htrxDHBFT8gr+vlOre+hBE6GKB87x4j9Eu+dOQyWo
         Oeme5bosYfZ4+DOXu5Vm/7SuAUOP6/Xdl3pbih072CcANUszULTS34ipmZfLnZ5wzzmx
         ijWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758202093; x=1758806893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tUNolTQcgouJkWXCDG6MbN3B7+59q/SI4c38sI/f7/8=;
        b=vh60HSUN/r3/2RXQPlls/xrTLwWktGvlDRfxkeSDw9d4dXyUqSvQruEfPDB/UuM0Gp
         o0hF79CVOzNn93tjQ905X5s/a8rexkREOYYWkzprDD8eIUb/NxkJCcmhmAFzM16Hlwh7
         2SveBQP16iT4TnTe+5CrrCkpk6eu+6WQgAnXa++BUf/lozCbvIqmyglLBpCv8jmdewDd
         Ecu9c0dwZJD6R4ONAq1F19pQqn9E9DC6PSzf2B2yxoo82qn5s26QW91iNvwCgsuZqerS
         EPxSza2B53YUIXc90JooW64G1moOJ5W0qJnxoedbsTIZgDcPNbBrjXu6DMqtTLCdTB+q
         foKQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5FrIKz0nHByUABA4KYUXChzi29DQSrD6EirDb2LhOGCQOb+aoL7Skt/BTEA/ReXYjo/1k+kz3@lists.linux.dev
X-Gm-Message-State: AOJu0YyrF/V6v0dbC1ec2tR7hCXOWze6Zf/xpPHZ/5LRWeGAkgoJGYf/
	tX6la52y9ftrNN0GxXk0aLrEdVlNAtAWsxkEitlIt+BN6CdEV+rGwET712Rd6bxAnJ8jdFtRtRw
	Nx6P15stjvg68yUjkTXLHNT2pZrb2KaAAP+6zjWSwgg==
X-Gm-Gg: ASbGncsDwTE7KDBSDd6nqT1qjwNowh/jeZ6iZA0YyHecvbF6WPQrNhq8AdD0wuYgnjF
	rT0CwGuBxWAhShBF5pggDEEspKBg7B7VANBSs/3zeNVhg+q8ArCwmIYvfXkB/fyuczXXvFGzvqE
	iYyh/pdBSHUMMm28FbAEil7VsOhmoioxu/L5+EOTk3NXrMdzwaqt8rK7eooQtLGNIIRg88SXafH
	VmcdZOROv7i3IuXT0HiCsodlPeAbG/ixr7N4YfYN5FQmkc+nJIXdx6omy8=
X-Google-Smtp-Source: AGHT+IGG1jIhGHKRZY7W8sUafuow8PRDueZE/olQQVTbSEj3fkdgWUl1XE9/jN4v3lTvkJ+Pwv1rYCrx3bZQzI6XG9c=
X-Received: by 2002:ac8:5e53:0:b0:4b4:9175:fd48 with SMTP id
 d75a77b69052e-4ba5fdec15cmr43627421cf.0.1758202092667; Thu, 18 Sep 2025
 06:28:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250917123329.576087662@linuxfoundation.org>
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 18 Sep 2025 15:28:01 +0200
X-Gm-Features: AS18NWBXC4NXI6frSic_5ZXkZR1iZr1QKJv-a6qUPIBbwfHXqxFk1OH_y2U-vbE
Message-ID: <CADYN=9Li3gHMJ+weE0khMBmpS1Wcj-XaUeaUZg2Nxdz0qY9sdg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Sept 2025 at 15:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While building Linux stable-rc 6.1.153-rc1 the s390 allmodconfig with
clang-20 toolchain build failed.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: s390 clang-20-allmodconfig

Build error:
arch/s390/kernel/perf_cpum_cf.c:556:10: error: variable 'err' is
uninitialized when used here [-Werror,-Wuninitialized]
  556 |                 return err;
      |                        ^~~
arch/s390/kernel/perf_cpum_cf.c:553:9: note: initialize the variable
'err' to silence this warning
  553 |         int err;
      |                ^
      |                 = 0
1 error generated.

The bad commit pointing to,
  s390/cpum_cf: Deny all sampling events by counter PMU
  [ Upstream commit ce971233242b5391d99442271f3ca096fb49818d ]

Build log: https://qa-reports.linaro.org/api/testruns/29914085/log_file/
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.151-87-gb31770c84f52/log-parser-build-clang/clang-compiler-arch_s_kernel_perf_cpum_cf_c-error-variable-err-is-uninitialized-when-used-here/


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.153-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: b31770c84f5240661141c61344d502129a9bda56
* git describe: v6.1.151-87-gb31770c84f52
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.151-87-gb31770c84f52


--
Linaro LKFT
https://lkft.linaro.org
