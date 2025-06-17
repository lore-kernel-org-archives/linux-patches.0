Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263872749F4
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750195201; cv=none; b=Tb9cPAIPf0rHopM75lDY+OR4xzvuKcnFs2xz0CXviW8xdbkHMs8TBpGidqH8HY+Q/lThgn55BICYZwYoGp3UP7vlXXdc6vHDWA1/GWz2B0NmQ89iagyzV+o0T2qwIOMnPYJ8hkPxVyt2KySjzXJvX90qaZVvEID1BJlmaYvxgLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750195201; c=relaxed/simple;
	bh=l/D5NMvXAn+poLQPgkO1RMnglJ5burjvSRypMQfBzl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oga7By2SpRufn8Vm7/EXQcBQFQt0c76SzulyiOiCPbyq3VflwgBsjTYzKqI0Ba2gAQbY/dPfA7YO+WwMJ6nr6Xk2wy2/sssbBwjb8WSop6mk430a+GQWtZnoX+TBUDO0aGj7UoDx6CBc/GFsgiZ98kXdhXCr4/zbjuVxGF1iXtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6FX/AOj; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6FX/AOj"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-875b52a09d1so140827439f.0
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 14:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1750195199; x=1750799999; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hHXoE1l6VmkaktquQQpfS4tQHCY95q6ZnsLPHOm+DMk=;
        b=O6FX/AOjxz8/BRzTKgWWyxO0ehHLqWHTztLWNz9/DMR5E861TZztr+zff7jTvHJB1S
         zdk82UUKYQ8iAwPjaQF3tKo/xfwwVEg0s3O04n9aldQ9mwM7BWsz+ljXyZcYXxrqG2xR
         9zFRvOHB0qXpGslgYzG81k/tUjnv0Cqd2p1AE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750195199; x=1750799999;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHXoE1l6VmkaktquQQpfS4tQHCY95q6ZnsLPHOm+DMk=;
        b=KXXgYhvwmvh2dDV57vnvdWVQiy2Qv/+Ka7bMo39UEAhqM22pl6b1dVRaVMv3uDupro
         NJU03DEsr1rVSodKoTmgDQIEg8zmzE450jl/VJb/LlpR4SP7o0nrHsmxM+HjEU47aGpk
         mJ/h0gnx9TBKzlXqHAL+vkELnQIpgalN3nPhru6noeZtTje3B8FVu2jfMOENd8IdJ/zF
         Vbzm9yq7Tnm+2+QP284seGcrfOHawQnVxCG2rDi49jxMDof8ErdL+/4O7moZ5vzX5E+y
         OqmmZG+OM9hK4nF5gVVpepmfqsCuvdjfXA4omb5Gyz7aTCC1Al5kBXr815KSvECEizW4
         jx5w==
X-Gm-Message-State: AOJu0Yz+GGqh+XIt3/1uU7jR5aXZoXe6muBXeC1vh3iYwEmSJaH0rRqV
	fBhUEHuugZXEbOnREuUXNxgQFsdliONinWXqi4oSYcH0nWI3FqTyq3679g/F8BDtDQaWy6E5LWP
	dhHaT
X-Gm-Gg: ASbGncvpTnV40cwi/SnHwtOPYy/1KAHctFPNty9CdW7ROLnr9V+UW2odur0tC8RLQIu
	UgVNfc3LYAQWxOGVmAGMBnmiAhhcacvyLvwIqLF1KMhwy/7jc2AfXY8bnb4C0S1kYgOiEVkjyxr
	jvLbL+S2vwqB+9QLpVm7epFm1mFeKTFjMy7dKCGpBVir06HwHkbCk+WKkR6d4P/h9eunSuCDbM1
	z5yluZfKE7KqIVjY5fMPaFupHcoNufstZxor8tvXfRhGV5IT3jqQLnfo8RBZ4NlwTRHdIky+B3i
	nFsNp3yR+ZQ3zzfIgkhFY5c5RXtEOYP6Zup0mUV9qkOzEi5sFJ6liFFXECrrUCJY4jH/LAye0A=
	=
X-Google-Smtp-Source: AGHT+IEWunlYJczIJ/My0qwdNVaCNeeax0MjC7QLjknh2C/jvr94Y70XxYA83yB6cMACh2HZsjWOmQ==
X-Received: by 2002:a05:6602:158e:b0:875:ba23:a062 with SMTP id ca18e2360f4ac-875dedb3cb0mr1806235039f.12.1750195199269;
        Tue, 17 Jun 2025 14:19:59 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d570f54fsm225868539f.10.2025.06.17.14.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 14:19:58 -0700 (PDT)
Message-ID: <787f5b84-5969-4214-ae0d-7438a38d2735@linuxfoundation.org>
Date: Tue, 17 Jun 2025 15:19:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 09:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.94-rc1.gz
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
