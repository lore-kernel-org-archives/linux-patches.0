Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0501B2573
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:38:02 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-63b5465fb99so2274158b3a.1
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 13:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681850282; x=1684442282;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UpgEeG9DudBLo5w82HUp9k385iL3QIeQyoC6nN4dF68=;
        b=Cvhw9/3nHnO9y6c+RBWxBGqoZfv6fZ7kkf72wh+YTogZ1PiG/6815gh9iriVAxyapk
         b/RWP+vMmdkT9UxCeLyTE+TEBcKlEvdCkFVXzJTGk0fkg+hNA9oSqt9BdHTXBu5V4uNS
         wwJ8bWSvRii/CXmXAoZoRNFe9dwJ7ni4W0cd3QAS8S/tsrvu1+YRdc/DnqrKqWhQZo5Y
         vN2qHHbeteGi/EJiaRaUGN/ylJG9scgLQMHCgqZupzDCbjxzcqRIQtxDAZp8ZTY7OEA3
         Fth1bUk8Vnx2j2uuvUcbZhOZTOvVLWEGdOzHxjzgsPc3jvgTXU85J40S3yUuOizBDaW5
         ut5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681850282; x=1684442282;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpgEeG9DudBLo5w82HUp9k385iL3QIeQyoC6nN4dF68=;
        b=XHqVC9Lg+QTIyThHYWY4jTD492rJaZEiuA3dflYxS0MKU9OfGe2z1j6V/nt8gscTdJ
         fxx03X/Vj1R752mE60j2NwbSmSitHnhI1l/bsUuvsvX/j7BsBWJD1yh1LXojuHcZg0eL
         +gmRDbyeP8mfB0ttw/RlT6gaX/69KdLG3xdlnmxT7I1wYF9QADbEaSwRlaJcUniq5Vnd
         SEARvIkLM7jPP6EnhWuZpndx6sWg/GsPfo+gpu2eveLMaT2N4y+5HKLX4a54Sv9Ttsf2
         r8X+UzvStaamFbKwSUvjePENsoNwlaZ8Ai9pu4D6z+ZQPuM5KNJZ1IODH2PAiVejnhEN
         TseA==
X-Gm-Message-State: AAQBX9eT1+LV0P2fFbNy9C104ovWIyAADUqIoG6WlmJrfkWvbE6+VI0z
	k/3kuTHUoRFDhmQT+mKGpIo=
X-Google-Smtp-Source: AKy350Z0EDO2jRyhUlCP2JxhfNbFOI+KLI3BsQruc9O+D8mmP8r4ur7NinNwbqSKYe8IZOFK/yeTKQ==
X-Received: by 2002:a05:6a00:2395:b0:63b:7ae0:fde9 with SMTP id f21-20020a056a00239500b0063b7ae0fde9mr1028652pfc.20.1681850282305;
        Tue, 18 Apr 2023 13:38:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h3-20020aa786c3000000b0063d375ca0cbsm1875019pfo.151.2023.04.18.13.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 13:38:01 -0700 (PDT)
Message-ID: <ae6f4a78-e44d-b4bb-d2b6-15ef02db9f33@gmail.com>
Date: Tue, 18 Apr 2023 13:37:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120305.520719816@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/2023 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

