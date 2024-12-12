Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7B11B6D0A
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 20:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734035109; cv=none; b=UxrRtZVyLJf9+23GRt+AJOjEBuBXtZ1ITsj230OPA/Q5Bx2e+4WpFahknfPHfNRQ6FpEiOaQL1FDU3Yo04qaOMexLi3gLAVLtTLWWd3wFR6GQmmA3TU9x/hMcr+bATAjVmtq6oIKwjuOgMCCRwL8M1x/5prhW/ZbqZyad58MvyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734035109; c=relaxed/simple;
	bh=Qd8ZBm3p8yVf+a3IlpOny97+x+Z8dg2dk2ElGjs8FCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyDCFvdTTcY9a2yNuzqCKU5zXfixN1Xl5PLm1evJYXRvP+11IO9zsviaCLl3FItbv3juKYpHKYHR2w6NCsv/VLI49nCFQu+8tBUHs556wfYSBxoovKU4HUw7O/xvUkdDx/4NtTPIm9kIz5C6jZ4ytyz7/WBOl5rT9uJ7Qt2PMNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gg/5HWJs; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gg/5HWJs"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6d8f1505045so8829556d6.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 12:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734035103; x=1734639903; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WsmWZKTDUFGjOeAhXzV23hHoSQBuVuhJuLt5WHiryh4=;
        b=Gg/5HWJsvbUFpKjaTE5VUM/OQvHQxM76nWT+l/fus03/J0MttBEeq+SO6D9a23Zu1Z
         opxZaTOlLJZnvt67y3XF4XenUuiycgUY9qBlE4BdDNY4BSmlF5T5hduis2SyqjE2dQK5
         wVjlAdPCHXx490GZ7bjsEhUv8Whe/dko0lYSOFiemf2h2HCTCNEesgP7TzOHAbDT4zot
         5dy7Hd+LsyVm8CBcQ36ZEVN1FVz11RcqNcxhcxBI8KGr7SJ+DH5Fn4VcgK/CTJx6Aoq8
         PAm9AHpcEUQI/o/21QnxgzfMmK5SyPNhchzHe+GGZls2R/jLFK6OhpDk4ufuG3P6rBfB
         1Vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734035103; x=1734639903;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsmWZKTDUFGjOeAhXzV23hHoSQBuVuhJuLt5WHiryh4=;
        b=o5kzgOtRYKZtUXhd3sewUKcCeRO91rg3LdFKMSLSQr74yDGwGnoWfb90uWntjgVxg1
         TwmBQNnnyoM0C13ywEyYx//Nny2AjwrjQleLnz9CBgsK+TC3+sbqNtUtqBIkMRjLa0rR
         s5UWCcPBkBj06j1DLCvPdtX/WnfQ5fR80eoFt6RyKXSlr4QebR71xZWDGuZFgHlX4C56
         CJWDpljvTNVEf4G3mu5r6/GRuOf9+GFNQfP4HwC/tPDjCSlsR9rgx8OfF/JQJOGcpXNQ
         v1LbYDSfCRINlcIUIne/XE1WfPkhXAoF6mst7AVlzECbnBCpE2ex9GGrM9459udI2ByQ
         WgTg==
X-Gm-Message-State: AOJu0YyaESi3iYYfY+OykfglIDXpX4lg5y7TSNm84FWyYpPc8NFdyyfb
	0WQKuiy2dVpMg7AwmF2jiRHHup9bb7AVEOMz9+PKabSY+BCyvj1r
X-Gm-Gg: ASbGncswXia/p/19mbTgBFsk+4+Lixc/Ou5FtjA4wJTba6DqPDrC6NcGUKdxO77PaZd
	qKIxY5BcT93oqDAvdJYqPnkpm8uzrDqfSD3jUyAs8KA98Cw0FdFyKGzb0GqeXpoPYIiKm32hqs/
	lQJLB1enETW1Z3W17ajcPuz6V5uV5YTzFyuFdVCiSGyJK7sgdZE92q89FHuQ6F8MRQdcXdTRZR1
	gmHXBM8NKztmEr+4XfSQwo5X6jJ/NKrN4FktvVIpUYnO+dC3VUp3WKRVMB1R/5XwNTnqPZ2J83D
	6H877dlS
X-Google-Smtp-Source: AGHT+IGgI6grpBZif/oO6iQOjexftekBRamWqawbZLPN2nvYycghF+WAN3SGJ+A1++FPntqfVBMsow==
X-Received: by 2002:ad4:5dca:0:b0:6d8:a610:21cc with SMTP id 6a1803df08f44-6db0f6ea959mr20781636d6.1.1734035102929;
        Thu, 12 Dec 2024 12:25:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8dabfb7a4sm85151826d6.104.2024.12.12.12.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 12:25:02 -0800 (PST)
Message-ID: <a1ec91b0-6a45-4351-bd27-8fe35ce87711@gmail.com>
Date: Thu, 12 Dec 2024 12:24:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144311.432886635@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 06:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
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
