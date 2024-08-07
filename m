Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B0D1487E3
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066677; cv=none; b=qLxsyOM+UJ0ZrH8yeJcgecojBFyrD6FkZWtqYsCqtLWcQIB8uw0ZV+EuaigH2RmKyFVT3aUTRVhluq7FwTMuYxatwdoOWO2ubK3nPPGQobR+LbTFBYMGec05ER3SzcgJfbMHVpniIGYAXvhadud7X1tAqS9BM8j+Z2tmqdm/2io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066677; c=relaxed/simple;
	bh=bPAE0jN6OxJyf1bhY509issRR1SkVegadOe7o/gDdwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OAeCHc+yxqwJKBB2tIfP+vlAToWaALSq387SRbaDIgW16lU673fZh3dwgh30/EGW57xMeCFs5IxdKs3Y0s5jYZ+HsrbwUQ2F3RceoT4TR5NpY/5BTmf+4AkzsS3u3Cj7WA65keihSkPazvKEHu7c7icuYGqVNAeu4qZT4ID5pkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpR5K1WH; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpR5K1WH"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-81f902e94e6so2274639f.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1723066675; x=1723671475; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aL0UiaVBU0BhpVk7/KjwpvAladn9QhUC4pdvjmsQDOM=;
        b=BpR5K1WHjoW6zc33yZfcr58HfrE7XNtNyjOOZB6CDaBBhKKEwjgqcN7KnxiIByPbwX
         JktsFPw7qMIoK9yxuW0br2gQLNoFHNi7kicQdQwrkYysK8RUyT1irpBGo4OnTJTvlONL
         8rnZAI+CoN8kVB8Pg3bCB6t5UO+i51HHZvKfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723066675; x=1723671475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aL0UiaVBU0BhpVk7/KjwpvAladn9QhUC4pdvjmsQDOM=;
        b=s4/05eafGqH5TWxgwali9SxAvuKh/LSftE7CG0pwY4YDclWGoRZA+OA5umkqzWwxwr
         oqA3bwOMd4TpHUsIjrk7LFUe+ImO29IV6RxXbo9j0XTZukHoisryPSE4PR6422RqOSJb
         c982v93uPyQERpK5/VUqqQn9/h+qa0AhFuJF8ZNBa3T0AX0sSH9JswiKVrLprovcF+rL
         DM0Ym0BXK6U6UIsGr76xkkQ12SkuTCs+FEv8Va/aUjsDlKrbagYlHfRRb4nI9BKKHWnG
         pQC1qme6ZWWtTAgRACibY2On5affWupYSRsWvDPmF8vcW29vJ0m4zN6RE1EQRetGTiQr
         YJPw==
X-Gm-Message-State: AOJu0YxPGSKF1RvlA7iRtN8IE5MhbBQEWp3zDSJQ4P9wsA0ESeJg6pG8
	n+KjqcYwZnZiCbVa5+R9QuqLHoyttq3ascqMNPg02BhDGUHwhp3R0cfWMcC/3l8=
X-Google-Smtp-Source: AGHT+IGVMtn7MiaIscoViwTPglpD4M3uStUn2uXYBT1vHi6PGkJW0BGpfdtdKAqOky58jq7XY8dxxw==
X-Received: by 2002:a05:6602:2158:b0:81f:a783:e595 with SMTP id ca18e2360f4ac-822537e8030mr5124339f.1.1723066674772;
        Wed, 07 Aug 2024 14:37:54 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d6a34c01sm2989918173.119.2024.08.07.14.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:37:54 -0700 (PDT)
Message-ID: <045f8971-09a7-4b9c-b753-d991acb6739e@linuxfoundation.org>
Date: Wed, 7 Aug 2024 15:37:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 08:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
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

