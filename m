Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7376D198824
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 09:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721123349; cv=none; b=AvBA9GQ0EVZNtG104GBQj20FvXrDZwHgbKMdVYDkbdG2+jQRy6bZj+apwHA4Y0YOd3Dq6YMBH2JjWZDT9pxs5r+dzwInSqE2xGiBhtBJRGitaFGcj3FITslduCwB75wgbG8Q3ZbEiF28jFCKji0Irqve4moRAkK+2+PHFzAfQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721123349; c=relaxed/simple;
	bh=8UvQU7I9knuWhkpzd9TO9Fs/k8V16zg/peOwYTNUXUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgKtUNrQkAIttaPf4CLx9xeMyBzEp3hDIy+Re/5bhz3wCnaMozLSB9j5z5blrCaVutbkryl6V967eQIYMXPy0n6VwrhzNePIaKVQtZOjz/7wA31OelixlrAq9gAyJB48IFlimke2+RKqUY1Ersnq9Tnmhc9sy4hzgQyNmpWGR7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-65cd720cee2so47749617b3.1
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 02:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721123344; x=1721728144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRQTvYVjx0Y6w3qpoyzLPKWPbAyGp8ArajcCwsaEB18=;
        b=kFX8FGf/PnGXDa61BgJZwlWv3Hboku4OF0iz5gzx3PBXympnrM1kV5mCFrj/IniWT8
         WVCVm/LJb4ubOneRHHLmziPVgw3DCSGg2r+fmim1IiLzSHAI2Sc1LXjfYnEt73RrLQS5
         zLIfVDIkogZjzjF8/aPeb0dht0HsB73T8LHZge2OXWW4qB5T3cR2Q2h2q5AUn6c0urGx
         oJWeRzlpeKAY2t0+dGkgys770JrE+YFI6SBaL63xvh8hXqpwv51LBhFe4CauknBBDM8s
         jVOt9BZ8m/szCRh/4jaqz8r+kD2RWsceQcFyhtR9tbPSrvvsVuVn0fSlJapzegWDmNwu
         DZzA==
X-Forwarded-Encrypted: i=1; AJvYcCXsrKBLZaukwUJP1qeR2aKaAhpekA16KeFnSz4eTje/SP4pASCLfcDOTRNtpZ9v6AXtsm8TIeu3FDXhpcpXu8IN/PbIb/r9rg==
X-Gm-Message-State: AOJu0YxF50+/k9ZSj1+m0xklE/dMoIO6lCoKsWoKjE9WCh6y7sr6wpiM
	1jVskns5GLplFY4DDnTU9bHS5L48HsbP5/hmC+UFoGbcjknopbiLVaxZod2T
X-Google-Smtp-Source: AGHT+IHGhGrebdnNX9BnKFQlQ6O4uBAdi1Oi0+BGz54OIw0L5daWKQNziRcpF8LuLNf39dx5r+W89g==
X-Received: by 2002:a05:690c:d94:b0:64a:79f6:2f2d with SMTP id 00721157ae682-66381105a8fmr20378637b3.31.1721123344073;
        Tue, 16 Jul 2024 02:49:04 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-65fc2af64cfsm11078067b3.74.2024.07.16.02.49.02
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 02:49:02 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e026a2238d8so5092157276.0
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 02:49:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVl6u8jIpmnfRu5Q4fg77WBV5tls+k7Gn85Kd8XhMtOgmdFiO+V7j9OH55Ae4grQ/L803M+x8e3O1/5RhXAC8OxTwkcmlBPaQ==
X-Received: by 2002:a0d:de04:0:b0:63b:f8cb:9281 with SMTP id
 00721157ae682-663817d8a34mr15909167b3.41.1721123342440; Tue, 16 Jul 2024
 02:49:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710201246.1802189-1-sboyd@kernel.org> <20240710201246.1802189-2-sboyd@kernel.org>
