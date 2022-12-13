Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1272F2F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 12:01:56 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id bx10so15380109wrb.0
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 04:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWgHX5jSvV1MjDJOVOhUVYT7IbR7BRcjtNaxKkj11pY=;
        b=lgYmiLs9DRSQroHMfB+tDUy1vvg7wt1wThMgtVvJGnT0j+vjddHyIQH+jyFR9V78Ca
         f05Q7FsNlE2f6BqxFPyD5/9qtAGcNDfBbXixKh6Ylk+mrNfztrnRkVz2x9rDZdHf7N6r
         7qIHyceAarUWdm41Kp1mPQnbPkycix8wzk/CiBm72PaykM653WabDtvE/sBqitqHyGVs
         sd4Y91gmaWYFW/KEG6B97gpyxOemKtXCK/qfeSvGs4o5QlcbLO4amor1fKekyixGfJKx
         pUiDGxbXysTD5CbN2aHCVGRt+lHkJXdAU0PSmkgZgjjjxRbOqUuBC5z342y/E+jPGLLS
         Pkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWgHX5jSvV1MjDJOVOhUVYT7IbR7BRcjtNaxKkj11pY=;
        b=lEVxLwxOK29HHB+Wx/VcJ/aN0YSMU6M/nQGazvTEfYY01FAngY4Mfvk2qKxDkXPS1R
         UQdMr7pjH+pUVhtbkxexBW4HGowHYqV3YE8JR/0PtOa1+fJqxKjXfKsoQqFMuYXEtfpf
         p+FXS7QE4Tqh4/vdRNFvTQwvPMaw97lCrUhwz7pm1zzkqG01dUM3rihNpFJKQFqCWI6b
         x0N6G63M5XmKBe5X958H0Un6IfNLCh5UtbQSMQuhtX6cFfaEeTSyOXRa0HEyd5DltsUJ
         BI3egStOXuF4iahf5nK3xy19I9NVJb4AwcMSpsgXAnjyJxFMhbEjpSPr3a6bWXcin5Y5
         j+Hw==
X-Gm-Message-State: ANoB5pl8q4/tyVGUGaGeg8X1vKfy+Q+HaojhI++ZbyLswf4++aO9XdDc
	7H5vvBeoo1bwf6dQmbPgVjU=
X-Google-Smtp-Source: AA0mqf5PIQehlqf74gHW14tkOANEmMt5P+hf+taoWEFI7yC/WYv9WTXiydndr4vBCWKyuvKtMAUw9w==
X-Received: by 2002:a05:6000:60d:b0:242:6777:c7e2 with SMTP id bn13-20020a056000060d00b002426777c7e2mr15899554wrb.31.1670932914337;
        Tue, 13 Dec 2022 04:01:54 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i8-20020adfefc8000000b0022cdeba3f83sm11583454wrp.84.2022.12.13.04.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:01:54 -0800 (PST)
Date: Tue, 13 Dec 2022 12:01:52 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Message-ID: <Y5hpsO3WGeTRvTuj@debian>
References: <20221212130913.666185567@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>

Hi Greg,

On Mon, Dec 12, 2022 at 02:18:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2337


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
