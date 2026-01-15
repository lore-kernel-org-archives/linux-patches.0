Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299DE32C92B
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768517011; cv=none; b=t0W/gVRCep0nKlfPcwvh/GUxcgFZCxVIPzqQUHKDyqxV6ll502amR8I9DppKa3xqDcotufdOomEox7ZFtwD7eGBIkLUdQ8EDiuscK4Wdd2fPevM4psULfpVaEuiFsH2lHCqiqUNwLgIP7DC48e4RrVtsM4eyttGWcA51g+9Wfmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768517011; c=relaxed/simple;
	bh=MCDhR2w1d6r7sDjNpkR1URtOxNX6Pk/r8MfOlD0CjpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=il6gn/knLpuG1L7S6KzFES+n3CupbodshtXm/kBw8/egj5IUSjQ9Xwny0e7UxSG0o/7AOFPCT9EXojwbtEPacFwh0niEaL+PVyTfWXTORrITwOMu+wHkNjhRq0ZS4SodYsw8GZJZFazKJ/z7FXGPI5Uy9+nU+pvtYZO7lwz2MH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZsHqGom; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZsHqGom"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c889aba0dso880918b6e.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768517008; x=1769121808; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qyRs+d0Cf5Kw2rXB13ZsV9jwZ76UYEa/5ku5BYfGZvg=;
        b=cZsHqGomk/Zb7WlaXDsjDHdZjkSKttvdstPQNnKl0yDPW5fy41ltfXAgasL55mrqGk
         tUvCtLTn7EdubalBe5ZBOKnP90vPYzijgXE/VHezwpla1yff6EPDK7+uFAUC71YPwddA
         risRYsH1SEpElcaNY8ZdRiYSDyaTtlsIJERgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768517008; x=1769121808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qyRs+d0Cf5Kw2rXB13ZsV9jwZ76UYEa/5ku5BYfGZvg=;
        b=sagzIz4VpJiTiDbVieZcYREWLhoZbg6rU4KJpPVwoeIWriqM9GCBWUYE3yLHXbUbyP
         7C1xNSnEqhJVEnTkkMUMWSXjPxCNuBm0P96Yo+0TEM9HXiXyNDL5vY63NorowJbErXnG
         mvThXIPmVc2L+WND+GGuAi8L45BPQK6ncWqd9HbfKGmqefMK4fxOyruJIMy9cCjp34Jy
         pny0hwMAx7KmBH6F0tCPE/xwG1ZWhmOyWH91n1BMoRIt5ZmCqKvB3CWr26u68wroCxO7
         goTFGPYTKhQbuQdQ7QI8sUAW13jdkGL8woQaz1bTHJU0f+ASwWKv1QxNa/LaI7u7x+29
         GB9Q==
X-Gm-Message-State: AOJu0YyK68XsJVQ8X2m3/hj8PueMvaX7hh/LAdXMW6XDYCgNtp9nINDT
	hRZfgJVdGB+OkXFdg64yz9NZAhEcf7PBbkpASmr+QCF0tRw62EI7TxL3DkOuplJsPt8=
X-Gm-Gg: AY/fxX73FJovETtAgebs/U2qF51w8LnYDcFU8/nXECtDJOINJpkRwXitrD29LXzXt7M
	GwiK6/10ZWj8z2arZZvWeEwTIarzjMxTBNVcvHPRgkLG1fCHKS+26d/JiyIfg6jBSSrqNuK8rMX
	Qy+zjQPEbAv/qwXdNbdUIAq3q9qfjDwrgWSzXS57zVclrpXFOd+3eiMNG4alllu24VwHjWPXezO
	FPZfKZz+Z6pL+c4cypMBf3U6KxLJWagdqH7TMsMCU3lCQlEED0RWBHwG8+sT1TBlOW8tGaaq4NZ
	w1kkPdzf8ZQpctat33MLaafw+sk9xmNMX00ZR0xNaWK/PfNA6cPtIG3qBfCEv28wyOLeOt56Usa
	P0AmzrhKxfWeOpwDeMYZi0pkPOuNKNUPl8r7lave03Fe1PTP/3QKA3WE++GHd1Pq8pfD4Y4ST9p
	uAtmFd4alCMNfxiNwb+8GQIDQ=
X-Received: by 2002:a05:6808:4fcb:b0:450:b246:f1ab with SMTP id 5614622812f47-45c9c78ff51mr501659b6e.11.1768517008104;
        Thu, 15 Jan 2026 14:43:28 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9defa8a8sm380622b6e.6.2026.01.15.14.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:43:27 -0800 (PST)
Message-ID: <9a75e502-619b-40f3-8f6b-1aad24855045@linuxfoundation.org>
Date: Thu, 15 Jan 2026 15:43:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
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
