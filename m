Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DE7C
	for <patches@lists.linux.dev>; Mon, 29 May 2023 10:09:52 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-51456392cbbso6023815a12.0
        for <patches@lists.linux.dev>; Mon, 29 May 2023 03:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1685354990; x=1687946990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8Ulvr/gZUbv6oI079IaQPegeBjM6/iRJ/6/UwLkRIg=;
        b=u0JRN58+4SypFTy3LwYLGaRT+pC3gNXCQAb3K2We3OX03t3OiCaUE8O9PNCgyi0fsL
         xwZEshK9wGftnJjhwIHLDwjsDqCqqGeOI5SeA623HJDmw9d7swXSTcJoB5GjMxqzUgJP
         pQpsBikAKC9tCZvq5G3GXS2k2G3EBxuRiV+Ug087VMdXK9T9VxkZe5opjU1l8TpSUzFX
         /Wdr+lTTzVsSVIX121RkuNs9RPwDmvOF7Ys5Mi2fRn/8RYDcNhw3dht1JasjztUs23Nv
         AH0yn20+VmeVSQkcBNILqfZ4s9GdCecwBCn4RSsYNGBFZif8KIxkM77RQixwHTuOXM//
         2KfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685354990; x=1687946990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8Ulvr/gZUbv6oI079IaQPegeBjM6/iRJ/6/UwLkRIg=;
        b=flNQTaDNtwV4IayHgkhtSCZmI8TOllk/XAzDio9XLWVCN1PLJlI0Bt7O0vzTTMr/BC
         mg/2Ejjs1x8U0GAjg715JWkDojZIwTrChSsp5s3jPqdwgbyWIQzjC5Dsv4y0w3uVbKvj
         DFDJrABDzQYS6rl/1g4fZxl4slxDQkFI1bjmyLZXeWDB3g4fX5qEzrfUssGLFAGp4386
         eEgoCTQs+wMmElpFCEnth8GhfLRktQ7RYzfwrltiJGn6UstBfM0Nez5ddhP03yhPzE7t
         iH7U2lWy4IsBDuEjMnbC02L8Ju9qt88jy+ONiEBvHbQ3jAcjw/BWyveJif/u9HooiKZ9
         7pvQ==
X-Gm-Message-State: AC+VfDyGvvlrvmytFmyXFyEIbyEyg1u6x5oliemCWr58OQpK1pIZfaAL
	ufCVRZ3pRkcvO46/69D9R/Jegr0KyDMTNuo9PKHzwQgN+zt4gBEF4unmPQ==
X-Google-Smtp-Source: ACHHUZ7gGI3d+zboU9ha1LNYX0Fy1Nci+qG9oOeSWbJgf5FflG7F+amRsB5ehHf3hNCeJzKwO8dgEGm80cuCHlYuCwA=
X-Received: by 2002:a17:907:6e02:b0:973:87d3:80d4 with SMTP id
 sd2-20020a1709076e0200b0097387d380d4mr7807032ejc.18.1685354990400; Mon, 29
 May 2023 03:09:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190835.386670951@linuxfoundation.org>
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 29 May 2023 19:09:39 +0900
Message-ID: <CAKL4bV5DhZD-ekQV2PPyAErndyHUwMS0b5VNABxbtx1eW23Egg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, May 29, 2023 at 4:34=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.31-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.31-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
