Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B12066DE
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224438; cv=none; b=dIC+87GXOKUtPu9eNPQFatJgL/Tddjo/owiyDVOXIC/cKRbzfTHdDA974yc9W/iPmMYh9l3kSV+zSmDmqiAu41WSPosactRl8LNscfaRc323D6q2vg4HHQTbBFRlik3pZjC5w6cReR/5NnRc04rXT1YUFr/fS8ouz+/xL17Zhzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224438; c=relaxed/simple;
	bh=9uGR+HlNTOhrXA095hQNTm97hB/TKjBwj210dxqNyc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ghp1i6vwKPkuf93gZIxbjm8cESVQbwDiwgy56q0OuEN6PDyAwX8Gpv7QMZM3XGiMPzvMCYSzJvB7xfBy/QenqQSyJHpCCUZd2ivdgre7ecJUvNA/vw2ERvjRf6bqKrUNB0VJ+pQlVoOcmildmJtc42Yr18JS3A8SVOcSTl0cVcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvkvkdNv; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvkvkdNv"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d6d84923c8so232145ab.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224435; x=1744829235; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a31MfxrWak0Tuq7rl1lgBguffZPL2d36CVBR6DtahIk=;
        b=IvkvkdNv4sZLLewwxqQxv33sPFK+Ord7JN2rlQU4B8S2fJbhl1NwP1fN865kRdv5S7
         UCh9LsLP2vTIpcF10uQQMOfN3jYDiy2UEEDP9iPjLLiAxaQTy426ewJYyt3dhp9fQnLH
         odE94xwmGjtIjvU1HzIAbgqdDYoOeWkO/A+fI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224435; x=1744829235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a31MfxrWak0Tuq7rl1lgBguffZPL2d36CVBR6DtahIk=;
        b=AqlSLh5HjQ0r/p/v+plEsZ6KtgeO3Rrv1l/K3dc9/kN3WyAxuh8MTjU3nwg+iKZ8B5
         z4Iy1UBY/sl32JnfzlLxXLee2oTKHunoINeWbcgs7VTjjU0g63z4YrKf9SjCXRRdYBkU
         kNBBZ4X9iOsqqqKikPdbFcTojik13Tv45/8wXmArT8XOnFb47X+JZ7tkRGv+zUUaFZFI
         5cdS8ZleXNj3giA4F0L0r97De/+JZSMNSXR53/Eop21/Uw6SNVTHLvQx305+++7odznw
         vQwFD8qUJdizFp/ujqR4se4cEEluiBA8qs2aMU6xgXy77/DGyRVmPoRrU72b33S69PvB
         bKDQ==
X-Gm-Message-State: AOJu0YyUaS14I1KEdpXc1JsVOuhB8RTDSTH1VM/YxeaF7Ft/9GVBenhl
	zIst+FaTfesSA+/mTeyuhNKXNa16haeQ+Vdll9idyApdLT3J3zm6Ocyj7seIGOk=
X-Gm-Gg: ASbGnct4HVs33U5zYujDrMr/vAlvf1/yozXStjNDvtHn0m7VLC02HylD3XI/x+XvBv0
	uAAaOky8odO3bWgzTYLr9/xDHHnF/uQwmDBLXAmxOJlSa1lM3mhSqREh1tNDN1J+77N8ASri1nW
	cug3YdTgDpDG1XCXHzOsURLqyknEIl7iVDphq1jzKOgIy5Xr4YIx8mmV3po8q6svWp9Z2l+bjeX
	uSQm/PoUubrZ7e58HOYkvCe/20eUm5eSkauy1/jE8DN9zS+Se00yJLZD0YhzgFSTYSEQjk5fDe6
	TIBi9dgssaJtDHzZtjYkWrEf6WlCBIiK8PG9EiNc/rbFHIFED94=
X-Google-Smtp-Source: AGHT+IE1GYrAa2BVgNVP9u5xF/JM4y9iYhKK1RMzet910nVc/m6SR/0Qfa9Lmpa3lh20JCyNmvbQxA==
X-Received: by 2002:a05:6e02:2281:b0:3d3:dece:3dab with SMTP id e9e14a558f8ab-3d7e46e42d0mr2327065ab.1.1744224435402;
        Wed, 09 Apr 2025 11:47:15 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc5828cesm3913995ab.47.2025.04.09.11.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:47:15 -0700 (PDT)
Message-ID: <2dee54f1-e333-4466-beff-c4b202c9644d@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:47:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250408154121.378213016@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 09:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
