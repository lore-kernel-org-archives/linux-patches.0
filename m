Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C63847B
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 05:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WfDKpks9"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-41cdc669c5eso135201cf.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 22:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698210991; x=1698815791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baZe6Er/ufhd0Yrnb7R1vtwdXlCqo8z/yXvbEj5eRBg=;
        b=WfDKpks9wM906gPnA72rPJ5/oWKJlkowloN4kokkn4+nUDtLZcn9w/K+CbI0yC3nTk
         znexBj3UGDvTpdcRlstGs9O72jEboLVoLnCEGQnMfIq/7XZ6zY5FWgLUUc2NYtxnh1L/
         DTYusfFk1OhTxH63++YBv+J8jLvKX1j7QSOO9bQvgo4gWkqol4Wb4E1+7zRw0mCJczsA
         t8D967mIzG+ODtzOiEOyIFdOgNInMf6v62enMg5YoHZ0qJjEmpslqSvDKa3PxgnnMUeh
         BsrAr9sV/xiSenG9rPfxOf8koJmy/wV6EDU+nJSO+dEcriUeJ+aH3RbQfTKkN1DvCwNz
         5jwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698210991; x=1698815791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baZe6Er/ufhd0Yrnb7R1vtwdXlCqo8z/yXvbEj5eRBg=;
        b=deCrVJvFsPZvDy9IJRD7Pj5dYmN7w9RlEWQKOQIYieSwur1Yj5a0p/4bRnIVw58O4R
         hexazAGCI88MJHSHvIs9YZ6kx8OBAAnSXO6fXSEFu1gfshkQacAEdK9fEJKy5QBOdDSv
         jjAMGJtCfkyHlNSz3CY13ys71zXg3epkk4kPfx/pFWO4CXdvMB6Rz0O3a/3XU4WfAbPu
         Y/hn9aqTqWwvgAsg6puLx0OCdMTMMnc2xxfb+NCtEwZEPMnhIwrMoplc2JXVX1aGwUTt
         2baRfpRISSZ1ty/2e5XGcsoSDgEbQWaINYg02mJEznGuygvN8rQkIa2KTh7VxwPcrshz
         0Nfg==
X-Gm-Message-State: AOJu0YwCNYtaPWPNSQf54W6bCrVpMutelXeuSHeS/jlaIYcler9mvQVh
	fKZASk4KepdGOAbzOClywFPEwknbMqfD5LeRPNrn3w==
X-Google-Smtp-Source: AGHT+IEzASoZCc/TRs0iyuhbg3NuUUgSxk35u16AmQj/DeiUVHb7V9/maMfbF9YIF+4At8GWNCRv/or/uAtFz+84vVs=
X-Received: by 2002:a05:622a:4784:b0:41e:29ad:8b8b with SMTP id
 do4-20020a05622a478400b0041e29ad8b8bmr142206qtb.10.1698210991149; Tue, 24 Oct
 2023 22:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824170617.074557800@linuxfoundation.org> <20230824170623.040455914@linuxfoundation.org>
 <2023102428-implicate-predict-0966@gregkh>
In-Reply-To: <2023102428-implicate-predict-0966@gregkh>
From: John Sperbeck <jsperbeck@google.com>
Date: Tue, 24 Oct 2023 22:16:18 -0700
Message-ID: <CAFNjLiWdyUzFpSSpfoPBjGRB4Eyhr=NH4TG0M0sydHTcUwvpxg@mail.gmail.com>
Subject: Re: [PATCH 5.10 134/135] objtool/x86: Fixup frame-pointer vs rethunk
To: Greg KH <gregkh@linuxfoundation.org>
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, 
	peterz@infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 11:12=E2=80=AFAM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Tue, Oct 24, 2023 at 05:47:54PM +0000, John Sperbeck wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Peter Zijlstra <peterz@infradead.org>
> > >
> > > commit dbf46008775516f7f25c95b7760041c286299783 upstream.
> > >
> > > For stack-validation of a frame-pointer build, objtool validates that
> > > every CALL instruction is preceded by a frame-setup. The new SRSO
> > > return thunks violate this with their RSB stuffing trickery.
> > >
> > > Extend the __fentry__ exception to also cover the embedded_insn case
> > > used for this. This cures:
> > >
> > >   vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without fra=
me pointer save/setup
> > >
> > > Fixes: 4ae68b26c3ab ("objtool/x86: Fix SRSO mess")
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> > > Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > Link: https://lore.kernel.org/r/20230816115921.GH980931@hirez.program=
ming.kicks-ass.net
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  tools/objtool/check.c |   17 +++++++++++------
> > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > >
> > > --- a/tools/objtool/check.c
> > > +++ b/tools/objtool/check.c
> > > @@ -2079,12 +2079,17 @@ static int decode_sections(struct objtoo
> > >     return 0;
> > >  }
> > >
> > > -static bool is_fentry_call(struct instruction *insn)
> > > +static bool is_special_call(struct instruction *insn)
> > >  {
> > > -   if (insn->type =3D=3D INSN_CALL &&
> > > -       insn->call_dest &&
> > > -       insn->call_dest->fentry)
> > > -           return true;
> > > +   if (insn->type =3D=3D INSN_CALL) {
> > > +           struct symbol *dest =3D insn->call_dest;
> > > +
> > > +           if (!dest)
> > > +                   return false;
> > > +
> > > +           if (dest->fentry)
> > > +                   return true;
> > > +   }
> > >
> > >     return false;
> > >  }
> > > @@ -2958,7 +2963,7 @@ static int validate_branch(struct objtoo
> > >                     if (ret)
> > >                             return ret;
> > >
> > > -                   if (!no_fp && func && !is_fentry_call(insn) &&
> > > +                   if (!no_fp && func && !is_special_call(insn) &&
> > >                         !has_valid_stack_frame(&state)) {
> > >                             WARN_FUNC("call without frame pointer sav=
e/setup",
> > >                                       sec, insn->offset);
> > >
> > >
> > >
> >
> > We still see the 'srso_untrain_ret+0xd: call without frame pointer save=
/setup' warning with v5.15.136.  It looks like the backport might be incomp=
lete.  Is this additional change needed?
> >
> > diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> > index 36ad0b6b94a9..c3bb96e5bfa6 100644
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -2202,7 +2202,7 @@ static bool is_special_call(struct instruction *i=
nsn)
> >               if (!dest)
> >                       return false;
> >
> > -             if (dest->fentry)
> > +             if (dest->fentry || dest->embedded_insn)
> >                       return true;
> >       }
> >
>
> Possibly, I remember this was a pain to backport.  Can you try this and
> see?  If so, can you send a working and tested patch?
>
> thanks,
>
> greg k-h

I think I can do that.  What's the process for a patch that would only
go to certain stable branches?  The 6.5 branch is okay.  A fix would
apply to 6.1, 5.15, and 5.10.  The original partial backport hasn't
gone into early releases, but I don't know if it will in the future.
