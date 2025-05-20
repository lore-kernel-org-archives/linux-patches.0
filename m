Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22921C3306
	for <patches@lists.linux.dev>; Tue, 20 May 2025 22:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781177; cv=none; b=lNax93qvQZLsUBVV4Ymc/V5+QFj6GktM7L5swDxdfW99urCaOdd/lEx2xvOjr0Qo1ApEh77NKIOOOaZr3SgFTypH00xqsJgs1pBAYsK+kLDUakp1cja3e1vk8DL+drS7RqKtr2njWBreWYvBT5nNCYqQuksUTxKQUMAcQMmMymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781177; c=relaxed/simple;
	bh=xU1qrpva3srGXzaRllUISS4qZ9R1FkREbCpATdGX090=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etSFZTpP3DxSBot7woT6YGX7ne39ZkR5UkAHrQry1BVHtS9SroJZID17B9MUybjwU4dD+jc+6a6t6byESulASRpQPz0i24vAXu1hmMdJuwrU/I4YySHqH8gODo2qbWVjAQKeGNWpQLRncpQyHSn/c8TLiUrifdkMDftjYuBE7v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuI33dsp; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuI33dsp"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-86135d11760so492680739f.2
        for <patches@lists.linux.dev>; Tue, 20 May 2025 15:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747781175; x=1748385975; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBK2iNtnFXG+56awWUtYZcqCou699Pnyv5HV8iziaWs=;
        b=HuI33dspmAuYFEdS3MY8zRZXoxsT6ixJcsSGOEUlIsGw6ITZPztybV98dfcEKAQysY
         C30ozaj/bnZUKH3mgwT4v+BenprrvLSFwTauS+nMCqbvO47lMJAPPGfd7AM2VEoccVs0
         AGyHoEPXOitRS+hB8tKwtpA8+AKlXjhOeK4+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747781175; x=1748385975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBK2iNtnFXG+56awWUtYZcqCou699Pnyv5HV8iziaWs=;
        b=RElEwMX0KqVz3dkKdaVUz1nraqPZEaH+X60CfbPndMgb3faS8TMAu8P1gxiXwpYBjy
         JOEpm7I9Lt9TqTK4qrrc9XlOLCIxcF1b/3G1CkNiCsxvQtAJNh2BBNa4u2jQia6uCDZD
         SzEfHUwjLtp2wGk0vKkNpzvuAvHtfwmNy+t7CdGiT5jK2AcKTL/nAxLKLzdlgvCN8hQN
         mk2sCw6b6aqF6MV2WUf1R2UtYO2R6ddBDQQ+J9i76S5ugOifouzKzh4eClOMhDMCiJX4
         HrUAZ16iiNGFr6jnSnybR/zSdwwAJXZjdk3nNnrYyEreRuwoySCCWtj9n5OfuStT7xC6
         xxug==
X-Gm-Message-State: AOJu0YwlIaHAFHGP6pQShdYki6c45/b/6K8Rl3+ulptheZpxM6Rg9T+Y
	85oE35AUIGO1IXFNMafKe63fT7alVoUxhfolNzp/0pVgqa4gO9Cf7H26/hw0JdVtG3s=
X-Gm-Gg: ASbGncsvfnynkxXl4rNDwJ9preWmvpYmqqC5KB8p2W5crRIFCMSZaWdKI8mz/qJOBCr
	xhMNAYaJbSBm4E7kGn35/laS8JpamECK+YN5zuJ1DkVe48sUriCpE7fFfn+Kqhviz9SbDyJweCr
	JvdU6KfTUwl4bUD+UeDBKSEtxJ0ho+Isa+X1+phhixTdXWsydPl80v1jEYPNCAFpNt2Ynx7U5sV
	PNFTPl+I8wuqBMepKWSzLR+Sfte61+WcRF0Ooc1Pk+IjXRL0qb/DoK3PRYWVh5m/DTWMNRJZ8A0
	XCBzRBQYJmKmHq/Hn39QNkn4Yig+XWvX8F2jsKzRf7pzoYbpPrqnJpPw33pWFMyJ4kHa3ylH
X-Google-Smtp-Source: AGHT+IGaYckQ1ocB0rCSKdcZon0qF7utkxxlGcyX9+/b8GAs+CN77IZYj8Y6+RKi+IUPbifSGPiiMA==
X-Received: by 2002:a05:6602:4808:b0:867:6680:8191 with SMTP id ca18e2360f4ac-86a2306ee1cmr2732619239f.0.1747781174829;
        Tue, 20 May 2025 15:46:14 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbe649f14asm1726634173.79.2025.05.20.15.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 15:46:14 -0700 (PDT)
Message-ID: <d2cd655a-7375-4870-b6a0-757721ae183f@linuxfoundation.org>
Date: Tue, 20 May 2025 16:46:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
