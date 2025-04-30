Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75825DAF0
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028739; cv=none; b=upoj8g5KjG6BKLLQiMTck5pYCYxVLqo8mG3KhWGrTQ/mS+JNNM6gZfJCuMbXJAzq2MAcQv9q0Bi4TjgokvJ4RFtKbrq51bCYfKjOxquJEe5EnI8pw1EPjm9Mx/exTiTO3Vzk0pBaxUt5dKbXnXZgJ8dPF520ArARlFNBfiYCLXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028739; c=relaxed/simple;
	bh=vsv5PKy7raDqzHvOX0Ep59/qaAv2tKKgt5lzO89vjIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DwVPQbynNQWyyh69s9mzPs/Q81pNf/mHdzQpORXIPSpHu8mgL1WnwYqNIgheShqDPGp49LBz/7yHUp7MkJYUxYipGs964lo80AvLOz5XdAAQ2qpAovE8GM64JQTzlk7OXwJjt6M9hFU1fXnTlP/YwJ1pzo8wTSlDZCFaTzUEGIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi/ACc3r; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi/ACc3r"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d93deba52fso40915ab.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028735; x=1746633535; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6oxFBEyqGTgNk/NkYnmbUallUIhueyR2i9uRq7jDxM8=;
        b=Gi/ACc3rnNuyOu/NhnmP/62d+okM8wBWhAW/fQrYiZmaProUPyIorK4OXYC1Ne2C8o
         iqejh87z63iTqBOEu5MkwYMErUDOMwUqu35XDu351oLK4NyeTQZWt48Me+pyAjSAlCzB
         K2x8FM4PrPp3HhNe3Q2USdsXcpW7XX/avJlLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028735; x=1746633535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6oxFBEyqGTgNk/NkYnmbUallUIhueyR2i9uRq7jDxM8=;
        b=YX0V4ozRJKjih1dwgRlUAL/+qkBTgWj75NMxqxasxIn62r/eoghBEwBR2Ax0lF/6Ly
         lhQXjBkx74P96WKwUfJE1JX7T7/gL9GaTz/BE3fmWDqva+sTLPKox2kCnTSHoHLPzMj2
         Y1NwyP8JYTAPgDPk24W0B8IvIc8kn9uxCGUgq9SuBPeZoQPhwv1DRIuxS0xSoth2ApwT
         MhQzwaSdgyFyugT92BqyNKobY/gffZELFAfk3iJf0+EZn1S65xWNpCRroOZEVXm0MaYQ
         ZHozvoIPuJFjZa7wnuQPFjSC9IGXsI9Av0MsWtrORdF1lQ4U823cqO7WzUv5rcTE8a/u
         SSRg==
X-Gm-Message-State: AOJu0Yx+BT1vZFN0zHCDIRVcYQgY8OX6SiSRmLpCTgauz7Nav1byEBRR
	04q5/GP3agWDgZzw7ZXHvthXoXG+D2uoPiVO6FWmb8Ha0EetvIp8d/Mikq6mGRM=
X-Gm-Gg: ASbGncuUFZwP0z2AJPfr9WmdkgRhf5+zKEXm2ckrLVC3IBxJD7PBizvcvIsfW6YityC
	h49Qn/6HpRqkP7MLzHMWCpLRJNyrvhjYQj/kq3PwlqJRheFhzp79b96OpBRdwDnwIebABD+x4sW
	RBecTzDlMTg3u/JP393GWsegWw7YTdhb2oGiNRiIIaApjX0/gjlt2ILnhCCV517IDkThOMgNqXL
	dNVt86KkiDrITwDo57rmm+NSlwA0yZYxgihw08Ydj0EIfqm6pgvm9CI45KUyODVX3SQHSHfYevJ
	YRBTgizkUJqKr35rcrHzDFu0awa+9d5LRrS9a0pHL8ZvN83Bhds=
X-Google-Smtp-Source: AGHT+IG6FTX2nEYxeimfrY7yoxrShI0y64r96IWSWY/xeIKXCYHxTWjWbue3hjv6fR8whb0OHlHN+Q==
X-Received: by 2002:a05:6e02:270a:b0:3d8:20fb:f060 with SMTP id e9e14a558f8ab-3d967fa3a4dmr31584155ab.4.1746028735325;
        Wed, 30 Apr 2025 08:58:55 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d95f2a2d32sm8991965ab.1.2025.04.30.08.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:58:54 -0700 (PDT)
Message-ID: <c97a7512-a350-4b13-92b4-52a03e2c0992@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:58:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
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
