Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A433CCE4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 18:13:33 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-690f7bf73ddso59248b3a.2
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695233612; x=1695838412; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JfTC70wEujuVMb02KLAiMmYdtpGG/mauqfpeX7AFOaE=;
        b=XXP4XKVPXZg37monqlKZL+xWTGLZ+mu/4XonzXin2obtSj6LhhydhFqkgoX0C6m+tn
         Srop6syCQJ1CH5mNKr64Kw6ca0fRgJ19CkPslqz8PH2+iPljVQJsyMPRZvCpm7v7PTEH
         ON3cGhRAe9tOVDwngEJoBlRMMmwW53qYoLdNY+TVxDHykoMX0oAfyiHghnCvAqOIIy7y
         f6L5GFz8qUc0lKTgU/5JPyui47myWvEeF86w58ZGJ7a+OV8ujehmTTgv5ZXTzITYFLu6
         NDIh4nHK0ZFL0APAKAYkCwY28BbZMLYD5us8cwENz83aYzhJWJ60NOyZtO7vPkNTpWhF
         CdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695233612; x=1695838412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfTC70wEujuVMb02KLAiMmYdtpGG/mauqfpeX7AFOaE=;
        b=d77CaEOPAVbw/XoYVBF25Ar4WoUVn/za/es91EsCndRGKlEdwq2wI1RnWLhu0CsORG
         eiGNCiue3obgn18HXTDHSExuwrO0K2AAd8aOu1sgZkW+0uz+DbvdAKgrhOiMvB/b6etl
         Y+Y8xyoF7FwBg/PX9V8Vj55SwSAOCOZk0VF+i5d6DRB2Ls8wJPGDewNYSX9iNZyK1lgA
         9B2W0LkFswXcNjP7l7T+v7bKeSStNMzgxqhojDG0YDMiSQFPVtFhiHdL8YgprqoBr6U6
         he9wvO8wrwPIbh1MM5mkZnPl7e2U0xpBm9S00Iprdk4xHrebQKWJdqgmxDd9zMd3vbur
         969w==
X-Gm-Message-State: AOJu0Ywcx6uG+zupEp5j4JrGvX+n2sO+raqL3FS6u742p2bJYxE6238V
	1pE8ut0xM9EjErpGkRF6GyA=
X-Google-Smtp-Source: AGHT+IFdl3LgMneO+iO5MnNLX1meZYPYp5J5pSrzItpSbxObmpeDIvzHfi3EwkbtLZ8a46prLlb9Vw==
X-Received: by 2002:a05:6a21:4846:b0:15c:b7ba:9137 with SMTP id au6-20020a056a21484600b0015cb7ba9137mr3052327pzc.2.1695233612530;
        Wed, 20 Sep 2023 11:13:32 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n3-20020a63b443000000b00578b40a4903sm2535075pgu.22.2023.09.20.11.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 11:13:31 -0700 (PDT)
Message-ID: <dcb9997a-2e8a-5eb2-7a34-f8af418d4bf1@gmail.com>
Date: Wed, 20 Sep 2023 11:13:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 00/83] 5.10.196-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Namhyung Kim <namhyung@kernel.org>, Ian Rogers <rogers.email@gmail.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230920112826.634178162@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.196 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on ARM, ARM64 and MIPS with:

fixdep: error opening depfile: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/.pmu-events.o.d: 
No such file or directory
make[5]: *** [pmu-events/Build:33: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/pmu-events.o] 
Error 2
make[4]: *** [Makefile.perf:653: 
/local/users/fainelli/buildroot/output/bmips/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o] 
Error 2
make[3]: *** [Makefile.perf:229: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/bmips/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:27: _all] Error 2

this is caused by 653fc524e350b62479529140dc9abef05abbcc29 ("perf build: 
Update build rule for generated files"). Reverting that commit plus 
5804de1f2324ddcfe3f0b6ad58fcfe4d344e0471 ("perf jevents: Switch build to 
use jevents.py") gets us going again.
-- 
Florian

