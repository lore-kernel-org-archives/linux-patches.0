Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C9D16EC0D
	for <patches@lists.linux.dev>; Tue, 28 May 2024 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902955; cv=none; b=qS4KYHGkQhj/j++UTzFbFnMDoPEsWrn7cE5m11fZUhEYxBnwpGiNtLG21wPNeo49F2o/63f1NKk0sR/yrCBfK3KIunMJmvJUL0Q7BhV2SlXywOXCI/eNjQz2vtNRUFZn0FOQJ7Bv5IHiUc72hTAmxDIufSsMbUn+tNX6UmuCFqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902955; c=relaxed/simple;
	bh=qF8RnWFXhFZYrpN4r/EMJVCuG3JWWMLwa2UIkxtk+Iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FrC7NcgTfSuCqXZvYRplbeLiFeoTnUzUjI/5t9zie4PtqvdO/X1ws6VyJy6gJd8M/tdvZaZLnO7jzohzQEM3Jgnll3l2S+Yde2N7e3xWVpIniszTqWBv3AgqNtgs/lj3ATWeoYREIieklwxahxaRjUchm/sH0iBieUtD/+OWjOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=i3waUurD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i3waUurD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97059C32782
	for <patches@lists.linux.dev>; Tue, 28 May 2024 13:29:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i3waUurD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1716902953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qF8RnWFXhFZYrpN4r/EMJVCuG3JWWMLwa2UIkxtk+Iw=;
	b=i3waUurDipDCAcGxoOid16UNJ9HYkcw8o9GpdJxJpgD01rsFSmFeGpTONF0dSEHUeiPlzu
	eUEMaWC1hVRRT+Sn8wNhQ6tT6bTZgYpph8tTEeWyz/VC8ksxjm5lZZ3XKvVaANaB7v5fSW
	YtkU0EBAl6dgATIuX8Lkzwlr3vktFKA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 902da5f6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Tue, 28 May 2024 13:29:12 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-df79380ffceso1895308276.1
        for <patches@lists.linux.dev>; Tue, 28 May 2024 06:29:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUktgDKYXyFNdoG2v4fsc6JFN94JEU3zVIobIQ+25xENb3GN/SW88WMLpImTtrQzhYizOAbdMlpfEcv7Y5jvQBly8pm4lNOrg==
X-Gm-Message-State: AOJu0YxjDMEq0ajsOEafDRrmthQyRI/JHc1BMk6SUc0Z3Z9Nc0tr+s1c
	0VnnYLqpShMxdbM9zvelSpttPIekD1OO8/qw1CK9gzpIAj7MyF87oT6u57rNyy06uOt8lDCFoQ6
	XSy2x1MDV1SiptvVhv2R3IPpsjrM=
X-Google-Smtp-Source: AGHT+IHs6YBGoJ22NizKEKgOAKHK5/PNDLyO/dJ25AG6/sBkCYeWtGE+E0FHaHhy2teOdk1tDqQwANej6Z1AgU51ejE=
X-Received: by 2002:a05:690c:6e07:b0:622:f7df:aa0a with SMTP id
 00721157ae682-6283496bccemr108435947b3.22.1716902950948; Tue, 28 May 2024
 06:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-4-Jason@zx2c4.com>
 <CAMuHMdVJ8KpaqnWeHCMbJdf-Am6uY0N+uFM+OVxWTZH37TQvxw@mail.gmail.com> <ZlXX0cFl5RANHNOQ@zx2c4.com>
In-Reply-To: <ZlXX0cFl5RANHNOQ@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 28 May 2024 15:28:58 +0200
X-Gmail-Original-Message-ID: <CAHmME9qZ2Xm68HQqfOmasWRoaW4xfAFAiLfw-pFbhq2i0rHz=w@mail.gmail.com>
Message-ID: <CAHmME9qZ2Xm68HQqfOmasWRoaW4xfAFAiLfw-pFbhq2i0rHz=w@mail.gmail.com>
Subject: Re: [PATCH v16 3/5] arch: allocate vgetrandom_alloc() syscall number
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 3:10=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> On Tue, May 28, 2024 at 03:08:00PM +0200, Geert Uytterhoeven wrote:
> > Hi Jason,
> >
> > On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4=
.com> wrote:
> > > Add vgetrandom_alloc() as syscall 462 (or 572 on alpha) by adding it =
to
> > > all of the various syscall.tbl and unistd.h files.
> > >
> > > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > As of commit ff388fe5c481d39c ("mseal: wire up mseal syscall") in
> > v6.10-rc1, 462 is already taken.
> >
> > v17 ++ ;-)
>
> Oy! Thanks. I should have thought to rebase on rc1 anyway before posting
> this.

Sorted in https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/l=
og/?h=3Dvdso
for the time being.
