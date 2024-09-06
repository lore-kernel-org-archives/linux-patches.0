Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAAC17BB6
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725581849; cv=none; b=cOlzCSKMih6Huppij3TFX9St3G9GxTkeT8sTJ+o6lOcd/PvmmJh0eKAtWvdv+qspZ+Hn3oWep+vVbH7q4X/NTkKa4kK7heZspRPlyH6kuuSdTCYqOtC2FgpMxNrLo6PVs7tX2y8RdszKsDm2CqfN6dK2QT5RzDj8Co+TQdsj9QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725581849; c=relaxed/simple;
	bh=OwpzBiS5Rmhz+J+NmaXY/hNNGB2eyD7rp4WviQc0kwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYIxRAZ2F3HRNhUm9V+7A2+sikEiMsHekBH7GJG/my4yEhZGTKuKkuyXyW6t2jHfnivj1OySEGeItbDin2eOjToVplkzecIeZzZ37/TGLHDP/AJoysaM0/YgaDmVHUmJ7Jz9whnfPOd7Nu8vZ7oz+299osn3GzfsnB0aIWaVxJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cg+mdJU9; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cg+mdJU9"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82a20efed34so65526839f.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 17:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1725581847; x=1726186647; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CJk6oTxSmxqwstN1cixMUi88869s8uO6pmgB1F/UNZI=;
        b=cg+mdJU9TLY8y3muWk/GDCZh+xyIPsq/+aul7ldMKdEbS7BsLuZOeE3B+ALCpRN+7a
         u/WaBhItd4yDPL+K9nFV3KLPe+4ICop+8Tv84HF1jPNSFlJ0xrGOO7VMbq7+iN3AemBP
         9QkB+NVUa+tezHSTDjHOsi3u3zRsD+wI4DrCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725581847; x=1726186647;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJk6oTxSmxqwstN1cixMUi88869s8uO6pmgB1F/UNZI=;
        b=Ohh1U7CdxI1MlzzsDnxW3hkgP4Lv3jyeHYGcGtTijehK2q9H5/8Oi120uth3nwft9A
         RpTu6/q65lnxxcll3rB2u4UMDtVHbB/yVUTDMnsOel8rkO3PeTHtZfUxLC+XD4l8Bo63
         e7qGcnPhMbWh8qzFAEF4wIyK+Ud62GmFtXCabjfV9rTW5AsA7vJPEnS6lPXHv3zi7oCY
         1KmW/KwbOe1Cdgbx5UEp/ICCgjd9rzU8vGnNpqoDkn4WcoJQiIciWDRtbGggQOLvkuFP
         FQX+mksS9wvLDYHSWe7ZS2+6oT02QcNZEXhXi7fUq3kii2IDIRbHFPVqEIWfiCQ+HorE
         PLbQ==
X-Gm-Message-State: AOJu0YwzJnJl/8n0bEfFRoe3JbkfkBak78lQLPD72cs/up8SfWjtpKS6
	EDl/rQdGcah33V7sLlJ0V2J6Kqwl2E9/9Vdwl99mMR1l3U22Y4T/qV5L7id8/5M=
X-Google-Smtp-Source: AGHT+IEXq8EGlVXVAtKtQBZ7pubAV4csPUqD77cw2zVgWsBW729E+ZBWLC7j0DysrCw72mbjJsdPlw==
X-Received: by 2002:a05:6602:26cc:b0:82a:173a:3cd0 with SMTP id ca18e2360f4ac-82a962494b2mr85462339f.16.1725581846670;
        Thu, 05 Sep 2024 17:17:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d07b01fbb5sm376826173.123.2024.09.05.17.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 17:17:26 -0700 (PDT)
Message-ID: <c808dd82-248f-46c6-a902-02d3527879f0@linuxfoundation.org>
Date: Thu, 5 Sep 2024 18:17:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/184] 6.10.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/24 03:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
