Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E74E11CB6
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705567565; cv=none; b=D6H6dbYMORCpWmZ6J/4iOljsKQtrA/CWi498nm5DSGU8Pkg9nJvKhlbeKtKhOPu9tr3VdMTOYR+46spBvcwXxvtgr86qDuQq4f0etosXDqKDcCPLzOUpE97Q4u/jEEsmGQiQdLG+eN6Z2gqVnIctNYQfTJV/AysLdl0SjqpSllk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705567565; c=relaxed/simple;
	bh=01BoHNQA6T6yKlyGx8npZBgE/grUaHHDD/eN3XO2uNg=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Received:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding; b=ACd5yOOh+13nnfjQ/M/yMgZyUuSgKevLoYAxjUR1+2+EvBNpKqYDeatLfNlzuSdKjS/pZaiJ+SKcygxqTBDGUqZzzUdw1Vk63uakX08EZoZCYgSeuWIUQ4YJ3aM1StCFekFWAGw4WD//eqWIIHb9OzAVc+NHkJx9vQp45Rrq3Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-5f00bef973aso123974297b3.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 00:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705567562; x=1706172362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t8e3GAGk3S+G/Tg/kgQzOivmxsVaFHTxxZt1lcCM6Y4=;
        b=CxEkSU2I9oYSavl1p0AYLG9GcjHtKBs4EhlDO/UGLQuwtdjccvxngocJE3f193lMAE
         nprbX3E0lQqlL+HfBpXmwejgl04E7gAp4UvUHTTxb2i/bbpGH/W409aNM/z0jUWmlDeN
         SKcz80rcoRlA+f92zbbdTWQKXpVnyWF/mQw6I/75JNZWEDY1KQKVFNAjRUiVG4eoJizB
         tOir42UiCSuURlSTFsCkGlweRk2BAxihLuTM142jSatKyds/bG/ixWa18UAr2kSzOMO1
         KpiA2cTSWcdaP/PdVwBcPEjfVDi9a+HSSHI/lhsFlFB/ZrrG/owUv0+zHkrs0aqAL8yn
         L+yQ==
X-Gm-Message-State: AOJu0YyeamlX8aShHrrkPA5kBbuQqFimaz0n68ABZFmcyJpa9kY6Auvl
	lGuyro+/CvTTDHmkZZd6Il/xYYAaTzxNv9jOmP/ESK0BoTxUL1DiEyD8sVbGGF0=
X-Google-Smtp-Source: AGHT+IG0KMYoVUIfzOlsTqfipSWeKtxRZA994olAm5LeAzoSu0Ggp00aqTvKQK5guJetikoU5CII4Q==
X-Received: by 2002:a81:7103:0:b0:5f6:eb69:5e1e with SMTP id m3-20020a817103000000b005f6eb695e1emr449923ywc.57.1705567562387;
        Thu, 18 Jan 2024 00:46:02 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id i71-20020a0ddf4a000000b005ff7b0c45desm721851ywe.71.2024.01.18.00.46.01
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 00:46:01 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dbed4b84667so11582592276.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 00:46:01 -0800 (PST)
X-Received: by 2002:a5b:949:0:b0:dc2:41de:b744 with SMTP id
 x9-20020a5b0949000000b00dc241deb744mr333386ybq.32.1705567560920; Thu, 18 Jan
 2024 00:46:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240112200750.4062441-1-sboyd@kernel.org> <20240112200750.4062441-5-sboyd@kernel.org>
 <20240115203230.GA1439771-robh@kernel.org> <cdaadf62222a705cda198dd96dc7c73d.sboyd@kernel.org>
 <20240117174114.GA2779523-robh@kernel.org>
