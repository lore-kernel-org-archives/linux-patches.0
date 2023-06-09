Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F81408C0
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 18:42:37 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-652d1d3e040so1703768b3a.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 11:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686336157; x=1688928157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pEF17blG1HpNLnd1VQwJnQONyB72caC9miz5H/8JZIs=;
        b=Pjh9KSMIMB74rYByeSQemLQ4hA6z+9/fP5Z3uGHIOI6xHmw3GUT2NUtpkVzaNED7tT
         SAoiPDl1u8QzvEJKBAez9VQU2nWyqxViCNDUuqPO4Zkl5C7ceURkq7Mvegp6Num1PUMx
         S2gmaj7x/mmOXVotYfH5KZ0Ko6bDOO9txTPiOhEGh1sY65cZmbGF2S00nhNSOgWk4L6Z
         GFfRRU6VrkkyUba3S3lF6xMMuqV+I232U5kN9SM7AyxsqnF2du1QH0ynv+UdL+pOU21I
         +eXA4dPPPqrgXqcCMmPmHp2WiTlP1roQlG9K/pMQvh1bfaupfudfrTRnkjh4ibU4Yhvx
         qtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686336157; x=1688928157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pEF17blG1HpNLnd1VQwJnQONyB72caC9miz5H/8JZIs=;
        b=HXE7MIsv3pdv5UrpoH2GAD42isBT0da91lCSCit5v347JLQ6eonobCBQJWv1V1YaRS
         /+J1OzV+FzTw+zcTmJ3TKS/P+KPKebgt1mHMybjg8lOzbOmq81EMn9PpTlhxqMZT4/ki
         q7CObFlNi5pp4GceLT1l18l4EaEkv55r/RZkfTq7XFAtjZBebaTdire53a9exxpnIvUJ
         rDMEc6afoSrftQuLqyyjdbfwNhoen1UmKxuKLC7jk33t+mZdtwcobQ+j5td4WALWdRtG
         TyLNjllNTB7JJEe9AFmNAd4PEWX/fn8UlTxGHH18+hVh7aqGpQCXJX9A0HWzlVF//KpG
         MofA==
X-Gm-Message-State: AC+VfDz7DxRTsRSYvWVT4OtfNw//vOdYk3wFAgcr4qK74Tg0RI3c2X/u
	CXgrvJsJbIaAW2PYfmwqW6I=
X-Google-Smtp-Source: ACHHUZ6iEgipL33n3ih3zruF3rlNZa5ojmGPQ4pzKRTEoboB2T+j4WNqhl3Bg9qVqBph8lmlIg/Vkw==
X-Received: by 2002:a05:6a20:4303:b0:105:63b0:5bf8 with SMTP id h3-20020a056a20430300b0010563b05bf8mr1993249pzk.18.1686336157243;
        Fri, 09 Jun 2023 11:42:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 13-20020aa7924d000000b0064d74808738sm2936320pfp.214.2023.06.09.11.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:42:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 9 Jun 2023 11:42:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Thomas Gleixner <tglx@linutronix.de>,
	Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
References: <20230607200903.652580797@linuxfoundation.org>
 <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>

Hi,

On Fri, Jun 09, 2023 at 04:07:00AM -0700, Guenter Roeck wrote:
> On Wed, Jun 07, 2023 at 10:15:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.116 release.
> > There are 159 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 499 pass: 498 fail: 1
> Failed tests:
> 	arm:kudo-bmc:multi_v7_defconfig:npcm:usb0.1:nuvoton-npcm730-kudo:rootfs
> 
> The test failure is spurious and not new. I observe it randomly on
> multi_v7_defconfig builds, primarily on npcm platforms. There is no error
> message, just a stalled boot. I have been trying to bisect for a while,
> but I have not been successful so far. No immediate concern; I just wanted
> to mention it in case someone else hits the same or a similar problem.
> 

I managed to revise my bisect script sufficiently enough to get reliable
results. It looks like the culprit is commit 503e554782c9 (" debugobject:
Ensure pool refill (again)"); see bisect log below. Bisect on four
different systems all have the same result. After reverting this patch,
I do not see the problem anymore (again, confirmed on four different
systems). If anyone has an idea how to debug this, please let me know.
I'll be happy to give it a try.

Thanks,
Guenter

---
# bad: [7349e40704a0209a2af8b37fa876322209de9684] Linux 5.15.116
# good: [d214f240b0f61480f9dbc4384cef03f6a55e5d03] Linux 5.15.100
git bisect start 'HEAD' 'v5.15.100'
# good: [11c58a0c1937c157dbdf82d5ab634d68c99f3098] x86/MCE/AMD: Use an u64 for bank_map
git bisect good 11c58a0c1937c157dbdf82d5ab634d68c99f3098
# bad: [e9c5fc4f3f35e769932158a7347ec245be5cefb9] drm/amd/display: Use DC_LOG_DC in the trasform pixel function
git bisect bad e9c5fc4f3f35e769932158a7347ec245be5cefb9
# good: [3dc3a86b88bda88b4ac859b18559385f02932e78] SMB3: Close deferred file handles in case of handle lease break
git bisect good 3dc3a86b88bda88b4ac859b18559385f02932e78
# bad: [b13e20cc58e438b2d3473147329fe3fe80e3bc09] perf stat: Separate bperf from bpf_profiler
git bisect bad b13e20cc58e438b2d3473147329fe3fe80e3bc09
# bad: [43b2f7d690697182beed6f71aa57b7249d3cfc9c] ubifs: Fix memory leak in do_rename
git bisect bad 43b2f7d690697182beed6f71aa57b7249d3cfc9c
# good: [8444b46e163aa9559a0af0381a1d230ec4146eb2] mtd: core: fix nvmem error reporting
git bisect good 8444b46e163aa9559a0af0381a1d230ec4146eb2
# good: [f76fcb9d43ec014ac4a1bb983768696d5b032df9] dm flakey: fix a crash with invalid table line
git bisect good f76fcb9d43ec014ac4a1bb983768696d5b032df9
# bad: [aa6ff950f875ebc9a01dc53666a1af17004924ad] arm64: dts: qcom: sdm845: correct dynamic power coefficients - again
git bisect bad aa6ff950f875ebc9a01dc53666a1af17004924ad
# good: [06106efa20f74a14674ae53def7abaddd851f7e2] perf auxtrace: Fix address filter entire kernel size
git bisect good 06106efa20f74a14674ae53def7abaddd851f7e2
# bad: [503e554782c916aec553f790298564a530cf1778] debugobject: Ensure pool refill (again)
git bisect bad 503e554782c916aec553f790298564a530cf1778
# good: [6b84832966a094a1b8305b1a42a4f157a3121258] perf intel-pt: Fix CYC timestamps after standalone CBR
git bisect good 6b84832966a094a1b8305b1a42a4f157a3121258
# first bad commit: [503e554782c916aec553f790298564a530cf1778] debugobject: Ensure pool refill (again)
