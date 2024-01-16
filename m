Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691C1BDF0
	for <patches@lists.linux.dev>; Tue, 16 Jan 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5f8cf76ef5bso87108797b3.0
        for <patches@lists.linux.dev>; Tue, 16 Jan 2024 06:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705414435; x=1706019235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sqbUk2C6b7oHNAWGCQckjFoAuDgEH4C3P1gTqqawwA=;
        b=jnYYyWdzMFOdYyCThlbZLWomtYWKvOEu7HrtU+lO4J78qjEKHGqY/3a4X6bSBFp8Qt
         AfP0F5OF+BRL2pSRY6KxdWRYSJ2x/9EHnEMaHICTV5kdA4CsRpUUHv21dUp1wO8uTc1i
         IhTq9K8l0gEvC9/H5KMycf1NnSFbY/Mw4OFArBaO+k6bSdS+78z+6ifu1CVSdy5epec0
         J3/AyLgM20AyPlnG9ySdu0wW02IHhCrkfe+yUcdMVPTTm5TehbtwqkBOT17VcQlX8Uom
         u9TZpfifE1iyFnyS/ZFEwNN/N2p+etbcmd/QAxeMxSou/ONnrNtKSrhGbSRAXclfllKI
         /WWw==
X-Gm-Message-State: AOJu0YyULBEfw5TFhvZlBdbyO2895OmhpCKfBaaBfpvQ1zMPC8KsuwMO
	1uY3vxAb5hx3tbcTY3oUkJJXdIuz1IFnsw==
X-Google-Smtp-Source: AGHT+IFBxXLRcm/2Z200omG/B7nY3LIYE3nFNT+B9lDaroijFB3x5sKi3OBDGcrEUwFM6TeHc6UNYg==
X-Received: by 2002:a81:e702:0:b0:5d7:1941:3567 with SMTP id x2-20020a81e702000000b005d719413567mr4769472ywl.78.1705414435257;
        Tue, 16 Jan 2024 06:13:55 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id y68-20020a81a147000000b005fa95a2f418sm4806939ywg.103.2024.01.16.06.13.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 06:13:54 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-5ff4da9494cso9604837b3.3
        for <patches@lists.linux.dev>; Tue, 16 Jan 2024 06:13:54 -0800 (PST)
X-Received: by 2002:a05:690c:1d:b0:5f6:e8c8:9b6c with SMTP id
 bc29-20020a05690c001d00b005f6e8c89b6cmr6746864ywb.46.1705414434365; Tue, 16
 Jan 2024 06:13:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240112200750.4062441-1-sboyd@kernel.org> <20240112200750.4062441-2-sboyd@kernel.org>
 <ZaZtbU9hre3YhZam@FVFF77S0Q05N>
In-Reply-To: <ZaZtbU9hre3YhZam@FVFF77S0Q05N>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 Jan 2024 15:13:42 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU0qtMeX=7SY+32=30-QGMRniFVCCm217REJ1X+ZNJ=Aw@mail.gmail.com>
Message-ID: <CAMuHMdU0qtMeX=7SY+32=30-QGMRniFVCCm217REJ1X+ZNJ=Aw@mail.gmail.com>
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

On Tue, Jan 16, 2024 at 12:51=E2=80=AFPM Mark Rutland <mark.rutland@arm.com=
> wrote:
> On Fri, Jan 12, 2024 at 12:07:44PM -0800, Stephen Boyd wrote:
> > Call this function unconditionally so that we can populate an empty DTB
> > on platforms that don't boot with a firmware provided or builtin DTB.
> > There's no harm in calling unflatten_device_tree() unconditionally.
>
> For better or worse, that's not true: there are systems the provide both =
a DTB
> *and* ACPI tables, and we must not consume both at the same time as those=
 can
> clash and cause all sorts of problems. In addition, we don't want people =
being
> "clever" and describing disparate portions of their system in ACPI and DT=
.

We'd get to the latter anyway, when plugging in a USB device where the
circuitry on/behind the USB device is described in DT.

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
