Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971045731E
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014817; cv=none; b=abSLaVkny0X12P6IdowdnvQv/rqSaOS19amRbyU6Movfh87cRoTkNk3dVqujaBXrSZ4B8nXMqPpadKiXBEWnivo+vGoqjXFM/ACqzhYc7m7lKn6qlqXfaY960xWRYpzof9lfbZNIRVTIReuVJcfyGH9GJrMrFPntW6wYL0ehq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014817; c=relaxed/simple;
	bh=ZANE8iSaaHTuiCj1Edk/R46hIcM40ALkebRemnzrjm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6RYJgvwHVcVqtHtCEu0zoNoSdGt8AY+Dtp0ToXld+71MALuHb8k3yBhuCJvU+DNaW9WaPvW7v5IX9Q/4LopkETnZTKDiGcH+reC0J7LLZIw4/+i2y8lHTjkPZNnGx+1MqcChCjzDGfXT5Y/sKRK6tBeeTKDkA0Puuwz9JMHLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXf0UC17; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXf0UC17"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a47680a806so1340336eaf.0
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712014814; x=1712619614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1jl/3ugUzIx8xqjqXwcOaRMc2nOK0CyZ8ADAA4iIyIY=;
        b=BXf0UC17QaDqjz3QqQbW6F2AKil+2Ze2ELC09zyduBFTz3xZYKdnxzsf3uYuZriCHW
         9CpFaOAb2AKH2U0hx5H3uhn2rDPWqPiHqYl1X8GZ4xluE3EvrhFH+eDZAW6AssmgSqLs
         pKOHC2qKKTPkrsPlOOScvSpCVQbHpSAkNjiBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014814; x=1712619614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jl/3ugUzIx8xqjqXwcOaRMc2nOK0CyZ8ADAA4iIyIY=;
        b=sVmwLxTpNfivMMDoAFj/uIxkGqPowlxYs8NTJ1LYe56Z093rGgJEVGnYxPEMBtoYzf
         u/mLcg+2YoOTE86Uc9LEPuqODiqwSmJEJVDqtWX+pTqx5c6epgZpeNtiTXT72YWQX/cw
         xbIBjowj2N54BOqhM84jGyeFGKGMBd/DYRwpvti6HuitTkP8iDIRCQckCr/dgDYJ0gmW
         w8hErFfb1ZPCtfj8ZeB6Bj2YzJcWO3C5URolemtN1vIHobVo5dWaHk2TBD1bN2cltmwS
         LtOCFMjPUTRKT7KFGT8MBVdZQlGiyN2kLltQgAEhdFvGk+g8nrJqqnYtOULcWdEa/qm/
         46bA==
X-Gm-Message-State: AOJu0Yy0cN+1UTEEaJ5DKI7frieonsV5sSa4/KKjF++ncTEWbfFuyBE/
	ZTD+HCZYLfSQSKCSsNojaXvO3Inm4hFGg99AuW0Jf8iBZtuvLKLGNBI2f9rH4xM=
X-Google-Smtp-Source: AGHT+IGnhHZrR/gWiM2r8q0KacGseXDqszQ4vZbPvMDgaZ3DeIBfjuJgHJB4VqqNj0DRkKeo4sY/fg==
X-Received: by 2002:a05:6830:1659:b0:6e8:8d89:ed55 with SMTP id h25-20020a056830165900b006e88d89ed55mr7343253otr.2.1712014814667;
        Mon, 01 Apr 2024 16:40:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id g8-20020a056830308800b006e67fcd0ff1sm2096704ots.10.2024.04.01.16.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 16:40:14 -0700 (PDT)
Message-ID: <bf6598de-545d-43b0-808f-aca2d5ce0e08@linuxfoundation.org>
Date: Mon, 1 Apr 2024 17:40:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 09:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.24-rc1.gz
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
