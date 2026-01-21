Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E20366DAA
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769038564; cv=none; b=e7dmyt2AAdVExtKclb9AmfpNXg+e5ljNijMsKe3zV8cuedpnd1XnFNsZfM3iwAm9Gfw+hA9YHwKHNa/qTOs0tJrjAgRzAitw2z3nEa2fe4Gqvow2BUQcCVDBddOOWVM8Syr28bX5HjTGzWmAWBq0yWLmPTKb92IYDl/3vJAFwlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769038564; c=relaxed/simple;
	bh=qL7aCUx6kvvRHjayMVw7naN77YFLWG1dpl5yFQz8HEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RliZS40Q/rtW3LZEv/U1UrP1+Vx9VqWDCrzdAVZaRBeI2Nv2bC827QDxw2I00KAU2KxXvCpDStW6vHMRtVePiWLw3Ssknx89yXmGZxeeTjLVaNDu63Seh1HL8cgihWjvAFUzAJI5wEcr8COQ+2k8jFj3lNHgW0pJLenavQsf+BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQRqF16o; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQRqF16o"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40439fb8584so1013968fac.0
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 15:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1769038559; x=1769643359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e7TbFCm9LfVISK6AhTxIU1adeTlDFPbZ2gHj3oRwHAw=;
        b=VQRqF16oOSlbpg5bQEhXv7RFFbnnfOrBxMxbr6hjrLiw1XrcDObvAGAtJv+Xmx2jtL
         nEKMEmWD4m2jT+6KTCrLUdkj9a84eRjoLMixdCBlArGhFOBHBH42xegl7VE0+3nhrnUJ
         qBrDxI685sWsoUTOr/Bpk2PbJSLV+6y8DmzzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769038559; x=1769643359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e7TbFCm9LfVISK6AhTxIU1adeTlDFPbZ2gHj3oRwHAw=;
        b=pRPaK6nmfIaE2agV4ZUOrOutgjsF10Ah/DpHM8OPvoMe0c95TfK3dIhL/XYpqHpSqh
         91sqMU4xBGl3wIwxdf1a4eqUR7xvCAcSiNu4M0krLOFF8JVEz2w0pDINgE3eFf8lOWy2
         5CezDQiJF8owLfb7iJWO3u5CFoVhMf+nGw9pLRGblcsh1abdWwRP7AKnBK3R8+YRCc1A
         b/RERjd++uvK0S07hRmUArWTzwMysHx9MrIMx0eqrp8vSGcXaNvg6hD0I3niUs9uSqqR
         jzncI1PChYznaryc3TlfiPMSlLwVV3ELgtxMCrDn5XaffCxCOHBqqsyBmqPZvyIlg6sk
         3bnw==
X-Gm-Message-State: AOJu0YxlcyjifzUh9JEzJXA+uookV+mPsqTv7lv2nSVyC1BCQ7bSx8WN
	GAaTJQzJyvCBdkt8xq/P/56f6e9Q83HvohEP8cPt2dmsGKqx3yVRU7jmlsAKq4oJAgc=
X-Gm-Gg: AZuq6aITJUj/tsB2WO7Ptb79WonP+AeoUEa2MyTjeBqTh+Zy+3ZIiqVY2dtc0OYtTOT
	9FEefwkgc0nAtI0mF8V7MoMvfPuh/qvB7HKh2ixJZ3Q4blfvw7NKAhlkKxKKEcF+sCDZU5nyVt7
	FLnXr5+CHWJB4WUoyAFKlB9RqEfihuPeEGkXPUK0NAUupH1IcpHVJ4ttLQ1C1eq8oKai2kckPpZ
	bHTzEX5cGceQy37BmxeKpcLvAAondSY1lOs4NzD6RNKsQEi4EFCmO8Mbtk3nJjiYIvn7oYFoMjL
	4IkqPmT53gzmTqGJUx0hyP5B9KJyvQ5PuEWoFRK0vUQUOn/7pAC3kvPFDUTDy8P7L/dyXXMVLMX
	utEM6ZvW2fTIMgSAehbiMiovSdghpnHUUm/rx03TtiLyg+apdL7A434Z3DOmyGpH8r/dKwOr9hy
	xt/n8I1KSmPC8XapnGhotlCuw=
X-Received: by 2002:a05:6870:828a:b0:3ec:5138:5cdd with SMTP id 586e51a60fabf-40882a7d813mr708471fac.2.1769038559117;
        Wed, 21 Jan 2026 15:35:59 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bda443asm12287034fac.22.2026.01.21.15.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 15:35:58 -0800 (PST)
Message-ID: <ff3a84bc-7982-4059-ade3-61c5a72ba674@linuxfoundation.org>
Date: Wed, 21 Jan 2026 16:35:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/26 11:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
