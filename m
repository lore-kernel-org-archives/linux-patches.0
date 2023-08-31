Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D113FEA
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 16:10:06 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7926de0478eso52921239f.0
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 09:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693498205; x=1694103005; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=41c/fNK1qQC2XK9KwuU0p8MqEE5Km30gP6fWHcjfMQo=;
        b=iMwa89qY7KnibEkl30nOdQjRyyRm6lf3Rc0rvEjtJjDqLX0DbkB0Jm/LbZX7cFYXDn
         3Q2nuEK2XJpYVphGhK1qip2uBtRqe+w66989lqRveMDRGrAaCftkpTsSkK+ApUTgO6Xw
         xUONXcOW5tvl5p/3rY2NCTI8Ttji2J92ZNkROZ7gnDfU1ptv5OUPTR+XBGTVxCQh5uiR
         iVMpWDUnXCVnO4tecN1VtF2FZpt+uf4r4Y8O9NZHGZ7C4O2GtWdnUpIih7Hq81KopjdH
         RfdrgxKc4fbQOwTQ5pufiq83JV0FwsBooQYe5srVA4drGAbv1cXAXHdgP+5/8TPM1gzj
         uw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693498205; x=1694103005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41c/fNK1qQC2XK9KwuU0p8MqEE5Km30gP6fWHcjfMQo=;
        b=CbyJlTePMO/7v0EinfJpVNZh2RT64AMqtMsLzEsMaDbVc21yBKNVEg5zEmRdIt+nkP
         JHVNP+VcyxMZemXvZymPa0uhNrsaDNLka1oebgUgkJUMenMmSNAkdFiQvGyR2MpobZIn
         DK/qDmVQ0mUFBTo+SWjc6U9qki37J+77FHnhyaTqOSlzW6RQafasZNCDR2wIA1SKecdP
         WDpb1jRZxxYJh4C6jmBY4f3gfC+DVhBFM/1BMpRb1/6yusp24su1gWMIx0CZcb2FVTXF
         8qFqcBX/krTXfqf6+e25E2KT7Saz75pfZTlNt3Lcq5NNuogRuoaB2754ypGV/Gk09XII
         1Cwg==
X-Gm-Message-State: AOJu0Ywur0BGg7e1iRJ+b5IYTqz2uvEYqm/V0/4I3f96QyGiNeMnKI6m
	d17TYPiiQjEr96tNWUEM+/w=
X-Google-Smtp-Source: AGHT+IGIk5fg7IzlO0S8uOjOP4VIcjkOGCNo8gyiNl5yp19xKSOvib6enwnc/oDThB57xVEIL0ilLA==
X-Received: by 2002:a05:6e02:f41:b0:348:b07e:fdac with SMTP id y1-20020a056e020f4100b00348b07efdacmr251422ilj.3.1693498205551;
        Thu, 31 Aug 2023 09:10:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f5-20020a056e0204c500b003489ccea184sm514510ils.10.2023.08.31.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 09:10:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 31 Aug 2023 09:10:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 0/1] 4.19.294-rc1 review
Message-ID: <fbefb0cd-e056-4504-b0b2-ebd778d4996f@roeck-us.net>
References: <20230831110828.433348914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110828.433348914@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:09:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.294 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h: No such file or directory
   12 | #include "platform.h"

"ARM: ep93xx: fix missing-prototype warnings" needs to be reverted in
v4.19.y as well.

Thanks,
Guenter
