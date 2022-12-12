Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD746FC6
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 20:22:36 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 142so9010680pga.1
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 12:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T6m4oJyqW7YP/7b8bP79gaG9JOlzFsGskUClBSJM9lg=;
        b=KTSnMDhZUuvC/ECxs4deMGyzsjYq27dKkyPi5+Ggi0tNdxfp+xcXq6YmDSA66i2BN8
         lZC5PLPQBqcLE3YnsxyjeYqj8mSytVVegDt9eAxeFuD/vBBGNjsGeAHWrMh+kdOdYziu
         AyIXzPyF0/2mDEUs/QMK3KTh2Th1wUW0+b5FzJ7VSNloVoz2O1S1eVdZ5SHw98pEQLDN
         9MxMkPkcsAEkB0mwXr/PF2129xVVw2W4ky/nL6MQCE6K8LHG2GBfYs09MbLAFJ8iWpAu
         ciwVJ7tXnuIESWkq+iPksWvBgY6gMPEdqYBN24oOQ4V2HGHxMfAMoaC1G7h7u1f1r3Oi
         xjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6m4oJyqW7YP/7b8bP79gaG9JOlzFsGskUClBSJM9lg=;
        b=1bkEzp/Ke8+H70df4HLRZG7wYvbzeu+FhoRxW5POoHSlHro/+p8vZCMl0ywA1FcS59
         wcTxvri24tED0bRFjKTBemqLm4CcucMh4DWAwfHg5g2nLqJUnVwOa4HaLRriv0Zul2zI
         DA6O1GrhTwPrAGgTqnC2/iAwkymwhEtiWWtgs+NW2LCSryy6y8VrCe8lFw351L1cPkMR
         Gu469ay2aVLQP3ifewVgPZZ/CWnd+nr8JKJZnNTA/Awxvy/muiuwai5bXbEiMHf43AF6
         YbWCL6qCDsAiO1kwM5XroZ+Y54LRGBye25CC9ow75RndeMXSDG+gZfaNeavCGgWAsDPV
         rqpw==
X-Gm-Message-State: ANoB5pkjvRE4FunIrKopel+XKtkUwDCn3GpKL6URtE8hAP+7q92K+EBi
	sYX2EqQNRj+GFOM/lff4LpT5W5TmzJEyax3sPMpFyQ==
X-Google-Smtp-Source: AA0mqf5Q61HiOiCPy5J3cYbEgHQgC+WkYNhTgryqXz7O8vybYzMll1M1ZeVWkktCQJ/mwIhESeUg6djT9yFLfqf6UFY=
X-Received: by 2002:a63:ed10:0:b0:479:3bf5:df35 with SMTP id
 d16-20020a63ed10000000b004793bf5df35mr342822pgi.572.1670876555633; Mon, 12
 Dec 2022 12:22:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130913.666185567@linuxfoundation.org>
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 12 Dec 2022 15:22:24 -0500
Message-ID: <CA+pv=HPCviyakX1YjY5sq4ZoeN7gKPhW8dSVzC_Yp1LS4UjL3Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 8:48 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.19.269-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
