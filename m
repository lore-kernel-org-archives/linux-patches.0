Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E562C4250C
	for <patches@lists.linux.dev>; Tue, 30 May 2023 18:31:49 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-256531ad335so2880940a91.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 11:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685471509; x=1688063509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KEW9iyPphTcnuNe1nVj+a43tMhSuae2gFfmByMfKsa8=;
        b=L+joybXijMGa4/e7fOk+a6C8lsbtQ++whH4ml6c9IAtiZfGctKxBof3xN9w5rrsnBo
         h9BqhpTCrWtwickmrQybCrQdTYN0YYxhFnM1jz5DMSYHJ49cK1l67XxGpQdsb5Kh8PD5
         +6gOQC1bx7JYXAmQBDKYjwRZ44B9ZHhnvKwG/lpFauSeq0sxhye4RwxMyp0L2HKbeKsa
         vGy7oYQx76IJ0pHNsHY+mYgLSJBCgvbGbAcgvbbtKt2UXwB/6oQHPqL3LT6+7Q7PJZ4+
         70ua2Pq0P3wOdjpTRB4Kgz9z9Xnkh3+7V4VrSIfqT016dbed3pS0zQ6E/YifkzSPvPKt
         Hrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471509; x=1688063509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEW9iyPphTcnuNe1nVj+a43tMhSuae2gFfmByMfKsa8=;
        b=QYwukHPKwsrXVJJGUxs/N41rQrG+XPtjAZ6EE+Kb9+LcTSyfILcdE7Ri/gWJpdYnOW
         siwOdf/UOG54eVfZSSrRJfE9ODVojZ65rYswNNnFJ4xsGZ4DplKR8D5e/zXRKi9f6A8g
         cIIalM3iB3urla4YF+n2hj4BZz8P+RgHxKkVIWdpycf6hS5UYVnop+Gf3Y3VPHdaT3Dx
         BqMgBdgzTdpmcuL/ZWr5eONQDgiVOlo2K6kLgtWXF52yyorwIEzwk0Yvaq4HZGmo5uMG
         f0GFe21tCfHYkPbUg+FwzR35+baugM/kOPkhS7uXU9s5OarHnw/syY6jnExq935WGRQl
         CXoQ==
X-Gm-Message-State: AC+VfDwAHp2dvb17fxZsCEamz478CD5cPVweNJCw82WSy77cZ2f+YTqe
	WbQMRM0Ouly7lSuunk8yqA4=
X-Google-Smtp-Source: ACHHUZ7n8ILu1TNR/dRxoHFEDmys9Q+z59wa0gH6crvvzA/gXuzt/1+r4IoY1+rxgRhJXQkVKnFdyg==
X-Received: by 2002:a17:90a:db02:b0:252:75ed:eff5 with SMTP id g2-20020a17090adb0200b0025275edeff5mr3255611pjv.30.1685471509220;
        Tue, 30 May 2023 11:31:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v4-20020a17090a458400b00246f9725ffcsm9101549pjg.33.2023.05.30.11.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:31:48 -0700 (PDT)
Message-ID: <26072357-9433-c94d-ef5c-96dba23ebaa9@gmail.com>
Date: Tue, 30 May 2023 11:31:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 000/211] 5.10.181-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230528190843.514829708@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/23 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.181 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