In-Reply-To: <20240710201246.1802189-2-sboyd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 Jul 2024 11:48:49 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV56nezM9cj1bVo4+gqi0OPvKjktu7i4Ov9ZKeyNkoiOg@mail.gmail.com>
Message-ID: <CAMuHMdV56nezM9cj1bVo4+gqi0OPvKjktu7i4Ov9ZKeyNkoiOg@mail.gmail.com>
Subject: Re: [PATCH v7 1/8] of/platform: Allow overlays to create platform
 devices from the root node
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	Daniel Latypov <dlatypov@google.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Maxime Ripard <maxime@cerno.tech>, Peter Rosin <peda@axentia.se>, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, Linux I2C <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Wed, Jul 10, 2024 at 10:14=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
> We'd like to apply overlays to the root node in KUnit so we can test
> platform devices created as children of the root node.
>
> On some architectures (powerpc), the root node isn't marked with
> OF_POPULATED_BUS. If an overlay tries to modify the root node on these
> platforms it will fail, while on other platforms, such as ARM, it will
> succeed. This is because the root node is marked with OF_POPULATED_BUS
> by of_platform_default_populate_init() calling
> of_platform_default_populate() with NULL as the first argument.
>
> Loosen the requirement here so that platform devices can be created for
> nodes created as children of the root node via DT overlays even if the
> platform bus wasn't populated for the root node.
>
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Cc: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Thanks for your patch, which is now commit 98290f295fbcf18f
("of/platform: Allow overlays to create platform devices from the
root node") in clk/clk-next.

This causes i2c-demux-pinctrl to fail on the Koelsch development board:

        i2c-demux-pinctrl i2c-mux1: failed to setup demux-adapter 0 (-19)
        i2c-demux-pinctrl i2c-mux2: failed to setup demux-adapter 0 (-19)
        i2c-demux-pinctrl i2c-mux3: failed to setup demux-adapter 0 (-19)
        i2c-demux-pinctrl i2c-mux2: Failed to create device link
(0x180) with e6ef0000.video
        i2c-demux-pinctrl i2c-mux2: Failed to create device link
(0x180) with e6ef1000.video
        i2c-demux-pinctrl i2c-mux2: Failed to create device link
(0x180) with hdmi-in
        i2c-demux-pinctrl i2c-mux2: Failed to create device link
(0x180) with hdmi-out

and anything relying on I2C connected to these muxes fails, too.

Also, loading the 25LC040 DT overlay[1] on Ebisu using the out-of-tree
of-configfs now fails, too.

> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -732,11 +732,14 @@ static int of_platform_notify(struct notifier_block=
 *nb,
>         struct of_reconfig_data *rd =3D arg;
>         struct platform_device *pdev_parent, *pdev;
>         bool children_left;
> +       struct device_node *parent;
>
>         switch (of_reconfig_get_state_change(action, rd)) {
>         case OF_RECONFIG_CHANGE_ADD:
> -               /* verify that the parent is a bus */
> -               if (!of_node_check_flag(rd->dn->parent, OF_POPULATED_BUS)=
)
> +               parent =3D rd->dn->parent;
> +               /* verify that the parent is a bus (or the root node) */
> +               if (!of_node_is_root(parent) &&

Parent =3D /soc, so this returns early. Hence of_changeset_apply() [2]
didn't add the I2C mux bus, causing of_get_i2c_adapter_by_node() [3]
to fail.

> +                   of_node_check_flag(parent, OF_POPULATED_BUS))

Oh, you inverted the check for of_node_check_flag(); was that
intentional?  Re-adding the "!" fixes all issues for me.

>                         return NOTIFY_OK;       /* not for us */
>
>                 /* already populated? (driver using of_populate manually)=
 */
> @@ -749,7 +752,7 @@ static int of_platform_notify(struct notifier_block *=
nb,
>                  */
>                 rd->dn->fwnode.flags &=3D ~FWNODE_FLAG_NOT_DEVICE;
>                 /* pdev_parent may be NULL when no bus platform device */
> -               pdev_parent =3D of_find_device_by_node(rd->dn->parent);
> +               pdev_parent =3D of_find_device_by_node(parent);
>                 pdev =3D of_platform_device_create(rd->dn, NULL,
>                                 pdev_parent ? &pdev_parent->dev : NULL);
>                 platform_device_put(pdev_parent);

[1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.g=
it/tree/arch/arm64/boot/dts/renesas/r8a77990-ebisu-cn41-msiof0-25lc040.dtso=
?h=3Dtopic/renesas-overlays
[2] https://elixir.bootlin.com/linux/latest/source/drivers/i2c/muxes/i2c-de=
mux-pinctrl.c#L60
[3] https://elixir.bootlin.com/linux/latest/source/drivers/i2c/muxes/i2c-de=
mux-pinctrl.c#L64

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
