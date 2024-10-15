Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3A818A6CC
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728976050; cv=none; b=QXHykChA+IQlPTqxWJ54JPbkIeMruppaRI6g724sMvrhskIVuFVDZTnX7yaz3qgSPwz+O7OZsypOoNXJYLIiem9VJS+aRGXMlu3hQxA3Wh9dXBOMu4K9cpVIdYLw/U0Ik1KUpODwC3jCxMkTtiLPvX/APMpQjJTlGO0g8ijD1aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728976050; c=relaxed/simple;
	bh=6dfEGaajQa2pJMeZNL7rrar7W6Le7Lr83zfKbQPXDzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bm/Aaq7BvgOwZ0ZxCjZBEpySMD2BMBsmVv9QmPrqjuiZjYAciP/sCgQYBeNUwhsIMIDwOfaUO9QPWdDj0Zz/8p4cHysVDZn3X/czqb0XLLswOJmlKSB+ZU9JqKJhqV5cmvKx4M98xTDhUkWhowe8DiDJZ5eFodXTKWOf2wuzkt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e28fe3b02ffso4335332276.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728976047; x=1729580847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNBLoVY7KmTb//gQvb+nY+loZrEE+K14uHe+vpf2a3w=;
        b=BGQukImp/iN2MnZh7QCfidGf/bcai0YifdGZ0Ff//918Eu5M98p6tlpFoWdA/0B2If
         h055ZQku96i86ugD04B/nsZEB5EHa0S98duyUTxlv05tfJ/r5TrIaUU7YImTdBmijSvl
         wL02GMVJoSNRZrW64uZEYjcyd7ru3SPpDKSdGA1cZWL90fluWRvyevXxZAVlGkt+M1Fg
         i04+G70aL0bvS0P1TXR2DDsOicVSP/l8k/KschSbJNWsp/YgMk9IqJwEzbEKqbjgG4lH
         EWrtklkese+TbPsQsFyCpv8cvJTIet7EHOqTyh+AAFuYGEedO70XrM4lNvZn2bDKTyet
         qIDw==
X-Forwarded-Encrypted: i=1; AJvYcCVEqySqxM2gQvFY0czCba9iK+FMg0lS3y3o0Ma48Hsk7vyxjygmO/HOwSzrtg9pJT2E9amDnfit@lists.linux.dev
X-Gm-Message-State: AOJu0YwW3M18sXXZu/e9hJD7VRFYZH+0wqJ1SEV9AaFCJA8ye6K2vR6m
	cbLe8IDNZasryIEf838TmthEQHLFDtBaJHuX+ZQpaSnPP603RwvCqY47Wwor
X-Google-Smtp-Source: AGHT+IF2QvXYeJSymsP5Bh9TeBINf4IP67SdSZk+/DbNWBDeecPjxEUQV3QtMagxeOljBy/YEOpdYg==
X-Received: by 2002:a05:6902:2809:b0:e28:f402:cc6f with SMTP id 3f1490d57ef6-e2919febfbfmr8260952276.46.1728976047402;
        Tue, 15 Oct 2024 00:07:27 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e296cbfaf41sm151435276.5.2024.10.15.00.07.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 00:07:26 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6dbb24ee2ebso51657297b3.1
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:07:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUHtdOaFyJz+Zfqmz+x4ULfGN/33xj7eJry39RF49oNCyapmckib573k8C53LahaZ1jAoDNRgrE@lists.linux.dev
X-Received: by 2002:a05:690c:5302:b0:6e2:43ea:55f with SMTP id
 00721157ae682-6e347c68ffbmr75778377b3.38.1728976046499; Tue, 15 Oct 2024
 00:07:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141217.941104064@linuxfoundation.org> <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
 <CAMuHMdVHLiB7PWji9uRLZNWqFa1r7NiTv9MWCCAg=3-924M7tA@mail.gmail.com>
