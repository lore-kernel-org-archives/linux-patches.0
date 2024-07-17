Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFB1862A0
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721252056; cv=none; b=twE6K4UIaKDjIPrclWZydHVRvOnOLr64FAuyJrGIAcUDCmfDUFEKTCVoE08ZNRqlO+ZiXef2oNwksjKUWorRNwfm/F68DdBegxhiol0DUx6LC+iG21Bnt646O9aRH4BFaJlsLwotvSw+u1aLEhloRRK2YXdcAJUKUr5VR4pvgJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721252056; c=relaxed/simple;
	bh=gl2Q+tMjWcZ/GoedLF9UhlaZefndxux+7yo0H7gHVzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBLTk/nFIyT6C/ikCD90NJqzLVJe0Ufyy9buo+r2QCI+2mY53vhoCmfxOUtEAk6Iqm/LpQi8szskfolr3/Qh1cpjihsXIOXXpTQsHtYaMJCSJng8GFeZCWBf0DOWVLyLJ+/uvZhqFX+XRZAFFex2oExgr3EC7xtt9YTEFftVqZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvMqBLwd; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvMqBLwd"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6b6176e59e7so977456d6.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 14:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721252050; x=1721856850; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KsBGb2vdt0b/FjklMsKTbmLxEuWSJkAQN2gXGcQRYII=;
        b=kvMqBLwdOp6C4KEm4gheyoCouVAQDKemlyPsPdGeLelonXyzBvVrVgDtQjUXEAtO9o
         BrFwdnm5NL7c5paHFlLHBt9EESJlEsdoSDfi6N+Bq0mbVJO1A2aAc56bM2HJV0zUatEg
         IPVvzKL5/ZnV1Hw+zvT+1QSTFQFQNcGed3tMlzKdCfodi58XuSW488VcH2KP8pUTsdFO
         iaO5oMznuVyuzku19020eOINo4tugeVO/b6zpMeKSvyptg5HdMnywHZr/cxvrSu0Ad5L
         jOdHhx8b3kLm2svxBXaAfealNIZshnOF5QTte9BmhJ1NnfgMkj+6nyDndPFgLBY0c6lH
         Qblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721252050; x=1721856850;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsBGb2vdt0b/FjklMsKTbmLxEuWSJkAQN2gXGcQRYII=;
        b=liVG7Y3l6Fa8wEyi5YFMdfbWp7y6jMXDRm8SicDtqr0NQKw1O9iJ66c/NZCCy085oy
         VMOSSxAclBMJ14NWfhX0RUVVBE2nTR6rMOoy1Iz+vQZGhUiddx8tGFED6RqyhVTX/+B5
         5d8Z0efr9WakgynP2+CqEb6MAvrs0kgHKaa3TRwpoWlZogDqm9i13KmEYI8xmeBsNSfZ
         6kP+YsteSggoH+h9gvjziUUAs4zFC2EwVG7vaRqkK21OSEx7+R5MRLXpOT3AAv41dyVo
         YcDYiRi46JQ/dtHfiNrLSsc6KSRjdfa7mSLdrBfX3gf9+P9NeJeiemsoARX5inG8VTNM
         ECMQ==
X-Gm-Message-State: AOJu0YxZV/oHA72C1hPFoeK/p+9GaRTK0fS4c/r+HbvQAPcm2/uWmgUN
	uXEefFwCyoPX2YEcPS1vJHF+WjIR1psjZNxgoZTCtWmIt47LsQBd
X-Google-Smtp-Source: AGHT+IGeBFbyrv2x408blAU2xaOFM1dKbO03qWpVIzeUtT3O2btNETS9AdxJX3RlUwGcB9sIx9IcDA==
X-Received: by 2002:ad4:5ece:0:b0:6b5:dcda:badf with SMTP id 6a1803df08f44-6b78e200381mr35274676d6.42.1721252049851;
        Wed, 17 Jul 2024 14:34:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6b79c4d18f1sm2506186d6.19.2024.07.17.14.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 14:34:08 -0700 (PDT)
Message-ID: <08082dd5-8f91-4b8c-ac6d-9e8032bdc3a0@gmail.com>
Date: Wed, 17 Jul 2024 14:34:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063802.663310305@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc2.gz
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

