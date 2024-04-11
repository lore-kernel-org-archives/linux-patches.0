Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95013AE2
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863772; cv=none; b=FslEMPx72548hDJvW/ibDuPF8xPO8zBhYxdXtnVzGcQeTaQq1VphQ+les7VH8GuQwzKuGKnAXN+erm7wGQUM8L0BygU1MP339uGCw83Uojf8PkAYQUK0FYj9KzH/jUU++rkeQj25P6ub1D2/B6mEw8hivJOgLFupGLTdK6azElM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863772; c=relaxed/simple;
	bh=0UZR6CKH6h178zPDhPDB3a2CrnZFz+/8Wj1C8d4j8Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/wtnVBneUAKn9IyJpLO/+zz3mdHdXay8utPtbqRHEuPo8wCUWQViI12e1vPTTVHyRaul8bTYmEEwoN4jfbBHWeDBrEZFbVBSrBhJlD/zaRyCRvPgi9pKzpBeUdkTeVV1RpWU8hUfGYOVRY3uwB5Lu//nPmJZHIurmIymnSBA+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZRuMsMYC; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZRuMsMYC"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ed2dc03df6so204111b3a.1
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 12:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712863770; x=1713468570; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hbi/5jt0y+jOH+G5BmgxVz/BqPv9rK9wWbxiYNwm7pI=;
        b=ZRuMsMYCUPZjhq5mhqWwrsk8NaGz79QaTyK+NJ9khQoG97gtbRk8fD75eVECVSO/Tg
         chw8UPF5A7WHgb+eblc2tCes17+QzsCNAZ1qW5iO0avESw2b5Qe/aix1xPgmgw4dytNr
         2icesSJI4VBCI8WbvdG9Jl7pbw7AOGbkYENi7yf+N+gP7ZxWLE3+u39Ra77S/fa6Ce55
         5m5ISB/FTYAccq6AsLQ+7sK4P0vMYLQegN26NWEo6pPE2Ld4rox92xM6eddl0sBkK+Kt
         iZz6rh8h2FHSi5xg2C5HD4H2Voa+n0yHYLOSTTdrWNYXKi1aGXzlI4LFOcXY5usQGRrW
         q06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712863770; x=1713468570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hbi/5jt0y+jOH+G5BmgxVz/BqPv9rK9wWbxiYNwm7pI=;
        b=K/F6TJtumgScV+QpEUWd7AFV/kZk4Ewxxo4/EV8Q9oZECDFnZ5cHSPVh3j3de6zfBP
         k/aoWSLsVvqrTsoEVvzZQuaUHDfyxps8uL126/QfKO655ri9LiN8ilHStn56cHKz48Ph
         uGKCliMkXKkDbhXtQTFcCgyU+1IZd8ygJYgxovGGE5RjNvHIysYbB3Ywk/hydv52h195
         iHEiqyhcJigXHYnYD4HuUomfQOiiDjKAbIdg+aG6t2+2C2MMPijtlIzFFLlfCrpH3qNn
         0WslBmXHrE8TRuXQ8vdou439Hw/1xjVlmu7/0+fPJpy3eVpMCze2SyP8uGMwGAR/R1c1
         PglA==
X-Gm-Message-State: AOJu0YxT0yTLqPfFIAAtfdclChJPfsS6av45V047Y/fGgG6lA793v+Y+
	ySLb9gJDINxb86VK4lYqC7aqcFQ51mbPmwvjleE38EYzJPVfoA5S
X-Google-Smtp-Source: AGHT+IFw//f9itzpMOGLKU905z/0fvYX1JVXRIh5gvwlWskL8Pa40IN8Se8iFkXz9sLsKjror/Wtjw==
X-Received: by 2002:aa7:8888:0:b0:6ea:8b0c:584 with SMTP id z8-20020aa78888000000b006ea8b0c0584mr780753pfe.9.1712863770306;
        Thu, 11 Apr 2024 12:29:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lc11-20020a056a004f4b00b006e6529c7d75sm1537850pfb.3.2024.04.11.12.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 12:29:29 -0700 (PDT)
Message-ID: <42230b1d-9e52-40c2-9875-2f88098e2ae8@gmail.com>
Date: Thu, 11 Apr 2024 12:29:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/83] 6.1.86-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095412.671665933@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.86 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.86-rc1.gz
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

