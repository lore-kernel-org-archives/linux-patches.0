Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A51E32CD
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110077; cv=none; b=dumQV/SiUf7OdjrLGIyVmMRStRpQ3fcjkiZeUH06jCVMfDau3pyEURHo2CQdgD+2QKzEUPjRNoj2WNg9LJaBZJi7hcsjQXy1i1hnGYutqKdGNFw8q73b/gq4z6vBDP/13r3BFO6rZwkc7avY9WtwOFIn8NVHbG4yfCScXJirAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110077; c=relaxed/simple;
	bh=nEQAJ7tMAVKoPCrSrHaaafwI82XnnJ+HSEY0wGbZcJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nT0fgxvu5gkV/LlwghhDf/EeYEwcyBU5TgE0jIr1Gz1cp/0HXWkVhcd52ybaWxY/Isw1mvuJ2utIEDKX5gp/A/8hyXHbHWuho3aF99/6q7FQkvKk9GFvpdYn4gNMDGLqVAmCcW09L7RH44CbBp6TydvuH4Sbs9JIXbiwXzp2iRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkrhzpTW; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkrhzpTW"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a9cb667783so15778575ab.1
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 09:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734110075; x=1734714875; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhPL9NYTRXT2OymQSUELSnul5634w4kN0UX4t+krxe8=;
        b=UkrhzpTWte0G2Lv31e5GiH+q+88Tokp8XymA0R8FiETT88sggEoON6y1R7epGmVUWe
         EO8Yf+ueVg4KwscJZh5QftjKp6ukRQL+PmrjM/aZwNvtsDu7gFENO/AguLOe2bxmlLYP
         JzTfnet+X1w+4+DtjdCGJMu6p9Pjbu3QBnpuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734110075; x=1734714875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhPL9NYTRXT2OymQSUELSnul5634w4kN0UX4t+krxe8=;
        b=AWKJCiSPGcfGleImFD/bdhQRBA1hrzKGsGbYC1ph80fKAQbtGWbyYkUaN5k+JUtpHm
         lu0dq6oQdSURFKIYa5p/oeIlyXQIUrj17fW9h8FxNfkMIbXZt9xpofyzqA/p6ijI9G2k
         oVyg1BZm13aQ0NEoYVddfRS6vcq7SMFjkf6+TB6zdgaT9Jb0+443N/RF1L7fJDFHuHkS
         DnRQcue9OG7milNtYcZPCItYdHt7hRGPV0I9CVaXMrOWp0cC9BwG33m6lm9M3U9Agg6/
         WdN25iAE43P0o09PCKVAqHmrJ+Pnh21VKG06pY66kCeCpZIRK7BjzWpK23sxDhVRHCqJ
         xjHg==
X-Gm-Message-State: AOJu0Yw126EcDczNbia0NNpK5TG7ri/dr5tj/Zvi0ZB1HPeOKkH6bCSj
	JvlGvFblBxdW2zgKvMWLlzHE975Juhh996LplaEE+oSyiHYS7vTfs+ec7Wst0YM=
X-Gm-Gg: ASbGncte5yVqlvAd82w9GzHOf7P0zHLc3F+oIGXLyi65zwLK90Y8zZIogr56CP1i7cD
	QeInORgh2WyM+UnsaMITHi6AK5uHchAwgbYkc8vXlIw2U9toqQMvlXbiA+al/crCj1bkp/PwEl/
	SY4v0qkoZ++BIfVnA5fM1vqSNYjUTwMmVMSBY8CvF0KwqWYHmHfi8cwdd83mq5tI65I1TJ5MfJG
	NaHlqxe6zVbrRtLE4JR28z3a4ljbwv/VHYDGKyx8uVAlNJSShZoM5GV2tL9U0vVe1DG
X-Google-Smtp-Source: AGHT+IE787W9PHbVdoivn28P7E8AqG8a0BDD76LSQQ9TR7ermXtOOZEn/BIwAAOAjlwDZ7A+ZBGldA==
X-Received: by 2002:a05:6e02:1aa8:b0:3a7:d84c:f2b0 with SMTP id e9e14a558f8ab-3aff50b340emr41233965ab.8.1734110074882;
        Fri, 13 Dec 2024 09:14:34 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2c835a054sm2288061173.77.2024.12.13.09.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:14:34 -0800 (PST)
Message-ID: <b71d9339-4b5e-43a7-a728-8016daf4a90f@linuxfoundation.org>
Date: Fri, 13 Dec 2024 10:14:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
