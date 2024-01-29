Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAF551C28
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 23:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706569562; cv=none; b=gJIQLw8R6QBKTmjWDDUFlALEljhtw5FEMgFuf7mI3pL9RMrCkHVZEAyT+wSkkQ+i3p++9EQAlfv2Z6jJn/Sq7uXHMcalOS+CnXElAgbPxHBKFaz/pKbMZ1T8Maibo15oUZy+FdLIwNaQ9bTKN48d9bLy53Z1NW3d16uD1IHh/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706569562; c=relaxed/simple;
	bh=T1i+0Z7ACB0e1waX+DNelGsHpBxFRWm1UAJdYGSjW3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWo/RY+3NpdORoyznMwCjkMpuaqgzDUQQJrdRuxWA8EbgrGqXAkVqbCmZDSHMuFRS0NvCiRqS0qo3sMgxzD44a2BIfNJoCuiRryxLXcR8cZ8wNf7UTKr7zWrGrSmJpotgNSuvu7mgVCl6ElJ3HT+rInKcXjlVS8EJrHK2YEl75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjqlAGIJ; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjqlAGIJ"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7c00a2cbcf6so3974939f.1
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 15:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1706569559; x=1707174359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DtZNDuZTycih5i2sdrujtgrVVk9yC+uswOIOzkl33jM=;
        b=UjqlAGIJ/hfY5jszJ9WmmtSN6TBPwyFnD6A+20MToNmxfk18byA2BvadIoFESJzuDj
         j6Pay7VmMIvgAwJdofZjLctEoC1zvyAkx0gya9j0wQpwaoNLQ8Uvq+pmhoc8QhZB3KzT
         VOqVtADj2Qws/cSAFunHLUjFrO6Jzu9zeGe50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706569559; x=1707174359;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtZNDuZTycih5i2sdrujtgrVVk9yC+uswOIOzkl33jM=;
        b=ZqmN9pxc9N4QY8XPIzVR8OcTIBrYJu8upQJGV6yRkVruUV0YtqiWsK9nuYG9liqdFn
         rWs56wrR3YxadjbG9ZxwdYNrt1q+fpSLYQtTYvsqKY14sqW6hDWQeRAtX21Y9NhRC4KR
         Om7tKq2Z/uPVVoCNcX25IaNkCTyeufnXcRQFHKKebYuaFk04l1iMLZ0MZ9cPD5KYtJrM
         /+RU/7cOEEfHNrPo6/0yAPyfqBjXrB7IdYezRSw0LKPWXRuDchNjq9RsKKrsSUSvlc9O
         dwDXAey0ZtDbNX3mY86OZZDsBs5oVXqUAGDU99fKZzGBjN+6/cudrxG8x8EYul5gUe9D
         gHpQ==
X-Gm-Message-State: AOJu0YwvH6HOciR8TlB9pMTQkAGMYuFTQF3VWviwWUlIJzhq6bSf2ahR
	XEKXh9yHqWc2+jEYFh2dc04WM3ZV7JNUAF2tCDf2NW2HxahCUE8lhEW4TDNrMUY=
X-Google-Smtp-Source: AGHT+IE6XcnK4WKeliuDrDTChW1y9AdUOP8cK1betdjliW8+3UzXaLc7J+q720eiwMh/frzYuEP3zg==
X-Received: by 2002:a05:6e02:1c8c:b0:363:812d:d6a0 with SMTP id w12-20020a056e021c8c00b00363812dd6a0mr4567440ill.0.1706569559541;
        Mon, 29 Jan 2024 15:05:59 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e12-20020a056e0204ac00b0036382acbf8fsm822713ils.24.2024.01.29.15.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 15:05:58 -0800 (PST)
Message-ID: <b74d661a-a857-4c7a-99a2-e5902f174052@linuxfoundation.org>
Date: Mon, 29 Jan 2024 16:05:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/346] 6.7.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/24 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.3 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.3-rc1.gz
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
