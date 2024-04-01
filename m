Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EF75A7AB
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 20:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712003663; cv=none; b=VDJhZto3DnI04D+M7zSPikxnNnPHZKETBERMIcd6TJMHgwNmX4MNCcwu2wN/IN9aHnMcNk4KM28TYQaNAmrdX2udWgxPY2pA6r3TTagd4rqXmcvScIWevHqstzvV9H10zl1jO88uRua66jyarRBT69f9ZwNk4dStan+gz8ajDYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712003663; c=relaxed/simple;
	bh=IXvnhxI2pXQ52Hg1YEyiDW9h4z8TaCL/BxY7wfJZcS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIvePDtif0gkgWcQA+epRsXTVI2RJHL2sqfqGOvZ5kxmLTpmeHxhVJxyWnQTcbOJCdWD7MD2uUUGVmvnpuFhPcHrhVhAdIBPK6f4YUwf+r/gXMLOFyqcUMLXgfia/Ff8FSN1dAjY2gRf4KnXM4H+7SnmjQit8jHw6xnMceNQc6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JolSK/WS; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JolSK/WS"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a07b092c4fso3345754a91.0
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 13:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712003661; x=1712608461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6FwFD4JYxhcIwnfKCG0w6eqnbQcVPaedMXbOYVzksxk=;
        b=JolSK/WSr4m5PEUrsXhFBhHEVFAOwu51IB29lrLQ3iD4wbwi1+aLQHVTKUz46w+cef
         rlAGWBMtPdg0/3Rok3ERrGZqTGNWQ5mMxrwjy+6DHR8C3UGDVudMZKVqX95bGFWTuDDe
         2STuvjwcC+uWf//vbeyV78CwbNfEGcscymXe965NbQz8VG8U7jTFEtx35lPYFoN1o4n2
         WL0GriAacCaXbho7tgJ9ziKa+6B2Udf/00eupHaypXz2htEyGTyZZWHCkM6x1W4pmog4
         kmw2uLy4ANrZRed3Pno5h7OE77ecFAPMb0gJstA9Fj7YVAzfWHIG+Nk2e/sxiaEF7W4b
         y+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712003661; x=1712608461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6FwFD4JYxhcIwnfKCG0w6eqnbQcVPaedMXbOYVzksxk=;
        b=sFtOC9bjAYpPJdtUXSSIqo0r2sRwCz97a1qcZp4xUr/jAZHYNFPsFOjZrvqWLfrCpB
         cPRfECSKFiBugtwrqoSKYsgaz/iSCPXf4OmFvLiin+6uTDlifzR5lGI8n5r2nk8RlHjn
         4AHxIzn9eI2lEDoSyKfyyRIb3FAttCd6NGZtiNeeVpLDZAhWN6cH29uYyuIw/zBA3lzA
         fEkX8m6F10wdFihPykVAwEkXbgOsFCv+HvN826xuY5RiSkVjxTSVfLuwx9EMOm85WQNr
         9Q3dp+aNbDXp6q4jjjkQ4/FMYp4P/xd0aCtln5TnDSDCupYyauVNjblp5Hfq6dQGEwDt
         gPlw==
X-Gm-Message-State: AOJu0YzWlcoVYJFGlLVavSdgwZo5Xb9VqtzXtwzCfMn1+5XY+ESKGlCW
	35rWw63qJoYHbWtVRWjYT0sj4WL9+D8/2ytkJeTkWLmO+hRfremK
X-Google-Smtp-Source: AGHT+IFTxaQptQJCitxa2lQjF/XzI2d/woGr+xEoVq2OhhXdQPW+leNIfgcvPM0k+RuUFB8jtLnLHw==
X-Received: by 2002:a17:90a:5c86:b0:29f:67ad:7db0 with SMTP id r6-20020a17090a5c8600b0029f67ad7db0mr9768772pji.11.1712003660956;
        Mon, 01 Apr 2024 13:34:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u1-20020a17090aae8100b0029b9954a02asm9598386pjq.0.2024.04.01.13.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 13:34:20 -0700 (PDT)
Message-ID: <4bea0061-09e7-42ef-84b1-735682c5f65d@gmail.com>
Date: Mon, 1 Apr 2024 13:34:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240401152547.867452742@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 08:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

