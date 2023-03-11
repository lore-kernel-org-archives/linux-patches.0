Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BD77B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 12:27:27 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id p4so1207695wre.11
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uCcG9r8zvzVa32ACP9pjDJ0u/GOLkhnUW6bBmHPkFUA=;
        b=BOGEDY//pxaL4SCTRH2vyx67C4dYcNczt8afRE0cKxI6FdPArV/rXR6+bJhPgRZQiw
         vTO0rO5KG3YXJbe8rZdnEPuXzP1auxt2qvnkH9FvfBLgPk/em1BPa90EJhzDTLvr1moc
         zXmAwua8R7s5upW7dDpUchKRs1ent4I9a4F90aU4+jUXcQbs2BV6WHfrXL4WKNX4zCXG
         ycn7EzNqAF5FkRnRpO+qPhl0dt28JEKdiBAzTdsijvD6eVScRbjL+wWJn19ncTQ286NJ
         ygTz1V910/Nncr+QGtLs79GUsxRhdjEB1IY0czqd7BDgW/EOYRmV/X5g3tI2n1MnaXvG
         HVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCcG9r8zvzVa32ACP9pjDJ0u/GOLkhnUW6bBmHPkFUA=;
        b=WhVYZAr4vKYVk6Fx9wlrKf5QiW23aY1e4fsf0ue0DO+JzgjBPHxIwKhmFvkGGf5Z7e
         fJ6iOHsobjt+SWZx76j8YT6k4wBSZwpYtKNdHWEfMF+FDTvUl19UGIMk2tRnvFDE92wL
         CGftsINWujd/HamAOxxMzkbnhHBin1jGecZva0rmx4/K8TzErK68YlHDNPXqWaOQBGUu
         nLU3PnEv4Z0kjQZRFQLMNXDbAijYkmie+Je9cyv49w7k4fZipmyV7VQQRxE4cV7JWe9U
         6tD59SgzmcF3np2f06l4IV030v3LF1CYmpzB97BvdjHS95Gl5I/uGxHUq+8sfgMQjOEQ
         gQgA==
X-Gm-Message-State: AO0yUKVXPuRE2AP0b+976pf5CUqJLRE/ApVwMtGw5uQX4NOPOJkodTJ+
	Bq5SKeeTffbGZ+3tEMYecDg=
X-Google-Smtp-Source: AK7set9YQlBu0WUqDjanj5JJDkG3xTc2kmCFY8j138j5Ef7mpCwU5fRxBfA5EEIVlb91ZHDVEBW9Hw==
X-Received: by 2002:adf:ce90:0:b0:2c5:4c9f:cf3b with SMTP id r16-20020adfce90000000b002c54c9fcf3bmr3854705wrn.7.1678537646073;
        Sat, 11 Mar 2023 04:27:26 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id c13-20020a5d4ccd000000b002ce3d3d17e5sm2380854wrt.79.2023.03.11.04.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:27:25 -0800 (PST)
Date: Sat, 11 Mar 2023 12:27:24 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <ZAxzrMh1zu6WOKyR@debian>
References: <20230310133804.978589368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>

Hi Greg,

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> failure
xtensa allmodconfig -> no failure

Note:
s390 build failed with the error:
drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  656 |         .pe_handler = dasd_diag_pe_handler,
      |                       ^~~~~~~~~~~~~~~~~~~~
drivers/s390/block/dasd_diag.c:656:23: note: (near initialization for 'dasd_diag_discipline.pe_handler')


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/3079
[2]. https://openqa.qa.codethink.co.uk/tests/3083


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

