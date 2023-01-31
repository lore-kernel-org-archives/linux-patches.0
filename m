Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607A033E7
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 11:47:38 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id q8so10118029wmo.5
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MTasx+tlHSopiV3GgQaWxu+fMhhwtK7KYGbCTFrTiwE=;
        b=Zk07LbMH+ffyrTNolAHT85QHTSNPLto6Mk/P1NaUS3M7rJTPTxduKP9/zAElTmwb5K
         P9/H7V8nS/R5Ent6b7fHWfAFIg0iet22oYXj2a+WcBVMinePSDKUcW7hyGo8JNSHogYX
         MfwOshywVefrWIROSPXzsthA5RYHqa70x+XqOfJEtqBO0L3VGSpJ5fUJBRR3DuVHU28Z
         WzUGVfOYZ2lnReBUTB//cDWDeBpcyRTYisD+2YyYw7kJ/MqlmXbv0GiR57P81NViMwjm
         knT10d8y2nmDJGmnaVZpdDwRZnYzOc9dHZU2JNy5WQF7hlAIknQ1umzndYK6twm5tkO8
         mdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTasx+tlHSopiV3GgQaWxu+fMhhwtK7KYGbCTFrTiwE=;
        b=rN4oNuo0gxf1/IpAkEeTApRhLQHuUVmR/k+w/os4Qf0qiceK9oi1BLGZgl5fOiuhtn
         pqvHrGK7o3OH62IVqpdja9JqR3rXsFKH+eCHqcoUlmHGwSzLr+Znj0olo53CD0czItUt
         xu5CfFw2e/5xzEb1vt/bGkCU2KRwFlz2y+PxTSCsJ9tgPSesVx+6/briXx7HUj59/n5k
         ebYQy336o6vxWwIPdjcwwiEEAuI9Z9EcLDgOfROrVQ5CMVGi+5mYC1RD5yAMtZpbeqGk
         clwKNLt85gDGAPzbypvvzLzNOXRz4nr9weFNugYQGC4tjEjWixFRX5qeICrrCLPB42jN
         zmzQ==
X-Gm-Message-State: AO0yUKUyXzqPzdKqWHf+mdf4JQL2w+7LTu4GJdR6vm7zLBl+WsZuDW7i
	X/w6obmrmvCH6YDbCuFqUsE=
X-Google-Smtp-Source: AK7set9VtwxuHBLBgumjxHbl8Vwl7nDPKcUiYwUfzxWl/SUMAenoyZH4a2HvuTskZF5GiegUlkXCgQ==
X-Received: by 2002:a05:600c:35d6:b0:3dc:443e:3a8b with SMTP id r22-20020a05600c35d600b003dc443e3a8bmr13228816wmq.16.1675165656509;
        Tue, 31 Jan 2023 03:47:36 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003dc49e0132asm10220566wmr.1.2023.01.31.03.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:47:36 -0800 (PST)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date: Tue, 31 Jan 2023 11:47:34 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <Y9j/1k4gm4B03WPV@debian>
References: <20230130134316.327556078@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>

Hi Greg,

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2768
[2]. https://openqa.qa.codethink.co.uk/tests/2771
[3]. https://openqa.qa.codethink.co.uk/tests/2775

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
