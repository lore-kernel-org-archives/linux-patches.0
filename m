Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C9E5FEFE
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 19:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQdNDrYx"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cd89f2af9dso1312245b3a.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 11:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701371422; x=1701976222; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QitiP5XoRIz3e5peYWbCOL+stxKLuwju5RuWWjYKtdk=;
        b=FQdNDrYxr4C2sVeVeBDHIFBofFV/+ed1516RQ5fIIs77ETVrd5C/scIiyTdllVtXaW
         5eY62UhhHI0jlum65FihwfWBaO2PkV+wVRGLdYAqkCmxoMeIu22KhlL1axJ0H5kWSjJh
         RVSq6BtwDHYyTHivHXqx4nwLLa8wUJ7rgZiy/89cGAGlG18sU8stcIJJ8IRlV7g+TvLz
         UZmzxnnTC/LFac7XDiWhuAGq8xnNLbb2tn0veh7+GgJwX+Jm9RdsF3qxhTYgMeMKRuhx
         GDSAffctsZC7AbZQ6urJdIWZAKMYC/1kHilSXy2b9OmXVOWqGIfzAUl7aW11Kw2NUMxT
         /XAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371422; x=1701976222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QitiP5XoRIz3e5peYWbCOL+stxKLuwju5RuWWjYKtdk=;
        b=dDpPUZP8D7meA830bp8SGQ5XRxQqHDJ0Wamy+xfhjhRCQd/Oa/CyWANnWNRCFiwApL
         r/QY2A1ksEa/ZpvpIcxBSowi7tatvZf3qRHUIsm2evi2pSpexMUCgwtkVGtxkZ/CiE3P
         MWgULdejchrC+moUie4Qhalh99eaFP2XAaE470J1/Q7Y3U4WSt6QlqtzGVQMK22jS4D1
         LUhXf13e6OIF5dwcfjjm/8rARkmW+YBfmDAN26zNxaguw1g5DAjJCvdvb7qaHE+GpkfM
         tutJvlcHxVyxlJziHn+Ni8aq2EOIsG/ArGE2VpDxwqfy3XAtMyR55kzWBxD4zIeNXG4f
         m9Rg==
X-Gm-Message-State: AOJu0Yx9jW7b6n0FZHpwDTNjc+NDES8he/1JmHRHkPaxZ9THukeJgGAm
	uLV7Ue69tcBU29QDrB+Oyfk=
X-Google-Smtp-Source: AGHT+IHxIthsTZ50FfgNUEXYgObdZ0eyLoZ/m4F1pEt0Pn46iewGSeoWvofyMMSEEWAw+V69/bPv9g==
X-Received: by 2002:a05:6a00:2d0b:b0:6cd:f69f:e3a3 with SMTP id fa11-20020a056a002d0b00b006cdf69fe3a3mr1681746pfb.21.1701371421855;
        Thu, 30 Nov 2023 11:10:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 77-20020a630150000000b005b8ea15c338sm1595622pgb.62.2023.11.30.11.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 11:10:21 -0800 (PST)
Message-ID: <63978ea9-0be6-4698-ba0d-7eba78e986e0@gmail.com>
Date: Thu, 30 Nov 2023 11:10:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/82] 6.1.65-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231130162135.977485944@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 08:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.65 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.65-rc1.gz
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

