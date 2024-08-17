Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA62B66E
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 15:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723909203; cv=none; b=OCmPPBiiMkbFro1lyBmomtK5aMnL6iEv37UvHtmOWtWzXAc4VNjsYboQKmO/ZL2h+kJH1l2Pv+68vMPoJPIbCWy4uXUUKXFW9i89XlKi3E5SfdFoBvCAOS0HtCqlYVCWvgwc9rzyrlZuWUPW3U0OqIe+wF5jk/10Yk8yjZkPFBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723909203; c=relaxed/simple;
	bh=+tzeaKbZ3wXqBh2YX5z2yPeSMdZb1tAgkHcCAOIOSOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O69raeyfkaYPSoTzTknlszgQK6heD5OW2EdfaoaXOSBODq8jSPrH4TBhlhV43Lav7R+vw7wip2yGiyCU7niwlMGlej49H/u7di+PE4/pkYrs43yLqgFzF+zBKyt2YzvUUgjiHwlL66SnOCqJ6aW5LXOQhEt3c2JJsNdynyGJDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=syS2v/UN; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="syS2v/UN"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6bf6e17cc2bso15717686d6.1
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 08:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723909200; x=1724514000; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CNBm3qjSy5qMMK53bE87AwOPaQn+kCh2D9IAJ17szRY=;
        b=syS2v/UN+GRbFqbv2OslaZn8zk1em0SGcdwEFfSIFzgCEjjZIDHaNj5sbx/vrQL6Sk
         GfsbxuCbt/QLY+HMZJ4a6MH0+RGIP/eNWh5E+aHFicXy8rrRMZTJYR47nTxTtC11uW6Y
         S72AkoewcbM9IuyFwPPiUG12u9Z743cRJM4LJo+oMLpU6B3ArXChHwRDVo1PRJd6y2qT
         t/gwt2roa8jUh/7HwqS86L1KbbwS2UgZC85wcZp1Ys84/tYvJFKpvcKsoX2nifT89rnS
         6P4ocquuvBZmtkN/qZuv/x6Jk37DmZpQZLUs8OVVWwpEE3MaSH9Kilea7ySUuR/nv/bB
         NBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723909200; x=1724514000;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNBm3qjSy5qMMK53bE87AwOPaQn+kCh2D9IAJ17szRY=;
        b=PcsM0GfzsPMuB9hgIkVNI28vAw7gX7xBtci4V4U7OkZ6M5wobDUpdK8ERf6vW+xijz
         DFSyL0d5lbRLzBW2o4JKTGD2HpaDOBmT7pY2YQ32Y0fCq1JTAPK7JbkHQelBF3hYjJOH
         8sn6f3hyqXrEBqRS+TX4I7XKnl34a2cs8toRzQLNpOT9WiHRmA2sou+ULoDHZkHwttz3
         prH8onCdQICnlKzymjAv8IeFQX3ciJGzbtLF7VmY9PA5DttHsz3bvSYcc7RWfAEzqPia
         1oxCiQEBY4Spup8SA0esjhiQB7UwUrQb7gZPs9jOpu0DqQlglHoUlEPsgrJbbZmIcG7N
         0IWg==
X-Forwarded-Encrypted: i=1; AJvYcCUMmmPbUEUv0PPXxBD2vhZeQs0iY3AAJ+BnMUSK+MLKDRbKq1EhO4om0f7MSK6r8NTRM9dcZkZwlRqzzLvaWahSionXqvtJig==
X-Gm-Message-State: AOJu0YyhFGkcE7ognPSt9CdDc0kFyicUzXZFXu4u6fZVejItPX8Nfndp
	GaRrao/YG37DiE0qQn489FXZXddGsACaW4hTrI33aG30sORl5I8BUDAJNY7qMvo+KQmWLKq5Pho
	zc8FIvNnoooXIaD2JbeOMXILdvWpwpE9XEcjb7w==
