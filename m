Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5031B7461
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fieEjJUc"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40859dee28cso23061395e9.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137785; x=1698742585; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=miTVCU04yyCrzOSAI9EkRMIhzdyP2FapJh++0rrQ6Wg=;
        b=fieEjJUccjF4xzpHDBFTV4OPqLX3xiIRh/P02AgSWSERndXLSQ8WkjlNjFhzwNDEuZ
         bKloI896bshJ1wHgNhPeUBXkbrE49pfyzExiQIgZL3JXQirpxnP+i3jhrouZK7GqDI+A
         IJWPWVrR1wFE1xQ4EwMx/wSXdX0Klz2Tn6foLEVLdjLCW94ipk76lU+jwDF1+fsiVOLa
         zDiVdmZIkDeJvOf4vQkEywKm9G8SlqPPU91nUTKPcifW9aTAzkm0nAFGFKkxsl0xHnjJ
         YyZIRDonX2Gt62M30EXZXVIOh1vMF0KZPVWm2a712cbd2+KDkYHh2WjvJZUf0+x+VcKV
         IEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137785; x=1698742585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miTVCU04yyCrzOSAI9EkRMIhzdyP2FapJh++0rrQ6Wg=;
        b=ipLiqBSrBOcAMcoosOBnF3oEmk6nEY0LMz4gj6kR2qISjmffDwFggykV2+q/MwyM7K
         AsToPOD+L1LPdE+NAQzzn19k6httPkps+j6lRpy1dySRm6dC6GQBU6Y6PEe4gT6uc+uO
         GIgl6P3lQL20/mkUaekj61ItALD8ymQo3fnsWAqFbLMJ7ImC9HLwkq/uBBWzF1eoqxlo
         a47KsjEblE/4ZI6FMGuUdFSmQA64U1tHEqc39Yh82ktqrJcot2WRVzfRpXoOsp0KcwwP
         FGG1hx0a8ALcgZ2X93ZkLPpdZ9wlQ4K65itj8UlIHrTMdLBmr+jqUIpcCZ4+uaEzPch8
         +Sug==
X-Gm-Message-State: AOJu0YxRN6ASPtJdSMzBkMcXcZWz7eOqom5Baba/+1bShXwt9e8uwwXS
	8xvYAqhV/Fsx3TFPhE3DGp8=
X-Google-Smtp-Source: AGHT+IGetQYjoPclj/kmbwPywiuFWtEc2VzhJ8b2Vn9XlycBsIp3g0AHLZEG3uwg270sYu4L4jCDRw==
X-Received: by 2002:a05:600c:1c97:b0:401:d803:6243 with SMTP id k23-20020a05600c1c9700b00401d8036243mr8983012wms.32.1698137785245;
        Tue, 24 Oct 2023 01:56:25 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id o27-20020a05600c511b00b004067e905f44sm11655034wms.9.2023.10.24.01.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:56:25 -0700 (PDT)
Date: Tue, 24 Oct 2023 09:56:23 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/123] 5.4.259-rc1 review
Message-ID: <ZTeGtz7cTimKctug@debian>
References: <20231023104817.691299567@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>

Hi Greg,

On Mon, Oct 23, 2023 at 12:55:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230511):
mips: 65 configs -> no failure
arm: 106 configs -> failed
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
arm builds are failing with the error:
drivers/gpio/gpio-vf610.c:251:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
  251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-vf610.c:251:9: warning: excess elements in struct initializer
drivers/gpio/gpio-vf610.c:251:9: note: (near initialization for 'vf610_irqchip')
drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
drivers/gpio/gpio-vf610.c:340:9: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror=implicit-function-declaration]
  340 |         gpio_irq_chip_set_chip(girq, &vf610_irqchip);
      |         ^~~~~~~~~~~~~~~~~~~~~~

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/5353


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
