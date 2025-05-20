Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82725485A
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775987; cv=none; b=g1esg0q8+SWYkQXyi4oXvzDoxB/pYhAlGtmVGq2OOx8rjxVST/rmktE16WgDylp5O114mLn16r1Qwo0usPVLYfoCw0oBBI5PYjZIvPXvgHLAchUJ0m80Db/eoJpRoVrKNvoUNfeKoQasFxbdzbjIhp2Gvn9vEH35n8aPM9sjMLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775987; c=relaxed/simple;
	bh=eSdCjtp/1fPo3n/voZuF4t/69QdVtMMYeXdvN1m3saQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfyyODy03y1dj0kkh4noblhrAF5Rx6TSbxQA1GWlNE6g7VO0wBAeoG5TfqJteaUt9GC0g/BR2p/CsUIg/1ur1J+VIudDdnRsMFzFLBJPTSBR2NmB9vHx5ujI2SQGz+uqMrDE8V4ZwxTispYE79tYQdfuAhnNxfDoEE0znH+AhUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmDPrM+/; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmDPrM+/"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-861525e9b0aso453794739f.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747775983; x=1748380783; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1YCTd9DwztrmkYxeGkW5TVua7369Pn3fqP+RCzxS4Co=;
        b=TmDPrM+/bdAB8ITESDN7Ygczd0Rgv7I0LQorHVcmGcTBLpyz1jsL/xj4T1BFbTRIJz
         83pVvuFzmRZdUiF/ieen9rE7e7aEyFFomGNt3+v+MlKx7v8u4WJN6F3Yqd2PW/TYAb8Y
         oTNCA4Vqh3nTAqrG81RbxHls5RdG3rV099mr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775983; x=1748380783;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1YCTd9DwztrmkYxeGkW5TVua7369Pn3fqP+RCzxS4Co=;
        b=PGWVHTSKHO3Ekok8iq4drWIe4vSlnk+ZZx1kDAiN4PiSONg/E4VbeLppP8npiaWHm+
         nDK3oVERADARy2LtU3d32HtMkSIKiR4xlGJ/73bo7GvbbPNplq7Zdwqgsqw+TQHzCjk2
         ECTdx3m7d1eck4psVKK+fbVvWPN8PfN+XhAF1jmcwEBUoWUqvOP5BnccVY7uiypJBl2R
         9zxBghcag9HFiNVZYa6rlCWaq23C0S0rvPSvOiJq6PSXdJF6w3MQBwQ0S5NfftDCmDkD
         gGqAIGPrwzZ82K4z/BgzYdCYgQWPVaO3Flb8Efi2BGz3VEh0iqnxcrBm0RvT2Id4asYu
         47ZQ==
X-Gm-Message-State: AOJu0YxIamcl/k4uafA7g9na2ZIRERvY44ubqGc1ZdwHT9K+Fy0RBh9w
	yLJnO20e+0RiLpuBIi0J1coS/ZCcLZNkBE+wSDc3Yfo9SZ59FR3PkUYfbd+PxNwODM4=
X-Gm-Gg: ASbGncvTjFdtxXW6/y/aCdrRHast5vZK/2BPQLgpIC2YzSpWpDGbozHP02/cirWfqu/
	ZLYwmAzdZKeTc2QvHTSHFARe6iLvhlFxtreXEtzSbahxIHnuZOrmr1NP5ZEBqMHvzKBCjIzOGXf
	Z73MeU7lDcWNkdde7iZSa2xEjmgZV34A1e+0WCfkg3L3LEYG8iG2FLGCa8x9SD2eccTm0j/wTYA
	UnTmWvj42iGnsgjTKTfCrFS6JUeuZqywpXA1ceNMtHCyM1LuqzCMMJbVhDP8wAEOamVDBX1s+Rc
	gqVsdk65EpP5S//0S6CChPvSV7tskAw5DsAG7Hyw7LWj83gKygVsVvfC0beM+QNQrNqamcEC
X-Google-Smtp-Source: AGHT+IGHZLwTf8LjSiEncxDrt7PbnARYCjK2hr9FZIftt2iQNbyIYNrlmrCAsmfEOVXuFPxxdltMeQ==
X-Received: by 2002:a05:6e02:2592:b0:3d4:3db1:77ae with SMTP id e9e14a558f8ab-3db843313f3mr233401395ab.18.1747775983457;
        Tue, 20 May 2025 14:19:43 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3ddea4sm2410313173.69.2025.05.20.14.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 14:19:43 -0700 (PDT)
Message-ID: <eba8ae12-eb72-4913-9983-c9d600ba41d7@linuxfoundation.org>
Date: Tue, 20 May 2025 15:19:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
