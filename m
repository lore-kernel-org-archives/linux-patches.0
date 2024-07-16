Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC72374C
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163671; cv=none; b=g+/faQZSIJTTHqs1+t6XtQQB713f3IeD2jNLfEj6oBSJElMi9tpfZlb1so0opnnJo7vxHyN5QxVs4U57EjAodSG2bxnAWSQhCwwl2oP1L5K/K9KRsQ41WtfSnPRQB0RcEe6YvK/HPCDYLAUVHgZRMEny91cod/rh4coNFgR1NEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163671; c=relaxed/simple;
	bh=ZhvJI5sTx3hlaxf+nVUj/uhFdYJslH/ZJYOw6nlbEVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWfbdJb9aMVJqlNo4zPAKII630htpLvzLcrv+kLJWLzwlNO36W14+Qahup9HuTAkHX/lqGq2QesWcmyPuX/4hcuqtst1EVoSFsLRRdOCjJeMbVU+xUx1Tj6yLCCaKv+5Ulzu0W1Pw1SZquDlRvCo01xJgUOLtqb/FPF9jqP7Yqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=coZBcATi; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="coZBcATi"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77bf336171so31175266b.1
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721163667; x=1721768467; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fYlSeh/88dyiZHtXFw2OhH5nX5oaBfRET6Js1Ip/Ous=;
        b=coZBcATiXe0T/JfR08n1ispttdslkT7UgmXLwVJKSbKfroSPAcn5nqyMnMa/AKAnGl
         zCH2CN1XpoJ7ej3unR0QuhQZyHgouoPJSHvRJd0H2AcuBeT97b9eQ0eN33Ks26Fdysaq
         tZ1TAsPNqGfQZn+NE03+mu4fkW30GfqRwamViedhpYlK8dmKPigMVff+NcfE9nLWqQbu
         GahuY7prhsXhyJd8/cIAiGrgC5B23JbY3ETUhQYcZEdsozuXqcTs0kIQWcql10IZphrk
         1bq0iDJ8ehFVWrg9VI8ExnMTtd+g5PIeyB2b63WXc1QKhIqdTnZjqhARMNFUhuW5fp35
         5WJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163667; x=1721768467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fYlSeh/88dyiZHtXFw2OhH5nX5oaBfRET6Js1Ip/Ous=;
        b=QuwWB7OYdAGvoYdp7Ic3N63gVBdAdivG9NIpcLWS2r+tJnhLUhm7t2hOti7VARlRLh
         XbQxGbhW4kb5BtQDqEBviT5g1lhH8Lfa6S3qgFf1GdtGOcyHYK1zeiHJuDSNveqWOfIP
         HA7sntN9WoIPvNK5lxshYPOrTYO2Av74yw/j6QNlTIVZwOYVxgPsnz4ltwE5SkSSzhVF
         BzMP59952iA2K7WCsKH/QsdABmU/9mQzJtJhXL7mOEA/Dcgv0LpNjzmAdB8It4hBEfMr
         gMBMd8YF9NClj7CIhjD1E6Pj1dh8pxsn8HBOKvGgvBe1+tvUZV9eqVDyfwB0vL4OF7Rf
         8EZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt0+uG0t/B+tSmIDC2PgcIllySNS9f5WZoganbV9kckbJtBDVGavKtGQm0bg+Jbl3J/p1Fv1/zsMlwpZB6EgVQHUTb1VFp5A==
X-Gm-Message-State: AOJu0Yx7tj6pVhCkROuyrUKRc/kk2pEotR0XJstfMTxBGQvx5Gi9FlWf
	2OKk5cKU1POUyddamBvK5L1RjaKn+QN4GgU2tO9GAhVOYpejfDl8xAjKXa2k16MFzduDFxtAdQU
	r8PbOk7ZKxAw2W6s3i7q6bkL4rWwXKPEVmi+SXA==
X-Google-Smtp-Source: AGHT+IEes7lVzd1zbd+s9TAKyx+L9TnicLPt0I+L7F357KcgZRffzmyibdwIUXmFNYxp+IcOu2mtDYhIAaviAT2JQIk=
X-Received: by 2002:a17:906:231a:b0:a79:7f2e:d308 with SMTP id
 a640c23a62f3a-a79edcf457bmr328307566b.25.1721163667236; Tue, 16 Jul 2024
 14:01:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152738.161055634@linuxfoundation.org>
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 02:30:54 +0530
Message-ID: <CA+G9fYuhFAiB_bnPpAC7sW96cyPHE3wGi+Q+=bNuXcmMzGnu=w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 21:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.318-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The 390 builds failed on 6.6, 6.1, 5.15, 5.10, 5.4 and 4.19


* s390, build
  - clang-18-allnoconfig
  - clang-18-defconfig
  - clang-18-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------
arch/s390/include/asm/processor.h: In function '__load_psw_mask':
arch/s390/include/asm/processor.h:292:19: error: expected '=', ',',
';', 'asm' or '__attribute__' before '__uninitialized'
  292 |         psw_t psw __uninitialized;
      |                   ^~~~~~~~~~~~~~~
arch/s390/include/asm/processor.h:292:19: error: '__uninitialized'
undeclared (first use in this function); did you mean
'uninitialized_var'?
  292 |         psw_t psw __uninitialized;
      |                   ^~~~~~~~~~~~~~~
      |                   uninitialized_var
arch/s390/include/asm/processor.h:292:19: note: each undeclared
identifier is reported only once for each function it appears in
arch/s390/include/asm/processor.h:293:9: warning: ISO C90 forbids
mixed declarations and code [-Wdeclaration-after-statement]
  293 |         unsigned long addr;
      |         ^~~~~~~~
arch/s390/include/asm/processor.h:295:9: error: 'psw' undeclared
(first use in this function); did you mean 'psw_t'?
  295 |         psw.mask = mask;
      |         ^~~
      |         psw_t

Steps to reproduce:
----------
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
