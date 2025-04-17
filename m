Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2BF14B092
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 19:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916805; cv=none; b=cB7ie4NxTjhWqihhvJEOiMz0c1XI1JaiCQvUaYpKZeMjPi0vBqcsiSh2B2FWR9cm0fupHtj8WE3jFged6lfUWXmBfBYZyA6nOCYmraQk0TfNhtl+58IVKMjdz2f8sW8l1qN3MJh35XsELogvUcRlcZMvQ9aMUD8XGnkxk+/qh5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916805; c=relaxed/simple;
	bh=ByZwBqIg5e3XnAXpT5I73r/KjqgjylQ42ZXJCcxAdzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgtbNZ+jO7o8VZ4NmpVif1HuUOUwEYBHYLFuHG8ZibZ5DgWzF75s0t8m6epsVrGSTz1dHZgg2d0S6rxSucUykiuhKecsbjgVtL4J75R/sZy+fe+FfEVs8uvRjUMvHNiVFg5VsoN0cWQBxguiCz8eA2Aj0IYLzUg4+n8oLMVevIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMBqpGIE; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMBqpGIE"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-605ff280d1fso59862eaf.3
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 12:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744916802; x=1745521602; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PFe7ZTlW2N3/FAk3pU9QpPLTiImBz2Mq0lgXmwMOuPg=;
        b=SMBqpGIEFhWMTBRwZsreP8Tu4/kp7U6WBlOS2MVXhwTp/ayYhHUXzwrFVLQ4yhbkLF
         mUWGSq8CWkijsad6lmkTWfEE9tfcufO3pyauyUz5CLrvBLg74EcuoIKtSvOCgyVPyKrs
         IKZ9igKIVMn3GwY3vHGtgdAk2JM8nsCQzpZslnbpZ0/bUza0xmPnNs26pOjCfkbAaD87
         cct5VW5Z8LDG+H3EW8QCXX/2uV8xgo0oRBAW1IGE4cFORxgy5M1rasEuPDp5ikjctlpk
         6cBThnCbqzz49AMxtqA2+ho5mnbwp7g8HpR1pFO1Mq2DMOj44N4+kY0rQK0wvoPGui3n
         wpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744916802; x=1745521602;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFe7ZTlW2N3/FAk3pU9QpPLTiImBz2Mq0lgXmwMOuPg=;
        b=VuRWli5r2UuwXdO4lfTgvlBykjhWUQ0Y01aeX9b8bZoZwO9TUzeQP/5OKHvad9fjxV
         TXLAnAo8SXZmcps4SBkZTuXr34twybP3E3JJ02wsCp94BjPjlBfVd45tjFhcJdsAdQ9d
         cGCVJ7siJVaUeN/HVSk2H7uUwkDvdwRBeHu0O2TOmCo6I4iUgWq1/ItE7qGGt41UdwSZ
         hvXognlxaihzKhK8xHf83KcThc0WmNE7zrSWSVG6+5R08MUS0SMC8rWU2M00KJkPvdXL
         JOR+I+JUOBxEmVNAMW+a9ZnU2V3/YsxFwYNntxzns23tcUi3nX8cL9+PsONE8AY961ws
         pc4Q==
X-Gm-Message-State: AOJu0Yx5mPoWVRgCBux05WWB0n7DEX9B1sVdVK6V45GXZNrZNJOResQs
	Sz4tEIlNy9ltK0Ofp/gPJ6sN80Tfz/lhGVE/ccLNilykk9kNdQJN
X-Gm-Gg: ASbGncuD3zId3ff0pMlxl0YkruWM1+ppMNLjwyXa6pkXuRamQjWU3Ya/G4RgzNtp/9u
	vHaEkBpLSclfY31rBVsgK6slsm61qdo3hClAE+SP906ZPYvxJEyClnOuyly4Y/gMYjsQiZ6ScET
	Hu6ZMH2F9h1yGGF2zIQ5yG2koOpZiMlVxGyAK2RHVeyNcJL4ED4TDUGnTDWXRJfSZ62VTlnhWmx
	NzEgQrvZtuSnZFKTmgLR93rUp2hfUUxI4tfY6dVnm2kx/vbgjMgGY/9b5A9C7Dv59OfmexrDAQX
	rCZP5aSYXo7pC0voLGIFjSm8e1LEvDhtkXF9t1OCL9II+Mi0PtqV+mBBhxMzylOJWw/V7v5YcQ7
	e864=
X-Google-Smtp-Source: AGHT+IHnGMkh3VLrU82vM3wKHWWuU+xqCJ1Fk/cIJGgcQl/DOP069V1QDMBCLRmh4Mz5kJm4xrmWQg==
X-Received: by 2002:a05:6820:1ac5:b0:603:fd3b:aef6 with SMTP id 006d021491bc7-606005e133dmr80554eaf.8.1744916802546;
        Thu, 17 Apr 2025 12:06:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-605ff69ca14sm69247eaf.26.2025.04.17.12.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 12:06:41 -0700 (PDT)
Message-ID: <1793b939-7669-4e6f-a7be-6fa1739ae570@gmail.com>
Date: Thu, 17 Apr 2025 12:06:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/393] 6.12.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175107.546547190@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 10:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
