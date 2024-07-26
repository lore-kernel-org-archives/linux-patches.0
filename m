Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325911C83
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014878; cv=none; b=a4y12cd8i04AUoy4WhrKYk2Ocazd6GEfWDd9q0YaIA1d6AdzkP6zfRlBKWGLIExOX9cHFj14U2CjxR0dcjeMizgo4bVFrf2mSywxMEHVo5vfy5RlaxQtUt3lWMijJ2/80k1A4fPrd8nUYfGdw1snQqk5jAorGx4WlgjnSXorqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014878; c=relaxed/simple;
	bh=RYD/owF2suu5o1Lgl86+/OAfmjGR1ZR4NG8RC5CHgac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECA+EEwIkIWEUX4ZORCSc5YGuxMpx18O1cqsg/nZLROpoqS3xuhhk6HkWyWYU7IJFZ2CK1OJc7wMo06yWdGx9DaaLYaBDbjM6hzRFy+kZ0oSBRCihUIs2SZvJDDPYmhZ9fhZF5uBtNV3UumB9tS2yszi2lIrSjWZFLIF1cQms1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNu8iusP; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNu8iusP"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6b7b28442f9so10551746d6.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722014876; x=1722619676; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r97e3GXSwTloPUuX/mhN3eyxcRY/5guMC/hNOxlJdh4=;
        b=jNu8iusPtkq195B9XkDkoP3PqMwye+I7kIXQfxgroFA1Y4Y8B6XbE808CsnWYtjXNA
         dwYeC5LecDSAUvml0f/qVHeV1PqFtOlKUnzdf4F+WtToAtnHhSu46k0cwshFXnc8UTcT
         OnBIXa3+K1aw8qjArvOtpW5iugygQK1Yqv9bBFem53g/J74J8IlB+uSMeHBS1GE1brq6
         nc2AVATAn60Kfvn/Sgi0O0+NHHJw5cS/M6JqG/QggtM/m9s+7c+jMk1MRqN0c0gsS448
         fZ4zppn4Mi2/zR+AZpcAkgh1VkGcE4jTOyVYnFdW4B3nhMxRlwaN3kstVXFG1FS93e32
         snCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014876; x=1722619676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r97e3GXSwTloPUuX/mhN3eyxcRY/5guMC/hNOxlJdh4=;
        b=due9KpnvD0AjdR2+j4oSOi3hupcb9NhAauWRGs45tetpd8Z5nUc9wx1CrLvFI7Mzos
         8fINC8hq5SDmQGqqGkgLgTaJ1DgZlg33uRwICQdOzeyOISw5ktZBGoMWPmTnJwxrgzsp
         LM8UBkAIq4QZ/+ru9Tw9Ch8Zw7M6oRm42qjYqLtHZCyZ72yNe7mC8y4AkyaXKD5WQQ1P
         q9wU+Zp23zQu+EE8LXlGvsRgUJAu2lfTr387ulFl1Hg6MuGtAnP/8seR/gVnPX3I6iFE
         CTQdVvZZ0OeVWjWULIcTtpYdphQH/z0z2H7bKGw8VhvwYrlihcbJjHF5R+RRInb/Tltl
         wiow==
X-Gm-Message-State: AOJu0Yzt0u3GeCsUxK4KoODfVwFv0XW3xFOwrzdVw//hFqVfti6raYz9
	TsiBaYesMPFe21ZtxF/wt6m809U2iAJe5R2A3OrjqRRY7Vc15RXobNMpiQ==
X-Google-Smtp-Source: AGHT+IE852chFyJktcaioJZzEk32NHvwXvQIS9moHkEEfKOOvbmZFSRHXicbAYVpS0MTx0JcBRGtnw==
X-Received: by 2002:a05:6214:27e5:b0:6ae:ba6:2136 with SMTP id 6a1803df08f44-6bb55ace834mr5973436d6.36.1722014875777;
        Fri, 26 Jul 2024 10:27:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bb3f9407c3sm18505046d6.71.2024.07.26.10.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 10:27:55 -0700 (PDT)
Message-ID: <a17a952f-87c7-4ac9-983f-692c61dd73cf@gmail.com>
Date: Fri, 26 Jul 2024 10:27:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142733.262322603@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 07:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.223-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

