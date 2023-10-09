Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AA6FBE3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 19:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WAh3zVsq"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-690fa0eea3cso4368182b3a.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 12:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696878551; x=1697483351; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2WB2O+ZBzB4ZMkeQ2reQ4/yBz+9uB3jIVkq0VzlaCUY=;
        b=WAh3zVsq3r0uFoWHEKn0teyv9c32Djao+MYdzYw+nYmr0ckxC6iVJhZzJxJkR/YkcD
         SZPTVN4zsjnoI0JssdNm8l0X3GZkQYKSlCtFACtg9dgdhHPmsvvu+8W4VML/XhlQZLlS
         atfgwvK8LJ2bxsf5KKKiBYpOMCBFYW2P6i1XKd8wd5fz99RfQpluQu09EN9Evelx5kWX
         S/r9YGFag7bMbwOYPB2ZEFId2zuQXhn7L157nnqPNHCQZhGb3s8sPeZbe756y2TZ+Bou
         pYdVjQZ9WO7eZf1A/OvT+BGmAZUQ9cl7s16Tr20cGHpd64JiEWD5YF+dc0FkXIOVJ3Fe
         tlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696878551; x=1697483351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WB2O+ZBzB4ZMkeQ2reQ4/yBz+9uB3jIVkq0VzlaCUY=;
        b=YDlPobG5roHJ0/gGvNGGoamo382BHWKivXBR9wZMO6OxOjVvDk0GoCcicFK15npXKx
         fzxItHmkhQk33Z/bh4trMXAMktpI/Ukw+XkFlGJ5xWtZnSVRSbP6dWUxQsnVXV6bzC4J
         k30Zo1JOFHGTOKB3hyP8TgB40yfTLgfy2x45wo5Ehwh0UY9B3afIfvisNd9FMdoLzaCp
         6mC9el05FvyMPcTtA4woe9+/FrLgWuHJ5VYYNfDD94mzX8Ny5hQC4yerE+DnmzS5hLTR
         OVXgKiYgnbbf6M1f+mSz0MFKtR4E8pe+6fTkg94MGodwhxW6wXj4iD7fW3ephCIY4Ypk
         UxEg==
X-Gm-Message-State: AOJu0YxKGhFLRhFycmu6QWmfMryLctgTZBRwuPaJ81ypSRgXGX/EnIlm
	YuRM5e+NeFqkr6H+qnKAHMI=
X-Google-Smtp-Source: AGHT+IHqi/Arp5jO9UE8mGcTD2ZBtMrBThOiTbPkKB2cIKERsnzlL7P8eOjGCjenBXvVB4E+NMPaQQ==
X-Received: by 2002:a05:6a00:2394:b0:690:2ad9:1454 with SMTP id f20-20020a056a00239400b006902ad91454mr20897163pfc.33.1696878551009;
        Mon, 09 Oct 2023 12:09:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gx9-20020a056a001e0900b00692b2a63cccsm6729012pfb.210.2023.10.09.12.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 12:09:10 -0700 (PDT)
Message-ID: <cb16ada8-4c7a-4134-aca9-41983521e388@gmail.com>
Date: Mon, 9 Oct 2023 12:09:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/131] 5.4.258-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231009130116.329529591@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 06:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.258 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.258-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

