Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9ABD509
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 18:18:45 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-13b23e29e36so3232221fac.8
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 11:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ft3GsmDHQiijtAgXFeKZ1FHd0R2eTHzEp0HfUcjSdV0=;
        b=CrJ0sen4en7UihQrzYnp7HiMgQeI5bm4cbFdXytRjD1hoYJpLaSObCuo07OO0cdYng
         3ollvA0sYMffet//jaysZNA00QeSOSOGb07OXjTys0fiooO7Kg3A1z40SKsT8Dh//oUE
         Jn6eb7c/P4CMrBsaFfd0tybt+8Lslypa05BY1zA/3FWTPbBOCOaoLvXiRHGCWMdoHkJz
         znkeL8KurHUaC2FBopuGZA4jcy+5q2NkZCCqSSnbJzS2sKUhB56N0ABXKnj0n2CIJLmw
         8MT0OTf7vE9R3niBBtGPdn4JOG9Co9+jgHFJEjYn7N3PhKgliLgDrdxd54LO345ZkAOY
         2LmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ft3GsmDHQiijtAgXFeKZ1FHd0R2eTHzEp0HfUcjSdV0=;
        b=Mi3JmWJk6tNqToZ517EBUca1NAg/l+AyxvIasHr/WjQ4GErO8QhA13w8i2ZLc5y34V
         M31h5YpJSvDaEGJSLhSoRBC9a3b5hLbcZoHRmlnNeEVQ7jBkO0tzim3dFGM8ydqW5iVu
         cskj6LxNbjke7DAop3nJh8e4+3B7yrRObRpZ9g6g9koqzRjwSkbGFBHSVVsqSSsfVJIW
         O7VfygLbWIHJmndL/bIEQAk+xdG7umB0PdJCq2vCDZo0WL85o7PdqXRyAP1Y2B+PCwYa
         HM5sCFMUVqNYnnczgWdt6L+3f15gwN9tU5MfVLlcgFSgHu+R9zdeYa+6Zv4vbX/dnPtW
         IISA==
X-Gm-Message-State: ACrzQf1HNazZ7hpgAi7eDrvufb9p5Xym8LohsRnUBLtYuAAy+hLIuKoJ
	N7ToIrBR5u/hz7YIITN3H7I=
X-Google-Smtp-Source: AMsMyM6r6WNeVGs7k+7AXoc8GPNNntZhYhBTanwDXW9sHPSF3iwAqQMDq55wUsp/p7hjY2QZq3aUvA==
X-Received: by 2002:a05:6870:c0d1:b0:13b:a5f:e17a with SMTP id e17-20020a056870c0d100b0013b0a5fe17amr6222481oad.274.1666894724885;
        Thu, 27 Oct 2022 11:18:44 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t23-20020a05680800d700b00359b83e3df1sm683336oic.9.2022.10.27.11.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 11:18:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>
Date: Thu, 27 Oct 2022 11:18:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net
References: <20221027165054.917467648@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
Building arm64:allmodconfig ... failed
--------------
Error log:
In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
drivers/cpufreq/tegra194-cpufreq.c:282:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/module.h:244:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |               ^~~~
include/linux/module.h:244:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:417:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
   417 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       | ^~~~~~~~~~~~~~~~~~~
include/linux/module.h:244:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
       |                     ^~~~~~
drivers/cpufreq/tegra194-cpufreq.c:282:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
       | ^~~~~~~~~~~~~~~~~~~
make[3]: [scripts/Makefile.build:289: drivers/cpufreq/tegra194-cpufreq.o] Error 1 (ignored)
ERROR: modpost: missing MODULE_LICENSE() in drivers/cpufreq/tegra194-cpufreq.o
make[2]: [scripts/Makefile.modpost:133: modules-only.symvers] Error 1 (ignored)

I don't know what exactly happened, but commit b281adc68db8 ("cpufreq:
tegra194: Fix module loading") introduces a second MODULE_DEVICE_TABLE
at the wrong location, causing the build failure.

Guenter

