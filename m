Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720647489
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UqhinNMS"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-406402933edso25914945e9.2
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 13:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697229431; x=1697834231; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGqNMQJoTKDExVF5LTm0ABt03qpcjjaRQIb4oBXXpL8=;
        b=UqhinNMSuFR+2EgeV6mcBuyS0lo6nZBK4g/ZdKOWzQiylwZasC+O3yhvQ/EnmVZXI6
         NB1RAcbujPoj/gDY2h1RodL0FRdmB3Fza00/BUAzgp5mnEMgw8h7dWxzN0IH5ap4JCSX
         nQ6xy+aFV/W4WMKyhtaKtgmtkHyEQwi3cPaQOgFakkZNnQ5YkSnaemQpK6NEvcI9bOc7
         dZIBZsqY3NWX0Pw73CXO7/HiJUqbAfijPVPYO7b3fClVHFs3fn8cfsT2Q6g2+3SaDnvZ
         f2adAyN+lhSxwU8dqz8cVKHkrKAoJBfyMppbKd02JlksTIp0qs9QtwSTev+OxqpIryzt
         4PwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697229431; x=1697834231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGqNMQJoTKDExVF5LTm0ABt03qpcjjaRQIb4oBXXpL8=;
        b=NLrBj/JcwQvPwDOkpk/RD00XlX0Y9DdxLTtRvIw+7k+ec0ZsdJbCSc1Go4jqUn7L65
         liTClnyrY9DzqUMhr7A6BQYGEVdfON420bHAlKD9nWU9FAKr/6JIniwq1QQ0h4oas1QH
         vvIBlV6fl9NPlKqSdol6a+SruVwOAYPtMWRVwPKZBuzYH6fGuLiXQiaWOD9ph1GLMlhI
         nCrUxrCxmuRbB3ThqsMVaHSNYNHGTfCg3SpgphfV4R5DhHRc/5xKDXSotT6GmDAPpOTP
         HcGZ8+4T3ogYpZutNc1EaDSLw873ubfsIERwNN/u4rpynIYMHFHZsl1tRfU5/psH2lTe
         gEww==
X-Gm-Message-State: AOJu0YyIDN2hNqTDGJmDDlET36gywmT+mkDvXiFGMphZD45d5CtOxFNO
	QkBuoFkRwGFT6FijVKiQI7vh1I2+B72HiRt+6onodw==
X-Google-Smtp-Source: AGHT+IF+7IiJEEKizdMeYQJowMnFRLsMOiRhCWVvtDSSbLN5+4n2cIdYTg5MU1RI1Xr336Wc5nGpjJB2bTesb2OZQ6w=
X-Received: by 2002:a05:6000:1e11:b0:32d:8357:42dd with SMTP id
 bj17-20020a0560001e1100b0032d835742ddmr10781479wrb.68.1697229431471; Fri, 13
 Oct 2023 13:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231012-st_remoteproc-fix-sometimes-uninit-v1-1-f64d0f2d5b37@kernel.org>
In-Reply-To: <20231012-st_remoteproc-fix-sometimes-uninit-v1-1-f64d0f2d5b37@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 13 Oct 2023 13:36:59 -0700
Message-ID: <CAKwvOdnGDXvbCgPFq+DZxaMo-ptdq7omXJyLVgwgFeKh5RwdTg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: st: Fix sometimes uninitialized ret in st_rproc_probe()
To: Nathan Chancellor <nathan@kernel.org>
Cc: patrice.chotard@foss.st.com, andersson@kernel.org, 
	mathieu.poirier@linaro.org, robh@kernel.org, trix@redhat.com, 
	linux-arm-kernel@lists.infradead.org, linux-remoteproc@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2023 at 10:04=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>
>   drivers/remoteproc/st_remoteproc.c:357:6: error: variable 'ret' is used=
 uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uniniti=
alized]
>     357 |         if (!ddata->config)
>         |             ^~~~~~~~~~~~~~
>   drivers/remoteproc/st_remoteproc.c:442:9: note: uninitialized use occur=
s here
>     442 |         return ret;
>         |                ^~~
>   drivers/remoteproc/st_remoteproc.c:357:2: note: remove the 'if' if its =
condition is always false
>     357 |         if (!ddata->config)
>         |         ^~~~~~~~~~~~~~~~~~~
>     358 |                 goto free_rproc;
>         |                 ~~~~~~~~~~~~~~~
>   drivers/remoteproc/st_remoteproc.c:348:9: note: initialize the variable=
 'ret' to silence this warning
>     348 |         int ret, i;
>         |                ^
>         |                 =3D 0
>   1 error generated.
>
> Set ret to -ENODEV, which seems to be a standard return code when
> device_get_match_data() returns NULL.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1944
> Fixes: 5c77ebcd05ac ("remoteproc: st: Use device_get_match_data()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/remoteproc/st_remoteproc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/remoteproc/st_remoteproc.c b/drivers/remoteproc/st_r=
emoteproc.c
> index b0638f984842..cb163766c56d 100644
> --- a/drivers/remoteproc/st_remoteproc.c
> +++ b/drivers/remoteproc/st_remoteproc.c
> @@ -354,8 +354,10 @@ static int st_rproc_probe(struct platform_device *pd=
ev)
>         rproc->has_iommu =3D false;
>         ddata =3D rproc->priv;
>         ddata->config =3D (struct st_rproc_config *)device_get_match_data=
(dev);
> -       if (!ddata->config)
> +       if (!ddata->config) {
> +               ret =3D -ENODEV;
>                 goto free_rproc;
> +       }
>
>         platform_set_drvdata(pdev, rproc);
>
>
> ---
> base-commit: 5c77ebcd05acf3789949c8a387df72381d949ca2
> change-id: 20231012-st_remoteproc-fix-sometimes-uninit-7aff1bdb7349
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
