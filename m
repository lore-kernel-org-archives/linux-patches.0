Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A041D3FED
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 09:41:13 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-31c6d17aec4so1911297f8f.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693906871; x=1694511671; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QgJx92vjXTkTpttBpTwFSL3+GPVEdvVno8ObySBYzAw=;
        b=TEoLwkrDJtpy42YfuHkNTFHnwD3LZslP9FOIfnx+FUhu8Lr+D/y9hkxT/fcmE+6DqA
         dQAekXZsXZLs+mCh0sKZy+HTNIwIYP+Xf7fgfb7XZJJkspPxIUBsTSE29piyF9NgY43o
         iiv1+7nmqKxBY2/DLKWL6I2Huo+0NUyVHnyNFdQxGn7cjenh0N3Ap5UTDc2sOeCdn5qG
         jM4Dnb5erjQKQHfN63Lzp+vjq+CHSrQ9UnvcHOCZoO7D39+Pbe6A4hO/oLUw0LOVh8q+
         OCXYZCftpZZLLeh/ccNkzo2ZDwCXATUxLUx1ElotisUy/muZ782VZzQHRNo70l+ndE4p
         Ervg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693906871; x=1694511671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgJx92vjXTkTpttBpTwFSL3+GPVEdvVno8ObySBYzAw=;
        b=kimMS+VY0VAY+B12VVkMcoZIPMUCSyPtuvDF62E6FhJaNiJ6nYyO8B27RZ1yVjbon8
         qZmYFyhG1DgoAPrnNZS82jE7HRBzPRKSDwp/Saq6GLx0Hk6X6ovq1Em6lXUnYUYa9Kkh
         Ts+uqaMEk++6ACeK2R2llsTpLUjm+SOJErLsYAcDDBA58J4+fzoRZOVg6rIHcnTrOA2Q
         kMqcIjyb5+wtF0X2esfrFi00g9OuBgNwTwAZBZGLgMNfF28oCCO5dq+eRzhwxqOYUGdu
         4Iwog08px+sxPwETbivI4FhacaJ12Pd/c5/lLlL9dX6AqaGOgkaS5HP5/sZi4tZXz0LX
         9GOg==
X-Gm-Message-State: AOJu0YxjZ1rSHdBQ27spXVagwmQQJWO97jd3sek0vjslcr9WnW3Axsos
	p66HtA9VJ4CBEQFFHlsLuXhQ535NeKs=
X-Google-Smtp-Source: AGHT+IGoWSR2aqZbmIZ7hgg8jVBiWpsSfPlwPPGJaYvM/yrDW64biTEHWOw+vteZXDnVn1ma2BPxaQ==
X-Received: by 2002:adf:ff8f:0:b0:314:1ca4:dbd9 with SMTP id j15-20020adfff8f000000b003141ca4dbd9mr8028088wrr.27.1693906871394;
        Tue, 05 Sep 2023 02:41:11 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id m6-20020adfa3c6000000b0031f300a4c26sm11812954wrb.93.2023.09.05.02.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 02:41:11 -0700 (PDT)
Date: Tue, 5 Sep 2023 10:41:09 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
Message-ID: <ZPb3tUUqe9WewDyN@debian>
References: <20230904182947.899158313@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>

Hi Greg,

On Mon, Sep 04, 2023 at 07:29:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

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

[1]. https://openqa.qa.codethink.co.uk/tests/4940
[2]. https://openqa.qa.codethink.co.uk/tests/4953
[3]. https://openqa.qa.codethink.co.uk/tests/4954

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
