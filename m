Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631A6C5D3
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 20:30:51 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id ml19so43218253ejb.0
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 12:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cOpI50IRSP+tpFzJsKqCTjkUrvRMXY4+JeOnanNhycY=;
        b=qh6SpbhrML9jYXByaI0wmEXwSjxM++62szbAucqjj3RKxv4ZV/7NbmywEHXzgfVu2z
         37gsduzBGKYkrT6tp9lTOYXaw6bQ6XO9a5Ycf1nWBMAgr4xnI11YP+Fb7WdT+J49SdxR
         Zv7ah9Zap4aBt4xkipVcOcnOdV3e1kZifAPEt2M4LSsTVDDf7zXe66C5s1Hg6sV88a2A
         T0l3W+pSX1L9gWQeW+1Y0Gpm+aKYk36oBy9Ira44DJX3Ns/9YxmpelxQ7MIFxN1Em3vx
         Bg8sMNLTJyP36P2hsV8oo8zOpp6ieU/0Ldu8ZCj80IBvEmDfjyRFlqsjrN2af8ot68E/
         zVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOpI50IRSP+tpFzJsKqCTjkUrvRMXY4+JeOnanNhycY=;
        b=oV2aYnGJLKLdpamVYGMltIOBmbJ6KX6YkOn1RRyx7mnct+ltczrvhSgkKWwumrVGx6
         iPptj+TidW+IHa1+sZmduEVs7+KNHiQxNpS5cwH8dUqrcrGl3bP/FweAd9yeBgeGc1CF
         YM1iNQ3Z5mJsbAULqI6zIJhu3h6takdNvFy6zO8UWPECLPluZTz1HQdasUzien4+G2+f
         Eyumu639zXONYajqrdKhEiwu+7C/Nr0JeErE4O/HpOs4Xf4Xv9KomTGe9DmKdHRRDdAG
         sJdcqCIwQ0DU6NJBsc/u5c85NqBou7xr1ohqdDNSz/J0UU1M88FbPa0PJV1Yx/gwYBHq
         opDw==
X-Gm-Message-State: AO0yUKWGL5ohmlAzB4hMAik33oet+SMXHfF15ghCdbJIMGu3YEoIYMyc
	AcYucnkjNbpW9Sj87kSR2CE=
X-Google-Smtp-Source: AK7set8K7TKDeiDhACB6bO5sVmIqhSarHiJfap/WC8YJUGjbe7STej9JU7THtj/iCBuSzJSFnBlODA==
X-Received: by 2002:a17:906:b753:b0:8af:2b57:b80f with SMTP id fx19-20020a170906b75300b008af2b57b80fmr4007892ejb.55.1676406649582;
        Tue, 14 Feb 2023 12:30:49 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id h7-20020a170906584700b008a9e585786dsm8584782ejs.64.2023.02.14.12.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 12:30:48 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id E8812BE2DE0; Tue, 14 Feb 2023 21:30:47 +0100 (CET)
Date: Tue, 14 Feb 2023 21:30:47 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Guenter Roeck <linux@roeck-us.net>, gregkh@linuxfoundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Message-ID: <Y+vvd+lHl3nd2PRu@eldamar.lan>
References: <20230213144745.696901179@linuxfoundation.org>
 <Y+vk638j8tpx9peU@eldamar.lan>
 <7352502a-37a0-6813-7c06-dce1cea1bfd7@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7352502a-37a0-6813-7c06-dce1cea1bfd7@roeck-us.net>

Hi Guenter,

