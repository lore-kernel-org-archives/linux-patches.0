Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE61E5019
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 23:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291745; cv=none; b=SMW3yYzUB6CdBMCFIYiTP29jOGlcAFy09kOLhdecoZmpdr2rka8Tu77SLs97kpXg/NfD8nMvYiZMA5CXGg/dovSsPJQu9vaHEXR9WpeVLZdWHho1e5XY6r2MurTQLeHuZEsJlGTJq9OWVYXWIiP3mKL3FC7iZ1q1Eyl/GF6XZaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291745; c=relaxed/simple;
	bh=rZ+dbjJZOGaD/3tYp/5lJJYIprZg2k1S5ZNTgUv5aYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTs/IpXW89QTrX5qI9TM+fgySAK620twJ1nU2oSx5yyrI9HtoAHoTpaqs1rYVyZJ35mPUrLED5vy5kilfDe5G2v19vzAwmlsF+Xb44uvl2o8WwjFSDEdyV1CGJ07/42e/YtZ9ygb/c1b4S8x/HKdCwyxgEl+z5VM5bvrXCHZvrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVrn860Q; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVrn860Q"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so10931139f.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 15:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736291742; x=1736896542; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AOVOoOK0PrX/4VQ/PKrEjNAUqBo1PTcmPcjUND6espk=;
        b=bVrn860QKRU+GfiDHlK/8XPr9vWPL0QwTZwiVO3t11Ezl6jRGuHoQUkn8DxhZcjiZI
         mBqTuNU7C1wOFpMTOkN3A0kzDrcxXur7/cKacpymFvPEQpK5PFzkJwqqizjt9Po6om8A
         O4iN5z9r+1sDpOdCDUlC5DTzvkBESIO2ssS2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736291742; x=1736896542;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOVOoOK0PrX/4VQ/PKrEjNAUqBo1PTcmPcjUND6espk=;
        b=Hj4tOOuEggPh/d0ToHs0kRj1QwVwBHe36ERWRqx+n/vGOORzu6+i13G3jD+6uhgKAL
         t63kiiAoe9GovHwChMY0ie4EFVtQSTxA9Wy7SNFuO2paqb/NNlmi2JyhT6/CvkqcAAbo
         h59E69sU7xOdynlSGLjZ63aEmhOQn8BEeDay3psCxvObzyLnbDjuNpX8YO4ZCAiWjVhJ
         cLPayKM6y2dwWdTFc2z5yQ0Pr+D/mC/gJ7gHfoTYm9e+kUqpgMgZQtJbTEivYGdpGOyL
         XXhLtNven3z8GwiCgz2l2IH9QUX+mvs6+Pbj11kR7zd19Hr78BLrdkvwK3NGU9K0lbOz
         mA4Q==
X-Gm-Message-State: AOJu0YxgoNoF3IMZFyEaicLrF8Ea9cQDGL9SVDJzYtCfa1ncBurB2yV7
	Q8XYL0I2aUEexJq/O0+xJ0PM0CooHNh2b9E8jQIsR+HJdCN7FDW+GxomO+jRDgE=
X-Gm-Gg: ASbGnct8bifdwrKZ/niMdTP6XEjXrGwa8DOXgyrYC+VQxjgYTQPOCrgnk1nLG3bNJoq
	sE/WI3fnASyB9jovvRxpIn2qEcPQX0mDnF5Fm44Zrpi7gKzalLqeQOkgu5R5R0lmTxQWUIiOaHi
	FxpuMoCc4RFtQXkm2QDTT6vHXWf2qL4CHcr+yYkyJ8E6Q4r4bLXaki22X1xgOEwVmE27BB5PKnu
	bj7Z1SLWB3dOQyxfHYze+jeop2YkqoBMxFtsujhxINAQCUphr4fv4BJr24QLNrBCVqA
X-Google-Smtp-Source: AGHT+IH9Y3yDWt7oTh0Kt0furL/kOQmB4xXav1icdCWQvy60uXpUeqxXxeihohmaWGsGZoRHiDBKng==
X-Received: by 2002:a05:6602:3158:b0:83a:943d:a280 with SMTP id ca18e2360f4ac-84cd2d7b531mr364003739f.1.1736291742371;
        Tue, 07 Jan 2025 15:15:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f410sm9826755173.4.2025.01.07.15.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 15:15:41 -0800 (PST)
Message-ID: <4e821b52-b372-4a27-b8ef-a87a57ac18b6@linuxfoundation.org>
Date: Tue, 7 Jan 2025 16:15:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 08:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
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
