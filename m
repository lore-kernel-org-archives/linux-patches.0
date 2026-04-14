Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC6F3F0758
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188615; cv=none; b=dM5qgv+hnUhnaRvXqBH2uHPWu6O3Th9j2fcve2eo6HG6VocajCICdMQlQ0pCqvGGB+iM/bPDdTrnBmufQbQOYI9OwD7HJ2LcAIpaULn4kWMi2FuP3f2IkThgL2fqzkJ8yUKOa5gI3/e6zaKllwKGSrrUAVHQHk0G4IxoXBU3ZkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188615; c=relaxed/simple;
	bh=l5bn1W/u+cU4A3aF1wl8yVgEDNPAMCw4MG1lEQEWRVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=obXs3agVpbQ+Sn/151PxQTExkbhIVliIF97u0riMtww2sSGOxD/F+IBsgejkwlRQ2zS52h4SZ7bbdUiG/J8TEVRhp/ARYepkncyquSmPEoRD0l93oHbzZWk9uhx/iPEwjY/MtjRTftPXPXVN4azx/8xjkNRwfZQ17rgdly9fI/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxaYFrsv; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxaYFrsv"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-40423dbe98bso2288977fac.2
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776188613; x=1776793413; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZBTnl1lp5ZydNmagsRng1mXgZMebui5mKrZOOiOEtIo=;
        b=BxaYFrsvXUrYJdQU5GhhKa5vcoxlKufDAHR8T/EhKNpa9jHOTBci12gmLBXZzTk19h
         5DeZyNxzP1FaH0WP9v1yPOselrYq0HzoEJQJYLDietM/y0L5lp8h7U6u813MW/z8K4gH
         YesjMO2kigqzjWl+loFIXQtnZ6IaCCIEAurmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188613; x=1776793413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBTnl1lp5ZydNmagsRng1mXgZMebui5mKrZOOiOEtIo=;
        b=dzjKFjwQdaxp2WFy7KrjhZH0o/SwdvSTfZiA5CayySoJngvlUecTzovuuoh2HP3j0E
         U6tHU9dvmOgPopWlDVYi7dU8laEJqpz8uGTLDaJYMe98YaHHW08hm5gurydiGLkpUDi9
         cGz3E5KRVp1KamD2hqF8lJLN1g7/UqUctrtYAuslBmrEmoFdSeMhhRMVN8bgwzz9g9Bx
         y4a8edRthehi7crKdAor8s26vpEv5LdRKmqjQWFjElpYUkGhmP6Kv7I6k86EKkcmI/ZD
         z2nklCn9EwLB4y1s/6AOq5ZbPamDHskqD46dkMnWkGpRSOaqbNCRcrRByaCdlCJQoHJP
         IauA==
X-Gm-Message-State: AOJu0YwFButvhLuPqaf0XQUnBcVHG3t2p+qmDizw7pat/bNRRWIy6mR5
	oI3ySandSTaTVgND7lDJi9hfg8g7yLJZXXTQAAXk1hxOOP00ZRni6gkU0HWtguCZek8=
X-Gm-Gg: AeBDietTGTB3r5l5YI8hyuxpz16oPQhkDGEWVYQGLoaGeJiP9AWtPHD4ian6uQC4cAA
	pnBP4cEn3MJ4ys9I0EEJU6J9G067LKV/k/cG8D0q//OeypT8jI8hrn5OfMVEy9kEDo01ujmqZvX
	JquHK+9jQ6LNRXrouxahJfTJbPaZ2NKZ1xKttx8u4z4lJ0yJQ4SIX/sdNblIe5BolNAxiU+y3Jb
	6Oo1rxG6woGpWw2mFegDGaMP05BV/10YghIRSoOn5WEDpqtb+CFr5uTvkiZy0UwjuYA0NoJcW8T
	CzDGh1t/0Pa87KlTccdm03/0QnygIUmsS2Xbav7yBVGJkrpLULVm73VgJu88c/zBmCkDB0TuAmu
	PN0swYrUWna6uE4ddiC8PQjRnvRuG9OFWckptcyP+xIMBFiQedxEtNnnX9vddVk4P/ySmp7MbTa
	mvJQM9JEAAd+TKcCnKS59wqq9Ldrhn7fI=
X-Received: by 2002:a05:6820:1986:b0:68c:1689:697d with SMTP id 006d021491bc7-68c16896cecmr9301885eaf.42.1776188613389;
        Tue, 14 Apr 2026 10:43:33 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423ddb23a9asm11674765fac.10.2026.04.14.10.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:43:32 -0700 (PDT)
Message-ID: <0ddad656-6cd6-4566-ae58-204471a9f7dd@linuxfoundation.org>
Date: Tue, 14 Apr 2026 11:43:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
