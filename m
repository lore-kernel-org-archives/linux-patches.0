Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44677F10
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798929; cv=none; b=NxEh4NaGYocL55s3BlH14et7YiTjtgrorHyau9zqeNxNRxWDWVci2g13QIYJbMx9+VyJd91bk3akNCvO/m8MY8BQnE9aUmPeWIez1bit1vDnMgFxfjYx6yd3+dWPNH7MQ6IfKwAtU6buH7DT2yRDn8Cnbc2Z5S3uQEEzJUt7PbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798929; c=relaxed/simple;
	bh=3LtfzWnjqE34FcAojC1Q2ohWMYNdJZLQOkB/Q2NvThY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFnlvWU5JrMm9y8YXWfXp9ooHJOdOn0utxK5HKqHyLzF0Mrew2Tls9JAq1shoYYilBB636SdcRTe3xJjxUiqkJWJyhZZ+EmA0QPr0OzwbschsAQpWv2MznZYCeV3qug9p7hmZS01OSRJHph9MTgLn4PdBCciyFBPou8lkALW9qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DdB6zHJJ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DdB6zHJJ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a83869373b6so145115666b.2
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 02:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723798925; x=1724403725; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NINSdRBEfEpSn8l43T3fPW1cepVfujVcuIvvr607qdk=;
        b=DdB6zHJJCTzQVW6jgzASU889dews5n6p0vY6qCpEekDX/PMXDEOzwsuyHgPORJWLIz
         0G0c6PpNSnxbdq/MEAnQhIGR4Pf+O4uQvx7rmLnX4lbIMOS63ZRRsoMKSN8TlhJxokbo
         +aJUaQ0gV4OrMn5qqFV8RWM5NjW7BHVDvc+mUchtgvidwnZ213JFoiiIAhMz0qdtpESn
         EGt02JclQJy/YhlXxPSnFMMYBn8bcmDDXxT0lK+QbN8dxG0mCZ5ZZXdlcIw2IlVh0OZq
         DRJHPStsFN/aPCN76dpGpp/aEZPYEnFYXB31gYRBEJjsImBj2rR5aah3jN6w04/T6WFn
         H0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798925; x=1724403725;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NINSdRBEfEpSn8l43T3fPW1cepVfujVcuIvvr607qdk=;
        b=R1RrqIpYoWh9B0ot46J5Uu20nDlmT3eHY9q6AHc668H7qM5fEtbqCusC+TKy1kWZSb
         6MA8aVtCRRgpP7qnWFQ8aWV1GFtA/BDY2aiJoFMAWAM0dUgPTX+/zYQah/gev9XJAMQb
         2J764r07qG9l2zrwJaC+qwhAEHlDUdLZua6qtnQ7hyHfYpo6c+hxtVj9iuRU2AL29QcK
         XWjUNNDzSS5ShKuzuJY/DWkZ2dGGtakLd+D+j8ODxyYmVWc7uwYkTxwiZyqRajvvXbzt
         ucJ9DUtqoPvat3bdFBYI3GMkKoEAX0SQqbHw10Ms2Jk7K+R5n8wuunHdaybBQWOzIs1K
         BHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9rLUqAX21vjhkp8GVRKGcb5a/jJkCg6YN2E4ZV0Y2KNB5ZhrP4RHxasdScMSW9y1g5qcthYizEdVwFq/cvdPul9+D85eK7A==
X-Gm-Message-State: AOJu0YxWGE7Mga5dTYk11z3V/Q2WrobhxH61RTlxXXBf/CGbo21G0rpG
	00VC1eKWq7SZU0Usch1YLmduV72SyrudJaHPEL6Yieaiw2HAcAqIc8tbP9Ytvz5LBBsYsrgezd2
	iYMqXcDKkoi6rRhwYIliSnsgvyKPJoSS/CQV1ow==
X-Google-Smtp-Source: AGHT+IFYkVm58QtdBkqONHO8uNxRKVcpOAMTPyGL/U9cyg/WodG+YdFS9p37rlkb4Y+aVtiHQPGiZIw3wBKNOsSZx6U=
X-Received: by 2002:a17:907:e2a3:b0:a7a:b977:4c9e with SMTP id
 a640c23a62f3a-a839292f21bmr182899166b.21.1723798924923; Fri, 16 Aug 2024
 02:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131902.779125794@linuxfoundation.org>
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 11:01:53 +0200
Message-ID: <CADYN=9+zo=R7jFdHGps0YedBqGzhjm7xeOZLsaR_E7-b0Y_CMQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/259] 5.4.282-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 16:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.4.y with gcc-12 due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig

Bisect point to deb23146ba03 ("s390/pci: fix CPU address in MSI for
directed IRQ")
as the problematic commit [ Upstream commit
a2bd4097b3ec242f4de4924db463a9c94530e03a ].

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
------
/builds/linux/arch/s390/pci/pci_irq.c: In function 'zpci_set_irq_affinity':
/builds/linux/arch/s390/pci/pci_irq.c:106:17: error: implicit
declaration of function 'smp_cpu_get_cpu_address'; did you mean
'device_get_mac_address'? [-Werror=implicit-function-declaration]
  int cpu_addr = smp_cpu_get_cpu_address(cpumask_first(dest));
                 ^~~~~~~~~~~~~~~~~~~~~~~
                 device_get_mac_address
/builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_setup_msi_irqs':
/builds/linux/arch/s390/pci/pci_irq.c:298:2: error: implicit
declaration of function 'msi_for_each_desc'; did you mean
'bus_for_each_dev'? [-Werror=implicit-function-declaration]
  msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
  ^~~~~~~~~~~~~~~~~
  bus_for_each_dev
/builds/linux/arch/s390/pci/pci_irq.c:298:37: error:
'MSI_DESC_NOTASSOCIATED' undeclared (first use in this function)
  msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
                                     ^~~~~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/pci/pci_irq.c:298:37: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/s390/pci/pci_irq.c:298:60: error: expected ';'
before '{' token
  msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
                                                            ^~
                                                            ;


Build log link:
-------
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.281-260-g95ce4659a81b/testrun/24873581/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.4.282-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 95ce4659a81b365646fc35fdd6678a62f8c02256
* git describe: v5.4.281-260-g95ce4659a81b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.281-260-g95ce4659a81b
* arch: s390
* toolchain: gcc-12
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2khPUOCfrk64PMmp7nyDUvvt9j6/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2khPUOCfrk64PMmp7nyDUvvt9j6/


--
Linaro LKFT
https://lkft.linaro.org
