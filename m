Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF011374183
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781717620; cv=none; b=VgCSpqx9jpo2A7n5SaJlsDO5KFCFVNDFjTP6KgYKQ4dEay9duBu4qqn5EZIrW2CGesoNvTV9uU7W8COdynnHL7XFjHczsrL+0ewgtRaXYZOuQfT2RHENFWk91AZtsaPWajzDnQ11fABW4xS8462sG7G09gvmcEdIOi1ow0elj7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781717620; c=relaxed/simple;
	bh=hIwmC213wLcSWDqxTttp1NyeaGwkLczVuaFVFeNnVSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jm1W8hjZSZQkFwkGBs/W1HDNJ3o7xm8XyamXwnNfgBCjB4BYrz2WlXu3Slm9zWt/VQY47dMaDMwmjCg8Ywt+AXyxb6TwtHdEqtf+dDShYXw39uxjBw5cJAe07mzRrqpnsgkOZrfYDlBdn+8fF6+Rf8lLG2mqKlVAP9vYgtapUEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgiY20w9; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgiY20w9"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e6cfdc8382so4223a34.2
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781717618; x=1782322418; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rf2iG4MQkM7iTLQQTt+KD2Vw29aqWn38Iccwsy09sW8=;
        b=IgiY20w9FjErA2iggK4+qGoR+Y3Gmh3tu+60YeUUmhhl4vJyS3xm7TgZl1ufr0id54
         NWlLgWO4qEVcbzoWnrlhrEfAxMBvxefxUFJBVJ0b77CpbCUBknxbg12Uzv2dA7P4aE0s
         JRwy2FP4VyuFz5wte9PJZWMkbM1ZTJMNa5Fn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781717618; x=1782322418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rf2iG4MQkM7iTLQQTt+KD2Vw29aqWn38Iccwsy09sW8=;
        b=Vgy+o9S1Uy0ISqWnhBlk95sHGXCsBYitQAoNIOBeB2YDtsHwIJpa4JJctIn2du2NfZ
         t8AgzpSuk+P8K6SJ08Zu1di93hvBZR2vWp5GsTiQAFepwdYgscNSwMlTycY3YSjCWoBl
         sR0tkfc0XAG4/EvXVK5Hkgiy9PPsKtrF3tmrr2gte6Cg0ni/yZ9UwclyQeqKwvNnBBGx
         vSCw+3HZxlPlVmOGEquMvQbRYYr7zgQjuHq2oDSfffVOw0zVT8naCBIburooPGFredK5
         ztOB64NVDPuUvSXdwGgqJt+ODxOzvuLcxuKTx3BH8l3k3MHjlQi0qHaAjeD9QKdsROf3
         zopw==
X-Gm-Message-State: AOJu0YxFBgLHSc/WBGnB8eltDnkBF+p4K3KNvKGmUH9ryyfXM7eQ/5as
	0AsxURcku4ZGhiBYAxIZr4qHe0cJLtXuZId26OpSxSnubX8ka12RTNr0I0KVMTvbOaXb+sWy07G
	OAkVc
X-Gm-Gg: Acq92OE/sj3Dvgb1bUlpPN0MjLHQx6vayHRKf2P0bNmJYJoDgtm1Z+WQeDzkUQJPu17
	I/ccArwlZhcrbgzJ0QBitsXtsdSpHs6y1r9UA4XLwrdGS2PFGzFCG1MnN+8UhVFpOx1vW1aazoP
	ajCg9VA/EMCgGXcVGcP9RxD+M6cbHowrhbQRQJGl5uxNhGkduGp7wQOD428Mv9+qWbgQEGbNFjd
	O9sVvT6CDa2GK+RozINf/nxjv74k6xYtO0x1ozD70YJS+5YbzEtuFy3X2/4K6gRd5Woe3YDgVav
	oNQeSe77a2u0fd/iDnudNf8hqwcYm+0rq434OSzllLGPKw3gJISunVBRUY0Gak4EOAut84OoOJ+
	3bl/N1/QVM0eP1EBcxWWqvWeVJQTYzFmdgVFMsEl9XmxZRmbJlIHrrHF8ZGs9zAgxxrwiBzFqJF
	AUXpDGcQqXuRXiAgc+EMzI
X-Received: by 2002:a05:6830:230d:b0:7e6:fe3a:b777 with SMTP id 46e09a7af769-7e90b38a99amr3923302a34.13.1781717617577;
        Wed, 17 Jun 2026 10:33:37 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f5a1de6sm9605897a34.4.2026.06.17.10.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:33:36 -0700 (PDT)
Message-ID: <4fc2c04d-e76f-47bf-ab7b-e02e39ce2bab@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:33:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.176-rc1.gz
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
