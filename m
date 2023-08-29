Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777F51548D
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:26:46 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2bcfd3220d3so46831201fa.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 04:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693308404; x=1693913204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ufSg9Xoj+x6gy61mYl0sxgKzEfU/wHkCsoLIIIpLSCo=;
        b=NPDHY7/JjnhmasNoj/YgiopaMT39cypdrWk03wl4/c+WW54646al81e3krE5eaRg2m
         ZMIdtjLhgQtBoh/f+WvT/FsT3XtM85dCXqxN1L4NeZ6zw8AltYfUMQNlSny41GK9rrkU
         xVLIGiiLU21RqmqZZwGdpREEerIIEJKbf6lZ+r/lTSKiBifzgwXnWvpsPh7BP5P0Tq0S
         6qrWkluemXez4hvzPvuuN9Kkl1zLs1cwo56o5wHRxygpcj7nFboCePBKtxxrjOs7d2Qc
         KgzZnu5Ifs9hKBOaZCifP+icVgNXNXtU53/g2mOnmUagp8ui0/gcc9pgmBt7ULBoqkWP
         oIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693308404; x=1693913204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufSg9Xoj+x6gy61mYl0sxgKzEfU/wHkCsoLIIIpLSCo=;
        b=CtyOY0Zy5Gva6G122xPmS0q4juWy49wjWZ11D242FhbwpiM1EJgMElLTUo72NbfdE9
         EXN4A1BdTSZur1zZaqDasvzdXz8v0rIm65l7EPRyXjXe6FkedCipSi/Zem2OlzszNpMP
         1M9RFZpBABA+DoY7JaWMMPk7ZcWrUhiyN5UH5PwzeqR3c+KiCRQffiP+bwJAmUjIT8oy
         Pk6ZmZHO+6vkppXMsBy/IrK+IbXKNOndq0HNBv0mpkwRWwPLmK1vYh8nABRPrY0VH3Pd
         FR7vpmhbthSROAkFc6F+JJ9S7nScKpwK14XvXnz9xXp/0XffknTR+QAGWbBL8vqeGN0q
         +kxQ==
X-Gm-Message-State: AOJu0Yyf9tVMITWQjgZUTuj5mbmjyXfZdrCT4yGIWl5IQfWsgvj2mmaI
	yPGTHCQesSnEjFD4TWrzMAA=
X-Google-Smtp-Source: AGHT+IHx80hDPLDi3mPvKofK76yE9I19hj/tEJYW34QX0/Hoy6KPfeifJcRu1buiS8wq0nTq1VdzBw==
X-Received: by 2002:a2e:3607:0:b0:2b6:de52:357 with SMTP id d7-20020a2e3607000000b002b6de520357mr20322457lja.40.1693308403970;
        Tue, 29 Aug 2023 04:26:43 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id g12-20020a7bc4cc000000b003fed8e12d62sm13741408wmk.27.2023.08.29.04.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 04:26:43 -0700 (PDT)
Date: Tue, 29 Aug 2023 12:26:41 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/129] 4.19.293-rc1 review
Message-ID: <ZO3V8apl4EtNq0FX@debian>
References: <20230828101153.030066927@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>

Hi Greg,

On Mon, Aug 28, 2023 at 12:11:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.293 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230829):
mips: 63 configs -> 4  failures
arm: 115 configs -> 4 failures
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
1. mips builds are failing with the error:

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory
   33 | #include <linux/dma-map-ops.h> /* for dma_default_coherent */
      |          ^~~~~~~~~~~~~~~~~~~~~


2. arm builds are failing with the error:

arm allmodconfig, multi_v7_defconfig and omap2plus_defconfig:

drivers/bus/ti-sysc.c: In function 'sysc_reset':
drivers/bus/ti-sysc.c:982:15: error: implicit declaration of function 'sysc_read_sysconfig' [-Werror=implicit-function-declaration]
  982 |         val = sysc_read_sysconfig(ddata);
      |               ^~~~~~~~~~~~~~~~~~~


arm ep93xx_defconfig:

arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h: No such file or directory
   12 | #include "platform.h"
      |          ^~~~~~~~~~~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4857


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