In-Reply-To: <20240117174114.GA2779523-robh@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 18 Jan 2024 09:45:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXg1Y7mwHKTYi_j7a_XGdMJ7Aa7u5dEv5+xsLe8=BMaRw@mail.gmail.com>
Message-ID: <CAMuHMdXg1Y7mwHKTYi_j7a_XGdMJ7Aa7u5dEv5+xsLe8=BMaRw@mail.gmail.com>
Subject: Re: [PATCH 4/6] of: Create of_root if no dtb provided by firmware
To: Rob Herring <robh@kernel.org>
Cc: Stephen Boyd <sboyd@kernel.org>, Frank Rowand <frowand.list@gmail.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Simon Glass <sjg@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Wed, Jan 17, 2024 at 6:41=E2=80=AFPM Rob Herring <robh@kernel.org> wrote=
:
> On Tue, Jan 16, 2024 at 05:18:15PM -0800, Stephen Boyd wrote:
> > Quoting Rob Herring (2024-01-15 12:32:30)
> > > On Fri, Jan 12, 2024 at 12:07:47PM -0800, Stephen Boyd wrote:
> > > > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > > > index da9826accb1b..9628e48baa15 100644
> > > > --- a/drivers/of/Kconfig
> > > > +++ b/drivers/of/Kconfig
> > > > @@ -54,9 +54,14 @@ config OF_FLATTREE
> > > >       select CRC32
> > > >
> > > >  config OF_EARLY_FLATTREE
> > > > -     bool
> > > > +     bool "Functions for accessing Flat Devicetree (FDT) early in =
boot"
> > >
> > > I think we could instead just get rid of this kconfig option. Or
> > > always enable with CONFIG_OF (except on Sparc). The only cost of
> > > enabling it is init section functions which get freed anyways.
> >
> > Getting rid of it is a more massive change. It can be the default and
> > kept hidden instead? If it can't be selected on Sparc then it should be
> > hidden there anyway.
>
> The easier option is certainly fine for this series. I just don't want
> it visible.
>
> > > >       select DMA_DECLARE_COHERENT if HAS_DMA && HAS_IOMEM
> > > >       select OF_FLATTREE
> > > > +     help
> > > > +       Normally selected by platforms that process an FDT that has=
 been
> > > > +       passed to the kernel by the bootloader.  If the bootloader =
does not
> > > > +       pass an FDT to the kernel and you need an empty devicetree =
that
> > > > +       contains only a root node to exist, then say Y here.
> > > >
> > > >  config OF_PROMTREE
> > > >       bool
> > [...]
> > > > @@ -195,6 +191,17 @@ static inline int of_node_check_flag(const str=
uct device_node *n, unsigned long
> > > >       return test_bit(flag, &n->_flags);
> > > >  }
> > > >
> > > > +/**
> > > > + * of_have_populated_dt() - Has DT been populated by bootloader
> > > > + *
> > > > + * Return: True if a DTB has been populated by the bootloader and =
it isn't the
> > > > + * empty builtin one. False otherwise.
> > > > + */
> > > > +static inline bool of_have_populated_dt(void)
> > > > +{
> > > > +     return of_root !=3D NULL && !of_node_check_flag(of_root, OF_E=
MPTY_ROOT);
> > >
> > > Just a side comment, but I think many/all callers of this function co=
uld
> > > just be removed.
> > >
> > > I don't love new flags. Another possible way to handle this would be
> > > checking for "compatible" being present in the root node. I guess thi=
s
> > > is fine as-is for now at least.
> >
> > Ok. I can add a check for a compatible property. That's probably better
> > anyway. Should there be a compatible property there to signal that this
> > DT isn't compatible with anything? I worry about DT overlays injecting =
a
> > compatible string into the root node, but maybe that is already
> > prevented.
>
> I worry about DT overlays injecting anything...
>
> I don't think it is explicitly forbidden, but I have asked that any
> general purpose interface to apply overlays be restricted to nodes
> explicitly allowed (e.g. downstream of a connector node). For now, the
> places (i.e. drivers) overlays are applied are limited.
>
> We could probably restrict the root node to new nodes only and no new
> or changed properties.

Changing (<wild dream>or appending to</wild dream>) the root
"compatible" and/or "model" properties is useful in case of large
extension boards, though.  This is also the case for DTBs created from
a base DTB and one or more overlays using fdtoverlay.

For the latter, see also the following threads, where you weren't
(but probably should have been) CCed:

[1] "[PATCH v9 2/2] arm64: boot: Support Flat Image Tree"
     https://lore.kernel.org/all/20231202035511.487946-3-sjg@chromium.org
[2] "Proposal: FIT support for extension boards / overlays"
    https://lore.kernel.org/all/CAPnjgZ06s64C2ux1rABNAnMv3q4W++sjhNGCO_uPMH=
_9sTF7Mw@mail.gmail.com

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
