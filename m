Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0345778C6D
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730948260; cv=none; b=d4iBkBjiO8CIsuLpkNOBYyGvFOlGQxgINQBvtTgYBCF5CYJOzzyO9VgexSmf1Ypsbl2TNEM8q0hq64z2mfxv3Rj7F1v0yS4a0+GtJEQGg7LsXRX+YngBP2tZdYZ//f/zWel9Ynq1+e9Vr+1+ZvgKSeMavxZZrT/I1kyBiavRqKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730948260; c=relaxed/simple;
	bh=HBVABVvxbDZbSdWxMmhCkzobnKr8e7PlcAHc5r7VUxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mi/2bzCsdI7FswJDXJSkfSxW54X3NNPWAk+URaQgWnVWzTXQcYv5QjBcEUx/d4aGNlpUgOExPREJ3hsBOQ7F9uAILMmtYfveRv2DB4jo/ArS64TMEQQtGIzQNHTDW7z23YHFa8MG6HyzPUQ+JULRDuNV/EgaTxQdFUxEqLVLLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExEFZ/6s; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExEFZ/6s"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a5e0a3ac48so2099055ab.1
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730948257; x=1731553057; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WnWx8Kk/qOehULMa0Y04w3YMnjalm73MUZBqHKYkraM=;
        b=ExEFZ/6sYLnBBTH9nRLJJn35ZCBCz/JLIMkunchh9maCPsM6OatxxQKWtoMPd9V4JW
         CDHfGH2jDcMRbDRSAy7MJ+36wfzvO0YFZm8GtgKmOEE7oWPi3EMbsLrmtzUXVfxzpkDd
         pw9CmB238vFY4M0shEPy7JqZ10drU9rXnXq2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730948257; x=1731553057;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WnWx8Kk/qOehULMa0Y04w3YMnjalm73MUZBqHKYkraM=;
        b=kl9WzhFTPmjBmYrnaJLskFueoipqB2wC9p+WtqC+fb/TDyQLdl59CSbjR7FHY+QX/M
         4DRUHgptyutiJQWvlE9ul1x5nIIEQx5+jIgp+5dWgAEkEZXViEnSm1NuBTNSH81eBMXS
         g53oBnKDMlTaTTtVkLh4+DKrmmgzkf5ta2fVrI8x59ypl1gF+ePyaZJ4tzsA9F7E8FTK
         fQ8dXxZimcNBHzbG+fBtQT/bEZKjqanMe2+uFOMvoWRlQuTGSaGBRAm0DeUxCcELEtMH
         5AFQtc7omj9f6FFQJhhRyD+j1VfT2ZjwPqQDuuv+uu9Z0uFwebZFyvxQTp3w8Xtg1vLR
         lDyA==
X-Gm-Message-State: AOJu0YwS1vanUJmXKs4QOBARZfhyDoRvhmKHkidN39uKmI3wJa7lQOeg
	4LUk/6M87u/+wBsonc6hporo7PdeZHHrS8hby7Lu5TSyJJjg+3m8v74Bj0JXoSb/Ffl9ZNEBx1R
	N
X-Google-Smtp-Source: AGHT+IG0JS0I5G++8zt4aSSwZVyZQIhV0US2uvA73OFyCmrguDefvjKXqCjX650GwNJDp4J1SLl+Og==
X-Received: by 2002:a05:6e02:1a6c:b0:3a4:e377:d906 with SMTP id e9e14a558f8ab-3a6b021b260mr241438385ab.1.1730948256767;
        Wed, 06 Nov 2024 18:57:36 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de5f82e81dsm117809173.70.2024.11.06.18.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:57:36 -0800 (PST)
Message-ID: <ee29d620-2e82-4b2f-ace7-6be9caecc60e@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:57:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/462] 5.4.285-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
