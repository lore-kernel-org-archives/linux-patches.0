Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5B199B9
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 16:14:44 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-79f8b2bfb2cso22954639f.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 09:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695312884; x=1695917684; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jrawzLTr2iedIiVQVMU2FN2MVVtTCN9TYNgtIQ11vvc=;
        b=AtYDIeR/p5wcocQVTl9S7fZWDxfvfraIvfZoUyTqPtZwuMcyZrbKuYlP1cUYwR/Qow
         1LrGRp542uG8jlC/HYnWnz6svVQv2RZknIWXt2HYDmBfPHH+NYrIC4MsCbHR6nIDU97o
         3IgyR8GpaIj4cLIjPasW4/AufXWY1yvNC8GsIoRVaw8MDSmBOIhxj2Jj6td7Xkdz4lGK
         qGEuwSsH1HHSrlr4WD2jQn5cWcdXLcKKx2KES+S2Li+JZB5u7o21N11oSC/NaCLHuW/V
         O+XyhTkv1TpTIBas3TCdTKh/s1USB6wR9m9ibnPM8jghrlkdtpzeVzkHRoQvlVLApCom
         KcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695312884; x=1695917684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrawzLTr2iedIiVQVMU2FN2MVVtTCN9TYNgtIQ11vvc=;
        b=Sf1KwbIzOuqxQsF8x/qRfemO7cNsHnB9oVDQcxTxqEorR3zF2HiAdwGGjsnPGtyIlA
         0JyWVZZ3Q2S4vC/+4mWs91codKGDUQf0ndmQfVS9z+5uelWvNC5RzukHWxqOhZUAeY3N
         07mJjQhA7rb9gk7ON8vYozToEX9Q67EsWc8/9FvyuNUSsKYHjiIYPxY6t2GjzWWDg44P
         FfEnY1X89UEpQQjZDvm/UaMGYaLZkvKaIF87t0jiuMDOLURQ193rJhcJ3G9Wucs+5Vs4
         neAophEdbRGZofGKim0UmoBF5sMpoILc2NRmJX/pQHeX3vmo0JeVGluGjXMwY87AdEQn
         oMUw==
X-Gm-Message-State: AOJu0Yx2PN/dDqgy7i8spqdYrsOL3Njkg45PKF9LW854ixJ57EvktiRt
	2n+F6qaiAriu4XPzP95x3vR7dk4BHjs=
X-Google-Smtp-Source: AGHT+IGPpmxjWfaXq0c6bI7Mft6n53Xh+KMLL5prPGbYlR2vVDTIDw6iOS89hs4+8Uw4U1p0icd3zA==
X-Received: by 2002:a5e:834c:0:b0:780:d031:bc42 with SMTP id y12-20020a5e834c000000b00780d031bc42mr6402829iom.16.1695312883880;
        Thu, 21 Sep 2023 09:14:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t23-20020a02c497000000b0042b10d42c90sm419890jam.113.2023.09.21.09.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 09:14:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 09:14:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Message-ID: <5b6e4c12-28c4-4026-a68b-937d750a059b@roeck-us.net>
References: <20230920112845.859868994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:27:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Note that there is a new lockdep warning, inherited from mainline.

[   11.144387] INFO: trying to register non-static key.
[   11.144483] The code is fine but needs lockdep annotation, or maybe
[   11.144568] you didn't initialize this object before use?
[   11.144640] turning off the locking correctness validator.
[   11.144845] CPU: 2 PID: 688 Comm: ip Tainted: G                 N 6.6.0-rc2 #1
[   11.144956] Hardware name: Allwinner sun8i Family
[   11.145137]  unwind_backtrace from show_stack+0x10/0x14
[   11.145610]  show_stack from dump_stack_lvl+0x68/0x90
[   11.145692]  dump_stack_lvl from register_lock_class+0x99c/0x9b0
[   11.145779]  register_lock_class from __lock_acquire+0x6c/0x2244
[   11.145861]  __lock_acquire from lock_acquire+0x11c/0x368
[   11.145938]  lock_acquire from stmmac_get_stats64+0x350/0x374
[   11.146021]  stmmac_get_stats64 from dev_get_stats+0x3c/0x160
...

I didn't bisect, but it looks like it was introduced by commit a828c9b08531
("net: stmmac: use per-queue 64 bit statistics where necessary").

Guenter
