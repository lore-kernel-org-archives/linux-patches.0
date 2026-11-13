Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608921;
	b=XJKMbCMLy73OOTDeYPF/Fbk8RNx7Wef0B1bTXJHmFuFP3tHwLN+p/hcDzOhy+3lF6jwv
	 HNYMMpOJ3y0E5aSOQDPXGaGgXFzIw2oXy2EwkglpXbbXx8fptupXfViNHOzKUWfHmLnX7
	 9Y1g71aAbgrjXRKKoC9HDsOLKx8qMNmnuOhw82R5VS/Y4g1tPQ/S+SZKD++eHhnQa8LkM
	 BR/iowyY9xi/+obTMpenY+5He+p06bzO2krIA2+1kWQaX0Pip3ca+sZ2Q7Hy9hikjUF1F
	 HsdTLazDRocJKfkXrhlxVIpmeMaxSkZxFS7sgm1azy1exHncLS8E1ZoRhkmuVOMUn6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608921;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=f8Yyu14PmVzE14sqQ8IHgz22ahJAxs1j9mX0HpcMRXc=;
	b=tdHiyZ1mFeNt8x9a6xUxEhEpO/pCTBkS1C1y9bPpTFYXcHcvKdYygCh+rpRSn5T6FZ0t
	 5cGo3GY75fzBQqpiJjKkqllfFMsNcmnw/koWK2lyVk5sYSD//4xJx7VpL494AyUGh7GJM
	 /6hD7Ybq/lam2KtY1G5qKN4898d5TeGuMFKjfKmpb/uya97DwuwUAHbgIIxMjmbq5DOn3
	 RfuT/2SPQPZZgGL5qkwrb8XeH7emXeP4EzQ65t9j9yvnZGxRLKRXcx6ho5c8vBx/OvdmA
	 KMpkY7SlUy29SqhG4FaEKxU3Djtzz/K+mNHW13C5R0sRYth7jvMJ50OcKSuc5p/9bRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=YdG0ZeXW;
	arc=none smtp.remote-ip=209.85.210.53
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA348606A895
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 22:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA348606A895
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=YdG0ZeXW
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-8439fe796ebso1880605a34.3
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 14:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794608914; x=1795213714; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f8Yyu14PmVzE14sqQ8IHgz22ahJAxs1j9mX0HpcMRXc=;
        b=YdG0ZeXWr0lZhSXaINdz3AUiTws2ZWn762zju3/sLtc200z7H3dSVdSVMvZ+WmPkBE
         oNjNqzim6RDvXfdNZU0pAA6fT0qFSXfhoPTswnYSV/7SYSK6m2/TBcgB/9lOP+dhmFbp
         EaexUdvZYhuTbwA59GkD14FdcAPQUOAVSU45s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608914; x=1795213714;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f8Yyu14PmVzE14sqQ8IHgz22ahJAxs1j9mX0HpcMRXc=;
        b=2WKkYxXMY7C4ie/L4vNoHeVkn4rAIgVkouURQXhu6KMFyQU/Er6w8MmSmfgnGp/qEF
         kYU7nz6b8beAVrEtoUWjLMzB5m09GFJMt1R5/M7E9vhiHXDCp6yjuUXXjL9TOmvxYa8U
         pgE6YUpwZ94f53TwD7mvsKYLCz3xk0n9mPJPW/XskKk5P6tnsdkVpXbKPUjqkDvR7kAw
         NwVebdq+YOInQPRlBI4y6+LfHq1W+/44uNESjDjqS1pzYMemGLyxkbqh0tUToM8F+Q2g
         sYk4N4h4d7BtWB6xFp4e0F3nXmdzPtBM9CKeCeFf5rS8R/WVONpPd4QI+/K1vip3DTud
         tLPg==
X-Gm-Message-State: APuU4Z/yo+MhylzswE8QuQ/qM7jLqNQ6XmOTlL50vfhmcvUs7Nn91gPe
	fYYuQTJnYbD3Ff4Xwtlyrb0DNJdg6/yNeMDVqwl4A1LCnei/ltwwpQObayK9jfAvmsI=
X-Gm-Gg: AYBFou1Lwiv1yKhG9ySW8jZB1RcItOze3zPZla/q/J/zulJIdPFaP9ZDT9WQk2WnQ3S
	5t/R1A0ojnD4Y2vlXxZQZeNtLBxJXkhhT+/ApFvlJfaBNLNFBaOrsQBKYDh4sV59zFC5XDQMAiF
	1oNEfk3YQzNP/iWB5fozuqDKbt+m8QsxQ3qrHaQYb9AQ8aWUQerxX3G6vWaKFLSchfK5jU1LKY8
	vNCFeNqf3VOF+gwYrzfKeT1AaphywiPes8ky3dqoD0bKdUem2JjN0LZuXAqyqGHTAxg31Y+/GvM
	hGmaKOpYEh8lft9AMzh69M5VgB1esXOJ1suYF3WuE3TdlTlcY7lNIXv8oWnw8Mn3gWupNpPIqyH
	d18nkowj1AwLXUnYCQ8atU24pYG5G44QFUjy2zWbrVKNnyjiZBsqDr9swey4VyPMQbpIqyVWfBz
	BVFYYlo5QbpEHuXE00Lk4db7GOUvyzhFJjmL4f8Y/tN6RPIN8J0WJA5Oi/2l6dkO8SEm5y08xzI
	50aAeoWIxfUJ8kqa9khpSfhF0J/UjSyfBj7ZaYswZY3/z4pLdJFJjHZhn2gB1V6EdX3yZbgzWrA
	alZgqRa0YXeTMM9yYN5RcQv6n/dbvQMoKiYKfw==
X-Received: by 2002:a05:6830:2692:b0:829:2af1:a07d with SMTP id 46e09a7af769-86289818d7emr3591229a34.5.1794608914557;
        Fri, 13 Nov 2026 14:28:34 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862880e9abbsm3427767a34.9.2026.11.13.14.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:28:33 -0800 (PST)
Message-ID: <278205d9-75a9-4f0a-86de-fac192db4edb@linuxfoundation.org>
Date: Fri, 13 Nov 2026 15:28:30 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 08:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
