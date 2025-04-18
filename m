Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6519F40A
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 06:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744957847; cv=none; b=E9rw6WJRP2Rmd50pc4I05sTY6cQy4c/LNlnqwqERJj95GAkpMu+w2fROg3vuxkpqPDCTEUI+2K1HSH05FKal6JuiFGk6vLpNMD+R0WhLc1cLWO/DYwXHsgmFOXqRzpq3KUmOfDEZAK6hIG3kqME0u0RpZAu1bZQMpFt7qqqIKko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744957847; c=relaxed/simple;
	bh=vblSzRg0143xPuN4XeD6Vs9S/c2LX8BGW2kzWp+TWVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGVZB2p3aS5yCg9DToDn2GQRaJxb299vhpQpAp/YzSQP4L63lYIIouUwHA0FigHB8c9/4tZrFsjylp8J12kPboDsd09V0TPFekQM9pGL2AM3th35l20cjzlcABX6Mi7qnAw5twIFK2LMY/sISEhACyGDezSkQ3ICcYyJPXco0Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BJhjpXMs; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BJhjpXMs"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-86d5e3ddb66so582818241.2
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 23:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744957845; x=1745562645; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cO+LZPGdKwCP9kW9Fu9VT4HesIxpNlVbvo5GVB8YGbA=;
        b=BJhjpXMsIokALDAR1hLffO+IuSVjD6UV1WvXVSAqKc93fDOVgkHWFjMm59lRplQZnD
         eyhHG/B29g+KTSKOi9lKnB2UOC5CwHhBp2rvmIgRXrrBhJsnxAyetmK3pEtAubWqtdLl
         EenpOUwGebvANPZj5oyaA++PMYiw97sPV69E4YORajTAPL2ri9v7g5pulZv1TZsw2LVs
         MalwNhsh7vTmb2TeWvFWcqFY5WNAVEQZdWJDn7gO23bZskJjPkV0tewWXLfYE7OPzFmO
         IkuA0au8A9mr8EN842SzmKva3YWsPXB1kvMPFg3Av/MtL9BJeiekLuO77As+4tvamp21
         /4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744957845; x=1745562645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cO+LZPGdKwCP9kW9Fu9VT4HesIxpNlVbvo5GVB8YGbA=;
        b=SFNucuIaU6/H9Kdqwt0NGCBR4pFwL5Zcn1SCX1u3He0XMCVI6WH/QOi49z1lfsfUrk
         b5eI9UP/OnE2Zii0sizp5I5z1hq8CnVuNAH9sENsm7kCwgpkV0bteifkNQJkdPEtkg+L
         gO7PrB5w/f1/Lx17NwohMgpeOs65N4CqJXdhaA8fcU3VfjdGpTYvZ+T/XI+oSPJUFRv6
         X7JOwrHMIBI2z28weHFsdceMtZbXbDKvyPOsq1WWDjgPKbtbRIYZZaooKgMH7OADQmi+
         ulgk2GrKiOK9usb4ko+oSv6fLZCzO22OSOLHiozH4WErNYz2Y7neCdFpAKrWfWTIlI4F
         zFCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSS/ynrp4iGMu+3KXHCGH0UKYKnj+qnW1E6jAJk8akaP2ZT4sG/pLVl8VHxU/GeoMamnIACAt7@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3xun/EtggCNy/b+6/3JrV5MuEepukwVpdCZnan89RD0/qtNDI
	vE9gF0BtMl7MrAtVFEtmpEpbTe8IZkg9SdLIFhQ+U3YqaBXdxrL3ktkpDWzXVprRLYQ9CoK6CIH
	JI9Q7bhwqt4636LGnvCbBa/45Z2NTY1luBNqhww==
X-Gm-Gg: ASbGncsdgBkCDz1hSN+eSBMvnZ2eejbvgm3G7bw3Uhs6Y46lwbCPSAVEY6x+tIjg9c9
	5CMHlnRcpCq6TmQu9zaAwhUy/Vg5o9Lfdnp/eKha/65693NX9BzQlN61Bjx5SfCZSOzvMR/qejl
	8/mcnMh/M+9HRqn8yX29xaIqMb7uDs1AmBWuvBuZjaqFc7Vl2ic2Dn2TkqzjVtde6A
