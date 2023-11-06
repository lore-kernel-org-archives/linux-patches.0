Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C799229CE0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PpmtF1et"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3b566bc6daaso2857108b6e.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699293188; x=1699897988; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9WROodUma+YX9D9t3U/MSNsWH+qYxH1P9vdKfkt+6QQ=;
        b=PpmtF1etnSbNQ4mbFor3mm3pK2D9oLi8ZfGpZGDe2XbrGwse7cCrbJqqAbBTy+NGeP
         10D9e2pqg2cW80pD3sMcMFc2xzDiSJUbhe1JOUz4loUftuS9N6zW4MDS0lirRqwwuZig
         PlGFA7AVx1SCaYqfUPtZzeMI4SKbtIR6cHAfj8eZkAXakvwQKkOW+c2EIbpTfBZ+Jmxf
         y50bHIWdPKgiVyo57RZeoupHPBKWhXu5q+8T2I2rqtkGThjPN+uOLxe/DyI41P631Nai
         F251dDHUkr6DAzhJo/BPKgnsEvjtJHz9ZiXj4xD70e+YUbm3A1hghA6z4s+7pQN8HtY4
         FTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699293188; x=1699897988;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9WROodUma+YX9D9t3U/MSNsWH+qYxH1P9vdKfkt+6QQ=;
        b=EVxU1BCXVt8jF6qtvsQYzF/kGYn6ePUNstKZ/7W+vMESbuCghYnyh9/tf2RokbFEYa
         0N9ye+l3/ck5L/W6grI0oPTBebPJvah1aw2DgjEmpx6QrsE/zeiugaKG/NojX+vLhirg
         btjemBs+jfl3iK4xvEjuzWhfNFnfSDGVktJ/L20f7u2BoxUWB1cpEhW6ckChi1lx2Qgp
         BH7ZBIpATcIBlEDeTbHaLHn5YXu7QJe+pvycGDa1jiYX78VRMd4u6KpVwtAYw7ncteeZ
         yiUmTm9Xv3w3/uPOlDj1Vn3zVn+B2P8MRy/4AzZkscJDfu5z/tEhKil2BDqWipuN1eQa
         0o7A==
X-Gm-Message-State: AOJu0YwqMpxszQTMt54+1IO1RMP6Glf3A2D8NLe/74GAo4L70wtoZUw/
	/47w7ExAsA5AOqfJfUUA9dT2MQ==
X-Google-Smtp-Source: AGHT+IEL8z1Tr9lAONkY54ORSL5BRqixdea0A8W3dB2QXLDSm17ZTbZxHici7Eg4mDMAISCQAjNb8Q==
X-Received: by 2002:a54:4407:0:b0:3ab:38b0:8b84 with SMTP id k7-20020a544407000000b003ab38b08b84mr31465404oiw.17.1699293187829;
        Mon, 06 Nov 2023 09:53:07 -0800 (PST)
Received: from [192.168.17.16] ([138.84.54.223])
        by smtp.gmail.com with ESMTPSA id 11-20020aca100b000000b003b2e4b72a75sm1302246oiq.52.2023.11.06.09.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:53:07 -0800 (PST)
Message-ID: <8aec1bd5-befc-486c-9e47-7571b937b8c7@linaro.org>
Date: Mon, 6 Nov 2023 11:53:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231106130304.678610325@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 06/11/23 7:03 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

There seems to be a problem building for RISC-V with GCC 8, 12, and Clang 17. This is with defconfig, allnoconfig, tinyconfig:

-----8<-----
/builds/linux/drivers/irqchip/irq-riscv-intc.c: In function 'riscv_intc_init':
/builds/linux/drivers/irqchip/irq-riscv-intc.c:119:17: error: implicit declaration of function 'fwnode_dev_initialized'; did you mean 'zone_is_initialized'? [-Werror=implicit-function-declaration]
   119 |                 fwnode_dev_initialized(of_fwnode_handle(node), true);
       |                 ^~~~~~~~~~~~~~~~~~~~~~
       |                 zone_is_initialized
cc1: some warnings being treated as errors
make[3]: *** [/builds/linux/scripts/Makefile.build:286: drivers/irqchip/irq-riscv-intc.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:503: drivers/irqchip] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1832: drivers] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:192: __sub-make] Error 2
make: Target '__all' not remade because of errors.
----->8-----

Currently bisecting.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

