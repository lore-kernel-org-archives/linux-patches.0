Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE11A83E1
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 23:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291699; cv=none; b=V5VXWhZQLfpRPxWtnPPFINK505qrfGTDmKl9/xjYgz+a8NVpQm3adiSevvw4Gomv3XMuTONS1+SHoGJgbmmMV5NMj6Jw1xaSNYZkNpfEWeceTUezEdW933WTpWs2d9w9MAgNCdMv/0hczB6qdhyGN8MYKwPf9dBMebOZ4VoeG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291699; c=relaxed/simple;
	bh=BjKKH0vGpUbV7AWq3U1V5wNomw+T3c1zTcany7gp9zY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNyafVg16WVn09idrGNR7t5LobcpZeSprFo7tkdVauB99tP1Vx1IeLmh6xqVMa3IWqQYBkh4t3MH+ogciAy3z8bRcS/7UXROhnATSVhiQBPiQZ9qDF5aRqWk44n+JOi65AM7n83J/GP4vAhrwjl0bzKTSMAQoN8nIpxC4m1Rd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9EsB6EJ; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9EsB6EJ"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-84cdacbc373so32138039f.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 15:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736291696; x=1736896496; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OMG2k29doqK4b4RNK2OGfEYP4wm7KC5LacWfwMa88uE=;
        b=O9EsB6EJq/J7DuSy/Tris/J+PiBy44qufIoi9eassg5DwIFbup/JdyhJrYzq8NjuxI
         3znMaVgcTJE6tV3vtpdDS8b19w9MShwG0Radv0qrE4TfGsxmWuERsBKYINmHbqJrev+R
         VjCi9BnAAzAon7686sssJcD47F/JaWcuNc1GU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736291696; x=1736896496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMG2k29doqK4b4RNK2OGfEYP4wm7KC5LacWfwMa88uE=;
        b=mEAzPgB3XRTucdvdmimESAlW0JrlEX6O5UgbtN+iluvS8bSUZ3TBpejAruYGdgYiqd
         P5cxIwtjrdxtvVywBqZvcp2Jy13bZYMD5FKd8sD1RT4SJqPj2Wl3siVr9nhlmlgNPfzn
         AOPdrrL6w8NItdW8w+igIRh834t6nb2V6ji4KfNPE2uOSwZLPptJNftIqg12OCq7S1qR
         JgLfnXPfGVIQJhvn/2hINswXVnNvwttFrjoZYp7a7DyR9gR0qjqgTHupTCGSj1U+UcCX
         xBPUq6dK/4KwM+jH1FSBv2gYWAjBvpubqFSNb2onvUnL6YFxDIaFmuRwJsIYpJ5FwODo
         EvTA==
X-Gm-Message-State: AOJu0YwuWF/QVojhUNsuxCvckCiSShR0SouX2UYYWLFAW3H668a71HeX
	cZXyPEh/W7ZiMGymW8RKR9oFWoZK7ymSa7tqCHkMHPEjSSG+SO/B10Ol/3d/rjg=
X-Gm-Gg: ASbGncvEnbSbMZcJUcR8Ecjw4yCrwe0hE/2o4BG8roEf5qHd0DybXPO6GD5+5PLHnX2
	OQ92TbsPBzrer2BkafPMSa4WDrlzcv/oe5JuDsr6n+inTf6fZNNEdysPcftJOwTGS6gmELa7pIW
	b3DBaJaL5AXjpIXTION/oTpp9M3o5itdISZHS/zrHKG59IBBCOvx2An9prlbNFjFPlO/xSulmYP
	ncTnMWeoD0tGDhxdHTBLN8bV+2BZNLOgNOHrVBTlNpwJPv0us7s1+hv+BDE1zEwf73T
X-Google-Smtp-Source: AGHT+IEhdYFsphyMJwmUVBiBfw2T+7bke7tQB4guyZXOZBr/m0Kf//ky5qWxoeZ80D1Scq5qTY9MWw==
X-Received: by 2002:a05:6602:4c08:b0:835:4931:b110 with SMTP id ca18e2360f4ac-84ce0081db3mr91795839f.5.1736291696579;
        Tue, 07 Jan 2025 15:14:56 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c19990fsm10229964173.80.2025.01.07.15.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 15:14:56 -0800 (PST)
Message-ID: <c59a9bf2-efe5-473f-a8c1-c93276df7fc8@linuxfoundation.org>
Date: Tue, 7 Jan 2025 16:14:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
 <5c3ac106-f18e-4237-83ff-52398839f635@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <5c3ac106-f18e-4237-83ff-52398839f635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/6/25 16:18, Shuah Khan wrote:
> On 1/6/25 08:14, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.9 release.
>> There are 156 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compile failed during modpost stage:
> 
>    MODPOST Module.symvers
> ERROR: modpost: "i915_gem_object_set_to_cpu_domain" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "intel_ring_begin" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "shmem_unpin_map" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "intel_gvt_set_ops" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "intel_gvt_clear_ops" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "i915_gem_object_alloc" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "intel_runtime_pm_get" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "i915_gem_object_create_shmem" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "i915_gem_object_pin_map" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> ERROR: modpost: "__px_dma" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
> 

You can ignore this.
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

