Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5E8F507
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791598; cv=none; b=uOwmngl/goB9hZuTjD5Y6/kemaYbmQJBwHMt9EAIiKIO6wTcgrI4d0N4aXaUQx8kyhiLiSlb/xBPou0dHqWmULFCoyOGIOwaHaTzvBqsV/LUndo6mSO8OGcLLClUV5zG+Ue2PT7hlN6Bhtu3Kt8iEUOvn+JImxa3jVL9ZW7L+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791598; c=relaxed/simple;
	bh=YIjCJiL3NctpJ1FHcOVJI5OdXflucIydyzN1gcoqVU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uy82fEQt62N644pMNkaWJIEJBTTMf1ZoEiHIIVKuC4sza9exlu+/Qx+MRoVia5Hu42dXP3PZPnYh5adabK7XHaE8SnXihefph22mKtxC0UuLRWMXJJbH7zN/+ej1RXf9N8c3cunw8B7kZFwc+hKukEvoO7Ku3Q+yh/vkR/hBEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8QhX/sL; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8QhX/sL"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83aa3ced341so61621039f.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791595; x=1732396395; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jAKrBwFw6AjN3w1/yul3Y1aZvpZYxgPpFC14Ia69JMs=;
        b=I8QhX/sLAWha8kdWvMSLcyfc30wlM1AI/Zre7ZU6M+BBY9tdJvl9iLoRwn68A5e8+w
         3MSEPStVmBwH2TVbKdLXfJ/UBZHoGsthapTeiT0rw1bA6mcf4xTAkXrBCbsubAwghH38
         9Ft/+MUJFqLU5SxlIMbaVaxPcGHxVfFj/AYCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791595; x=1732396395;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jAKrBwFw6AjN3w1/yul3Y1aZvpZYxgPpFC14Ia69JMs=;
        b=AIpbnQeeNflDt8byoyZhd+R6i7OiZ9PuVNyH6BDNGVNmV/fDlx5Pka9PcqIYJ3v4jr
         uCoENHZi6m8gZEuXYKooPuVOjP/gSLP4EJDYHOoum5QVHsYtkPPVc1nj7ZgTzRlY4p5x
         ZhggsaziJ5jofEzjsCPRNmHelC08nJ/1gZ+CZhrzui1oHzEkw25P+uouDFEPnC0pw18h
         oTt9JOGXtqhWWT+Lho/pFvp8FqJEVRcrYgGoKhebqhEFYItZO7nbPKhSi+eHfUiJ+O0f
         Qc9uO0U2KKmgumeR9yz1JibxJUN32HUCkE7rIFBuaMfVWjcsUJcw6ivVK4SUiBqtxGrA
         ItHQ==
X-Gm-Message-State: AOJu0YzhaPEgAnzCLOLlhKDnHf2NIOZ1cWORIxO3hDxmP6BVJaHUQNhQ
	PZ7Dvk/MfEEKEehcKGvLW91tsla/6rzcuWv6IuyV0Xlj8d+/0iRIkDK2rKyvUzk=
X-Google-Smtp-Source: AGHT+IF6IYnGCdfNBUtKzZ2Fl+6fZVHiVr4UDDDTVvD8y/wnZBu1qH2mWddE/Uoh/IxHTrLU4eWlkQ==
X-Received: by 2002:a05:6602:160e:b0:83a:ab63:20b with SMTP id ca18e2360f4ac-83e6c08a540mr836596939f.4.1731791595322;
        Sat, 16 Nov 2024 13:13:15 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d72d940sm1247007173.68.2024.11.16.13.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:13:14 -0800 (PST)
Message-ID: <699ce371-3d20-4859-bed4-2f2ccd9fa3cf@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:13:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 23:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.173-rc1.gz
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

