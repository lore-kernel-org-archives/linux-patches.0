Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DEF23741
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705595023; cv=none; b=C35T9jJM7KpOUcGMImK12keNAV6N2gHIVj7hw+Rykd0MaTWg6E4PLvSQ15ydPod3DaXL3DFEyavRcQ2BCYGMB+5GxPMaHluqAqSVibgDd1UZC67CbKYuydqx5ADciA5CPk4q/9L6RfaLsVJ/Y8IyyqKiVSfC/qULAQob0jEUHmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705595023; c=relaxed/simple;
	bh=qKUUpq7MmCfdf2J5CKyKj1so4YJl9z164uDR3Riq3eE=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Received:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding; b=QLcE8goccNVPoi0dgvy7hIqv1PXtE78JsjMnvWqbXvk3MVHC8roDI71VpCK4fN0npTsy08MVlPmCD87GsvL5+4fXAjUNF15Po1xcE/1GottIb8G8ChYEAKyXf99UT03hl1d3qM6nmF202h4/9IZYIgU6Guo6BJgRhzoRvjP31rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dafe04717baso10060347276.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705595021; x=1706199821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Si052lwaQIxGIdPAiTDPdKrWDfItm8neDWdgcw4uLug=;
        b=RUCrRa4kHsXDHXu4JuVGWfCn7OSeIdXkQLx2METlOg1DNOtef0K1Au+HigFIa49Ckd
         nCePEMQPDpg5Ekw4R5uuGiBYywc1NNehsPh5qRP0D50BMcxDlm8s1CadOhPLdKpi9kd7
         r4sV3rVJwTivWXzDFLsj5nGb9Ni7IBUSKYO+ZI8j+Ko+k4frZQLKQkgvw2rL9UPC1Y8n
         vkdkmrrSbMu1an2NNdFwRRGBpieul62QM0sC5nPQeBaYARIbcCaOJRy6VRXuN0yb3qHw
         XCB6j3uTkd7W3T0xOTIrKasR1yMCdznMwTVRhZ2ZKICvAdmCvvbfhL7ZMMASDz8fnHNk
         oUkg==
X-Gm-Message-State: AOJu0YyKIndh0hrJOpj09uurIRUit9j/zpLzhckCE3J+MtvFlozevYd5
	UnZbuqEUGqgRUXJ8gh7MQujMLKjm3x+fZKbkxaQ8SCssga8eB5d/laTofRnZeGw=
X-Google-Smtp-Source: AGHT+IEyfKkm/JBeZkfHqtzKJjhDqxBzHh1G6EOqnAW+ZufBE9oY/kpgyz5uZiaPngX210Uk2c7mpg==
X-Received: by 2002:a25:bccf:0:b0:dbd:abfa:f83a with SMTP id l15-20020a25bccf000000b00dbdabfaf83amr878666ybm.116.1705595020855;
        Thu, 18 Jan 2024 08:23:40 -0800 (PST)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com. [209.85.128.172])
        by smtp.gmail.com with ESMTPSA id k10-20020a25b28a000000b00dc2217892a4sm2380604ybj.56.2024.01.18.08.23.40
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 08:23:40 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-5f2d4aaa2fdso127764207b3.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:23:40 -0800 (PST)
X-Received: by 2002:a0d:c201:0:b0:5f4:97a:ac87 with SMTP id
 e1-20020a0dc201000000b005f4097aac87mr963234ywd.60.1705595019879; Thu, 18 Jan
 2024 08:23:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240112200750.4062441-1-sboyd@kernel.org> <20240112200750.4062441-2-sboyd@kernel.org>
 <ZaZtbU9hre3YhZam@FVFF77S0Q05N> <434b21afe1899b1567f3617261594842.sboyd@kernel.org>
 <ZalDM90KoQ2Il0j7@FVFF77S0Q05N.cambridge.arm.com>
In-Reply-To: <ZalDM90KoQ2Il0j7@FVFF77S0Q05N.cambridge.arm.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 18 Jan 2024 17:23:28 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXkwDA4WAe5qYujeP0sF+h-950GZNkg+6kERr6SSmfz6A@mail.gmail.com>
Message-ID: <CAMuHMdXkwDA4WAe5qYujeP0sF+h-950GZNkg+6kERr6SSmfz6A@mail.gmail.com>
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

On Thu, Jan 18, 2024 at 4:27=E2=80=AFPM Mark Rutland <mark.rutland@arm.com>=
 wrote:
> On Tue, Jan 16, 2024 at 05:27:18PM -0800, Stephen Boyd wrote:
> > Quoting Mark Rutland (2024-01-16 03:51:14)
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
> > >
> > > It is a very deliberate choice to not unflatten the DTB when ACPI is =
in use,
> > > and I don't think we want to reopen this can of worms.
> >
> > Hmm ok. I missed this part. Can we knock out the initial_boot_params in
> > this case so that we don't unflatten a DTB when ACPI is in use?
>
> Why is that better than just not calling unflatten_device_tree(), as we d=
o
> today?
>
> The cover letter says this is all so that we can run DT tests for the clk
> framework; why can't that just depend on the system being booted with DT =
rather
> than ACPI? We have other tests which are architecture and/or configuratio=
n
> dependent...

There is definitely a merit in running (platform-independent) DT tests
on any platform, whether the platform actually uses DT to boot or not.

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
