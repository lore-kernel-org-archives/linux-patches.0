Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893AC2A1D7
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 21:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjOQ82fb"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-45db31f9156so1638585137.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 13:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699393071; x=1699997871; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7OscIyj4i8GIO/pAULmGru3eamggIkLaqaKY2i8guPY=;
        b=kjOQ82fbBF8k373LIE3OYc/TDquXtwd26O6V40A3Km4B4Q5Sox8K/REV+yaQdcgLM6
         tXg0ik3qfRAJNSEJD9loI1fFwWMionUxq/O/WxXj9CtKdWKyuCfS8GSt0fE+HMp21Su/
         wRWUSxrrWF14Toyk0i1pXkXTIB5A5pMUcKbTKNqQC3wegmB8qYg6vY4CQAsUvmR2cUe/
         SjEy9PvPxco4wdveN1g0VDmdOdj1tBOiEORtux01iEuJLiUzPemSFymkeZKGWS/koWh/
         klTj6EGZMUNIO37T+U9zQ2GWxbsan9VhFUkBcIFTg1R2NSrLHdItZCV+zv6dyVmPOvnP
         oLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393071; x=1699997871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7OscIyj4i8GIO/pAULmGru3eamggIkLaqaKY2i8guPY=;
        b=V61Yh5RweWiGaRQRJkpX5NhMr0T4goe7Q+6FEtgFR1ijfFM2XU2joX+6WnXzXjGSmR
         Z5zugoQLwyuEZofAIlL+osBBtkOqru0DVp5uR6wIcsLRe5jZQwJJglWHXH5csrub3jw0
         ayyh3J3APZeVz8MJ1CiSNBKjWHKIp+hKVfr1ASjmnF3bXZoITfJc5hh125jC2nvq/Nd8
         ROhy6yojzoENVvDEXlbDla1EVwWpd1C7K+Q4+QDZk0U6TejJdolBNPtBvrl1PSfZH4Bo
         vahiSOTZZmALdOmVRDx5c0M6GLyLIdXYpSzCkEjiKygy61nsMyCaxpVta07d5UEZrAZh
         iVjw==
X-Gm-Message-State: AOJu0YzxrNgGt7J8Je25RwxtDMjiq2qY0+AIbCXwX5ftV+Nmlu0rdnTH
	7nZjY3ONZ/SsnamQ76aJYuk=
X-Google-Smtp-Source: AGHT+IHfZKOcyiczSG9qjN0nBFczJGgManA+OefTDO1U0lQ0hQGCnFWFwCaqa7arjNdcdrWC42MwAQ==
X-Received: by 2002:a67:e041:0:b0:45f:1349:fec4 with SMTP id n1-20020a67e041000000b0045f1349fec4mr7488767vsl.20.1699393071294;
        Tue, 07 Nov 2023 13:37:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c21-20020a05622a025500b00419b5274381sm88621qtx.94.2023.11.07.13.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 13:37:50 -0800 (PST)
Message-ID: <7406cc46-15e6-439f-a8a1-3e44cc2ef4f4@gmail.com>
Date: Tue, 7 Nov 2023 13:37:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/125] 5.15.138-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231107202324.434534294@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231107202324.434534294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/23 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Nov 2023 20:22:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.138-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

