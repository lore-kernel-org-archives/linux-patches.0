Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB52231845
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594617; cv=none; b=SKSBNMZ7XeeeaBy8i+S/V38jW/eodDSPrq8ROzJkceKmTXkmlXHzkhckqwrmuietWCzkuEzBTdAteTxX8BEMhOMgNoyT6kdFGkvE9WTgJvdcJkxpo31UP2ENZ0Wqrqxk6aIDurQuDS8uokJ8bgbrYp1mmEq2QqJLXEAJqwBUMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594617; c=relaxed/simple;
	bh=FHNYoF/IQm3NSjCxvVug5AzXG/Jrr3TW1MTDfbczAZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UjJNGCWTP845ZsT9tq0vuToDzeBSrVCRjoNdWCD9KxwOjcCGJscyg5K05E7xyxwxSmW3GJLi+D91bil3nt6KrLeQijrkIaH3e/xfi4iFhiV9OyJskYmzfjphisjEJYwaJrRNYA61yVlBXgZZG7fvorwFHw4WVd5Ez6/gjZH0c8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r0+FcoS5; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r0+FcoS5"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-234d3261631so45848775ad.1
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 08:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752594615; x=1753199415; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UIIjN1tqZmWeaG1/hcRkxBvRGWhZvdkRZb14oJrNFAE=;
        b=r0+FcoS5+UDu+zjcghxkUXt6gweRYAQ2b7dtnhTasra6AzUqkPvu0igksokUMjBaxv
         dYwViMES9Jhjdm8rKkYXZu+V6Lpp4muMRnJOHtJJa31+GnPQzNn+unRiLcxNh2FkEI9v
         mtxt0eKchF2j7idauqRpxngfhuErKX9cXMOOyXGuLz0Wa8rA8iExWng4MnUQrEJFJjRf
         1Zjua6raEQUBnAZfhd+apeuiCUC8qrQBRq8mB2BlJZlKGefHomnH6EVkIHCq4Z5cVAdN
         sjQ9miZjICI8X2fzsQr0Mw11/JNi/nZcXMHFPEBcJ4pR8bSN+gJFMkMqLua4KMT3eiPr
         pM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752594615; x=1753199415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIIjN1tqZmWeaG1/hcRkxBvRGWhZvdkRZb14oJrNFAE=;
        b=LSENrrtldqFzPk8twz4xIYhDsAOJmLl2bAQum2qi1p4WlW41Ap8fWlAnQfgLAub3m0
         zyt+eJo876Wh8GUZu6iRzF4YN6KJVyQU/45sztQ9Z23MOBvvsLK3JyDStCRTG3SfkAil
         fZlB1jEm8HTrKRuRs4nUPD0Wd44chWpeIkRYhRpoD9Ksytg69ynOJRUw9iqQNFM7ou6U
         1A0ro6NUP0Nl30s4IgoZsMB0DcMTBBE1lFbCIVTJb7y58VCywUBjskqT2NOtU9+o0COn
         rRN1Fq/PcIyqnFXuLmjZfKEIiTcfvFG7/RiznfIDW0DjepUsiK7iPtpsXqtWYncREhx0
         MstA==
X-Forwarded-Encrypted: i=1; AJvYcCVHKarDdxJbTr9sw/bftJyB1PKuGmibCQdVp6dqu7/y4MRfKbR8QwOg/wlk/zPwp5BjmXAEmDTq@lists.linux.dev
X-Gm-Message-State: AOJu0YwA3v6WkSnF+aLLRoXxdxMollZauBJR3ZDQzNZILTcWCMFtc7TT
	emjxobeXVROA+oDWLthvd/yoo5+AwkNrok6i2QrGHaZra4ZBrrCfd4fdTvt7vVDIg1b6aiI7kFi
	AzOnnCaoVForZfxMkCEnmsdTvZxl8yfL8v+z5T4zH1A==
X-Gm-Gg: ASbGncsBihuCTAzuubpxcS68pwKJWJxQk+K65E1K7G/AtHErl2n5T5BraL+LKNC1BEW
	oFKxwR/qLyYHquz4D2ea7iLQVbRRI7Boy1kKFs7yD3do0ey7OaEhZ1SmyZysXn6OHk1rfcjML8S
	w9StudY6U9KvH5DdFf8T5jUk6/znOU5OZSVhDxUnxoclG53VBf6X9gEDMdyhwcHC9g7tMqNtn6o
	zaqKakOJluqSLkr82Sgdioz33tcG+lctXmbu0p0
X-Google-Smtp-Source: AGHT+IH2GHXAddytBVzHlzZlUwWfVVizUg3Mdfrc+tcbn2GstC4n4ER7+JBt8opcBUiP2rYzqVGpfM22XG6oLoXJSWs=
X-Received: by 2002:a17:90b:4c4a:b0:311:eb85:96f0 with SMTP id
 98e67ed59e1d1-31c4cda5bdbmr26421022a91.29.1752594614605; Tue, 15 Jul 2025
 08:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715130810.830580412@linuxfoundation.org>
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Jul 2025 21:20:00 +0530
X-Gm-Features: Ac12FXxAa1vyHVydMmn1zKgiK1rEAJyfq1LsZRFvEdK5Vf5oHcOwb7L5DrB1big
Message-ID: <CA+G9fYugxp3W1-0Q2QNruE9r_a65M0gaE=1bgb-q+JS5GogAfg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/208] 5.10.240-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Borislav Petkov <bp@kernel.org>, Kim Phillips <kim.phillips@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Jul 2025 at 19:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following build regressions are noticed on the stable -rc 5.10.240-rc1
with gcc-12 and clang-20 toolchains for the arm, arm64, powerpc and s390.

First seen on the tag 5.10.240-rc1.
Good: 5.10.239
Bad:  5.10.240-rc1

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: arm arm64 powerpc s390 drivers base cpu.c undefined
reference to `cpu_show_tsa'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
drivers/clk/qcom/clk-rpmh.c: In function 'clk_rpmh_bcm_send_cmd':
include/linux/minmax.h:20:35: warning: comparison of distinct pointer
types lacks a cast
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
drivers/clk/qcom/clk-rpmh.c:273:21: note: in expansion of macro 'min'
  273 |         cmd_state = min(cmd_state, BCM_TCS_CMD_VOTE_MASK);
      |                     ^~~
aarch64-linux-gnu-ld: drivers/base/cpu.o:(.data+0x178): undefined
reference to `cpu_show_tsa'
make[1]: *** [Makefile:1226: vmlinux] Error 1


## Source
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Project: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.239-209-g5baac0406819/
* Git describe: v5.10.239-209-g5baac0406819
* kernel version: 5.10.240-rc1
* Architectures: arm arm64 powerpc s390
* Toolchains: clang-20 gcc-12
* Kconfigs: defconfig

## Build
* Test details: https://qa-reports.linaro.org/api/testruns/29133328/log_file/
* Test run: https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.239-209-g5baac0406819/build/gcc-12-defconfig/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/2zuksckfjhEl6lBDDB8nn2ne019
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2zuksckfjhEl6lBDDB8nn2ne019/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2zuksckfjhEl6lBDDB8nn2ne019/config

## Steps to reproduce
 * tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
