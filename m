Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A7DC977
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:15:10 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-247399d518dso73642a91.0
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 12:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681931710; x=1684523710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syjt/k5qWCL0P1uU40/xSeDGborcvz1X6BHF/A89cyg=;
        b=kPMQUtmFLHdC2pdMOcVVsQ0V7XB3dMzz7FXFM/yyb8l1HL2dHL0nvw9b2sHt/fut0D
         wMxhR3huLcaEnZxK9DDSE03hgftGsIjbh+x4PPJWOa4lVacSA6d0ygDVuxRPaOPZW1yX
         WadUdRHqAPm+UHZKInPvbPPWjc9gGuJCOOr6//t2tPIBR8mOu09vRBxjaBaLvn0vEEjo
         AmLCAjlNYxEPqTRcUsiQh1A/Ro8o1rnjijS/9LzlNsWFBdz1/toVJILrkERfszXAIMem
         dUmvb765Uwj1zNa6vL6wRvUF0Pelm2w6SzMQvRUm+KXKS1EORJOlfcCwcxertjFWTwZT
         9wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681931710; x=1684523710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=syjt/k5qWCL0P1uU40/xSeDGborcvz1X6BHF/A89cyg=;
        b=Y3ZY2lHOWtuogdjWLFHcARvFBr6d7yVOb78Ecg74zJRJaVEgg0a7ip/YbQ68kvAeBt
         c86KExvdg3gQL/38YpyifTzrIEN9tgszlwehgaCNHoqaC2Um4CJJSmKAoJSDd/S7GFXt
         BpwbjnQx9Cgj7P5EyBQBjvEPT8sZ1PkuBHy8DK5zRtNvIb6AMxXGiiXUEZuAYRxgCiP/
         AB9aagYA/3PEDCOhQ+sAX4yDiuGJTA01vjx6lLb7Vrd/ZggreD35b5Oc14IVDxbQDjRr
         h1GQeP64Y9Iuqtegqr7gHGqPAbjomrQpNAUaFtMCoXUBiau7tuQA7LMN7ytek9eVVPLh
         j3Fg==
X-Gm-Message-State: AAQBX9cP3wYm7h9YmSVG5enSSNTsPrAywj6K60VSVPhMH5GNHa7uZtL1
	uKaDFX4HOlklGWCGvcXG5Qk=
X-Google-Smtp-Source: AKy350YCbkg1urE+MYLiNEms0yNX5L4R7TIBO4SeLs6NihVS+L97frK/A/rQVyVkalZJGnCJ9cJI2A==
X-Received: by 2002:a17:90a:1f86:b0:247:5273:dac1 with SMTP id x6-20020a17090a1f8600b002475273dac1mr4265068pja.12.1681931710038;
        Wed, 19 Apr 2023 12:15:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ga14-20020a17090b038e00b00247abbb157fsm1745502pjb.31.2023.04.19.12.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:15:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 19 Apr 2023 12:15:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/120] 5.10.178-rc2 review
Message-ID: <bfe2e9c1-95d0-4dfb-97be-d15a7fc03d13@roeck-us.net>
References: <20230419072207.996418578@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419072207.996418578@linuxfoundation.org>

On Wed, Apr 19, 2023 at 09:23:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 07:21:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
