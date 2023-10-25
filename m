Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7585D15AE5
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWkdGjfi"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cacde97002so36523415ad.2
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 08:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698246449; x=1698851249; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JP1FjdQMG6Z5vfQZsofPNw1OQcVaM3P5E6uI/DRXk8k=;
        b=OWkdGjfiZRFDvPZOmUofUhgZhsR0VvvnJE7UHui2Q4aWNncUHz3CfZZdm/3xCv+RWs
         lEKed+WhUyoKEk5rW0LWnFrRrm64x+w4s9qKVhGC9jvOo8mRn/YfTxXQItFTlcHwOCwK
         mht8BZl6UiK4px0mlwnj8+WBiFn9aZCHw1mcjNkI2dsHyPrVcAZ20z0TlH6UV//5dF7C
         lUxScgyzABBtsZZZjXyw86VG7H6F/fmMQZKHaZ6T4XA2GYkY780TDsjRZgIx7i5qpuIC
         5fNdRLrhSwzYOOjl9Z76VoWStfhpYqzKwe51MrRNfwsmIGxzu6u3DMLNG85Q95WB+M1k
         C8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698246449; x=1698851249;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JP1FjdQMG6Z5vfQZsofPNw1OQcVaM3P5E6uI/DRXk8k=;
        b=SV9z9WCaxLccLA4eSpicUb/+B8t+4bjDT7ud+wA50lTpUm3Aqim+COJOwwt+hKk7LC
         hVkRw9dP+bB+iPqJChotFKjjQ/yZuY905oAbVih34VhKh3xJI/9x+5uWAFll6AIHt7us
         N8KrT74tMF2i6xr1ddO48bU9ycDQ05N9FuctByJJDsOx4xjkvURcQHFaLA7zBzHWa82a
         KGvlxZ9zaCAV4mT9n8YBuGgyAgGy7BFMTtcE9ZxkWacPkNqDXPcOeEQPPhJiJ0D2MXh1
         T0u8gSZm3Aa4VlgAcVuhb6trCCGB0MqVLTaF3bAmYXmUwVqqf2kzrGsuJNuSK7rZ4Aou
         BA5g==
X-Gm-Message-State: AOJu0Yw7XgSdPtxyT1IDQIV7Zn9jTPoIeFX8FSNAjgX4sXAPQcoxK3CM
	pUxJhERRXKMDVAFpNYlb8Cc=
X-Google-Smtp-Source: AGHT+IFMOIIhptdepjZLOZzYYCzLergAVAmDgWVhVsoemQVUM+VhK/lctlxxQ/HCg7xsgPO3MFsjUQ==
X-Received: by 2002:a17:902:cece:b0:1c6:16d3:1783 with SMTP id d14-20020a170902cece00b001c616d31783mr13902474plg.58.1698246449576;
        Wed, 25 Oct 2023 08:07:29 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z20-20020a170902ee1400b001bdc9daadc9sm9334783plb.89.2023.10.25.08.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 08:07:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6413ac66-2608-cd76-1b3c-5a185fe6d88d@roeck-us.net>
Date: Wed, 25 Oct 2023 08:07:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20231024083326.219645073@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/199] 5.10.199-rc2 review
In-Reply-To: <20231024083326.219645073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/23 01:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:45 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.10.198-200-ge31b6513c43d
Compiler version: x86_64-linux-gcc (GCC) 11.4.0
Assembler version: GNU assembler (GNU Binutils) 2.40

Building x86_64:defconfig ... passed
Building x86_64:allyesconfig ... failed
--------------
Error log:
Unsupported relocation type: unknown type rel type name (-1940038754)
make[3]: *** [arch/x86/boot/compressed/Makefile:122: arch/x86/boot/compressed/vmlinux.relocs] Error 1
make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
make[3]: *** Waiting for unfinished jobs....
x86_64-linux-objcopy: vmlinux: unsupported relocation type 0x9e
x86_64-linux-objcopy: vmlinux[.text]: relocation count is negative: bad value
make[3]: *** [arch/x86/boot/compressed/Makefile:114: arch/x86/boot/compressed/vmlinux.bin] Error 1
make[2]: *** [arch/x86/boot/Makefile:115: arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** [arch/x86/Makefile:274: bzImage] Error 2
make: *** [Makefile:192: __sub-make] Error 2

No idea what is causing it, but it is persistent. Something odd between
compiler/binutils/objcopy.

Guess it doesn't matter since the release is out already.

Guenter

