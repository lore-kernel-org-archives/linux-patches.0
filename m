Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DF3151991
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738841847; cv=none; b=TmsPXGcWnSSJ4fJF9lUJa4j/23mvZMpSLy82t2ZiL4/ly9+4Vg5n3hqleT7rTRFSUTCyV2mszm0low3s3gioSE+gr4tTkosd3gqgZ3yTkd3XAkfOGQMuLU8zMfhvCoJxMCtGRd0tfitQg+LV0Ei4CiL6GipVTtDkgXx15LpSbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738841847; c=relaxed/simple;
	bh=WcbLGJwq4AcwSHGQ2m2Nfejx19QckbRwA20i/pxYIw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw7CnsjrQlyG7wvHwStDMsu4qwTmt/np9wV5du9KQ735beLkY4hvvTeTalqfK12krkAOP4+42m7hrcW/HvAKRAK/gM8vcWJQVqN33J4tQ5fRtH22iLx/sxbFNIwNrzz6FwdIfs2JFBN6aaOSibV432245/0f/3oICw8TEnyoLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HZd9EgrK; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HZd9EgrK"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38be3bfb045so1185401f8f.0
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 03:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738841844; x=1739446644; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D32KWc9ir9C0HEQYeaVgTviYL0YqMb8Z6Iw4EEOaB2A=;
        b=HZd9EgrKMBek+czHQtFCVksDZ42sBiAgfb1+T3S478H+E05o7gGZn4DTRbiqmbUXWG
         QbLUEZOhSWcK/t9LWPiLEOrFkUovq5cAcc9vdPE4uDho/dSgttUWnAjauMDgh/WTkXf4
         +oTahe+j3xB+z66o1Vb40M85FdlbjhAzSxKtsCcrWKK2eBf1bUncXf+2+eGbtl2MCPmE
         /ARfvqjvW1w7qF/+wBbOSgfO/umlP78vJ64FilKsM3sGgHy/EfN98eKy3nGtIa8gGV9u
         elqjr2cCIh448YYcaVY6TiCrc/DsTicGEeLlt6EugPxiH7H1wj63Tr2AlYatTQjd9Sxv
         5tQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738841844; x=1739446644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D32KWc9ir9C0HEQYeaVgTviYL0YqMb8Z6Iw4EEOaB2A=;
        b=V4fOQj2YOW+4KbfsFtKBu16EUmotq2q/EKMFnRoPrPfQUjH2PSZIE+icKpSxr+ith3
         Bw7mc7HLFfaxkz/0+o5QE8atwfK8T52QMr+w/VqCbbeiBUPd1hBewCmz1co67EwwrgIt
         dMlkfz3xWG+zA/aN9Tj10bC+2kOiZ4cE8M7UV5EYmk+G/64+t/1RzQbX4IkVkhoaVs64
         2p3dK2wRGlZzf1NJDS4sYM0WQs6M0PHG0l/6am8ZUMUYBNb74Ts/eTS/kZu4L+Gw6kfZ
         xpSQjokS10C5duZ00eh74qU4kTCW9X7svICVIIEfp6KUxWQ5CjtoylK7OdMe+g5LMa1A
         ihpw==
X-Forwarded-Encrypted: i=1; AJvYcCVNhPt1dCq3q8nmNKnrGACvSLBgXRbVDfoOd+OPCk01RtoJyOQ/h1z5OSZYwS8ZHyUwMIHZnvW9@lists.linux.dev
X-Gm-Message-State: AOJu0YycLRIRpB3F1GQXNjiYW/FOulgnlVmH6QELLr8eopxMnNp5bIte
	15JUcJzy/ywOPX16sQAm2r5/KcjWU+Ot7bYdZGPOOMIpyurzhq+866YUfifc2Cs=
X-Gm-Gg: ASbGncsT/w9iex1s2QY9PJUjO/kUact3XKxc80vCdPcONOrKFDYoEE/4qS/5MfNH/jm
	Xp/Si73WyaX0u6x7rqlARSTCxRvVRP6T27PO4/j0oHpRSmJz9AvGMskoKSWt5ZaNBOAfPsMRJ6c
	FXNb4+BMiMJHQJyj0JLx51c4uo0UHyMqihXEEzQnJIPnWAUsXVmx0xjPGXBgMvJD8+qd6Ep0tAy
	ct/6nS805i+b2O+B0LXUMNPScUU52nVlo+ZfgKGSrhpm+CG7uDMQt26rlSv4WH65VvQyrzp5nCP
	IMDVEHja453NhSsjBn/D
