Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1D881F
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:46:26 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-401b3ea0656so17292735e9.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693561585; x=1694166385; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJ5sMtYdIYKsrQCl5YLIcPHoNwIAIngA/Abzs2s406g=;
        b=Md2BxUevmdxcThrxMdJv5qeidZkwi08m6TkqEIUeQwcFqpAwoPae8B2Y+W4RA56DLh
         46VA2wZ0+vUy5MmY1bdVB+e4xkvKlU8aom+4ihRG3BMjP40FNGBHyoDqGsKmR456KgW8
         INcxf04Vd1J0bKZu7QO3Gn1jBHLJhk0W60diGqBDrhPy2+PVGEjMyfWZoYiSgIXRMQ86
         7S0FytE/dV6d/+0zhRu7EZBQcOz9vJNIcNiQTAe8b4q9sTBEnmpGFL+QAdBo0ecidxcX
         TGz0YIRreCw85HXUjYg/aVR/bFSFv1y540Pt0S7wAoGRvp5q99K/Tp/XEpfsj1aP7JOg
         6AsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693561585; x=1694166385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ5sMtYdIYKsrQCl5YLIcPHoNwIAIngA/Abzs2s406g=;
        b=DDIJ7Udu5pe3Ls9FGHTUcXPLZBERxLCTfP/4AsT245Pkkf7eIm/sQDswVbSRY+pXw7
         euSClwk1wqrX4sHuUWEFSD4ESX56WHBlz+L7uiUw/JrQNSo9A4R0Wv7HiGvhv3K0+jpl
         p3lFmOyYXcqt1uO2pl4NHDv9p8zW7P7u4Uceznt2Qiv1Ohyb9OkC9vVLmxGdZWukO7IC
         9Ejd2ncRM/tGUwZ/03MZ5675KxMRqDfYmsro8MqF7NkmYHnK5dxo+WOLX+e34lDYD/Ax
         5OZgV1ecusMpfQGq1x4XWib4UvehjihBlSQYcOEmJU3T5u+yPh9c2Lflmic9ZdnX4Nlb
         8Vxw==
X-Gm-Message-State: AOJu0YxS69/EotZE+vtrqqyquiurOW5BTXCcowsmh+U/WYr4+LBrcidu
	5nSovc+GvlTSLyHnj0rYVtc=
X-Google-Smtp-Source: AGHT+IHeoEJza6WtyVE6WqFbM2nV6YWS4NSrpRVXvTFAGVosHG/sdf1zh2jYjGV/fjbQSxeC67kTfg==
X-Received: by 2002:a7b:ce88:0:b0:401:b204:3b98 with SMTP id q8-20020a7bce88000000b00401b2043b98mr1323127wmj.19.1693561584581;
        Fri, 01 Sep 2023 02:46:24 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y11-20020a05600c20cb00b003fc02e8ea68sm7439143wmm.13.2023.09.01.02.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:46:24 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:46:22 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Message-ID: <ZPGy7iBF+avgfn6Z@debian>
References: <20230831111127.667900990@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 01:11:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:11:18 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230829):
mips: 52 configs -> no failure
arm: 70 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/4891
[2]. https://openqa.qa.codethink.co.uk/tests/4895
[3]. https://openqa.qa.codethink.co.uk/tests/4894

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
