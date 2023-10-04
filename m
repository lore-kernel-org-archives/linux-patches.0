Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA511B29D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 19:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="feMI0Vzn"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3ae2ec1a222so124076b6e.2
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 12:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696447992; x=1697052792; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SemCWQzXcuF1OTgzS/LJmmq/aml5vJHjFSPL+GSAbeg=;
        b=feMI0Vzn7X7Xey0wC/lhVQHRrnU5gC6nFd8JbijWlnvRDSfFCUbAAlSLuF38CTQjvG
         mNot+tYzo0CPKlBkkBkEgxQStd/jigMmXEjq3JErQxA53oLyI1XUyN3GdKqYLLFHuURI
         pAJ8C499N68UOWdV/Dnug+ut50E59CbtKqQixw2+eF+O35T+VY7GWgkjAgKC7JNQOLdF
         FCh4SC7hHx9FmoGfdmwJ+XQSBbYOHjNYNU9itnWcLDQfpg6xl8ky9Vm/GcznQvkfVogW
         bIpNTishXI/7Oa+XyaOy7SwMcq5O4HpgVNlTS1LOSCi6AIFbBbbZpZNQ8plUU8FleJ7b
         Sk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696447992; x=1697052792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SemCWQzXcuF1OTgzS/LJmmq/aml5vJHjFSPL+GSAbeg=;
        b=wyzg0YbC9qifiiN428RCRF/ev1yoLc3h8rZUEauRj2LqPZpAoGslZDav6aev+VaJbz
         SU5gcNRQSYvj5PEfNc4d1ucF0PY19nZpUYYvCerfGhcQCkUFS3263dyL47AN9ILK9mGx
         10kkEBoW7JSZPEGOocO1khKYTf9YKTMZI7zpqqNSQKgSHrWClk07utfX7OcsOQ9O9n5Z
         MYDWaZuz0CWGZB7i+OkIC0E8Rig9zzT2KW3vEsBUZYIxBFKJ0c8Mmgm0YC2qjLPqOwMH
         Pdq+DZ2YAJInullAdhBJQIIzEZqHzFpZ2foXTEOAXj0rv1ZTpeUDtzYVbkC3v78kO3lt
         6mRg==
X-Gm-Message-State: AOJu0Yyt1kwfT/UFCy0SRAhC3vuxdMqzM61yaUb/mgPyPhbC9ugyoN9l
	T4571uZIkFHm2Up0bTXuo7g=
X-Google-Smtp-Source: AGHT+IEr82quBQXlc35fnQUjfi5Zei6SuX0j4dlPLgb+UF7tcqeF6Yik5FgXSIaDBuC6YBa8szmBKw==
X-Received: by 2002:a05:6808:1484:b0:3af:6c30:f206 with SMTP id e4-20020a056808148400b003af6c30f206mr4188489oiw.10.1696447991649;
        Wed, 04 Oct 2023 12:33:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b10-20020ac86bca000000b00417fa7d33dbsm1416420qtt.93.2023.10.04.12.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 12:33:11 -0700 (PDT)
Message-ID: <f0115175-975e-4fde-aa69-666568ce5c6a@gmail.com>
Date: Wed, 4 Oct 2023 12:33:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Namhyung Kim <namhyung@kernel.org>, Ian Rogers <irogers@google.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231004175217.404851126@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+Namhyung, Ian,

On 10/4/23 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

fixdep: error opening depfile: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/.pmu-events.o.d: 
No such file or directory
make[5]: *** [pmu-events/Build:33: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events.o] 
Error 2
make[4]: *** [Makefile.perf:672: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o] 
Error 2
make[3]: *** [Makefile.perf:240: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:27: _all] Error 2

due a80fd00cb1a7793ead4d7c3fa7d3f1e898231c27 ("perf build: Update build 
rule for generated files"). Reverting that commit fixes the build for me 
and then all is good in terms of testing.
-- 
Florian

