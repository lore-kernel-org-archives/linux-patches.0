Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F341C02
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 09:36:31 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-401da71b7c5so22835695e9.2
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 02:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693906589; x=1694511389; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YN74zXxSunmC1J1XCmYDd1Mc9iKNJ+pIChJ9we9c978=;
        b=O8vDMmirvXenGrQl4HJ3J9r88Lv6URBo7TZWXl9dj2fy3FVBC4hXnbMbrGo9WALGsM
         N74jN34VdlNeSCZPcr+Jl7cBuvM2tLAtm0v1OJKw4GdSvgzrTpdr/QkM5RdL8VMgudN1
         /OIcWtf1P4YsOJAkI/+Bc2cGtxP4c6Mw/LtSQjDob2Wd8vMu03Vy/yjE/F4dusmPIpbO
         DxcG5xx22G0ypyu37I8jbS6W3BQHp+3PFyMRqQupN0n5cbiafZXgmJEaivjJ1HCqXXfv
         ys2I8bGmLbe2b+Fm+v+a4ZwqIaIjc2qIcLic3YWZpFIUUkJ8z8F1Aw91NNlt9foqYB7s
         lUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693906589; x=1694511389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YN74zXxSunmC1J1XCmYDd1Mc9iKNJ+pIChJ9we9c978=;
        b=Pdoug2A2MzUwXyrjV2CHyJMzEtnsur44jVB77WilodODpymgp0NcMl6rbDTxoDDvdW
         fPap19nCxrNXUoaJLeBwNGYvxmgSqrLlofNu8VFdKrHH5OabJxPHuO1/pLGtIz4VEod0
         oLVuTfxe+ew9TEIqcsx9hLgfnAsjxmBn36UOyv7e7EfgDexK+8UFDttZ4Byv0/gKgVaN
         OQ0i2cAdNuxKbV5z1t6STaq1+75SoEY7gIjimVhyOrW0HhMzyYbqdj4AwmQF+UMxOWVL
         tWUS98/icAiAAZG3i4RQfXHMAD0zxBvSRkO00RdSM1wVErx+CNp/1ThOow1HxOb4ww1F
         dsrw==
X-Gm-Message-State: AOJu0Ywvb90zu7uxdEiVByE8Y2krWQnOziRWk/zEcR5B529zt8uT/TMz
	a3Yo+KkvrTJsCYpq1LzkTMU=
X-Google-Smtp-Source: AGHT+IEX3lGhBHiQY6i51kVXIPsNIJpgoOagjFoCu+G51Cy78QGjFeHnRZ+SJcKliEm3g4SK0jGHCQ==
X-Received: by 2002:a05:600c:28c:b0:401:db0b:48dc with SMTP id 12-20020a05600c028c00b00401db0b48dcmr9500781wmk.37.1693906589310;
        Tue, 05 Sep 2023 02:36:29 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id e10-20020a05600c438a00b00402d34ea099sm2614344wmn.29.2023.09.05.02.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 02:36:28 -0700 (PDT)
Date: Tue, 5 Sep 2023 10:36:27 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
Message-ID: <ZPb2m6bxirMCA2cf@debian>
References: <20230904182945.178705038@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>

Hi Greg,

On Mon, Sep 04, 2023 at 07:30:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.131 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.3.1 20230829):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4932
[2]. https://openqa.qa.codethink.co.uk/tests/4950
[3]. https://openqa.qa.codethink.co.uk/tests/4949

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
