Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5555381
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:37:13 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id f11so4305334wrv.8
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677757032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=poBYxosYo3cIJmxbVSW7d8Wean0D5vMPhmQIYxLgsbU=;
        b=bsGbVVD6XLn6JNBxftc8OzRczWi9O1OfD1UE3j2jEjodMs/MawarT1lEnuWaj3DbbC
         1Zwee7K9771TRiHDPGfbdmmNiF3I2e+vX6W5mL2t8X8jOlCipmhk8YvU33/yBijNnMKZ
         /THhsF0A3LFrt+U+dyEEh1LIpLyGCTzvpZmmXGdG+WKem09L5vMnn4S4lwG/GQhok9Ua
         rXZzMrDy3SWqOq8di77bOc4iBdxTMBA1B9Qp+BDU2xeoFqUY17EIBCtJbSCjqKRGBfNE
         Y3aHhUuNRkCEModYRXFfAbYJLkYDq9MoFV1aZyOLwGllsE99bAYCPmKQxAYmf5MsFt/A
         UtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677757032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poBYxosYo3cIJmxbVSW7d8Wean0D5vMPhmQIYxLgsbU=;
        b=sGz0wd1GxRO8Hb5jnpfcOWEchkTGQpOi4sXfvl5+YtrdBTbiaLVtzBSl6+9mMC5otB
         yfINwCh1Ya+p3amijM0gXtIxl93KF00ojshwRoN++KH2jdKr8NGMuhHSAwL3rPh5ZqQX
         cufnczqgZRh/XXd9Rgbk00AYjOJRzF/BpdCGfFJbRbLnni69yaZsyeWpNXgvclts40Xz
         gD7pNekZ1sMF9L/R8mJEYao5SXbkfJDZwk7thkKcXpLRGfP3Vvv3jh3riOVJrWUA6Q6c
         1quH0+lYeEL0TFAeSIP589iHUhAi2voxZ8Dd1mVwewiK8NnXmHrB0tJtegWa70OvgoOc
         UiJw==
X-Gm-Message-State: AO0yUKV88ga2TxwmLUsQmSU//LihQM6q1f6rrjDFmkXPxPwgjzsqkBb+
	ppK7/fgLNo1fipGzEFXQ3kU=
X-Google-Smtp-Source: AK7set/ew3Z9kHlo9wlyyy4gMA9iGuo6DGpOU99m3zjy0BieqaQ01tlswiJ0ZHJhKeYoBvYX5mLSTA==
X-Received: by 2002:adf:e747:0:b0:2c9:23c4:8f9e with SMTP id c7-20020adfe747000000b002c923c48f9emr6699452wrn.38.1677757032055;
        Thu, 02 Mar 2023 03:37:12 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id x8-20020a1c7c08000000b003eb2e33f327sm5459675wmc.2.2023.03.02.03.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:37:11 -0800 (PST)
Date: Thu, 2 Mar 2023 11:37:10 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZACKZqDji0xzknEw@debian>
References: <20230301180657.003689969@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2975
[2]. https://openqa.qa.codethink.co.uk/tests/2981
[3]. https://openqa.qa.codethink.co.uk/tests/2983

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
