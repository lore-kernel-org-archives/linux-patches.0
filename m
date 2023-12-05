Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D560B97
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSZ9VuQ7"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6d8162ca490so2115684a34.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701795302; x=1702400102; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9OxrBZgNphVEIKMq/OBJrIuosfHOMdhPrtNTXIWYyM=;
        b=gSZ9VuQ7ZnrnvWgk7/m4qfwTuACnlt8r8EWDptnTGbMDGecoi+nbZ18ZIwaZHgQjgj
         KKzFa5Xq0eIpZeQ512AJSRhXGkhvQz6gHXC0SXVEcKKf6sQ/XK6mnflQd46t9LkmaWDv
         REVOaGUY2N07kVv4A7VPctOtcbwnF9GdMJPCXVl1ZmfwS7gW8GOAPh/9aadFDlOZEfES
         jO+uUHoJI2mzX4QIIBg8rCjKLo+M2BhEA/OhYsSDToYgQO3RPv0FK15rDqIjZnedDKoF
         tj7fqdRGDpJrzoN2x9ftQYDnOlgEb/vm7gUQI8rVIc+eP0+9PGKRCJLg3LrcB4AXku0+
         YeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701795302; x=1702400102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9OxrBZgNphVEIKMq/OBJrIuosfHOMdhPrtNTXIWYyM=;
        b=Xf/z4Znk+Q2Uv0hqwNv82BreFl3LBsUiVHYfU6GIleR+o1fKfbTw/sGJRMNDoSicAf
         eA2H30BuMX5du3vREXDzCNo9vAhnpMvzB6UhgOAHhh12/5tQ/ItnGFJz1LHeHLoM9FQG
         2ZmKFmBWFuq2nfuV7aO+fdKogNE3DVfxICTjLnKSKNLH9xXhbXBzNOXdeTG4hyXmoUwW
         HH0758ZQmHDPya/6zQ5bXTQjF44imqL15PpA6jdYa90YDA8YV+uyjN774nUiejYhWbNX
         qrp3oUA77kU8/CCyGf+/OSsGPkZiKHiloVYe+gSBWUOZm9hmRKLpc1X7FFd36BWxpycA
         YRQw==
X-Gm-Message-State: AOJu0Ywv+HZWB7OqCPb+oPLvCs70xQ8rcA17VObvEudjnijdCWaWz+WP
	pLjOVfrZRTQ8evq0F5sWV0Q=
X-Google-Smtp-Source: AGHT+IEBC/Md1Vt7qRHajPubEQ4P+Al1cYnLz+7MzGO+7kte/K8NgAKU1tSgv/bPF0GNxKXuH8kqKQ==
X-Received: by 2002:a9d:6a8e:0:b0:6d8:779a:1b1b with SMTP id l14-20020a9d6a8e000000b006d8779a1b1bmr856434otq.7.1701795301875;
        Tue, 05 Dec 2023 08:55:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z5-20020a9d65c5000000b006d679b53e8asm2289178oth.24.2023.12.05.08.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:55:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:55:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/107] 6.1.66-rc1 review
Message-ID: <ca62c23a-ee16-404d-b983-a680857737b3@roeck-us.net>
References: <20231205031531.426872356@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:15:35PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 146 fail: 11
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
	riscv32:defconfig
	riscv32:allmodconfig
	riscv:defconfig
	riscv:allmodconfig
	s390:defconfig
	s390:allmodconfig
	s390:allnoconfig
	s390:tinyconfig
	s390:debug_defconfig
Qemu test results:
	total: 537 pass: 467 fail: 70
Failed tests:
	<most ppc64>
	<all riscv32/riscv64>
	<all s390>

powerpc:

arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
arch/powerpc/platforms/pseries/iommu.c:926:49: error: 'struct dma_win' has no member named 'direct'

riscv:

drivers/perf/riscv_pmu_sbi.c: In function 'pmu_sbi_ovf_handler':
drivers/perf/riscv_pmu_sbi.c:582:40: error: 'riscv_pmu_irq_num' undeclared

s390:

arch/s390/mm/page-states.c: In function 'cmma_init_nodat':
arch/s390/mm/page-states.c:198:30: error: 'invalid_pg_dir' undeclared

Guenter
