Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F1E27E1B1
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 21:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442788; cv=none; b=We3li7SoNVJ+a41TMuBJun3juFfscEgPFH4Y0GF8xy3qS2S4UB3jJuIyRTBNfKs/lQHJFj7kUJWyoO9fdA+OHzcIlfbInqJgcbotOaTPvnW6smdrwVrA6ge5dGnEBD1KD7zyrWsRPDOhr92bD+2CQi5Hez1M28hoG9DBZQTDXvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442788; c=relaxed/simple;
	bh=E//82LOYPiTmGcYh2jIvd7jDfS8n/1+ryqbT7Uroeh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hk1I9prgiJzNlHTTioDWfRd8eycN0JjBbSMwQFg9nwgCrz2J0A9kcFfPxbAcEYOr/RTTlGRkI7gPIkjmgj3TyJGhRPQ1uy/Cmh9mVwWdxs3OJNKr3FE3xkXdHnPpW0Sx5a2VBXTDU5I98hsC3ue8UXSAgaxivokC7CvbdGheLjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXLzCnQH; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXLzCnQH"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d7f111e9e1so3266995ab.1
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1745442786; x=1746047586; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xJl4xnZJ7CK5VljYcazrir4C/qZU01ruca5B4HK79Vk=;
        b=BXLzCnQHL70HGkDzR7tahFgmj96YOLSn0EAUM8VdptZYXoytZRclfkNxXO3+PtHaus
         0xqaCgPIoo/32myy7DKsUZE30sRgRA63bsaRGFpJFu0gZmKf4yridK7bFlCMJ4XdldbE
         PBxACZcfj2cM/7zfTfyj8uijHn9n2SFw+14zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745442786; x=1746047586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJl4xnZJ7CK5VljYcazrir4C/qZU01ruca5B4HK79Vk=;
        b=qjVz9UM+SJ41mNNF5Ts/enT8s7u6h7h/xwngSvI/pEBmb19YfYdwTuBANZgU+6SLJ1
         LuD9gM4UVbC0KKg/+EuFwfuyhpc0fqMRWeh+YR2h4SJWhugxFM0bTUASli9Pil6kzYwl
         plogfWRRu2di8W0Vsw/kn3eqh9PU5ct9QzvKKso/2/MElCL3dsSBZ7nyt5o84YSRvOJX
         q1SUKXbMM/E4VEiXihxewGpsfTk34X2pDJs8+KwQ+sUNzYdvLJKisK9oq7mG9VzNo0vj
         KRk6KslqbQyJ0fxNHNH223wMMOWlNx/0XPHz2DA/s72LUWmaYoCDIN4Hmt8dSkMZ/bmW
         9Kyw==
X-Gm-Message-State: AOJu0YwTGKg6eWfosUtP2+2Kp0Atbt8uD0VMcR6NOxmQ7aBEkWXsyMAQ
	FTPKTiXP/+bqEGLr8WEI7MFPNxMnyulirRZmy+ymYX3P89OsamhqRaCgZfRux04=
X-Gm-Gg: ASbGncufX/lvjVPHhylx9yZnqsSUt9yxUDa/4LIOy6D6SXrkEPD3nfmfLmRdkq/wq0d
	0I7cpF1ODetQRzIh3PqBh+f9dB3RFm7LaUefxCa7qcE0JnzjwnFABv2nxT+O/RdNGlMCtmYw35a
	JQV3s6CESBlfdN2jJKMMKHli272R3pod6hoFcHmnPeWBdau/PeIeIUrDKNXoizpOzX0TCKThR7V
	RobWCobqAyOV/5RqYSw5B8CVosG14GXI5AHZrWcgWiRqUhwhSPzG/v9KNurWXtN53pSmmimmEVA
	PR4I96FDrognlIvLVfL7iwRhD/IYDVYlvLLrPpAtPsBDENIDMSg=
X-Google-Smtp-Source: AGHT+IEyZDCabZuyz0Qo8Ncebji6UII8VsX1nanFNy6fPYhte3F9BgT0IArHsl2sKVHW0CRT8FjE0g==
X-Received: by 2002:a05:6e02:1d9d:b0:3d8:1b25:cc2 with SMTP id e9e14a558f8ab-3d9303a0901mr2127865ab.8.1745442785773;
        Wed, 23 Apr 2025 14:13:05 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37f9c7bsm2977167173.37.2025.04.23.14.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 14:13:05 -0700 (PDT)
Message-ID: <23e1eb72-c445-4aec-9077-cbca66525f48@linuxfoundation.org>
Date: Wed, 23 Apr 2025 15:13:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
