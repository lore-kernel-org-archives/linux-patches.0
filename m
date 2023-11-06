Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5786E29420
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J77jXawA"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5b9390d6bd3so4530696a12.0
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699292279; x=1699897079; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JXl+Hk7DG0xQnZU4tGVI8tvUE8tmSEux9caPBMuGXfY=;
        b=J77jXawAXRq9V68pGfM2K5fuW2lQ4nAmzMgUL3Q26NUnnGmffmCUF642xjWwUDmzJP
         Ost5AgwYoD/o9BXxZLFGHnl4pNcuX7klMD8mQ9lJOIWuw/XKW0GYVDPK6M2w6pOWY4Tf
         ymmSgzw2MWOJ+3hHplV/zC0JLLSEifo4xOR4noB1nqM8orBG2SfVSccb/A6LJlZJNHI2
         7Jc3shdyy+FxL1aaUpuTfzzwgg/rpQTii5cY6jTe8Pmocgm9xezzT8hK5etjXMT/wVn5
         HcUp13BzgAPt5ggOXUTMRgFjei1eKXuu3ZQBEkj9YbHc7NNZWUZJjDuJZJPFecR4xRRc
         vHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699292279; x=1699897079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXl+Hk7DG0xQnZU4tGVI8tvUE8tmSEux9caPBMuGXfY=;
        b=aqemtfCOFAw8mpnJYNjaqq5J3i3pSbMgx7GaaAbHA+s8E8yLKHkM/uJpP2xs7k0Rws
         x7IKbZZm/CQesjXWueYW4dQGpXU9Ol+gdBfGe85NwurHuUITepniuvL2TlfnJPiGI7kk
         TObeM/wx10MEBvArgs1yjsbzAuEjpL94Q7WW0Ak6/thStbmwJM3cP91VLHo92CupXKTt
         h8w8BhNKyfancqa6YD19OcRwSXNG2Uau6Vnp1WaBiT3Ve7aYL5MW/C0nNvSZYi6IA8bJ
         a7GaVGnC3tMm6MKdEjsCqmjrMvMU6TLbuWjJoZq5PZ8iRhrH1r94gTO0koV7fTWFSQup
         BNCg==
X-Gm-Message-State: AOJu0YwD5CwvDU3hgrlhlJHQ/cHvB3rOACEzeKjf/Y/JFzFnq8sUkz0Y
	V6P+BBErtvovyOODwv6ih48=
X-Google-Smtp-Source: AGHT+IENG/NaqDAdFCQ9VnTFpP4G2Tf2g017TUG53McEQO60wF6u3aF8m5z8YVdFn8j4VyH1bHKp4g==
X-Received: by 2002:a17:90b:4c92:b0:277:68c3:64b9 with SMTP id my18-20020a17090b4c9200b0027768c364b9mr267730pjb.5.1699292279446;
        Mon, 06 Nov 2023 09:37:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d11-20020a63fd0b000000b005b82611378bsm60018pgh.52.2023.11.06.09.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:37:58 -0800 (PST)
Message-ID: <f643650a-d520-4789-b67c-4f8da46fee73@gmail.com>
Date: Mon, 6 Nov 2023 09:37:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231106130304.678610325@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/evlist.c: In function 'evlist__add_aux_dummy':
util/evlist.c:269:31: warning: implicit declaration of function 
'evlist__dummy_event'; did you mean 'evsel__is_dummy_event'? 
[-Wimplicit-function-declaration]
   269 |         struct evsel *evsel = evlist__dummy_event(evlist);
       |                               ^~~~~~~~~~~~~~~~~~~
       |                               evsel__is_dummy_event
util/evlist.c:269:31: warning: initialization of 'struct evsel *' from 
'int' makes pointer from integer without a cast [-Wint-conversion]

...

   LINK 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.3-0.2/bin/../lib/gcc/aarch64-unknown-linux-musl/12.3.0/../../../../aarch64-unknown-linux-musl/bin/ld: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf-in.o: 
in function `evlist__add_aux_dummy':
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/evlist.c:269: 
undefined reference to `evlist__dummy_event'
collect2: error: ld returned 1 exit status

-- 
Florian

