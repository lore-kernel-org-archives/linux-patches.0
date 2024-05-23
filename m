Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F49414A82
	for <patches@lists.linux.dev>; Thu, 23 May 2024 21:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716499092; cv=none; b=oicH4qxMjl73DqduRw16xz9Ev3UEES/2MmD5dvVmIm/qSdIXX2av17KLy8y126unUPELFbGHccnGmgZTHJcNdk8/CN4r1suvN/9+9rdK+Qox87OzsxwtQNhXf5xnlR6oH9Re+fBqz8c/dHiFg0j9Es2XxRqRguIbL5YtK/GbMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716499092; c=relaxed/simple;
	bh=pKD8sIzMjawIjx8TgK8/CugVLHIN9wwV+v7SX4LeI7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=It6c6EKOukPS9RrJ1dn3qG04w+Qv2RLBswUscsCCV3JXljnRClb0NA0E0G1ZkxnGwx3Cu/pPod8vOC7Btk+3iBY25Rd9EF8rSLGFFqrk0P3nyziE1EOBmAOhJxAw+VXPU94W2kI/W49rwi37nYxAvGJ4j5z/y2rBEJ8+IjrcnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GkRE47YE; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkRE47YE"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-794ab20699cso8718485a.2
        for <patches@lists.linux.dev>; Thu, 23 May 2024 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716499089; x=1717103889; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTQYbO81rVm1d7lRu0tL1hZxpq81q3UNDF+EXPIQyIs=;
        b=GkRE47YE0V3Sx5BgFVk7vSVwjhUabX9AxgJLbLqZWQ0qiVoewAUeCpzX3eVPdTu4Xo
         cPcfDoMrKqETqyTEuqB1K2CnQof7D7+9pOnGatG6iq4hveaEtVDT/CLWECvEL79wvep0
         +CwGkkweQQbvEOuf/pbBriIWcWGhVaGRufYHq+gBTpuQntLWvByM99kcLUf2tvQ7xyS4
         50arjfDGmkuk+1sZz4NJFzDJN+xFRHiMF3PXhYI1WuiV6KDA0tSnRXwpCRxkxzAoIm7G
         Wy4VZaRtExiabpk0AC1r8f02C/AUyXBJmbhfOa1hUAJNhpyo9BdzeqLxbOhaKJYpYOdq
         7uLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716499089; x=1717103889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTQYbO81rVm1d7lRu0tL1hZxpq81q3UNDF+EXPIQyIs=;
        b=XXbeg68+kAACCXGL1C44GUKmxNru4Eyqq4Ee9EsfWdOPRuFSiQHlYBm4w9NyohnmGA
         tQkccow/+Ng1T85TkvGR0g3kRRTAEYI68MqV/ldeIDQ+yxmhIxy5yP8ZB4PuFFrkXDsP
         dNPLN2EYsR5IiNtpqwntnvjbuWtl3GRTM1XPKjpqx04PJJHeOfQM+2vTu3oCn/phEKJm
         Kntba4dW4bIsnJAl6DzsVvyVgNjRlbTeLiBi6YJFZYZmTu7waTare1wtO/U4A27ZquXG
         EyW18WtF+0mMnwhqdvUlWanYiUk2MlEVaG5Is70SrZfBPEUMcjSj9Iyl7IEe1lSjL1qt
         8P7Q==
X-Gm-Message-State: AOJu0Yy7V+S81zFKtlBFMy//P28iMl7/IGwxzZwmF3Z3i/zHOt6yHnFo
	9cwP8XLYFAS4WRdhE5UbpoHW+4o8o5+kuBaL7WEfnOK/ld+5W/nh
X-Google-Smtp-Source: AGHT+IEKNgehrfnWFRSEmmW1Nx71a31VIDj9r5mseSzNIQPoMxhkHyzmjwbHsSiL2GY4KaItmoBTqg==
X-Received: by 2002:a05:620a:248f:b0:792:b254:640f with SMTP id af79cd13be357-794ab0f8366mr52098885a.57.1716499089357;
        Thu, 23 May 2024 14:18:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-794abd441b2sm1685985a.130.2024.05.23.14.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 14:18:08 -0700 (PDT)
Message-ID: <44602d92-6908-4dbd-af32-f3cf0c790766@gmail.com>
Date: Thu, 23 May 2024 14:18:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

