Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013A14F9D6
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 21:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723758209; cv=none; b=clA36yRP2ozqgVCvHvM1/TmRRAHkQdUklQwJ+wJBd/YiH42iXIOzu+ki3u+C56L1o3DvJwVNwGZstu7X/du3FDZLZ+71yJIm9kXL2xwRUJ3SGz895I0vlnCTmhbsjAvHlOmfAOv78pZpqKfYliJEcQb/RDbFnE62y9Q/6sHX3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723758209; c=relaxed/simple;
	bh=ZS69LGaE0q+bUgF2Hiv5fj6EnU0goQe0XWcy/l6pPzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjX2hjnLjkMDU3pxcjE61QkSoI1d/PTwnDHtNhaFqMOMZkSqGm0dgNX7QQGDz/4/9jGjVo/ynfG9cNhsoW3q8qZed6OBp/nb947I/x1GL+4970F7/hfxE9I2p6cz4t+i8hjr5ZCFrcrS7duWJN+MwYILfeHuApmUpiHB6LacOIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBsEJdsT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBsEJdsT"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20203988f37so3794035ad.1
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723758208; x=1724363008; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hoYUpO8Q7f8EZ4jJloF0Exk8C2GWNVomyUmCZIA2EWs=;
        b=PBsEJdsTUJWaOTaOFprmCC5FcQBKdDI75Of2/KuKzdvSEZArvW+2vGNpM0V9p8uQvw
         XNSYumhK69htMBX6m5shTgyBO10qtYdFai3+h3bn5EoNZj2WHxRrlb+RKrdO7jeg3fT4
         Bohhrln7XhOwFqU2QZBMXRkVQNHux4+XynB5nmRnmbI1kihuzVcpi91tSdf+V3YcoW7M
         MoWWKS1BcyJSM19IRWgBOzc8UpPI8mApKIAEa1aJoll2ZkYfb/UaPkQ9PE7noKsYrZI7
         aXKEIspeMV/yqjTfx+yrsX45e5pi03InnPYIs0VyEGraNLSUZnqTnSqSvmWK0S2jh1mn
         LU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723758208; x=1724363008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hoYUpO8Q7f8EZ4jJloF0Exk8C2GWNVomyUmCZIA2EWs=;
        b=GrrugB2Z9wGV329Z858mev5SUB5pHDN2P7qKvnG5bPh/He9A4b/Lx+U9i4IJ5SLm2n
         /1bOcFRvKX4CJ2R7+ieWrPtrO96bV6vNW34emLjsfk0k6Nc9EwxVtrKyKNFQzMbl5AjE
         O27+6RgRWNArO/SbwiyeN3t3wFAH82rrdt0iQsLz95bdZ583wjLkkx6vJws6++x6ndfh
         EeT+eN319S75c3jX2mfSqlVftg/RsMt/tT1e/4OI1A4XlM806RMZK9B0HMvxx4IW8IS2
         RJFgVt/76wGWwwBb4oUUgJzZouLkbRZ7BykaZ1MXeAjFrnbC9kDbATapvNp1uC//GoRC
         yWBw==
X-Gm-Message-State: AOJu0YwaaKEkxTPMyfwiCIatinnLqoEc3oWR3yEXFPQJ7ib2k4rZD9dm
	2W9KJAp1skDsnWewmKbovbfHTGf9ELkgW9n5y5eJ0u5ruUAxbAbk
X-Google-Smtp-Source: AGHT+IFApLX8g5MgpzJHdW5JrKrg2cPzhA4XiFcv9FIbS0GNcRc0ra9mSXhT+XpnBeWtx1ZVJM+LYg==
X-Received: by 2002:a17:902:c94e:b0:1fd:664b:224 with SMTP id d9443c01a7336-20203f42320mr10458745ad.56.1723758207797;
        Thu, 15 Aug 2024 14:43:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f03a34c5sm14364565ad.280.2024.08.15.14.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 14:43:27 -0700 (PDT)
Message-ID: <8b307f8a-f383-4a1b-8247-214aee428408@gmail.com>
Date: Thu, 15 Aug 2024 14:43:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131832.944273699@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
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

