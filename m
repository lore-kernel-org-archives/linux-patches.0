Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8297B1DFE0B
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755098198; cv=none; b=XBP6gt2LlzUylvGJzwNIHwntod/lthUnd6TmwKyRRkNrpllhiV27fG74XmUPh9jWiLE563qyYuYKKP3fmiRgHP2ecM2CWIGcMq/IuXyoDY9IC7K0ijP5Y/+vmnsczumjN03eHBYY7bU3V3wd7xXhq4ZwoiVt1vxRi2b7n+NBOnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755098198; c=relaxed/simple;
	bh=YWu6QysTTta+ygIB5yJvbhmovNUrZ+mY2Zbvv1O16X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=anJHFREawQAL0+POhZJls4HolamH9XUft/durdRXAoz5qxHqKlbEQ9J4my49V47fVeMc3HuWzTsjxqjMCkihkoEhHpNYPhJQODR+ySv8kqkZcgWv79jtKPTv6tJRY5aFAM7dyC4BhfXZNasDgcvdkIVad1f0TgpT7X4mmbFPai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRmxeBe8; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRmxeBe8"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e406ca2d22so35743895ab.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755098194; x=1755702994; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shieCgzmVFkz48fGZIWPswfofiSSkJbIXRswAa1EobQ=;
        b=ZRmxeBe853/5hUNkTjM+HA/iCtMRB7Wz14OkGqGaaPrPbmJZyZSi2yx6uQGYDVFQ85
         /j1r4BHioE71Bg2cPAGyqB2LzjwCwow+etJsQjFWcgTAeEupw6epgymAqaqevaYkcazX
         cLHgBVr4BDqcLFO64Zi18/GJZoWdc/ccs+Ucw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755098194; x=1755702994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shieCgzmVFkz48fGZIWPswfofiSSkJbIXRswAa1EobQ=;
        b=tCqwVMf66zjpx78R17XAm2Q8Nskd9xm3QWTKSdPMKOceAGBh44KbJrXDQRyvx8Ixgw
         sHMDG0tX+WjWeGfx9VsRiI5qWVqmF/ea4mqw6J25Uq9N2kDGmBcZ6oGmyM+Ykk0KKbu/
         Ljxf7H3fxP2H1NXE5HfzMVz1GCn/YjNRozrK9ZR621DHSqwkmPMJPcf5PfxDMcP3dXqi
         cDJO+EBtXu7XHyMo19FlWZP++76C+hjLqQD220lfcYgYLYAR/yKkI8RcEKHvYDdQnoe3
         tYjWrK8yzrpB0XQCRTTmp1nHgiXfeIGmUyvvH+6ou5NprsU21pIh+JGFhEymxdOTrMPi
         DTVQ==
X-Gm-Message-State: AOJu0YztKjkvA/mYlqBJKI+5UqcthF11zTfIG17Lhnj44jYAwlQhLRRj
	HRKY1EdqgbMxc09I4NJZ9Dv1HjZUeA2fHiF2Z1bSgfUVaufrcqQFdrmo5zfWYHIt4bg=
X-Gm-Gg: ASbGncvaMOrW2HG+MJKVAZ3SkUTi3VMnj3Zw8V+BkgF+xXVBnl5HAiPnFgdAgLDLx+O
	i+wIx2Dvcc7LqTAtKzYJUSLxWHfx76NsB1GGX2TZWvVI7ng1JMLsWJbrxSLOKGMKrNM/upSvz1j
	MfY/wcj1p7hzYSDSRpkGjBnEyjCDeJJ8iSNUaseJMVS4WK8rw2+V1KaW6797r8n+oXYUey2L69j
	ZSXkrCm5i/dgbJN62ban/cnZXbtSlCNkbPcdOLwbvbFmHxQIk9DPttIyekUNqDO1VMNpAB1c0Fe
	ijwuiBb68tcF91EN2TY4p+CjoV9PvCharc80KrZAB8aZcOm+bUq+omgHuCV2IIYw+zK46tE22HB
	xvnEk+GbianMH+UB1tAQILasBBi7BgMvr+w==
X-Google-Smtp-Source: AGHT+IH3h+VIDrQjN5ai4jcK9ftE/5NNjveL7L/XQI2ggB2zwH69RAmhjvCcKUG170OJcY5Gh8frWA==
X-Received: by 2002:a05:6e02:1fe6:b0:3e5:4b2e:3b05 with SMTP id e9e14a558f8ab-3e56739e3b5mr58175045ab.2.1755098194414;
        Wed, 13 Aug 2025 08:16:34 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e54270f79fsm43167685ab.7.2025.08.13.08.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 08:16:33 -0700 (PDT)
Message-ID: <0e8e6d86-1fd8-449b-aca7-5ec86b049267@linuxfoundation.org>
Date: Wed, 13 Aug 2025 09:16:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 11:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
