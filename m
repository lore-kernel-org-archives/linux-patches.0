Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF87FC01
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:57:28 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-31126037f41so4216285f8f.2
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 03:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687258646; x=1689850646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=12MHpXVfV5/4NMPgWQ0+SabaxFmiyGuGrPFVvOL1TDA=;
        b=N4W7GsufFgmP6oHtlt9Q1p8seFK+wS3lXJ9dyNPgdJUGjAzzp6AaPtChargp3nIhXE
         hkSoxyLoT8DK0oUX+iwKIJNQetG8CK9gx+0WuVcEkEkLVYQlidvOP82tcSYyFRi/as/B
         HBp/pLZLysaJBJm/b3zbRgK1cFBmJ1qhqEuxmKN1a0dbwQzEt2d9SKdx8MfZSqiKcrfb
         L6RBYAiv/RI+2L1mdZJKoaEDHh8SIwTYEOvwWket7x4IfzoyjdSC6IrTCJR3VNhhZC4p
         iW2pwd6qykK+IZVmtDE04umldg+eWbkDNTdlxVgbifwQEyJHhe9INA/WwXyj6YWWfbk2
         xqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687258646; x=1689850646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12MHpXVfV5/4NMPgWQ0+SabaxFmiyGuGrPFVvOL1TDA=;
        b=SBwmr1psd8lO6A1b0kEscRW/XEqgRugpUas49IVjd3ECSPPNsLwcz9uIbLCBb7MvY9
         Xp//5CFVxl40dCjjYVghEz1I6VTTxfdGV7iI3JnGcHt8xf4ZsSjUgmKePsbCXrNr2bLw
         dVXl5yNS3sfWy6+iTZgfAufuhemu8UHigOOQzv91mYYXbs2Ab5k0Rbvkeq1NG1mfBoMW
         5vpIxETukOsHMAQwHw4ibOV5ow+BrDV1/U5kSHPwm0LrezVuRpOjHDIK+MxU0XYMh+R6
         6jUqY+F+Hx6KXQFu+S4/dPO5285e5SpstV9xzdxXfO+R0GZLJ+z4eK18jVT+jAkeTw6+
         1QZg==
X-Gm-Message-State: AC+VfDytsP/U+443nVQwwhhTwoi63DlXyvkA6vrSVE3TR5hooGX9TH3c
	AQKs9iWS5HksEG/y6dHwIio=
X-Google-Smtp-Source: ACHHUZ49J3mc1NBJrhjMDak0Nllb38q8xGqs3Yq3y4XRXRcxCJ3z7KE1nqBdaw1gUYYEI1AgxaYxAA==
X-Received: by 2002:a5d:453b:0:b0:311:1b8d:e565 with SMTP id j27-20020a5d453b000000b003111b8de565mr9229426wra.34.1687258646031;
        Tue, 20 Jun 2023 03:57:26 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id x5-20020adff645000000b0031276f8be22sm1701779wrp.97.2023.06.20.03.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:57:25 -0700 (PDT)
Date: Tue, 20 Jun 2023 11:57:24 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/64] 5.4.248-rc1 review
Message-ID: <ZJGGFPe1KWMyC891@debian>
References: <20230619102132.808972458@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>

Hi Greg,

On Mon, Jun 19, 2023 at 12:29:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.248 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 65 configs -> 3 failures
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
mips db1xxx_defconfig, gpr_defconfig and mtx1_defconfig failed to build with:

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory
   33 | #include <linux/dma-map-ops.h> /* for dma_default_coherent */
      |          ^~~~~~~~~~~~~~~~~~~~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4066


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
