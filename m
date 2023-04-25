Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3C933E5
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 18:43:33 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-51b0f9d7d70so6226028a12.1
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682448213; x=1685040213;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=seaqzbM0T/KT5lN1ikdO/NY3x70xGuSLmb6mU7SK/YM=;
        b=KJUOKnpyLl12Ao33o+U9l4yG/YF2rQoOGSX8Ru0D3qtPj4GF8E+IZhAqBWCqWrurFF
         oqaSQskVH8lS6fZFBhk72MqhveAxfMrksTsYEECFL6fl6NlJiDTILsvuCUMC4dk6Iu1O
         CTJ6SYLuXah5HUGZiahuzPthpXw5rd1Q4uBBy138fSBbV5oCoCJz9f9BDKQAl7n3c8ja
         g5EIrWT4+j0wrkY6yC6e25ukXTzaEzgJ1j2tnbc2qBqNUVKEolABunj/NtYC6iZxHC8D
         1AkKSw7NOPAiNeQNMA6gJhoNN6rQUt4KwlYJrvcUaTwPA5jtHtbGzkM/AphoxFDs9KBN
         TqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682448213; x=1685040213;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seaqzbM0T/KT5lN1ikdO/NY3x70xGuSLmb6mU7SK/YM=;
        b=OxvcSamhW27g87srsjivtI6hnKqzb7Evmd/MBxIvodZ77gHF0yKGVvEo/QRKKDU+6J
         3jGQhn3CDKX0sL+CNJWvlkysCUWOsXDQ9NQiT6iqFjxI0SYZPGn2hHET/roOyYHviLmE
         J7Su2O2TGKKSsADXlcrsI9PTghxrL9ufKOH9hHmFZTzcCO89v5noc2rTfBCjhAqBACpO
         QMbUMF2cefeFvoGPP0zPdoUsDW9vnemYIUMF0Fgcl48l+5VmyYUsvIis0+EF5okaqo34
         EQuuVSKaHj3PmJPhYV6rf3+QZX1SRDORAZTo9lZvFTtDL00ADJMvVadMBObVEhZVUFrR
         NR6Q==
X-Gm-Message-State: AAQBX9dYcNPzD7XwCx8lHvOp/Ok1HK/odXTeEqg65QqXDRjZ6Rn7HXYA
	yl3VNvGjoFSJzuVSMk33irk=
X-Google-Smtp-Source: AKy350bSwSyUk4TsW4BLeOlQheixISlHJlK24ZtPBWlG9l5rQ9DJ9Nj1z/Y5lO4vM6WsXJgNa1OWaA==
X-Received: by 2002:a17:90a:7783:b0:24b:5a08:5cb6 with SMTP id v3-20020a17090a778300b0024b5a085cb6mr17214810pjk.19.1682448212565;
        Tue, 25 Apr 2023 11:43:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pw12-20020a17090b278c00b00246ba2b48f3sm11843465pjb.3.2023.04.25.11.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 11:43:31 -0700 (PDT)
Message-ID: <7b13bdf0-bb18-8f3e-0a4c-064ac47eb45e@gmail.com>
Date: Tue, 25 Apr 2023 11:43:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131127.653885914@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2023 6:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

