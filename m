Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2552518A6C8
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728975996; cv=none; b=gWoC9T8lDRNp7hr+9HhRsOupKUuu8DXOr4Uh9/P/B16B6/MAXvcJ+M5Uo9ss0Aaw7vonDd8Ud+PUPAOrHCfl10Aevjy4XA7TDbLuTT8QqFAQBaY7okqRyO/G9rQL1ApATh1YDL03C/jeySqqx43d04N6y8Ogu/KRCqOzPxKIQfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728975996; c=relaxed/simple;
	bh=LYPJDKAOIaphEy92xgvTYRFt9LgukmQ/k1PhfTyENkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SITRGDantSsyfNRJdUyTvOKMLd9srAY9upVShW7a+SFsA0Ii/hTq5eL4s2MGBml+yRwdROLyPv3FMlNYV3e/IETrY4ygGINHIjnZyMxi9vQxcg97hylncrf8RKMm2iZbrWAoYQ5OdDQlbjWi8/fTqZCiZ9cEQzJGojLPuSO/sjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e2903a48ef7so4694578276.2
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728975992; x=1729580792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RjXNxhe4YkjVhl5J3HDsDQslVdlFO3kMOqAyUlL8DnU=;
        b=dmLWdbfZAlBKQMSWFAs+KGlB47BdEHFiRdVWXNdAVcsqrTGO8J2x2EBeY4wjM4lKPO
         jmx1bmRVS/jBQUF1P22xV10NcvC0DuKwJcfL5bA++65fQxgQc4K5h3t/48GWcW2yT31S
         0w6Wko90jBVBMnh5u9KdG8WOXP9GuRSIQMf1Eu189hc2ZbUd+805uK+7GPQlTuNCFsp8
         EjAdI3SvKmykmGbde+MfbNVscWpr2EOmpNr3uk2+vBEA0Jkj07ZoSFxv7F9WevOq0+qM
         GJH+R9yooVQj77eJR/E+sP1U7iAfjtzchXZ9Ozkh/yq6HwO3Oq1UZO7k0aM8LmJ2sBzk
         Vkbw==
X-Forwarded-Encrypted: i=1; AJvYcCWfQy3NG84Go174iwWqgu39hlY0JK2kYR9w8GFR5i7sVc4vbxvh0wRbwgb9ZnGkrAMNwbIpdsVc@lists.linux.dev
X-Gm-Message-State: AOJu0YyNLEiuNdy5kvoot+4mjvwvBeMawRSx/zAcdta8UBzYgXaLTySW
	34KNSPBcICpdSV7PaPIBHCoO6oTHz0wc5VQuWsZ2nqU3lKp4ZgQbEdkRiEYG
X-Google-Smtp-Source: AGHT+IHMhQ+sHXzwLurVtcb1gY4vZbs1n1KhNRnGM5EqHPKNv8oL+tbS9gL4/k9Skz+nq4UZe7Xq0g==
X-Received: by 2002:a25:aac8:0:b0:e29:20a6:b8d4 with SMTP id 3f1490d57ef6-e2920a6b993mr8151586276.18.1728975992403;
        Tue, 15 Oct 2024 00:06:32 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e296cc09a24sm139973276.21.2024.10.15.00.06.31
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 00:06:31 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6dde476d3dfso41725297b3.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:06:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWFjSZ4Ql4wVc2yYJhCnMMr4ZrQ3C4JCEYnT+eCTwk1wA/fbwRMuLureu6asklVNMAPZ/YRgfTH@lists.linux.dev
X-Received: by 2002:a05:690c:5302:b0:6e2:43ea:55f with SMTP id
 00721157ae682-6e347c68ffbmr75764257b3.38.1728975990825; Tue, 15 Oct 2024
 00:06:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141217.941104064@linuxfoundation.org> <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
In-Reply-To: <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Oct 2024 09:06:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVHLiB7PWji9uRLZNWqFa1r7NiTv9MWCCAg=3-924M7tA@mail.gmail.com>
Message-ID: <CAMuHMdVHLiB7PWji9uRLZNWqFa1r7NiTv9MWCCAg=3-924M7tA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, 
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2024 at 7:32=E2=80=AFAM Jon Hunter <jonathanh@nvidia.com> w=
rote:
> On 14/10/2024 15:09, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.113 release.
> > There are 798 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.113-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
>
> ...
>
> > Oleksij Rempel <linux@rempel-privat.de>
> >      clk: imx6ul: add ethernet refclock mux support
>
>
> I am seeing the following build issue for ARM multi_v7_defconfig and
> bisect is point to the commit ...
>
> drivers/clk/imx/clk-imx6ul.c: In function =E2=80=98imx6ul_clocks_init=E2=
=80=99:
> drivers/clk/imx/clk-imx6ul.c:487:34: error: implicit declaration of funct=
ion =E2=80=98imx_obtain_fixed_of_clock=E2=80=99; did you mean =E2=80=98imx_=
obtain_fixed_clock=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    hws[IMX6UL_CLK_ENET1_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node, =
"enet1_ref_pad", 0);
>                                    ^~~~~~~~~~~~~~~~~~~~~~~~~
>                                    imx_obtain_fixed_clock
> drivers/clk/imx/clk-imx6ul.c:487:32: warning: assignment makes pointer fr=
om integer without a cast [-Wint-conversion]
>    hws[IMX6UL_CLK_ENET1_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node, =
"enet1_ref_pad", 0);
>                                  ^
> drivers/clk/imx/clk-imx6ul.c:489:34: error: implicit declaration of funct=
ion =E2=80=98imx_clk_gpr_mux=E2=80=99; did you mean =E2=80=98imx_clk_hw_mux=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    hws[IMX6UL_CLK_ENET1_REF_SEL] =3D imx_clk_gpr_mux("enet1_ref_sel", "fs=
l,imx6ul-iomuxc-gpr",
>                                    ^~~~~~~~~~~~~~~
>                                    imx_clk_hw_mux
> drivers/clk/imx/clk-imx6ul.c:489:32: warning: assignment makes pointer fr=
om integer without a cast [-Wint-conversion]
>    hws[IMX6UL_CLK_ENET1_REF_SEL] =3D imx_clk_gpr_mux("enet1_ref_sel", "fs=
l,imx6ul-iomuxc-gpr",
>                                  ^
> drivers/clk/imx/clk-imx6ul.c:492:32: warning: assignment makes pointer fr=
om integer without a cast [-Wint-conversion]
>    hws[IMX6UL_CLK_ENET2_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node, =
"enet2_ref_pad", 0);
>                                  ^
> drivers/clk/imx/clk-imx6ul.c:494:32: warning: assignment makes pointer fr=
om integer without a cast [-Wint-conversion]
>    hws[IMX6UL_CLK_ENET2_REF_SEL] =3D imx_clk_gpr_mux("enet2_ref_sel", "fs=
l,imx6ul-iomuxc-gpr",

Missing backports of the other clock-related patches in the original
series[1]?
imx_obtain_fixed_clock() was introduced in commit 7757731053406dd0
("clk: imx: add imx_obtain_fixed_of_clock()"), but some of the other
patches from that series may be needed, too?

[1] https://lore.kernel.org/all/20230131084642.709385-1-o.rempel@pengutroni=
x.de/

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
