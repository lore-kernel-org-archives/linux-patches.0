Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2E54730
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 20:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712004397; cv=none; b=nsU8FixuWZwHrsY0MrZz1yS7z7Qc8CGdwudU87h8hAC6aG4QSq3sUPiYC8iF5zT+7PBPOKyZgJSSRNtMgbX7//Vg27dFRNr5qQg4wAsL1Aj8OygR4SQGlDVHr9rmPGPIGvrVTge8e+gvFMUcp7j2mxNY0CLhTlrqlSYCLYk9+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712004397; c=relaxed/simple;
	bh=1eh4EosVIJe/RGgbyngmwAmaNn7FpgVczuCce1/V6dE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmU5EJBCGxsMk007NhRGK/77LXFUKkEwXWnsi/ZZ4GRb8apW5bnW973oVq2FsBLNRNt85RYmBj4RUc8aDc+PuBnmwHhs9bE2efPnbpCVbFFRuXNIePDDqPaV2KFQANCGS207M/ImOkodjp1xNpO2pk+sp6v68MYWUQpB0TUw17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrAJgQey; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrAJgQey"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e223025ccbso17430885ad.3
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 13:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712004395; x=1712609195; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4vmwsO/t4KNvnDmSvXyJNoMNNVTQa5mB2jFuIsMRTOg=;
        b=WrAJgQey7AhcfTrp/DkF0rokuedDMMFP96yaBDDHLEpZF+hwe+AUoDIiJPHn2kg7GA
         pVAEFEDF32qVJ5QgYFE8ayQ2CVfkJu/e/QicYhYgaWut/ndhGgq5ZDiPiQWk26mFeYd6
         3qGPXzAR829heNKkOe1Nfej4fnWpNKLXk5pT5hhPyHIeS6OgJdkBqlbDDXS0Fd+hFkgJ
         xhi2GqHcm+vpvULBXZTo6vW4OQ6z4Yg2UxXHliaQl4EBWDJN/nAZ9hgiWYJrga/rnXwl
         jv6WgPikzMU11Y1UyjWf3jZrC5swTsQgeJP9VjNzA8P2RSulvXRTGlIOGD4+wKMLryBw
         uahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712004395; x=1712609195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vmwsO/t4KNvnDmSvXyJNoMNNVTQa5mB2jFuIsMRTOg=;
        b=Z129K6uJyB4HTeOBtetRW5/un39qWecnXzNT6+Y/LN6mTjMslKPL9oKFvJEBraiYPJ
         BhTVc+8vi+jEwkl35mLex2Nv3ZUQUYx+DxUpefHx/zghxSC34DKFm6HaVMWQ8W81VU+p
         DnQfjMVQ0VbkPeloOc7slJ9MWU7LS4auaZRHB4ku2KvcNja4PMArJBtbk488t+3eOqgM
         QYszTKMSGkN/t14f5TvhgsCAeezwTvBExz6j64FnAqLng6Gq0NeqQppNxBuiWA6NU0Ts
         KltCUH8U8fOC/pX+er12l3qInOj9+TZ5pAIlbVQsHIEU0ugLCg2yovLxzXY5RB8Lh6Xo
         a8uQ==
X-Gm-Message-State: AOJu0YwIB8Q30MEzmUdPC3wiW3DD4+4zedM8h8c5kTjTrDIwvtYA1XOc
	6GVCweqfSJzk/c/rQgrXAxpvib2oSI90cqkhfzRi1UG2i8X4e+OJ
X-Google-Smtp-Source: AGHT+IHXp/WGncQL5m+2scozSheJ2HjLV5OTyDk7ex5hN+Yk3jgndPR6FmSAQ/+tMINfp/heU8X8gQ==
X-Received: by 2002:a17:902:c407:b0:1e0:7f78:624d with SMTP id k7-20020a170902c40700b001e07f78624dmr10073853plk.57.1712004394743;
        Mon, 01 Apr 2024 13:46:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id kh12-20020a170903064c00b001e2194ab34bsm9234135plb.245.2024.04.01.13.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 13:46:34 -0700 (PDT)
Message-ID: <022b4411-2ebd-4f8b-adc7-0ae81a665181@gmail.com>
Date: Mon, 1 Apr 2024 13:46:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240401152553.125349965@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 08:39, Greg Kroah-Hartman wrote:
> Note, this will be the LAST 6.7.y kernel release.  After this one it
> will be end-of-life.  Please move to 6.8.y now.
> 
> ------------------------------------------
> 
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

