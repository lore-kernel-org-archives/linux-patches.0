Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334EEAF6
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791944; cv=none; b=i0ZVCu6KLgHck74ON1vRBc0/ael3Y1IUvokJzSXDpm+8tDrDsWf/ZJN26Tei7168dTZcUZjiBJkzRbA91ajlh7/Hfi5dJ87w/a872GdYfUjMzxtVxN47lsNrQZgb/ChhnCTnBOJOqjfpevPsDJcDwXieOFyK3aDwKdEHY3ULOsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791944; c=relaxed/simple;
	bh=ATCDMfq1ap+xVM6eDu6GAm8UuTQFcxafUK21WEUFtU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8cnn2dz0kbrMObvwbZwBsNFHNXjGoNIRVq+06FXCzwxYF8T/F5bNLdhoM7wuFDuEt0DLf6DjCKTtqWaFUKrwLrMynJfeBHbfTlDRxNmi52fl0cEsTGNTNAL7MakTCJmKTP1pqKKJM4/JB+5oCZrsw7idzrxohHCxduNWaaVuxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePYO7gpO; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePYO7gpO"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83e5dc9af36so95737239f.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791942; x=1732396742; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vH/N1Ah7ld00p34JtPqzQ6F88eNrq8g0hTlulRI55uM=;
        b=ePYO7gpOeCztAOabcL51aL1V5Do9mgEKWPT/BNBOxsgNRSOGh9r5KGOrJXuFh7QJSA
         PEHUcu4yQhRlAW6dIQiW4xUchiPo7oex3X6p3OiEvwQRX3gVWoT3X75Ut4NUj/qkC6np
         bibCe1YVoM9iN2dyuq/bc7OGQVLTdzreq9qpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791942; x=1732396742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vH/N1Ah7ld00p34JtPqzQ6F88eNrq8g0hTlulRI55uM=;
        b=vVRPbZMe5L6qIkIsPwOOcOZDa3cZ9ucibPEuIwiGhbXn2tdgFgnIsDa/qIXThv5hYd
         T1dWGKZVvm12HECoQju2feik2GhTreF3qR5ghAuTIosS/a0F5Kc12UOJml+vvo4LKlTq
         08biqMnSb+Uyn614kLONjJSrqOPxYquPFjlE7NWV7/CDsaI4aILidngGPLguFWgMgrvP
         fr3186JfiKI4YFdyBVJFXy5jfugkZI6RSnmJ28DK3IhSudUrlreiW4GOqB6xmNqFLHSz
         vO87vBFisSYdiOJ/NdYjybgO4NrYGyAsO86HKxvkrcAWyH58iKhdqnlAJKNS9TTQmQqu
         +kyw==
X-Gm-Message-State: AOJu0Yx63n5EuT0IPsddzLNBJcLpVv16TO+zdH4RZrAH2XgR1ggkxwTY
	axHYdWotazryeLywCiPIIJOWnghGIjAWvBpjRNEd1sIENncToYbXA2fjsQqTe6A=
X-Google-Smtp-Source: AGHT+IFq5s9Maiz8mB72S8XNfESsKb86sKgq78MZpNxGDzORIvnWzE40RzcCjyYFXkV9FGACyi9G6w==
X-Received: by 2002:a5e:cb4a:0:b0:82c:ec0f:a081 with SMTP id ca18e2360f4ac-83e5cd850d6mr1054234339f.4.1731791941764;
        Sat, 16 Nov 2024 13:19:01 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d707987sm1206884173.34.2024.11.16.13.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:19:01 -0800 (PST)
Message-ID: <ce63b792-7430-411d-923c-39aa962ff35e@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:18:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/52] 4.19.324-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 23:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.324 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.324-rc1.gz
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

