Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E91A180
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 00:10:01 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso136722pjb.1
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 16:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWkw8USON2HrUmyH0b8pO4aOKQO0VycbPyO1Pmwem9g=;
        b=l7igjYwSI5wvqZQy8FZ9NFcMXbuebUmal+Pcgj2QYFvZyvfgav8B7jrv+vU1/eKTj7
         tIXuS8KnSuCAUfFxQSlwuxG52FD/oFV5eXOTAbSZ3rREgu1HPRGuED/I5sh+CJ8XCudm
         Ro75/VHwCI5FC1Vl3jsJ30q+htK3ruZlK5A7AEH1ULzyCpLHfJs6zdwyMpCT8K7i2jCX
         MWv7dMyQ/loo723dFK3s++PtuK43fgt33ZtARysxGO7YL/zlp+am7vNS63illY3GMRC/
         M2dBSeNcjk5HVzTUypaLfDcXbFzdV8hFEkeZCRAJbjszNCmz/kik21a/6qw6WOZZilv5
         h2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWkw8USON2HrUmyH0b8pO4aOKQO0VycbPyO1Pmwem9g=;
        b=ENt/j9nIFcQDrTBtZSA+ZuFumDrf88ImtoDMBCg717JAtOHSDdPK6DpDesvMhGZkEM
         oIPdPUrjpJTE0VRBiJtHO0D/HRrCTZpz1Y4Nd6s9eO7WpNmK1XwbtbNw+YyVmI3blMNl
         1tBV3DqEwbJ2O+tGsAACYMbZF4KW9m5oLcYG7LkRM7LQWZoco7QVMAGKv+zK77VZXUrH
         yrxpTbNptDyBjwKQ1o0Pe+2Z36mR5tamV7fZwrSMQcvTPhmrQFD9JtJwY3nwabGzQ+3v
         16vE5WcYhor1cSCBcwuzBlbIgmKsnyi3MQCNNVHylWMCSx5RvMK4JjgXC5LDsnmhwQVy
         oMdg==
X-Gm-Message-State: ANoB5pn139ljm/UyA+Ds2A0j0VlnKlFxnB3qQhi92pacVP788SV3OaKZ
	nOZ/1cq76BiSMLMTzvaFT6U=
X-Google-Smtp-Source: AA0mqf5y7GS7F6F0deLhC9nxIAXYbGotWppRNNY16or+szh8u9muHc0lqaYp0bdrz4UyqwBvoYLdXw==
X-Received: by 2002:a17:902:7b84:b0:189:6623:4c47 with SMTP id w4-20020a1709027b8400b0018966234c47mr16848890pll.170.1670285400914;
        Mon, 05 Dec 2022 16:10:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm104426pjb.1.2022.12.05.16.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 16:10:00 -0800 (PST)
Message-ID: <023b17aa-5fcc-1465-79b0-0ba4ba86f580@gmail.com>
Date: Mon, 5 Dec 2022 16:09:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190808.422385173@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

