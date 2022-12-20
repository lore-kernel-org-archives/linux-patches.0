Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309237E
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 12:26:07 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id v7so8619869wmn.0
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 04:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYPzO1sV+Q9V3ln8qWKl03fQyPbIX5Xv6crA24tJRIc=;
        b=DVc3xzencbOETXcD/75Y4g3qqyEejDQn7ccQsCrBCE44LyvZwIgNoiFHgiOl5q+RZ/
         BkU98R5tEWTD8g/DHt2GdntW6/SZGWa1/N8nyqo4smPtzJRLaMYKJKLbVAPLQ2abFizP
         SncdSlHAz+szR3gZSmD/mskRXySndHblL+Yu6XbU151/n+z8io0Qo+olqQuhdp/Pcwi7
         dwXGVspbenPCjGdhayCiJXm+j/boknUFV+ZpDFpN7LpYXMiu6J8EK15/sgq8BGINiV30
         J6Z7gsVYRcL4BvQxNdAsdIPOIAwEnIICzdAti044GzKYiaKhYKbi6M/YSG36ijcNvRg1
         rOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYPzO1sV+Q9V3ln8qWKl03fQyPbIX5Xv6crA24tJRIc=;
        b=JLxpmPdY8HjZkwoJntq1WfxESZBsy4+nWKR7jETFw4BZ7DB4XWz6bXPTW3s+gZKCDu
         /tSV/uUaIwZMRIh17OeueGgJ0elli6X58rbrPmac/1rzQdeJGu7CJTXl2HgJ3gQwPREA
         xoTNlD1rDO63xjxOIvptWnQQ+ivvVLvHl/0sI9U+M/m0FXeQlijC4JGR3kuzNTU3uWrH
         UXqF1ZI9Xl2cyAx+D/wnDASx80AUfQc3OBooeDn1fvNMKoawhf/A5rg0M8HmVFznAMoI
         I1Tw6RPzkQIiRCufF/SP3qtyrZ8+er9y6Vp1Wbtng9BUNIE4uOFOACIj6z2BDvzRoDXM
         oEgw==
X-Gm-Message-State: ANoB5pmM0ni5wSZZAbRerP1jU/lcHnITvleYkFzc9zkk7Y3HDDFy0nza
	2ZQkx1U3yDqnCalqtspGBDg=
X-Google-Smtp-Source: AA0mqf7FmP+sPdD68l4OCaTcBjwJEHVWyxx/tEbdfAkj2zTju/NvgA8gRUAxchzNVHPvqutKLCSR8Q==
X-Received: by 2002:a05:600c:2d0b:b0:3d2:2d2a:d581 with SMTP id x11-20020a05600c2d0b00b003d22d2ad581mr20856209wmf.30.1671539165332;
        Tue, 20 Dec 2022 04:26:05 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id t16-20020a1c7710000000b003c6f3f6675bsm22148657wmi.26.2022.12.20.04.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 04:26:04 -0800 (PST)
Date: Tue, 20 Dec 2022 12:26:03 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6Gp25YJ/m+DcgWH@debian>
References: <20221219182943.395169070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>

Hi Greg,

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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
mips: Booted on ci20 board. Regression.

Note:
networking.service is failing on mips ci20 boards. Issue seen on v6.1 also.
Will report upstream after bisecting.


[1]. https://openqa.qa.codethink.co.uk/tests/2420
[2]. https://openqa.qa.codethink.co.uk/tests/2427

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
