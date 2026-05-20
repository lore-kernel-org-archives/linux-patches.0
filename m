Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF215331220
	for <patches@lists.linux.dev>; Wed, 20 May 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298120; cv=none; b=Y0MJNIqCpI7iIq0zNg1ti5A19GkxVsIzfLNsK6hlQW4QYDYr1akS8URtcvdZT6VYb8r2WvIF4XzRP5vEUEk2rsdd18U14emWxgBb8xZ0n33YncH9O3xm4PHJF7c6AeEzN8FyjaxdGAgdPk8V80tZ1I3GE3TvhHAHaN6f8uvwLC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298120; c=relaxed/simple;
	bh=1JoJ1pMrRta66xrnAqvPlRrU+s1jQQogKj7zLypIcR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3coebfnpgH5zj8rDVD4Kp56Km8f/OzyxgZnhjygmnY0LwVeQFonqy2a6SNZu3HZYoXVDpiF2x6Zx02AzO2XmFvP4/Tlm5RMvv4NTxXhQ/+I7hJqGCftM6k9fhN4cbTm8vs9eZ40eQoUYYwxraOGpnxRg66e17cdNbDr0A+afyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XnZ/YSUa; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnZ/YSUa"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2f7020a928eso7438315eec.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 10:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779298118; x=1779902918; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VuzZ4HzSRbjeOjIzQh3TiYGdA8Z6tPjiq5L3ytoki9Q=;
        b=XnZ/YSUae+urHRYhDL+PCugocDr+3oDy3gYt8l6REvYuWouFPFx+j5M8iGeuokEicF
         Kk5vEWbHbO+z1kTztnnhB1uTbo/M9uqslrQHNKRerK256UMNUwqsmXjJOPrIkZyCjt8e
         7W8i+BRAa3xE7RKhJG37upytvFhMwopFWpbBR1EghsPj3zjEnCfP7KCYF/DSvwFOA8Zl
         MIARVYK4TRdtfmfqY4ylrpe9Cjwk4QyBiKVOo184zYO+0VDmMthyB9wh/cTnBkalRbwI
         RddnxHZ134lXCyev18II9rZJ8lo4qGIlL+lPFk1LHrBv3rym7xMh2Uc3IzFe1gGRWYt3
         myoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779298118; x=1779902918;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuzZ4HzSRbjeOjIzQh3TiYGdA8Z6tPjiq5L3ytoki9Q=;
        b=ny3voFZdGAC/q27uQYyzbpLKfrWTObyNO1pkt5y02IaTW0moD0y6sPOpUmh4mLUVc1
         htJ08dWDgrWPyY//Wi7OgB+CF2mlpe+Z2/HoExBlD5Z9vrNAvao8pj4bljilcweV8b72
         Jxu1gF5gJL4W5K+O31dIAg4k4QVY/eTEtwSTv2TVCDeuSGR2yOYiWbY/dIMvF3IiWuIU
         ElJTelKaPq/cgMafw5H9all1bJw8wPznyDKKtn5uwsjBYGhBlB/Wy69HcWeJeZdsP9AR
         mbWjNpH+l1lqZar1F+lHtxJ8zrML6N6brGH9m8R43AIx5RW4TqafoR7usrgCtpHrqf58
         n7aA==
X-Gm-Message-State: AOJu0YwQ2tyApO6cBxvlfp5VESX7HHuIfHoqu77IdpGzK13B+1Q8fhrU
	u1O2LH+airnha4cBs3yMMnt5GM1bTWXF4jNelpPalqJ5NlWELiz7iXaO
X-Gm-Gg: Acq92OGZ8DdX9o1U21J+dX7lC15m6hJhygEB3LJGi9yMJA0l+eZBD3Y0Tx+18RGNICe
	EbPb6WKbDLe0M8DuD3eS/Lk4utBrWsCf4j4bcnZkH6Qj3S+Q8+t2mCF26x1snfsYxg5dcZxABTR
	VQt/qIfZ9TAIvT3VoxDbnKtVYbGG0Q5mXIdxID2azVnZN9sEpbgUcCMBUlF/vSwuV5cE7nQte//
	cwnS7dzs5NuSGbY/hkHqKJlQtM0sP8dOHD0rw6zLwUGFX93bOZ6FACvKPgsHuXoj5bXcIGpJX3M
	1cwmayHsC4WQPnW/Rjc5V94WXwdrH+tOTLr7uS6qWgf9xxYqLViatJVrZerih9hbsLBOAz6pqiL
	SSl1tl5ljczB2Op2nlakNZ2k0l5FKSLJ+QfPj8pbOLcJdMCdUTwSASutBm2UWO6wmGnTvqak+y0
	1kz8m5uhgNDKdun+KQHzXGty1voKsaxodt/bOSKKI14VHmOJIAeqjyb/UwBnrd
X-Received: by 2002:a05:7300:b586:b0:2e1:e5c0:7992 with SMTP id 5a478bee46e88-303982ac675mr11233548eec.8.1779298117688;
        Wed, 20 May 2026 10:28:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcc458sm23876517eec.18.2026.05.20.10.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 10:28:36 -0700 (PDT)
Message-ID: <6151ce91-aeb9-4dfb-ac57-4223078066c2@gmail.com>
Date: Wed, 20 May 2026 10:28:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260520162148.390695140@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 09:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
