Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D9399
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 00:21:20 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id 4so10664035plj.3
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 16:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FaK6z3GrOP0OER65BMHomvnlNSQmxSYdORpZuG0pagA=;
        b=e8/N4LJyB7BHMSYTtZ8iOTuZ8R7DVv0z7VuE9DQ0nbPp+tetGwMcDrnIxW3CSymell
         7IeZujNbYNUoKSI5UNIX6Xzq370Svem1Ec8on9zzt8Rq7HBKgHi8U+2KQmQKYKhBLckm
         Qx8hVeNAb8g2B/i7wTdmaDtCARm8nKk+y+F/rpC/qdCU/OC0cASOQr4Lk6euxYzDsYqM
         Mec3Ytsi0JdtwSdvjvQaaw7jOeBirIywMyYkvoBlayaSinQKfaCvtY9irnyIoCyOrdm1
         Gy7ZdOWFNqKLaIgVjSe2mc/sIGw7irkqKzjogqEycchqwWP6zTK8FhzYEzNRKmlGYG6v
         aaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FaK6z3GrOP0OER65BMHomvnlNSQmxSYdORpZuG0pagA=;
        b=QLH+kXZWsoxHO9YhnqpEvGajsche8h7Z4cNb3Lc+qJpvi40R4u97YGyh2hpTfVU71N
         y+efFzrdRLARepTH3pKx65NM7TTm5sdLH+ibJrkBp9wwYnVOIolKAYkrkYFho7ihpsDW
         3jiMZ2kCnaoZzkASQm5aTZ0onb21I9PHCur+EVJVT3y0PHNiH4ecwu+tjnQ1j8dxZZXR
         yTPH6ps6L/GnhkKaMjgE6KCIEJz4V+lBaeTRhsU9rLRnTvM2yHE+d0HCBwajQCY+8RNX
         ULnujsYKYqQl2SncOl6O7Sc5OH7fLtK+QOV9bjwTtSMRgmwgfkp5p79CswFY4pmDx370
         wR3Q==
X-Gm-Message-State: ANoB5pnlXwhg+GjootF/nETZ0ApjqS0ZDEFZ32wSaI8QFSodahrRAXOj
	3jJZ2fyMVzYQFGzp256mhm4=
X-Google-Smtp-Source: AA0mqf4asHePCzJlxD4MPUU/8AE/RF08E4I9Vdi3on0Hz0v8fFVMf7L1GhK413Ftj6MrZm7Zvc3r8g==
X-Received: by 2002:a05:6a21:789e:b0:a4:4578:8caf with SMTP id bf30-20020a056a21789e00b000a445788cafmr64431166pzc.43.1671495679854;
        Mon, 19 Dec 2022 16:21:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id om7-20020a17090b3a8700b001fde655225fsm34989pjb.2.2022.12.19.16.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:21:19 -0800 (PST)
Message-ID: <423d222b-5b71-a179-b2f8-f4231aa03270@gmail.com>
Date: Mon, 19 Dec 2022 16:21:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182943.395169070@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
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

