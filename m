Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD0EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:01:02 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-792965813e7so123721639f.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693360861; x=1693965661; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBJ3hYsypardy5bqovi6u1iDRftB1teY+ENziJZCw2U=;
        b=nADsgB+j8kU0ShkFnnz7ccfDI5GiqwwugqSLAl7G840c63PL0FWoXdS9VQPbqe9bbo
         doXc6z9xz3EyUg134iDKdv4adqxn1tH5pHUaUvG3A8hSwXHB2w/sZIpcEIQepefpvD4Z
         Xm53mjw8yKCHxehoa/EBfHuFYsLNwoRnDqO3xH3NyAtbnqmHhYpQIEwX1OjYNuMT4CCM
         fnWyhmj/Hrlh3PKFEKhKrMzE1tS+5OV2+UAFBwjfPronZ0gDz35hz7HVE8JHPa4DKEaK
         KQZH8SGJC5r6RgCebvsdC8vyy5KgAx2vztjp+8Gdl/Z9ueqenZLn4IEU6FfVl+vuOUB3
         ArjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693360861; x=1693965661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBJ3hYsypardy5bqovi6u1iDRftB1teY+ENziJZCw2U=;
        b=l9X6iFktSPpEotLxvM3TdCRs/WHHOy4rf8uIBprbp4qs27fpf8aSzVGCDsXVxGD78e
         j/eeMT5VAbxSzsguMEx8jgpyToEBn0RDvGEAI2F9xYEwm8XHbzf/mBsOBVJiKDCXhHYy
         8Zdb4mbHAO0cy2PsOzRCV3Q4blBG0FHyiKp9KO7QKq4ZQM/hpSa/p405UcaKXeekLNiP
         f0jXFE1on3TBUNIm/F/s/ca8HBBo8pof6XuCE17tqUQBUnJlEukoNUXAonxtRy53IRwP
         KIX6qfZTwp/pz0ktMdi5EcYMT5mUXFtSn+f0nA9amJUc0xWTl9nOdGeG+nkTPdu3uaS5
         8qdg==
X-Gm-Message-State: AOJu0Yzg+xTNDYvtLP6BKCO9ureGbZsceorH4FfOpSTiktcMLa+099p2
	pQ4lJB7oMdQXyd9UOMQiJlY=
X-Google-Smtp-Source: AGHT+IFdlpuCa4wtV8m0eRng+0OGcJQWEFhqL8ck+0oeWUOSlJixI0fx7ITrQM+GCCMpTlnajilveQ==
X-Received: by 2002:a5e:d713:0:b0:786:4795:30c9 with SMTP id v19-20020a5ed713000000b00786479530c9mr1220078iom.20.1693360861663;
        Tue, 29 Aug 2023 19:01:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k13-20020a6b6f0d000000b0078680780694sm3612024ioc.34.2023.08.29.19.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:01:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:01:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/129] 4.19.293-rc1 review
Message-ID: <59f19613-990c-4e58-b53d-c5f764483119@roeck-us.net>
References: <20230828101153.030066927@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:11:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.293 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 144 fail: 5
Failed builds:
	arm:allmodconfig
	arm:omap2plus_defconfig
	arm:ep93xx_defconfig
	mips:mtx1_defconfig
	mips:db1xxx_defconfig
Qemu test results:
	total: 438 pass: 407 fail: 31
Failed tests:
	<lots of arm>

arm:allmodconfig and others

drivers/bus/ti-sysc.c: In function 'sysc_reset':
drivers/bus/ti-sysc.c:982:15: error: implicit declaration of function 'sysc_read_sysconfig'

arm boot tests fail with the same build error.

arm:ep93xx_defconfig

arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h

mips:mtx1_defconfig

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h

Guenter
