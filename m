Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D79C25776
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705585501; cv=none; b=J4NL0mqr1OiM7g9iSifFFdRj+WLO/5QbjQhPjvnHweRTCvWc17VdQ345xTpfhnb3ra4XNZc46aGmKpXxaJaLaw5iYel9AbEMZJF/CAu7Rmsd36bK0poW0kcSlkEwoswIFrxjreLadDFzXCNBCSVjuA81Bb9hUBcF3LmvpNJaIaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705585501; c=relaxed/simple;
	bh=gT28Fh3wl8eP/Ljj2XHYVD5ng9wv0/Gy376PoOmymDk=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=plqmY8mHYzJ5uRkmDqJFfFD/09pyatoWE3Surq3+f7lkkrvxLub5BB8AYW7hKp2GW9cgIVURA1yJJSqK4c0jgsttofENRpqG72bSIltDZU9EpkX+3dxfHIf+5UiKt9+cv6nAhdYAvThw5nouXxu55sqKvXYrXvRmkQdXSwetihY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+3MZbe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+3MZbe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB458C43390
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705585500;
	bh=gT28Fh3wl8eP/Ljj2XHYVD5ng9wv0/Gy376PoOmymDk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u+3MZbe8ibF/PsJaydFqyRJp8ldbVeNDlHnif9pS4/4cGJp0RDYpZPhpESX+qacPH
	 onPkEixPpCI3mbAQKsqT0BLkRVtfsZwSSr2vEPj79v1OGDs/jP3+P2iwCV9iefkdef
	 6QFcZms6XzJ8vIAUbW2367Ls8jD8nMfDaMUStiiTGymyegb1QmsgMVKR0Efw0kOD2X
	 THGk7SORQtBkEz0/HgFmjH97kcFVNO6kgR6k42jCF/B5U7i9ivjOs0RtUs84cdmoqb
	 1k6B1051EFaLPbHRejKw8QHcE007AYh4dLHDYkq67M+cnoRyuHj1bOBwTNVMa0pDs1
	 6N9eImRIzo7Qg==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2cd2f472665so130420161fa.2
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 05:45:00 -0800 (PST)
X-Gm-Message-State: AOJu0YyCE4aV2cHLgTlMW/8CLkfmh2A9fEBGg+AgYrKTCYNp2VNtyIv3
	3mvsiBi8dqOboCuk4WICrZiOCA+y3A/wyq9zhkzuVNreUlwYATKPuZ2ac5hvnmarWPVaLFHQEUG
	jpbP0uABJA14oIcRMPkpZTTM8Kg==
X-Google-Smtp-Source: AGHT+IHanadODpHlW5kv28ZPQQm1BxNO/Q4y3N+LkzY5cQvNMtQPZvXZQU5q6BYEcqxNmpGoLRuQA+l7epkP//J5f0Q=
X-Received: by 2002:a05:651c:107:b0:2cd:9e6c:7f3f with SMTP id
 a7-20020a05651c010700b002cd9e6c7f3fmr625521ljb.71.1705585498933; Thu, 18 Jan
 2024 05:44:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240112200750.4062441-1-sboyd@kernel.org> <20240112200750.4062441-5-sboyd@kernel.org>
 <20240115203230.GA1439771-robh@kernel.org> <cdaadf62222a705cda198dd96dc7c73d.sboyd@kernel.org>
 <20240117174114.GA2779523-robh@kernel.org> <CAMuHMdXg1Y7mwHKTYi_j7a_XGdMJ7Aa7u5dEv5+xsLe8=BMaRw@mail.gmail.com>
