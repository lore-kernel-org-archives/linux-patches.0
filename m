Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF3A225A29
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548879; cv=none; b=Ss7yKG5P+pboydYROnL1MRZgiVGfsf3X3Q6g4ujepbJnNpVa+1RisI5bZ1APCSvcQ2AVCIl1yHy1QoOfop9+Ek2p4jTduhL6yZUa9tlH/Zv5mFzKrrtFWxfvhb7ZBhyaDnUxkYP7H8EvJ64m/ATNYHlBNi4cFyle1Ts28mLh4Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548879; c=relaxed/simple;
	bh=hDooSJaE5aEbmAO+pjBnSTkBESSsm0eOvdKkpZB3s5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kU1rQnm7H5ptueppfTkXMq+zFcupm6D2S1XfUMn0cPjKzigrymDraJywyOjsGSlbQsAHTCBygGMMQLged7qQ7gQMp+98yjtG6/ZTqsy2wcFWKm3bbo75+DEOHwk+6D9551In8s5qPrlLwQQa9tf534bWuYwf1aO3fyeNkpa7pE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx1flWOX; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx1flWOX"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-88432ccd787so290628539f.0
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 13:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755548877; x=1756153677; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hwb/sGg8U9KLGwojJ2PDXhY5l4YEOf/IhW5l2o/KSE=;
        b=Wx1flWOXCBkKNG94NlyONiV7YVcvFQ7MyFA2jjee+YXh94VaaL7RJpN396FP3S3jiT
         0HN/uOdmg6oNDFUd30bCanGBVzkeJsQjRjzoAJ8Cr5z7PR/7Oxk5rjiz/X4cxzGj4lwe
         7HBmILccUpkucRFbRl7lCsDgCUIkXqJBdGfN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755548877; x=1756153677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hwb/sGg8U9KLGwojJ2PDXhY5l4YEOf/IhW5l2o/KSE=;
        b=o2ZEOeMIhiDKfj1A/KDCzRZPMIgPzToGeeqDn7nBHdYVL9M20a5EvcurhVsbOG8JPl
         qdh8zyeEBgFc1SyR9hYtAX35A2UXBydNwF3qhhVJflv2lPETvLhzcLv+HSH7fXOfY6wc
         IaS8vGtpAzcoZV9GwbQbEDq2YaSqp5NOhUge5nfL2aYJH2kspadlsqpwHRnhGiYpWrC2
         vDQnsHq3FltHVWn92pKrvdFxw2fHK5O3T06YVcJ+007oscj+in7CncjsLfpfAyinGQGM
         Hn4hFs1Z7svd2y/Yh7H/zxmmFvNSWcAmvh30DEpFwV/nkOnOdd0om63vDl3lqHPi2EMQ
         Hpzw==
X-Gm-Message-State: AOJu0YzZSDDznD0Y1nXNtISoOXj2OR9SVtDnfMS+H0WQiB3z1MSQXeYL
	v5xzpm3EnEJKWKoC2aoNWBUBF4mOS7/EepH/IPfxojaAGIP0EgcL/IC3DBw1FhH5zkg=
X-Gm-Gg: ASbGncvFv62iltfZerBXqBjwC97WukaJB0zdjhCUQkTwVplMSebUVHypa43a4Q1jNpc
	tsypTaKAeg76WlUJUGJwXu+Ln6uD0NgayRCKAM4OTW3BCB0inomubI2Mrt+YEOj5YO6K4syB6tl
	B6W8HhcTr0zdyEvg+do4alxldUdTl6oMP4vRl7BwuUslE3JPsMEH+d1hCOF1IBpZxox0rCf7G8/
	juAqtJLr/irnCkj5s8/3XTmbf8U24PTrbImFgCkbt9rBcO7b0p9FCt9Y0fABGnUMOcxINUiLzym
	yGOCrGv6Hb3NpZ8NBsS/2jr1Q8sZvEpx/cwKV8Wy3bBtifCLcTXhinGsQXveAVfBBWkBfrFBzxb
	MKk9vrKKtFAXVxwsWu725DVGMQAuYoR/GFSo=
X-Google-Smtp-Source: AGHT+IHZEEvzNoKlVVqwlC5w6deqnH1DrBO7M/07loW+8EGXwxTGSXrkqC3Q/AULvCwD0f2HNqrD6A==
X-Received: by 2002:a05:6602:3fc1:b0:881:85cd:d08e with SMTP id ca18e2360f4ac-88467e825c4mr5673839f.3.1755548876979;
        Mon, 18 Aug 2025 13:27:56 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c949f7a37sm2823835173.78.2025.08.18.13.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 13:27:56 -0700 (PDT)
Message-ID: <e8442465-7ac2-4c1b-85d1-676ac5c8fb8b@linuxfoundation.org>
Date: Mon, 18 Aug 2025 14:27:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/444] 6.12.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 06:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc1.gz
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
