Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E52C6A350
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhQ60i48"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3b86f3cdca0so3359390b6e.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 10:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701800498; x=1702405298; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PgcyvDd+GyU8MF+J1KZ2O9dcJ3DnRcClT2xqXZO8qcA=;
        b=NhQ60i48bPgSUdXCypRZovlGN85LNlHgC3YrguJoQtRLcOJfpi9eFPoTm1RWD3aa1C
         wJmuKQa7fWxEBJMLQW2AScmCaiuEUs2aWoZzXA7FAJzqYwhakGh6DUSd2wNEo/Sc10yM
         RIiy3DFL4XoVBeKdIyYRO0S/0enxRmeOuVs9h4CBXMCUwCAp9ZY3peAWXGAMdT/dV9NB
         B45x4jUXVEALKcokAWvyyVgl15Aa/BphyZwd4dWCMVd28L5yZpaAL6mcmTmwhehlSUIO
         aD5bxFXv/cPHzdkEftV0OqAUBzWTW93imApr+pR2J9imWNr85lBCTom7AaRJwFr+EOUJ
         Tyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701800498; x=1702405298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PgcyvDd+GyU8MF+J1KZ2O9dcJ3DnRcClT2xqXZO8qcA=;
        b=HlVyJhOXgI+4KFBg8HI2V6UZJKWXIWaRqbEJxMCec6v3mgoi+n2eAExLDqTjHEo7l/
         fdiPaqJPjWLwDmeDjszUBZp/Xw4OyAqaFqON91MIh4neLPs2BRQbnwI4IXBznulEVz+1
         eJ3C4X4UyzxeMeRGZiaZ3It/Yns2JBjP0ibs8nKdG16DQyhUbRTaNX2owBWOCptm1+Tb
         STR2n8JWiqmauNmFCLmV/YmGYP/a7xB+RqV6KOIyI/aytdEl645RTnHzOVDlJz2wCFY+
         G3knOZkUo1Td60PRSb+FMr39Y0fgnKSgay9yKstkBAVaV4ZFj++pT0/o+T+VNGKAy9wa
         ANrQ==
X-Gm-Message-State: AOJu0YyTN0qH1NrHKtoRMr33KU2PdxxaA0hJqZ89DEFohKNpn339FVOk
	UXe6Dv8f4PgqE+yrOwVfdXE=
X-Google-Smtp-Source: AGHT+IH0e0BsVVu5PPn4Q2TeakTUfnpt+L3Hj0xiIoNfkyfLhqg1pQ9BbJdXNsEUca+tUpWfQPP+NQ==
X-Received: by 2002:a05:6808:1817:b0:3b8:b67f:b7d4 with SMTP id bh23-20020a056808181700b003b8b67fb7d4mr6149497oib.68.1701800497860;
        Tue, 05 Dec 2023 10:21:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bq31-20020a05620a469f00b0077d65ef6ca9sm5203450qkb.136.2023.12.05.10.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:21:36 -0800 (PST)
Message-ID: <2388daf0-3874-457d-a554-882bd3cd2cd6@gmail.com>
Date: Tue, 5 Dec 2023 10:21:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205031519.853779502@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 19:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
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

