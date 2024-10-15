Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B001B0F0F
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 22:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729030894; cv=none; b=AMge9GzHHZ5C3OojUww4NqIDX5sm9VoefSpotBUMvUrkXZdfVYmiKErQplYvUamWaOngoriiIbsSqsSgw2LKhBBd2K934wwyanaG7vOlBcD6gjPzB/mBuoCeiFGIlDNWhbNDOMY2G054hfKlMt3Ty3gMnectLaRN0+e0ZNhSXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729030894; c=relaxed/simple;
	bh=ltQMRIsXUfjEPweA4ruMh+CIceGsnMVBfbTkfwieJUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LTSKVbtY9TldKmjET8KSAaaKL/lVrpnY9ilfu5tiLkcjwrdUIBGCphx/jWQOnd5h+77CJsGmGGFVbZxCkQZRDHJGorrHpuCKSpATMtEYxB74UPVTQylSD1leTi2kP3pmdliaJLvDnTMZgLJLhyPxYTxRncztkm85cdt//xTk8EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArFp8a15; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArFp8a15"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-83a9be2c0bfso5672039f.2
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 15:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729030892; x=1729635692; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TNv6EpUkF46yC8CnPi4D029NeIjdWSFiLY/SEWTCkiU=;
        b=ArFp8a15aS4FMfEkLfJZ5PPoj7qnjkA04WpViGBPrdimm2fHc899KVmuFGVeG7AsC/
         f6MNDUSOsO/tFMfmSJGOUn9O9jRo1HxMKKqw5uUOCGOJCq2P4mK1QahvfgT2WvcBgJqs
         5NVFJt5z4dX0CthlsU4dJpHspZBUeD4LSqlAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729030892; x=1729635692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TNv6EpUkF46yC8CnPi4D029NeIjdWSFiLY/SEWTCkiU=;
        b=Wz1OuBnj8rkYmvE73m/ypUflR4d2vaD4GYAPZckHoOku14n/09ju/Xz7RdP51UrX7V
         +vX9LLrQhNM0+Dc1v3iopbycNWCHjBqR1GZRhknyTMzWKLmf1I8YASXcCcHrUFP27Uhg
         zeJBxlLqYwkujHdkf93VN/0eIEUwZN5sKEMA5CyhVXgNJ+ZJoAL8z+u+GOWVbKMgfwF7
         3LZpsux7lNplHXOofxE+MiXoyOLYAtXmK1x53R09WccI0nQAKISGBGQyMthPAk7UhUbN
         SXE9yvanuWHohiNIefEXZhnZbhPA7z0mvx8H0a04Z1S2k92zb1jVa7BLmBI5lJVrbphc
         R8+w==
X-Gm-Message-State: AOJu0YzNp7Z1qvFTV9hA6eGOObG838J9SsrVZTh+8yvCusXFzfTw6394
	XSCZiqrfm6c0RrqgU4QiHc+VNxOHRnDGNUE4jlK6Ay9vBSZPz+XxtwpmzUQ1XCg=
X-Google-Smtp-Source: AGHT+IEaclnUl4KoFETjKApAJu24dk+GljHsnn/vZz/hzAdpQuBIfKEIAYOFjZjg6nfn/buMaj3f4Q==
X-Received: by 2002:a05:6e02:194d:b0:3a2:4cc4:cfd with SMTP id e9e14a558f8ab-3a3b5faab6amr157980805ab.14.1729030891827;
        Tue, 15 Oct 2024 15:21:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbecc6a612sm521449173.162.2024.10.15.15.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 15:21:31 -0700 (PDT)
Message-ID: <cb1a9ce8-c84d-41d4-8fc1-ef7d181af1e2@linuxfoundation.org>
Date: Tue, 15 Oct 2024 16:21:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 05:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
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
