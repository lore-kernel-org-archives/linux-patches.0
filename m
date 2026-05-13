Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ECF4C043F
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688896; cv=none; b=NIga2BrRoSokX6xyfF6O925cTZFwBmxPwup5e0tWSmnHoSt0XSdSxqi5wQ8+E2TqTSZVPWcOw5FyJ5JILUXnt4mU/eTQ3YQ3weCI0mIHKt5Jm3oTUhxItf+JS3uk3CXsjQBqOpbjQBnz46hW0CIpaUc31YP5GZt+PFb3NDVMUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688896; c=relaxed/simple;
	bh=IMl9rhAhPrsURjRw385PZ5F450XhA27rjsXquxxSRvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XpU6k0PZv2yevE3X1/vYvPzmeeqW7GPFjGsvsBfHAUGooI9XH9llPpwpNBqCEXvrjxANo0wq5zB443qlvgE0PlXS+ZhNipv8/2OA+KPZoBglOt+Hlt3sEX7eKoa5Yrjn/hRsrbY6RQFByF+WWIldiXvNaxkUxsUNVqND3Ld4cgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXU8gE05; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXU8gE05"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dcc9b506d9so5671077a34.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778688894; x=1779293694; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1z14a1NSTBZsCRhz0ugTYwEWpkWkPhC3ttrFpH9DYvY=;
        b=AXU8gE05Y+4+aEv2yTuG3Z2nIgguCvgLfnd0BbRWcJVw2Rwe38tElu+F6IyRZxiuBF
         VlHO71TBShhcRQZkUQiQcipCVwyGv1XmR/wCJ2XMz/vPNLo10a1o1rvKly8TymH2snlq
         BfXas1hXpjY1/B7cuLBTtd3mkJz7cvniVvg9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778688894; x=1779293694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1z14a1NSTBZsCRhz0ugTYwEWpkWkPhC3ttrFpH9DYvY=;
        b=kLhCY3M1jTCjyMKZZuoPUdbHik3QaId7YOQQTyDlCyJR/++H4LDDnl3/5VHfEdVMGd
         a84FliFSLhb0PE6DclakOoHd/wztSSrtVjTe+CsaXrv0A53wgYF58cIbcWN+U6wLBysm
         MFN5V0vTEPMPV4bSQQznwDepbeb1ZYPGeAo48BwwaQFHPdwrJC9wZqNvABq7xQTzIGN2
         hUZYuBoOtbZ448+jwHUbs3y8CFqvqXKGeJf7krpqOGV7eB5ztRsiNmFpcPSYWOZbtKe1
         zV0zqgIA5+DUBdMQ4fbWMZrffM1sGDiXvRrcb/Dv+i2O5uYCjO2t5nX6OuELuOhWDz+F
         GOMw==
X-Gm-Message-State: AOJu0YzqiVTVrpJAPtf5fGBDjFqlHQoI4HtxCu25TqB43hyf3Uxs2ARQ
	ayUCLDpzab+ZDfiFE4aB7Iv2RCsrLpJBq16iq/A+c/B4tC8OVwfJGMkr3UJXXY+Bdog=
X-Gm-Gg: Acq92OE+AYfE7DZestRFdpJ2fZgmVbMoTSTEs+BLnVeMAZeI8hZoY5cCBalBPLswnoR
	Lf7JyGTAqxsTNY3xq7Y9CfhMNknwFLEeFxd6ogFW6WO9kNQP9zNSatv0z51PornD4rLECzlRGnH
	+9XkspeKqfyq+Rob60UoWjBv0eg3jyuaCHHERO+gzp2bDVAy8F0MXUVXFOiRkQZdAOQQdSqIRx5
	41/bKmYCT/YylVFyY+BcItLwrEoKaZSascQezk5Kyhp2M/ZBR3J0lRu+X2to54I6siREF0q13c+
	PTkMopwXZFzaphL9bGAkGCjeJQTOm5pRscDn65o7lwVo71S4otJGSQkg/diyxf7EPb7L+O6iUk1
	iMtbuAD9jfCHbGDTCn2PnEr8utMHsS02pYo2aqpD0g+cH2BvW+iUnFMmpMqDGxooxQzskkSXe6g
	YKJIUp47QmVoeBfvxWi7Ego2HXILtVKuA=
X-Received: by 2002:a05:6830:43a9:b0:7d7:4639:43ee with SMTP id 46e09a7af769-7e3dc61b823mr2202671a34.3.1778688893789;
        Wed, 13 May 2026 09:14:53 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e367d8fd96sm11468947a34.19.2026.05.13.09.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 09:14:52 -0700 (PDT)
Message-ID: <775a2878-b038-4f9f-b44b-f7235da62553@linuxfoundation.org>
Date: Wed, 13 May 2026 10:14:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/26 11:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
