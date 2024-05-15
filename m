Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E8113F422
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785619; cv=none; b=kmElSDlBaUrJpMl1bN5tef7Yd7pzUgV5CvKVHPUiGbmldpqxAHCsMkiAxNAsjNRN38TbRUqJHMvIx160NPbzTKGXTU+e5KOs1dwcO83CcfdKs0NZXs4ZUZT+DJJ5FnmZnrpRtjoiFX7sYb8u8hmxGOhB+snimfSA2+Bzuc5Xe5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785619; c=relaxed/simple;
	bh=RIAoqjM14Fu2GXpQuniUrr5udioxLXnLSlEc1B8cx3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGyU3GXqyGzN6Mmv09EZHPEKtOWaQX/fF6NsZWs5BXcYCMS4a211jI2iCXHUIiGbUkzga+tsnonkR6O+s9mY/rDW40uQjOwFXco1O2MhqzuqYP37OTxQv4ISadqSkiR7h4ngYgtNGD6Ma2gcMyID9DfkYwh8q+HfMxrOh7X9HbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaM37Qo3; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaM37Qo3"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7e195fd1d8eso57559239f.0
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785615; x=1716390415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YcYN10FfDn14US5p3x/TxdGIIki13NwqcWmNX431Yx8=;
        b=WaM37Qo36X6azJ00CaXsfP+eVUrUX1wLDLnxng/OwVWDYAdCxy/mMCYFzHYWzgrjjM
         QMBZjMGIATJr0+TUjacuJr3pFgiKX0mLo4hJnHsTHEkdPHSw/pdLk/ZgnUSkYmCofVZF
         KHR7+r0exWcIlxbRGKqbDjXtcSf4kIGZB1oxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785615; x=1716390415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcYN10FfDn14US5p3x/TxdGIIki13NwqcWmNX431Yx8=;
        b=k5vpuI0xtQ6spXTsKyzsMZrI0nb8zOBYgbMjHHezwCRINiS9tAZdtq0lPL2ByJRwXf
         IAmY67Y/hGWXkX6C3QlX+3Rs8pWbzkCqKjKSBqicAQtFgL2z9Q8ZudwHCIPeMgaHzJFK
         EYXqABBTUoi7DQZTjIeYMjqNlkl86/guxmtRQNWYumdW+TcFvxHhDFyliLqF4HHYK8Vl
         HXhuRwsiU/4S96lgd0BZQL1cwAtP6yi80yNVd7z3BWRChH0Ful2r7/mRlsJa9/hzbEAa
         3PMvSS102Ix6nAh6Wvaqi6aBea2bS46h7MyXsUcZOq42Fqyj1P+k+Wqcbpsm+P28BOqw
         ijOA==
X-Gm-Message-State: AOJu0YwE7Q+4+/igYS+oUi7zcVp+XB01V1ZMNE749uk1CFl+phBkW5l6
	lRFSXd+mr0onVQxq7iGctLrUkS2/JbHYFFDhpDFX6+Z2T5wFVvVnPTChr1RdwYM=
X-Google-Smtp-Source: AGHT+IHswPwsFnweSMcvLm+AWWS2t1fafeIrDiKAyKpwgDgiLQqvE94t9I8Os3WbhkkDOZrFGH3Ucw==
X-Received: by 2002:a92:cb0f:0:b0:36c:532c:d088 with SMTP id e9e14a558f8ab-36cc1391118mr158636705ab.0.1715785615724;
        Wed, 15 May 2024 08:06:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4893700e469sm3634804173.30.2024.05.15.08.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:06:55 -0700 (PDT)
Message-ID: <97dec171-048e-44c2-bf19-7d1a1c8694d3@linuxfoundation.org>
Date: Wed, 15 May 2024 09:06:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc1.gz
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

