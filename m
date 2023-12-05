Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA4D6A009
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TizptZ8R"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3b8b556aadbso2277107b6e.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 10:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701801318; x=1702406118; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zp50cEMhA16nGXEsXh/65k5s1OUgtftGnHrdudTWHl0=;
        b=TizptZ8RpIzxAHdPfcsdjpmKuMYuKPJCGYsB7O8L4+r//zrC4InxWgKjaY0B4zDXNS
         3vS0OGnILEqJ3hwZKgn7bLHUwAspy6HmiqoHE+lRNUCOx6zV5amfA6O/kwGpkY7fyfy4
         X20xBfiDXHKaU9k94biE+Grccwh7Zyz4bTbpoOT8z/fxN81wc+sbIMqB7/fc3yGIcymu
         bOp4+9J6Ja6c18Eh/bLNdyEWXIFvR/C0cMAxGb2A2l+TppN9yJRY1Z/C/K2SloCfpKKf
         KjM5NyHFQIQ4YBEjpQieUe/7u6LqgS2eFZyHz9pkRVcZfS5eKVsdH76vgwZfJ4moDPh+
         BMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701801318; x=1702406118;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zp50cEMhA16nGXEsXh/65k5s1OUgtftGnHrdudTWHl0=;
        b=br63AeNV8HvpgbzMHpInVIxTDcxTgGfCiqmf1mv6UPtZmC+oYbBdk2JEwza4tFAPqA
         VBM7DSyh+biwYNxMWRjcJyIk15zR5knnw9peyzVzSrTiim/5OSkYv3hth5R08XtPlwIs
         30IYZS2b63wcjlyB8I5txx6G1iEPaL352iFFUmvt5XdKcAFz01N3H01uolSFdupIts9w
         knYqR5G+b83lEYYrLL4I5YLOQYhSSWY5tCxMgIzPG94N8inmNMQk72PKaIQ9lgq7uBu7
         ZJVbYMO0hSkjs8rcKzP+jc6xtm+tTaCjikEExjwKiIPIFqd1xODxzGDv4zP+DXwkjWzl
         vwuQ==
X-Gm-Message-State: AOJu0YxuqwAwzA4Dyeb7dWWTI2gCGK18sy9QFVe2OrodY4jSXBsBWYFu
	Q0Jeo8FFpbgAZLDDKQZ3sXc=
X-Google-Smtp-Source: AGHT+IH1zZJz1AecXGZ7V2IG87FO1soRW88u6fqO+HLSk/N/EZWXVJW9vwfEn6HsuUyXB3KlUZ2OXQ==
X-Received: by 2002:a05:6808:13c5:b0:3b9:96a1:1f40 with SMTP id d5-20020a05680813c500b003b996a11f40mr3934064oiw.44.1701801317850;
        Tue, 05 Dec 2023 10:35:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id vy13-20020a05620a490d00b0077da601f06csm5289868qkn.10.2023.12.05.10.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:35:17 -0800 (PST)
Message-ID: <0a676e7e-9b6a-476d-85e9-21fa6821e9f9@gmail.com>
Date: Tue, 5 Dec 2023 10:35:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/107] 6.1.66-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205031531.426872356@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 19:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.66-rc1.gz
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

