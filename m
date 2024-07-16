Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445C7208D0
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721129052; cv=none; b=nVfFX501KqCzBYXaD9XJd2f8SCrjCku4MBs+xOlEj99E7IiOQrK2XyUNPh+IjgaDsAxcU3msOHZk8Y31GQTKj1aU6uYaA5TlLBfltDnVrFY/d4t4vBIwm28kbiuZY+o+fE9a7izqqRMVtll2KTAPo5DuMrPdwcguPS8LkjvRVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721129052; c=relaxed/simple;
	bh=UlbGu3EkA+Lvmf3I3klsx8B2VOESek2LOyeDAUqvLIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5aDVBEZsLLyAIoRlXkatJN2KFLKCHcdyU7J9ycNmnDkPlgTTpHVfLJtTEQXwde7KX6nWwBFu1echIUgP/EIodBIH1E0XF1Pl/nnbwoTj4lGc1aFsetSHbS0JgYtdXoXoAvQN4ANXNEXk10DUW6XSePw/4SctR9lkXJU6+PKGWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-65f8b0df1f0so28466397b3.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 04:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721129049; x=1721733849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tEqgeyPZzEuby1pRGoux5oH5BnRs53yKaWTX95zMy4=;
        b=HGve41A7h7BWdj7fr8vTXczruAZ5n+KC2JMrZrO1YhHqID4wd/hzR/dtii0P8WOG62
         sPes/rb3oxvPZb9Z2jHNjulptT8kXN7kZIwcoCjxF4LaBWYKJRfW7xWPvKid7Q7fS49N
         1LWxHkUG7IjlOjfOx2V/CggbIxRJKZUoWW3TTT6aVHZoVKc38xEc0nM9Pq6AFqdG+1Ag
         3YewdfQFzRuzX6O1wgqAfAQWw42LQMn5fbsPm823/i08bIFQGgVaR4SOCo9J+pOtr5yu
         abAM68AEt1jpxHYBY933wcIaI8zKp18irphUk0MVw1K2qTqOec0ScgrUKsfqXXwXgi78
         QbPw==
X-Forwarded-Encrypted: i=1; AJvYcCWudaBQ3kI5CqHRg3GMFEr+JHwPOYSNQuqCfF3YkSg3WnrjTi9DY1VbwgdmjqDICNchv5T7OBn/PWcQ+vKu47O/RLJv5rOpMg==
X-Gm-Message-State: AOJu0YyKa1NMrv9drzKrcqUz8BZAkNVoLAIUu0m5uKpfxLE/7omliqrK
	H1E5a1xvINx60DXDWubLXA3Q2CUokW3uxkmCo7Pmj2E+RbjdRod7xgY3vG1H
X-Google-Smtp-Source: AGHT+IEeu6SeAmt2lRsunuKApH1e6OpNioPNKKeaDy9bpMkEtPUqVKnEE30ZS8q2Kos3FA8EZIkkqQ==
X-Received: by 2002:a05:690c:d94:b0:64a:79f6:2f2d with SMTP id 00721157ae682-66381105a8fmr23261457b3.31.1721129048794;
        Tue, 16 Jul 2024 04:24:08 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-65fc26104acsm11209097b3.30.2024.07.16.04.24.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 04:24:08 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-64789495923so49540217b3.0
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 04:24:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWM5QZ+TD7Gk0uNvvKKKDCAMlC94ng6eGkvdbT/G3zA4Z6M953Gkjub98LxrZL5Ck3PjDGchxxXBm+8vUmspyHWpqVbiWUoaw==
X-Received: by 2002:a05:690c:ece:b0:64a:3e36:7fd1 with SMTP id
 00721157ae682-6637f2bc7c4mr23335497b3.10.1721129048431; Tue, 16 Jul 2024
 04:24:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710201246.1802189-1-sboyd@kernel.org> <20240710201246.1802189-2-sboyd@kernel.org>
 <CAMuHMdV56nezM9cj1bVo4+gqi0OPvKjktu7i4Ov9ZKeyNkoiOg@mail.gmail.com>
In-Reply-To: <CAMuHMdV56nezM9cj1bVo4+gqi0OPvKjktu7i4Ov9ZKeyNkoiOg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 Jul 2024 13:23:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV9EwBgmNYP9jZBZKNNn0ZX2XErcyeXu1xatFdBVzdXmw@mail.gmail.com>
Message-ID: <CAMuHMdV9EwBgmNYP9jZBZKNNn0ZX2XErcyeXu1xatFdBVzdXmw@mail.gmail.com>
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

On Tue, Jul 16, 2024 at 11:48=E2=80=AFAM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Jul 10, 2024 at 10:14=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> =
wrote:
> > We'd like to apply overlays to the root node in KUnit so we can test
> > platform devices created as children of the root node.
> >
> > On some architectures (powerpc), the root node isn't marked with
> > OF_POPULATED_BUS. If an overlay tries to modify the root node on these
> > platforms it will fail, while on other platforms, such as ARM, it will
> > succeed. This is because the root node is marked with OF_POPULATED_BUS
> > by of_platform_default_populate_init() calling
> > of_platform_default_populate() with NULL as the first argument.
> >
> > Loosen the requirement here so that platform devices can be created for
> > nodes created as children of the root node via DT overlays even if the
> > platform bus wasn't populated for the root node.
> >
> > Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> > Cc: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>

> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -732,11 +732,14 @@ static int of_platform_notify(struct notifier_blo=
ck *nb,
> >         struct of_reconfig_data *rd =3D arg;
> >         struct platform_device *pdev_parent, *pdev;
> >         bool children_left;
> > +       struct device_node *parent;
> >
> >         switch (of_reconfig_get_state_change(action, rd)) {
> >         case OF_RECONFIG_CHANGE_ADD:
> > -               /* verify that the parent is a bus */
> > -               if (!of_node_check_flag(rd->dn->parent, OF_POPULATED_BU=
S))
> > +               parent =3D rd->dn->parent;
> > +               /* verify that the parent is a bus (or the root node) *=
/
> > +               if (!of_node_is_root(parent) &&
> > +                   of_node_check_flag(parent, OF_POPULATED_BUS))
>
> Oh, you inverted the check for of_node_check_flag(); was that
> intentional?  Re-adding the "!" fixes all issues for me.

I have sent a fix.
https://lore.kernel.org/a9ada686e1f1c6f496e423deaf108f1bcfd94d7d.1721123679=
.git.geert+renesas@glider.be/

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
