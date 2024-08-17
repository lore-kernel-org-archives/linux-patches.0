Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411498F40
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723909139; cv=none; b=EQtHDX0AY2eijhaIZ7R4aVycbGwtWMVNSux43FvnPakermNlpYo6oVQNEB5JPxmkEPDmitUojxluJDIbYEmKesQtb/GsSXznTNZkGXMRFMDNLRyEk0mnTZpPMl+XdxtcHgkkLzLMZ+QVNsv5MlsCWSWiGI6NbJ5NxH7V3H6WWhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723909139; c=relaxed/simple;
	bh=wfAAaM0jmClhgcfNpIqUuc7ylHCMJJf9rVgMANon+bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cr99m+f0IUq1tKtb3IHNGnGl+jMDqpRxajXMNXXN5+ADmne/wAFRWEEIVUtOBTqDjbf5sF2QSTMCJIHpeD6/3HyGGpjDcSRExRVTz/A7i/fAx54DaV/jekqk9obz+pGYin+F9YaCOqdkvyiE2KvF0db50/pPIPuV53tCMaPH4Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FjkhuFco; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FjkhuFco"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6bf7b48d2feso11947446d6.0
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 08:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723909136; x=1724513936; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoUZ7+obYFa+U1vF9E6Yb2bjaEAB/EzTa0GZe5T7Ig8=;
        b=FjkhuFco1fkTf8jaBk1Pe2MdxiFWMJyIY5aEtt/Uneb5uSs4Dzhr+Ui6Sd4adaI5RM
         /hzW6olE5IyVvtZm/UDtRApc/peLqYXYJwgihfi+nXKwjFYMkaZhdug63p28KIuyhKer
         rkluIiry+RkBkNP6evkkGDzhFmR7MB7HtsB/voyejJT0d/zBtByyTPGZW9q7j2aKEjfC
         dnjEKAvONyJk9qBGLda+Q1tUq9TYxY4FkEwbFBXiYuI31a+sUMJpk9moR2pxLt7FXfxW
         I8jTYvlTylQ1FbEusRcTX5Wn4gRYTabqRwHKPSpYTMQp4aIzKsdwGYPUW0/0di93pMBl
         3YGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723909136; x=1724513936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZoUZ7+obYFa+U1vF9E6Yb2bjaEAB/EzTa0GZe5T7Ig8=;
        b=wFiCgOAGPAew1TlK2XsGmwqyLSISYKUdKduhxq4CsI+7xfgXgoPabQZirRoCOFmdeG
         pHInmKKD2w+Yk5tGaQVzgpJLjxxhWRUgV+RfrR3JftMw3KJEXw6IXKi9TFEL+yRUVwlq
         AORQap79weOPRNd1bjxlSPy/KF7t1OS+mIEERFY0PStwPhIbkMfwlfCtytViKMUBoPIY
         8ErCruYtYNdQgivC1wT+zL/kLmQ44qtCZoVrmRBXqBQLHdwGh/I2B8pTBhSaJviOJY5G
         HU/Mv9d4qJYMRWzBvpuEOheRfCxSA31MoUVpZI611Y3U8H/yj/qut3kWI7uKWSzyZWim
         EMag==
X-Forwarded-Encrypted: i=1; AJvYcCVYQaJ1qVg7FtFmUvBKahVgBV/3Z9GPGUzgHxGEWqxmmKwjDTEoH9k1CD+zp86tmohbLR19WxmMBYQqg1iXlycmtwqU49Rn2Q==
X-Gm-Message-State: AOJu0YyiUPxoMFB5p8Lg6WpKcZe2IFv451Zm7nyCmDBHkQpcIF+pW8N3
	lHKeqE1m8B6xCzEDJM9vz4H+SVZ7qw+9tTOJaSDMTfY8mMSpC3/RloTCi7ipSOZR0Sa0/Lgh7kO
	buhcRs3He7uVwCteQaU8ZDfel3BGxdukSFiWh7g==