X-Google-Smtp-Source: AGHT+IH6BG918r8UUA79PN7vIXS5dYZcYnUeACLfVZYjN9RIV6I6z90wfnR5o7Bxh+UkT+2opBqk+p0fP04vNBwseo8=
X-Received: by 2002:a67:f085:0:b0:4cb:5d6e:e6c8 with SMTP id
 ada2fe7eead31-4cb80128dcamr1118528137.9.1744957844659; Thu, 17 Apr 2025
 23:30:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417175117.964400335@linuxfoundation.org>
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 18 Apr 2025 12:00:33 +0530
X-Gm-Features: ATxdqUEWtM1oKR-sQYc2k2BCDKdcFTg3l0NQ9YagooLEJvlaaYx37l9I6E6Bh2M
Message-ID: <CA+G9fYvz0kujF4NjLwwTMcejDF-7k7_nhmroZNUJTBg4H4Kz8Q@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, PCI <linux-pci@vger.kernel.org>, linux-s390@vger.kernel.org, 
	Tudor Ambarus <tudor.ambarus@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Niklas Schnelle <schnelle@linux.ibm.com>, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 17 Apr 2025 at 23:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 and s390 allmodconfig and allyesconfig builds failed
on the stable rc 6.14.3-rc1 with gcc-13 and clang-20.

There are two different types of build errors on arm64 and s390.
These regressions on arm64 are also found on stable-rc 6.13 and 6.12.

First seen on the 6.14.3-rc1
 Good: v6.14.2
 Bad:  v6.14.2-450-g0e7f2bba84c1

Regressions found on arm64 s390:
  - build/gcc-13-allmodconfig
  - build/gcc-13-allyesconfig
  - build/clang-20-allmodconfig
  - build/clang-20-allyesconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: arm64 s390 ufs-qcom.c implicit declaration
'devm_of_qcom_ice_get'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log arm64
drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_ice_init':
drivers/ufs/host/ufs-qcom.c:128:15: error: implicit declaration of
function 'devm_of_qcom_ice_get'; did you mean 'of_qcom_ice_get'?
[-Werror=implicit-function-declaration]
  128 |         ice = devm_of_qcom_ice_get(dev);
      |               ^~~~~~~~~~~~~~~~~~~~
      |               of_qcom_ice_get
drivers/ufs/host/ufs-qcom.c:128:13: error: assignment to 'struct
qcom_ice *' from 'int' makes pointer from integer without a cast
[-Werror=int-conversion]
  128 |         ice = devm_of_qcom_ice_get(dev);
      |             ^
cc1: all warnings being treated as errors

## Build log s390
arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member
named 'non_mappable_bars'
   19 |         pdev->non_mappable_bars = 1;
      |             ^~

## Source
* Kernel version: 6.14.3-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 0e7f2bba84c1f492e15812fade27cc0a697f3cb6
* Git describe: v6.14.2-450-g0e7f2bba84c1
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/
* Architectures: arm64, s390
* Toolchains: clang-20, gcc-13
* Kconfigs: allmodconfig, allyesconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28150920/suite/build/test/gcc-13-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28150920/suite/build/test/gcc-13-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28150920/suite/build/test/gcc-13-allmodconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqIAiN9QWCPEV6FWrOWIRos2j/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqIAiN9QWCPEV6FWrOWIRos2j/config

## Build s390
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28148516/suite/build/test/gcc-13-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28148516/suite/build/test/gcc-13-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.2-450-g0e7f2bba84c1/testrun/28148516/suite/build/test/gcc-13-allmodconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqI5I7Rtlnhj4xhKXAwkGJ27o/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqI5I7Rtlnhj4xhKXAwkGJ27o/config

## Steps to reproduce on arm64
 - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig allmodconfig

## Steps to reproduce on s390
 - tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
