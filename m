Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE88F60
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 17:18:29 +0000 (UTC)
Received: by mail-oo1-f44.google.com with SMTP id z138-20020a4a4990000000b005175b8ae66cso552084ooa.6
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Sf5BOgBYoKexxio9oBRlmrzfjBVgiqa9tGRvXK5Y6M=;
        b=Jwv74C0IllnWgjEJgrRBHp8ZGd3of0X0grxtfUAn097Bu9LwwJdIlFMN0hIdOQnnIy
         HHDBbSwqbIiq4LwPrWMvXTXvmNDw+599LNsBWkDkM1hdr+kgmg4EG1HlpXe7it2fQ0NP
         TxEZy/GYsKSnnwpxRr0gUnpZpUreR4Pg0wT3Qsy+RLoQeY8P9C/0YtorPvAMjscMb17T
         ELsKsTBmfREQreBn4ycFfB8e3VvplcAMaeeEcnmuxPheLekmzXiU2u/HymbHZCaoG9NO
         3HGbUyWTwhdAoGF19sM4GlhvBGngixXoblyO+D+F7768/G2ZEB/NrcGZfW1cS7SWde9q
         zHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Sf5BOgBYoKexxio9oBRlmrzfjBVgiqa9tGRvXK5Y6M=;
        b=zywqAFiJdN+FDlZcUfGPSact6uQjVx1BJK+Zq9eRY8ebw6oDV1LAK+Z9X+5eCXnfvn
         KW/JyuBlATfVCq4x/5s6Kjcr44opQtErI/nN8myDVXS0rsCfKAXNPB6r26uTauz2xv4e
         eAbKFzzu7zjHA3Y0B88nq/56aAL3QRcmItsKvP3e9yTr9EjP4hIiReOi2AP6v3d+17i0
         SYGvSeoZT/6IzlXVaP3qrku/50xEvwEG8eGk/bh1qnrYiAdqkr5qCBVIBqFxIHOB6+Db
         i0OF2K2aERng7E0zQOcVzsJpKIMtYwg5ajLKI8lCK7UDOH79ZkyBH2pJoX9Z8kOc1/Sn
         BXmw==
X-Gm-Message-State: AO0yUKWpN68d9avIlKBCYiVYudbhacsonbm7/1MdweL4I0qzkjMc+ohE
	jEG8qzRMnCcjymK/HaxFn6U=
X-Google-Smtp-Source: AK7set8y04Am9bgTDpF230YHO4fZBC/NWwiYPgRaq5ZpmP+2o5Hvbb4VmgDrCNm1Cfb820nnSYw7OQ==
X-Received: by 2002:a4a:4194:0:b0:517:4b63:8e48 with SMTP id x142-20020a4a4194000000b005174b638e48mr5316841ooa.1.1675444708505;
        Fri, 03 Feb 2023 09:18:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v32-20020a4a9763000000b004f73632d096sm1198293ooi.6.2023.02.03.09.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:18:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 09:18:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230203171826.GA1500930@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y906Hz3UWYxoxYdD@kroah.com>

On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.231 release.
> > > There are 134 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building ia64:defconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > 
> > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> 
> Yup, it does!
> 
> Eric, any help with this?
> 

Adding "#include <linux/sched/task.h>" to the affected file would probably
be the easy fix. I did a quick check, and it works.

Note that the same problem is seen in v4.14.y and v4.19.y. Later
kernels don't have the problem.

Guenter

> thanks,
> 
> greg k-h
