Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7B67F
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707869610; cv=none; b=E+Z4p28QVMuivX5RWkGQUIqkYrPU+c5rsJ8k4qqJs4s+EMSr877gpmr72v+qnWDTk32OEYYiF2aFSZQtlt2YWB4FczrFZTWsNRJd8uAikEEsszesIgI/u4s2CC5lkBG7LKT8xitCOn93y3IyDXV5HiDT1BhcEOn4MsRZMfp4PRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707869610; c=relaxed/simple;
	bh=blGoqFSG+bM4MY2OkxkXog0upiI3/Y+AsY70uk/SFk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bI/6B86B3qtb97p1Qrb55YDCUs78s5Le6b/CFj6UP3prnf3Lk+O3y+UCrJwllUC1o/N6ycRfp641ITN4nPvqDi6RF6tEOkestk1/zyKpsyYfHxWsQJ59wj4M2TLABxPKwDFeNPU6+bi49+Agp72E8U2IVPU4Q/AEGdjYGpH8/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7enaHOJ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7enaHOJ"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so4920725ab.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1707869608; x=1708474408; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yPDqGsGVRBXi/v9PW7ctsmPDNaShTV4LQ+ip6JTA0Hk=;
        b=e7enaHOJtlWdw0qzj2jiiR9a+tHCgV6mJcO2NyDyIdsliygq8grXoTbJR2dpsdVvaf
         M0SlJs7+e8SWffvqhn0H/gniZVLMv0J34xcPXKqYOL/sjk3xVM4zbJgMc8c62eIH6BZG
         I8otCHyCdVqblvqNtDx4Mn66RQWRPeVOKlP84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707869608; x=1708474408;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yPDqGsGVRBXi/v9PW7ctsmPDNaShTV4LQ+ip6JTA0Hk=;
        b=g6ZdXoCbsOT+HBuwaC/vOAU2Ac6mBiEx2q3sErf65+4JL7t1oOBzpFT/0zmV1PfPSf
         4D1etQDf3w+GvN3ntOxgII4CJao79TaJhrxJM0MlM8Mv0CqocqFV/PpCEdrE+q2dJrpg
         /GweGgUPoqw+3S1NgJ5oSBM6LV3VfQMD68xOti3Xz7+AgiDFwA2P94sF8vSxvzz6AL7p
         DU0X40Mg2h+5as6K1iYFziTGMVOlVNBsyXsBaBm347EwffQxdDOHL8bxdcXzDvIBE5vN
         EO+q1/jQtDUDLxDmuWJX9rjCLxiyG+yU7Am0dzxg8K8tSd1f+cwOUNOTw6hI0PsNCsko
         AZmg==
X-Gm-Message-State: AOJu0Yx44EKImedcMbHUgqWmZuCFbQD/8D0xnIa0kq8oXxgxgL4ik2fm
	Y5yABIc0YhwJecUrzxO1S6lzs4ejyIGA7h8UVqwD73CQtAjLC13iSoPPncvNO3E=
X-Google-Smtp-Source: AGHT+IFj3DIzE8TUG3KuUciUIn0QgQ8h3JK6FQ/JtamGNxaKJ+e6Cs9gS1k8YQ4vLigeLUxYKfVwKA==
X-Received: by 2002:a05:6e02:1b8e:b0:35f:bc09:c56b with SMTP id h14-20020a056e021b8e00b0035fbc09c56bmr1410174ili.2.1707869608280;
        Tue, 13 Feb 2024 16:13:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUlRfBRzl53Qpa1e5k4sZBQjm6mmkehiuSVkzvDmLjCCxZQ6dHTfpladZ0qu8fqLi1FYonvVXAq6JIvnnis3b9fJP2R9/PyLh/9m1L8dIuVQyxdu7uF7RDTs93CIzbrWK+VWnsngZyogbd8xrT7rObS57nyqilAWdEJ5ZDDSBVcsjE/qnFrLF82j9BPBVfawKiua8L/me31gsAVPjjS8Dq6M/qqFfRIeJOvopZdAVFd9a4TgwmChgW4H94d/N6Or9jquGBsAsehslOf/e3hZoC5j2nh2+EsICBXI/VdXAMoZMEt5n93zilacIgQO3aamtPQ8qHCqZrlLvVErTIHIjsUpQkTNplO9dGK1h4STPhC1jRuGb5Frc7wewX5OeaZV55ynWOza4hEWEbI1KruA6q4f5/NxBAytyaajsCoEb9jCDV/LOx4whuZHuFE/KPnC46iNS+xgNcAj5lpY444OMhrU98CAV6OleVbascJRkIuHGBPakBcOM/VBgvHx93G14retu6GQQujrRtL8mfGENKH4n4HvNksgyfD3Mn1CxsgYbSAzykZXyCCgr8xuDUBM0qcbuM1epZcJw==
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id z11-20020a92da0b000000b00363ea1209basm2752707ilm.11.2024.02.13.16.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 16:13:28 -0800 (PST)
Message-ID: <5ff3912d-abb5-4049-831c-81a3bc8da929@linuxfoundation.org>
Date: Tue, 13 Feb 2024 17:13:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc1.gz
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