X-Google-Smtp-Source: AGHT+IGWz/aKYGezzhbX6UXoOIF2JUqK+K21v1uQbtz1JesDM2Ox49UG4VMgItHLMr5GzA1WLluSrMoJtabTMk3wpwI=
X-Received: by 2002:a05:6214:469f:b0:6bf:7aa3:84ac with SMTP id
 6a1803df08f44-6bf7cd86401mr77277006d6.9.1723909136016; Sat, 17 Aug 2024
 08:38:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240817075228.220424500@linuxfoundation.org>
In-Reply-To: <20240817075228.220424500@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Sat, 17 Aug 2024 17:38:44 +0200
Message-ID: <CADYN=9J-7HS62eKTgda-kU=JCz3ck=UXfaYk1XTK5jXuybpo7A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 17 Aug 2024 at 10:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 479 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.15.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisect points to 5af75585e330 ("s390/pci: Rework MSI descriptor walk")
as the problematic commit [ Upstream commit
2ca5e908d0f4cde61d9d3595e8314adca5d914a1 ].

Build log:
--------
/builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_setup_msi_irqs':
/builds/linux/arch/s390/pci/pci_irq.c:328:9: error: implicit
declaration of function 'msi_for_each_desc'; did you mean
'bus_for_each_dev'? [-Werror=implicit-function-declaration]
  328 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |         ^~~~~~~~~~~~~~~~~
      |         bus_for_each_dev
/builds/linux/arch/s390/pci/pci_irq.c:328:44: error:
'MSI_DESC_NOTASSOCIATED' undeclared (first use in this function)
  328 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |                                            ^~~~~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:328:44: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/s390/pci/pci_irq.c:328:67: error: expected ';'
before '{' token
  328 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |                                                                   ^~
      |                                                                   ;
/builds/linux/arch/s390/pci/pci_irq.c:301:17: warning: unused variable
'irq' [-Wunused-variable]
  301 |         int rc, irq;
      |                 ^~~
/builds/linux/arch/s390/pci/pci_irq.c:300:13: warning: unused variable
'cpu_addr' [-Wunused-variable]
  300 |         int cpu_addr;
      |             ^~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:298:24: warning: unused variable
'msg' [-Wunused-variable]
  298 |         struct msi_msg msg;
      |                        ^~~
/builds/linux/arch/s390/pci/pci_irq.c:295:56: warning: unused variable
'cpu' [-Wunused-variable]
  295 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                                        ^~~
/builds/linux/arch/s390/pci/pci_irq.c:295:53: warning: unused variable
'i' [-Wunused-variable]
  295 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                                     ^
/builds/linux/arch/s390/pci/pci_irq.c:295:39: warning: unused variable
'irqs_per_msi' [-Wunused-variable]
  295 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                       ^~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_teardown_msi_irqs':
/builds/linux/arch/s390/pci/pci_irq.c:395:44: error:
'MSI_DESC_ASSOCIATED' undeclared (first use in this function)
  395 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
      |                                            ^~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:395:64: error: expected ';'
before '{' token
  395 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
      |                                                                ^~
      |                                                                ;
/builds/linux/arch/s390/pci/pci_irq.c:386:22: warning: unused variable
'i' [-Wunused-variable]
  386 |         unsigned int i;
      |                      ^
cc1: some warnings being treated as errors


Build log link:
--------
[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-480-g2a66d0cb3772/testrun/24903946/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.15.165-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 2a66d0cb377282f04abd41b09fbbbdebdf39e5ea
* git describe: v5.15.164-480-g2a66d0cb3772
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-480-g2a66d0cb3772
* arch: s390
* toolchain: gcc-12, clang
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2kmLyVVnghC9nRUIBEQn4Vg2fzy/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2kmLyVVnghC9nRUIBEQn4Vg2fzy/

--
Linaro LKFT
https://lkft.linaro.org
