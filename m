Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F37B3DF
	for <patches@lists.linux.dev>; Tue, 12 Mar 2024 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710255150; cv=none; b=GifowO+fOPGFMiY2Vgay0XRJEOCeIjulwko0ys6G0JEBaQYc7BdmWyQPe9aCJor7Qlmj4qZ0O0IuNywgueDZlCw0m1cFMoyN/jzN6pZ+dquRkj2ErwwMIRv+UHZlsR2c6g9JaGZGmkRim2x48L9O2FqA7okMIKoMXVSQS0Vmz1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710255150; c=relaxed/simple;
	bh=HqLKdg5D/2l4/chJuAGqtrhx3KH6eTcOmIIabi94HGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DG/W1BBXI1X5iTpG8MuKkPntahosnlwB/PxnnXRe+dr+ruMeYsXlFnxjoQ+GSBavGWsbIgnL90YAENtHaocLG+Qu7W3w0gqZxEc4QYiQJHuxJN45xyVmQVVKlikbSEy2y6FyQBwhLIwsludH6bnH8n4PvVhFrE+ZZ9x1JOqQZxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-60a068e26d8so46176967b3.3
        for <patches@lists.linux.dev>; Tue, 12 Mar 2024 07:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710255147; x=1710859947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YdHy//nTWN9K6sgwTweLyEZnjTzGOH6tr4kEOlMF6A=;
        b=nWBD6+z0z6e0QguPFczgMCR6AuvVNBd7Xg/suvgzsVo4bJ0U4wnM3XH1d8XgVc6Rou
         73iNEHaPSpp7noTI9KtnZfgXFYnsF+KR7KPzGW5j4/UquuSSCX57+f0sRyF6zzD7SDtT
         NlAnQ20gVKiAnmx3e39Meiaih6pIrHezjRfcLB5g0E4HGf3Z8YyMfHW/mfWxz0UILel/
         QFOoJC8rBZsWmRVCS+476FeDP8nXbtPLuaAWGPgzNyd1iUq/39uZv0Kqz40/UPamDyh9
         Mp7AdZTW/BFDRumfQZ8Y7Z9SddglDKyQVA4MqPZXgmH3Fhbn3/1i7TPCJgSHJmmnjtnk
         0nHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu9DkryfI/JIWKWqwkDUNNAKgVaFysxWfnrHx/WHA6tVb2EvPhTQhn1S5FH4gkBhqvmuyi9vpOc+iHtEAP3k26c4x9Of24dQ==
X-Gm-Message-State: AOJu0YwPsjeSOnf8pQGFd4j4NwQesCCmAsKFF4HEMnc2mv5poTmkIMOb
	rL13IRMO7lnL2dnI7uouOnYf46RUrb+Hqs2DlUgGDiwRRj3CVok9FgYW5zpM+T0=
X-Google-Smtp-Source: AGHT+IG5aj2LfZzzmAQpbJv3n4cuzmNQEhx+VMszy4trgNcX2ocdI11xPIKyK3bNEyiUH1/B5+ndKA==
X-Received: by 2002:a0d:c204:0:b0:60a:3e37:56a2 with SMTP id e4-20020a0dc204000000b0060a3e3756a2mr5436013ywd.8.1710255147005;
        Tue, 12 Mar 2024 07:52:27 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id j128-20020a0dc786000000b006049c16b843sm1929329ywd.145.2024.03.12.07.52.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 07:52:26 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dcbc00f6c04so3888978276.3
        for <patches@lists.linux.dev>; Tue, 12 Mar 2024 07:52:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0keFDpxwAw9hQHQPXmZ6pjb2DsiT9VjQjNnEy8nuTw0PhrhbMcEFXxnaa3bVLLKqm9CLFWzg96/fJe7R0rKbNG1KgvMNu1Q==
X-Received: by 2002:a25:26cd:0:b0:dcd:ef35:91d5 with SMTP id
 m196-20020a2526cd000000b00dcdef3591d5mr6727921ybm.2.1710255146517; Tue, 12
 Mar 2024 07:52:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217060843.GA16460@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAL_Jsq+Feu9NnzTNx=XU5vgHhibGAQXvkuTeWbpu8gJ3rVrzcw@mail.gmail.com> <CAMuHMdUKa-KdWfYswEpFvj3RjQPM+ThhU85myfBGVkXxZqbHWw@mail.gmail.com>
In-Reply-To: <CAMuHMdUKa-KdWfYswEpFvj3RjQPM+ThhU85myfBGVkXxZqbHWw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 12 Mar 2024 15:52:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU83qwmO5swSQq79Zci7SP_xkNsjmQ4dYo-Pjw8d65fmg@mail.gmail.com>
Message-ID: <CAMuHMdU83qwmO5swSQq79Zci7SP_xkNsjmQ4dYo-Pjw8d65fmg@mail.gmail.com>
Subject: Re: [PATCH 2/7] of: Create of_root if no dtb provided by firmware
To: Rob Herring <robh+dt@kernel.org>
Cc: Saurabh Singh Sengar <ssengar@linux.microsoft.com>, Frank Rowand <frowand.list@gmail.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
	"Gabriel L. Somlo" <gsomlo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 3:41=E2=80=AFPM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> On Wed, Feb 21, 2024 at 3:06=E2=80=AFPM Rob Herring <robh+dt@kernel.org> =
wrote:
> > On Fri, Feb 16, 2024 at 11:08=E2=80=AFPM Saurabh Singh Sengar
> > <ssengar@linux.microsoft.com> wrote:
> > > This adds the strict check for compatible which makes compatible
> > > to be mandatory for root nodes. So far, DeviceTree without compatible
> > > property in root nodes can work. Do we want to make this documented
> > > somewhere ?
> >
> > It already is in the DT spec and schemas.
>
> How many systems in the wild violate this?
>
> Apparently the DTS generated by LiteX does not have a root compatible
> (and model) property, hence of_have_populated_dt() returns false.
> While my gateware and DTS is quite old, a quick look at recent
> litex_json2dts_linux.py history shows this is still true for current Lite=
X.

https://github.com/enjoy-digital/litex/issues/1905

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
