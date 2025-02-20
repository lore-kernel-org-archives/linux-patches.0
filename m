Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4333020CCF2
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740068077; cv=none; b=LEp4hgYO3huY0FwyXGUSG6GiM9efdHnA2cSvvyInYBg29ncn26HDMunMxQZRaIKZCXMvdna5wrVWZ/O+U5CTrBgqObyVwbs10IaNl7hTwCZBmN1E1bpV7bIWJ2zF75f162luQeOGIdauH1OHspCUiVbIOM2gNv3WKlcpXOvCox0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740068077; c=relaxed/simple;
	bh=AeWS/JuF83zRBQJJyVjU8mcMgJejFBEFiJlmItfKqc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iJVTDB6GDB8+hMsv7eO+MjwfcLqX5Zr5hRPOIoN4hKFHEUOOJbismW839sTvGxlNMt7ahtrx7A9lV1HLx3xpkEuQOqSTQ1Q9CGFFfprf+PeoLOaWIzduSGr00tBzYOa8X9DFIpwYhvEKE1j34gJGqv6pwj40AkdSioO7MdECkyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYoj0cNx; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYoj0cNx"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso8672675ab.1
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740068073; x=1740672873; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dI0srPPOo8S7V8Myr7HFucm2ZHT05UfWeqQYkZ5WTeA=;
        b=KYoj0cNxFn909p8PGanqeZfmHQrohMysccf3DH8+NRwDovqV4zMRwwzOyKnam2HrSa
         o2X58OdSAg0NEoyBkwHMPyQB6ujuk+ExHhg5oMFBlqwz+CYZ+GzoxMrNB8blVWCri/lQ
         Ye3Q4XbNSFrlHnmbW1/bIDWmp8jyEW0HcuISo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740068073; x=1740672873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dI0srPPOo8S7V8Myr7HFucm2ZHT05UfWeqQYkZ5WTeA=;
        b=OBhnios7/417NGRBaTWg9mDIXvagfOxIV3oV8lUFUZGpOAlo3JKcDL65Vqmves42oV
         ytbwnz12udRskCdV9cJojZKbXH8C053HfuSgMpk9cZ7HWuTYejpNxQvBRlSZ9MQSqgT+
         sezwQwOtd2RfuIpfvtEAQr30HqiR/O+bB7rpRnlh3RRXFzwoiuzIGxhWcFqdNovAQKhZ
         1PqqpMDza1+Ap2yz12XZZcysZn6R5By2gWCKf6yqUj2CY6OTwvKuIrPLN09C2jzfplYo
         /ZdIBol1tu8A0OCZW1EEmLSooVhyzSBKoLYknTT1afTPfVGMC/up3h1iWJNOKvlU8uVx
         sv5Q==
X-Gm-Message-State: AOJu0Yyir6oYr3VEglbFEv6Ms83nxgkY4vtts8I/6jBn+zFwVSEAbwdk
	KQr5+15NXl8hDMlTIzloznT6UckMCAkWE6T///V07Py3QCwYU6+ESZ08L+lPiRU=
X-Gm-Gg: ASbGncvweAYZtS4IkEOpsEE0QMfJvQyvpiBlgKI+iV0XpKDwpZnHKzThzfzJUXLv4yi
	7Li7nbl352XmVC0OIB6KOV8cDSD0a5ZRyJL1jwXjIsdtIUEevbv5bw9hXBT++BDJrlrHg0MtRRs
	TwnmLB21TeyuXq/w5F8gW8j6GmnrtZIggfj4T54ZTg4hhLWkdMz5kXO73cv+8uH0p3PKu/JZ9EB
	3jppAckEwbXh7f+rC/6ADKVu1OPuGslZhGeUD4643pZA/QQWvvgjCDmQtNseLEhGJLwDWuk4Vpu
	CbpBHWoiBbPH77vhYbKybprg5w==
X-Google-Smtp-Source: AGHT+IERvZlWYEeZFxmoldq5ZudEzhNy4QwhwxU996FqfPDpmWgYU6X1zjIzJ5iE23uPC5Ep8G8I/w==
X-Received: by 2002:a05:6e02:3285:b0:3d2:b509:af44 with SMTP id e9e14a558f8ab-3d2b52bcc85mr108180595ab.8.1740068073182;
        Thu, 20 Feb 2025 08:14:33 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee8d3b29a2sm2449370173.8.2025.02.20.08.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 08:14:32 -0800 (PST)
Message-ID: <a60c071b-f30a-4d93-83c9-d056e7130b68@linuxfoundation.org>
Date: Thu, 20 Feb 2025 09:14:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

