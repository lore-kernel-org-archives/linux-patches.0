Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882603DCDA1
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 07:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783324385; cv=none; b=V9vWtS6QxkAZphyfz5pWmPWwAq+c1IRUPnkS2PA9dg9NTa4pXJGNrosFjgZZBYJT9usm9PJUbtJ9vUU0S/wxlg/gejeEpQiIT2l2zc9/vI2vjLn3f2/qUVRtTOzFHTefPxKNRWtKGSQuyzjr0DsuY/Hvfa+jyxGGRKWYuTzlYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783324385; c=relaxed/simple;
	bh=M0/CdQ2hWlEsNpX+uvlrz2p+fcJUmzcvLY/hJKYzvCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jTpHP7A54awgwLLRL2euycYp6sGC32kDxwL73az+PuXa4YKnpkyCyAn/0TfWhZxyC5gfe5cnWK+WMnXq47RVbsjjB+yqMSNK5sRcFInWZP2GiCKvX4DoX8R6DYbi9d/50wP03jA0z5f1cZZfTiC7g0nppQagDao0+pCftFNNFCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-96950b34a3eso630363241.0
        for <patches@lists.linux.dev>; Mon, 06 Jul 2026 00:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783324380; x=1783929180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xh4P/7d1HtdDB3vmst4Juu+8bmd5NKznkNS5EpUXno=;
        b=ddw3VqTQn442bG2IHNHwn8gBG2rXlB7SAGx/pyA3+uFtcVfg9PYTAKQuxQOFFmu4Qs
         5JKHIoTmNY0pCMM4L98W7kTBgvCqQE4nIIABNZNQXf7PbWsFIJsBno101UabOC3i1ReV
         TBXDshM9MH/v03XB4JCk4QUdwj1Dm2NnujlqxRyDoODWKTxZagchVC0Al/qZfltYi0Td
         EuPbMEMW2Hkhs2tXPqTy/iajMpKA8d2zZwR0C7GVg0taEPJUrmdoOtsDZl/u+enygrna
         UEp78L8N+3OVUestIE5/Ssd+D2oqZaruFS50wggkXK0tXnFBNWtqOso0xrJhe+wzG0fS
         GOSw==
X-Forwarded-Encrypted: i=1; AHgh+RotEfg9y+PWkPMFlLT0QvXzD84Z7vlQ7znYdiILniUB0tjN+gDFZBG1zKSDVhTsSYMJVCquZy9c@lists.linux.dev
X-Gm-Message-State: AOJu0YykueupXgdsNLxZsa7grF3MV9AlTipUgEX2kJ3o+Quqid48ujQO
	ipUZasAso84C3ZHaVYwgfWSMO8XsCv7b2/5tUJw0GAtC+/QD2socfDBiz1+FOkOJ
X-Gm-Gg: AfdE7ckSCI5LvosZrwKwsIWx1cLx/3XqWTeTFMcf791Nm6et9pw+JQt5CjU+0TRXoC7
	lHk0v8Y1SGacV7u2FwiN4QIwUmm6PqVi4Dp87nSa3zVBfwCByRBjmf1JN5iB5Mthtz+FPJqj/EW
	fQiyxo/NMwGgy2elalBPH9hKJrIOPRYg4LYabKRDvfsqYjqQSmpiZ4uUAihnkV0QHZn4dfn5amF
	PG4ZRtPj8LUy4iYBardR69u8osH0CyLsk3ka6cIx+s2snPd/HljVMmePXDa+Mz3/XVd9bDM3hI2
	VxfAzradPHDumb0jZ5mG9dicmmTKYqPjpAZODfJ+SlD7OdruxoNGD5yEIELro9S3YIGKSGIPt9k
	pDWS2Uc4YbhC9UtNSHT4Gv00PjWVGT0qGoME4HqpNaA0AIPesQ0aWM2T7LUJCs+FjYi4ricW9cP
	IgDsvV1KO2lChrmGfERf4cqeXDC6l97jWc9uSykd72G9DX2A9I7bfU5Q==
X-Received: by 2002:a05:6102:441e:b0:739:71ef:d772 with SMTP id ada2fe7eead31-7427bb6d1f5mr2584304137.4.1783324374768;
        Mon, 06 Jul 2026 00:52:54 -0700 (PDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-969839dc372sm5002047241.9.2026.07.06.00.52.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 00:52:54 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5bbc717c52aso742904e0c.0
        for <patches@lists.linux.dev>; Mon, 06 Jul 2026 00:52:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr22kdAyaTTHEWXxNncjQLszSVF3A5Cdvp/jAtQQJwffbHvx6Aezm/0FVTvLMNrJ9WqzqV4Exl9@lists.linux.dev
X-Received: by 2002:a05:6122:550:b0:59c:b1f7:4df3 with SMTP id
 71dfb90a1353d-5be102ec434mr2791159e0c.12.1783324373810; Mon, 06 Jul 2026
 00:52:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260702155108.949633242@linuxfoundation.org> <20260702155110.958322610@linuxfoundation.org>
 <ed0c9af450494df5f7bfd72670754c8e48e1f36d.camel@decadent.org.uk>
In-Reply-To: <ed0c9af450494df5f7bfd72670754c8e48e1f36d.camel@decadent.org.uk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 6 Jul 2026 09:52:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWEVCxK3gPCrD5cTAsGguE6WOJ8sAHMrX_Ba992gkKubg@mail.gmail.com>
X-Gm-Features: AVVi8CcBna7djcvUVCHqavMy8dwrPHmBT7hVzDDa8jlPMmxq2pCY8JhUDX6MQ3E
Message-ID: <CAMuHMdWEVCxK3gPCrD5cTAsGguE6WOJ8sAHMrX_Ba992gkKubg@mail.gmail.com>
Subject: Re: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, 
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Ulf Hansson <ulfh@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

On Mon, 6 Jul 2026 at 00:15, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Thu, 2026-07-02 at 18:20 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >
> > [ Upstream commit f48ee49726ee4ab545fd2dc644f169c0809b19b3 ]
> >
> > The RZ/G2H (R8A774E1) SoC was previously handled via the generic
> > "renesas,rcar-gen3-sdhi" fallback compatible string. However, because
> > the SDHI IP on RZ/G2H is identical with the R-Car H3-N (R8A77951), it
> > requires the specific quirks and configuration defined in
> > `of_r8a7795_compatible` rather than the generic Gen3 data.
>
> But this backport maps it to the generic Gen3 data, so I'm wondering
> what the point of it is?

Nice catch!

Indeed, the upstream commit depends on commit 71b7597c63d2ddf6 ("mmc:
renesas_sdhi: Refactor renesas_sdhi_probe()") in v5.15.

For v5.10, I think you need to add a line

    { .soc_id = "r8a77e1", .revision = "ES3.*", .data =
&sdhi_quirks_bad_taps2367 },

to sdhi_quirks_match[] in drivers/mmc/host/renesas_sdhi_core.c instead.

> > --- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
> > +++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
> > @@ -119,6 +119,7 @@ static const struct renesas_sdhi_of_data
> >  static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
> >       { .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
> >       { .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
> > +     { .compatible = "renesas,sdhi-r8a774e1", .data = &of_rcar_gen3_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7795", .data = &of_rcar_gen3_compatible, },
> >       { .compatible = "renesas,sdhi-r8a7796", .data = &of_rcar_gen3_compatible, },
> >       { .compatible = "renesas,rcar-gen3-sdhi", .data = &of_rcar_gen3_compatible, },


Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
