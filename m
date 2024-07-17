Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DFE181BAD
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721231038; cv=none; b=VpSqhNtLDbILMrHNiIz/2H1CcFkKM9Fpst8xx2Dad53teSicx/G6+LTL5qTl57k3xeriArBM59pZsu7ThE8WquPlokhClPUR4Fv1xHNQJMHCA+LrVwKwNxjUv3gYTUzSOZuNeGCvYjm2E1Jttpr7pH+Fv23lwrhz8CkEX/xGvSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721231038; c=relaxed/simple;
	bh=wb1LYv4A0acrrEtIIC/SAaWQ8u2gOiMpH/PnqcW8a6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PaG7nJLHd6C7MI1xtG4mNPubYUYJfzd0ddSiiObLn3JWPjOPNTj4+Ckb2LzH6Fy6/0vKDQP2xu5GxvMmT6DPNMuG9dNc7063/B0pIzguoB25JhRw3tDaSWKFmTd/k9q46JrbK7GlkAavy7o/AP329yaAK4WSgnww9zzSMa9EVeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH/LHswG; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH/LHswG"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7f906800b4cso4524539f.3
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721231036; x=1721835836; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EhC5AUh0nXY2Z/jAhnsZPgn+TyMTEjILQNMnkrHVTOg=;
        b=RH/LHswGyKyo1HcPkDNxI1WFvy7ON40IjX45c3JkBYgqnP5gnOxc5PR12LEMPzAa+J
         5ippnElbbJEMH3y9xLHvluJFkRIRKcY+xdwnDQisJ2yOGAUNWnSa6WAsUKLptfhTI+nW
         PEo5l0VNA5I/osB99r6u+OsFoQc9nu9D7G+wI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721231036; x=1721835836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EhC5AUh0nXY2Z/jAhnsZPgn+TyMTEjILQNMnkrHVTOg=;
        b=bzWIsGWDIO8m5d51kP7FMAdBmIjyDr4Hjqo68qhfgwrxuY/n3ZLiySDssokA7hP0rr
         NX+Q1+GtSMvv+jXz+xS9ralYBuvQGPL/e4s7T5fWUFsIttgiTm1GHn2oLbZX1fjRUVhL
         wyry9DUlekamCHi3d+SRy34/omJqOIthH7XM6SpqT7AdwnZQbnaVtXrv6TN+rhH1j/lh
         v3n8kdEvjkZTIUkyUD8OgsgR4YOF5ZgxRJ7bbLKgoFM6sr8o42ofPb6N1hiObntLDB3r
         TE90dWTfbnXFtxx9rrDyEyTJcNKo+ieOS7TVxZsbSkSh8lTFrr0qv9yFksYL7b9G8kMj
         /TkA==
X-Gm-Message-State: AOJu0YyGjeq5txD/NlHPe9uf69i+fkzVcyQiVS+xDq4/IAYxKkU/Sqzf
	yxDnicjbHKObx+lMVbQilQvGFBS2dPPViZDyK2fjuO0J0/xDj1NBWwN8RyHv+ZgL0VC/xlHwuBg
	p
X-Google-Smtp-Source: AGHT+IHZXl0hg8iG9vIuc9XxlrCQtDPuT6ZziCdBXxjOkrQv2c9JNy1ocmAplgM+FJOKVBGMYPOa/A==
X-Received: by 2002:a6b:ed13:0:b0:7f6:85d1:f81a with SMTP id ca18e2360f4ac-81711e195e9mr149045339f.2.1721231036378;
        Wed, 17 Jul 2024 08:43:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-816c17c4e40sm69814039f.12.2024.07.17.08.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:43:56 -0700 (PDT)
Message-ID: <a00b55c7-9491-4e63-add7-7f0f8649ae3d@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:43:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc1.gz
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
