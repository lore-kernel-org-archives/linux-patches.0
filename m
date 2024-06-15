Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16F7173
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417529; cv=none; b=tG1Go34k+klRfIXzlgV0BZv8EqAmIGehd7fAB5UYklFrn/crgeZKpsMyRVEjAhjSa3za1vm1ZYMf6bWmp4bhVbh7eL229w3qkAmQ84xHTO0Am50CgGWhmRiuDu1SLTq150NZ5LaLIOgYuuxpx0rGo5Eyf8DQQL4QUw+ogTHiEmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417529; c=relaxed/simple;
	bh=0HlJM+hydr0oOrnUYCARKSFLYrf+PRSlAOvsNC1aidQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JR67PvU+cyegEkdvoKXOfTI6x+Zk7tWkYGLhMoPRKukn9tWZhLqZejrQTesxtCNkmp7OoF/WrmijlhYDHaaDs67ydb+uQE3JsM/ms5BsCEVz7fwMDehUAPjrJfQc5ZrMjxwq+PIs2Mk9rx8zH8d+Tc5q9wZzyRWsVOmqoKVMDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLPOHkTB; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLPOHkTB"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7e8e7306174so9225339f.2
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417526; x=1719022326; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=repXjSvFkNzm82fDUnLA+bN+roCNKUGFQOpyhe9n1Ls=;
        b=NLPOHkTBprmHVvCqiZ48Tlk2ziifXR1G4vTuPb5h1o8dU7eZCJ7gc5Ifs4FNjltsOF
         2zVyH6L/CbKq6nw5s7URMx55aryk0l+JgHfSJZrz8O3WzkSj69Kj0vnEGunbRfSaHqnf
         /8ZZWNmAvzfSwoT+vFnsWtHtrvhwn4FFyiirM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417526; x=1719022326;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=repXjSvFkNzm82fDUnLA+bN+roCNKUGFQOpyhe9n1Ls=;
        b=jshSBLRn660nHi1w/Qp5BLh7iBpqkzy9+H0dr96etXfM7Fjf/UsXTrli/pC75K0FVk
         TfsT3JsApuK21eGSUXnAw3/PXNMq1DEFuXMEgCmAiki3L4fG7d0UBGpkNowM4syVchR6
         K3WpT6T0IRW029A2bLiHFHQdeB4ngZQUnjJvQmjwmTBRe2uzWD25eQkwSEvZRn2ZxeaI
         oE3OUYYXu5lMcVq5AOzWOoDpko1yXq64YhhQMYhYYa19Bf+g/ZPJMhDwFxXZDdSvNc6f
         4Eozpt5Ik1oUzRxQJ8N/0MzCQHLjmTsid94lhnHjugQGQOmvm9dbKGbnKxPAG/SQVt+g
         OmOw==
X-Gm-Message-State: AOJu0Yze4Mx2iE4BzditDiS87pRaWkURXby+VO0Ah/YITdtw1cqTdmEW
	PTV+18E1NJixBpznsf0vZSFBJQDZZoM9+Poed2USGS3ghuZZr35sZg3TSrCkNrY=
X-Google-Smtp-Source: AGHT+IHV8vX1HkLcPFfAI9zvZrPEKUy4/PtHR2mGaJiFDLaW2MBRlldZ5Yh18Yt6TmCd9T7bkLfjmA==
X-Received: by 2002:a5e:cb42:0:b0:7e1:b4c8:774d with SMTP id ca18e2360f4ac-7ebeaef21e8mr435884239f.0.1718417526041;
        Fri, 14 Jun 2024 19:12:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b956a1f7ecsm1226095173.122.2024.06.14.19.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:12:05 -0700 (PDT)
Message-ID: <d97e4128-7463-4583-88a0-bb7d2945036c@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:12:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.278 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.278-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

