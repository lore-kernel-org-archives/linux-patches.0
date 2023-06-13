Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1608F1361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:10:58 +0000 (UTC)
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-55dcb77d921so109482eaf.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697858; x=1689289858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGbbjXN/crvc59oMheelamvmeF6LUTy2pn88QOiGH8w=;
        b=LcT9ZFoqQsWDsjMQq00tcthHC3hGHT15aJmiOvTQfd81qF7dR2S9G+roEvMpyVASPc
         35ZlYyUbzSbT4Vw3P9Z3Mc7WJGzPRQtz1WZWOvoxm2ymAx6I8bN18K4hY//JcSsNFW5Z
         U2XWcBmbe6PmgV0+3w/EKla62syx84BC/vS4b+LrcmZ0JYwQZ7muRrVhHtcdtw8YlmRB
         Yz/mfyYP+XRFUO5scJOI5q+C2WbGdQQtDbVmQXzV9T4B0HHa6AsmwmQigPgRMwRwLAhx
         SxvrPToMda2TIqRbT5GOO+bw+/GXdGcTYoNZn/TEyj5gOLCZleUegfuAHFvn+8OouB0R
         ltiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697858; x=1689289858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGbbjXN/crvc59oMheelamvmeF6LUTy2pn88QOiGH8w=;
        b=WdbnghpR3dv/3NmizbyjIWjSLD7Z2Ek9+BbNeyhQCdvEwATyvuohG0zy2lE/8FZXiJ
         PD4PrKCdKA8Moq6cL4cfiQrtchTu+eWCP2sBwU00AW+9I9D4HaFwdLHRIPm1iBjxF/FS
         KrwE1C+HXS0eki3fSKvYr9wcGDxuYwnmCdUELw7pgBZl6KJ76MYJxfWjG/I+qNO35WON
         37kaStuTE1D+P6Ec+jPOLbA6GpzoADtxqEb1idkkSVgIGs6QiPqAJdo4ZdUVJtdOz8Eg
         gAXDymdrmAIyuJyvoJHrB60lPd3QxunJIlF5AO1ejaMPJiT3cqqur6Enl+dFLlWQ6t75
         SnnA==
X-Gm-Message-State: AC+VfDzlFx+8jaEfGWk8c8VaCDPTwtUiP0DEyQF2ZMaO0COF6Y7wyQZy
	aLlONo50elf7cPt8UZxISXs=
X-Google-Smtp-Source: ACHHUZ6vmk5nAB5OTM4ohimtJnmJRT52OmC+SYe2CrEewD9jQnkbUwfqb8D1bb9uWZaW579bD7IiWg==
X-Received: by 2002:a05:6359:29a:b0:129:c3a3:5efd with SMTP id ek26-20020a056359029a00b00129c3a35efdmr6807107rwb.24.1686697857811;
        Tue, 13 Jun 2023 16:10:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y9-20020a655a09000000b005287a0560c9sm9089916pgs.1.2023.06.13.16.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:10:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:10:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
Message-ID: <51551bd1-425a-45be-b3f1-76cd96761910@roeck-us.net>
References: <20230612101715.129581706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
