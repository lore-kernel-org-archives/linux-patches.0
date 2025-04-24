Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5C318E1F
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745498833; cv=none; b=qeuQTJ51MW07S/RoyzrrPBQvB+qKRravHwHgbmbj0/2XmKuIC87acTlvFmjRo+ifI/YYvABy3jniZOm0eYJD8StLWrsKwxq/LbFYf7/Ir8D4bzbxDTSGKKCsAGe0zKaf7dvjNKPsWiPFLZL/Uq/GNwSktFm1FUu4LQ5jeE9gYQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745498833; c=relaxed/simple;
	bh=cJRCjlsCeTLKTZ6D+BtpKIT8yRvgsA0Ay1/LQUIxtss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=paL7dAu2TWtMCO72lobSBtkuG5F9oxbiS7z+oHa9+XljeSNM9gfYiRczsj5JWvrEEW1fn7ZSpgBKSkNwoMk4hkQOV+DbiArurL0hU7wh7rAZ+Pe/FVw+ePU8Xejiwv8ujHS/QgmA55vb4bTWSTKj+hlo/gwiporJib/WjPXVGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hAYtG3nm; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hAYtG3nm"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3054ef26da3so773946a91.3
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 05:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745498831; x=1746103631; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=O8kBtFS33bnbdGstcEg/sndG+tIQeJQO5OdY73dIh8k=;
        b=hAYtG3nmmcWcboCNi5nPcSTV0DYhj8HLMIx5O7fgDfybl61qFl9ajGPzWIci6M9ZGJ
         x4tQO27bdZUZFyq9z4YFm0yoOvVEUYjRpAjUWHsDAnDfgRzfda7irqv9Qy9pvUA/L+eB
         i+QbDe2IGkjsZgM72hudTjg0pklfOSPn9sHGCRHEhwMJOdwxZcx64THFOGeVO12UEL/p
         Nh+fzSdTIVkseQsNwdPDd86OrYvhGeSC5lwA0LHZD89iZfpBD6siEoYJGosw/rhr0z68
         V0eassMqHMKm4PDVvuBLB0AlUzZJlfJbQW5lPmQHl6fUwHHKo31/k5u6npNh0+lemvI7
         aeMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745498831; x=1746103631;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8kBtFS33bnbdGstcEg/sndG+tIQeJQO5OdY73dIh8k=;
        b=b8ybRiYwstcrGSGSZ1WvgAW/2E24mw1Kj1cgeyjTSnoGteSaDCEjSMAjMeTdPY+44d
         7RgDNfxYXeT/gzwh7vxrWHiG5lKafe1mVXaCVNUIMBalm9PZ+AXIXkREL4BVp0NS8U/x
         +pmDVBRA71ZS01rELK6DbFi62QTgCfsEOzInA3wL1yjaAHGGeIMjsfgUNLhM+O5JivH3
         c9SE2UNIPu0O1tgFTDuvScD3zOQc+yrHaVUnuOfGhWADbHei24eRVTyU+oaRDvE+e7pw
         mM5srgKjHBHUyIiDf0kgdP+R7COHKwPD57bKTOCAePhEXBMvxt+IgG4ncNM7+QWNlECv
         rk3A==
X-Gm-Message-State: AOJu0Yy5KYYhq0RadzAUDtEzj6sg0rhUFySmu7IDat2/ITKua1aQQ3G1
	iA/KTXISTXRMPSmcDIWcQB2NJy7WnsaUg1zODackkOzkMCogtnCB
X-Gm-Gg: ASbGnctxF9A0QyWUcNvJhvA9hpErrx4voO1jdZZGY4YW3nsM15PUJss6WLJYEiS7VnU
	V0jZ4DmgI1WKgmymATEuS8oaKCBSk17YkeYltakN0k81c2rsnbRu6RfkaXYoAeX1DByDEla3pfa
	uSKiGxDl5Wc2MqfnangRwtiCsEM2rlYHtzJ+ODnJ7QBm1On44NTiCwh/D4Z2HDRPG99NxHO3/r3
	P18xq3ivDLa4GOaYUnVmc4LC4t7+lJfPXxRlHGUdMLazLEY32Y+qB7w5yL0Dw7MwAywkKPhX/6g
	ZjRTwKMK+1b7CpPjOGs2URxWmZdrmGNf/W7EaZa/cu5VZqXj2Xu4
X-Google-Smtp-Source: AGHT+IGginV6s3oYPbz8kFS6BleUK6y+AOSbHLd3A+8QIuYYAwF1OPQNvlBa1A7BqR39QNVhV0cj1A==
X-Received: by 2002:a17:90b:5646:b0:2ee:bc7b:9237 with SMTP id 98e67ed59e1d1-309ed34b685mr3678966a91.27.1745498831476;
        Thu, 24 Apr 2025 05:47:11 -0700 (PDT)
Received: from [10.54.6.12] ([89.207.171.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309ef09817asm1243454a91.27.2025.04.24.05.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 05:47:10 -0700 (PDT)
Message-ID: <f285e63f-8a18-4010-b076-0a58d865312f@gmail.com>
Date: Thu, 24 Apr 2025 14:46:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142624.409452181@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/23/2025 4:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