X-Google-Smtp-Source: AGHT+IHpYvv/zDG4i03lgS2R3xg3LkmpfRk52jhg17y5N5GeiW6M8nXkkM0Wq0CqmV8YB3R3Sm/1rA==
X-Received: by 2002:a5d:6d06:0:b0:38a:906e:16d0 with SMTP id ffacd0b85a97d-38dbb2ced02mr2406806f8f.21.1738841844030;
        Thu, 06 Feb 2025 03:37:24 -0800 (PST)
Received: from localhost ([2a01:e0a:af6:67e0:48f1:a46e:2623:227d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc2f6aeafsm625513f8f.20.2025.02.06.03.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 03:37:23 -0800 (PST)
From: Theodore Grey <theodore.grey@linaro.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	dan.carpenter@linaro.org,
	anders.roxell@linaro.org,
	arnd@linaro.org,
	david.laight.linux@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH 6.13 000/623] 6.13.2-rc1 review
Date: Thu,  6 Feb 2025 12:37:21 +0100
Message-ID: <20250206113721.2428767-1-theodore.grey@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regressions on the arm64, builds failed with gcc-8 on Linux stable-rc 6.13.2-rc1
But the gcc-13 and clang builds pass.

This was also reported on Linus tree a few weeks back [1] and also seen on
the stable-rc 6.12.13-rc1.

Build regression: arm64, gcc-8 phy-fsl-samsung-hdmi.c __compiletime_assert_537

Good: v6.13 (v6.13-26-g65a3016a79e2)
Bad:  6.13.2-rc1 (v6.13-652-g32cbb2e169ed)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* arm64:
   build:
    * gcc-8-defconfig
    * gcc-8-defconfig-40bc7ee5
    * gcc-8-lkftconfig-hardening

## Build log
In function 'fsl_samsung_hdmi_phy_configure_pll_lock_det.isra.10',
    inlined from 'fsl_samsung_hdmi_phy_configure' at
drivers/phy/freescale/phy-fsl-samsung-hdmi.c:466:2:
include/linux/compiler_types.h:542:38: error: call to
'__compiletime_assert_537' declared with attribute error: FIELD_PREP:
value too large for the field
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:523:4: note: in definition of macro
'__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
include/linux/compiler_types.h:542:2: note: in expansion of macro
'_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro
'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:68:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
   BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?  \
   ^~~~~~~~~~~~~~~~
include/linux/bitfield.h:115:3: note: in expansion of macro '__BF_FIELD_CHECK'
   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: "); \
   ^~~~~~~~~~~~~~~~
drivers/phy/freescale/phy-fsl-samsung-hdmi.c:344:9: note: in expansion
of macro 'FIELD_PREP'
  writeb(FIELD_PREP(REG12_CK_DIV_MASK, div), phy->regs + PHY_REG(12));
         ^~~~~~~~~~
make[6]: *** [scripts/Makefile.build:196:
drivers/phy/freescale/phy-fsl-samsung-hdmi.o] Error 1

## Source
* kernel version: 6.13.2-rc1
* git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git sha: 32cbb2e169ed556d3d60e8ea56a138cef824a28a
* git describe: v6.13-652-g32cbb2e169ed
* project details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13-652-g32cbb2e169ed

## Build
* build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13-652-g32cbb2e169ed/testrun/27199349/suite/build/test/gcc-8-defconfig/log
* build history: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13-652-g32cbb2e169ed/testrun/27199349/suite/build/test/gcc-8-defconfig/history/
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13-652-g32cbb2e169ed/testrun/27199349/suite/build/test/gcc-8-defconfig/
* kernel config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2scp7tWHD0J3Iyj4KIMuqDUMKSF/config
* architectures: arm64
* toolchain version: gcc-8

## Steps to reproduce
- tuxmake --runtime podman --target-arch arm64 --toolchain gcc-8 --kconfig defconfig

Links:
 [1] https://lore.kernel.org/all/CA+G9fYsHGrgZsEEVvP0XMcAhLyCYnrCPgZJ1puT6cfQBCGUB9g@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
