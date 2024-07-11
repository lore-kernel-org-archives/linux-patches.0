Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF20519E800
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 19:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727422; cv=none; b=VSF9zuuZy83Sf2Ok07SC9+lQhPPiBv6+uHEteN7JMcoMjaN0yUe/2cG0Mi48ojoFpDZ4mz+EBm0ofSAY8zNGKvWKZHuKP4rUOljx2/9b4JhrpxQeV5jdcco9DZSJLVlreXl6LrGNZimFpYqlQ8Q/0aEGiWQ6RDXT1msl8oDdFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727422; c=relaxed/simple;
	bh=4diN8MrB3FHIACY8p3Y2UO40Jfz3e8/rTkgrXUMp9EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s5hFrEx/0RgMhxIveoz3MOM2UH2FjKiGOkpUOuo/seemTYrJavGqqWCoJ3m+oknStnglprHSfRBcqomvnQJ99c+Qk2ABLb0ZgILTAoLmNtDjJEGrkyIks0V8HMj3V1RYD31fetCju2oAINZ6dii6qdX6Ug5KsvmpZF2Jvbhpgb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jv71BQm5; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jv71BQm5"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-447f8aa87bfso63591cf.0
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 12:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720727420; x=1721332220; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6WD8uWdmw8Cbo4EjYtrrPSI26ltEqhqtj652OLG+Q4=;
        b=jv71BQm5XUFgsrQ1DjGi9/BO0oObnXoTcJq9oprtrN95V8iRP9qJEbwmrHCFDFFgxZ
         EjIVSCRrA8OP4qAKIG+4WOOB3e5cShNxFJxIjFEkRZHnUMGzU8s23u8vZ9EWIybZR+0a
         NCh8eMaqySuOGoJxvzYLotnBebYhw5EK18iug0JCfsw4eE8+O/5iOj9dJsbu2QYoSzaa
         NPRqV0zPDT0sd8a893HkwW0HoOFjrXazAsnlA52PEXSwuJaOGxXOy+y26tMrOv13K5nk
         ImhGsswJt0G/QZhesBy0xAEZK22LYkLx7iem8b6ZKuClR+FXrxSqBEKS6ssEe3CyERF5
         RAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720727420; x=1721332220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6WD8uWdmw8Cbo4EjYtrrPSI26ltEqhqtj652OLG+Q4=;
        b=DR71iCkJN11CY1ULzy4jwsrNbNzajv+RtDpnogMu2t1G2ldlVEGtgb3wCgFJXkxtoS
         FPrdHHBPeART9L9eV8prluMVNCjnvsLt1vj2/hnRPfIXHmAuaAkc8gEAfcie94pRkD2A
         fdwzibpIgFSHHO2xgYMF4Cr5kdjiIC4NGJFYT3jBCZ6NfhP25qdJFj5CWwOH00ihROLM
         IRyuWs5QTD5cAYPSulCN53xMvhkwL6PKz/enwfQvLaTv9rslTVdSOS0UiwpGF2jIeQ9y
         opboH1WQwzmAYEAfzfF+LmXa39tRaspEMddo0DZ/DbRrktkriMUxDbMU0SrgoEsq0cOw
         v6xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdYiF+jZZzYdbNZ9mOz0c0JxzWNDH6rAbT6BSTG9Jb/xbeaOWCKKf9zT5dpx2N9orkxaAk8DsqS8x7lFw7Hg0fAgl1yW671w==
X-Gm-Message-State: AOJu0YyHIMc3q8pI13oKm/eg8VwEBrjKiyLUZlHNsD+Tbv8iPJr30XcW
	znkfZvxXXNO2HXyH1Z6sKC5JUv9H25h6/QRWfJSaOBlA4N7eC3HwErhyDGdEvbWCnwhgNZSHhIH
	v3XJtbyouHy7c5gmucferN7+yDglgVELbq0kt