In-Reply-To: <CAMuHMdXg1Y7mwHKTYi_j7a_XGdMJ7Aa7u5dEv5+xsLe8=BMaRw@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 18 Jan 2024 07:44:46 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLO89y6577ACi7s4Zhpexszp3Bby=tKMEoDGzK9MY+9Bw@mail.gmail.com>
Message-ID: <CAL_JsqLO89y6577ACi7s4Zhpexszp3Bby=tKMEoDGzK9MY+9Bw@mail.gmail.com>
Subject: Re: [PATCH 4/6] of: Create of_root if no dtb provided by firmware
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Boyd <sboyd@kernel.org>, Frank Rowand <frowand.list@gmail.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Simon Glass <sjg@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 2:46=E2=80=AFAM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
>
> Hi Rob,
>
> On Wed, Jan 17, 2024 at 6:41=E2=80=AFPM Rob Herring <robh@kernel.org> wro=
te:
> > On Tue, Jan 16, 2024 at 05:18:15PM -0800, Stephen Boyd wrote:
> > > Quoting Rob Herring (2024-01-15 12:32:30)
> > > > On Fri, Jan 12, 2024 at 12:07:47PM -0800, Stephen Boyd wrote:
> > > > > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > > > > index da9826accb1b..9628e48baa15 100644
> > > > > --- a/drivers/of/Kconfig
> > > > > +++ b/drivers/of/Kconfig
> > > > > @@ -54,9 +54,14 @@ config OF_FLATTREE
> > > > >       select CRC32
> > > > >
> > > > >  config OF_EARLY_FLATTREE
> > > > > -     bool
> > > > > +     bool "Functions for accessing Flat Devicetree (FDT) early i=
n boot"
> > > >
> > > > I think we could instead just get rid of this kconfig option. Or
> > > > always enable with CONFIG_OF (except on Sparc). The only cost of
> > > > enabling it is init section functions which get freed anyways.
> > >
> > > Getting rid of it is a more massive change. It can be the default and
> > > kept hidden instead? If it can't be selected on Sparc then it should =
be
> > > hidden there anyway.
> >
> > The easier option is certainly fine for this series. I just don't want
> > it visible.
> >
> > > > >       select DMA_DECLARE_COHERENT if HAS_DMA && HAS_IOMEM
> > > > >       select OF_FLATTREE
> > > > > +     help
> > > > > +       Normally selected by platforms that process an FDT that h=
as been
> > > > > +       passed to the kernel by the bootloader.  If the bootloade=
r does not
> > > > > +       pass an FDT to the kernel and you need an empty devicetre=
e that
> > > > > +       contains only a root node to exist, then say Y here.
> > > > >
> > > > >  config OF_PROMTREE
> > > > >       bool
> > > [...]
> > > > > @@ -195,6 +191,17 @@ static inline int of_node_check_flag(const s=
truct device_node *n, unsigned long
> > > > >       return test_bit(flag, &n->_flags);
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * of_have_populated_dt() - Has DT been populated by bootloader
> > > > > + *
> > > > > + * Return: True if a DTB has been populated by the bootloader an=
d it isn't the
> > > > > + * empty builtin one. False otherwise.
> > > > > + */
> > > > > +static inline bool of_have_populated_dt(void)
> > > > > +{
> > > > > +     return of_root !=3D NULL && !of_node_check_flag(of_root, OF=
_EMPTY_ROOT);
> > > >
> > > > Just a side comment, but I think many/all callers of this function =
could
> > > > just be removed.
> > > >
> > > > I don't love new flags. Another possible way to handle this would b=
e
> > > > checking for "compatible" being present in the root node. I guess t=
his
> > > > is fine as-is for now at least.
> > >
> > > Ok. I can add a check for a compatible property. That's probably bett=
er
> > > anyway. Should there be a compatible property there to signal that th=
is
> > > DT isn't compatible with anything? I worry about DT overlays injectin=
g a
> > > compatible string into the root node, but maybe that is already
> > > prevented.
> >
> > I worry about DT overlays injecting anything...
> >
> > I don't think it is explicitly forbidden, but I have asked that any
> > general purpose interface to apply overlays be restricted to nodes
> > explicitly allowed (e.g. downstream of a connector node). For now, the
> > places (i.e. drivers) overlays are applied are limited.
> >
> > We could probably restrict the root node to new nodes only and no new
> > or changed properties.
>
> Changing (<wild dream>or appending to</wild dream>) the root
> "compatible" and/or "model" properties is useful in case of large
> extension boards, though.  This is also the case for DTBs created from
> a base DTB and one or more overlays using fdtoverlay.

I think appending by adding another compatible value could be okay.
Removing or appending to an existing entry is not. We don't want the
following sequence to be possible:

of_machine_is_compatible("foo") --> true
apply overlay
of_machine_is_compatible("foo") --> false

For Stephen's case, it's going from no root compatible at all to
something. I don't think your case would apply here. To put it another
way, if we've booted with ACPI, compatible in the root node is not
valid.


> For the latter, see also the following threads, where you weren't
> (but probably should have been) CCed:
>
> [1] "[PATCH v9 2/2] arm64: boot: Support Flat Image Tree"
>      https://lore.kernel.org/all/20231202035511.487946-3-sjg@chromium.org
> [2] "Proposal: FIT support for extension boards / overlays"
>     https://lore.kernel.org/all/CAPnjgZ06s64C2ux1rABNAnMv3q4W++sjhNGCO_uP=
MH_9sTF7Mw@mail.gmail.com

That all seems pretty orthogonal to the issues here.

Rob
