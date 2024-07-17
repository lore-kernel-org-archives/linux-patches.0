Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F1017F50E
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721231779; cv=none; b=bocm0gm9iX4Ml17xFy1UeoXr8QWQ/DzB28jy1X3QxJff21+hlnprzpMsqbWjACv+VFiJSqHyx9u8SI8tko65OoDblWEf07N8CczseU4nKJrvk92Hbbvg8AjrhvmaJu5WQUJJoFgfutxPB8vTOPIGWCMNvxFVvMvd+W2fg4lmRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721231779; c=relaxed/simple;
	bh=MYfrQa0fJbjSdtyT8Bj/AIXzLi4i6s15cEs3nXJYmV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GvlwEYyi3DWAfhSnRCBmso2hbb40mw5n+jeuaiKpVSYW5OGgfXKmnCmvty9UZV9zEXzbfQ56wh/EboOasHJHWz4p6hK3wytArol5j4yWeXsf8B9yQSQXV1XYvqGr72WB+/RvpvmMh9SzLQAYYEsZhzjbg1alFa3Zau+XXrgi7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJHBMe7s; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJHBMe7s"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-805f8db779cso5949639f.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721231776; x=1721836576; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rBZ9BCujXEeN5BS9JKY5AUjB0nzA3LUN+tDMe/EUrF0=;
        b=iJHBMe7sFgjdOxwRr5yd/nCP2I2vVeUqKTNY+iiwkrqW449nvaau2chiWWVZL/uDIw
         lIcVTHx9DXb2++Qp72x43Bsud+T0kpmkYd/Goa79htc2Msfbi0OoDkgYqKwmbWfhVCq7
         3gyn9Pj+DiSa3q8rLhKAGBv4M9vK7FuLXVGcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721231776; x=1721836576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rBZ9BCujXEeN5BS9JKY5AUjB0nzA3LUN+tDMe/EUrF0=;
        b=mP1n+UGBnzA9I7xs+0afQSlPUH4aXNaQ6C6UuAlaLxL3jLHSVOpRuql7HQevSvuhlv
         vYjOto+5/Zhvf44Xx3sx5Fu+MNTH0xntUsAK37dNUeQp2OZz5ySwSmkOaZkwhfXyNIB2
         L/Rrg27n0btMoTPQaf6pjq+lxAuMLGX9RMS5kZx4Ax/SClIYhXg/8X2eSXAXusOVZIGp
         1rpdRRp0zsb/w0asY4OHJkhvUdKaUJD5bDfd5ZS1ZdoLSeKZFa4/0E5fjEBy3nmaDBYl
         hFF2IHiqDmk4zoGJlXSxxpq3fNgIKRYnPgRC+5seDboGkUO8rWqPxZMpLdk/6c4Q+VHr
         hOlA==
X-Gm-Message-State: AOJu0YzfpSdxO6DNGqkiPbDnvg5qEUFIKwmN1M8RqQOE/D9ojqIqrs0o
	YCQRNv7rlUGd3POOu9DCS0SLny2cPVzHQnofQD61C9m/tv+PM3ugANKBu/N2fFI=
X-Google-Smtp-Source: AGHT+IHa28PHq5LEexpMkyLCGewC7gi/sDxdXohPWQKhTNOLWXTtYgg1+uKAhC4jTwveivoIK8rS9g==
X-Received: by 2002:a05:6602:5d1:b0:807:6708:e35b with SMTP id ca18e2360f4ac-8170d30bd82mr149299839f.0.1721231776310;
        Wed, 17 Jul 2024 08:56:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c210c22adcsm758244173.37.2024.07.17.08.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:56:15 -0700 (PDT)
Message-ID: <33fad97b-54e4-4c38-be9e-c9ad4b3deedd@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:56:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/78] 5.4.280-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc1.gz
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
