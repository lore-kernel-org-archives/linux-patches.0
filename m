Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC01FBC81
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 22:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729550171; cv=none; b=a+H2Jg832oMQO06Os7GjYo76RHSSw5cftWu8LwDhKM1vfsDAJT0BTEteaTZDNqB2vTgiAY/va53sgf9WBb5tFH2GPyASMeMyJ2KwvFy8ze30hQWbsLK26y2qLhldZPKWUdE+M2Qwm/ioFJJ+I5EUcTWSDVQ9A7QO2JWdiOr6WLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729550171; c=relaxed/simple;
	bh=7ridXmxOHKWZoFTcCWYzOqNgAI+K4jvfNxUVNRtv7CM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=art7/LyWlxVlzgHHgbV2WYHDNbdNDvsT0c4yJs8D+e4poP1J/tIklWt9dvkOTfateltLiifD2aH6a/iIk0EMUPzyPeBBqUNer4Uz9FlUjMAylXMzJEXS47u4rgNqHkc2uJi1K64v1kvmgS0YR8rQl3n2zBHWsaHcyRavlWmjZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWAtrQYt; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWAtrQYt"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a3bb6a020dso18426435ab.2
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 15:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729550168; x=1730154968; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1oI+BubvD3PxPJMfqOmKVBP9PushioezVB2K9owCDI=;
        b=MWAtrQYtgrY+1dt/y2UfZS14iVk+PncyOt4oitPEpUxujdF+NC7KHzShow6H3ZW5/z
         5931vcH019CzmZAlncG9mZ4pMu8aXB8FArPMlni0WknFk/tDsPnxozgWPTrGP6h2q05M
         t4D2h4Q04SEBFejwOeJ1VcpPYBOgpZ1R2AgnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729550168; x=1730154968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1oI+BubvD3PxPJMfqOmKVBP9PushioezVB2K9owCDI=;
        b=QaqVOM7632XJVo38hVUd55LJ5IvJf/MetVB6qL5W9T2CXXhkzVnZT5DKwr/K6SgER8
         cWY1E3vX1kzfmCg8yCO8guMc69vwCz+I6n1gLAXEwRfAwNzN8mT8g08fx/ZRSSCu927j
         s04+q/PPbHS7yeGqZmrSLtHdY1ghB211BjuRQOUs+ymuDO1xOoKavRU16+K8dZVhxNTo
         YWPnrXTNL/Klrrtg+JZc4U1/NW/nAs8hXPO0dsIznCEchYrXRlB8x5n6P2LR3QKOkD1j
         8whPj9M1KrUg5u54ogI5FcHXjBjXPZ9TA2VSttq3Pl+ujfL+ffVmWvmibw9VGZdhY1pe
         8QkQ==
X-Gm-Message-State: AOJu0YyyzjwyvoN6ufw06roDnsccvgr701DOFSqjJnAgGzHuCIE0rQYN
	gdgnRx55uL0HNURyWC4PvlPzdGzBnoWcZrjqJhEp5jeSYfKXdhX+SXACqVan7o0=
X-Google-Smtp-Source: AGHT+IHQbwFRjNv3mvRv4eYW87D6KlEthx3nm80SwdMIqSHvZkHg4K6C8J+Gc1bJjQZixmB4IFeUFg==
X-Received: by 2002:a05:6e02:1908:b0:3a0:b384:219b with SMTP id e9e14a558f8ab-3a4cd81a173mr4512455ab.26.1729550167696;
        Mon, 21 Oct 2024 15:36:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a63020asm1268461173.149.2024.10.21.15.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 15:36:07 -0700 (PDT)
Message-ID: <59996bfa-013d-4ade-954b-33974d86cbb9@linuxfoundation.org>
Date: Mon, 21 Oct 2024 16:36:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 04:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
