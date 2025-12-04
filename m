Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623183FCC
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764806521; cv=none; b=NG69w+gVQZB07WR5xFVcuEh7P4e75yNowgtKlX7VLX27JmxTd8HfzcBF/wqPM8q5LP01+tZTCQqAazsWAVpx/v2IgZHUALZKPcNPWHFdFD9vP9B/IHME157dqTmbrRIR/EnJ+F7mQjGwZj5TLlOJNVfBt/ZvKFrkGs/oqv/q1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764806521; c=relaxed/simple;
	bh=4HzK1tEhZsn0c0/oMdz/HjjRrkW0O+hCcJ/HG8vLpLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9ceuqo/kSgjvptJws5KGbz/Br5pU83+XNyskh75/MZR/1t2f5bfHYQG1JOhM5V5hEjM+wBqecD8xzurz7bbAzQbX2SSFTex7ci8DT4WPwMu60UUtLvgebZ/Unokq7vrQ3vphYyJ56EKk3ChsQD5jjCmE31KWWzFwNrEcMyDsVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNXdTq48; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNXdTq48"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c7545310b8so219901a34.1
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 16:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764806518; x=1765411318; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G4wjFyRQZt8QFoZmh2FwKlf9iqvXN/3aCEOnfVe5wtU=;
        b=YNXdTq48lJuzPUu7av6/b+NwqQls6DhqCdElN2qY+wDjzsaX7H4WBsvG0fBy/c59IN
         92YJjgV1JLSCMk575rZk9/OIZtj7fZoHx3xNwaLddUlKvuPfiELXC/VTlQEenYWe7bml
         RC9gvsyVJsyOMppyBkkev9kHRGpb80yMnQURM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764806518; x=1765411318;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4wjFyRQZt8QFoZmh2FwKlf9iqvXN/3aCEOnfVe5wtU=;
        b=bZEHjUsUCMU1AvMHudviir/SJMRm9Cfj1bGWu3PLylC68lqHnb4THuffLj3Wu+zUj0
         NMhsYUqdUZSh1d+fcMN6xY0TVfFDlVm82qe39hlg8jxaIOKTQqenBmi4hWNksnjajiZK
         xtVq32yvzS780CpROqUS4VJRbkIJ05XMphK2LDnBCctIsqsFKKkIDGeqsxaWxK69pkJy
         5DLfKfavYRBbuuSy8kulaare2NwtwKXclXHqCCRUZCXaEOLlsGNkr5d0a4WgdPuZ/QtO
         s0MM9Ba74Lhzm3yhcfTPgFWH/5VcciD9Rg6T7m3imd1doCm2exmDdqnkqNmZ8Jpj5JTE
         uGfw==
X-Gm-Message-State: AOJu0YwbiYJ6idrj7Kcsh77n04S3zrN2EhwvcfMfptLTpllo4zpREKbh
	2bSAsUE0cUI4DnJEzjnbw9xWuWfphdNdnO3FnhGNMJOP7Vc2GPLRYUimRm35qpHL0cc=
X-Gm-Gg: ASbGnctREqhFDLWt7KMZBY+nH2+G8tG93Oo1vCQeAcnS025k8xdqk9fhoCFkw84ErF2
	KcBsHLuG/lRqKtMBPiyQjEzOY+AG/uEboIPX3cvVnU7AE3JwmihMIQ0WYD77XAwZ4LKMg1alykV
	ZHYurvsQolAtppDysMRpQXeGpyuVyDbU3JUv9TAkh1Kejyb1kC6Zlkb5akRGLyBnwRq0gV+qPGG
	r0Pc6uzmzbOacbnGfsv2sIqJx4Okz9hmnXbcsv78cSl8F1YMlrQFfdhAmmcLgGiiiM4pOApVSuQ
	16zSvTEB6LmJ9euZiM+EXRK6umn9qTurWJiEPaYnT+tPyBcIHZnXk6I/kOrH/G2yWMxE9A9kZYQ
	0zXCKF338X3KCSm1DbgApYSbbOUILnWTzZBMP7zu6fGy9tcsnGvYYMT854pplU2X6owfsIh5jAg
	nSlRZ57hGRU7aB1fSD3dZRnxI=
X-Google-Smtp-Source: AGHT+IH6vr9clJI8w5eLykliAGikx/axa/VzdZW+lrxRAlKePDaQJH4HcjPYYKu9xeRqNvaoDTI0Zw==
X-Received: by 2002:a05:6830:925:b0:7c6:e92f:41cd with SMTP id 46e09a7af769-7c958c046ecmr518241a34.32.1764806518352;
        Wed, 03 Dec 2025 16:01:58 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95ac833d3sm175655a34.17.2025.12.03.16.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 16:01:57 -0800 (PST)
Message-ID: <3093ee45-505d-4c13-a013-8a83b3b38564@linuxfoundation.org>
Date: Wed, 3 Dec 2025 17:01:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 08:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
