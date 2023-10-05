Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C27182
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DH81lkzx"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-418148607c2so2226051cf.3
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 17:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696467115; x=1697071915; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KLPXdOdaVA9/J7ssR8/n0iS+S2k1cLUJViUKTVXnwcI=;
        b=DH81lkzxX0aNkoIFnfaqHxt3//ALX+09jAzVjkzYVkLHfU+37lUM+uM1yM1M5IeUje
         9FpMsiUqW/8bejPwKR7T/s/Mnzq0sYGJO/M3FVyqxcrve2HC7AQ7XF0aivb2S4ogFQL6
         JHM0nykmIOH28EGL6LUaBUuGRsX/V/emuuPIxarQ5IXDQOLeqIgQrdI6IqC+K4hX5XLj
         pBOrkDewfFWsUORY9j8ZKN1Gbeewxgin3xPoLP9KZqudwm3aZWcOXe9PAXslgsVU65P4
         StcdQ+ErfKSDJNnAXldznoLLuCBv4ZlssEBQ52+Bwdz7K30nw6SKFc+jHYR4r8HDOOKr
         d6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696467115; x=1697071915;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLPXdOdaVA9/J7ssR8/n0iS+S2k1cLUJViUKTVXnwcI=;
        b=rwEKn28d//Ig2+7PBUCj9MHtx6TCDcSjZ5OJlv9BEBgtTEH04AkE7ryXZGz+8ErBzw
         1/V64VlpJzVg12gM2Y90qRG4eE1j7z5r1BowtkYrg6LpwcdD6rLX5FQvOZWcp5EgdTan
         SRP3Wf5ImzJVUqvkA+3etjzektfRGc9rTb58N9rWpeZp6H3mN32w9gZkTQx3fAteNF5o
         olzgb7HV88gVl34LuIQX9TotvuyVmhxklcQYkI4rlMoQdWSjFcAtnkfb6UVt0DsMvaEL
         kFbVoDGTV+IOdwRO4d8MsPbbVjeC5hRF+XvB82+GcUm8mVPI0BiFtAS3UzBKwv5ijSAl
         Zs/w==
X-Gm-Message-State: AOJu0YytAXVHSdwRSokuFM/xdf+M40J2GWC913elHaFqwZQPfqTQ/aVt
	M5t1nDpIHq5vmfpSMQ8AIks=
X-Google-Smtp-Source: AGHT+IFP4b+dKlsWEeTs8JXEWgf/JYvo5OoPEGL7aICcyiCoBBFNzUD+oJgS3R4B+q78KlptTyWE+Q==
X-Received: by 2002:a05:622a:2c7:b0:417:ccef:7fd0 with SMTP id a7-20020a05622a02c700b00417ccef7fd0mr4019447qtx.22.1696467114759;
        Wed, 04 Oct 2023 17:51:54 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bp42-20020a05622a1baa00b004109086e54bsm137995qtb.38.2023.10.04.17.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 17:51:53 -0700 (PDT)
Message-ID: <d2b80a6d-63c8-46ec-bf0f-83217a7c517d@gmail.com>
Date: Wed, 4 Oct 2023 17:51:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Content-Language: en-US
To: Namhyung Kim <namhyung@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Ian Rogers <irogers@google.com>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231004175217.404851126@linuxfoundation.org>
 <f0115175-975e-4fde-aa69-666568ce5c6a@gmail.com>
 <CAM9d7chUnxjPdOwZZ0imYs+i8+dd9GL=O3gqJXzaRd1VGZJxBg@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <CAM9d7chUnxjPdOwZZ0imYs+i8+dd9GL=O3gqJXzaRd1VGZJxBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/4/2023 1:19 PM, Namhyung Kim wrote:
> Hello,
> 
> On Wed, Oct 4, 2023 at 12:33 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> +Namhyung, Ian,
>>
>> On 10/4/23 10:52, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.56 release.
>>> There are 259 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>        https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
>>> or in the git tree and branch at:
>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> perf fails to build with:
>>
>> fixdep: error opening depfile:
>> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/.pmu-events.o.d:
>> No such file or directory
>> make[5]: *** [pmu-events/Build:33:
>> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events.o]
>> Error 2
>> make[4]: *** [Makefile.perf:672:
>> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o]
>> Error 2
>> make[3]: *** [Makefile.perf:240: sub-make] Error 2
>> make[2]: *** [Makefile:70: all] Error 2
>> make[1]: *** [package/pkg-generic.mk:294:
>> /local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built]
>> Error 2
>> make: *** [Makefile:27: _all] Error 2
>>
>> due a80fd00cb1a7793ead4d7c3fa7d3f1e898231c27 ("perf build: Update build
>> rule for generated files"). Reverting that commit fixes the build for me
>> and then all is good in terms of testing.
> 
> I think it's ok to drop the patches if it's not applied
> cleanly.

AFAICT the patch applied cleanly. There was some bizarre interplay in 
stable kernels prior to < 6.1 as reported here:

https://lore.kernel.org/all/dcb9997a-2e8a-5eb2-7a34-f8af418d4bf1@gmail.com/
https://lore.kernel.org/all/6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.com/

Does this make sense to you that on 6.1 which does have Ian's commit 
00facc760903be6675870c2749e2cd72140e396e ("perf jevents: Switch build to 
use jevents.py") that we would still get this build error somehow?

Thanks
-- 
Florian
