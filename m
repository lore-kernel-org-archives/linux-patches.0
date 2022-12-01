Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8001116
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 11:14:31 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id q7so2132128wrr.8
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 03:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A05Qt4D9Ellap4EINVcsvsioMqjg/vGDGC8jqUvyTYI=;
        b=AQWKATtzvkMmlcaUcHY89svb5GQg/Bo1zBvsYa45AHCj48B/tFpDgSlo+I91PtmC7t
         EhV6Y9DSD0MLb10876JjHkfQ08r4CxqIk3/YQIpVQkY8RGK46iRcaw5uKvylXmPsPrn9
         yDjH91IoAMPfaQ0oUB3bfCSHvmQ8JsDrXs9qKiLahpCcZRvV+6bLlxB7dBvWGAuDgQj3
         ZpIlIO1L5ZSOnXJSPQmWw7rtiKkeu57nsckXW+k++GrRZyqLvjnF6jWngcNTxIS/6dOU
         ZN2KH2qsC1PLBf+z8t3fj5+jdZo6ys1tdG55AFkARWlm3KDjcj+GdxrKTlajdSCEfdeq
         zc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A05Qt4D9Ellap4EINVcsvsioMqjg/vGDGC8jqUvyTYI=;
        b=WKsYtSNVrEgdFKtpEF50iJn6ff0Crz/sdRBjRde99EmTMS9WZHpgX/XK7cQqQ8bBBg
         T4VOKDF8U0FsI+n4eo7xumY/VMqtmlPaTYuv2yTv5oI/YcdIzHqW4DvcpCZGNDoMDVRj
         wadj1RAMORe7nOkKG5TfQVSQXGFb2iyM9YfT0E2S3etXPx3vwE5r4B66WtwIJx2tJoeu
         fl69FZn7nWCqb7Q5LADhSwi2DAb4wjbXbAZbFN38cIOXTujm6Cuz9TY3IiPaipnTYvg9
         +k6ilV5ViO58JTArRUm3mKc0NhoKRVTltxV4I0A0+x8kr/5ucj1GJ8o7eBMvcsjf4qm2
         sjKQ==
X-Gm-Message-State: ANoB5plmDfT3HyWoiT7kNK8sPUiTvP/nJ6n/RfJmBC1eTBK54BXT25RC
	LSgmv3jlZ7NXbLewR7KE1Ss=
X-Google-Smtp-Source: AA0mqf5zuBJwalN4us6585M1gKgEw4ctUsFcPCOkqLCJtxSoxJB+9RJyvheYdkuPjjSO8icseiDkvg==
X-Received: by 2002:adf:fa12:0:b0:242:1c:7507 with SMTP id m18-20020adffa12000000b00242001c7507mr21499950wrr.42.1669893269226;
        Thu, 01 Dec 2022 03:14:29 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfbbd54178sm9184251wms.2.2022.12.01.03.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:14:28 -0800 (PST)
Date: Thu, 1 Dec 2022 11:14:27 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4iMk6i8pe1/9ke2@debian>
References: <20221130180544.105550592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>

Hi Greg,

On Wed, Nov 30, 2022 at 07:19:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
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
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2253
[2]. https://openqa.qa.codethink.co.uk/tests/2258

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
