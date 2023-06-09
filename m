Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D9A377
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 11:07:01 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-25676b4fb78so486904a91.2
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 04:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686308820; x=1688900820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p9Kp49qcxB2W/Gx/r6msDIk3UxITI3+DTECoDc55ia0=;
        b=XH0RYKJglDJSo+LUgfbk7Lirkr5mNmGpbJX1n0pLDknKqm0t5b873l5/KlTaoaDD5y
         d7QYPMTJvEZN9IoD0Nj7b+mIw3Ag29u0gelrFQVdzqRAc9tykFS0an2cmFc8X4PkH+CU
         uiNTqcwQ2clV+eatSPfSSNwZLIKXa8kvG9HhGITNWD2mmC08LhPpLtXhguktlHsMyHbo
         u8od/c5kD8b4nsnDQDmuzCoaP6tjPLBY553qCG04qlb4g5W9SxKw+sfbsArLu+UIi8Id
         X8COKAxOl4IhNPZngfbh/mNH4JZ5UYrX6v2VmNH73jfCkjXJeTGqUrbHCUPxYFP6hI95
         0IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308820; x=1688900820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9Kp49qcxB2W/Gx/r6msDIk3UxITI3+DTECoDc55ia0=;
        b=hnvK3y57No026wy1Ezqv+fYiRImugT9FEsM42yqqS9EkXKJSaCtqRIJDEI5F0B39R0
         GVyZo1bhkx0+U+J/0SKKZJREXjx55aepbo2ajHw1Qc71oFVvvNdcxVS/r2umoAddikei
         4dJsiOcKjLHxyEoAdLthTGTlQ4Io//U443Ddu2+FnEnp9bVhPJw6OP4EawjTHNYfgEYG
         w7CfFGGhlceOmMlN47dXYBCWUFd4xvRmE+ob0moVejVTCqq/X0GFZztP6ybnN/PoGNql
         ma468dX98YRcJqmQ4ls2IVforaXGz7QlyAOs1lyTsQYZnwrd5fF392MTHEqpGO95NvoP
         1Lgw==
X-Gm-Message-State: AC+VfDz6l8Ng6AGY4+4tWKY+Y+eMpValVDJ9DPW+MPAenMQLPTUws1qq
	9hnaRCxgZIVqVsGX9uv8MPfCdAgQfzo=
X-Google-Smtp-Source: ACHHUZ69iuycrMPAsL6r820Mk8A8KabO+WlKUAKOfAWMN+/OE9BN5aN5Lh0/htRWag2WEwxd0cl8UQ==
X-Received: by 2002:a17:90a:1908:b0:256:9b75:84cf with SMTP id 8-20020a17090a190800b002569b7584cfmr703254pjg.6.1686308820385;
        Fri, 09 Jun 2023 04:07:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a194300b00253305f36c4sm4785820pjh.18.2023.06.09.04.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 04:06:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 9 Jun 2023 04:06:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
References: <20230607200903.652580797@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:15:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 498 fail: 1
Failed tests:
	arm:kudo-bmc:multi_v7_defconfig:npcm:usb0.1:nuvoton-npcm730-kudo:rootfs

The test failure is spurious and not new. I observe it randomly on
multi_v7_defconfig builds, primarily on npcm platforms. There is no error
message, just a stalled boot. I have been trying to bisect for a while,
but I have not been successful so far. No immediate concern; I just wanted
to mention it in case someone else hits the same or a similar problem.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
