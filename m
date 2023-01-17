Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8F1110
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 12:35:24 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id n7so4345799wrx.5
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 04:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H1sazlO13B0CCYmrJZ9N/1/ukVSWqASb/1IbYgu+dLk=;
        b=WbQtQoGPoellA3xFKFY1+amIvyc+OBh2aSgFVXJ5OqL9NAaFkZTCmPeZvUWlGSU+YG
         ILi8AKN+dEhtPGhsWV814JG/sk7IhPqZboSKEqc/tiFisOmLGy9jTvI6ZlWxjigRFx2v
         dL0LPzowlBljUEE+5BEZ2mm7rboqYdvwogJj0uyI1i+Lcn0iDY6agpU3NYebMVKF/xJz
         JvgkSHQKcQGiD6Ttyq3Eb6MMqAxss6iYQgw+83R+U05P9l+jBqXhG8CVrztLrM9p3gQI
         AqLi9BNwkjV7JYZX0KnB5jdeFO4umCMER0wQo1d2VVzZSd47gHa8z6l4ddn0DACr49oy
         UkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1sazlO13B0CCYmrJZ9N/1/ukVSWqASb/1IbYgu+dLk=;
        b=y7gG+i8g0Mfi7OR9XtSqdKlLbv1N3PcJ+M1E/2Oify6zou6MHz/Jn3UXRZpmvtZqPL
         umx6M6Eiv5+BRbFJ9UUy6W8bfj+jkd0W/LZ9WyTgT+2gwmRzbQR9sybTa3VKuw02pg90
         REOi3U60aIlRcQ59qzWAClPz2dOaAbSth4wElh1b4ztNv7tuLTFrwGxnADqJUG1+7Vlm
         3H0hLfPtutu3yH8Y6Q8hTs+lc5gHtiEHHjKEgQOxsHl8oe8xc1kfb5iMOPRZ6UPvlm8V
         x28UYLBOQmgnFD6aG8xDdqeMkrLThw4M1qhf2AhvwcUAqmCKTticFjHBoj83ym7I+myF
         kRbQ==
X-Gm-Message-State: AFqh2kogfgkQ9TGH4aNBHafsGzWzJBaMTHq8C/z6v4qEy5fp5QbfWaHr
	cHytjplbQb5NWqtq2B3+uTA=
X-Google-Smtp-Source: AMrXdXso8XJce4JaQ4/3V6qIdrV5+rNmUK9DrELcy6Q5u0Zydz8Lv+npgysFjqsY0epSLG2o3qU7Fw==
X-Received: by 2002:a05:6000:98d:b0:242:809e:1428 with SMTP id by13-20020a056000098d00b00242809e1428mr3034513wrb.5.1673958922445;
        Tue, 17 Jan 2023 04:35:22 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id j17-20020adff011000000b002a64e575b4esm29129839wro.47.2023.01.17.04.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:35:22 -0800 (PST)
Date: Tue, 17 Jan 2023 12:35:20 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8aWCCF8bvmMnj0g@debian>
References: <20230116154743.577276578@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>

Hi Greg,

On Mon, Jan 16, 2023 at 04:51:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> 1 failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
arm and arm64 builds fail with the error:
drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr' undeclared (first use in this function); did you mean 'idr'?
  427 |         if (!isr)
      |              ^~~
      |

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2661
[2]. https://openqa.qa.codethink.co.uk/tests/2667


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

