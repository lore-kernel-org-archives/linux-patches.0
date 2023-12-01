Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054AC3E492
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z6Odc+X3"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3b84478dd51so331435b6e.1
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 06:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701441271; x=1702046071; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fln7JZ3gmS5L0otpWNEVUCaXcYxV9vulN7piRIGYzVQ=;
        b=z6Odc+X3ackdMptTTSuMs5w57ZFBsZejLBSodeuHffb72HL+c18MpO9w+UcjDihjLr
         ZhHe0u3iZT04Q075K6A0MU0hiMdLSKJ5B+s/7CCDes4OpR8V2WmTm5Hpfr5TbPUTOW1f
         QfHUgecwHdkedK3XJiCsvBDp3QdwyWHhZaJt23GyD4UGqpI/pSCcZ2NfIHZ/lQeSVjmp
         nKv3gcv/Qm3u+7qxJrPSWTwUnBf3IJMb09XKmSWHfgMEKGtzVG2IZmGqj0RfPTG7Au4S
         jPXMQhM2TBE0MFpPvB+rI2oSVo3OMzsuXnT6mFkEITq6TBboDEXkZ7jNaCg8iRc0jfcd
         tr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701441271; x=1702046071;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fln7JZ3gmS5L0otpWNEVUCaXcYxV9vulN7piRIGYzVQ=;
        b=BH/98OY9ohFj/qxY8xWiW05fMyD5Upu7VpKEBfuZgNwZ+QSSfRpI22ZAIFbNDW4ayW
         UETYSgFsqPwA3/Nx/8FymWOy01ul1GzlOXxaImB6dwwyTcLmJI4SGPepdSF0TMy8O8uV
         29G6Fx/4HbcJc08wfOO3XPja1qFGM4vnJI8OXN2D0xTwzafJxRM6/+F9TScliujtxGgf
         f7/ncHqtQt7P4TesdDg2SuIcGtuM+H9QbfFMfm8K6vC6dYFY/52vf+TErcLxxM0d7pJj
         nDdRpbe8+WT/blkZYa6g76s+UQdkUrgbgkXCHZiSIE5pN+FFAU784Pv+5xdenAQDA3jB
         Y3oA==
X-Gm-Message-State: AOJu0Yz8sOgjuOVeXyvraMYl6Ad5PBQAXmwgsrRYNDoXLYRzoVZE/uo3
	gxOAX0sRoZ5wWHDVSfli4CfK5w==
X-Google-Smtp-Source: AGHT+IGlS0ZJiPjHS08tYhuYYizp/NnBi/oTgvFplF5P7lsUqNoJ5XZsvgT8CEP84o377lqBaJlDIw==
X-Received: by 2002:a05:6808:ec6:b0:3b7:73c:ce5f with SMTP id q6-20020a0568080ec600b003b7073cce5fmr3469254oiv.41.1701441271073;
        Fri, 01 Dec 2023 06:34:31 -0800 (PST)
Received: from [192.168.17.16] ([138.84.45.78])
        by smtp.gmail.com with ESMTPSA id k15-20020a54468f000000b003a3860b375esm555786oic.34.2023.12.01.06.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 06:34:30 -0800 (PST)
Message-ID: <4cf40ef6-058f-4472-88c9-3dc735175c85@linaro.org>
Date: Fri, 1 Dec 2023 08:34:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
To: Francis Laniel <flaniel@linux.microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, Guenter Roeck <linux@roeck-us.net>
References: <20231130162133.035359406@linuxfoundation.org>
 <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>
 <2023120134-sabotage-handset-0b0d@gregkh> <4879383.31r3eYUQgx@pwmachine>
 <2023120155-mascot-scope-7bc6@gregkh>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <2023120155-mascot-scope-7bc6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 01/12/23 3:44 a. m., Greg Kroah-Hartman wrote:
> Please take some time with a cross-compiler on the above listed
> architectures and configurations to verify your changes do not break
> anything again.

It failed in more architectures than we initially reported. FWIW, this error can be easily reproduced this way:

   tuxmake --runtime podman --target-arch arm     --toolchain gcc-8  --kconfig imx_v4_v5_defconfig
   tuxmake --runtime podman --target-arch arm64   --toolchain gcc-12 --kconfig allmodconfig
   tuxmake --runtime podman --target-arch i386    --toolchain gcc-12 --kconfig defconfig
   tuxmake --runtime podman --target-arch x86_64  --toolchain gcc-12 --kconfig defconfig
   tuxmake --runtime podman --target-arch mips    --toolchain gcc-12 --kconfig allmodconfig
   tuxmake --runtime podman --target-arch parisc  --toolchain gcc-11 --kconfig allmodconfig
   tuxmake --runtime podman --target-arch powerpc --toolchain gcc-12 --kconfig defconfig
   tuxmake --runtime podman --target-arch riscv   --toolchain gcc-12 --kconfig allmodconfig
   tuxmake --runtime podman --target-arch sh      --toolchain gcc-11 --kconfig defconfig
   tuxmake --runtime podman --target-arch sparc   --toolchain gcc-11 --kconfig sparc64_defconfig


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

