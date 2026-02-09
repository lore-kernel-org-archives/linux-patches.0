Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D8A3AE6E0
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662951; cv=none; b=ekEcaun0Biw1K9jXrRbDTM93yWO3QfKJwILEX09awcDKaMD58GPM8VNoP+xu0Rbn3+HxBMv5GQAPvq/gY0lUgg3hoxy+rdpqFpuriIKlfxIWa/QwW8E+hZ8df0l89/y3eE6k3NrqNehW+E9BJ6gpJ4vjwlUUBq+56MMbeTaxRIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662951; c=relaxed/simple;
	bh=OBP9YfsO1ONxZ+Nu9hHPILZ5miGi+cYyFL4ueH5k3eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d1H93PF8MYqVNkxXu8FKwe2NspyvlvuL2RnFaMoOodC0JGD1RN6PZZ/bQi/Icevf7/3r0YSTeZmrYVMfVxRC11J2JSUSHCDfRw67Gb/88c0Qhruc0cu7viYeVVQtaL0RF35J2lGwTxZKiXIR8dO86ASuGyBwtiFmKjEtkdlHZEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DS4y7Opn; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DS4y7Opn"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba76579640so1064440eec.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 10:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770662951; x=1771267751; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ew0PcY5M7Xc4Nitj9H2O94wUPDQ0Cr3Y47he92sxLuo=;
        b=DS4y7Opn1KfmdQnyStFlxLs5y2biBUYzx38ANp2VodQbDbFUoa0JNDMSyYWluh6FJa
         2FQmBUAQj+NEebI6XqXkScmxzZek1FLXsmyDKcgry9wwV/uHwjearqcVAOhkvhNA+6ZI
         YG3VmROtj7wMRTrRAtiqCUV7NBH61kkSVLyjDEKdiLlCIjMedOfQryr3Wm+28TsWZ3eD
         PyRDKVYy4Dc6JrIYZDO7Y9NSxLfKsEAOYcnsbk4CgpLZ+WpvR1r8CckZwkRdw8zx6d6W
         UEn6d7V3W+uiTiqlMpxqOG1n8AHkyDICeJY1ehETCmKcz0/h+kzyaDK/DyBytuD0Ur68
         29Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770662951; x=1771267751;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ew0PcY5M7Xc4Nitj9H2O94wUPDQ0Cr3Y47he92sxLuo=;
        b=bE4LOMXyvJpYnFHfLQfMQM6kof7MQ6akTr7wZKG3gfP9/d98i8gd9rc1iDB1hdyvtO
         NFG2zbrab4PERaVbf6Mhi/RMVgrMbCxz7fnyCAzYkYjqq0cafwxpYbYfclhMPKwAL1/P
         FW9Nmx4n9TVWSeLE2UL+fjWVx5BoTi8RUiPIBmlR+eoaTahd3A9loivpNk1KNzrycbrf
         yG4OlIi4+g1iVt9Ivf3oyxiSKwPvvjBVQ34ATquUq6KM93qyNHNNP+1T0N7e5Bkfqf97
         TlYXWPpGCEQoOUyne2Kot0f0bVPZjVLAn/ssCNTL3Cjs4l/yB+//wnX0v+63iqfUlSkP
         l76w==
X-Gm-Message-State: AOJu0YwsIYIjAKlS2Xkl1XxLPH+RU/JBmbqrqYtNd64ilHWF5DXKseWE
	ry6Iq6Ri5MCDE2SCQiFfFDG6auLcGBfThi7wnlEKCoh/afntm/pb0TTP
X-Gm-Gg: AZuq6aKSiO7cGS1AOoFnjWPe2NvOYJpUn3Xs63m8RU9d4Uvz8Sl2bIpNQNn2t1DwAxM
	mFORboTdOZbzAlMSgci7nLQKndDat0mdxkdlo5n6afhAB/WxbQn7yMCfKU3rx4FgKNpYQygm8hw
	DLic4sooEHzU+VL6lUXztE6zEOHff3IGsv62SR4l4T9nese51a5VYpp5dgWzl4+mugMLLSKIuyZ
	1gjvyvnAfwXKLuOQnbP5zFd/GbB/QXhv+2SPhAekl7qZ8CDaPvMslFWVjFN5Ia0wpCa9JnGRjy/
	ewXeHXP7DTi1TjaIF86FqLBE4JHSu6yDN9YOBkhSOuE5JxHAxqPZFFd5HdVqqujFB+8g00KMo1x
	hGZnow02h6h8qXCSZ6qkHn+Ip3X0MabkrkHC3SLf8Z3pw6Vb8+c9Bdb0Sz7iRmF34+vCe3FQstU
	BTr75PiRCF1RNyBoqlxpXbZU4FAxEEHMZiTGWS4AJmDytxqC1VhB/T
X-Received: by 2002:a05:7300:641a:b0:2ba:6d87:cf68 with SMTP id 5a478bee46e88-2ba6d885c37mr1639927eec.16.1770662950495;
        Mon, 09 Feb 2026 10:49:10 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba734ed83csm2419418eec.23.2026.02.09.10.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 10:49:09 -0800 (PST)
Message-ID: <be01e537-7df7-411e-a4e5-061f43b08b28@gmail.com>
Date: Mon, 9 Feb 2026 10:49:02 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142301.830618238@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.200 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

