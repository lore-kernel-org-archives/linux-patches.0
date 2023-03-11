Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A27B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 12:24:39 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso7912480wmb.0
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktDtq6F5mYK2om1OkmlupbObQARt7GGBfAckHwwPD5s=;
        b=SJmbpgMg1wWeZlpCieTj0YgVoj6N0l3ju7FpvmBybLKjaMMXTS+HFZDJIcGooFODJs
         WaE+YlV3Xd+3AucPMZ31HT6n2ImvFxaChorJEhb4ZfNE3Zw7Bx/MpwHXbSEW3c1IzECp
         qCZkW4tbof5nXEqko3jKaa1nhkY+k1RLgce5njC05FE9K5d4rcpQlyHHVHqic7JOdKEL
         O8zhLGO2zv7O618oBuDwtQPjZ07OU+ffmmAAwAI+T9yyEyPBVj11HG+U0c+SofnPCsdN
         E+V5E+++mhzjcZJSJE4JAcAyEhT1+UFsgLMB+b995XWkHzIWCgjFaxAY7HgpjUdE9WMj
         qBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktDtq6F5mYK2om1OkmlupbObQARt7GGBfAckHwwPD5s=;
        b=KiRJSSq/3Xjl+qa9PbPTBWKcf+i6VUGJotOtWmJwMqCnA1KTE07Krthw1LT952exdQ
         uFxj93FCE3c0vaFBP7yMgoCCUvxzPAPfMgwdZ0+qQ+Qwjv+KuRLGOehGOKC2GM7c+A3A
         KxmfpVyb60s2a3RQXRbWrzblohDkygjPZ1a84CXjRkeX6n6ecbqrNPEYeD4+YQOXpzN7
         yksWj6HI9eXoUTdw2Dp9qYQU/bkle21el0FUOMV81hmpQ/kL/gQsGgMu8STyLCM+h1Pe
         R3KGUBikt12PbGHl2ZowB91TAWNfTbtXYtVSy1yFzsjncBppx/MFR1V4rWU4hQqERtmY
         zyHQ==
X-Gm-Message-State: AO0yUKVa+c9kNnmY6AQYDreXLgaEGMC0JWy1JvTE6jcXuRpU8uJF5FU9
	OvCcxYyjHJbvj5yBu6Ym62Q=
X-Google-Smtp-Source: AK7set96yaiaJ5hySs218YQKWsYE12lJazGBg2QQx4xHtBYi2y4qn1VzdHW+JeV8PI88QTgVwJLjHA==
X-Received: by 2002:a05:600c:19cf:b0:3eb:3cc9:9f85 with SMTP id u15-20020a05600c19cf00b003eb3cc99f85mr5798593wmq.26.1678537477544;
        Sat, 11 Mar 2023 04:24:37 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d44d1000000b002c5691f13eesm2339151wrr.50.2023.03.11.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:24:37 -0800 (PST)
Date: Sat, 11 Mar 2023 12:24:35 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
Message-ID: <ZAxzAxJWBUDX1F4N@debian>
References: <20230310133733.973883071@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>

Hi Greg,

On Fri, Mar 10, 2023 at 02:34:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 65 configs -> 1 failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> failed
xtensa allmodconfig -> no failure

Note:
mips build failed with the error:

arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
   42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
      |                                            ^~
      |                                            )
arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
arch/mips/lasat/picvue_proc.c:87:27: error: 'pvc_display_tasklet' undeclared (first use in this function)
   87 |         tasklet_schedule(&pvc_display_tasklet);
      |                           ^~~~~~~~~~~~~~~~~~~
arch/mips/lasat/picvue_proc.c:87:27: note: each undeclared identifier is reported only once for each function it appears in
At top level:
arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
   33 | static void pvc_display(unsigned long data)
      |             ^~~~~~~~~~~


s390 build failed with:

drivers/s390/block/dasd_diag.c:658:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  658 |         .pe_handler = dasd_diag_pe_handler,
      |                       ^~~~~~~~~~~~~~~~~~~~
drivers/s390/block/dasd_diag.c:658:23: note: (near initialization for 'dasd_diag_discipline.pe_handler')

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/3081


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
