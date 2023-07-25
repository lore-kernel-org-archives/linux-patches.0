Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DB826B6D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 21:52:50 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-403a3df88a8so45702351cf.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 14:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690321969; x=1690926769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tZqXFEJOsELJuU0v49sTZz2n47Z0GHcqodEIuHlo/OM=;
        b=jdASqLsMWvG4Qq/HHjguFQkzgv3yWbJ7izVcFZgCktLOhZji2BK7pYv3EC2FHPQk+b
         bt9GfwrvagpagR5wSNI8ygUJXpc3vXfjha7HXIiPkFmy2HjGkRlVSKy9QS9r9jDIepBZ
         WGClO8mgHZTbpYv8EpoklhTXMCjKxP0iE23us6zAWOlyfIYng3Yuf7Dy8t4RmxGH4Jmj
         Fk+yCe4aKZ6pcmVtv8dSRO1NgeL65La4ckWvGFxv4b1+oSNj9JFH09Qw6jG2h6Wc4f5m
         AO/e+Rf0eSO6rgGniYRBtRnleKvwtigDN8gi/yJknjitZTK3nAkHfTGFEdxZLeEwVTYL
         QiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690321969; x=1690926769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZqXFEJOsELJuU0v49sTZz2n47Z0GHcqodEIuHlo/OM=;
        b=Rwt+iIjiFS1bWCzJY3Oer6d3HYEFKpd5iILIPnuWa5Bp19JqcUDo/GBvdF4qfeBo2u
         LcszTecD6ZnUYCYsRjZWiHfFqlXGvs6fqCZIb1jiTLZvxrtJW2Rw6Y+zPMBXXMK+b6o9
         vrGltvibXcyBFeiVO6ZFddfL7oX7MjX02XnSfzajC8gzw/Jk7JcmPmz7sqzcmy8Umesa
         L3dXID+XgcRq+zY3OmT0281eVYnMY5SYaCij2DGnJQO3rztMAsqLWuVi9+WWVYdKuZrQ
         6DvrgkmCPcIK96yQoyzjbavIxOhRyUTiFo9fEqxF6iY/1gt5uRFRpIKcKXPX0ugb0krv
         oYpg==
X-Gm-Message-State: ABy/qLZFcE5tSsb7gvMqhpVESU0jprhavvv/l/pMjiTOFnW4FdOIihVg
	9640k4VAQK+jJlukiTCHBBA=
X-Google-Smtp-Source: APBJJlHL+UTOzgSHuMPKvkao4BVSCaXrW2fNQi6JzMHVXGzmCA3hn0D9VxbDjT054+BXTKzFkKlWkg==
X-Received: by 2002:a05:622a:1b91:b0:403:e919:513d with SMTP id bp17-20020a05622a1b9100b00403e919513dmr220422qtb.15.1690321969080;
        Tue, 25 Jul 2023 14:52:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r26-20020ac8521a000000b00402ed9adfa1sm4357525qtn.87.2023.07.25.14.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 14:52:48 -0700 (PDT)
Message-ID: <f0c5b6c8-8049-9172-e39d-cd7b53349e49@gmail.com>
Date: Tue, 25 Jul 2023 14:52:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/78] 5.15.123-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230725104451.275227789@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 03:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.123 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.123-rc1.gz
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

