Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD833F9D6
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791168; cv=none; b=VPpm41tU/5BCRMMvFq00K52ub8AGplVM9r1EbQdN19bADdcVHCTZVCWbpQxCnaGgzB9IgWC1s4Jspe8X4DzWwslFmXch4HT0WtJxafohJL8WhXo3DhKrTKtaoRmInYrM+cqbsW3YQedBcAPYtklM668fmzxq51ezrp7+K4LGQIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791168; c=relaxed/simple;
	bh=wn9xCKXToTyI9t1rtvyW1oEEfrLH5/5AdrmpGh/vjL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3MLh2CQMXe256WmQLc9OkwseqG53OyQArhz5/kvrVN4xhhcUpQbIrgVXXjbMwAp/a5uraqJz3bOWUuV2OBylOfYC11YoEwl+mBg7RR+fRpsU418RmRYD3A/KgIvL7gYTcvOaQ3OLCjHGIm2vfhEdFFlQ6xHn0lbrKU6KOI41y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BitaR86h; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BitaR86h"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a7546ac6e6so1887635ab.2
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791165; x=1732395965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z0AbCMuB3hBadpOLkxJkWemVNrqkK9LRa2QCq3z5Qco=;
        b=BitaR86hDuAoctB1OpMkUL5/CMuCekPWFDxkFvvBZ11PJlrBmmcZVX3oyMgA03+Pwb
         6vkWN0O/vRJPfsjTpV0dLzpbpP7K93IS+vQKJivp4f6nR32F0+23zraWhL6kw1MX1d8v
         sxSfYGZRj715CrMOw0PZUUIp5wAsD2qKW7Y+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791165; x=1732395965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0AbCMuB3hBadpOLkxJkWemVNrqkK9LRa2QCq3z5Qco=;
        b=A0tXmfNVxm+M8ojt8tgDqe9e2QRQtVpuvLUm6OivtLaVjRCB/gkZ2ywA7dliOyu+VQ
         p5DP0xwbBhwAvtuANAOPKfJYcNDbvdjjBpEPLwkc1uDpHAq3XBXCbGYzlq9gGbjqT4Qf
         J4Tje+S9AJZGM6UqYSO36y0yl7M52SJDkoee8a1784Tg4KLnD9OwAhwjo1JdQ0HSPWLv
         lUMxsjAeE9haRj/xv0M6lizFJGaml9c/wCexP89hG6VS6lsg1j7QNFa/sFN910Hmbrx4
         BnPMglzF7KsBF+ruu6kYWVjKazIQaRz8jNNzaB9mfgK/FUFEmQA9X2a6aqw59G4ANKGs
         vRLg==
X-Gm-Message-State: AOJu0YxNf5/xTdvLscbdLexuatQADu1D6YDZLEuG27T5F2roC5Sv69x2
	VkE3MXpS+wdGPiuQAGUK3l7mJRqVDmRCzT6si5rm7ASwNVlb9waY65G5Xg0UcnI=
X-Google-Smtp-Source: AGHT+IFLAGWpLruvWVct/AIomQLfHk786eMYKwC2cfKMYTqTaAo0hlwJFI62U1jwxMViXP9d4Ur/sw==
X-Received: by 2002:a05:6602:14d6:b0:82c:eeaa:b1e0 with SMTP id ca18e2360f4ac-83e6c12ffe8mr679102039f.11.1731791165065;
        Sat, 16 Nov 2024 13:06:05 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d6e7374sm1174251173.32.2024.11.16.13.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:06:04 -0800 (PST)
Message-ID: <5ea45f0b-bd60-4603-aed0-10f70e77096e@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:06:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 23:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.62-rc1.gz
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
