Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E403364
	for <patches@lists.linux.dev>; Wed, 10 May 2023 08:44:39 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-306dbad5182so4434157f8f.1
        for <patches@lists.linux.dev>; Wed, 10 May 2023 01:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683708278; x=1686300278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CLxz5DSWRRHerei3SoKL6mN5PRxkZvTh0Eu/+rq5yS8=;
        b=PZW3n26F+OUtxtGmsFx8VXNjQ+7l1GjGnGte6235H0O5CHFUK6p5w899Ch1oN6yvU3
         1wuir4l+K8fMumpU6BL/2aIHlj2mMR1S6CiAC3f5nF5t+yV9c0Cpnqy+d/iTnk1IoMOW
         ZaoSmkw39MJkEH12HANN1QSnh3Yp1e/ctadSuLC7kvmKxVfdOLhXaYav1yDLANKY5+dg
         3IXsoQWmtIPfTDmuz6D5d8x6Qj4FSofH5ac4Ugr2mpGmPx5+XbkvpBS+7Sx7oojMEmsH
         AdxkfrQvRt7zUR4aVOvb849a9heZbJRajILyl9vYmUr3G6e0AlWW5q+IUnZdYl6IOdej
         eDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683708278; x=1686300278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLxz5DSWRRHerei3SoKL6mN5PRxkZvTh0Eu/+rq5yS8=;
        b=aA/2zDqLrIsjA66IsFDPbTTpYuNGy5t46mEckdjAnXQKevLKqxn5HqQBihUQUWeD9/
         DU3UNV3ifU3KSfZXWT1py4ZzU8NUjdsp1GNL94Z9Let2snmlVZZ7udbIR4RDxylpTOGr
         OuNBBcmawSBA0FPxS/prS62NTzM6mQa/n9E4Bm/u4ueCFAzvEx637zQqrANU8jFChpQz
         z52T5m2mTt3VYUjP01tV922IYX5H1+M+gHCqQ8yzWajkOHrCoqJtm5wr+HilMQl+0RtZ
         L/dpanSbj3X/JCcYONHqBTtLOrz0RPR9fLSGs8e2zop3fesKo+5JvEsii8NWq1DZQKlC
         vd/g==
X-Gm-Message-State: AC+VfDz+Tzlla0/JsFGHyJEW7wb6LslZfWWgDh5cJTojgw2JRyxY1hxJ
	hpFN9hBZURjIBttzKxw00oA=
X-Google-Smtp-Source: ACHHUZ4q8vpCgrOqMElGtyhKewZlK52jUjwZq8EwMRh/PA/qJVyW5kp6PXsHUvRUZ/v0DvFMjjk4Lw==
X-Received: by 2002:a5d:6ac5:0:b0:306:3429:1833 with SMTP id u5-20020a5d6ac5000000b0030634291833mr11399556wrw.46.1683708277580;
        Wed, 10 May 2023 01:44:37 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id k25-20020a05600c0b5900b003f4272c2d10sm7293517wmr.1.2023.05.10.01.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:44:37 -0700 (PDT)
Date: Wed, 10 May 2023 09:44:35 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
Message-ID: <ZFtZcwRcoTO3A6I0@debian>
References: <20230509030705.399628514@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>

Hi Greg,

On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230501):
mips: 52 configs -> no failure
arm: 71 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3494
[2]. https://openqa.qa.codethink.co.uk/tests/3495

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
