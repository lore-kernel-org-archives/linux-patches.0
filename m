Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076D3346FBC
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917289; cv=none; b=AbbfS7UsiDDrK2nmaMJ2xBUaOHv2A/5MJV6sOtjLMq7ORvHkev0bIAIBRXkQAjOwAuQLWIZ/J7Oz5URLES+/YJb7KwYI8f30XyBVlz0M57jkvCpdGRIYzZ+RByx0G3v8Y2vh1V4cAdn2dNfvXADFlnMmC5weAqXGi6XObwdDWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917289; c=relaxed/simple;
	bh=JCnhFBbhjyM9ZrSTljHLt/ThXEo19Bb1KFb5dj2QrHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TPwePi61Il15sRU7ClJ/0WmlV7A/W2hRi6vaeqM4rMvW0Ch0/9Swf0eEHCquAPCqD+ztg0IOmOypXzeHckrX4DDlLJ8BLrgakNqx+NnsUAR10JQbcvdpCIU2WUjYnmErqWmDN7IkUFwoZYeRt4ZqOT2SMqSvjkKEayV1tVYenmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hk9d6YXX; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hk9d6YXX"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6913fb25322so2554668a12.1
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780917286; x=1781522086; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AlrDLQ7/+KQQkyc0QSWiYFjNtmvk7yv1uaLVnyP4as8=;
        b=Hk9d6YXXdEJZEaoIdxqad7Q8YbGmjSTfE6TfK4BjIIPgcBx+LnwuwkTIeu+G2HeJob
         5mZKn3RYExTl0kfjbdD07GsMr5IBIcgLoCHr5qINEnVEYMDC1fTGKXrCRFBAkH5djUO8
         Py4mtkBxaU440oEAa/TvfzgSB0ZdzT2cN9ZEJmJClaBVmMYyFsvtZCq1Ew0VovqLD4hC
         b+xPc3ZTvdlHcrEFX9qqHpy0N9cH2qfSB2FfvHkExE1BJGm8KounNDLJPjNectmtt9Ve
         2hj5LAitqLPIGamZ+/hjQgAe1JFV57hbqVoeLz7ZxQUYSQX0xKH2vJlfYvHJ0E+J981s
         mZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780917286; x=1781522086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlrDLQ7/+KQQkyc0QSWiYFjNtmvk7yv1uaLVnyP4as8=;
        b=ami1/QBSZ8JPrHv85+S12TGkS3V7moaEvh5J7AuX2rl8aiFqrpZU9yUyfrDTEtHkrH
         /NGxre9YcmUjj2NMITGo8lefJjsys/oEeOTsyKcWVViwuOl36ZXy/utiLno0ILysm1JF
         3bSfV9z+ffCCz+LtmQCkoA3PVVwh3rm/4JLumXzfoSxl7ESSV/iR3jA9b3gWNGz5+QFC
         Sa5lVk8Nwk6v/4v237UqDbqaCg06efGxZT7nftoHpEvytbdQb1vJ6SocmaEco2dNOhpB
         jB9CYLVbpx2LpBaeUjv52wy7FFK+Qu6EmX91BRUCcDo6ufINRRcAJW65ypn8s/gJcJsV
         XujQ==
X-Gm-Message-State: AOJu0YyPZrt4fP8xm0kB1L/UxuEUQunEE7HmdZhWt07p5kQN+YbQTXrN
	k+TSOHYcM/Z4kXn+9EPimxrmSICcpZHfffOiTic1Pznx9zFWyTsEgu7H
X-Gm-Gg: Acq92OF0WnE+px+fi4H3TDAKOhqli0kcPJy0sBgm7HIcK2X/e992M6NNRXBK3QOzOjy
	mAz1jC5339jR1/k+Rw07ww6A+tGjSLZUmrZbnJWtHMj9DKsPUkjZGX3jRP54any24Ydaph2YhSj
	6FjcWJLr70t7Q53ViufVab48qtXfpUeGGtKYQvjkgYI6MLS7YEOi/bZHMdugDbL6geiWfOrE64I
	zENCsHCnTxembLEtr2ofpxXKmyM1fCabNoMks2ZehhbILSOmgVZHHp3xwapQ495iaUTiKq0EIWV
	vjxFTJsFbYFnj46TFm9ioNJl4yK5as+t8+HzPXM4gmtwyq0KijIQUXMM+RqQBPo9p6u7TLHVoPB
	lqifRJ1VCOQ7KalGmaR1l8ds1HfC8SIM2kobzd/jzoay/wJZUd5zKJtKTHGdw6mTJ0/Pd9z9zR6
	ZFC35cyTHU5YIOwPvbdGyGxoLie/c6IUQDRK7Viok2w7dPP6aGP7hjvzTuOZhcJ0sBz6Hm9jLn9
	TrxSZ7yRJMSC4PzmqzXsQ==
X-Received: by 2002:a05:6402:2808:b0:68b:f026:f382 with SMTP id 4fb4d7f45d1cf-68fa4c00509mr7207707a12.2.1780917286260;
        Mon, 08 Jun 2026 04:14:46 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e650287d9sm7167414a12.12.2026.06.08.04.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 04:14:45 -0700 (PDT)
Message-ID: <6faf06f5-541d-483d-a7d9-090fb0299154@gmail.com>
Date: Mon, 8 Jun 2026 04:14:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260607095728.031258202@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/7/2026 2:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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

