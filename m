Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EABB258CD0
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760134817; cv=none; b=bQMp8I8eaM/Rjo7piyRUy6RCWD/f+0PifNeyIK3IYzjH6dzkpF9mbQqTofPtFJ8qXeHuDugEZrvqEx9wLCVF4dNjj3XWmHfQt2ZBWXEfavUMMZCeAkkMHzHYPCfVf+LKVt7Sm0CoxGl34I+cOLtshh1GyUvfvwiW29fpRHbcaMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760134817; c=relaxed/simple;
	bh=HX9kUSbVvZEhkBm389aXiAE3qoNIBIrdZd/4VNb04nk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j2VezAXUeUy2TE69YRWY3hxV5jMzcSPRS8GnmRlC905l7YU1j01ksoaMTGyEDxNVOZLkNSGx+5TmVus8AQXZ5MvJUXIg4cAJGJqtyRMf70cAx6uGVX3In3Bi8meKdaEd0jZMgEWpQNoxbuDw2ed34lZ1pvzS2YHi7YdJdi6B6CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auSv1Y9y; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auSv1Y9y"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42f7b17f9f7so20592965ab.1
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760134814; x=1760739614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FATvYxMqMxqS2ormXMSWnTcKBdYsfsjX3qE9wWsDV+4=;
        b=auSv1Y9yJaYB+Mpmz3vLgkup2Xh5KUxH51ICPsMYozv8qVQYbdN+0XlDfvxyf4UY5j
         VwgQAhYoeoHGhyW8DqQknIuo0N6fDqzm2uVitcL1wP7pZJk4HeJxyx0bpyzuC8kASF+0
         dFqSYP1IFXlxRmkuvPF1qaPZDPN/y7FsP+6i8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134814; x=1760739614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FATvYxMqMxqS2ormXMSWnTcKBdYsfsjX3qE9wWsDV+4=;
        b=R6RPAcdGhHOsJcqpKjzKJT2qTy38Mfj2eaESXWGLOROoleDmn0Ipe/FCMbH1kMauY5
         Pz/g6YbJGsJwzXatXoy8Xmq4FkYVYzwSreq7hlkfzUhnE/9eQk1eEWV8UJHe1zgrYJcP
         9hJX7MGaXK/R9U3zTNEO3H7sbNP4j7WJbfMEB7oBnbvCpufhGatQJrJTmK0M5f8PCQVG
         q+J25Vfr2QGvpj05HLV19QdVUmGyhIWegRaxtsb7qQ0GMsmiShjwcEYycrjRZ8BpRhX7
         A1uBHnSk53ncDYB3Xk9U0mO2VYUdWGSX0JeDzfgA2p6QEmTE885kS/EDfgW9f9B5iPsv
         sNgA==
X-Gm-Message-State: AOJu0YysGaqBG8CsgQEz7RQFJ01C8KbkyQ2xKRncFgNvDiFgqHM3PirJ
	ZUjckBnk89zZij0BfFw9/XC7hz1er8mtr0RhdVkJ0quyWVfPXpKQmoPccrxMDxApGA0=
X-Gm-Gg: ASbGncuDoi8NUKnX+cQzax5VXat5vxxKbwwcmCZlC55xL6O7SjtxZmMRMIMEDdVvx4M
	R0qir99EV4r8PeuSxLhYtX7dqFFpMR9FFsUSlZMcvwKejns986NgF2ozsLLWmPMB603Pdn3/zEn
	1NQo0/TeJ6VhifwdphWg3TZhRDKM7dzqOmvz1IJinEa9RFLQD2NVWlAFjra+dXp/hbzw5RLi0sj
	jacdAdRhYz5wNDml9Y5ihRg3ddmti6Jh2VF9Nq/VRPBgLW778szY1wWAxzboCpmoLA0fAuAKRe1
	XPGclrbkqYBiVZ8Ad1hk4rniZ1mOon6lrtuZSz/rpkMOHUNic7a3iFntb7+KH7G0yHAFCBiZKL7
	mF3pnGxgbtmjgoJ4QmaaNf25Fwym9LMtECw+UwugD8Z+uuQH9iwn0pZe8zSJKSvus
X-Google-Smtp-Source: AGHT+IFjVlOVlp/S67zJcwokGu7xNEaPgsH+NZPyas7fNGWZBTxl9oVKAsc7jb/qBFuc1FpBfQ7TOA==
X-Received: by 2002:a05:6e02:378c:b0:42e:2c30:285d with SMTP id e9e14a558f8ab-42f8735201emr153202805ab.6.1760134813952;
        Fri, 10 Oct 2025 15:20:13 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f90278522sm25119905ab.13.2025.10.10.15.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 15:20:13 -0700 (PDT)
Message-ID: <4bf09441-6431-4770-bfd9-a1890c0db4e3@linuxfoundation.org>
Date: Fri, 10 Oct 2025 16:20:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
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
