Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63715A922
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:39:08 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-401187f8071so10964995e9.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693561146; x=1694165946; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xZ9ZbaoplgcAhTiVLC1bDr8uxnmA/nekFkByFy1DR4=;
        b=dQxwo65EHrT8uXy9I9jvm+w+708zTmxewoDcKQSi6qERDNCXowf7pv0BpeuHvfo0cx
         2Xyige6FWRoNfLmSIafGJC2Cb9KjgYkvGiNpzU+TF1o99nIk5EgNkso3Eh4GXmXR/828
         L5jBa+HmZrfPHFY7H8wa98wHyYvvR2zTtOqMpm5xW+6enTEofnxYkQ2bqMu8N4nJFBNs
         KYRUcPPrPddWCPV3Rwkak/9USbiyJyx5vtzUa9qpvpwGETM30d0ZODTcRJ/qc1n+FD0v
         PDnuKJcOsjxrkfk2oKCpGl8xb70lQ4VALVCERTO6ImOu7H1MjtrpdjrThP3oldjxMfBr
         22/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693561146; x=1694165946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xZ9ZbaoplgcAhTiVLC1bDr8uxnmA/nekFkByFy1DR4=;
        b=Wm2niaYrSZCq+kcz0+5ZquKfZruaUe0RdCjKH4lvWDekNfUowyxRPyeR9V9Dw/vCiO
         SkOrOEN65yrkmHkvCVC8Udwg3CJ5kyzChxIJqrHfdNxtjYzyJ0QNLvcfc0c73iE1j3L7
         4G7W3y34k+NExRnl5SeRq2yREuBWu+od5XVLje8REAcZb0a+uxVTV63S1EdQfWZOPC8j
         cI6bExj/CYV4wLcrxgnKUP4KAIlBWvPWUxLav7W44A08qZipb6M/WSiWMOl/LLc1naLx
         OqYyp9T1Carof0sNlPz0yajy/2z+ptawE2Rcd2nPuYIXUfi6OzQ15UEpcceVtwj01pGm
         nfPw==
X-Gm-Message-State: AOJu0YzoS/xZz+wGTsPlbs6HiukEJ887CodxoTZpfODQpG3pmgygCLIs
	M5Yl9SgEJYTcQcM07xuEEA4=
X-Google-Smtp-Source: AGHT+IFXtaTUGny1kxuRDcOK1Ut+jp4CLT1eqTNyu1lF+/eLom9GoaA5NXi2WQOesh/QlqYFXHLE2A==
X-Received: by 2002:a05:600c:3591:b0:401:bc03:1aae with SMTP id p17-20020a05600c359100b00401bc031aaemr4051227wmq.12.1693561146124;
        Fri, 01 Sep 2023 02:39:06 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l7-20020a7bc447000000b003fe1fe56202sm4330877wmi.33.2023.09.01.02.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:39:05 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:39:04 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 0/9] 5.15.130-rc1 review
Message-ID: <ZPGxOEEJa0u8DgiA@debian>
References: <20230831110830.039135096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 01:10:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.130 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230829):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4885
[2]. https://openqa.qa.codethink.co.uk/tests/4887
[3]. https://openqa.qa.codethink.co.uk/tests/4886

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
