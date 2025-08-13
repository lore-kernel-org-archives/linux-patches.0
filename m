Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96E2F83C0
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097640; cv=none; b=GXnxnostAuAYBZ8T19zcXq2e/m/hUXJ5fFvC7cFCRibRa6VJX5YrKEVE3+ojLKAbwi17CGONxrli/okB/fVH8fgslscerOgb6n4xs2eczTvK+0/36P3QoRuYZ8IqEDAxAz/KGi/lzcx0FoZxeunNV5XdSsU6FnhHUL20txXXPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097640; c=relaxed/simple;
	bh=8r03NX+r9x2k65wyMt7AIvp8WP7OUAczYufIB8H2A3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sk3jqUHTaXclsto/knE4brYPY6rJm7Y+nEL6EV1smcSnw72e18wFVjlO2wVay60Iub0j3y2cPNB8NkzbrUFln5VpNby1EwDpDmROuFL56sVDXu4Bbp7140csh8kIBNp78zGNsyHOQmq9VOuJOkIxFEVmN+HJOXP4PiKlZOTVzaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMS2s0vf; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMS2s0vf"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e5328231e6so20997915ab.0
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755097637; x=1755702437; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BES+tZqo2SQDVT+JlFy01sjWICy7VQC+Fxe6pE/Yt90=;
        b=DMS2s0vfVfFpMYRCOqh30+ANoriviDnFeXWj8hB1+y0xNhOH0apasKzXWRqiu8s5E6
         1nvfLGvtS6fyOZk+yVOaVYTuxeveyOjLzz1Xj79hmul0NQyeR9IZETQ4L8lSRVbu0Onp
         GNGBbb1n2PFho21Gjq6oTa6wx3iOd+tXO9LtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097637; x=1755702437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BES+tZqo2SQDVT+JlFy01sjWICy7VQC+Fxe6pE/Yt90=;
        b=qZk1Q7nOAuTQruYZNAOR5zCg6qQMwRgB7xtkFVw+KE3gOCHJLGo5QLz2m4aOXLymgg
         Fp4d9vkQJh30auxNK2sO0fHsQp8pTMQtw3oUFDczicUN7Ghz3bXI0f9Gpcvc6K1tbynv
         y++novPvT8p6tHwep3caTqZnMt73qmoNLGEKzbpNb+jVLRrxQkou/l8LIswRvLCDBFTB
         NPcpyLg+bUCcO0tavy2rcG9Ka2OjT6Nl+gDQuULfOth79ATLhE1cqa2H6L2M3QxBn0GK
         BJDirITnMb78HAoWcGsgnwl2lmjoohWSbeSkihRHdsGjs+bkYUS+Q0+QrHy5Umm1646N
         knwg==
X-Gm-Message-State: AOJu0YyR0ZX6OdZtyCh7ArvE82Azywis2MTbf84UL3kDLhdqpKNLNBsF
	+bxiPLbqfk9/GIZLvXqs+lhOjPzSKa7vz5BESTjRwLV21dnZETrwQV7BYMx8MaFCiQg=
X-Gm-Gg: ASbGncu4z5HYziEu7CBqJq1xdmNRgW81XBpXIwTXgfop5Gmxjdfx4j/zWvULJBvJCRk
	WYdDGrXkncxHy5OwEDMFoHMyA8g51mN2K3PY3v5sP1k5kK6ZQelHDVWD5/FEalPHIZYuTPr/H11
	d6G+rpdLVfaBHvOemusxb7+TSeuC9/0MTTTJW23GI/XspBsoSWt8TqNRSCdievWj4P2SDNfe/2N
	aANowA8e0r96t9zjCSl1/suvvahVYXRu2CQSsFveOWpCQgNDXncbXKxGKCMfeBtrHA4tU4Mfyv3
	rhtVOFiBWNt2lH0/K94DyBPrAUV9xLqWl5CxDaqoShBJZzz2eclvK6DjiCCPODFLUBzJSTu48nf
	mGNRJySDLKBct1iycJLtM/xXSkAyjikhDJw==
X-Google-Smtp-Source: AGHT+IHnp8n/7OAU4jNs9ZCJvpQIeiaA6sLSad2OkT1KrPCLwJcVRh9VXs+acczXHfHfywLoggsTbQ==
X-Received: by 2002:a92:c262:0:b0:3e5:3d13:5d8b with SMTP id e9e14a558f8ab-3e56738ad42mr59701575ab.7.1755097636513;
        Wed, 13 Aug 2025 08:07:16 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e542eee208sm42577175ab.9.2025.08.13.08.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 08:07:16 -0700 (PDT)
Message-ID: <020677f5-bd18-4801-8b41-ad294a14ca66@linuxfoundation.org>
Date: Wed, 13 Aug 2025 09:07:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 11:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
