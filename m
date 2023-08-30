Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7F6EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 01:56:53 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-34ca1aadce9so18016195ab.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693360612; x=1693965412; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dohu8JcCYbtfCQEoNAJu4CBtsaFe5TpGhloC7g3jQYI=;
        b=EfaAO7YBQONIs58Pi1J4xUYNLJm0A8uiU9L+8QXhYt4tgqpyfyy3wNI3OdkgX3VQ7d
         0HRSFLrMAfZ/qHAZzYlf+tIU0wZGONVKw3tb1oyvKFFisovarBXIcG0whu7n+hvO6gk6
         6WjsoxiIcx6TqVWZusR6vAN9dfPdE4u8bW6zdY/CSkTvJqhEDJZ0DckG2lFAamffg1rD
         F09hVM9PiYqUb/X3ZejmLzRBQl+MdXELeL4YP8eiwFl9bXTMU0KIYUgJOUFvbqPNzABq
         6y6fMTVBPHCMyt7MaNjnEU3h4AvuqyqJRghSbLvNgJ7OAiyEr03i0f14BNej0sKiZF6Q
         lH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693360612; x=1693965412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dohu8JcCYbtfCQEoNAJu4CBtsaFe5TpGhloC7g3jQYI=;
        b=IFidg8oJxJWVaPpKkjUko6aMDFH2EoSypMdSRBeabVxDnHBKjvGrzXe2of728uvBEs
         2WvHhDr8p+MEFlaJqr8SarJFLSKXlXqu3mbJ7N/qSb1AD2hKTyPWTmRxBSxHcgWwtKEi
         pFqJynhCr0AlltxXFycEpqwxNRw2i/DcPLK9hpM3aqUoR6dZkeznxpxdHyYZ0nVnkkwy
         YvDVyqKGr1GVd/Raj5MWRFb4zNHsRHU41CSUvyrzRD+tm9BMkogVJcoIddgWFGor72Fp
         JJ8ecOphQmtrJhvcZOCj4M3mi6Ki688bVzD1RhZQI6N2q0sM2Z5d+xuaDxKZX0gTY5WH
         9F0Q==
X-Gm-Message-State: AOJu0Yw6wpFM1Iq6aILTmjdyNNRLUftdFG1/2N7n9TwMVZ0yAu608IL3
	jYZOgPc/3n/u1WSRX0V5ZZU=
X-Google-Smtp-Source: AGHT+IESZC0XichRF7tbayUE0qjAYkv7esnNqWRRnO232/hCeng+/RC1mg/YD9CIJhuoqmrh/uuIGg==
X-Received: by 2002:a92:dc87:0:b0:348:8576:15b5 with SMTP id c7-20020a92dc87000000b00348857615b5mr1017781iln.3.1693360612586;
        Tue, 29 Aug 2023 18:56:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u4-20020a02c044000000b0042b0ce92dddsm3560561jam.161.2023.08.29.18.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:56:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 18:56:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.324-rc1 review
Message-ID: <98dbc981-56fa-4919-afcc-fdf63e0a1c53@roeck-us.net>
References: <20230828101144.231099710@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:12:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.324 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 133 fail: 6
Failed builds:
	arm:ep93xx_defconfig
	mips:mtx1_defconfig
	mips:db1xxx_defconfig
	powerpc:defconfig
	powerpc:allmodconfig
	powerpc:cell_defconfig
Qemu test results:
	total: 431 pass: 414 fail: 17
Failed tests:
	<all ppc64:pseries>

arm:ep93xx_defconfig

Error log:
arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h

That is really an older problem, caused by commit 2e50d55578b0 ("ARM:
ep93xx: fix missing-prototype warnings") which instead of fixing
anything in v4.14.y broke its build.

mips:mtx1_defconfig

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory

Again, an older problem, caused by commit 10130470bb0 ("MIPS: Alchemy:
fix dbdma2").

powerpc:defconfig, powerpc:allmodconfig, powerpc:cell_defconfig

arch/powerpc/kernel/rtas_flash.c: In function 'rtas_flash_init':
arch/powerpc/kernel/rtas_flash.c:717:29: error: implicit declaration of function 'kmem_cache_create_usercopy'

ppc64 boot tests fail to compile with the same error.

Guenter
