Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35450C2EE
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:46:32 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-312824aa384so314257f8f.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 03:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687257991; x=1689849991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U3Pe3mydueWhf/EywBBfkVfhRK27666VDF44tjUu2/Q=;
        b=SdaMIDLqdPJh8Vec5iSw5088pyHl35AsClNybTdZWBxVa2jdc5Y4/cR+190TLISoUe
         Lu0X92/tMfZowY2Xf8/BvrESQuAjT7S17R1hJ+vFBFTO8H6YHcUPKpvHTns3r98jWnj/
         EtGEglTa0WyzxUPDMAWKrIZs3QJM8Mtl5IG2JdyvA0kOKMd9RzIkxYv53fojeIlT6YMW
         WHpDSo8HWuklNb63H6REpawGdNJTELHljMkT9XHK+BeIhzYw2ZNR3BgmJxyWtk9xowG3
         AW6/mLCEgS5U/XCHRL7TjUPPWwXaYitbiupxO4tKtlvCgM5FxSaaZy8X+Gl0CuFzExBW
         m48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687257991; x=1689849991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3Pe3mydueWhf/EywBBfkVfhRK27666VDF44tjUu2/Q=;
        b=TUzhH4I8sIMaMYgeGgkM9ntGRevb29OB4zYCeFmB2R2tliMOepg9Kr9RuzWk97DNmL
         G3oOcvVezp41UI29f4XNn4iYfuuz6/YznL0zQNdu2DNG7+Ucu/9xdQzrgSglnlfZUp8b
         a5KJWshxh11QX3Slskdo2RgMgpfslmgN/IdliP4VbQDt3MYiJpR9/ApO8ufUyh6ioCR1
         rlFsJfv3fZvbBVA7qajgKp5OmsMx52MTzxnXDNbe3cjEdiCneF4nKRwSTjqgomZiI0y2
         w0QFfLhiHDlhudbQ40p8glQDc6Wel6c3hYm3rljJeB6nrkPT50qVNd2r/A2C6brFxNvB
         Gp6w==
X-Gm-Message-State: AC+VfDwE48gOl4Jgtk9hKEN85UYUt23Piha+ZYfWRTJLr/nDuMpFcHUb
	JtULp8+hMZJk25TAtP1trF4=
X-Google-Smtp-Source: ACHHUZ6J8aXfN+SopC1GpwsGgSPJ9huSWBkuml1Tpr+XaxNE+yHkG03hLO0SuFduqh4BLvgCys8+eQ==
X-Received: by 2002:adf:f392:0:b0:312:74a9:8262 with SMTP id m18-20020adff392000000b0031274a98262mr2880447wro.62.1687257991079;
        Tue, 20 Jun 2023 03:46:31 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id n11-20020a5d4c4b000000b003113ccbf388sm1744620wrt.13.2023.06.20.03.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:46:30 -0700 (PDT)
Date: Tue, 20 Jun 2023 11:46:29 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/49] 4.19.287-rc1 review
Message-ID: <ZJGDhS1ZR6Zgw5tD@debian>
References: <20230619102129.856988902@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>

Hi Greg,

On Mon, Jun 19, 2023 at 12:29:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.287 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
mips: 63 configs -> 3  failures
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:

mips db1xxx_defconfig, gpr_defconfig and mtx1_defconfig failed to build with:

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory
   33 | #include <linux/dma-map-ops.h> /* for dma_default_coherent */
      |          ^~~~~~~~~~~~~~~~~~~~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4064


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
