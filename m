Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088A61F958
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709138368; cv=none; b=WDTFiDI7ludAeiqX6LTKwCYsWD3IJ2/vrqRalVJU138JiTve1PIsAZc99AUo18ohRGCdWkOryl75q4DDlaCr9sIxZwVz6WbCnQKSfslNBjrq2mwY/Et4ok7D4QB+07DfS+L0LOKsqQ76K3vW0tdb9Oi6nq/P7xswr413dkLVVlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709138368; c=relaxed/simple;
	bh=ZZYZjjBoPY25nB94qJ/iXB7sLKjUp5eutwi9DVAvdO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lG02qTQYn19oFAga1/jFLUJirBRboZQwnQN1JdkxgfAi5Y5eg/AGgmTMbjvbLCX4dr08R7uSMkwVJdxBc6ifNg1XQWYR3UyndkqSTT22obgY6HM2LU9Z5VgmSUviqbR8cF+XIgaYnsMlUeOO/BWMh2Rd3HfgM2zTKzFkUMz6olc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWFnxBLH; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWFnxBLH"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-365b5050622so1385385ab.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709138363; x=1709743163; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ywQ2N+51LDfOyR1ODhnc+p+KZScDU+E/nSoRgEWr78U=;
        b=MWFnxBLHlWiI6SP0En43zrXYLVDFnOQT34Ej8pKXQd9nFJmJYZ/5UZ5Kotp9eZBnhn
         C3fu1W6BlyulsfNFRO/NGjQSUnvJq0/Na0gqBCmYAe0oGC0p2M/05jgvGJchuslwFgK2
         kB4lT3I1Y6XTSJKkd3uYvoe3odL160HtfSZeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709138363; x=1709743163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ywQ2N+51LDfOyR1ODhnc+p+KZScDU+E/nSoRgEWr78U=;
        b=qFdT92c+J2kuPoIFoW8wjr4cj1JMWerIfHkLwkoyXCXr7WeRveENjlnMQM+Q1o4pag
         UWQagofF/2ttQlCOKunrbkvbTR03oa8ujvUcFdZt3j4lBV7UaDNuJzux+LimgdGf2g5G
         Aqdxo1YTIpp1LnC2L1/AofojOfNDp7zSAJ3m3t4PHPZA3y2UXGBlA1ewHPoF/fVj2vhu
         a2iQMC4+MzkSQ0aV+yQOV587UbpvGoEwCx+C9ANKF/nlelwKgDzoBpe+jS8kkpADy+wB
         zI1eqU5dEN5vHA2V5lP2TDmLb5t1FTqpyGwk0O5/DaJxjW3QhfYy/wOPJiyWwrRdzIbu
         drWg==
X-Gm-Message-State: AOJu0YwH/JBEdZceQQ5Gm96dxgG7EEnpfM2XonGqJiJ20r+/7Dz4TXHz
	VHF58Ty2m+7jp2kj8DLt3ozzaAWTPEpr5HG4zfAssWhRVu4MGGOnWQjsft9FMbM=
X-Google-Smtp-Source: AGHT+IGsF9/a+7Ca+mGlICoWd8c8ICEa5PoYE/zWk1d7/NEcuLYBJkjLS0sP29zqANvE8DiQhmIt0w==
X-Received: by 2002:a05:6e02:1d86:b0:363:b545:3a97 with SMTP id h6-20020a056e021d8600b00363b5453a97mr12989996ila.0.1709138363186;
        Wed, 28 Feb 2024 08:39:23 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bs17-20020a056e02241100b003642400c96bsm2891272ilb.63.2024.02.28.08.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:39:22 -0800 (PST)
Message-ID: <1d657e86-c1f1-440f-99a0-5705a29dc2a3@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:39:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/334] 6.7.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

