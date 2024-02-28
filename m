Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B413200A8
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139511; cv=none; b=PLkQ9E5G5IKUzd+7JidZ1UYZhkrNfZpy6g8NqAXGeUHuISICjzrskAXmpsa72gWuBrmwhF/gE1XoU3IjvcVhNWNPXSbuXLOdkcACU8UGi13QEjzzL4S1K+p4ZAbppZwbpAmxRfVU33fniBqDTwhKfVHlCcUPaUdcjMIGbrXQ4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139511; c=relaxed/simple;
	bh=bMlDs7yBQYCcu4DKHS4UqUXWxsAp/yIjHTqNlIRq6mA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sILuU5FECLjt3Rjgnzy+cBZe0M69fGxYd/BWvUkmiMOVoohZIeK0VLzt4BmVRzZH4fGxlic1FIbgfi3nr4pmGdfjZQOu1fyePghKnYfhDR1c546te8K+6Gy9QBiEIpqBoWrUzTaYpDMK+o/YHirAXUHKBKADCzAHTojfdUBkV0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmVWX9uv; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmVWX9uv"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so57260039f.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709139508; x=1709744308; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rYAQxmYZbaAZw17MlObOfiOcMGN2Gwvik4DkJbgp85c=;
        b=EmVWX9uvZiY+TxHmy3yItlpGy647a938RB93xxvc9zDtTZ0W54F4kzPkC+arWmQI5L
         93+Wtf7u9qcMiZ9LSwOUZsBNIX/tm9QIbCDJznIGxvM4f40XmGI5NXVVjLZ2IN5EyD1p
         ykYdT8foG7OUZWvgkhstVj+IuMmLgkHi2ISxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709139508; x=1709744308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rYAQxmYZbaAZw17MlObOfiOcMGN2Gwvik4DkJbgp85c=;
        b=ZO6wafgsq0ace3UDDXWv8wEGezP0vuqpRFKZw2xQgemD58ApG0BGicYg5SZHaCTarK
         XDc2PtMO6W11t/T/TbEXPBr+cgMuhxsinOy9qU5rVnjQ0G1gPXD8nMIrmDLZ0IhB47DE
         prC9amWAl54y8BcXq9h8CO3J1PIFnLFbqtDBlsZSfe9Qn5cIPfKFFxH2TpPOXwQ9/5J1
         n9HeYufUfON68GGW5YGgQCITGR0lO2BqeMkMD9DvjcVKRbpKkoVkfy1IQpPmmhwTjl9R
         LzXTfxIsbor5bVFAKmC6cMJVdvo6THWpBJgbEuI3hwOLzi8a9Em43GNaBHxwWjQhMXuq
         7R4A==
X-Gm-Message-State: AOJu0YxbtS4aUsUt4madV+jVab1QZm3EZ34xgCjwbJ5D7VQ4H/ijeZqf
	pKzw8tIMyIURVgOAgTgdr5NeC3UBOAQuO0PVhQrV6H6jQtOKcX6om2TBw99pkug=
X-Google-Smtp-Source: AGHT+IF7HKqsk7OlJFFWRmBCmrY8cVas7yNe8MrolNXPjuqX96G3BVToSjl5cGRFw0X7TvetVBi6yA==
X-Received: by 2002:a92:cda6:0:b0:365:4e45:33ad with SMTP id g6-20020a92cda6000000b003654e4533admr12524621ild.1.1709139508320;
        Wed, 28 Feb 2024 08:58:28 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bn29-20020a056e02339d00b0036533cae5afsm623565ilb.60.2024.02.28.08.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:58:27 -0800 (PST)
Message-ID: <2902f57c-4438-4761-b48e-d40bfc019de7@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:58:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/52] 4.19.308-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.308 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.308-rc1.gz
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
