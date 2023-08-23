Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD4E7E2
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 00:49:57 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1bba48b0bd2so33870165ad.3
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 17:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692751797; x=1693356597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwKQQZjmpvwCc7+3qPK6l0MEjC1OGrKphiy40wLGUQM=;
        b=efFIrKCgCxm3PxjaPMDaWF2SLtMeoq/IeKmE+CdqcjGG4PiYou5I8RnKvWBsOPDCqZ
         NDysXF877DfGT2emsVhpv1fHAW26nVmdsPHarJTTRApW+ftScFw++2tkL85SLTwaCbT7
         MFLUMEZvFDPvGb/BIkVq/9ygi0Qt3gWu3XxWII26DiMXcc8DlpKIIo4Vz4D8RJkUtJJR
         PyGUmjRV5oU2VktQNyixUjmrbX4q73zROnG5hfjXVhjhGdwHUm7MtATIGmeLa1/LXECe
         q2CHInNlF6Whf7KTxrpPW2FAU9IxUulS/Xw3oL5MSIJo9KR2Y2IQKQ0X6F/MJyj1OO9z
         OgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692751797; x=1693356597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwKQQZjmpvwCc7+3qPK6l0MEjC1OGrKphiy40wLGUQM=;
        b=E4yB3sHOwCSPzd1Z3Uacqo/1WUfXIORupM6mNthagnB4i+6QTW4rIpy6UOiHgqk6F+
         N9tUti3gaFy63kMcclgDIL7yOpLjBDbhJCsk8KZmLEafhepNX/NZ4oRMRrbtV+Jr6+O3
         3pCiWeCT1FyMYqz+lRq/+6KjR2l+AsM1yS78A5rq1dg6xC9AwinXR4ow58A04A7qqfmz
         K9OS/8UFZoDLf4P33SMJC5BzGEOR+qA+6IKvYb58aXAXIRhcKkG4LQ3QKuKCgX3+caL9
         JgVT+w5DXvrgP/LrbKsbM2u7lOFOkZWKZxrJ2yDgmGP8lUqFtV4Zyi0zHUMsjHjyYnPO
         EmJA==
X-Gm-Message-State: AOJu0YyyATb49HVFLdjvmAwXx6ugLSI4ScpDPRpM2YIfwJnL0FZ//T1H
	iCPs2FDk5JJufIx0w/FTpoY=
X-Google-Smtp-Source: AGHT+IGg7Uqhbuss07EY3xzy+9AeCTRSSN7AcMVUWMoR4rxfLDp3u6ZvlucWPoVnqMsIO8J6MkW0hQ==
X-Received: by 2002:a17:902:b594:b0:1bc:9c49:f8bc with SMTP id a20-20020a170902b59400b001bc9c49f8bcmr8742401pls.8.1692751796711;
        Tue, 22 Aug 2023 17:49:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c15-20020a170903234f00b001bc676df6a9sm9599282plh.132.2023.08.22.17.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 17:49:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 22 Aug 2023 17:49:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
References: <20230821194122.695845670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>

On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 156 fail: 1
Failed builds:
	m68k:sun3_defconfig
Qemu test results:
	total: 521 pass: 519 fail: 2
Failed tests:
	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:f2fs
	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:f2fs

The m68k build failure is

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

I already have KALLSYMS_EXTRA_PASS=1 enabled, so that doesn't help.
Nothing to worry about. The f2fs crashes are still seen. They
also happen for other architectures, so it is not just an arm problem.
I'll probably just disable all f2fs testing going forward. If so I'll
send a note clarifying that the lack of reported test failures doesn't
mean that it works.

For x86 I get the same runtime warning as everyone else.

Guenter
