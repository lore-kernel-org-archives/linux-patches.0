Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B431DFE7
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 07:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g/4EIAZ8"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2044ecf7035so138028fac.0
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 23:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704352549; x=1704957349; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2SmQScyvIuLdY3E1hFWKaRhiC86WTLlAjqHutwpfeQ=;
        b=g/4EIAZ8aG3N5qr1Zy2dwkI6wr+LlW4WOuySrrO8b/ZkfDWRIXti5QEvKj5gtwHEwR
         X/y0IBSspYxrdEwLDjgbi3+RyAJHaqDZvmZsw3dXHY405GVrLsLiiNYcl321uZel+Eo4
         G0U+8rBAUUpaAglxC+eQD9rC4vbpP0fBhNaaAd6nvr8qCsyhMlqgPotG3M0gzhDX4xxC
         G9lKiF3Glac/OIlvk3PZr6uyS6MkesU+7EZxvp25J0AvvIK7jdP+uShMPlnrtbHR3TEP
         b6Bpdrvcybs1CsTIt+LjiSVDTe3m/OAuwbYYRsMc289m2JC73PQILa80V28Zh6C0mvBt
         8auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704352549; x=1704957349;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X2SmQScyvIuLdY3E1hFWKaRhiC86WTLlAjqHutwpfeQ=;
        b=AkJBtiaunXE6cVarOB/VDt/ORp9NuiriQyj7zYw6wvQr7Wyy8+yh5f6QkUgcOqzRN0
         5uXIq5Is0WLdN5YWGTahaGCrLHjixZ2whwqgAR/0R6ts1A3bRDIpAEeeagS0EekgWJYi
         XHFqfaQb25pHSuF12gISst2h1dLoAf+AV+j1Mq/yWgd7pByobC7QAppJqyAECIJ0+J94
         BEB5vOcP7d6ZppEZ4rx9CxY6JvsXbFWdsd7BeYGnhni8bOSc6c9J9M93buCsN855G/+U
         XvCCS8dbudp9T452ZWsH4HR9pY+Vh+oyVgOI/10L91zNq09n+/jMtur3rOJ0mmOnwXn9
         dZyg==
X-Gm-Message-State: AOJu0YxCRJfsxXePZUe9pLxsFRnO0s0pyEuZs4PyqLuOMM1iJlnWLiWs
	GHKl1hN6d9ugnzvp9pkf108kSIzzco8k5w==
X-Google-Smtp-Source: AGHT+IFDtkmc/5Itm2/vrFUrhCZarPV/ONCswJm00ZQe5veImd2aILrozVH3VBmTM9uNWBifaFHrHA==
X-Received: by 2002:a05:6871:e410:b0:203:ef6e:2319 with SMTP id py16-20020a056871e41000b00203ef6e2319mr251670oac.10.1704352548337;
        Wed, 03 Jan 2024 23:15:48 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.99])
        by smtp.gmail.com with ESMTPSA id u11-20020a9d4d8b000000b006d9fb0458cdsm4542214otk.39.2024.01.03.23.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 23:15:48 -0800 (PST)
Message-ID: <32ebe3f1-49b7-4ad3-9ea5-ed2adbbd78da@linaro.org>
Date: Thu, 4 Jan 2024 01:15:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, leo@leolam.fr,
 johannes.berg@intel.com
References: <20240103164834.970234661@linuxfoundation.org>
 <99fe3993-51b5-4284-8a22-869764f393d8@linaro.org>
In-Reply-To: <99fe3993-51b5-4284-8a22-869764f393d8@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 03/01/24 10:10 p. m., Daniel Díaz wrote:
> Hello!
> 
> On 03/01/24 10:55 a. m., Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.10 release.
>> There are 49 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.10-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> We're seeing a build regression with x86/GCC-8 and allmodconfig:
> 
> -----8<-----
>    In file included from /builds/linux/include/linux/string.h:294,
>                     from /builds/linux/include/linux/bitmap.h:11,
>                     from /builds/linux/include/linux/cpumask.h:12,
>                     from /builds/linux/arch/x86/include/asm/paravirt.h:17,
>                     from /builds/linux/arch/x86/include/asm/cpuid.h:62,
>                     from /builds/linux/arch/x86/include/asm/processor.h:19,
>                     from /builds/linux/arch/x86/include/asm/cpufeature.h:5,
>                     from /builds/linux/arch/x86/include/asm/thread_info.h:53,
>                     from /builds/linux/include/linux/thread_info.h:60,
>                     from /builds/linux/include/linux/uio.h:9,
>                     from /builds/linux/include/linux/socket.h:8,
>                     from /builds/linux/include/uapi/linux/if.h:25,
>                     from /builds/linux/net/wireless/nl80211.c:11:
>    In function 'nl80211_set_cqm_rssi.isra.44',
>        inlined from 'nl80211_set_cqm' at /builds/linux/net/wireless/nl80211.c:13000:10:
>    /builds/linux/include/linux/fortify-string.h:57:29: error: '__builtin_memcpy' pointer overflow between offset 36 and size [-1, 9223372036854775807] [-Werror=array-bounds]
>     #define __underlying_memcpy __builtin_memcpy
>                                 ^
>    /builds/linux/include/linux/fortify-string.h:648:2: note: in expansion of macro '__underlying_memcpy'
>      __underlying_##op(p, q, __fortify_size);   \
>      ^~~~~~~~~~~~~
>    /builds/linux/include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
>     #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,   \
>                              ^~~~~~~~~~~~~~~~~~~~
>    /builds/linux/net/wireless/nl80211.c:12939:3: note: in expansion of macro 'memcpy'
>       memcpy(cqm_config->rssi_thresholds, thresholds,
>       ^~~~~~
>    cc1: all warnings being treated as errors
>    make[5]: *** [/builds/linux/scripts/Makefile.build:243: net/wireless/nl80211.o] Error 1
> ----->8-----
> 
> This is currently being bisected, so there is more to follow.

Bisection pointed to:

   commit 92045aab1bd9bfd73d816e907ea07739c4550b41
   Author: Johannes Berg <johannes.berg@intel.com>
   Date:   Sat Dec 16 05:47:15 2023 +0000

       wifi: cfg80211: fix CQM for non-range use
       
       commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.

Reverting that was not possible, so I reverted 47f3694a4259 first ("wifi: nl80211: fix deadlock in nl80211_set_cqm_rssi (6.6.x)"), but that was not enough. After reverting both 47f3694a4259 and 92045aab1bd9, the build passed again.

Reproducer:

   tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-8 --kconfig allmodconfig


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

