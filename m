Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CC51474C5
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 11:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313792; cv=none; b=ZIEoIxzXw+ywJBn50hbLPjt+m6MxEobu+IhaW7Uvb1dB2JVNfVYMIBh8vI0y2FTWlhgNdTQ+SWb39v5Xo8aCrZQGaLOvwvhUFIgn6RNYHbdLOGbp+0f7c3Y/e3tsMJYXJPkky/qB6JXw6wRsx8x2eR73w1pYpj3PIv946b5Gs7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313792; c=relaxed/simple;
	bh=Jqx5709BtugoJVZY8NxxbQN9lreP98TY5Wx/Ks/oQYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ut+bZooiz0/OD4F+vyQ3R7+PFKa1Cpe4WQfHylofOj/RFK4OuIQlcrU4MsRFGUdRCDT+BSVk0dSI7rvN2mWFKmuE2zHX2VAn07QtqAslJP7i2c7b/tA3m6TbOssv1Rn027+hZ2/hr0DV7H+B2dLQQk8F2nr6B27x7WbN5rnGvMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bhJbYtr7; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bhJbYtr7"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4ef52e9038bso1303537e0c.1
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 04:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719313789; x=1719918589; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7R5wxQYwGfaVqYk9QukhujZ0AZZW5oBR/ydEPdcFLQY=;
        b=bhJbYtr7ePzH5kbyQ8muI1g8ohZnjf1CudQPA/xbe7tox0aeD5vW9dTIHGd38JZSbi
         Aw0HpDdwuKpmMLdH0qlM1IJDCr88IdkNIIwFRIJhvcfzGRAAJwyyFrEX4OvO00MphXBy
         gekOc7PVHZbtkKQFNpgbYOkf775/xs9wzewDxgbtchTSXK13bnrwQcieQ8AWnnFSKhYW
         i7vtj0HbFALQyr+7ynRIlnW9G58YykgbI/pWYvIImyaOEn+mHvl046cINRPH5Bd4GAUv
         wbErfSYUmjPCVwSYEJlHE/rhGoL6e4r1UPaRs/Z6xTk8dbypo+JK2sG95FEoW1Q3qxH/
         u2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719313789; x=1719918589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7R5wxQYwGfaVqYk9QukhujZ0AZZW5oBR/ydEPdcFLQY=;
        b=UGkzDPa7GTCaJTluJh9YRfOf/0Y42P2FX+38JfsN1/Zs/7d7vNt8Sc4q9XqAVmj1g1
         QIPrjrQfo+TXiShz+GiVlyAbhnIetJZMGG/HWpgPlU9kAZpYKP5+vuuyQiKDCIko79vA
         bBcdJ04KdLC4Lz4dtcKpCcaHEJTu8mOBG03iILelaR8D64EzLgCSvHR2l8FpzCPWk/q5
         i2WGoJeN+odnD5nrvZrhiwKXkn0seBd9py0Bhok20CkKu7oBlHiLoCM6Mxz39xCtVY4o
         5J1396EcicHd8jeUdyie7ATKi4L7WPFw9Zui9F7SwYOGM0xecs/rizpkcKixVd2ZBXND
         Dngg==
X-Forwarded-Encrypted: i=1; AJvYcCXgaOD+EolpL/FL64urJ4ZjGKui5tE8g3/hIZi5JrlrZVfs4tMhlYsyBhRxjaeCDaFEFfE6oY0aVQPiz0IKPp5jCu/LEJcUrw==
X-Gm-Message-State: AOJu0Yxvuj60apsgtKfSeNpeSLNsHiLK5ZZISMpCDLBRSRGk5iTu/awl
	6/2rMzXNwXlaCfDx3H861oSX0Gn8Y4hI6aucn2tuSurvzXxeH6NGHczuOeyv0tq8Ea7gbFigExw
	AExy8u1i+VveU1LKoc7fF+O6ywHD8P3vegGFBTg==
X-Google-Smtp-Source: AGHT+IGFPvgQg1o9LeRDhdQ+qJIJ+JQi9wNh81iGlEdpy/Tfa/2hvfiRTSb4TnSM/hw5l+hirYUDOyyZZbUacxz0ZYk=
X-Received: by 2002:a05:6122:411d:b0:4ec:fc23:7928 with SMTP id
 71dfb90a1353d-4ef6d892a1dmr5555079e0c.12.1719313789305; Tue, 25 Jun 2024
 04:09:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240625085537.150087723@linuxfoundation.org>
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Jun 2024 16:39:37 +0530
Message-ID: <CA+G9fYuWjzLJmBy+ty8uOCkJSdGEziXs-UYuEQSC-XFb5n938g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Jun 2024 at 15:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm builds are failing on stable-rc 6.6 branch due to following errors.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
--------
arm-linux-gnueabihf-ld: drivers/firmware/efi/efi-init.o: in function
`.LANCHOR1':
efi-init.c:(.data+0x0): multiple definition of `screen_info';
arch/arm/kernel/setup.o:setup.c:(.data+0x12c): first defined here
make[3]: *** [scripts/Makefile.vmlinux_o:62: vmlinux.o] Error 1

metadata:
git_repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git_sha:
580e509ea1348fc97897cf4052be03c248be6ab6
git_short_log:
580e509ea134 ("Linux 6.6.36-rc1")

Links:
  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2iMq0CHppQGxkVSsEPFtnw08bc6/
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.35-193-g580e509ea134/testrun/24441308/suite/build/test/gcc-13-lkftconfig-debug/log
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.35-193-g580e509ea134/testrun/24441308/suite/build/test/gcc-13-lkftconfig-debug/details/

--
Linaro LKFT
https://lkft.linaro.org