X-Google-Smtp-Source: AGHT+IENr3A77Xgxppnz3neQHMLruOsrOFPG5UHll8ma7WhGXms3uuMDcSKNpckxI36I3OJ7mkiV/BUN34ZoGEJxGdg=
X-Received: by 2002:ac8:710d:0:b0:444:97b7:e3b1 with SMTP id
 d75a77b69052e-44e79101746mr496381cf.13.1720727419548; Thu, 11 Jul 2024
 12:50:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
 <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
 <ZpAR0CgLc28gEkV3@zx2c4.com> <ZpATx21F_01SBRnO@zx2c4.com> <98798483-dfcd-451e-94bb-57d830bf68d8@redhat.com>
 <54b6de32-f127-4928-9f4a-acb8653e5c81@redhat.com> <ZpAcWvij59AzUD9u@zx2c4.com>
 <ZpAc118_U7p3u2gZ@zx2c4.com> <ZpAfigBHfHdVeyNO@zx2c4.com> <8586b19c-2e14-4164-888f-8c3b86f3f963@redhat.com>
 <ZpAqbh3TnB9hIRRh@zx2c4.com> <443146f4-9db8-4a19-91f1-b6822fad8ce8@redhat.com>
 <1c8632b4-06a5-49da-be0c-6fc7ac2b3257@redhat.com> <2c464271-1c61-4cd8-bd4e-4bd8aa01fa00@redhat.com>
In-Reply-To: <2c464271-1c61-4cd8-bd4e-4bd8aa01fa00@redhat.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 11 Jul 2024 13:49:42 -0600
Message-ID: <CAOUHufYsxCb=taWWfUbuzi1Hmmug=ThQMoTjsxrtFkt=UXEu6w@mail.gmail.com>
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 1:20=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 11.07.24 21:18, David Hildenbrand wrote:
> > On 11.07.24 20:56, David Hildenbrand wrote:
> >> On 11.07.24 20:54, Jason A. Donenfeld wrote:
> >>> On Thu, Jul 11, 2024 at 08:24:07PM +0200, David Hildenbrand wrote:
> >>>>> And PG_large_rmappable seems to only be used for hugetlb branches.
> >>>>
> >>>> It should be set for THP/large folios.
> >>>
> >>> And it's tested too, apparently.
> >>>
> >>> Okay, well, how disappointing is this below? Because I'm running out =
of
> >>> tricks for flag reuse.
> >>>
> >>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >>> index b9e914e1face..c1ea49a7f198 100644
> >>> --- a/include/linux/page-flags.h
> >>> +++ b/include/linux/page-flags.h
> >>> @@ -110,6 +110,7 @@ enum pageflags {
> >>>             PG_workingset,
> >>>             PG_error,
> >>>             PG_owner_priv_1,        /* Owner use. If pagecache, fs ma=
y use*/
> >>> +   PG_owner_priv_2,
> >>
> >> Oh no, no new page flags please :)
> >>
> >> Maybe just follow what Linux suggested: pass vma to pte_dirty() and
> >> always return false for these special VMAs.
> >
> > ... or look into removing that one case that gives us headake.
> >
> > No idea what would happen if we do the following:
> >
> > CCing Yu Zhao.
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0761f91b407f..d1dfbd4fd38d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4280,14 +4280,9 @@ static bool sort_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct scan_c
> >                   return true;
> >           }
> >
> > -       /* dirty lazyfree */
> > -       if (type =3D=3D LRU_GEN_FILE && folio_test_anon(folio) && folio=
_test_dirty(folio)) {
> > -               success =3D lru_gen_del_folio(lruvec, folio, true);
> > -               VM_WARN_ON_ONCE_FOLIO(!success, folio);
> > -               folio_set_swapbacked(folio);
> > -               lruvec_add_folio_tail(lruvec, folio);
> > -               return true;
> > -       }
> > +       /* lazyfree: we may not be allowed to set swapbacked: MAP_DROPP=
ABLE */
> > +       if (type =3D=3D LRU_GEN_FILE && folio_test_anon(folio) && folio=
_test_dirty(folio))
> > +               return false;

This is an optimization to avoid an unnecessary trip to
shrink_folio_list(), so it's safe to delete the entire 'if' block, and
that would be preferable than leaving a dangling 'if'.

> Note that something is unclear to me: are we maybe running into that
> code also if folio_set_swapbacked() is already set and we are not in the
> lazyfree path (in contrast to what is documented)?

Not sure what you mean: either rmap sees pte_dirty() and does
folio_mark_dirty() and then folio_set_swapbacked(); or MGLRU does the
same sequence, with the first two steps in walk_pte_range() and the
last one here.
