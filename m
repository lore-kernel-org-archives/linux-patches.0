Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8D119E975
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741711680; cv=none; b=vGk7RgjNc4VFD74zVBhKxTNluoloP1pFjyy912tDWA0RZRGB0Hnsb8zfaEEHuzCJd5aHeG2UDkFqRD1BHeHSJvKCLX1U30pnpFXG/K8v3UgXcsVCq4M4TJoOHq37vTCTDizjBj+waBEBCJKHt/5hjyJdjs22NMkXfGKGitlqdQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741711680; c=relaxed/simple;
	bh=ltNZnId99TBG9+FOkJZg7yKI5tAEjGEUIIVmvk4BJ3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUJjHhxY94MpgmOoNBb932kUdKmUYi9M5V0QdQXemISl0kq9EYNmv2w5DQQzJEU64Ddv/hbhJG76n4ZrQBbCXAIQaKQ5wSMQ7FkMCYUUYaYUVN8CXS+lAyCZc+84UlpHJSiS4+Xdm3zxvZL6gpk9rUJmIEiCnMFsePSAtZpf5+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPs/oOBt; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPs/oOBt"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d445a722b9so20142175ab.3
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741711678; x=1742316478; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eIelccZHQZk2+ndDXbKBajYZKbjgA8vG2Sfh/B1954k=;
        b=cPs/oOBtrDsKnQ1kjtFbNRXx8/HpriWX+3kTJ9aOTRF/i+EscVoE3OXK94CscyVBru
         GVENeqDBzh2KX8QbyxK70imC9x+Ql0xKyRDh4mrLgVeXsw9oYosyy2x9p9dwd262AZBP
         o8HAR6vvYn3qk1X20IJZ6b0ZvX1A7zy2EjSyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741711678; x=1742316478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eIelccZHQZk2+ndDXbKBajYZKbjgA8vG2Sfh/B1954k=;
        b=VPtaBQvzPCgx9n/CPq6s+c7NV+46eHWSZpX3WgytU1n2Bocke2TcBhk+rmFNO5odpJ
         onFw466vxhDuhVJDgblM7xSw6krgjPeJ/1C10hoY5f7XwEcCXZ9knUmAjBF4+DyKb+ZI
         t0J5zcZm5FYWKtPr/dRKiS6ilL4evtJ7CVg3tFUx7QPSSuEN2T4R4HHSMJ5qZXscjV3z
         Os/XZacbDerC8xKDMal+eVlS3DR//+BmWDop4OxYaHCXijo07qot0SbVRNRmyAgZkkgw
         TB5igusH8tZXFhuSUoxDnIs4qN4cjln/NfAmJgG7yt4ieSF47Me0IJoBzu6UrTiTO5vk
         QIdA==
X-Gm-Message-State: AOJu0YzX32OtBAc3kf4u/dVFVn68DrQuaKLml9bitFrlEPpbILDGGLEL
	LnPIrxsDEsTqBT7Oal73On/FehQrh/zNpxG79WF2WqfWYBUhTFq1uaRhE0mxEOw=
X-Gm-Gg: ASbGncvXRKrVikx3rVSv4FLl1rfbDVvpib77Jaxr3I3eFIR19b8ENsvbd6cj5bpJonL
	vvTIU7qRhTx1M11OHoySoAMAX5YKY1MFYkPXfTYX92xtJ8tZy5sat9g6g+sA9hfz0mYYs4/X154
	AZqIOsfOzr+thqrhzFDlefaZp55ZhB99O0ThY+pOPS8E822c+JtmZkg6tJUqUE25iD8TUQUq7tn
	jyMPpQPRQ6t1uVw2PFNLKYwls4U1tI2gZv3xgHr0yC6IEEsmn5PRLuEXbGCsj5B4nziggOFZOlL
	caRtC728G4MKvyflPb0Tcx1XohxsHX6bNxdeWn0CIvLM44j7V1IxISfeoqBx60K9mw==
X-Google-Smtp-Source: AGHT+IFDdRp0z25FQZ/a/6jHqnCfBwxjRuZ+/4KP0GXCpPYNTXRmWcdeY+uBSojv6boITzpPUPC1iw==
X-Received: by 2002:a05:6e02:2142:b0:3cf:c7d3:e4b with SMTP id e9e14a558f8ab-3d441a12ceemr239262975ab.21.1741711677772;
        Tue, 11 Mar 2025 09:47:57 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43fd73234sm24748195ab.0.2025.03.11.09.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 09:47:57 -0700 (PDT)
Message-ID: <fde3d71f-a152-40f1-905d-1aadef6175a9@linuxfoundation.org>
Date: Tue, 11 Mar 2025 10:47:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 10:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 620 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz
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
