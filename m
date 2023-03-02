Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963EE5381
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:34:06 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id e13so4678327wro.10
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ep+S3pdxbMooIqcVhUAKETVhQpGPPtmS5sMfXUnAbNg=;
        b=b0no65LLKsRpUmmcmRl1u/JvAI7+XvzWtViUzj+AoA5pAT+4DwYqvQW/QKdECLi5FM
         B1QALlBl3KSRhE4SbQx16FNOdrhQ1KRt0aFlpTmfeZtxU7ZrL5q/JKiPA5dqB97VdYmt
         ExHiAFdIErMC4DzM+u+UP3/4474djemkmtQeNZeU6du56BR9wvW2oPkmNSX8zBtXsHw0
         XMS+lPza4/00prh44j/qwZRF43FIFkp97oPJlmGjDs+0wJbeTLxAmfpqGTitMPQ11mCZ
         /+TI9sXsxNRHfMfXk1d2NdmHM7EQXGJ4Y0/SjthwFKj5I0ynstUCAvvh5GD7QzFLL8fq
         bCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ep+S3pdxbMooIqcVhUAKETVhQpGPPtmS5sMfXUnAbNg=;
        b=by3RpzyuJHnFaZKHJlAobBQmLnU9JQwLbteZEd4ZeOfHGet9mv4GlqNvyDAcwRlzdJ
         rymOP7uReWKf0NPeZKqP39AFLYVaRLoIh/i5h2E676VdWQZt4fnMK3OTvzXxDfG3u2An
         Uq5HpeAOpR0sbrukykiEiAfuYmRDZeYVPQsW1Q+lWJPBawqXphfjq65B3/yjmMtEOGXK
         gqi5vH7lKc/kUxLe3w1F9brnSUkKVKNdiWgDhF5fax7fEmQE09waQD/EprI1KwCIEs2M
         y83sfh0vSv+9U1LQvDjoKwyaJQL4EtDGKHaJzYIQyAILylPmABRdXc9sAW5kmAc2rzvi
         AvTA==
X-Gm-Message-State: AO0yUKVa2cFdaRGzwZxv8DWs2YBUFHTNhAvdMpUkxsmq5S6p2f1aGIpe
	AKjs+tqyDd12xJY108dBkRg=
X-Google-Smtp-Source: AK7set+cyTQaoBhhaVcjFd4R5kFai5kVb6/v8uNSJ3IYQabfEdWwxGyhAGxeOhKWySIvuXOpeInPhw==
X-Received: by 2002:a05:6000:1b8f:b0:2cb:72c2:3d12 with SMTP id r15-20020a0560001b8f00b002cb72c23d12mr7254295wru.68.1677756844799;
        Thu, 02 Mar 2023 03:34:04 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d458a000000b002c559def236sm14735520wrq.57.2023.03.02.03.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:04 -0800 (PST)
Date: Thu, 2 Mar 2023 11:34:02 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <ZACJqpfGw1EleS/g@debian>
References: <20230301180652.316428563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:08:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
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
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2977
[2]. https://openqa.qa.codethink.co.uk/tests/2978


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
