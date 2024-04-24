Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CB516D4E5
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 17:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713980824; cv=none; b=afMyL+A6nJkjFMGnYDEI9N+BfDQ3+FEZiPXSsgnS20rREfYa129KExjFHTVJGKmr6aADRNfcBQfRny5adJ4Orxaa9x3qxwwnlI55ZHHzqH6WsB+u1sUKB3nGBolyB8B6B81dhenEEcaarZ8virh1EPhnxZRcPGOZX76S/LcEIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713980824; c=relaxed/simple;
	bh=3ulp/AFGfJ8TKWcjkvSHDpHVf9ob13UZsZaRg2nTma8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MyYGoxtIqU1jT6/d4cpjVnete+px8WvTFMbtuxM++SuQJlLnxmy8NxXvcq/Npn3BJve5Tbcx9Dq0cGpYpVEjI5jRkjp1UDndpLehiWq6uwdX0lRJTWWsgjHnJY2/Z63nyjMOQm2DDUTVqOWTRnSFmXkQDhA+Hy/92IRLkzjxXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjQsIuCu; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjQsIuCu"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e3c9300c65so884395ad.0
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 10:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713980823; x=1714585623; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AX3wkTmJw2SYmJLJtHNaFQxm/J59nt6zUunS82mxxbw=;
        b=UjQsIuCu+GSD/Zi9LQmOBgOaMP4PbGl5O0xk7C82olcjuwONTlDwWDGCQc4UPioKhI
         WziYnO7VK+3RUGN4swqBrRaTGhCgUB+HSQ59J19zrNIC8SD9mCGIL+MZyLKreZS1+D0N
         WwkOPh+BUbmKhVHFT22GutVzmif6c//0hEuW0gHwBBfLVT/G6xJv3UPZ7BmEb9kHG/F2
         4ebjVlxrbZKFvhUp2qRqMRgEFgC9Db/IvUek8DYZr/b26gNtrYZR3HKEXIax8ie84Dy5
         edfclkyQk0AvOUQx4JzTkTcMhyKHJ1H8NYqnVjDSB2Wm8t/gFFhVjkaih4mGeKM+2Vkw
         oEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713980823; x=1714585623;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AX3wkTmJw2SYmJLJtHNaFQxm/J59nt6zUunS82mxxbw=;
        b=NDRkajrUCSeMiGGcPpwoJzeOicWU9zQkiRkp9ujV5md9WAixeeOPlyjG/KdTilyOlM
         j/baWrBgw15zyD2l09ew+Tq3lrnaS95nL/h7mCO37avnw8NUHqRZ0QTxqSdeq/MyzApo
         vUq4SuLw0T8N373LL2cxqQ8zkbl9Hj7bREI3tbg/hRu7IBCI68W5z2S2MP7luM1roLaQ
         rgp84izYxuPGzuTQX2vhkeIOpn3MajN9tppKV9QdNj4xuQW5BV5FyyVhq0GY41QJbGkJ
         MTUdFxxL7rpK/Rv6c3ih48utqbzDudiev7fB3sMR+JsSs0YWYlcbGGWQ/uU8XbHgFnV9
         /tAg==
X-Gm-Message-State: AOJu0Yxl5yLQAq4YSvAOOKbVpqTT02LtfjWkjVN7nkFNPtWVi5ReX51a
	4NGzp3fKpA//6erJqu7qsf1PWeisyUhzDnQgGvl8giLMxiSAZwwG
X-Google-Smtp-Source: AGHT+IGGiyT97MQdP6BJF1NJUmX2poKgH1hddx9G83LT+ayCELDcks7CSQ3RQMz0/xD82c+XzI/4CQ==
X-Received: by 2002:a17:902:ce06:b0:1e4:9c2f:d4f7 with SMTP id k6-20020a170902ce0600b001e49c2fd4f7mr4146620plg.28.1713980822718;
        Wed, 24 Apr 2024 10:47:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d10-20020a170903230a00b001e8b81de172sm10577801plh.262.2024.04.24.10.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 10:47:02 -0700 (PDT)
Message-ID: <276ef4a1-6477-4e3f-ba8a-ea3127edb6db@gmail.com>
Date: Wed, 24 Apr 2024 10:47:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/158] 6.8.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213855.824778126@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.8 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

