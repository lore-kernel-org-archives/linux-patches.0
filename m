Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CB38D005
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107700; cv=none; b=PIcsUm/67lPlI6LeyFa7EXmZZDvgegaWn/lARzyJp1gC1m+3mbwaE5N3inpmQoGLxPAKe/ZWd3I05YWkfufUILJL0+ISUD4khlVUX1CM2byUFYHD09v6EEzlGLnpSHRbBG/hMgPRGqWETlrPesU2Hr4dn62ywN2pVdCUr0tmKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107700; c=relaxed/simple;
	bh=hjrbUh3K16uhPv+qGKiFJMHaayQ7zUPBcGTS9VdYRT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eriLC40w9RezSQ1LGqE/7qexbI4lu2iTEl0Tsku6OYbSZDMN9zAr/xIqRP5uzCEju1bjb6Gfx0Qn36LXuSlStBwf22ECEtmp1TxI14VqHxUls5Nb2EwOJK+mKU196dhxxesITX4UyPJ5W5l2OnMTY76AQuFHZVun6+P990OeaCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fv3j18Wo; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fv3j18Wo"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2d52c7f92b1so3933125eec.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 12:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776107697; x=1776712497; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6CQP3NmVGMh1UqGBteJSFQx79n5V+bZQmDU6yBEPTYU=;
        b=fv3j18WoObjMje4Olj87RjzSU1BiEaH8uwalVkedgBoLeHd8iTsgJfo5JWxwMR0pU3
         4cZOVrIlXiRoqQ5q7Xi3THT2qKMoXppsrxYDFMXMeWEHV85jmTAR+LLkf5ivQQQ+8cGY
         G9MpVTG5pIVnhXotDEswXpqvK3CzgIK7m8hyFv4HM7XvXat4sKeXBmZnFynIJ7QN8yc9
         U9vFlOgA+qkXaM/AB1jQhEIKUW3UzrdbZRyVnPDPiLfgNodMwgaL0UEDYzX/9hSG0u11
         offtn0etesKvlktWm+C+tLtJGHOsM/R60PxT1b3c3Owejyj3CUTxxhsfW84lNFXmvEBK
         QAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776107697; x=1776712497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6CQP3NmVGMh1UqGBteJSFQx79n5V+bZQmDU6yBEPTYU=;
        b=Xe4sdQn/KLmgoAQe3KVXqxtdRTtccOBKWgTpPebwe/84/Igrhq/DXS6tWt/7fT7C49
         hxS/9SHtsAZHLaiisGWpdXEWiNnrA+jpdolqJFqCRahuhYRgTcjYp74NjDRrZV2uxEi1
         SZ+WLeWDDPv1drmHZc5cWGDR8V+qKOwkC/knFEkfkJ616MihCwyykHtJxzEqCSMeedlm
         veSSqrTOijqOOUD9gmtuEyc7/Ere0R+CEVWlUwSI3O6WZNm2Ueg0y2+AoPxr4pRuGk+9
         qMqDcAN24Tu+rhAYO4XXm3vh02TrBhAtGTYo4L5L8/0DNn+KWdiNz3LRlTEtBdw1sRlu
         OaJQ==
X-Gm-Message-State: AOJu0YwpjHJgD2u2yvE03JnsQpZeFsG9daBXiKc3iK5wbBoZA6wQUOO9
	CDQZPHdngaHKuqdTiCGCeXLmVdGqK/ZISZrJe3co0wQFpqxU5hQSLPs/
X-Gm-Gg: AeBDievMVBzAMgExFmEDUS5Vjsbo6aY/E/b42K/pPdOneewjJIK1XNw9YogoeYSmp42
	wco0Z9udg6860cazoDtUg4FiQwwWSBTUXU+07rxSkSWmiptJpMoWKcGpj/Owi1G75oFO1CuEMIk
	1a+uFCjph18Ox6tVDD6v9DHF8xrJVOWEVsMZJxTDnmuzin2FHg3tjczRIvpAnr1mq10jOg4+ANy
	NCgP8XiHIBq8NJMQJGfp5YLDqWMDtSkHP1oFDDvOUxOciP1thXDPGWQ9VkNIBDqmcHSohYqJH5R
	wiKoBHFQ1o9aTLURAo0riBu/R9l5jsZme/BFbbKDxqhQYqsAC+LU5+fqY6gRIMpt4MLZdcSDsds
	O3adm/aRrM5vFSDjMpM1nrdL/9PCNoz95ylD1TCAdIJdqWtOrLdmVVNq02J9gfy5Kr3/aish9aP
	NuwPk8jdnFPEO846Yj7SlzYoFNK+drASJJinB822/fmr7SLo4BbA==
X-Received: by 2002:a05:7300:d70b:b0:2da:9a3c:8062 with SMTP id 5a478bee46e88-2da9a3c91a3mr1371099eec.17.1776107697433;
        Mon, 13 Apr 2026 12:14:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55faa571csm20993898eec.10.2026.04.13.12.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 12:14:56 -0700 (PDT)
Message-ID: <36b828ee-71ff-4c48-9ab6-139a3ba6bc1d@gmail.com>
Date: Mon, 13 Apr 2026 12:14:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155724.497323914@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.135-rc1.gz
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
