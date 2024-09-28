Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF147F53
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727543656; cv=none; b=hz21WR1fEjZZbnbuDFzYD9MlIKWDWZUu/OhS1cw8Ix144uSBX0m5/r/vwgX+YSmyrNw71cJ/+9BZO0bGxU5BAUiy3u4zARLCfF2U2i6mkEhkUWY4YK9q6wIp3VQ1UKBE1LYJJXECHeAP/X+FIdVpOOZ2aDeZcj6kEGFBIH+w+K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727543656; c=relaxed/simple;
	bh=8h0mqtSR3cJMDeaf3gQShuu3Hb4p9VvJuvHRFRnHAPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pl/FuiVPz00s7YI45h8nh13naLWVO6aBvkE+L4gBtlu5/Sn6uQgez2Ie+l+P/QcsMy42Dh63v0uc+cgBHYImyuLcmGu4qIyDXkm7F4uouD2NxnE2yfNZwBaTVrTUwjaUItq8EsWuvd34ZEFznLGw6eK2oGavktMMi2XtjEDvO/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDijGLnH; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDijGLnH"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-82aa7c3b482so116620039f.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 10:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727543654; x=1728148454; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fLNwBHV8ycc1jDSNmRLEZAE/y0F/roWJNJrPGAjRslk=;
        b=HDijGLnHz1/yfa1Khx0ltBMwmqSMF0XkiJxxm8zcWy3224Jzohnxf9avdQtk4WXo88
         9Rv2DZ9x8g70qDGLpS8iUB0vKLTgyeT2J5whXZ3GwnKzQcs9no+GC/CjDSrVeTLsQQzu
         378Ee5OnMdGAQ7OAqhKjRI3KIVt0qq2DNk/5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727543654; x=1728148454;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fLNwBHV8ycc1jDSNmRLEZAE/y0F/roWJNJrPGAjRslk=;
        b=p1N98fo41mp6z+95YwKcex4sCnp81LcB2FDHwvxQcMfhsa2gsebkM2WkolOUEub6Ui
         WVptQFK61QQPEFJl9kUacDSe2NJ+oFe1dwIyv4/jY23/xXhgVVEJX/rumXrno+8nBBdI
         xZlF88gfHOjj1Eo5pDb53gBqG6ZEakhVCulUkPgdJYKJxM4sqJmJAkrnfq6+wHCw5Dk8
         V8jdzHP9VQWl3K1rJKDzHIOyCU3flN6dXVtKQkrXz8lP+zvssQEkgLjzYxpJCEUEtzNk
         KHDeQKlQ1sV7SxQGLcBGjzw1P+6DilKn4lKZKLsqsujoU4DVFtjBi8eGYoUQcRmozROq
         0Dog==
X-Gm-Message-State: AOJu0YwPxpI7dXDNfejEhkbyzc19mKVXoGOv9KP3KhLvdiiqKaUpkvk9
	O7gZn2bVLxu//OQIjpPkj4s+Wt9bBhFCFWAE0UHBJlBudo9O1WvURMQOeKuSk9Y=
X-Google-Smtp-Source: AGHT+IE9RveJoVWD7x2Ya2Bk/5CQLau7MKHDHNVEjxKmy7eCb4AU9uRuLzGDwv4IfvytwQOrO/ivTg==
X-Received: by 2002:a05:6602:2c84:b0:807:f0fb:1192 with SMTP id ca18e2360f4ac-834931ae42amr706616839f.1.1727543654576;
        Sat, 28 Sep 2024 10:14:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d88884a6a5sm1185351173.43.2024.09.28.10.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 10:14:14 -0700 (PDT)
Message-ID: <7343743c-c44d-4dff-931f-80f782634fb5@linuxfoundation.org>
Date: Sat, 28 Sep 2024 11:14:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/27/24 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
