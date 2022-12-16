Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FC20E3
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:11:14 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id m5-20020a7bca45000000b003d2fbab35c6so1714643wml.4
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 05:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zATequ/mwmonfG64bUqQyd1X7tC746Mmt3aX2pV/efU=;
        b=cnr3D4KYC9xbOBqrz6evjwfdGLm6LNRh1nNvK7iRmdHNOEAQDzHqQRQjJ+RTUnW1yV
         9M+Z2GUPARuXXPFTulNKJxGTulLWWfGuzAp4qw+ZPWfRoXchq6UjwQ9lTjmqwpphf+6R
         mjUWKaxNvXP90d0z1J3UpVZVsv7s2dVRY9Sg8k6VOx0vt6GRyLtNmxQ3tM3G8mSU7Fz5
         mP2Cb4J2WgNM5ctAykaeoptE66DWjuu8ATLJ+M+7sV4K38V1Kt0+4+AhzLc3Pb+x6T8Z
         3ayc98PuglG6VoATd+jxeBhwYU+V94427ItIWWHDFQqLx+0jyUt4wzh+Dv2anq+9qpqW
         65Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zATequ/mwmonfG64bUqQyd1X7tC746Mmt3aX2pV/efU=;
        b=IaVL15OF/mi2AVsTNylqyszkDH58kV6JO022hY8OCcOeL+C9202IFB4ZM8JGBuN8vh
         PiUbJ1CImYW00+VyrU+uth3t3otDP69AxtiC7B1JwaE49xCePd1eU7Nuo+Gvy25r9a3p
         kRKZ+WPpf/yHWHq8V0xEUdMtFcwQLpY6dZzBjkLmPpAEWzHEsYlJR10xO13yAAlyoRJt
         btGv4VOHpNbIPEA8AKgOyP0o/sq9bW+bVYSDSxfooLS24dYdZwUNX9tQhaKmVmskX9E2
         gifF0oESSw2oB6c0ub2jtfpfFMYHyh3Hy8i6tiqi9LFmjQcI8g43PL50QDo3yELCrT6z
         O8cg==
X-Gm-Message-State: ANoB5pkYi4HUu5xxbEBjHY5XiN9/gkMLv5m3asa0pOXLXy52HWVqdxsP
	5iFmglkouFKrWlKims2X160=
X-Google-Smtp-Source: AA0mqf5k281z8UJtBhUW+9e1XQsZSnWIKmXhrEWjl4ZqIneSYpsc/fQguq2DhmimPbPQUxoO9Buvqw==
X-Received: by 2002:a05:600c:1d91:b0:3d0:274a:3171 with SMTP id p17-20020a05600c1d9100b003d0274a3171mr16573641wms.0.1671196272788;
        Fri, 16 Dec 2022 05:11:12 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p16-20020a1c5450000000b003d07de1698asm9562837wmi.46.2022.12.16.05.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:11:12 -0800 (PST)
Date: Fri, 16 Dec 2022 13:11:10 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Message-ID: <Y5xubgkE7EG4bPaR@debian>
References: <20221215172905.468656378@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>

Hi Greg,

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2361


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