On Tue, Feb 14, 2023 at 11:57:04AM -0800, Guenter Roeck wrote:
> On 2/14/23 11:45, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Mon, Feb 13, 2023 at 03:49:05PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.168 release.
> > > There are 139 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > 
> > Not pinpointed the exact cause, but booting 5.10.168-rc1 here on a
> > x86_64 system:
> > 
> > [    0.853375] rtc_cmos 00:03: RTC can wake from S4
> > [    0.854150] rtc_cmos 00:03: registered as rtc0
> > [    0.854694] rtc_cmos 00:03: setting system clock to 2023-02-14T19:44:16 UTC (1676403856)
> > [    0.855555] list_add double add: new=ffff90df87f15810, prev=ffff90df87f15810, next=ffff90df80145420.
> > [    0.856513] ------------[ cut here ]------------
> > [    0.857023] kernel BUG at lib/list_debug.c:33!
> > [    0.857519] invalid opcode: 0000 [#1] SMP NOPTI
> > [    0.858024] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.168-rc1+ #1
> > [    0.858713] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> > [    0.859562] RIP: 0010:__list_add_valid.cold+0x23/0x5b
> > [    0.860112] Code: 01 00 e9 5c c9 bb ff 48 c7 c7 e8 35 52 ac e8 94 10 ff ff 0f 0b 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 e8 36 52 ac e8 7d 10 ff ff <0f> 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 90 36 52 ac e8 66 10 ff
> > [    0.860502] RSP: 0018:ffffa8db40013a78 EFLAGS: 00010246
> > [    0.860502] RAX: 0000000000000058 RBX: ffff90dfefaf4c00 RCX: ffffffffac8b3648
> > [    0.860502] RDX: 0000000000000000 RSI: 00000000ffffefff RDI: 0000000000000246
> > [    0.860502] RBP: ffff90df87f15808 R08: 0000000000000000 R09: ffffa8db400138a0
> > [    0.860502] R10: ffffa8db40013898 R11: ffffffffac8cb688 R12: ffff90df80145420
> > [    0.860502] R13: ffff90df87f15810 R14: ffff90df87f15810 R15: 0000000000000000
> > [    0.860502] FS:  0000000000000000(0000) GS:ffff90dffbc00000(0000) knlGS:0000000000000000
> > [    0.860502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.860502] CR2: 0000000000000000 CR3: 000000016ee0a000 CR4: 0000000000350ef0
> > [    0.860502] Call Trace:
> > [    0.860502]  kobject_add_internal+0x7e/0x2d0
> > [    0.860502]  ? rpm_idle+0x1d/0x310
> > [    0.860502]  kobject_add+0x7e/0xb0
> > [    0.860502]  ? _cond_resched+0x16/0x50
> > [    0.860502]  device_add+0x118/0x840
> > [    0.860502]  nvmem_register+0x547/0x720
> > [    0.860502]  ? nvmem_unregister+0x40/0x40
> > [    0.860502]  devm_nvmem_register+0x3b/0x80
> > [    0.860502]  rtc_nvmem_register+0x33/0xe0
> > [    0.860502]  cmos_do_probe+0x3cc/0x5d0
> > [    0.860502]  ? cmos_validate_alarm+0x1c0/0x1c0
> > [    0.860502]  ? rtc_handler+0xd0/0xd0
> > [    0.860502]  ? cmos_do_probe+0x5d0/0x5d0
> > [    0.860502]  pnp_device_probe+0xb3/0x150
> > [    0.860502]  really_probe+0x222/0x480
> > [    0.860502]  driver_probe_device+0xe5/0x150
> > [    0.860502]  device_driver_attach+0xa9/0xb0
> > [    0.860502]  __driver_attach+0xa7/0x150
> > [    0.860502]  ? device_driver_attach+0xb0/0xb0
> > [    0.860502]  bus_for_each_dev+0x78/0xc0
> > [    0.860502]  bus_add_driver+0x13a/0x200
> > [    0.860502]  driver_register+0x8b/0xe0
> > [    0.860502]  ? rtc_dev_init+0x34/0x34
> > [    0.860502]  cmos_init+0x13/0x74
> > [    0.860502]  do_one_initcall+0x44/0x1d0
> > [    0.860502]  kernel_init_freeable+0x21e/0x280
> > [    0.860502]  ? rest_init+0xb4/0xb4
> > [    0.860502]  kernel_init+0xa/0x10c
> > [    0.860502]  ret_from_fork+0x22/0x30
> > [    0.860502] Modules linked in:
> > [    0.881782] ---[ end trace 15ab58632cc3d5c4 ]---
> > [    0.882291] RIP: 0010:__list_add_valid.cold+0x23/0x5b
> > [    0.882839] Code: 01 00 e9 5c c9 bb ff 48 c7 c7 e8 35 52 ac e8 94 10 ff ff 0f 0b 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 e8 36 52 ac e8 7d 10 ff ff <0f> 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 90 36 52 ac e8 66 10 ff
> > [    0.884708] RSP: 0018:ffffa8db40013a78 EFLAGS: 00010246
> > [    0.885274] RAX: 0000000000000058 RBX: ffff90dfefaf4c00 RCX: ffffffffac8b3648
> > [    0.886021] RDX: 0000000000000000 RSI: 00000000ffffefff RDI: 0000000000000246
> > [    0.886767] RBP: ffff90df87f15808 R08: 0000000000000000 R09: ffffa8db400138a0
> > [    0.887518] R10: ffffa8db40013898 R11: ffffffffac8cb688 R12: ffff90df80145420
> > [    0.888266] R13: ffff90df87f15810 R14: ffff90df87f15810 R15: 0000000000000000
> > [    0.889454] FS:  0000000000000000(0000) GS:ffff90dffbc00000(0000) knlGS:0000000000000000
> > [    0.890295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.890916] CR2: 0000000000000000 CR3: 000000016ee0a000 CR4: 0000000000350ef0
> > [    0.891670] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> > [    0.892493] Kernel Offset: 0x2a400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [    0.893451] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---
> > 
> 
> This is caused by the bad nvmem patch in -rc1. -rc2 has the fix.

Confirmed; -rc3 boots fine.

For 5.10.168-rc3:

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Regards,
Salvatore
