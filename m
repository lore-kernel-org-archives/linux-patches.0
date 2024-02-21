Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47263FE0
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 01:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708479641; cv=none; b=WvkdDyUrR3tChAg4AJ0szDJDEl9AF8dYGEvpPVJgaFZPk3ryur6V0gt1UPggcgGfNp1vbF61un07EyoxOyTH4vmzbWRcXQcYNDO+GsM4KzU/Bsi/cBqQCbHVh3gVnetoik2+a88jDFqe08p8rqlJiv+TWCpEtoXxJybcQzD9l6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708479641; c=relaxed/simple;
	bh=MHjeNXfg70vZndjn2W8FYoWEeFiRzFLlHm568a5/VKM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MLZnQ0UFTgx/iuoGcyWttVKNyDi7wEPrGBRbLBCEo2Wr48JzxJlBlZ0NdBfGwmnKmYqLufro7UlpWm/jiBi6RIue74djRMlm2z72mBb3KQL47dXxQwZHBSp/jt2N6WLwpIOBilxOKTwEwPDHkBWuoKajNagwm0vZBMm/RvvnXcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CxUmKfws; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CxUmKfws"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c02b993a5aso3721280b6e.1
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 17:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708479639; x=1709084439; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WFQJDZxmoMvr6g51d9kMvuqvb/f+3ctrTw6gtvp3hGc=;
        b=CxUmKfwsyuaJ+8J2LpJDOpJ5hMGo4W3ekf9B5bbsAae7cT0cb4VS6P4A5Xy9JY0OcS
         k/LIP+yvshpcwOvQdvpDk3Qvt2NUiadtnSg75yrpy5QYpM3UcyX0LNLzKy+P3IYHHJyy
         ZW+CrHu7RhrPvNI3gsgXJWB4zwIDtI/wXUx/6AU+yvX6NTml1RlqzhdGxWDKfLAY2TTz
         l7YjubaQgDwuSnvXpzZMEOtFAufEe5SCZ3CUuYUz0QBzCyWCSxF/qKccSaxoDYYO/Yqm
         1UUEwfzIpj2732hTZbqcXMgsf5ErFVmGfaW8UQeDBFoMXfOGGGuqKGeATtX1hzh+I7eL
         FZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708479639; x=1709084439;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFQJDZxmoMvr6g51d9kMvuqvb/f+3ctrTw6gtvp3hGc=;
        b=ifcWaoGXhpYYgbRCs0RUv10Hk1+M0/ivOaR6iGBUQHizvNh7kLbVyzN6QiVXLeZjjM
         bAnpGrh61TRsaXQ+L275MOZQrBYEY8vwU8Hbcu/m4fQ+Uduxmje5MeiNLZxZCZRvD8sB
         fW3sxD8qxni04QFJEuidzKE5U09YsOiQ036OsdmhNisZD0P1AdYKf1p3q1Up6sPBgRJ6
         Tg3dTeEc+vFIkwqaMc5yMUCbJpr80bvqBmNQUmaFBECEGCLAv/vLWUz8Z9HzAmTREtW5
         LQYmhi5XdgR2Shf6geCol76Z95M6Cfp7ZDXCJ63ZjlVvrSbbA9Cza2dMZYHLbnxuCRYU
         ri2A==
X-Gm-Message-State: AOJu0YwIRMVIIKCg5v503vbsPmgfU91TcCIdkAR83OB9MWVIwdac6OpG
	re+4vR1Nmkd1NEInWE7dnpHg0r9jl1ADMQgzArOFont6lJIarIzmXSGl0FZilec=
X-Google-Smtp-Source: AGHT+IEtmFf0cEi0/mL21f4Jx5A5mi5l/Gl/Dzo0kvoN5f9i1O4XHUPyAD/0vafiZ2SjHgHDua6ylA==
X-Received: by 2002:a05:6808:384f:b0:3c1:4d83:30dd with SMTP id ej15-20020a056808384f00b003c14d8330ddmr15714514oib.13.1708479638926;
        Tue, 20 Feb 2024 17:40:38 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id y16-20020a056808131000b003c046fa43d7sm1363131oiv.19.2024.02.20.17.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 17:40:38 -0800 (PST)
Message-ID: <7e1faa29-a154-41fc-aebc-38d5f355ea90@linaro.org>
Date: Tue, 20 Feb 2024 19:40:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.79-rc1 review
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 matthias.schiffer@ew.tq-group.com
References: <20240220204841.073267068@linuxfoundation.org>
 <c873370c-c12f-4f03-a722-1ae59743089b@linaro.org>
In-Reply-To: <c873370c-c12f-4f03-a722-1ae59743089b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 20/02/24 7:04 p. m., Daniel Díaz wrote:
> On 20/02/24 2:49 p. m., Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.79 release.
>> There are 197 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 22 Feb 2024 20:48:08 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> We see a regression with PowerPC:
> 
> -----8<-----
>    /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S: Assembler messages:
>    /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S:124: Error: unrecognized opcode: `sym_func_start_local(setup_g2_le_hid2)'
>    /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S:131: Error: unrecognized opcode: `sym_func_end(setup_g2_le_hid2)'
>    make[4]: *** [/builds/linux/scripts/Makefile.build:382: arch/powerpc/kernel/cpu_setup_6xx.o] Error 1
> ----->8-----
> 
> This is seen only on PowerPC with GCC 8, GCC 13, Clang 17, Clang nightly, on:
> * allnoconfig
> * tinyconfig
> * mpc83xx_defconfig
> * ppc6xx_defconfig
> (at least)
> 
> Reproducer:
> 
>    tuxmake \
>      --runtime podman \
>      --target-arch powerpc \
>      --toolchain gcc-8 \
>      --kconfig tinyconfig
> 

Bisection points to:

   commit a65d7a833f486d0c162fdc854d2d5dd2e66ddd95
   Author: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
   Date:   Wed Jan 24 11:38:38 2024 +0100

       powerpc/6xx: set High BAT Enable flag on G2_LE cores
       
       [ Upstream commit a038a3ff8c6582404834852c043dadc73a5b68b4 ]


Reverting that commit makes the build pass again.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

