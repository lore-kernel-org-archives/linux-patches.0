Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BB6179950
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722012024; cv=none; b=khe1ezgy1LMWgu4bcv7AJ91srYEfSsnHXIoL07TiMeBoU7Fja2PGh54j2T2WZQkf4xwiK+dlNmsbNaw6r3YVnUKJuu6pCFKyAhmwKekYn0hqShWv/Z+WQYJYRAMr5+4yR5YRKSICEbm65/S38/hxA/feN+ESEyEwT2uA7Mbnkh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722012024; c=relaxed/simple;
	bh=YFkHJmgMoHj+m0y0ahZe+tVJx9yx6DTmVWfvugjJLTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZtXvK77HsZ3FGTommhrpFPN6mr3QVdOj/hWxzE+pvbw/g5MTgNiZZVmfZaJmywL0A+AnSdCRanc6Vjbg1FMXbgSGjnJ1oF0xl12jukBe8zrQY/tkTy8TXSzv/rWmnDB7FoLZXRkgDT8GGfUAgn3MLFIrmNQc4iiQfgArsdD9G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqI86cMR; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqI86cMR"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7f906800b4cso9212739f.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722012022; x=1722616822; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qdeqIp1amBwYh9X1rRkUL9HFaDcjtUcMUkWTNmSG1HQ=;
        b=gqI86cMRoOiXrv9LjepWozgvgBJLPmWkeCsKq8855yaQMkYXlXIUlQyL1JjdCfzr+9
         sG1st2Ip5ecUIcmog4JOT+uNtJ18RjVc6Cty11P0iZ3fjSnUVTGs7gsKoxeCORM5OdnO
         RmPrR3gubadHg64lRY0LueFdRCgVsA94eDMv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722012022; x=1722616822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdeqIp1amBwYh9X1rRkUL9HFaDcjtUcMUkWTNmSG1HQ=;
        b=SyjG3Gk65ORawrbnjYUmj4rUW8cSrPLPZ1PnHWxuSOjRYO9KGY4XSOmtNMYQ68f3hE
         HVyXaYwC4VSb/bdxaDzRF7Y+ur7mjoB1Kblnhy6pdff0knK6WS37+E8U5TAB0R5AO+M9
         FNEnVMkpS7fGp2IEsdGS+nRQu9fIpxfp5crYWP9cOeNDLK1geVgJ3vL69jzvBymw5BId
         qUKzJhVOYgVCfBZIyltGGahZk2sRgDMf3W2bShyjLEFuC3FXDcbEzHtQlaUnqrxLU3ek
         B2MwpfKReqCxaP5BFFsBv4aKEZT7885c/BP1WVjqXBIX5SpGkzxczvduZImU+lbHP9Xa
         y2EQ==
X-Gm-Message-State: AOJu0Yz3lIAdu1p2YpdmCBIJ2LIDXjK8Iwz/6APNqdmxvJdbT8mhAin1
	BrTQkEvXOnJ3I8FGrhlG4pMyuoKX2mnBsTEOcrOs/l5rFsHALUIoeCOqaLdUOmA=
X-Google-Smtp-Source: AGHT+IEVTuMiNnfHYyl+FJNl81Dbpul+4YdQEdWL60VJeEzpubbsWkDjTyXJMssUsftU8oZSnDHKrg==
X-Received: by 2002:a05:6e02:1aa4:b0:396:94f3:a9de with SMTP id e9e14a558f8ab-39a22d465d2mr48021365ab.5.1722012021928;
        Fri, 26 Jul 2024 09:40:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a22e976besm15575205ab.31.2024.07.26.09.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:40:21 -0700 (PDT)
Message-ID: <642ef95a-62bf-4a4e-922d-91249d3b8ddb@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:40:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/43] 5.4.281-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.281-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
