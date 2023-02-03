Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CF1AD5A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 20:03:53 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id f10so6828280qtv.1
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 12:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AX8rN/nRejIs/f3fT9vWTY+nHDhK8VwQ9KCiwj1/p/w=;
        b=VeIQDjXwnnyeRxOt8XBfLLh6qaN9VTOVvYb/ZOXjO5hYqwqjXfGJehRmCR0sQdz780
         BYbRWpJoKp/NgXmoy7R+5NHXRnIRvTRI5cq6iGX299SeiPQtmB6M+EORhs0qxkmX6+Ft
         JBSFLOEQrM/e/ECu/xwKh69SvSONqrHL8iHv3bmK2c2KYHzhhh2UslrCX8PYhdYDBuRP
         GCGfSfKBP3WoVLBGhekbbSjXWNwMPeFPg4AUl0+WczYA0UTrZac3Pkg7tmzzVanNNo1i
         eugKJLaR/fvmi8Xs0GPLad9MbejVQH0PwzrJcRPSj7hg+40TJLVkzDhs7BF79TL+o9eJ
         ujQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AX8rN/nRejIs/f3fT9vWTY+nHDhK8VwQ9KCiwj1/p/w=;
        b=cKWQqGkHt8FBIuT+uNgxcqHsUjRWjHeOGQ/Z5DAi0EPqkjMhE5ZkUoEJAzGHDfbWHp
         OFWZFLl4i2CxcIMI+ToAzO5QCYhJIkIEAh0BCnFEDpBJ+Eh/3NFB2LxJWp3I0nSbbODs
         2tF6UPEemeaqE1haICV9alCEdQEjYiL6YvevZWT9e8rprrvMB49HwBG5egOo++YpRb9I
         tbAaFxBHmf1No9w0I5qGrpReW+NfIY3AoqohnPdJ+t7E9OdyGJjo4Ei8jnLe0D3dmHoZ
         m7i9AZyUEGeccX/SjJvFy8rLXGA8vIZLO09b89xjVmHJbGi33DgGd2NhY7WIKZKJKB2c
         aoTA==
X-Gm-Message-State: AO0yUKX56UCq1Ry+ccVkoPI/2jqfgAHNiEacb8PeEp62ph6O1vI7FfKU
	OSL/BPiWI8LRnCBEPDhRwJ4=
X-Google-Smtp-Source: AK7set+SMCkfnKnwa2jTlPNVxI3n2/ZNzOCSyLdbf8EJ+RJnLnPObAMjeo+9lyyUwQR/ZBqby+7zmQ==
X-Received: by 2002:a05:622a:120a:b0:3b9:bf2a:1364 with SMTP id y10-20020a05622a120a00b003b9bf2a1364mr19177520qtx.55.1675454632008;
        Fri, 03 Feb 2023 12:03:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm2421840qkb.16.2023.02.03.12.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 12:03:50 -0800 (PST)
Message-ID: <3d4042de-6178-2fab-3bba-5e08b25a93d6@gmail.com>
Date: Fri, 3 Feb 2023 12:03:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101007.985835823@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 02:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