X-Google-Smtp-Source: AGHT+IEadpRL8Jv6RZt+8WVKsffMlrSHeIJHNVZpBdeFc3pSSRb+C20YqvoECyKpXKPIZnw7z37bSTAoeYIB6ZLpoTA=
X-Received: by 2002:a05:6214:498d:b0:6b5:4aa9:9686 with SMTP id
 6a1803df08f44-6bf7ced6631mr86203366d6.42.1723909199600; Sat, 17 Aug 2024
 08:39:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240817074737.217182940@linuxfoundation.org>
In-Reply-To: <20240817074737.217182940@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Sat, 17 Aug 2024 17:39:48 +0200
Message-ID: <CADYN=9++QDcougZ_xJOLf8otPOrrFcwaJe_gL7ZYmmw6gDXWmg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/345] 5.10.224-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 17 Aug 2024 at 09:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 345 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Aug 2024 07:46:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.10.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisect points to 34a325f5a22f ("s390/pci: Do not mask MSI[-X]
entries on teardown")
as the problematic commit [ Upstream commit
2ca5e908d0f4cde61d9d3595e8314adca5d914a1 ].

Build log:
--------
/builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_setup_msi_irqs':
/builds/linux/arch/s390/pci/pci_irq.c:298:9: error: implicit
declaration of function 'msi_for_each_desc'; did you mean
'bus_for_each_dev'? [-Werror=implicit-function-declaration]
  298 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |         ^~~~~~~~~~~~~~~~~
      |         bus_for_each_dev
/builds/linux/arch/s390/pci/pci_irq.c:298:44: error:
'MSI_DESC_NOTASSOCIATED' undeclared (first use in this function)
  298 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |                                            ^~~~~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:298:44: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/s390/pci/pci_irq.c:298:67: error: expected ';'
before '{' token
  298 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
      |                                                                   ^~
      |                                                                   ;
/builds/linux/arch/s390/pci/pci_irq.c:271:17: warning: unused variable
'irq' [-Wunused-variable]
  271 |         int rc, irq;
      |                 ^~~
/builds/linux/arch/s390/pci/pci_irq.c:270:13: warning: unused variable
'cpu_addr' [-Wunused-variable]
  270 |         int cpu_addr;
      |             ^~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:268:24: warning: unused variable
'msg' [-Wunused-variable]
  268 |         struct msi_msg msg;
      |                        ^~~
/builds/linux/arch/s390/pci/pci_irq.c:265:56: warning: unused variable
'cpu' [-Wunused-variable]
  265 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                                        ^~~
/builds/linux/arch/s390/pci/pci_irq.c:265:53: warning: unused variable
'i' [-Wunused-variable]
  265 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                                     ^
/builds/linux/arch/s390/pci/pci_irq.c:265:39: warning: unused variable
'irqs_per_msi' [-Wunused-variable]
  265 |         unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
      |                                       ^~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_teardown_msi_irqs':
/builds/linux/arch/s390/pci/pci_irq.c:371:44: error:
'MSI_DESC_ASSOCIATED' undeclared (first use in this function)
  371 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
      |                                            ^~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:371:64: error: expected ';'
before '{' token
  371 |         msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
      |                                                                ^~
      |                                                                ;
/builds/linux/arch/s390/pci/pci_irq.c:359:22: warning: unused variable
'i' [-Wunused-variable]
  359 |         unsigned int i;
      |                      ^
cc1: some warnings being treated as errors


Build log link:
--------
[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-346-g2810e3a9f5d6/testrun/24902188/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.10.224-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 2810e3a9f5d69d54c8932173cfbd380f16d36b5a
* git describe: v5.10.223-346-g2810e3a9f5d6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-346-g2810e3a9f5d6
* arch: s390
* toolchain: gcc-12, clang
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2kmIhNosE42gaZLyeRO6utnwevO/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2kmIhNosE42gaZLyeRO6utnwevO/

--
Linaro LKFT
https://lkft.linaro.org
