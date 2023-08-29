Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8F1156C7
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 12:26:18 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3fee8af9cb9so40385045e9.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 05:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693311976; x=1693916776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f/vl6V+/9Rs5Obbv8m6Ii1Y8RyQvDJMieLJcGjD769I=;
        b=eJE3iJH0cEFx0Ij0DL+xRcchTugw04PthN4i3mSBr+XTRr1KKDOGuOlRLKwivVc9tl
         fA0U8xot8XVHU+fDkxIAHxIWGrMVdsgs9OSA41Px4w34lNKdNE4nNKcmMBjiUXn5xW/L
         9YHBfJBwFyy0up9FcFVIxWYXUNY5l5whZHa9NwLUCBpwD87zQNFwizG4n46WlpvxzCQ6
         YmGV4qd1D46A9xf8jtMgl+1LToiWvT6TauACCqKmGMSh3GowiKSLXLN69yM0eBkiw/sj
         B2WTVVGRaM82J3IGyJSdwmqMZtMgg4brgbUtyVA9aXinRaTF8tlrc3/dPh1CRnN9d4Qm
         KnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693311976; x=1693916776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/vl6V+/9Rs5Obbv8m6Ii1Y8RyQvDJMieLJcGjD769I=;
        b=R5GpMTdccHUJg+MQpk2eNrvhmBFM6lW3CZ1M9Ps3I8IhLK4PG7Yp/hhnpI/8PZhmNr
         +//9xuuyWYsoTD64VtinGxZzSjwSV8cK3bQk17NjCMtxK4CQA122onvplib67A+QckKV
         dHPDLYGvh65W+uhxve/FGdGAZjqjOdUH/zsZwbqnB1J2NzgTsn+QtytxGlOCV+3GddNx
         Syw2mdwQLNwS1rMbdF3FP8ovDc++lucBsJVLukRsK+fpplW0QjMJcCfvY+Z11NAcHq8o
         8DjXyqo9CI3frbtX96pTFd13dmx1y1k8xDxkgknxAThxw92WsUqM6B7YRuQFRaP47NVf
         OeBQ==
X-Gm-Message-State: AOJu0Yw95TsIBICbhQeUWOYta7fwkyWDvYXIWEejuphIgW5lZ7X1ccS/
	IKP/C0M5hh76wCsrl47rbL0=
X-Google-Smtp-Source: AGHT+IHz2BQglAeihsEWvAnkKI1HGNHU4OG399teUxWeazkybqCsNXASm823S4K/L+CNErKHWgUvxg==
X-Received: by 2002:a1c:7302:0:b0:3fe:c7fe:206e with SMTP id d2-20020a1c7302000000b003fec7fe206emr21544055wmb.16.1693311976081;
        Tue, 29 Aug 2023 05:26:16 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id n15-20020a1c720f000000b003fed630f560sm13776467wmc.36.2023.08.29.05.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 05:26:15 -0700 (PDT)
Date: Tue, 29 Aug 2023 13:26:14 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
Message-ID: <ZO3j5h2AvQRph+HL@debian>
References: <20230828101157.383363777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>

Hi Greg,

On Mon, Aug 28, 2023 at 12:11:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230829):
mips: 52 configs -> no failure
arm: 71 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/4841
[2]. https://openqa.qa.codethink.co.uk/tests/4864
[3]. https://openqa.qa.codethink.co.uk/tests/4863

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
