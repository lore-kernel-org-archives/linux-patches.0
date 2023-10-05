Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EBC3FB24
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 18:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rnhh6sfd"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3231d6504e1so1218118f8f.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 11:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696530707; x=1697135507; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3oHq99QeF5JtNLpOndq/jeK1gHtPcoa92kZKu0RXp4=;
        b=Rnhh6sfdbL8sgUDybq+rwwdoG5uxlz6GgefS9KUokIIw5SzMN608HNGvg2EAMQlYT/
         r5QnszveMZrqPmAv6Tg+off81adjjmOMCNBHHJhJs866K/icPToJnm8A8QVpj051EmpN
         /Rcbc+N96TeygL6Xj76xJu3sOZHzEtV72cN5q+SWOZXcHxBBAkHyDkoha65GwRryxz8r
         fJrKU5r8/np8a2fQrkwDcCYOvEEzlyb0Z5TaO3mu4+eKT1lnix6bnopYozwz0wmWx4H/
         9ZjbZIwcxh/RylsQ37OtwyWF6Eghy+Y77EjNbmrRbaKilP1MSiGYwFdinx4XgVgZgjHC
         kkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696530707; x=1697135507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3oHq99QeF5JtNLpOndq/jeK1gHtPcoa92kZKu0RXp4=;
        b=F3Y0jv2MgE0PdtuwWihfpS5NBlyprrlVGQAbQxQ7HNSCSBLYTyKhOpvNwW0doLdioi
         A65drK2ChCY4HXMdA7HTXuoDOcVjr0S2IiWa/K8A+jkBZc2xmAjsm8AjZaV1q+0TDRr3
         KP+3EAGPWscUQVChrPqlHQrR4EXysvddEARCc4onzfvDuJmwdbNSm5/yN3GJd3xxRDRA
         pQkvonxUhfZgYheUPjwxKfhby5UGzG87Z+qhlH+Zt0l8dB0A+PNbuHs+/jDr5QpM52ZM
         2bBQNjK5R82DhjZF/rzBZAN6CeqQnvlYOIMaVgEZDX5MMd1OliTpQVGUhWNdmOZacjJ6
         4ehA==
X-Gm-Message-State: AOJu0YzDdLyGPdwZAWSm4rWmJuKY/NMyhKEY0M8zLtmcqwN/OfoHEUpX
	hg2m9JK9laJCIjiCgA9LbmUJ9Yz3I63YD/j6VNd9OQ==
X-Google-Smtp-Source: AGHT+IGjcp95cX6dB00l0Dlwo8I89MDeu9iDd7gxrJ6XWjmStfUtDvPIkS6czEb/hhrzPdEHuyeLenet0F0iLbILJfU=
X-Received: by 2002:adf:ce90:0:b0:321:cec8:e64d with SMTP id
 r16-20020adfce90000000b00321cec8e64dmr5676004wrn.62.1696530707248; Thu, 05
 Oct 2023 11:31:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231005-opp-of-wunsequenced-v1-1-778815980a8d@kernel.org>
In-Reply-To: <20231005-opp-of-wunsequenced-v1-1-778815980a8d@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 5 Oct 2023 11:31:32 -0700
Message-ID: <CAKwvOdmhtS6LAcckceXLftKeqxthdHEEi-zr8EiOW0hRYwsjEA@mail.gmail.com>
Subject: Re: [PATCH] OPP: Fix -Wunsequenced in _of_add_opp_table_v1()
To: Nathan Chancellor <nathan@kernel.org>
Cc: vireshk@kernel.org, nm@ti.com, sboyd@kernel.org, ulf.hansson@linaro.org, 
	trix@redhat.com, linux-pm@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 10:25=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>
>   drivers/opp/of.c:1081:28: error: multiple unsequenced modifications to =
'val' [-Werror,-Wunsequenced]
>    1081 |                         .freq =3D be32_to_cpup(val++) * 1000,
>         |                                                 ^
>    1082 |                         .u_volt =3D be32_to_cpup(val++),
>         |                                                   ~~
>   1 error generated.
>
> There is no sequence point in a designated initializer. Move back to
> separate variables for the creation of the values, so that there are
> sequence points between each evaluation and increment of val.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1940
> Fixes: 75bbc92c09d8 ("OPP: Add dev_pm_opp_add_dynamic() to allow more fle=
xibility")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/opp/of.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/opp/of.c b/drivers/opp/of.c
> index ade6d42cae46..ae5c405bbf9a 100644
> --- a/drivers/opp/of.c
> +++ b/drivers/opp/of.c
> @@ -1077,9 +1077,11 @@ static int _of_add_opp_table_v1(struct device *dev=
, struct opp_table *opp_table)
>
>         val =3D prop->value;
>         while (nr) {
> +               unsigned long freq =3D be32_to_cpup(val++) * 1000;
> +               unsigned long volt =3D be32_to_cpup(val++);
>                 struct dev_pm_opp_data data =3D {
> -                       .freq =3D be32_to_cpup(val++) * 1000,
> -                       .u_volt =3D be32_to_cpup(val++),
> +                       .freq =3D freq,
> +                       .u_volt =3D volt,
>                 };
>
>                 ret =3D _opp_add_v1(opp_table, dev, &data, false);
>
> ---
> base-commit: 3c4746e28af13fdd134d3c4312169fda0a8abef0
> change-id: 20231005-opp-of-wunsequenced-a594ea4c053d
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
