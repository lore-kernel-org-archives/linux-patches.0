Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BC418AE1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 21:08:33 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3382602a12.1
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 14:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686604113; x=1689196113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PgflJ5HauZ4+h2KSgczCGeZma4l/SQyA77jKXJkcojw=;
        b=OqbJgCcwUK2y+JS690twBeqU7wnjZEkGEyBBQpyjRuTpWve63YvvJFZxOQxaImcyzk
         bvd9BvpY5kEIF+l4O3T7tVLy2vvftotbtSqhmKGm/2oE8+uo3i4uimq9+cYs/bLg+W8k
         cXfmdO+8pZrZPUtDew9ZCFVlfctj47LhPFXiStMTuia4bIFLgWV7hpzFtJgGMYWmH7BB
         XvQG5VBfmxfb5+bpVS9Z+7e3T9Ux1TxmKI5wmksfk5nGmPa7YHMMYhqhdUCFmZ/0gqe7
         QWcNXR9STF7lIGgAzhmuRSf1ydHV5WXJoaGaY+eevuDmZWG47zsYQ6v0bdxZvOmv9bxQ
         iXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686604113; x=1689196113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PgflJ5HauZ4+h2KSgczCGeZma4l/SQyA77jKXJkcojw=;
        b=g6dMTSngrHqEbw+45icedTxkRpRhEqLcL1SqwpFEPlXBR9DEXm7f5FiQh3tPt8NuP6
         YzfxMTWwMb9yZYdyu8sVS2bK2ttZPO/coxqixXTCXsPeOwjwY2UvXrBq09Z0VPB5U58J
         EMZfeqjMAdBCvKavldv3LwstssXVuXzDDcPqBWWnOaMJ2ViPLgAWcRU3HWtlJfoo/MOq
         wiBY9Dhz2zkUbORLQRTKW2CkG4QwNMFkZ8HEB+BXBba3qxk5ABgY2T+vy7Bu3ZIzfleB
         X9qCMT43NmCY1hKRuZAkfdk9obRkJLB5VwRRpL1VLJVAJ/8JDHSjFJkUu5gdks2GP0kA
         CxcA==
X-Gm-Message-State: AC+VfDw7/NGTu+riZf4igR7Jt+/Y6PVdoCHXSKVQXZCLYyRhYsU8hFuw
	y4ZbjXSwnhP81Ksz0nmGpSq6zPKfOgyChmDthgA=
X-Google-Smtp-Source: ACHHUZ5D8B2tB4XZQaX7PnLlkIGl7fgsEwEyJER/K4Dpmu9w++B5VMhiO3d0v8uoPAtcGofZyZqzESr0QPwUfnACVps=
X-Received: by 2002:a17:903:32c7:b0:1b0:4c32:5d6d with SMTP id
 i7-20020a17090332c700b001b04c325d6dmr10231740plr.31.1686604112978; Mon, 12
 Jun 2023 14:08:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101715.129581706@linuxfoundation.org>
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 12 Jun 2023 14:08:22 -0700
Message-ID: <CAJq+SaA3BzspzE=fjLYxrJ55nyKRxkjV_1dwUtN5-f8_P3kubw@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
