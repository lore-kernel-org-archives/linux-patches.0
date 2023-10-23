Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154481B27C
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbLD21up"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-d9b0f27dea5so2881276276.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 07:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698071789; x=1698676589; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CJ0t+v02CjwjkswDCmDeSY6rN5hL3pFQ5QlA90jP6kY=;
        b=RbLD21upcgrKhmVbO1gxKKRPh60Fm52zb31LzJjxKrxGCbA9xofo0AVLZE8S13fZmj
         3hDKJO5hx/YvrQ0KFCqs5Ipiaba76++JjgO+AJYrbWIHRsBT3OhpW8wtDCpy/PNADii8
         7GXFJktMDPNfme7zf/FxmZuL0dUO18O/l7WsY+HMGl3gWH3qvtv2lrELRWVqSW0h33ue
         v7+eSJg1PFC66TtAe2Uf5Mb7R5gNiAuui9Xhu7KRV0UTuM4UqGBpklTJde3PUgxRAtL+
         7qv1EJ2Me9Y+0f0oO9sKq74cSgBq99E6ni516PEOBfCpF44BMh9kxborgKqTBAv/SwfB
         iabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698071789; x=1698676589;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJ0t+v02CjwjkswDCmDeSY6rN5hL3pFQ5QlA90jP6kY=;
        b=rvBieFJAwDUyjdSCnpssGEjaGdI0n90BiwdWvJq1jnM6cTK733DXs5288XPohGouCV
         Euq9RRhRa59iGd9AfF/X2j4Fh2nx9ATXicIpL6BNsZhadzEb9XMlW2sSvwtxo+bWm3MF
         yDUn630NrsZvQ6iUX8VZY8Ne3Fg/Rm9xrzUnBunfZfANliUG0mVPW8m1ytzLYEJbS6Iq
         spD8Hzh2mVQ643qO5vzOEKNjf2vDzwLnWA/uUzZoIXSNC20uHAcyHHTGasUpQCq65nmh
         /H3rlLa5lQK6gUMmkfOBOslfGvYJ8djz+G6V/RD2PRytB9DqN8EU2VBD10rZV62j0FHM
         rvNQ==
X-Gm-Message-State: AOJu0YyAzsaH2fZs+q7fcDInUrCFzUOiDFsHlXXu9c//I4NdUkcdCdX2
	dR0Dq3CSjd1sKRb+QmFg6Uw=
X-Google-Smtp-Source: AGHT+IH9MpOOovN5WmRxQq7B0erFLUXyrlNO8AFUEAU0ZSw6It/yUdsSd6EwhA77lIBmadu98p3EgA==
X-Received: by 2002:a25:7756:0:b0:d9a:d894:7b51 with SMTP id s83-20020a257756000000b00d9ad8947b51mr10286089ybc.57.1698071788862;
        Mon, 23 Oct 2023 07:36:28 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u5-20020a250945000000b00d7465a90f0csm2722816ybm.22.2023.10.23.07.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 07:36:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5bd191c3-a58a-e6b4-12a6-64efb9b03f2e@roeck-us.net>
Date: Mon, 23 Oct 2023 07:36:25 -0700
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
References: <20231023104817.691299567@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.4 000/123] 5.4.259-rc1 review
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 

drivers/gpio/gpio-vf610.c:249:18: error: 'IRQCHIP_IMMUTABLE' undeclared here (not in a function); did you mean 'IS_IMMUTABLE'?
   249 |         .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
       |                  ^~~~~~~~~~~~~~~~~
       |                  IS_IMMUTABLE
drivers/gpio/gpio-vf610.c:250:27: error: 'IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND' undeclared here (not in a function); did you mean 'IRQCHIP_MASK_ON_SUSPEND'?
   250 |                         | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND,
       |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                           IRQCHIP_MASK_ON_SUSPEND
drivers/gpio/gpio-vf610.c:251:9: error: 'GPIOCHIP_IRQ_RESOURCE_HELPERS' undeclared here (not in a function)
   251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpio/gpio-vf610.c:251:9: warning: excess elements in struct initializer
drivers/gpio/gpio-vf610.c:251:9: note: (near initialization for 'vf610_irqchip')
drivers/gpio/gpio-vf610.c: In function 'vf610_gpio_probe':
drivers/gpio/gpio-vf610.c:340:9: error: implicit declaration of function 'gpio_irq_chip_set_chip'

Also affects v5.10.y and v5.15.y.

Guenter

