Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51164125CA
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIod6esv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46726C433C8;
	Tue, 24 Oct 2023 08:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698136122;
	bh=o/bhBD7x66xOviqK2rso+3X+laO9UIhD9yITFlGEQZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIod6esvAdneOu4+xyrt1MZ8kt/YfXrZcb00FWPQ4UAUDQ4aXSkb+zkB+QHBrjFIh
	 +csukHiO0UhZH/Pak7TAEXqyrR/NcvasDfAiWmdsFXokhaqo5XZqtSaZGObneIQa7I
	 HXp+lIZ213h71x662bq9BV0yBT5sgU+kpJONg+yc=
Date: Tue, 24 Oct 2023 10:28:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/123] 5.4.259-rc1 review
Message-ID: <2023102434-dreamless-parting-35ed@gregkh>
References: <20231023104817.691299567@linuxfoundation.org>
 <eb759f41-db11-4f2e-b3a0-e9e92dea3196@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb759f41-db11-4f2e-b3a0-e9e92dea3196@linaro.org>

On Mon, Oct 23, 2023 at 09:53:08AM -0600, Daniel Díaz wrote:
> Same problems on Arm 32-bits as with 5.10 and 5.15:
> 
> -----8<-----
> /builds/linux/drivers/gpio/gpio-vf610.c:249:11: error: use of undeclared identifier 'IRQCHIP_IMMUTABLE'
>   249 |         .flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
>       |                  ^
> /builds/linux/drivers/gpio/gpio-vf610.c:250:6: error: use of undeclared identifier 'IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND'
>   250 |                         | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND,
>       |                           ^
> /builds/linux/drivers/gpio/gpio-vf610.c:251:2: error: use of undeclared identifier 'GPIOCHIP_IRQ_RESOURCE_HELPERS'
>   251 |         GPIOCHIP_IRQ_RESOURCE_HELPERS,
>       |         ^
> /builds/linux/drivers/gpio/gpio-vf610.c:340:2: error: implicit declaration of function 'gpio_irq_chip_set_chip' [-Werror,-Wimplicit-function-declaration]
>   340 |         gpio_irq_chip_set_chip(girq, &vf610_irqchip);
>       |         ^
> 4 errors generated.
> make[3]: *** [/builds/linux/scripts/Makefile.build:262: drivers/gpio/gpio-vf610.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [/builds/linux/scripts/Makefile.build:497: drivers/gpio] Error 2

Now fixed up, thanks.


> /builds/linux/drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
>   363 |          */     mutex_lock(&dev->struct_mutex);
>       |                 ^
> /builds/linux/drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
>   357 |         if (!drm_core_check_feature(dev, DRIVER_LEGACY))
>       |         ^
> 1 warning generated.
> ----->8-----

This can't be a new warning as no patches in this -rc touch this file,
right?

thanks,

greg k-h
