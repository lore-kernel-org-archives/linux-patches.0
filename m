Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEF617FE2
	for <patches@lists.linux.dev>; Tue,  9 May 2023 15:12:39 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1962e7284baso789691fac.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 08:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683645158; x=1686237158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1hVbiWE7jH+RJ0JQHiLPh9PpS00FlJ+tj/knZ39wURc=;
        b=E7L2GPpWit9bG5gktvVxYP8tqvDcftdoXQ8qPBY2L/vlq+OipWPciPhXNrfx9VRnXV
         dVXPMWNpHXz4d+geX1OjmJhgmO0YNhCYlnTqiW/7kG7mtJTmmfnhB7/bPIJgq+I6bhHc
         7jD9k2F3OT3ukaRytOBMAIx6PnRt9mvh+uS733/uUFzp27a7Mvcv4nnl3ZdIRLRIKd0c
         Kl1UeSnK1keMbGE3838TRGpprsgVBLTD9jQLHMytmUsYxICObb/HGK2KbcPwn5PDqMx4
         18EehpdIdPlNIkmsWN2MxeBB3194G52ZqR2giPkTtfZqHluaqZ4G3O7UjwfNYiU6S4Wc
         CWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645158; x=1686237158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hVbiWE7jH+RJ0JQHiLPh9PpS00FlJ+tj/knZ39wURc=;
        b=HhbYvl8aked9DqOgO+NSABLWqj5onk0ov60MtyueFXELwfSavGpJkeLpXG2/NjHiIc
         BtME0mv0nydfy519PLLYugVkUkr2GejmZ/e3rSg1zihLDYWDVkTNPo/X9funfI18nb4I
         lqjWI7s/sy4S4oADaodWYUwI8KlhAQVsmu0U3LGDdupV9sb93lQ5WI1te/MfsHP+vpzc
         A7pWyyU7JXySgbSCJAgFkREwk6tj35kW8huQGyhheoA+036d6020HSGbF1+Vn1TKqf0O
         +xN9ugs4TlzI2K0OwwW2aF6Ei4NoeAhhl8l1dutuWW7xRTtHm5fYStntnssXLtqoYRXw
         MrAA==
X-Gm-Message-State: AC+VfDxR8QpHW+uxZ61cjw25Vpvz869Yaq12TPqy3erBfLKxHibmsN0p
	/s0B7XE2ARbMJTMn0//uwpYcXg==
X-Google-Smtp-Source: ACHHUZ4kq2RLG5HWWXgZdE+vA3TGRfraFmxIfCB5aoDxTXPOrdr3VVoTtCLYmDs1lzX8xI1NUD5OcA==
X-Received: by 2002:a05:6870:d2ac:b0:177:9040:d24b with SMTP id d44-20020a056870d2ac00b001779040d24bmr7924176oae.32.1683645158213;
        Tue, 09 May 2023 08:12:38 -0700 (PDT)
Received: from [192.168.2.16] ([107.152.39.94])
        by smtp.gmail.com with ESMTPSA id r5-20020a056870414500b0018e996a507esm6101486oad.31.2023.05.09.08.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 08:12:37 -0700 (PDT)
Message-ID: <863a112f-f4a4-d580-9687-f6214d555939@linaro.org>
Date: Tue, 9 May 2023 09:12:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230509030611.521807993@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 08/05/23 21:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 370 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

New warnings are introduced for Arm, PowerPC, RISC-V:

   /builds/linux/kernel/sched/debug.c: In function 'print_cfs_group_stats':
   /builds/linux/kernel/sched/debug.c:465:41: warning: unused variable 'stats' [-Wunused-variable]
                   struct sched_statistics *stats =  __schedstats_from_se(se);
                                            ^~~~~

These combinations fail:

arm      gcc-8     bcm2835_defconfig
arm      gcc-8     keystone_defconfig
arm      gcc-12    bcm2835_defconfig
arm      gcc-12    keystone_defconfig
arm      clang-16  bcm2835_defconfig
arm      clang-16  keystone_defconfig
powerpc  gcc-8     defconfig
powerpc  gcc-8     ppc6xx_defconfig
powerpc  gcc-12    defconfig
powerpc  gcc-12    ppc6xx_defconfig
powerpc  clang-16  defconfig
riscv    gcc-8     defconfig
riscv    gcc-12    defconfig
riscv    clang-16  defconfig


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

