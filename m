Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B773AE79
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 22:19:10 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-3f7f73e90f9so67505631cf.2
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 15:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686176350; x=1688768350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rIgA+P7f4yCi2//4vLetDTH19rWaTG6QenjxMKj5UEM=;
        b=gz/Avg2DZa0mkWMnclQQHqpjltVHceBf4YG1kLo2+ktQ5UXiVXN8rg5SGNL7Z9KzqX
         4+waSR2CALIN7sFwAkASQxwAXr+a2PfHKRkcUWPq1PwQ3nG4s1hMMXVcq/5w9IzkvcJT
         Ykgsx4zEHAUZH36A8xQG8bSAzu1n9G0BxfEWHDgAXPoc/O9ZU7mocG77K4SVNiK5eUXE
         lzs1jJp4brDGhaK5KpoYS/8nB16YFtgMwCGFF4cnlp+QqLV1MlACmw4V52lBhMDLCvPr
         7ai/Aj440WFYMvIIsGyBWVXsc8D4X7AyXM3VS66daVu6/r82xaZLgcrL3eosXB/Yh+Q6
         Y4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686176350; x=1688768350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIgA+P7f4yCi2//4vLetDTH19rWaTG6QenjxMKj5UEM=;
        b=ceFCGOOvNlRx6MO9c9NTroMvPkvWriQf74ZdAXxUgNo0cxh+e2z8+oqy5yp0jlVQ+F
         9JES6YgBo0DL6+OgPcwknM/ul6J5tfmOfCQr0VDZaS+cL/nI0/LBTlfuTOzsSs425c2q
         PEUrNe5uizdtIIIAwXRk6OPBM07iQuFFSrcEiZYVuZ7m/2vuYT3SQ1bkQT/hsKflXw5T
         XHCcq2tenVow6V5JB3PSNZy0/thLMCf/r0ELCjQOkkudSOiibcnmRw3uqd7pBeHogxDj
         zrgS4QrDYtILDRJuwIRxfdg8fsqByJugCwBIihsDgxk5b3hQPSlzA7Yb25Kwwx61adhK
         gV8A==
X-Gm-Message-State: AC+VfDyegNo+sHrKF5U7Kb8gMavwYrzArdtk+ju8StZjTWZ4oPInk7ty
	uSf0QP+GIza9jkKAxGpLHSg=
X-Google-Smtp-Source: ACHHUZ6rHF7ySirc4pbFlDouMFKi3e2FuMyqXAfP00bgd0iRloaj39fFZFnIWrwyOq6XQzJ5j6BD6Q==
X-Received: by 2002:ac8:7f54:0:b0:3f4:dec2:76c3 with SMTP id g20-20020ac87f54000000b003f4dec276c3mr5780582qtk.22.1686176349641;
        Wed, 07 Jun 2023 15:19:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fg21-20020a05622a581500b003e69c51cf53sm230151qtb.72.2023.06.07.15.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 15:19:09 -0700 (PDT)
Message-ID: <202b6f78-c43c-65f2-01ce-83406ea04260@gmail.com>
Date: Wed, 7 Jun 2023 15:18:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.4 00/99] 5.4.246-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230607200900.195572674@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 13:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.246 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.246-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tseted on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

