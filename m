Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72478F59
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760747075; cv=none; b=nUzTZYiIUrjpW487+7PMQfDmchjWH1XZNohZMkii3zrAOc9hUi1FGVzHAUw0xynLovryKSC+pfyTOYW7GLuueQfLHr7fnpiT4XAa45AVskA/okDJe1aeT7I/rS30fsdVNdjviYWMPBVFp665doq0VbmjR1Wi1ty3jRrKrnr+m0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760747075; c=relaxed/simple;
	bh=U9IrYANTsLnJeSvCr1DnvWP2LKuNICWu5JtEQxnWi2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gyG9JNzRkY4k89f98Bp0s7AJoVzDdhEYi68VDdjH80LrQSS35wRB70ts6MdM33H/Z2lnSZOrIaUowSwsaQ9wSFl818jVE5oBVpJr9jb55pXyg4aGoL0C26AXSkXQb1UYpD89QWE8dBS8yVCLY/hGEH+rvOQVf78YgXpgvZzaMcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd+1437L; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd+1437L"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-93e8834d80aso14555839f.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760747072; x=1761351872; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vnmqLG6mD8qqWt7UOjgypO2NRulVIOp0w81YmvKj5/o=;
        b=bd+1437LMYLwInHjvu7s6e59inkjIg1nJqTr6FOoTGuDnEyg+NgAleq2HqF6KSbkD7
         ejRq665zsIhzZxJsJmGmwKW2ssO61R1KeZT7QtBXTyXtG0j1snRyVWO4LXnFEBlbpHIP
         NI+ZQH1EpjOl0/8yY3lZ+ObLNLIceecB8voX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760747072; x=1761351872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vnmqLG6mD8qqWt7UOjgypO2NRulVIOp0w81YmvKj5/o=;
        b=SCJPKFE9Bjxd6mxewzzNxZ1NHaTb50Bv39XQzoxGT6DOPmshQKVLySFfAWkz5RMl4t
         zvogXISIoA2cVrKLS7D6aGFaW8puLikmN9Pjm95FY1Cx0nzea8XJF+MEanRbr5+v9oHC
         79hJcUpZLdIh2jPA2OjOIAV/uEnYJ4P4kmZdVXn3vCUDnvLdQNV9fWEhhIQAIBQRwZRV
         Q8E1tpCisPGVWI4Hp3XMaYO1Knckliq8V28QG8bUwkcJG1Ervn/crJoFH4T29gU73PT7
         zsvjpIfUDWzUL+8lWjqb1jysT4dOAuh1pyg61GpLzaVks+jwynmK+3Ld7WeUi79H5LRg
         QPnQ==
X-Gm-Message-State: AOJu0YwFbpqFuENBY2ua5zr2nG7xJ6sKMR73iTQmFZrEgaCPaj2ktoRF
	5lu5IFVlxfGbWW9iyR7Gy7Sgi8D16oHu81CTUjR0pKQg92Mrds4/qtGGDNIBLypt6OM=
X-Gm-Gg: ASbGncvWpzn607Y+0RK3nxQFBiRC+U9lvgpeP6zTh+uhjUlftPXuEVSwVF5pXNvMdSG
	ZC17ZPPt/HcmceV/UcolWw2Aqz0PE1vTK6MEqkuirUuk8JXYlKyDCs8v1qPfssdxdmhi768Eo1b
	FEtXse7tAUxie21amarcg2rQuDAy/7rO4Qq8D5M/jSYKsogDHAQXG66kw+zJINSPLOn8GMZDBj0
	zGutCRCYZ+Izd14m6CUSAfaCCwO/asJ1plW6IRJ1UNHopKJ0tHNlHbqUZAFoH82/AAKWgZMNsve
	LrbwrHQJpfqFt5rMAE8NLG41BjXo+UyS8u425OQWkxz5GdmjmcGixxa4Mh/MwsJhQhktj3IxEzM
	rOMUB7fqF+huLizKgedtW+tyUGgpjiM+biB2t9LkuTpei7QUjRCwlN7zuzngu/akx+WqjiTC+Nv
	wn+4pfuLOqKQKD
X-Google-Smtp-Source: AGHT+IHx8toFL4okOKYH1BcXiwIuVau+vE6aOwtifNCHVZJjzx9BtPHT8riQx+rY+R82cWq9XNmtlw==
X-Received: by 2002:a05:6602:2dc6:b0:93b:ac2b:d63b with SMTP id ca18e2360f4ac-93e7634f25emr896183039f.6.1760747072392;
        Fri, 17 Oct 2025 17:24:32 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866cad8fsm40199239f.15.2025.10.17.17.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 17:24:31 -0700 (PDT)
Message-ID: <bcf10471-28fd-4949-89e7-fc1fe9e5df94@linuxfoundation.org>
Date: Fri, 17 Oct 2025 18:24:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 08:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