In-Reply-To: <CAMuHMdVHLiB7PWji9uRLZNWqFa1r7NiTv9MWCCAg=3-924M7tA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Oct 2024 09:07:14 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVcE1Wvi+g5P5CEe5RFEuBfSCmR+7HFVfiC1rG6bHdesA@mail.gmail.com>
Message-ID: <CAMuHMdVcE1Wvi+g5P5CEe5RFEuBfSCmR+7HFVfiC1rG6bHdesA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, 
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, Oleksij Rempel <o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC Oleksij

On Tue, Oct 15, 2024 at 9:06=E2=80=AFAM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> On Tue, Oct 15, 2024 at 7:32=E2=80=AFAM Jon Hunter <jonathanh@nvidia.com>=
 wrote:
> > On 14/10/2024 15:09, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.113 release.
> > > There are 798 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.1.113-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > -------------
> > > Pseudo-Shortlog of commits:
> >
> > ...
> >
> > > Oleksij Rempel <linux@rempel-privat.de>
> > >      clk: imx6ul: add ethernet refclock mux support
> >
> >
> > I am seeing the following build issue for ARM multi_v7_defconfig and
> > bisect is point to the commit ...
> >
> > drivers/clk/imx/clk-imx6ul.c: In function =E2=80=98imx6ul_clocks_init=
=E2=80=99:
> > drivers/clk/imx/clk-imx6ul.c:487:34: error: implicit declaration of fun=
ction =E2=80=98imx_obtain_fixed_of_clock=E2=80=99; did you mean =E2=80=98im=
x_obtain_fixed_clock=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >    hws[IMX6UL_CLK_ENET1_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node=
, "enet1_ref_pad", 0);
> >                                    ^~~~~~~~~~~~~~~~~~~~~~~~~
> >                                    imx_obtain_fixed_clock
> > drivers/clk/imx/clk-imx6ul.c:487:32: warning: assignment makes pointer =
from integer without a cast [-Wint-conversion]
> >    hws[IMX6UL_CLK_ENET1_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node=
, "enet1_ref_pad", 0);
> >                                  ^
> > drivers/clk/imx/clk-imx6ul.c:489:34: error: implicit declaration of fun=
ction =E2=80=98imx_clk_gpr_mux=E2=80=99; did you mean =E2=80=98imx_clk_hw_m=
ux=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >    hws[IMX6UL_CLK_ENET1_REF_SEL] =3D imx_clk_gpr_mux("enet1_ref_sel", "=
fsl,imx6ul-iomuxc-gpr",
> >                                    ^~~~~~~~~~~~~~~
> >                                    imx_clk_hw_mux
> > drivers/clk/imx/clk-imx6ul.c:489:32: warning: assignment makes pointer =
from integer without a cast [-Wint-conversion]
> >    hws[IMX6UL_CLK_ENET1_REF_SEL] =3D imx_clk_gpr_mux("enet1_ref_sel", "=
fsl,imx6ul-iomuxc-gpr",
> >                                  ^
> > drivers/clk/imx/clk-imx6ul.c:492:32: warning: assignment makes pointer =
from integer without a cast [-Wint-conversion]
> >    hws[IMX6UL_CLK_ENET2_REF_PAD] =3D imx_obtain_fixed_of_clock(ccm_node=
, "enet2_ref_pad", 0);
> >                                  ^
> > drivers/clk/imx/clk-imx6ul.c:494:32: warning: assignment makes pointer =
from integer without a cast [-Wint-conversion]
> >    hws[IMX6UL_CLK_ENET2_REF_SEL] =3D imx_clk_gpr_mux("enet2_ref_sel", "=
fsl,imx6ul-iomuxc-gpr",
>
> Missing backports of the other clock-related patches in the original
> series[1]?
> imx_obtain_fixed_clock() was introduced in commit 7757731053406dd0
> ("clk: imx: add imx_obtain_fixed_of_clock()"), but some of the other
> patches from that series may be needed, too?
>
> [1] https://lore.kernel.org/all/20230131084642.709385-1-o.rempel@pengutro=
nix.de/

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
