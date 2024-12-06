Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6644C881E
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 00:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444065; cv=none; b=iQCb+RTDONbTGJxF9G606kx/XyQgyDJbTfXW4pEzbmU3fUHliZuTOQwvZh/X+b/InBbUsDATVtwIgOPC3zwNCGLW/B2km7XEMz6Wg505DATXBerVgmztVaIlZ2I8E+Wf/GAaJRSftGYpjCWk4yRipFxL9naKvTXWURxKWUADxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444065; c=relaxed/simple;
	bh=n1QMCR+o1IjAUTaDDfR1xEZ7D28jL25QnhcqGGlZcxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YbhLSk3jIWcV4NPtvS6Qmp5ngwIAak29jJjUDKbJygNQpGxbafULHHWVX4wFQwiHk5oiZm6zgqoCv4tHulTcxxkH872uOXn6kk0VzzzrJMVlTH+xf3zC//1mRA+FGbreQ9rNUz+S8N9mSfhPvUhngmhycZur6/bZovzmeuCFSzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q/oTv/MU; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q/oTv/MU"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53e23fb807dso1210639e87.3
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 16:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733444060; x=1734048860; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJZZetzxGhhv/pZ2FmC206fbtzecWH/gn5vhS8Kz1Hg=;
        b=Q/oTv/MUVRAvX+KY9pT1ztOdHPEX+CPb9YbTrWTSg+fQ9lBLCirZ3fvC/BUsRaOr0H
         oDpdmEQIZ7rsFxtAV8vWG4mNpGp4oNkCi1iCaC6ABD7Px67OqQZ0twelMuIavG4HWVpK
         4jvt4ZfsG7D6RcfG3K3fW3BW48I7OWv6L7UAwzDhtB23Va0HjxefiqbSvctbT+bPN8Yr
         e2xuKcpwEKrCrt90/Ong56RmlwL4Rfh57mLrn34ZoBUckt4ILoOG2E+rlfekoHSQY7jI
         khxdXrWUk34vz66yJNJzXiUikUu4hrImJMM8OyWeS9n0Rygqy8nlbFAu4KFSV4MYhCqm
         j9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733444060; x=1734048860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VJZZetzxGhhv/pZ2FmC206fbtzecWH/gn5vhS8Kz1Hg=;
        b=oNG+wtauzF7rTikne+1MQJmYqdFgShtzKBfEcVGSd1+7LIFv+tW4sxwmCJL89PPL/T
         9D100wh4prC3lUzVgMc8p3esWWtGkrzeYhgIDKi7GwmY3n4riRZAeSxMUnWe/MMXDWyG
         gKxc7FOydJMcLK47yns9MnJnhdTUrCXSymQg6SYTWmox82Z2k2KPNRp30jlOiZZXmQwo
         rNdNvPp6Lb0XsTrhcaOWGNUTZNP7Mo08gle+OI8Ilnmnugs2zYo3mTQUvjugprqgK+JP
         WtniPO/yWXFg58TmuVeX3QsHT+BHiVQ7WFleywCKlJADLGvYRz1HPTe1uTPmoFPwl7C7
         8b7A==
X-Forwarded-Encrypted: i=1; AJvYcCX/i3Q5FNIKINZW1HWjvGsqWqagaer6lmEwlQ62aO1UucOfjcvf1R+TK32k3WUiasR4wR8X9tBb@lists.linux.dev
X-Gm-Message-State: AOJu0YxbiyMtviHm+xjOlTN/kwlaNifJqjJozz4tPVF7zsi68/VnDxGX
	F3wQfF2BvLShonHP6gtNv5rqGPiqJkb+p4lEuUKnQ4EUquktmlkgVr9yyud0YxGjrtXURabErKi
	Dl0hgU7MOocPks5TtLyFOsQLj/3EDLzSv0arA
X-Gm-Gg: ASbGncsqtizYL+hUmvZchhaMTelxqXkXMNWNr+4/TSJZdbITDj6so6ei94siw+Detae
	nneug5+QoIGD6+qCsgQDYFFCWlf89sg==
X-Google-Smtp-Source: AGHT+IGzC7Vw+/YWeKChUjNSnkqaCpm/8ww/D54zHlaFZyxrJkwQO+aTpEfr7ztP6v5D+/22dJnOBSTTri1nIsLJRp0=
X-Received: by 2002:a05:6512:1193:b0:53e:1ee1:25b1 with SMTP id
 2adb3069b0e04-53e2c2c45e4mr205779e87.33.1733444060334; Thu, 05 Dec 2024
 16:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241204194806.2665589-1-swboyd@chromium.org>
In-Reply-To: <20241204194806.2665589-1-swboyd@chromium.org>
From: Saravana Kannan <saravanak@google.com>
Date: Thu, 5 Dec 2024 16:13:43 -0800
Message-ID: <CAGETcx_JPi6-DrjFO_oAUc7V8tSL7gngFaFEsDWV_DfDeWVm_Q@mail.gmail.com>
Subject: Re: [PATCH v2] of: Hide of_default_bus_match_table[]
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 11:48=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This isn't used outside this file. Hide the array in the C file.

Acked-by: Saravana Kannan <saravanak@google.com>


>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> Changes from v1 https://lore.kernel.org/r/20241204000415.2404264-1-swboyd=
@chromium.org
>  * Move of_default_bus_match_table into function so it isn't unused in
>    different configs
>
>  drivers/of/platform.c       | 23 +++++++++++------------
>  include/linux/of_platform.h |  2 --
>  2 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 9bafcff3e628..c6d8afb284e8 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -24,16 +24,6 @@
>
>  #include "of_private.h"
>
> -const struct of_device_id of_default_bus_match_table[] =3D {
> -       { .compatible =3D "simple-bus", },
> -       { .compatible =3D "simple-mfd", },
> -       { .compatible =3D "isa", },
> -#ifdef CONFIG_ARM_AMBA
> -       { .compatible =3D "arm,amba-bus", },
> -#endif /* CONFIG_ARM_AMBA */
> -       {} /* Empty terminated list */
> -};
> -
>  /**
>   * of_find_device_by_node - Find the platform_device associated with a n=
ode
>   * @np: Pointer to device tree node
> @@ -484,8 +474,17 @@ int of_platform_default_populate(struct device_node =
*root,
>                                  const struct of_dev_auxdata *lookup,
>                                  struct device *parent)
>  {
> -       return of_platform_populate(root, of_default_bus_match_table, loo=
kup,
> -                                   parent);
> +       static const struct of_device_id match_table[] =3D {
> +               { .compatible =3D "simple-bus", },
> +               { .compatible =3D "simple-mfd", },
> +               { .compatible =3D "isa", },
> +#ifdef CONFIG_ARM_AMBA
> +               { .compatible =3D "arm,amba-bus", },
> +#endif /* CONFIG_ARM_AMBA */
> +               {} /* Empty terminated list */
> +       };
> +
> +       return of_platform_populate(root, match_table, lookup, parent);
>  }
>  EXPORT_SYMBOL_GPL(of_platform_default_populate);
>
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
