Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D907718639
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 18:47:20 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1c5c91bec75so764915ad.3
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695235640; x=1695840440; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SaVRK/lPynvBxRFJJkTvRp0hGVnM5KbkWZipq2rlvU=;
        b=I0LKmr69JTIkzhgXtdpoNcXVaoEqWQgPpejvHbZFqkhYcWKUsDBDiupw3QcnzrgXQW
         NtI7Iez9ome3eELIGl1hT13tXAPkTvsaTDi/QNRtD2o4N3Ikze50WQ/XuRHwR2mPOExv
         0W1r0reUBzaUBxfsR5bfWFFr858T/mHVBy/jlwCFAPZKB2cQkvtDe7bPAvHNi6S3diGL
         DAPueyTTLS3Yd3RkZVCvW47Bb09j0yb5t5OcS8EaX1vn5rWqTNshaUAOiDAjtSKRgCVV
         jxUh2fc5mGNNBQvDoBTHbm4GtnqARXD5VeDfqAqfEQY4FE6X0tEeBjHtSWjMjXGGwXjm
         zYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695235640; x=1695840440;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8SaVRK/lPynvBxRFJJkTvRp0hGVnM5KbkWZipq2rlvU=;
        b=aqPW3Cs9CwDKgRLdMwL+2d2IPqqXswbbEn7pzT3JFphUELTWhIp4aSn2lvMIzYh8mW
         wa/B8jj1VjALo8OWTYw3lq2D4ihDWAnUKnfsym53AZQdabK791jsAYP07g6Ra8dSvJqr
         1uUhuA9WfSYB3b5WVRc7iqyBOg8Iv/2y/Blf6moasAP1o1XbAHlS349vr+7pWZIiiHJ9
         9/iNPuB6xfbrLJUUySFhVE9ffnTXGuQEE+zgldNLd2mQdl1D+LzfBSODyil38n749Pde
         X9J+g2zQ8r+k7/KiLpsZe5jL2ErS1RpdWOJa6HhxGMxUo6CbVUFcV8QQhr7jxuHbJlN5
         FUBQ==
X-Gm-Message-State: AOJu0YzB/Sv1ruxCljM9Wh5zzN6w37eNfkQb+8h/71TuSPrwaM8X/RRt
	HWgKXTkxuykvxoXnbtYFXls=
X-Google-Smtp-Source: AGHT+IHjAbtg/h7MbmZZiS0CzKY3Z8Qu5VW1pvq9abPt/lEehglQL0uhFnj0A1BpzRFtTgM2VsYhZQ==
X-Received: by 2002:a17:903:41c7:b0:1bb:d280:5e0b with SMTP id u7-20020a17090341c700b001bbd2805e0bmr4141314ple.18.1695235640001;
        Wed, 20 Sep 2023 11:47:20 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g4-20020a170902740400b001bc18e579aesm12185668pll.101.2023.09.20.11.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 11:47:19 -0700 (PDT)
Message-ID: <6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.com>
Date: Wed, 20 Sep 2023 11:47:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230920112830.377666128@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same thing as with 5.10 on ARM, ARM64 and MIPS:

   CC 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/pmu-events.o
fixdep: error opening depfile: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/.pmu-events.o.d: 
No such file or directory
make[5]: *** [pmu-events/Build:33: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/pmu-events.o] 
Error 2
make[4]: *** [Makefile.perf:668: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o] 
Error 2
make[3]: *** [Makefile.perf:238: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/bmips/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:27: _all] Error 2

reverting 95466975f143df7423bbf4905348c7b6260f4d29 ("perf build: Update 
build rule for generated files") and 
12ff96780ebd93d1aacb396994e3a32b50dccecf ("perf jevents: Switch build to 
use jevents.py") gets us going again.
-- 
Florian

