Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C4EB2B
	for <patches@lists.linux.dev>; Sat, 26 Nov 2022 11:17:22 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id o30so5179436wms.2
        for <patches@lists.linux.dev>; Sat, 26 Nov 2022 03:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKBlOjDIo+FXnoo/ratYxLq6wevcO8d8/HghKFwYCx4=;
        b=PdSUeXcyA/vBYOIS46Dxg3XdcZj2UdydFPmSFt+ujsV631OvtyTWC+EF8i++boQIYj
         Dr//OLHcBDVXrimwn/E9SsbEVXLdNaKi/CQmAzgN5+xSTw9BOM0iU0hz+GEWtrbENPrt
         EfaUXsaG2CiINFreuUVOJ4jD1zrfSvJVDeRPfY5ehTvolF5JIAK1hwYdr/rQYUnH+pb9
         sUAJpXiSwrg10lLuemj5AXs3FzbRntfNcXakSYGXNR4HqwY/OuPA71XQtnURgHwO7Ksp
         sm51rNaKKMJQL4/9WeIb9NCVxrEqkNKq/Zb85DIBEXfEBxqLpwb+tew8QttZLTn/HN8B
         tHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKBlOjDIo+FXnoo/ratYxLq6wevcO8d8/HghKFwYCx4=;
        b=W2YMg25cWVcoP1O+kLz2gmNDpuMzB/XkTbKoSA4k14NhnLWeqbUipqG9QdEqOduaGZ
         ccLj3HIISAflk96q2xQiOxGqgjGJjKPW4PLzFLQ1E86rXiGkAL3z2cz6RGAMhqS2qwJP
         w000BOpShPOfeRa4QcRTdO1X6JpxNewnMZGkbcPuWorj5Q0oadJpAZ/pfWIQZZsW0guj
         V01KSvbBtB1o2nmSKUBOuMon40jRe4/k8Vuk346rxprubpIFdLZCBx4c2HrqUJjauIiA
         HefO0M6hwAC+MccGAbm0IpAMuKdujBfRpZtaCaJlCh9nfEbYswZani4C3JD8f3yFbvmd
         6P7A==
X-Gm-Message-State: ANoB5pkERr2xl9yYfN7NU8r+jt8LkBrj6zBQtWetECqdZlCFdT6B47jf
	aKjHgIrrd/ffQkOyccFztg8=
X-Google-Smtp-Source: AA0mqf6ZSRviRwvrfCzcg5u5CU6ujh9mzD4e6f1QEbdq8uAcNdPU4CLP8AHAna4Sj3eSTBDoPPOiSA==
X-Received: by 2002:a1c:790a:0:b0:3cf:e137:b31d with SMTP id l10-20020a1c790a000000b003cfe137b31dmr21524246wme.205.1669461441065;
        Sat, 26 Nov 2022 03:17:21 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c4fd400b003c6c5a5a651sm9046745wmq.28.2022.11.26.03.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 03:17:20 -0800 (PST)
Date: Sat, 26 Nov 2022 11:17:19 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <Y4H1vz8htC1+9rbB@debian>
References: <20221125075804.064161337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>

Hi Greg,

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2226
[2]. https://openqa.qa.codethink.co.uk/tests/2229
[3]. https://openqa.qa.codethink.co.uk/tests/2231

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
