Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB552C192
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594941; cv=none; b=O+E9jVCz4Bkc0Wepm0AgBncCy9gIQ9Me6m/b7ZXWlUhzq+p8X+ysUewNxij3g04/MM+Z4z4vUrUchPrAPtAIVdOlyFrd9uOhw9rqI4lAT/zpAqMRP9uUGq39Kvo1zBnmwWjWlUufWewVF1cZMja9ToqZHm7aJLfrvGy7RfaHucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594941; c=relaxed/simple;
	bh=qPzK6gVFp3Jx3vDLYl65XpUDJJEvx4TME7a9OfF/BS4=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Received:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding; b=j633oWENbdSeUNV1ERp5OZmqs/KLBaTkOAYB5wfKAj/GcDAytT7ALTeYx+yPdjO8jT1644RvsaK2WuCNIH+To6/FoLjZECUihvEFN+fkAbVaz5pemHy4vDRLUlWVyIgwpAcnakDVBEQAOUNBKhB33ru6tVDFqPpC/No6FUPI4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5f8cf76ef5bso115564567b3.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:22:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705594938; x=1706199738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1ZHBh2IhHUk6R0mb0HwNUYRqWpgjfOFml5hWvgYMDU=;
        b=cPto5OpLylpHfqd3PXpo7xEI5ojrPnocZG/P48T7Qfk36Qsar9dIO2UcKujSFOFD4D
         sMMv/uyAa8s46nbibx27Xih5yaCNjBbmbgzgW9xkqCciACjdu20Vz8hDoZqlxazz2jms
         Qzu1ONz+ilbQkbq566XvHO2Cj9Bl6l35xLooeMfTZhZYQSwwIAM41fNsfR1/e+BswKBn
         mo9z/sEUU2Bk/9hYcntlpcxuHrt21kEMOz8aOk0Adp5tugHkxtbHOgf30TTsos4xLKMR
         yHU87gdr8Lmpx4TcziDOFDKRsWT8VO7hjSL8Dn/j/APzDegkZnJEbdBrUyY8g2InOxIl
         93ng==
X-Gm-Message-State: AOJu0YxuKcCeIM7M3btXQuVr1rVVUoSuuwyOMYXtz2TYDWPtZh9hlUK/
	tLF0gMCPrn+arxiaq4TUJrKn0UoaNq6GbWnxS9Lr6+OxOQTXjLmw7iVyXoSAr/s=
X-Google-Smtp-Source: AGHT+IFBC0KWkmEOB8tDfFvl4U8EcaMcq6x9dYFnTAi7XpAmEzTAkavY2ylonwPdHwh2w9pUIYWk1g==
X-Received: by 2002:a0d:d5c8:0:b0:5f6:a23b:9d4f with SMTP id x191-20020a0dd5c8000000b005f6a23b9d4fmr1220233ywd.3.1705594938199;
        Thu, 18 Jan 2024 08:22:18 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id r124-20020a819a82000000b005e92fd632e0sm6806717ywg.24.2024.01.18.08.22.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 08:22:17 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc250cff65aso1087355276.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:22:17 -0800 (PST)
X-Received: by 2002:a25:748a:0:b0:da0:3bfc:b915 with SMTP id
 p132-20020a25748a000000b00da03bfcb915mr1030675ybc.11.1705594937194; Thu, 18
 Jan 2024 08:22:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240112200750.4062441-1-sboyd@kernel.org> <20240112200750.4062441-2-sboyd@kernel.org>
 <ZaZtbU9hre3YhZam@FVFF77S0Q05N> <CAMuHMdU0qtMeX=7SY+32=30-QGMRniFVCCm217REJ1X+ZNJ=Aw@mail.gmail.com>
 <ZalCcivD0vXpQfr9@FVFF77S0Q05N.cambridge.arm.com>
In-Reply-To: <ZalCcivD0vXpQfr9@FVFF77S0Q05N.cambridge.arm.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 18 Jan 2024 17:22:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVW+zBU-7OEpsMZKFfkFbyN98jatG0RsLuzZmXKWavNAA@mail.gmail.com>
Message-ID: <CAMuHMdVW+zBU-7OEpsMZKFfkFbyN98jatG0RsLuzZmXKWavNAA@mail.gmail.com>
Subject: Re: [PATCH 1/6] arm64: Unconditionally call unflatten_device_tree()
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org, 
	Frank Rowand <frowand.list@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Jan 18, 2024 at 4:23=E2=80=AFPM Mark Rutland <mark.rutland@arm.com>=
 wrote:
> On Tue, Jan 16, 2024 at 03:13:42PM +0100, Geert Uytterhoeven wrote:
> > On Tue, Jan 16, 2024 at 12:51=E2=80=AFPM Mark Rutland <mark.rutland@arm=
.com> wrote:
> > > On Fri, Jan 12, 2024 at 12:07:44PM -0800, Stephen Boyd wrote:
> > > > Call this function unconditionally so that we can populate an empty=
 DTB
> > > > on platforms that don't boot with a firmware provided or builtin DT=
B.
> > > > There's no harm in calling unflatten_device_tree() unconditionally.
> > >
> > > For better or worse, that's not true: there are systems the provide b=
oth a DTB
> > > *and* ACPI tables, and we must not consume both at the same time as t=
hose can
> > > clash and cause all sorts of problems. In addition, we don't want peo=
ple being
> > > "clever" and describing disparate portions of their system in ACPI an=
d DT.
> >
> > We'd get to the latter anyway, when plugging in a USB device where the
> > circuitry on/behind the USB device is described in DT.
>
> I don't understand what you mean there; where is the DT description of th=
e USB
> device coming from if the DTB hasn't been unflattened?

Either stored in (FLASH) ROM on the USB device, or loaded from
/lib/firmware/.  In both cases that would be handled by the USB driver
for the device.

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
