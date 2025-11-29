Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060C253B59
	for <patches@lists.linux.dev>; Sat, 29 Nov 2025 21:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764450227; cv=none; b=OP3KZgicPUFdwoojgGzZ2T/b/5WDAF7gxx51NKMLvDFb4buuObO7Du0NGU4FtH8hi7KFS+IIF+2P9KBfrFOoyZjesnQmNpsl13IScOZad9gwJ0f+xUKuR9/WDJ5rkwdcgEnmvCB/0WBKiGxuGPuqrTCy5uqfecatDpjJ1/b2e3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764450227; c=relaxed/simple;
	bh=I4J065WtXbP0EattLzce1h3g+lCohohrgmSYwqTp33A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofel41MIa18Nt+TMCwAhP8KaySQZGuEJFAkHG2sXnJ4UPn2cse2RKg5gW41GgCMFVihwomFtOpY6XfqPi6R85lLd2AJHtW1QW4TdLBli0nCliIpFC1eAPxxgCogB3QWEEvlKN8qkg+KHOrCU6rCYbi5cOOOAAu1ZBz50xc49NQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RH8PlQZU; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RH8PlQZU"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-bc09b3d3b06so1642619a12.2
        for <patches@lists.linux.dev>; Sat, 29 Nov 2025 13:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764450224; x=1765055024; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TpfLBhneo4YXByUaX7wofPB4xvrmCVMQwWHAEbf81M4=;
        b=RH8PlQZU0OxD4bGhB4LFGFInk3acxaWGtGvK5Jtshw7yO3+7cyLUpwJ9oAwsI82beL
         wCm2r2Ye7mA+UmpynX/66OK+ijDCFEJmy1uTq/bsXrhSE/VoLtzH1U4k5rTQKTkkjw1n
         fyVeaUL0BoPlgmeXj4NElsMiQpNW1RDzUPfeDPNZ6/fyN9TQRTdJ7H6FXLkwolyEizkv
         bGUD/b/su0ACrAGdEGIOIbe0HuoPpCyExexRcK0PZwQ/0Lzsv4WSYBFmtW/JXyKc2U36
         nGQn9dYwcs+el2cNiwtk6M7F3hoUGJcP1ZFQRcV6qwl32qbNCseUAsrD7ts8J7C2ZL8H
         L7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764450224; x=1765055024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TpfLBhneo4YXByUaX7wofPB4xvrmCVMQwWHAEbf81M4=;
        b=Xg8K9ekSPYotilFcjcsfjOepxiEilJNoaprfugbOLsxXpAi2pa4ROQmJJoZav7ulYF
         2wnVCRiUxr3ZSqLx+R7UZZcPUlMtQjQ2r4y+9LUwD++NqRHUnHx8MQzx7V8UyFnfQFwP
         f/+GPMyVKqvuFuLKCn2WNYZujP96s/a1vJ8XzmLTvUlhNt9Ebdfjsq8fanKtfZMH6D6V
         Md2FvH8kTrVTrGNStZ9vHJTXNC2NdvP3h6j8JLT8VQokbCrt5cr6cxfCqwxOYADbcCrU
         nnza9122yAIeMwCuUxajPBaG9KlEQ1+hXzV2pDjubnTWUZIY9bPIVLMS2alZMgU7iH8A
         v1aQ==
X-Gm-Message-State: AOJu0YyGkOJ9+wkg/w2iHYpgskfiBgsRpTfQ00ZTeAwY+vRoz9caj+eO
	3DcGOmA2vO4Qh76hqohMhmHHbDtmG1AqP+KyeVjD7TjeDuiLMpR9cu6U
X-Gm-Gg: ASbGncsfgYBg1C2RC9LKXBVoKhFwcwIbBcdAjamEOKmFg/0QPcPWr8zFLa/Zp8qB78P
	dIJeHeEkADL5gd69Ul0PQ2q/bTdEzq9VbC2lPDCQWtRzff67fyZ0Yo4dY4YpeswN3PxOaPSQg20
	ittK1nw+vFj0tmsMcE5ZX8LynDm+Yhq03rOabWXJ1Bt+R1PG5sY+HGLT/tIK2OPjhPZv3vPwB0L
	0+0aMxWA3MFT3B/cqLLhjvDHZ2CGQ//eJmKfELoRXIYbrisBZ022jP1E1jlxQ4jXfTnUX3tXwsU
	iivYPst4tlEfy7qVqGs1v9NePAcdx1M+2jQH3c26T8RzZL/1H8gy6vRmotlTj6H/rBETJEG78CJ
	WyaOAaplLlaApD6/gIG9Bzc5pC1HAWAPA7LEx7q9FEP+okkr/+WPKOsFg8N6s+TvsmIAq5rvb2A
	AlJ9RGOBFWkWA2nRQxKYbNqaTozifb41ob6QR2nyPzRkLFSSd1TdLV
X-Google-Smtp-Source: AGHT+IFcuwZ6jgBNxAZr695//dbYbEGdPM9zQx2bXMjJg8Ap1CJzJf1Y3GNY4nJND/s5PjrNzaQtIg==
X-Received: by 2002:a05:7300:d4cd:b0:2a4:5eaa:a9a7 with SMTP id 5a478bee46e88-2a9415730cemr13260287eec.1.1764450223888;
        Sat, 29 Nov 2025 13:03:43 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a9653ca11esm28195477eec.0.2025.11.29.13.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 13:03:43 -0800 (PST)
Message-ID: <e91617e6-8801-4e26-8a35-b2f4d8297258@gmail.com>
Date: Sat, 29 Nov 2025 13:03:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251127150348.216197881@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/27/2025 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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

