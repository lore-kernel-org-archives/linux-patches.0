Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1656F158DD1
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734465664; cv=none; b=Ke189jWG23eDUBz/TSF52O/VTLpBXYXfOqyKQAbv7rQq608AKUvefgoI9x8pKBcslsuFBdjon89WX1bPuNMu3HoLt3+rRNsgoaFSKqef6gR0G2OkR4U3F66IsWDmdM+nu1kc1PGMjKoCZ57tPOFfZHcVjPdwNR0bgzLgifNd7LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734465664; c=relaxed/simple;
	bh=HMkJ4fMsVv7r/CWgPRS7Bm+bQe3rXt/McE263qqF/rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IzeaQMOHuLC3tkdPmm6HU41uZOktvssQCo+YqRBQhhSWxLhKt/GBRLpx14Y7OtxJdrmfiMon0vRghXZDiTDs0UElwqiUaIFG82Vzr2vx5QhzizC8saYYGqiJ+2LtxpfkcYqB6+pGu3PdU2aYI5ZODi0bgs0oJ67KsktGApRlt70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0vrazaP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0vrazaP"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-725c86bbae7so4917180b3a.3
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 12:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734465661; x=1735070461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=v8qQQWKPluifNb2nf93vDBlkdC3+xnnrtcJTnhZcfDc=;
        b=Y0vrazaPtRkBUXwoeDfHqmqRVBLYrBRCCiUDQqS0R/aywVw54+MAbLpyQk+U5b3scI
         tHqWvb0F1K+xNQvWxGCKGRIcX4r8qD0xpoVdphPGC5MZHNV8O/xym5aa09CuTqhcxpgw
         25vQ3cfJwLz+g2r1LtYF3jLtHyY33+dlcqo7dqh2A5MR0WhcQH4wm0ZyBxOT5UqIOF3w
         x5slWjYu7wFPPiIlJ5u2t8JLi2FrugZA6fFobiUVntksB5bQdU+uzJBJJrDYJsXUEWgz
         Bq0+hGNDl+jHJoKSGEAXN6XNdfehI5Po75nrYGWPaVYLR7dYj/59ao4OCFJCshil8KW8
         Nasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734465661; x=1735070461;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8qQQWKPluifNb2nf93vDBlkdC3+xnnrtcJTnhZcfDc=;
        b=b4KvZU3mEEG2OaRGuqhx4plTBDtu2PNAF4voM6Q+FJNJXv7oS09hSrrIDeyUBZnA9+
         jXPXP3qnb9NsTGZIew8HS49AKXHfnDeUpXXfQYVlFEpWsIgY8X3zwNsSaA8esIHc+zzC
         gykLfnjD0XSM0NeBTdIqyhluBoEx7JCozMcHzqn12dV6iLSCueHVLX3G45d1i8t/kwpW
         QU58sJaAIYDgj1RkJ8GQiOwJI6n03L5pdlzegJquQmoVC2XWH05dHaLGOCJGA7Oy+/w9
         ftwOybORthLETWPA5viOf15LRegd6ZGSuq8cDqMuv10gSbru+AhhY1DRz1aYsRoP8YoC
         SyzQ==
X-Gm-Message-State: AOJu0Yw/VQdObiyMLldpwqaDL46poIMXSsH3CIPL8CBcS6FyEfnWgebx
	rzB95IQcAcjlmTWGUs6mwXQ/KoAuLzKOWNUhLWGKYL2gJN+TTFRa
X-Gm-Gg: ASbGncs5WusZ+i4kK1myxWRRPz2cm7tdBYJcfcI64gtLCo8oUJkeB9E2rsH6Z8cYVBw
	2rlLrmqEy8lSmRnSNM1s/W8tW4xHHxJbpE1+1AX0L3MZR9tlfDLYT3x4pEXfpY8fj4g0VtKHatp
	fqHaRGRhM4jjNN+Y0G99htQUvvidxpsnqiwcrNdfs9CuSH1fJI9/Hmi7DOP/wgOe0cfaSjOTU9p
	gjK7U7todNL82DdqMQH/alHNc+uyxMYX+h7k+kV7VnCxaa3phqgblBOR1ZA213knRnyArMM8DZO
	NP3+BvZK
X-Google-Smtp-Source: AGHT+IF3F89YGDK686ZzFCeyUwnyfwy6a803+8VqRR6DYv06k7N1sU73s8QDJ3raSbz3dCuD5iHzEQ==
X-Received: by 2002:a05:6a20:7349:b0:1e0:cc8c:acc4 with SMTP id adf61e73a8af0-1e5b48a310bmr439556637.37.1734465661193;
        Tue, 17 Dec 2024 12:01:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5addbf9sm6187306a12.47.2024.12.17.12.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 12:01:00 -0800 (PST)
Message-ID: <6c36f396-fb6c-4cbe-86e2-39b3ce85ffd3@gmail.com>
Date: Tue, 17 Dec 2024 12:00:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170533.329523616@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

evlist.c: In function '__perf_evlist__propagate_maps':
evlist.c:55:21: error: implicit declaration of function 
'perf_cpu_map__is_empty'; did you mean 'perf_cpu_map__empty'? 
[-Werror=implicit-function-declaration]
    55 |                 if (perf_cpu_map__is_empty(evsel->cpus)) {
       |                     ^~~~~~~~~~~~~~~~~~~~~~
       |                     perf_cpu_map__empty
evlist.c:55:21: error: nested extern declaration of 
'perf_cpu_map__is_empty' [-Werror=nested-externs]
cc1: all warnings being treated as errors
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:98: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/libperf/evlist.o] 
Error 1

this is caused by 74d444cca1eb616912c3ffe4b8a060a7bb192618 ("libperf: 
evlist: Fix --cpu argument on hybrid platform")
--
Florian
