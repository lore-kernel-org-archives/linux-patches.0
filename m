Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D912FC43
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 23:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWbZBaNM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc3bb4c307so2224455ad.0
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 15:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700089967; x=1700694767; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8TzHkXurTXiuoLmd0INQVFVSX2Z2pNe+xxd8p54D+3E=;
        b=LWbZBaNMjAnY/6A+O3JtZzRTz3ofNEdeBBV2bfU6iBwwM8fQWqsQVmYPtdUpmGWNsB
         dUnPZ/3mIpQFnY15bUG/3zx0DbkV0N0MQ/7DbX80gREWVaFHd8z4fkIve+e+fpSsX5d3
         /huhQD9ZXdP0n/Zc+tVbLuv5ldWEpZDBH1mz/z7zRjYqYML+MSRr9bquq1wEQbg0pmh4
         UQYyN2QihuuvNX5gx+82QklVvPVXvSbSOGDqB2lJ1dh69f3FTd1bbxrZZTdUib8HO0/4
         usz1mmI3vznxUNH++gW92QiHPpZry5YKhFjt8liRh0c1teRY8Cfx+UnXEztnYTgTftlV
         xkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700089967; x=1700694767;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8TzHkXurTXiuoLmd0INQVFVSX2Z2pNe+xxd8p54D+3E=;
        b=rBFCv/mq1km21qnDM1D/dkwcqmcQ51COkFo2IrbYidyQeeat0rh18wRloyPEi5YMZy
         2UP3qFAulTtIg+FyPSV9MnIr6h7yO+Eglnt+/yr86/bZCfrBZMbo7KpilGgw1m4feTvm
         iTUR6mMuPgG7q3hOF1Fs8SV+z1x6pBNwXbRWLG0Lu0yDSA/QWzp9lEHbjm4qEMPcNpI4
         4nmps8GbnBi2xRN+x5afBzJvXGlJ9MWR2KgFggV9jlj9s5ebwdUVBj8+Dp8vPUkCooHi
         lDqFwkQki/PZxjCyq01rg7FjVwr6jcD6sSSGwyZ3D18k/5L9Swyb5avFhkGYV3An2NzR
         rAew==
X-Gm-Message-State: AOJu0Yy04EhN9rjNk6sp5JT5r1Jrkk9S7mjwvXyABLQOaWH4fwywEXO7
	XGGZJ+lgC5fdLh6wpfQ2Pz4=
X-Google-Smtp-Source: AGHT+IEWFvVqRwce+MLl9wrOrqSKPdP5sEXaSaCx9X50CKqft32/VVoyhKQ+r4kM4ynEObKGna+nRA==
X-Received: by 2002:a17:903:228f:b0:1cc:3fe1:f45e with SMTP id b15-20020a170903228f00b001cc3fe1f45emr8153767plh.27.1700089967204;
        Wed, 15 Nov 2023 15:12:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ja5-20020a170902efc500b001cc3a6813f8sm7945947plb.154.2023.11.15.15.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 15:12:46 -0800 (PST)
Message-ID: <4869f897-ecbb-4f5a-9f4a-8eb6102be34a@gmail.com>
Date: Wed, 15 Nov 2023 15:12:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/244] 5.15.139-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115203548.387164783@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 12:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.139 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 20:34:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.139-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same as with 5.15-rc and AFAIR the previous -rc cyle, we get perf build 
failures:

/local/stbopt_p/toolchains_303/stbgcc-12.3-0.2/bin/../lib/gcc/arm-unknown-linux-musleabihf/12.3.0/../../../../arm-unknown-linux-musleabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `evlist__add_aux_dummy':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evlist.c:266: 
undefined reference to `evlist__dummy_event'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:670: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1

same culprit: 21e98e11091bd6ef5e8e70650c6a52dee0e6c11f ("perf evlist: 
Add evlist__add_dummy_on_all_cpus()")
-- 
Florian

