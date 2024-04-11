Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996AB1CA8F
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872053; cv=none; b=gLcC1ehjSV0TaZHhg5FgC7+ClSfDCVmdFyuZTSH+I3Hla3wuHvzOrdmRQW7hhsyJWkItc7WrHpZaCkivIwoAIyk/gEpTTz6aTTDWet0ezWxu3d/2C/MghAZVIAdWkKMjZfZ6baOv12VmVq0Qp8SaKg8pSkpoOB3maQAJLnqg4Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872053; c=relaxed/simple;
	bh=NiiW7HlO8jYMlaSPOm+tGXTrPK1xT3n2rILXDAH4rJ0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=C60glEbSELMBBC0iT5Tl7wTvPg7uOR0Q2nQU2MBSyQDeylo8Dbijir8tjaGmKoy+f6Lbkziy2si+B67akSguyW/r5EUKeMBbowVKs61aq/I1o8pSbAtEHlJUR1B79sGMp1mobdctK4BKxmDUcLc68wrHrLaGe7BcMJqPPu1LKfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/bZUVgR; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/bZUVgR"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5c66b093b86so997853a12.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 14:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712872052; x=1713476852; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ddxa7Lm0V7tNQ5Yf2X+O79t3Apo9+QNjaVHgEzh5CP0=;
        b=h/bZUVgRVFk0LbQo6GyXPV23umvavGmwXpT5Y+fpfN1DruKfsSr9mrRkZf4KLj4jyd
         J6Wj5TvHvM/pfymKPtDyWLr9j/McH+AfH3Jz6PlE1K2RRCQUi9FFWlBW7awwuXhJtOL/
         zO3a9QJ3+hOtrQAPMqZRbVtHntyQCIuOiVyT8aX7o9W+X5YqoNZOVU3uElxyDTO29soy
         wnjpmwEcsHmTx7g4rIqgVUY1HEmvh+5RpR5KI6zL/r8S1gAunHYvHCKke4+/1P/iIirB
         uwtOx455ptjK+Gan/iZDtIkTdGne1bq3nI5TgIN1W17d5Z/l+2CDyA9zLNzSDQGX8ODb
         bxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872052; x=1713476852;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ddxa7Lm0V7tNQ5Yf2X+O79t3Apo9+QNjaVHgEzh5CP0=;
        b=XgkEaDMiKBmjiSTMmLmmMtgb2YUSBq6mHX7wPfyg7WQQYIv2xt/GEcvzwmTFTGiER6
         GlXMfOSwaTVWaMU6UJ/2whysX9ZmKOA8FWE1Yvh7ARTjgkDXI7BIqeUtcDzxM5g6Rney
         CxQsTKwsScOzpS93NOFvmrbJV9t6MrVPzW7SP1sj8EapzgeO9Mrc6erjMav7dbQ4jAu9
         FIMG0vMpF2ZM0FRMJzNkw/Yv9XSaR3Q1vtp6KFX7Io0ECGV3mt0Lhq0CNa5w4BvgJUHP
         0jkqU6nCgNF46VFydLXCeUu3yWKZKmsFHqISHH8DYLrVNnlgNIyKI1BGpidzZLEm6ICx
         9Lrw==
X-Gm-Message-State: AOJu0YzOksuf5T2gMkb07uXe8F25yMDWYdqOk32sENrmpjBklbltOtEe
	rPC0eHWqZl6SC/HCvr6M+5hUeafGpWw24MAWS6c33Incog9jVGSB
X-Google-Smtp-Source: AGHT+IG3OL39Tt2WbCq2ZhAMJutPEfrY2ljQNwyZVPQVJHZS0Yl/RyrZAznhXxuy4bMat415awG+jQ==
X-Received: by 2002:a17:90a:bf0c:b0:2a5:e055:88c4 with SMTP id c12-20020a17090abf0c00b002a5e05588c4mr4915966pjs.5.1712872051716;
        Thu, 11 Apr 2024 14:47:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a9-20020a17090a8c0900b002a058159ff8sm1582146pjo.8.2024.04.11.14.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 14:47:30 -0700 (PDT)
Message-ID: <c52995f6-20ee-495e-82a3-4e4f12c1fd5a@gmail.com>
Date: Thu, 11 Apr 2024 14:47:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.6 000/114] 6.6.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095416.853744210@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.27 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.27-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

