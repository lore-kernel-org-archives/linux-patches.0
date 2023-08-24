Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA010979
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:08:23 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1bf092a16c9so172415ad.0
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 08:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692889702; x=1693494502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEY3RKWdnw3zHmk1Y4mP82JEt/tjDoea5W8YztOyeHw=;
        b=OqscnWK/iN71B8aqV/S1gSoSBaakB0XKjG3SapdLFHmDaNy1pHSQpuaViCMTB0wXVp
         dSql06uupX5Hr1b+HaJNhUiMss0Z/LgoL3ugB5Z6p0fvPMjKoEkfzSyzlG3Sewt7z94N
         MoDGwZG7Ciulb2LvlWFDbmitVrGPuc6AHnNV1Z9G62ZzpJlcIKYUHK+o5KoNCfMc8pnD
         8rHBN8FjFYvepMqgYAQZFpimLjqTb3nqKcI57tMMVt7VoQ6utqdWUeiKERbWV/iAXwSV
         aSQeajGkF+uS4gURgOlUpEtmh6fXGvqP7lu5ny9RCbafoAm08/Qr9YQ8XzqacZXe00hL
         okQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692889702; x=1693494502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEY3RKWdnw3zHmk1Y4mP82JEt/tjDoea5W8YztOyeHw=;
        b=k+LJ3ZSH9Ydu8FIARRxdvman+S98Yz4+y/ytDwbncfv98upF7VyUKye5JzrBGbcDop
         OUINaGs2Y3cQvCg/r10/Q/qblrcf5XHfu+SJonfjiLUg7TqLFh57mmMfbIwxII/rroca
         wMmhb07XbZNeAk62vGtv8akdDjDetkuB2CI6LCH6XSuGH4JLmnqbCcsLBHuA5cGO/ySg
         eZz1tSblZR6kvkdVlWQXZOT+Im0e/BjPG+7z1xJkSMswT+oCV91TYpP0mvo8RlKmwEDp
         SDbMelMkEZ7HhzozIoBhF0Udi/1DlRo2mcU+G948S4NCTBGT52AMpmsi4D59n67y3qAf
         6XXw==
X-Gm-Message-State: AOJu0YxjNHixkTRD3JHwdmsQTYSeBwhuUAICc1RemVtY6pS2E9VZYs1H
	/iklHhfytidHib/7JRR/eXs=
X-Google-Smtp-Source: AGHT+IHhbz4OiENBQD9ho4jGvAcV3lWptJhsLXIcHHgF06ECT95G/qnXnkSBw6LrvjVJCggl6U5QSQ==
X-Received: by 2002:a17:903:41c1:b0:1b8:88c5:2d2f with SMTP id u1-20020a17090341c100b001b888c52d2fmr19471562ple.64.1692889702305;
        Thu, 24 Aug 2023 08:08:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902ea0200b001bc9bfaba3esm12900755plg.126.2023.08.24.08.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 08:08:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 24 Aug 2023 08:08:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <4b8fcb23-c5e3-4bf1-957f-f0cc717564be@roeck-us.net>
References: <20230821194122.695845670@linuxfoundation.org>
 <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
 <2023082309-veggie-unwoven-a7df@gregkh>
 <CA+G9fYvwxuVpSn24YvtdNXaofg2JtZDREatOpDsKTVJX+nFN3Q@mail.gmail.com>
 <2d8a5f48-6c50-4c12-8a3d-23e621c6b722@roeck-us.net>
 <2023082325-expansion-revoke-1f3a@gregkh>
 <2023082401-arrange-bulk-d42a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023082401-arrange-bulk-d42a@gregkh>

On Thu, Aug 24, 2023 at 03:35:55PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 23, 2023 at 05:50:42PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Aug 23, 2023 at 06:30:13AM -0700, Guenter Roeck wrote:
> > > On Wed, Aug 23, 2023 at 01:47:39PM +0530, Naresh Kamboju wrote:
> > > > On Wed, 23 Aug 2023 at 12:33, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Tue, Aug 22, 2023 at 05:49:54PM -0700, Guenter Roeck wrote:
> > > > > > On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 6.1.47 release.
> > > > > > > There are 194 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > >
> > > > > > > Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > > >
> > > > > >
> > > > > > Build results:
> > > > > >       total: 157 pass: 156 fail: 1
> > > > > > Failed builds:
> > > > > >       m68k:sun3_defconfig
> > > > > > Qemu test results:
> > > > > >       total: 521 pass: 519 fail: 2
> > > > > > Failed tests:
> > > > > >       arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:f2fs
> > > > > >       arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:f2fs
> > > > > >
> > > > > > The m68k build failure is
> > > > > >
> > > > > > Inconsistent kallsyms data
> > > > > > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > > > > >
> > > > > > I already have KALLSYMS_EXTRA_PASS=1 enabled, so that doesn't help.
> > > > > > Nothing to worry about. The f2fs crashes are still seen. They
> > > > > > also happen for other architectures, so it is not just an arm problem.
> > > > > > I'll probably just disable all f2fs testing going forward. If so I'll
> > > > > > send a note clarifying that the lack of reported test failures doesn't
> > > > > > mean that it works.
> > > > >
> > > > > I'll look into this later this week, next week to resolve the f2fs
> > > > > stuff.  I wanted to get to the other known bug fixes first.
> > > > >
> > > > > > For x86 I get the same runtime warning as everyone else.
> > > > >
> > > > > Yeah, this is troubling...
> > > > >
> > > > > Is it clang only?  I'll dig into this today...
> > > > 
> > > > It is seen with gcc-13 and clang-17 with few extra configs.
> > > > We are not booting defconfig.
> > > > 
> > > > The Kconfigs are enabled with KFENCE.
> > > > 
> > > I have KFENCE enabled as well, so it may well be that this triggers
> > > the warning. I don't see it in 6.4.y or upstream, though.
> > 
> > Ok, let me rip out all the x86 and objtool patches from this release,
> > get it out the door with the good things in there that everyone else
> > needs, and then we can focus on this mess...
> > 
> > Maybe I'll just backport _all_ objtool changes to sync things up better,
> > last time I tried that it was a maze of twisty passages, all coated in
> > assembly...
> 
> I got lost in the maze again today, ick.
> 
> Anyway, I give up.  I'm just going to push out a -rc1 with just these
> changes in it today, and if people are upset about the runtime warning,
> then they can provide a working backport of this objtool patch.
> 

Or maybe just revert all srso patches.

> Ideally, the CPU vendor who is causing this mess will do that, as it's
> their issue we are spending all of this time on, not Linux's issue.
> 
> Also, oddly, I can not reproduce this problem here on my hardware at
> all.  Maybe because it's an AMD processor?  If so, makes sense, as the
> SRSO issue is only for Intel chips.
> 

Apparently I am lost in the maze as well. I am quite sure that SRSO
only applies to AMD CPUs, and

arch/x86/Kconfig:config CPU_SRSO
arch/x86/Kconfig:         Enable the SRSO mitigation needed on AMD Zen1-4 machines.

seems to confirm that. What am I missing ? Do you mean the warning that
was supposed to be fixed with the objtool patch(es) is only seen on Intel
chips ?

Thanks,
Guenter
