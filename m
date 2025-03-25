Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C50025DB17
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921527; cv=none; b=LFgg2moX9hsHxz64vT7mnKl5F1xKgARz54jr6Fsk7n/rfzdzhvv9P5h+gyC/wGbMraUUTAiOs4luDuGgTaEV5Hnza7TZunGw1VjTbUrKxqdO3I/f2nYb9XKLI+w1ZL6wBGBVVEiJ4nMOOnED/OSYa3KVwYPv/vh3LbEUJRtbM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921527; c=relaxed/simple;
	bh=71XmAMG7kSQPcKLqU0rDu3LNlR3TXy/Mi4d8UOH6Np4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBsDZhPef3niYuFEtPCAWYAIXQX8gbiyYCF0lsDeMTP6o39SALW6zKZLCU7FkmhYnN5lc5L3PW0OIciklyl3m6MdzWYq2sprzAaCktkBRiBo34jq1KsI+lKT/DdE9svFleMb7/wyssxUgTAXzD/ytSkFhwo+PwKJWGe4rtNCs/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maHhH9q6; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maHhH9q6"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2c2bb447e5eso3111784fac.0
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 09:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742921525; x=1743526325; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uMPCIbqfMGRR3p5gduwt4di87BTfZcS90+uaZOwfLzw=;
        b=maHhH9q6n/5wNhqEx29F0VecM9ifdMopjzZsMw8h2bODllxCa3chVCmgJQKoP7vAHX
         DFeJ9saK8P1vR7f6t01JO3ekkSBjFAsX+BwFqmseu5q85wjYPRIFprTuO/AoM1Qm8EjG
         S51DU70KNEGHMFOzFf6LxDUZo7nCOLrZ3UvDyALQTdJywahtTW5RY5b5uejwfa3R1ucm
         2jEwpRFT6EEoo8cZ08uuKr1sy2CbbhW2vTdHhgt2JMOK2TVGx/6PP5sNGf7KmqHDfoKo
         ESRAfgt+KN6Xc1soR9cYj22lbVevvGeuyzh9Oqm0RikKRXnE/zxQlQZsgCCaTi8NTUJa
         uivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742921525; x=1743526325;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMPCIbqfMGRR3p5gduwt4di87BTfZcS90+uaZOwfLzw=;
        b=MzAq+yVqJymfMNm7OhmqsxCWxtu2wJDlWbTRhHubX4ztvy4ktUFg4+Is08IEMqooUU
         gQFNUvNKEvgxJfsl6Ne3sYSUwVYF5I8QIfBQlkSoVzNcPsKAtuSPeA8hNu6bUx2vKHR4
         RcLuOgsBwZq4g5H2S8T0CfsfYsDw/fEjETEmaxI5IK4CA8FK+MzymBGQBTFnMmT3IQ9b
         Zc06cGqhk6MOABdXg2ZBG9lNM5gh0ol/60NkoGkTp/DoiDdNgRPuJ6U2AkQSXDvayp+7
         4TPLaBYiS0X9G6PDp5BFSb+H1Iv4gC/b4bxeXpWxwax5obDfkXwOlouhxNwuHnZ145zJ
         F61g==
X-Gm-Message-State: AOJu0Yw1Eqs7Ss+GLlDpiQmlPCB7nlKfHvR2QwlCgbPBujlWy9mb7WyV
	w2TnuTgKuPD+5ZSk+hXa+xTVmZxd3MoNSobNnPPNyr4n0jOClw7q
X-Gm-Gg: ASbGncvp6hnVWZONNs8dfAkdndYCttvD74Xo0KLDCWBHm0BYoxvmjJPEDEJ61UPQgeo
	zAZ5HrM0XpCIH9oY2skbuyfNL1SrxjICnGLFQhfKRFxeT7cSlWiw45z3noME0tL5Nd0lkxRo1/Q
	e4VwOQA4Jz543Q7CSPrDCbl7FJ2NmJK/U92MzyUo8J33qLer4FOoxGdwvzlxCxdABcOLLVu7cLq
	X9JRYbqERuAd87MbHSvJBXWBhkETtgVtrI0/9cdstQsAqNVvfwUcNZ8tUKhTey2fL1SJY0snueG
	NW4NaGP1Ge3DkKyYJrWlBm15L1UzbwY+/z8w3HWGLHJ4mcfA1ICy87hrQC3B5QxoOuoxcoWd
X-Google-Smtp-Source: AGHT+IH2rq7Ag9BcRfStByzqB/4v0NbvRkZ0BvFx5kjWsb7902DPmxyBhUMWT877oTh7VU6QrxWfsw==
X-Received: by 2002:a05:6870:b8a:b0:2c2:71f:2c0b with SMTP id 586e51a60fabf-2c78022fcfdmr10923176fac.11.1742921524914;
        Tue, 25 Mar 2025 09:52:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72c0ac7b959sm1958781a34.64.2025.03.25.09.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 09:52:03 -0700 (PDT)
Message-ID: <55d55a44-1a5a-4fb2-adda-87e36c5033e2@gmail.com>
Date: Tue, 25 Mar 2025 09:52:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122156.633329074@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/25 05:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
