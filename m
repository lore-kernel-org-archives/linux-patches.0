Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B36FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:22:15 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id bk15so2455492wrb.13
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSgf6jiYcfVtPWJQMVHTmOxF85M+YtjytNm5UST5O0k=;
        b=izbaHHxtCFkvePT07BD1qfeuZBIWMdSM+hGVg49RzP/uKs+dO61RU5yF15Tg80cJoq
         gaRYbkyeksP+CTqljNIUQ0b6AgBz92SuOMvC9RcHexPmGB+G9BDCy28SF/16XYIvUTjq
         46UPaoUy4I8cpxmn/a5bk7+7IPvMgFQxUZOvIaX6BV4eGUsUbHKOb7MpLaBHuRFCx7O7
         PTST+o5fKhtQZSgkTBqmGt8PlhMlJXbUCM3BwLoeu/8MunSi+4yO8K89IToJ6uvlhajS
         6N9qAe2PRBx9xkrBYYwknkRCHm95OJpq9bIEvl8o+8uSabL2d44JDmYSooqWV70imV0e
         xm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSgf6jiYcfVtPWJQMVHTmOxF85M+YtjytNm5UST5O0k=;
        b=pGFLqJ/Cnb3KUNMG5qr9xnEY8eTpFQUWkyVMJl2P1F4l4UVPIImEjBvOM8eMybzvit
         QqCUrPlNhAj5ICQ/mrL1Vu8oitO9joJbj+gxKxBZ8aPL41Mz1sBIOeqddSAdQXMU7o0+
         /QvoLFr6g2hxfyUlogHqrOW+V8lqXk1j60qEqDjKj6np/h4zxibmdB+QWRi3JK4TT0CA
         B2AiPc3s0bwYON9Yhb1nEkBkhzkEZPSsfz4rG/u21/igRVKV13jjx4KD5ISS59Sopbni
         SyGFtRwXD3CmYhhramfVWVcSzTQAUFg/B552dOPyTudqFj7iENRqgoEjKpZyvb4GVItY
         Eugw==
X-Gm-Message-State: ACrzQf1XCTDRDQmaNUbL1x671Z4wEmQ8Vvh27Y4+XSlVFFugXKE0sskq
	roZ1Z2dN1J5EamSlyeernII=
X-Google-Smtp-Source: AMsMyM6fUf6Ip8ggD+ZWUZAq2zpubt3x556zczWNAjLLXW0IGOAdHI5bI99XkXh1Q+13mLb6xGThUQ==
X-Received: by 2002:adf:e6ce:0:b0:236:76a2:fc80 with SMTP id y14-20020adfe6ce000000b0023676a2fc80mr18647287wrm.163.1667478134068;
        Thu, 03 Nov 2022 05:22:14 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id ay5-20020a5d6f05000000b0022e57e66824sm966032wrb.99.2022.11.03.05.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:22:13 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:22:12 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/78] 4.19.264-rc1 review
Message-ID: <Y2OydDkyWRIWMu+t@debian>
References: <20221102022052.895556444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>

Hi Greg,

On Wed, Nov 02, 2022 at 03:33:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.264 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2086


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
