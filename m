Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF4B4AED4
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712879777; cv=none; b=bPUyqcBFijO8CDWVbL2GSUN4mITi6Bafw2GnOASuyxpOXNWdIjj/pElr1ld3Qb3MzEQ/CSISVwpxvbNt+qfGxRETZWzBecKbXaSgpJT1evwK9YIRwXCavWsYeIH0UBRqZqqXsq90oMigJ3BvsPwycubusk/EgSWmof+4GDzRqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712879777; c=relaxed/simple;
	bh=1hJuW4Q6DIb/H/sHiYOYExJ//bqXgHS7kwabOym3u1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnX1zI8dc5m9RvxqlmzhJzT6WskfLVWzSrHnWZj5RqL58Fe8/W4t463vmWBgg1HgdpApOe+6jmF99zhCBjqM+XwTowdhl6KeknK1n7ttUmFSy72NaQ490QX1nwQfb8boRk5I1q7U+YBREDkpEBxjZrdC6Y00jMkqYgBzMdxzQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MteG827s; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MteG827s"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7d0772bb5ffso7991939f.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 16:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712879774; x=1713484574; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qe0CvRWLgYscYGo8HB4Lqcq6jCdobjBtnisZZSsYEYM=;
        b=MteG827so5d5q33UwzAllZmbJfoIgRLvMFVxceNp6E+Caj0AHZBEqBSO7VOT3FryPe
         NuB1MNFKoWdpoB02piFikVverbA2ILkvlR2ZtiYwDILdKuT7SXRHJjnEgkEcQiuYMp97
         5HTbx3u/qWc+yMWZZ+et6N2GtdKbmsT2RD7gs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712879774; x=1713484574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qe0CvRWLgYscYGo8HB4Lqcq6jCdobjBtnisZZSsYEYM=;
        b=iAc+ayEFIdMPk/8xC5YzahC7jO59l2k5rHzORK3qKb1IGX3ShQSZHO9NKjMKjtyuT9
         INHztDqXlHwu6oux3A/09tbqPd6EikVOtCU5OSbVX9YUkfkw+TsCWDojlUwL49ToO6ya
         b6E6LGH3o4xsFBUNa4jMFUNX8K444OQcK8/oTafvg3mLs9XZjlCLVgFIAsGGVhbKhDXt
         zNnElXQECkg8BzcoaVgDB3LM4WXlNAQiXCmGHuXUM2mQrq/4HpuMLx8fAh2OFckb+rLq
         AtzSl/tGOoiwcp2LrC5SIH9y2UfmgmfmSGjN3wv2OgpQ2dlIPqrSPPlg1wAyO5/qCfll
         TB8w==
X-Gm-Message-State: AOJu0YyFBIbCcbWUaODl2Z1LzQRKhcS5DjmlXOkK+CpzhvbrQeF+sqFg
	k1jxfALzIhrkqJKHJRieoBGrZNipUoEKoFyx8N1wmZ+NC4jK6u0jQ4fTVneNlS0=
X-Google-Smtp-Source: AGHT+IGV0IhqS2O6YRkP3iIt3Yudyqf3AzBPtdznd78B8RXYp98RlusRMAJ9uzdymcwqzIpF6kSb0w==
X-Received: by 2002:a05:6e02:194f:b0:369:e37d:541f with SMTP id x15-20020a056e02194f00b00369e37d541fmr1456230ilu.1.1712879774647;
        Thu, 11 Apr 2024 16:56:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id r13-20020a92c50d000000b003698fc3a541sm644512ilg.80.2024.04.11.16.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 16:56:14 -0700 (PDT)
Message-ID: <8de5278c-9bf5-46ab-9fa0-ffba4c95b4fc@linuxfoundation.org>
Date: Thu, 11 Apr 2024 17:56:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 03:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.312 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.312-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
