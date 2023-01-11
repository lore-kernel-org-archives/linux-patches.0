Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43390256E
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 12:59:00 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso8210470wms.0
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 04:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmMcIUft4WbYyd1YhRNwUDrox+14DCGIc71j97XsCZc=;
        b=jJYGjutRCIJ7bxY/mRz8HyQPYqMotaewXKqHE1baOqVh8HUMWW5gUwf1Kyz3EQLZo8
         cUsJsvYqNqVe9NsATCX8xtbRkLCRzI8lRmSLX7IOgAEChR2MSeLcsPtT2Yz9+Cjde4lZ
         Gkf5tt6R3QH+CbEJ8jHDC+pzRFP9L3ufPTUi+zSiQ4VOAbWgObw7hAkdU3HR8BMo5YqQ
         Rd29B7RQQAWOKgB3URL0/aWcC8WKZRtruDllMNbbUWGTNHNR0f0n2LBBteNDqduHT/e0
         S/i/7GmaakpvTofjUzy7w1ndeGBllLFrlpHPFS0Pofsuq1CoM3/jOfCw8z4YdwOpJr6E
         FDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmMcIUft4WbYyd1YhRNwUDrox+14DCGIc71j97XsCZc=;
        b=dZ+P0j6V8q21yIQK+BJcx4NhApfGKKMvcfPLTlhB4mEGwZCMTdZPSCGMM9pYSC/FUD
         JGoqWXgM1YxFBqzt4GucqstESJKuMaCGmBtDSFktmg2wb3ugdh2X9YWR96R1C5IHsQaa
         tNEIu/W5HOpQApsZSJ6kD8GbQFlCQ0TXSkTEPfBavcKfUU1I/Lrcj5EDVfLDx9CHMtjG
         ET+y3dbq76K7wvjXpze6iWBdnArqojbvHF/6UYek56JtiWAcKgUcdJ9qJ21YnIj93CLW
         HEEEmjvwIFfROLJnuqz7w+9dVED66Wlzhaf4RXZzsTYMrcIw1ubxSel3DAh22jul9REk
         YjKQ==
X-Gm-Message-State: AFqh2kqXWM3M8eFD+Dr5ttzSfK114VD08Lurxl0+RCclUYTvHNRZmxyq
	yYY2A72PjrmNYQokGIfNd20=
X-Google-Smtp-Source: AMrXdXve0ye9QtTUBMqF9HXnzpbarAwLO2ONitQ31GE8gMiYOnzrDPD95Gt5cJJ0b/L0iRueVm7Vrw==
X-Received: by 2002:a05:600c:3550:b0:3d9:ed30:6a73 with SMTP id i16-20020a05600c355000b003d9ed306a73mr9392280wmq.9.1673441938343;
        Wed, 11 Jan 2023 04:58:58 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id fc14-20020a05600c524e00b003a3442f1229sm26143990wmb.29.2023.01.11.04.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 04:58:58 -0800 (PST)
Date: Wed, 11 Jan 2023 12:58:56 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y76ykHsQcyusWNah@debian>
References: <20230110180018.288460217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>

Hi Greg,

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2609
[2]. https://openqa.qa.codethink.co.uk/tests/2610
[3]. https://openqa.qa.codethink.co.uk/tests/2613

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
