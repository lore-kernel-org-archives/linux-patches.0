Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27998149C47
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 21:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350714; cv=none; b=MAdcD40QA4pdjwmKeztDfNQfR34BkJsmgKNurG0x8BiQCWlkFSj6zxVh92dNo697+k4ijClqJx1RwIhzZcpC5J8vaWc0NwABGy84HLIMa1ABA1GkdMSmvZ47msVTauV8xw7nExXz/X5GUQhGKjrUUhunYzsmQw8dLlRN14IDgHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350714; c=relaxed/simple;
	bh=pjCnSJI5wkLaPsKKzobjyBouBvkTV06ZYTrm2KLodxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8raYHcR9pE4Ujyo3/mEfMnJ0VeiYSIKqrlfPQl9FW3sZqAqgzgs92GIKt05bl5B92NP2FjXQ/DEWaxyzfa1qCF7wl2u8mNDwF+qeVOQD5urIR8KxO85bwDzVpsf9+8IZN4ssJLRPz9FQHeekHsoK8yW50WUrmNHccy3HUrDXTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkdjHWPJ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkdjHWPJ"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7eeecebb313so17291239f.3
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 14:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719350712; x=1719955512; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EylReHJRTyvw4qnns4SQL1C+bNXZftNvK2Yg8YJEAeI=;
        b=KkdjHWPJaBVZcFVEoqQf+qeRDwbjPcMs6exmuUW1Ybnb3BiThct75TM+w4c+C9MUvN
         PWZnEC/QM22Ukzp9dAivcrxxUcPRw1UzVgWJVbNCTYgmxXEgMTtj+Z2+3FX+ZzBJ5qi0
         +6RZfDRaKYP0cNQfJAC9Qk0HEsnygHt/P+ivw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719350712; x=1719955512;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EylReHJRTyvw4qnns4SQL1C+bNXZftNvK2Yg8YJEAeI=;
        b=dLecsoEfpNwfIdLEQzmrcVXMybkAe5jNGVZ2xDlk2CcPSDdMzcqbYthH6NhvMBVxke
         m9rWHk/9+lHFbM76tNPh52LU0GjDmSlab/NwZHQf3MCA/G7c4DHE+h76iFFE9QOk3bOo
         J0Xg07nrTAoBqtF70Uvuj7WGfpNUDWPBl1B51kljeX6PsLY79t7i0OJvD4WUKzQz/M3A
         gfd89VvuQFdHIj6eguEe7R8lKSLLlKjphPYFmrkIAJZvcpo5Q3iWCIw0o7tRJkToxecj
         mFl+o6oOqx9kIE/Q4Y0kPhAAZUZdnWJuFZMppNrWni1YNnF+uMuYlFcncDPrIbgMDmoX
         8vKw==
X-Gm-Message-State: AOJu0YzgkHOp6eFjfr0O/tKQq0rrOLKlw295AIKrLCZgyjwXE0iN34OC
	7kkaSW9s2vRRvD2UzXIpJ/6xmXdteMwAZ2i2MRNpgDGZPrY7tiD6LwZ22py/7go=
X-Google-Smtp-Source: AGHT+IH14wzfXEp103dUuJgZp/zY+2GhxllN2ig5sbIdAStPyKNV6CKDnd3ffI59yJ1MhhKGpGDD5Q==
X-Received: by 2002:a6b:4f0b:0:b0:7f3:cd61:32f5 with SMTP id ca18e2360f4ac-7f3cd613354mr35131239f.2.1719350712248;
        Tue, 25 Jun 2024 14:25:12 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ba0069879dsm1182080173.71.2024.06.25.14.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 14:25:11 -0700 (PDT)
Message-ID: <f65e8a9c-1674-4769-a11d-9a76076478d4@linuxfoundation.org>
Date: Tue, 25 Jun 2024 15:25:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
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
