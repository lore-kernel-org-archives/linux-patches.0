Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350FA1E98E3
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782394428; cv=none; b=h2nmyjvPc5oVDs8tOyQTUPFVe3gAYjCaRdHlVGqtvGMivhaniSHn1m/emM+ZlyH2hBfU0KMg45QBS2zkXwZW/PkIy83rJdtRBuIKpucPIjyl1CoRu+PjluNflHRhi4nYIX2TdNe728JSsITK/a7Dhk6UNHYWaG/3B3yu/oUWaVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782394428; c=relaxed/simple;
	bh=Mh0dKkeL8aXK2jemvLY5QFtmT5IYufo7jHyQTtv6G74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IzGSSB8qWUJofLjUYwjYErJSdKNe0hcuHtMteD7TbiUePRdsNQnvuu1PoAfMPO+7iZHxMqRv4SeeafQINupSF3MmaIxsmA87hhRxWOSM6tmcTfbB97BCc2GiMZ3z91BNofKrmVVsv3pMELVnwAXeZLVm02djqZGcZWCFQ7hv0wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IwzcBMec; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwzcBMec"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8e5be46f663so11439776d6.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 06:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782394426; x=1782999226; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8jaYkk5SwnwbHydDYQBOKtKgzdwEKCVkW4ZXTKn4Pw=;
        b=IwzcBMecZGsrDeCmHEAkDyggv68WgQWUQq9+cSP/of0n6l4Ehcbg0GnmTZyxV95LQ0
         qyXetloS6iAsh2bYohYr7ca3/4CciQk1LOrzx+CnK+PQglJ5+VWK/+4HEFRjjpUk9Gdz
         qYP8JvCQuKgZhi5KbXsF61F6wCvYPKHkobxUeHZlfWt0jXVQNdPRfqZzvVZ3fqZRpvJI
         HoeYz61m8I7189EGSjrh5SsJrR6nJxAkK2AdTg/PM95Nwg2faM44k7wj/NQ89zZYgC+M
         NNdd/iN6aojuwfvZJzy+hXVaTiWx5mLKHw6MTNrYR7HATi+r9t5bpb5bVlQZyU+qhAKE
         wDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394426; x=1782999226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e8jaYkk5SwnwbHydDYQBOKtKgzdwEKCVkW4ZXTKn4Pw=;
        b=V1PxozPz8ngxNK5C42j7rhra4zsSmPfoN4ek+AT6yWt6N9yYL4Xgf2I0XUB4kui1b9
         Q71+xDk1ZOlOxT5UfyqoMXn5OESmN/KePT7FaluhED+g9DqgQXERBxrUsVGoRMcLBfpj
         9ywNOa07a7DiitgUY50x/YXyrkt5NhwOvLbe+EohvbC8k+pGEBqoWcBV08Yd46LowWaX
         MCOJGJLvLzej+11wQuQb38V4S7ByDZ4N0CCRHgNAlrbbVsGNPF+4mFRknRzc98mfPic5
         ltT9gH61OT69ma5wOGeRR9xfKJyNvF7aopUdcxadcpIVCYSgFoXzkcKfIqUE8T7N9nv9
         u6qQ==
X-Gm-Message-State: AOJu0YxrFFhHgSo91T3TSB2SJEGuYxZsFFbPnT5vm5HfCdUBToUWIWNh
	3TO2C/P3l5W8zzbtftW2jlR2lVdT62QCCFwllzQML6QtJ34GlRoabDSG
X-Gm-Gg: AfdE7cngCoUu435i7BjlMTgZfHFT6vp4HASZXcSZAtnrj8fWK9l2IdozadQoH2EZ1mx
	6V5/af7Vvu8x7+IZzeJa50yuI/Fd77edQ2VgwMQHhaCBN8jHKQx6QZClCid/PsryJxSpMSi+NuS
	LYGfcYLYSuj/QGHiZy6O6GIIpaNEuNvTJLuJKhM/r3yZXajJKL3T2d6lC7wczgY3QfqaaPg68XQ
	q1riL0rtteR0sa64Vt7Kp0oeG+7lTHZ2brMmRY0SLg4iCQF2QO4/dE+myGMZEQrjBEZG7aXqH+k
	JuVXBkkL5x/Mwy6OmgPdfq9CZUHYZPyLS+tYiV9BgIJY+0GIG7ENx3SSbQ4FMBLClNKfleGhRU6
	1zJ4SoIp7UaKduSmwGWkX/kSqe1EyHhJEHrGOphk/AbQHF54agrQ0VLbeR7o80Qfdfr56J2ebdu
	bGOfWGcFJq31TwLxmFIKU8ZFOc6wBay6Ddlx0CVnx9
X-Received: by 2002:a05:6214:4698:b0:8cb:e63e:2a45 with SMTP id 6a1803df08f44-8e6d6c63088mr46861146d6.18.1782394426116;
        Thu, 25 Jun 2026 06:33:46 -0700 (PDT)
Received: from [10.178.4.71] ([192.19.176.219])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df8303ebe1sm179860586d6.49.2026.06.25.06.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 06:33:44 -0700 (PDT)
Message-ID: <a4a13196-7df0-48c3-8ea5-b56f5f362679@gmail.com>
Date: Thu, 25 Jun 2026 14:33:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260625125645.554579168@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/25/2026 2:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

