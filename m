Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC32302750
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760464474; cv=none; b=C0JNUkdk4h/mFhnIA7upPlUOVm+WTQU1OTg9eyE5dkbgpLTkQ+rFDw4hHOn/Kzzb3Kw3CFLJsdZL7nCGu7wdUfr4tn3uguewBw7Cqpw45h2rDBEVjoEdZXu8x8NFIdmtSIpr1Ixel5qNpdO8et1LiLktArYwmHh96fuDeqVwbyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760464474; c=relaxed/simple;
	bh=3MmYi1JoNQdXRWMSOtVp8Kdazcv+3jagEkZthqrzwI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpJWaAZnRLbgGiEmNdL9ce9AAAoZYFZ+4U0QJzcOLjOfv/n8CHN7JZOVhn1iMnwMy2N51mOeyPOG8YDScAiory05AwYEh2EyTSLP4+n0Qu/U9eRlbsIA0bsexpzDw0k54hjFs70a+UV1BZaK4dr2hfJnHuRD998BAMlpBHaleDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyljO0Gp; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyljO0Gp"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-93bccd4901aso554327839f.2
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 10:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760464471; x=1761069271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gseXM3xre7+2r0O+6iOJ8UCID/6DfgPEO9X0+p8TwIw=;
        b=RyljO0GpNppNkIOoUqJLwvCH05tlL8VxnT3UUN+FI0q21WZDw7bia3XVqWkM2m+pPq
         WOpD/oWZm15DKnaRdjJj9ULXmB+FaIcIMEk9oQHvYJ0u3xGqGK3nhtrGzbuBIUoTUsqy
         b9+ZQ7+CZFVXwvzI63ogYdmv7otm66F8tctKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760464471; x=1761069271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gseXM3xre7+2r0O+6iOJ8UCID/6DfgPEO9X0+p8TwIw=;
        b=dahQegXnmSwe7rDZ6bfunTd5+nUGCzeNkWRSs3TJo8V9Qz/OLOkr1TNRtyFKi1VlpO
         sod6m7eHyiKBOadLk+CHrBH72gT8P5zdKcge1mnNdPwG+YCbJGNVA+zybafVzwh/12wG
         ISnkWtyF/Z1nUr/KKDHeCctJiQMRmsMcTfhvawujXnkPu/I+TgD2R3iG5ecTc6UZGfzO
         vJfjSvzlXa2j6440viB+okhTWYkdGcZjCbMS8XfTXa5DYD44EQ+TaZ0UzZx2AAq1P4VU
         EwHZHsY4h3t6mx5XwPH3vF3p5hr9MneeJdm5jTC5Uj4T1ey90LnT0xCqVFp2xhVM8orY
         7Ajw==
X-Gm-Message-State: AOJu0YxkY/gx0nvcHmf2LAa0W6oLLO6l3bnVE5shu4BEJoJeG8DkkqnO
	bQ/KI83P/Z5BrVNbAiU9CWPQRu9V4eLeRobcU44/wDYj2KNa8WxzoYb9q5q16tDKrig=
X-Gm-Gg: ASbGncuZt3Vil9/s5yVUTt5L1jDlwNMrdXKCQYr/4X7OfBruZQjUp0JBD5wrQc7k0Pe
	Hw6l0NSG+E8PxeFU3osR/7zjjGNmuHGJQlWSsRTKDsOKVWUGme16yozTRtJe9MZBoS9HnGi4ZGA
	ArKm4txPDIQu0gMY62Se/AM7JLhk9OgdkK8Ys42dbYbPTyDTABgLVDwkhWj2n2sE45hRPqmIE5f
	Conc3X0SxJtRZsSOOsyzRv+hS+THowQUKkopxPqVf9yftg126J5FCztHBG3/XJf9vH0hF5me66O
	dhEmWd7PaIDmtq/oFI1dwlElfk2vICa8iYXHSwJQOubn4ttdlkerlKxSy6ZyEQyiI42ajzQfN20
	3lQ3Hjyx28p2gPQYh+iCecC2X0bnAmfGzPasbNlDBqi8z1/Wrx+S7VYSIwntsbCvXMO+IxCfwSM
	8=
X-Google-Smtp-Source: AGHT+IE9FQ0RqivT93CbQNVR3TRDywFKmKjMA7BmDG66JT1FsSkEi3MfzaXsz5AoqvIulaE8YE+msw==
X-Received: by 2002:a05:6e02:1b04:b0:42f:a535:4120 with SMTP id e9e14a558f8ab-42fa5354357mr187377375ab.15.1760464471589;
        Tue, 14 Oct 2025 10:54:31 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f7328a26csm4930728173.67.2025.10.14.10.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 10:54:31 -0700 (PDT)
Message-ID: <ee0b612b-2266-474e-b0de-b70ee6c392d7@linuxfoundation.org>
Date: Tue, 14 Oct 2025 11:54:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 08:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
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
