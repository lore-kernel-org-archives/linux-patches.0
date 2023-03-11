Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2537B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 12:47:27 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so7909155wms.2
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678538846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG+XDDsuS0ZSnVTC9Y0KL7M1HHk6RFW1/rF+Zc3EvoU=;
        b=Lk25gEEq+pGPmf7NgSfolMBtNmooCjRuWdWhl8XJOARRdE2hr/HJFxxnYIB4INAFJm
         +ZJfXopXL6VX21ZjBVvPOU1vJqQbpP6BNw98OSrnx5BKdsdCWMaWVaUaiSeiEEwjpEmC
         AIRPFl8MP8xgm/fCnZeowKYtzfahh8hLbi1WFRHzcxxBWFk3MvqViNhjVO5wi6XL32M9
         ZezRt+arpjqEKvnw7JKOOWFGmXBAQxkolWn7PwfdYQg2uMLlmPnFivWHdaTUUcEuGM68
         IJbOqED71Gt+wMZ5gS2n+GtYJ0k1N7B4eb+4Oqe4ePvIJnyTFB/o+dG9+i9ZYuOW6NNO
         iuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678538846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG+XDDsuS0ZSnVTC9Y0KL7M1HHk6RFW1/rF+Zc3EvoU=;
        b=oaWhO8ARHHQvWQPAMxSucY1fiWvfRzJSSsrqD2y36B2HhLeQSpS0ER1uRieh6Phi/c
         qftMsO1WOGnb961CeFAsDdxHfK9tg5mJMyl4vurfXA897wXt1dk5n0yBG3n2kgiCpF2P
         99/iYuP5COVoOGnyxj6HExeC96MyMiadW7ZJPdmsj1NN4KFY1M0h+UmZAGw3rxjrKSGV
         6CDL+9yZpP6HAEnOiS6Ohu1JgUFI01ffGN1+O02VTWX7iPIXCuTTWJZBvfs41uF5UYld
         yDU+DhXl5b+1y1tttVYNTMGDgEOKr8gXiFb4cEgEVV85fhnYSg6Ct857O8+XlCVDHXYb
         2niw==
X-Gm-Message-State: AO0yUKWDmamA9FzitGIMbbqhYk45FJCqDEViuFHO+UmS5fwAKptviy3z
	7knvt1DHxjGLgMwxWaFtg4s=
X-Google-Smtp-Source: AK7set9JSjHy6wHUEUe39Ir6qYIqFyQG3TiAh/Chj112lk3wx1xNetuk+R2dS8eYeGVyrF6BUVSkPA==
X-Received: by 2002:a05:600c:35c4:b0:3df:9858:c039 with SMTP id r4-20020a05600c35c400b003df9858c039mr3596885wmq.14.1678538846080;
        Sat, 11 Mar 2023 04:47:26 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d12-20020a05600c3acc00b003e2052bad94sm2711439wms.33.2023.03.11.04.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:47:25 -0800 (PST)
Date: Sat, 11 Mar 2023 12:47:24 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <ZAx4XI1QOYyHPA2K@debian>
References: <20230310133706.811226272@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>

Hi Greg,

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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
x86_64: Failed to boot on my test laptop.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

Note:
Failed to boot on my test laptop, just black screen.
Bisect pointed to 4eb6789f9177 ("drm/i915: Don't use BAR mappings for ring buffers with LLC")
which was added in v5.15.99. I failed to test v5.15.99 due to lack of time. :(


[1]. https://openqa.qa.codethink.co.uk/tests/3075
[2]. https://openqa.qa.codethink.co.uk/tests/3084

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
