Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5605F85C70
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707162948; cv=none; b=NtZTTAGI9B+3pwZsqIHVsf2TE6CFr4wnJumBAaX1yXOs53o8C9cRumbznCk+//DaO3CvIvlLc3CgLSVgFILhIrS6kk4KslbCJd4HI9GZGzfdHt80OzPXBpK2hTnNnZacNBrpVn89dNakZdn/qdnd47hICHcN0nuFbbXlQzSuPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707162948; c=relaxed/simple;
	bh=6KR5cC4rdQoGKm5Xws5HnQANaoT9euc9PGHJMySesSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j/VT+T8X7FYCHaDKrjpPmrSdGAzaUjy2X+ZatizQHFeRUXVg40jzLHey5fOCTR98C7hN0QF+JQ5j8J6IHGbhDOm2vF9iHV2npI/3vuu4F4OS6GyflUzCTSccKhbQ6DcpzbgqQX3p3v0kYYUlXvtWrYq7rInH4rvN6d0uLnzdwGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6043efd46f8so15990057b3.0
        for <patches@lists.linux.dev>; Mon, 05 Feb 2024 11:55:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707162944; x=1707767744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pg0vleuARG2tQFPXTpmZPKI66XOaTEWhuPP2csZ8T84=;
        b=DPQ8Og6yETaGVVem2p+BfA41HEiT5ent7rodvzCR4R35/YS1IL4zAs79XrjIdf+21Z
         zoJcYYY4M9rZOU+X24Upv76ek/vax3dh9LXkcislekOYfc/UY5EeJd0hNnz7hQ/+bakY
         ROByOxSUmphGW6PbVc9P8hJhP8mmivLc07BRz6zNrVw/xO6GmcjGiRxYrKBb43hyjZCS
         Sb+w7iN8ajB2Yf0XOXei6bq3W7lLxHjGSyZhAmIqW/U4wwbH2M5e3+BFxLMt5QTEpaW0
         0Yf8rnhKVyFI3wgVaPzsllV+HWJzFSUt6xsW9gSWjXUtyvIHM2sjAUmCRr8oqCqt6bDe
         1Egw==
X-Gm-Message-State: AOJu0YxvRa8Rqad2TPV3wd15SUZYXqZUrc6rhILueuIb+jV96OiyjwHO
	vMjr1i3980GmAK7G3AfDAUtZAvkwXuHr6ugy7rxgmoKWWOjNuWW3dNd6EdlRg5s=
X-Google-Smtp-Source: AGHT+IGLHBD4/cAOPd5Mnpt6EfkoqOwk34lgeW8n0PP8oW1cONp2ZAHD+LT3r5HIo5RDvUtFJm6tgw==
X-Received: by 2002:a81:4fcc:0:b0:603:ee92:9729 with SMTP id d195-20020a814fcc000000b00603ee929729mr647508ywb.1.1707162944532;
        Mon, 05 Feb 2024 11:55:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVScOmC2n7u9ztC4QJJl0a/VNUWB8t71tZi4ez/gpT3qm6gbmDtwaSKoG5oxkHm51In+6hGtJOD7EBWFEYN4Z4D3MiUQMP0sg==
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id m16-20020a819c10000000b006041c534663sm101529ywa.131.2024.02.05.11.55.44
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 11:55:44 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6043efd46f8so15989717b3.0
        for <patches@lists.linux.dev>; Mon, 05 Feb 2024 11:55:44 -0800 (PST)
X-Received: by 2002:a81:aa0f:0:b0:5ee:7299:e2cf with SMTP id
 i15-20020a81aa0f000000b005ee7299e2cfmr562941ywh.52.1707162942877; Mon, 05 Feb
 2024 11:55:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240202195909.3458162-1-sboyd@kernel.org> <20240202195909.3458162-8-sboyd@kernel.org>
 <CABVgOS=A8BQ6HHpBKFqg-N10ckk2XYavaS-MPXvZ0wenrVm=1g@mail.gmail.com> <89892ecd6b1b043db58258705c32b02b.sboyd@kernel.org>
In-Reply-To: <89892ecd6b1b043db58258705c32b02b.sboyd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 5 Feb 2024 20:55:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUuP5Ya2gU3V_ET=Ji_+yx+jr7eCch5uDJSqvQN9jJM3g@mail.gmail.com>
Message-ID: <CAMuHMdUuP5Ya2gU3V_ET=Ji_+yx+jr7eCch5uDJSqvQN9jJM3g@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] of: Add KUnit test to confirm DTB is loaded
To: Stephen Boyd <sboyd@kernel.org>
Cc: David Gow <davidgow@google.com>, Rob Herring <robh+dt@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Mon, Feb 5, 2024 at 8:19=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wrot=
e:
> Quoting David Gow (2024-02-02 20:10:17)
> > On Sat, 3 Feb 2024 at 03:59, Stephen Boyd <sboyd@kernel.org> wrote:
> > > Add a KUnit test that confirms a DTB has been loaded, i.e. there is a
> > > root node, and that the of_have_populated_dt() API works properly.
> > >
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: Frank Rowand <frowand.list@gmail.com>
> > > Cc: David Gow <davidgow@google.com>
> > > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > > ---
> >
> > This looks pretty good to me test-wise, though it still fails on m68k.
> > (Everything else I tried it on works, though I've definitely not tried
> > _every_ architecture.)
> >
> > aarch64: PASSED
> > i386: PASSED
> > x86_64: PASSED
> > x86_64 KASAN: PASSED
> > powerpc64: PASSED
> > UML: PASSED
> > UML LLVM: PASSED
> > m68k: FAILED
> > > $ qemu-system-m68k -nodefaults -m 1024 -kernel .kunit-all-m68k/vmlinu=
x -append 'kunit.enable=3D1 console=3Dhvc0 kunit_shutdown=3Dreboot' -no-reb=
oot -nographic -serial stdio -machine virt
> > > [11:55:05] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D dtb (2 subtests) =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > > [11:55:05] # dtb_root_node_found_by_path: EXPECTATION FAILED at drive=
rs/of/of_test.c:18
> > > [11:55:05] Expected np is not null, but is
> > > [11:55:05] [FAILED] dtb_root_node_found_by_path
> > > [11:55:05] # dtb_root_node_populates_of_root: EXPECTATION FAILED at d=
rivers/of/of_test.c:28
> > > [11:55:05] Expected of_root is not null, but is
> > > [11:55:05] [FAILED] dtb_root_node_populates_of_root
> > > [11:55:05]     # module: of_test
> > > [11:55:05] # dtb: pass:0 fail:2 skip:0 total:2
> > > [11:55:05] # Totals: pass:0 fail:2 skip:0 total:2
> > > [11:55:05] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D [FAILED] dtb =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>
> Ah yeah I forgot to mention that. m68k fails because it doesn't call the
> unflatten_(and_copy)?_device_tree() function, so we don't populate a
> root node on that architecture. One solution would be to make CONFIG_OF
> unavailable on m68k. Or we have to make sure DT works on any
> architecture. Rob, what do you prefer here?

I guess the latter?
Alpha, hexagon, parisc, s390, and sparc are also lacking calls
to unflatten.*device_tree().

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
