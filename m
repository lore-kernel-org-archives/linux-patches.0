Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6807E579
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524382; cv=none; b=mY0Dk8aWf73TP9pz6T7ja0l/eeAXXLE56mxm5QQjFjs2tlPpmmQiQNSTD87jJ+lVQXY8HjCz87jUDpO0wkXYAFs3GbIvK3BVEmgB4I02jtKMAtNLb0Z2/f+zH2ptB76wpbtwnpnOT5i3eKlpHmDT70WRHE/iFyEQ/7Dln8o7Ry4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524382; c=relaxed/simple;
	bh=SpL2kvMci3BCJiem1BIyIcsSR8wgzqXdO4GroPnsjP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eb2N4vhXGNzMG410DjCsXL0OpmHCimPMCcSIriLs2tqdxKG+el5R1pRAq9+3LmKsDxj09McW57MXNvTOYtIwRkN9Pzwv8hT+Ah44Bql39zUc7elwX2ug/Qw2Rwy66qM3a68j/f/ojVb8ICvSLvDBYaAAGPPDVeCMvJzvtt3E7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quTqlShH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quTqlShH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51DFC43394
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708524382;
	bh=SpL2kvMci3BCJiem1BIyIcsSR8wgzqXdO4GroPnsjP4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=quTqlShH4LWCaBTZCyQx62hLzRwZVLko6t4suir8Ot2AOcWbSVtaZdamqaM7w58fp
	 DdbftVoCHsUCAtZrueBfz94C0QKag0ucP4UlPGWV03xB+JkTeRxT7Kq9hgc7NcsZXc
	 jdVQs71Al076uLZgmoSahZ0U4RfJj5YkVku8IV4GGdbBtx+pGpMdhZ8eAyp0Z+GWNI
	 ltQ8vrqQsV3IadYmjrgumJm2YIKXXDGjK7zP6SVgH1PoRvtuNWCUadyNVbSvnC7IKo
	 CWUmyo8zmuq8zIcdMAr4cQxUEbW3qmbUZIszTl3aXJCaXPVHDRD5aTkpo7iJrjg6vx
	 SyGzgnFgXWrrA==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d1080cba75so64225571fa.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 06:06:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWusUrbOZFLt/F7SCR4+DPndQm/pmenJtAKX3ANn3aMfSH7KN46TsLNNu4hLdRla39KkxJwtbcGdf91/aaxs4710Wefwwc81w==
X-Gm-Message-State: AOJu0YzTbnK3J+vFCfo5PZMkKl8GlUtxitw7U1/U/emHQAn9PoyU+ARE
	JRVgwmv0soaMxTsKIJttkKXgY4HBz6fNTLvxjEHUR72Uzhd4kDVZzbDN/ttNO90QER+bPGF2Z9a
	1y9i+s088vC40KclpmK8AH3MSFQ==
X-Google-Smtp-Source: AGHT+IHOSOSP7ipJG1AW58Fmxdj1uchlXs5YgDpmVhr8XeqjnmnNtuMuC8wFe5RgRdG+Eir4Pr5TzJCIR/BeGaQpP5A=
X-Received: by 2002:a05:651c:220b:b0:2d2:42d7:7d88 with SMTP id
 y11-20020a05651c220b00b002d242d77d88mr3092656ljq.22.1708524380920; Wed, 21
 Feb 2024 06:06:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217060843.GA16460@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20240217060843.GA16460@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 21 Feb 2024 07:06:08 -0700
X-Gmail-Original-Message-ID: <CAL_Jsq+Feu9NnzTNx=XU5vgHhibGAQXvkuTeWbpu8gJ3rVrzcw@mail.gmail.com>
Message-ID: <CAL_Jsq+Feu9NnzTNx=XU5vgHhibGAQXvkuTeWbpu8gJ3rVrzcw@mail.gmail.com>
Subject: Re: [PATCH 2/7] of: Create of_root if no dtb provided by firmware
To: Saurabh Singh Sengar <ssengar@linux.microsoft.com>
Cc: Frank Rowand <frowand.list@gmail.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 11:08=E2=80=AFPM Saurabh Singh Sengar
<ssengar@linux.microsoft.com> wrote:
>
> On Fri, Feb 16, 2024 at 05:05:51PM -0800, Frank Rowand wrote:
> > When enabling CONFIG_OF on a platform where 'of_root' is not populated
> > by firmware, we end up without a root node. In order to apply overlays
> > and create subnodes of the root node, we need one. Create this root nod=
e
> > by unflattening an empty builtin dtb.
> >
> > If firmware provides a flattened device tree (FDT) then the FDT is
> > unflattened via setup_arch(). Otherwise, the call to
> > unflatten(_and_copy)?_device_tree() will create an empty root node.
> >
> > We make of_have_populated_dt() return true only if the DTB was loaded b=
y
> > firmware so that existing callers don't change behavior after this
> > patch. The call in the of platform code is removed because it prevents
> > overlays from creating platform devices when the empty root node is
> > used.
> >
> > [sboyd@kernel.org: Update of_have_populated_dt() to treat this empty dt=
b
> > as not populated. Drop setup_of() initcall]
> >
> > Signed-off-by: Frank Rowand <frowand.list@gmail.com>
> > Link: https://lore.kernel.org/r/20230317053415.2254616-2-frowand.list@g=
mail.com
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > ---


> > @@ -1645,6 +1635,21 @@ static inline bool of_device_is_system_power_con=
troller(const struct device_node
> >       return of_property_read_bool(np, "system-power-controller");
> >  }
> >
> > +/**
> > + * of_have_populated_dt() - Has DT been populated by bootloader
> > + *
> > + * Return: True if a DTB has been populated by the bootloader and it i=
sn't the
> > + * empty builtin one. False otherwise.
> > + */
> > +static inline bool of_have_populated_dt(void)
> > +{
> > +#ifdef CONFIG_OF
> > +     return of_property_present(of_root, "compatible");
>
> This adds the strict check for compatible which makes compatible
> to be mandatory for root nodes. So far, DeviceTree without compatible
> property in root nodes can work. Do we want to make this documented
> somewhere ?

It already is in the DT spec and schemas.

Rob
