Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC61E51F
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 10:15:31 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686efb9ee0cso638235b3a.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 03:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691662531; x=1692267331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=mv/eiEelF3l9lLUsBRPcXttFeQVRF65Q6Jsq3pEre1Q=;
        b=h9mwry4H0A2cJPJyKsg6gtdpplZQwGlzgxVECyd9xEF1Bl3mclm5PKH9z8KMLUtj62
         TABJVYfZYDDbUa5Zj6YaBEnT/aDXouImvlYLio3j8gGMaj23dQk/+yuV3xK9AOjZmtvy
         sgfJq06J0thV5BOx+Dp0D0Jc+iapQjwFFxU0QeaLrPbeqj0Srf7M7tikUi979g4Xweja
         Hp9glL5ZInMOeuQ6xL799JqSaCa5XgwSdS2mtS5J+IQlkXwnX8O4uHaCz6ugjUvrIzaz
         BsGcakr9TgBBf3D6IBfa8JlrrsGy3gFHaVllF3Kk0P9A6dj0BhN6sUew1TXDSWiAEO56
         bvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691662531; x=1692267331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mv/eiEelF3l9lLUsBRPcXttFeQVRF65Q6Jsq3pEre1Q=;
        b=eWJ8b/7mBPqIpyZdAOcZRr8yMsMvy7joz2ihApCNDivAI00Gyj/Vs5u/uC8puAXQn+
         ys/NipC0C+sUmLb12F1AfvizcgnJ/ddrtJHWeVQa5bi0GaNhY4Pk3rwA5BAs6PHp+z2v
         fYFUDAVY3lXFKlTzsjXz5JmycoHWpQ7BqIF9LxKTz3ErDC1YIEOKVTk/T10qhgud5nIW
         ZJCKQDK20tjvD0RVmiaN79fyDEYF/wmpreJF6VDokisA4VZ/jcayX1e+RG2FZFuap2Sy
         lEtE5jzDIIeu1TbsVsqPdOu8yFhQZu8poa09sPuIiAzzlRoogXUO59nisXxX8rlhGM3e
         YxXA==
X-Gm-Message-State: AOJu0YzzHMcrhMYfzLMWn3AsFXHh0YN8512jbgBtgGBVdpwL+D2Lp0Bd
	0yyq6ASSlKYZWhEFNGgz8as=
X-Google-Smtp-Source: AGHT+IHb4UpN8rioZwiCER8tj6911+u3pJdfglrkER0CMCQrYCj7iq+kQwWD2J6YG9fvSstJBWUr/Q==
X-Received: by 2002:a05:6a00:17a9:b0:63a:ea82:b7b7 with SMTP id s41-20020a056a0017a900b0063aea82b7b7mr2301540pfg.28.1691662530690;
        Thu, 10 Aug 2023 03:15:30 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v24-20020aa78518000000b00640f51801e6sm1146627pfn.159.2023.08.10.03.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 03:15:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fcd7b764-9047-22ba-a040-41b6ff99959c@roeck-us.net>
Date: Thu, 10 Aug 2023 03:15:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230809103636.615294317@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 


Building loongarch:defconfig ... failed
--------------
Error log:
<stdin>:569:2: warning: #warning syscall fstat not implemented [-Wcpp]
arch/loongarch/kernel/setup.c: In function 'arch_cpu_finalize_init':
arch/loongarch/kernel/setup.c:86:9: error: implicit declaration of function 'alternative_instructions'

Actually introduced in v6.1.44 with commit 08e86d42e2c9 ("loongarch/cpu:
Switch to arch_cpu_finalize_init()"). Alternative instruction support
was only introduced for loongarch in v6.2 with commit 19e5eb15b00c
("LoongArch: Add alternative runtime patching mechanism").

Guenter

