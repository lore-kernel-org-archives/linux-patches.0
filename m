Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF752571D4
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761148723; cv=none; b=qIUX+rqiHp2gpPPbvndcL3HisGIakuvjXO6pMrXH3DkS2mQWx4HKI0GAL7KboEAsio9jcElvb8lcqq8UGilkJGz57COHnZCOGcKZjqmPk2Bm880Ku2/IGshxTnp50u1dLYmZ2rPLcrP2ibyCaHG3gH/51ZcolYQ9oXXLaTKRr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761148723; c=relaxed/simple;
	bh=NM70aKifWa2Kd7WDeVBufAQ+rHD0r0An/049xG9//QU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JwT89ZI4BAYEgrFhd62Px7mbajyKVXpNgbeGFGzgubHqtqSwadsIXSoYwiwpcZCYpPYLuF/1emI9jYyDy7x/Jd+RAVAZelk6upRdS+zPFLX1zkPy/OOf2V34tyFeHlimoHeIRbkjSzH/g0wWGqip0U8HZtB6agaIhuqdbpxa5Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV8Xu7En; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV8Xu7En"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-430e1f19a1aso5908625ab.1
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761148720; x=1761753520; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WtlN632BuZQuTO1b1nC1/pJZ9G7lNRGEK1QOBTkTILQ=;
        b=FV8Xu7Enn/lkfAKdW1sQPC8oUaxTq8c7vQ8Jy99Pm2KJBzmeAd2qBO7aLy2wsiak+u
         NwL7pb3pHhebygB90Xx0NFC2QsSdbKMhgV4RScKDrU91q8iCMCRKqmkd7etRL6oe77E8
         lrVq1TlGK13ySfpcTYgr1OQ80QXhdvTuWQ0Rs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148720; x=1761753520;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtlN632BuZQuTO1b1nC1/pJZ9G7lNRGEK1QOBTkTILQ=;
        b=SwaKJ4HR+wZI/UpsLulxQ40ggBLrexraXWOAxxxSE6k93WKC4O0Ekc1QmJsSfZxTZ9
         A6UaTpAYK06R3yot3UwxWWHK+kFhSZ39993UNzr/vjapw+ilf16+921YmQxxfrGSeS12
         /gn1FFQDesuJpvHrWWkS4bmM1lnSGxw4p0U0cXk/hRnyRp8u5xvu75y7KW/kHsBOVGbB
         S6e56/hKX9CLnhHYEGX2cyHwf9hYckcY8s0/7hW+o8BpOMCC88oWgszi3UAoTIqvs1NI
         ujQYYSRML+HDlWIXK+ivqEhRlaygBmJaziiy3xcOXN1UG9yT1NcagJEny0nkp+xhMQek
         R0zg==
X-Gm-Message-State: AOJu0YwJnsMsdVyUtsTs5j4JyFtBbb2Bp2LGzlqhP7Chy3JMKxs6R+L8
	zy/OLR50UTU7X2mzy2qeeyyPgJWCufq4ASa0DSZIRPHofowUNUwiwaUYb0NfmwBaD1o=
X-Gm-Gg: ASbGnctG96IWNotLpQyGbxzooIAtcasTIdgNS8psBYvdWVoRuxVUsLIhkLGe8O9qQyJ
	ar3/mvRzDvSWMV8OmZBfV8gaFAL0zaiss6d8BbQAYt4CKzUzisrBpPBhKel8xcjixwF6hbvL7T/
	qrUHK1CY4qwlzv1UeoUi4GliKAIVlHkrMKMYOM8o0ZN/SpTuwycHcFHWUDnaLO71M80D95lkKLq
	RxZwMI1J5bM3V7YYOiyQJ6e7hWJkVluZTYHwnoGB9CNAUR4jVWkcWWAUNKpeeEUG9GdYGNr4mPO
	qSxJz/k979mFIPUFPpUHRxsPDc6rBBiBmW9LjhxcbpxBMEYIiR6tIoYcyenqvaOt9FEILWXV8o4
	KMnJHakJAx7YOGY2SzqyF+YIwa4Eln8e33DdGOEDS35e5vs20+/uv6ZvAJzSHrKnS5EBlfknnZE
	jkX27H0ddvQR9DGfi0fcxyZfo=
X-Google-Smtp-Source: AGHT+IFfmpCao/YI4qPYRvNe/k0MEVLSsUtQkapDAZIbYz/MAtfhrLCaFirgnyqdBAlZJ4fmtoS9qQ==
X-Received: by 2002:a05:6e02:228f:b0:430:b4e1:bcb8 with SMTP id e9e14a558f8ab-431d32d4088mr52223745ab.13.1761148720159;
        Wed, 22 Oct 2025 08:58:40 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431d73e411asm5735545ab.7.2025.10.22.08.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:58:39 -0700 (PDT)
Message-ID: <f0c89ede-19ee-4046-b2ba-0178c62e7243@linuxfoundation.org>
Date: Wed, 22 Oct 2025 09:58:38 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 13:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 


> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Check whether secure display TA loaded successfully
> 

Verified that the error messages are now gone with this patch.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
