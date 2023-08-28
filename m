Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238AF12B72
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 16:42:15 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3a812843f0fso1977624b6e.2
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 09:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693240935; x=1693845735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=07+BqHH2fvjqSJVcNPgMWDKWkC2DZMaqXd0rPYXV11E=;
        b=MzKTMIdKFjKyzdis9lZD2DJaudlaVtLPRBvUUxdtaNKYyaGkyoFdBr88+bo8oiuqDX
         J1sHRygsdtUHdH4Xc554WDcOR4xRNJSJGyE/iLyINu9Rmw02s4cRG3y71mtWx1u0lBGN
         TZmwgosaJQWK4zz4/j2DHgNA7NTzq43QAZF11SFyqpZifHKWauCDdd8xT9zOg/q47iQ1
         qnlfBxkavy3jcWDo88V6UwNrOFZPWEZKohjBClAKSIDHMfcfV7olXDtVVDOF8h07nATT
         3RW2PHgP+1TKJfkuKaA4kpnsCutp9Fj2i7shH0p3GsEiRzu/1XDwDc+smnfuB2gTYdqe
         Ay4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693240935; x=1693845735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07+BqHH2fvjqSJVcNPgMWDKWkC2DZMaqXd0rPYXV11E=;
        b=cBZISFT3CA6ptIe3FaQS9tKQX3ykjf7vs5ZE17LyWe1kghmJhXudy+VrLqXYiDMbBS
         OhBWHrlHSqq17qwt6XQBVadcWQktDETsrvh0K3pL6qvFiyjEI/fV3ImHN0kAA6mAGtv8
         xcceijCTKHWXqLAnaixi0bzODSIq7TpEt3FanVLclXczk85aFl8w7Zg1jJtwW1ea7cIR
         7RWArmrPttyI+eMRorZMbhDVHum91fpoxMjyy4M3XAoy3hWUXq2CqKf9Qt8Wm4AjxwcI
         5Ts0oGr3gbwMpxTGDxuYFHq1SGkfOqOV+NmH9imKIc2c/TV/pgARToNvBxtsIKdRFmqk
         qsZA==
X-Gm-Message-State: AOJu0Yyh2jg2JAHV+BVH/t+PRapzUgXd6Q4K9IVhoGEEXKFXFU1MbJ8T
	EiJKDc8Y7IxB6OSq/5STUjs=
X-Google-Smtp-Source: AGHT+IHeyhhWz7KeiPmmlRz0UTwkUc3V1SpCjjgwkl9iq5cJY9klp2pXz7fWqIjdSmUlVLaT0oWU/g==
X-Received: by 2002:a05:6808:1892:b0:3a7:56a7:6a91 with SMTP id bi18-20020a056808189200b003a756a76a91mr11967872oib.23.1693240934952;
        Mon, 28 Aug 2023 09:42:14 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z190-20020a6333c7000000b0055386b1415dsm7508224pgz.51.2023.08.28.09.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 09:42:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
Date: Mon, 28 Aug 2023 09:42:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20230828101149.146126827@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be reverted
v5.10.y since it doesn't fix anything but breaks the build for affected boards
completely.

arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
arch/mips/alchemy/common/dbdma.c:632:14: error: 'dma_default_coherent' undeclared

There is no 'dma_default_coherent' in v5.10.y.

Guenter

