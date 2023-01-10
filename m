Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E0A94F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 19:38:21 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id i65so6208350pfc.0
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 11:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoXD1OgyDYyTbjMw5dZ27r0qsE54dNiVyR8gm0rBom4=;
        b=SqXTCPwXJaDBdJJ2vWjcG1x9BYAe16IKAL5ViJ81Hybj9qnfN5eyxVIp94ZbY4Yate
         pxYV9wvMU2GXxVLuMbpeHnRMQ5XPlzDLJUn0A3P6S5PzqQ19QICJudVwvepJYtfI1EOO
         D4YU1k6nyVwOUuWpU4uR48xQyUBmmtGriodRzhc3mJMaOpEn1sMxlP/XVaIBxBukNW8V
         9vOVkbvAz0yMN4dq+1b9I7ayu0M4ppvs3CTuztJHs6My3NBb9U0iWQqaJCnzqbep+AHD
         ecB2I7Q60gKxpBP0Oc56I3t9InrtRgnjOw0qDg5mOVCSaocftLY5MSbcw26p2hwLzFEx
         wbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoXD1OgyDYyTbjMw5dZ27r0qsE54dNiVyR8gm0rBom4=;
        b=XrrAL3qCnz2o6xFh1GXGvMg/v5rxhs/uIh1DeMkqCgS8nmsIGlr8bHLbSae6lsQbL/
         8RrMBQABEppTGyktbGNXGuF5QDJTwYyLjOz8S4eSioCJfhCiui2lt++0nfUpp93Sa7mT
         QMMXcceqe47GFBlLSQyqTg+IYiPIUFTBwb/rv+gLmNsxEjOn2o6GADGeyAbrUhFcyRv4
         tZJTnFZFUsi2g3s/Pf3NcA07TobBNzZtxofkGqbnwxsollaa/Mpz8DHKmEUAxwBc0Mqx
         jtJJiZ96rgprxzP8x8eb9l5uDvXBfWWHVX7iFd4zJpZWLc54f0cuZZRUpT3DkTh+D1Iq
         VpwA==
X-Gm-Message-State: AFqh2koPtkYZp83cisx8jRULwDDNC3R9Y7aU1iwZKDfEC/awm5TzRMjc
	9ugPD94pAKDbyrWl2FyPHw8=
X-Google-Smtp-Source: AMrXdXsvKpBkQP/Od7HHJU5VOgqPMYAGSeav3H7/IcIUTcgNPcmJ1eVdqHWnXNYBwQ2/NNTsIHoV4A==
X-Received: by 2002:aa7:8a42:0:b0:582:34f2:20f1 with SMTP id n2-20020aa78a42000000b0058234f220f1mr36105975pfa.11.1673379500566;
        Tue, 10 Jan 2023 11:38:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b6-20020a62cf06000000b005624e2e0508sm8417588pfg.207.2023.01.10.11.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 11:38:19 -0800 (PST)
Message-ID: <1db853f8-cd98-2814-a643-8cff16886d07@gmail.com>
Date: Tue, 10 Jan 2023 11:38:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180018.288460217@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 10:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

