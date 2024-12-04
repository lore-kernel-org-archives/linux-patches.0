Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B680FC0B
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 03:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281711; cv=none; b=PBwY/6hpklH5SyimQOVR/5yVEePI8SI2QPwXjjO6SaCiwppEVqDMyZW3HfUYDj4Af2wTlIacm5Me5xjQ41Mw1gDzogBmH6PIS/gHQFBK9eWpcSVMYDz72/W1+Rqml1YBw7lGaJr4qW3xLVY4COBochVKJhhAOvcUt1R643fNHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281711; c=relaxed/simple;
	bh=Gx9TKyH/IiOvnCTOYjzUfxu+NCv+Qo0R5Stqwe7J2gA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgwMLWFDkZGmeZVbzKW7sfXzQY0GcwQpT2t8YmNHclGDXvuHos3zuv1XrDRSR657nFhsiemr0mSlCTGTcyW9kHcaYf7xndZyHYiwn1BgTSDc9v0cBZK5pAzL5BMaT7VlIn4TeiujFu9Zdv1G7DQ+5Fhq9sz2El+TKwzpx+J1Ek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YC/gHTSo; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YC/gHTSo"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53de8ecb39bso7385461e87.2
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 19:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733281708; x=1733886508; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVmSqpdGxBu8j7ybmU1Q52YmQ/jiLnXY/vl/nUcqB8I=;
        b=YC/gHTSosm+GiTupOhTB4R8C4t/f8L5Akym1tpGPleHq581b8ETE1DkuDVhJF/o4zK
         nFwfSDOAyqjdBM+iq17nj/pQIY8sU3ir78MtFTkldn/bEZ7pYHvFvU4nbTqv7Mh2kRmu
         zfVi4FKAO6TCV2lPKDCKm28DCQ+LO5sy2kL3WTQIdNByg3NKP29wVsDrc/rfHwo99QWp
         fxCrVqEpV9lGQqjdb1y9jJOHpXcHG4uVo569hXBuDRQq3VxWWrDkS/hkDOBwbWXjzKCe
         e6u8nO9qcUrzqj/0ce+MZ0MJc5g+Yx7Jsa3qRysArKh41BQtlaz3pPrb0KotoLjB/06H
         dV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733281708; x=1733886508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mVmSqpdGxBu8j7ybmU1Q52YmQ/jiLnXY/vl/nUcqB8I=;
        b=oYxagW+xS3Up3N5j28w7j1PPq2q1pdyuKj76EOD/12dmNoqjR7CNnA84Gma3JRHa/4
         stcN226hMbe/fT9BvyDZ3pLFTvwV5MrIwUdhJLP76IzkcvARnz1aYgOO8h/EOCThDd10
         d2wWkUptSaR3G9hmxb3zU8JlO97sW1MJJkeC48caJAZa0OzUpEw7IOUHdBsrq7+Zk+r+
         N944d7KvTaQ7En/7e3XmENXXgJt4SgNaSxHI3V63MyroQWzKsUfFF0ckh+pJo9vMhDRP
         wrbhzfloMnvg8B8uUOjHTri6m87Bk6lT6m1FFFW47bhd9WP5XiQ4QJlfG+r+HUodt7WE
         QjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHZZytMLdt5jgTS0+etZFppENFjWqFYkOOug1Q0XZeE287X7mRF7jGruaGT/qR5M+txHeeW8o9@lists.linux.dev
X-Gm-Message-State: AOJu0YyHn0HxVpE/QVv+Y+2hEM7ieLRMB59vi9MZa+osx12NaYZAEj0c
	qkJWWZYLUIfdz+pmykKfz/ujwUNFZwtT4zbA3pgESUi3BlNaUp0y5c8NXiIu0e4rGrll3uRvieS
	0G5P5bj2QB8+8z26yxEv/rLV6ZdjFEyWc4GS1
X-Gm-Gg: ASbGncuV1WAYv/znTthXMLr2fuPr03Sy/8lcK1WNP7lsFXVLUTunUJvl2b9STlVovzJ
	dazZlK15nM/YjQVBYBzlXx855y8oUMjJsQT51fLi5cZvLXsRAT2W6Wi3c/64N
X-Google-Smtp-Source: AGHT+IFWrPHsG4uBMjv2tdZR6tlXbsKwqe+rRNrv2XPJXAVNi7kJ86S8IWFxXuMskg01ueFLy0zr2v3g9u+L67fH27I=
X-Received: by 2002:a05:6512:148:b0:53e:12d6:8835 with SMTP id
 2adb3069b0e04-53e12d6883dmr2511065e87.46.1733281708120; Tue, 03 Dec 2024
 19:08:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241204000415.2404264-1-swboyd@chromium.org>
In-Reply-To: <20241204000415.2404264-1-swboyd@chromium.org>
From: Saravana Kannan <saravanak@google.com>
Date: Tue, 3 Dec 2024 19:07:51 -0800
Message-ID: <CAGETcx8uJF30UvK_4PUu2R+juYa33CXEZrnSLG9nWXN2TPL4wg@mail.gmail.com>
Subject: Re: [PATCH] of: Hide of_default_bus_match_table[]
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 4:04=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> w=
rote:
>
> This isn't used outside this file. Hide the array in the C file.
>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Acked-by: Saravana Kannan <saravanak@google.com>

> ---
>  drivers/of/platform.c       | 2 +-
>  include/linux/of_platform.h | 2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 9bafcff3e628..f09dc183975b 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -24,7 +24,7 @@
>
>  #include "of_private.h"
>
> -const struct of_device_id of_default_bus_match_table[] =3D {
> +static const struct of_device_id of_default_bus_match_table[] =3D {
>         { .compatible =3D "simple-bus", },
>         { .compatible =3D "simple-mfd", },
>         { .compatible =3D "isa", },
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index a2ff1ad48f7f..17471ef8e092 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -47,8 +47,6 @@ struct of_dev_auxdata {
>         { .compatible =3D _compat, .phys_addr =3D _phys, .name =3D _name,=
 \
>           .platform_data =3D _pdata }
>
> -extern const struct of_device_id of_default_bus_match_table[];
> -
>  /* Platform drivers register/unregister */
>  extern struct platform_device *of_device_alloc(struct device_node *np,
>                                          const char *bus_id,
>
> base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
> --
> https://chromeos.dev
>
