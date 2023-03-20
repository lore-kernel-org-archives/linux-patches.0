Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C9E4C6A
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 18:46:20 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id 31so244002qvc.1
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679337980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+RShZ8p+aI8MWYtzRRoHovg73jJS5tT17zWwyUiRKBg=;
        b=AdYh29yhxX2LnJVV4iSRS2+f790HSBw8GTy7h32d+XHzqyIPbUg4NzySglRKPi5sK2
         UE8LTjkPiak7/FYlibjUZTNyRH9Cv0EB37awpbklMRZMaIzovuouRNR52E/ilX7b9Hjv
         6jTTFK3ZR8z6RbOeLhlvDiLxjFuACy0Elc0hhBGUUQc12au0i8RNpezgg8+wTBEJIElh
         KFDkFTJX9K4qtvH461wlQ+b++gmTsq/dUYXbPC9kHUdzPnvK2+vJa3/GLumVkT7xRdpq
         w4CkiNrFuwwMM5BohoWTGQJzRwI/GSw358ZUPuhvBv9T0Rkj1VX0ftV4Yyl86mFjdjsn
         u6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RShZ8p+aI8MWYtzRRoHovg73jJS5tT17zWwyUiRKBg=;
        b=mJl57YeQMs9Ze4jNjfDENbQ9OeBWxPGLx4wwBYqaKy9hQnfjHVFc13riu+kYi2MEeR
         Znp/ptznhAkFLQNFPSbEFZMTMajOGOHHYJy9ZkCs3y6Hc2Xir+SKO8D9iNd06TXIBp6m
         9j2p292xsufxXKDwSpa1fevPP0PLrT97C7PYNUtayWR0f7zGky0f5aEcWClzXQnUt/db
         /PXYeQVT5VLdDChi3HjXgA4aQ2q+yBlzKF9MPW8yxNOuW4udG3SWi/IPbZ0XeyRqrbQq
         XonlkUETY6jXINymh/cWMr5KXSPdaiwOj/gt6YslkPKDndwabfdXBTVhl0X/bdGsO3l4
         5Hfg==
X-Gm-Message-State: AO0yUKVeQcIRI5CRMiiwGFLgv6PDOp/Sb2flB4GoT+puBlAxR7GQU2kN
	Fffd3IFGM6m4TvCy88yB41E=
X-Google-Smtp-Source: AK7set86mJscNIKpO56iUVpE2Bev9qfcrYuodovS1xmS18TZGQeLF3JW7KI+30VqIjREV4VGXJQzuw==
X-Received: by 2002:ad4:5fce:0:b0:56b:377e:88a7 with SMTP id jq14-20020ad45fce000000b0056b377e88a7mr60390492qvb.21.1679337979776;
        Mon, 20 Mar 2023 11:46:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o10-20020a05620a0d4a00b0074281812276sm1355188qkl.97.2023.03.20.11.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 11:46:19 -0700 (PDT)
Message-ID: <4cadd4de-3f4b-50ed-5bc7-c0ecfdfed668@gmail.com>
Date: Mon, 20 Mar 2023 11:46:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145430.861072439@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

