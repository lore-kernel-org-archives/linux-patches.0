Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97162C2C0
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 09:06:30 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-400e8ca7e38so5660555e9.3
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 02:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692954388; x=1693559188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i2nKk0BPW5aUoC/i6MdosDErp4K/kH35/8TD8Z/46T0=;
        b=Mo8NvNjeDv9g2VTAEOh4XIAzg2uJ1V203fkY6ENjtVIxmU5nGuSgy3ZwVrcyb6gPGt
         LBBjsiJxkeDECuqgMwMFkqBleQhit2sWEN8Q/XSBs99SM9I3fZrV5OEwLO+Z8GOnTa4w
         wvb4f0qw58DgYTYS8PS7kWtKG9W5Kf9yzMu5hH20N3hWqFl58hV/Mk7nDKtlt07Wli4j
         /J/2767vnf5Fd2HXPfhfNV3q99u2yCUvKBnGS1IY5xrOPe/8TcDpF3sj6dNW0XPQVdeE
         5qPMsAdQK5cSb6FpO/KKt3Rvq8DJ9DPAzKfhfeoiu9NfG1iAAMcJ7Qco02CN0mv9GXKB
         Db6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692954388; x=1693559188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2nKk0BPW5aUoC/i6MdosDErp4K/kH35/8TD8Z/46T0=;
        b=h9IMrcVIV8m8HZ3VO6U/6Gj69ZLUaec9NcJIVygTTf9BgEgqU47wKL7ohedi8zju06
         HDO8DMB8+v7gvET1N4ROtPlIDbC8m8235AIt+FkJ1qSDlOEXyVd48Gf1BrbSUPOdnn51
         5huzaoM5pV+35RKDFHFr3hmiuyXEK6hc1/P1UxQIY03SbmToiFRTGDIocKl3hM03bwyI
         ZuZvu5BAjUALS9rHXwiZQu5U0pPMK92WMVvAq95XOTzglyiJ0/5BxZfjf2WPD9w/FK8v
         CcsIy+F9eGnOF92wf9hdjIoecaDW37OqS81Oz4ZI9gHfnAfNVj3ZH15SoSbAzc1HgBxy
         zKFg==
X-Gm-Message-State: AOJu0YwHZzPArVsW/SBDPhn64xZNpopP1cN1iNRUYk7Mz4PdAKfR23/Y
	fef90wsWQH208ZEwQW9cQtw=
X-Google-Smtp-Source: AGHT+IFTRtpEgC1Fn8L6CBbV15hUqmulfli94PdQ6IwRK9ygLGLRHNz2ursxx5+h4i8bd/yOWGiN9g==
X-Received: by 2002:adf:fc09:0:b0:31c:6476:b730 with SMTP id i9-20020adffc09000000b0031c6476b730mr7191600wrr.68.1692954388265;
        Fri, 25 Aug 2023 02:06:28 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id a16-20020a5d5090000000b0031432f1528csm1623492wrt.45.2023.08.25.02.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 02:06:27 -0700 (PDT)
Date: Fri, 25 Aug 2023 10:06:26 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <ZOhvEoeysXR+4tGj@debian>
References: <20230824170617.074557800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>

Hi Greg,

On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230625):
mips: 63 configs -> 3 failures
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:

mips db1xxx_defconfig, gpr_defconfig and mtx1_defconfig failed to build:

rch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
arch/mips/alchemy/common/dbdma.c:632:14: error: 'dma_default_coherent' undeclared (first use in this function); did you mean 'dma_free_coherent'?
  632 |         if (!dma_default_coherent)
      |              ^~~~~~~~~~~~~~~~~~~~
      |              dma_free_coherent
arch/mips/alchemy/common/dbdma.c:632:14: note: each undeclared identifier is reported only once for each function it appears in
arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_dest':
arch/mips/alchemy/common/dbdma.c:695:14: error: 'dma_default_coherent' undeclared (first use in this function); did you mean 'dma_free_coherent'?
  695 |         if (!dma_default_coherent)
      |              ^~~~~~~~~~~~~~~~~~~~
      |              dma_free_coherent


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/4779
[2]. https://openqa.qa.codethink.co.uk/tests/4780


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--  
Regards
Sudip
