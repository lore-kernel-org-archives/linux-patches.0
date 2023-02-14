Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE19F107BC
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 11:05:23 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id g6-20020a05600c310600b003e1f6dff952so722707wmo.1
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 03:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ1Dxex5CkP4G/ke8ut7swdMeOh8578X1cc+Ky0yYAM=;
        b=Ypx4a4NJU5j5qTjZcAB23f11k9y3Gp8MiF6FIXy6aWbRSHbDplqJ41wBX0jG8fDbpP
         mw5aFNjpeUgS8zYrlVvXYValwl5HD+Id9xKsJpoWJsrs9+eztSAnukJFg6Mzk6ymhU2Y
         tWhfFPLQJZuprb/xkXHNfDYizaqcQKf8Yatq2XRJ4taMmajh1tXTWDr1+BF7rNctTHF1
         mP0DuQaMDL3zA2tn2317kW2MlnNrRIQLD5MG4Tcx8bQ5gJEBMkm3z320OOS/pK9DAf40
         YZObitRf/CvUEpjCvIoYCtYmH+OHROZNyY1zpuFCeAOnXcTVV/dEVOeoCjbpYr+EvY1b
         qe3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZ1Dxex5CkP4G/ke8ut7swdMeOh8578X1cc+Ky0yYAM=;
        b=VFtdspDBtX45ia0Ytmiqa5ChMy+XRMKsQsYxi2Dlxw5c3wDvgmYtM1ESrqb5G8pTRZ
         UzqfS0vayBLElcTmPI/vMuFLVBOonRD2rz9AS6HSR1M6n4L1X2nbyA/3gPs7cciy7LPu
         d1eJwE+I+tARlDPW0oBwcEYBRfWRx2Hcureb4kMYm6YV+IF57ktNKv/NqxZxz5Y+iMX9
         t4I2MmJd0/QwEe3ToMJaLeXUMoRjYPpnz6t3RG2tJvS8AuFXCcc2FrIM5tVOdzAUPts9
         kzkOxGs7e9mCC1y3BnxftEgvFT972UiL6j3R2tVmk3sbm+R6GNHIPo2mAKKURXqnZhBg
         ZTBQ==
X-Gm-Message-State: AO0yUKUekDV5JlBIBS4cVP9H7G3DyDzeDRxWAUV5qOhjbqkYHGFLMzPP
	S03wZr+xP4OZgvJ2znKGbtY=
X-Google-Smtp-Source: AK7set/eHMDEwWkJX9cRcLFxgAgoWTJ9cpjUkpmCxj34MwX4f4aW25Tz4kYm0bqcTxqmkmWvMH2Z6w==
X-Received: by 2002:a05:600c:818:b0:3db:9e3:3bf1 with SMTP id k24-20020a05600c081800b003db09e33bf1mr1510716wmp.31.1676372721989;
        Tue, 14 Feb 2023 03:05:21 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003dd1c45a7b0sm17669618wms.23.2023.02.14.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 03:05:21 -0800 (PST)
Date: Tue, 14 Feb 2023 11:05:20 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Message-ID: <Y+tq8HvE2TjffLk9@debian>
References: <20230213144745.696901179@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>

Hi Greg,

On Mon, Feb 13, 2023 at 03:49:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on qemu. New warning. [1]

[    0.768162] sysfs: cannot create duplicate filename '/devices/pnp0/00:05/cmos_nvram0'
[    0.768167] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.168-rc1 #1
[    0.768168] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[    0.768170] Call Trace:
[    0.768184]  dump_stack+0x72/0x92
[    0.768187]  sysfs_warn_dup.cold+0x17/0x2a
[    0.768191]  sysfs_create_dir_ns+0xbc/0xd0
[    0.768194]  kobject_add_internal+0xb4/0x300
[    0.768195]  kobject_add+0x81/0xb0
[    0.768198]  ? klist_children_get+0x1a/0x30
[    0.768200]  device_add+0xdc/0x820
[    0.768203]  ? acpi_fwnode_property_present+0x5a/0x70
[    0.768206]  nvmem_register+0x4d6/0x7e0
[    0.768208]  devm_nvmem_register+0x3f/0x80
[    0.768211]  rtc_nvmem_register+0x38/0xe0
[    0.768213]  cmos_do_probe+0x56b/0x610
[    0.768215]  ? cmos_set_alarm_callback+0xd0/0xd0
[    0.768216]  ? rtc_handler+0xe0/0xe0
[    0.768218]  cmos_pnp_probe+0x74/0xa0
[    0.768220]  pnp_device_probe+0xc2/0x170
[    0.768222]  ? cmos_do_probe+0x610/0x610
[    0.768223]  really_probe+0x28a/0x470
[    0.768225]  driver_probe_device+0xec/0x160
[    0.768227]  device_driver_attach+0xb3/0xc0
[    0.768229]  ? device_driver_attach+0xc0/0xc0
[    0.768230]  __driver_attach+0xae/0x160
[    0.768232]  ? device_driver_attach+0xc0/0xc0
[    0.768234]  bus_for_each_dev+0x7c/0xc0
[    0.768235]  driver_attach+0x1e/0x30
[    0.768237]  bus_add_driver+0x148/0x210
[    0.768239]  driver_register+0x8f/0xf0
[    0.768241]  ? rtc_dev_init+0x39/0x39
[    0.768243]  pnp_register_driver+0x20/0x30
[    0.768244]  cmos_init+0x16/0x7d
[    0.768245]  ? rtc_dev_init+0x39/0x39
[    0.768249]  do_one_initcall+0x4a/0x1e0
[    0.768251]  kernel_init_freeable+0x22a/0x281
[    0.768254]  ? rest_init+0xbe/0xbe
[    0.768255]  kernel_init+0xe/0x112
[    0.768257]  ret_from_fork+0x22/0x30
[    0.768259] kobject_add_internal failed for cmos_nvram0 with -EEXIST, don't try to register things with the same name in the same directory.


arm64: Booted on rpi4b (4GB model). No regression. [2]

Regression:
x86_64: Boot failed on my test laptop with a panic. Will try a bisect later today.


[1]. https://openqa.qa.codethink.co.uk/tests/2856
[2]. https://openqa.qa.codethink.co.uk/tests/2857


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
