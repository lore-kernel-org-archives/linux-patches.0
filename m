Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4422CA6
	for <patches@lists.linux.dev>; Fri, 26 May 2023 16:51:38 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6238b15d298so9965346d6.0
        for <patches@lists.linux.dev>; Fri, 26 May 2023 09:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685119897; x=1687711897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0EcAbr12Tz3JaIJZGOfuX6nKlF7eHCwWePp0l1EnR0=;
        b=ZQAf4LUZzgLtNI1iuErVfrDk5RtwHd5YprqowAtUBbv7Kz6xOQfmdZi/1o5/n30lQE
         /tpfYmZDRVi4NoxJIuNvdO9aqoj4c9kwfIW1rEqzNszwi76gHAD+BGX2cV/Zd3s+NTMZ
         E4LKP1wu9x8pSzqzw57xxLCOhqzW+XL9oX/UQsKnneky5T2OfUWG5XoKACPfuYsoe8Uz
         OLVd8dGzB0x+YRg7KmLHG59ArbV8g7o7IlHkeiBGwa9sKUG7yGRVlrMm1uYGu+qlM1LL
         RGjTDUiCcBQEZsGuPruFUneQF+eACEbsKJDXp5xVByVgYkV3VN6qQGHsL9fuVdYTAyeH
         GMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685119897; x=1687711897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0EcAbr12Tz3JaIJZGOfuX6nKlF7eHCwWePp0l1EnR0=;
        b=hHvlLfsEt6AVlCe/xUmOthTKxvuCYaB1MCWkTrpxz1pzwu3Kfbou//PN+7sDynbk0b
         QplENgHRxR2VWrcIl+rtpXZYOdp5ivhMTcgOXnC2v2+VH3G4K1E5NWLmom4PZAtNpRdy
         knGcTkLVvJSnwPahlilCBgUMaWDdV9cbRfVFp/tRridPtNVPGbo7qof8neoPggvHwPYi
         0SyLLWbb8CZCl0h8P9KRf12Nbg8aSBhbIVh7d9uUO7ic1ciZVmzhcJIbd6blQGIzpiyE
         OgFv8vURc963qxojS1xwaEIh5qHjl/aBurM/pXFDVPlfsVF64w8HwboOxE4EtJvmxqpM
         hQUA==
X-Gm-Message-State: AC+VfDyY/y4016t3mbvNmLIxCBk/QMCa2HXxUm34tb8XwA/PCcKoGjJY
	KMGcsqNTetb5P9DBpKlkiRTV7fwKVdudV1YW9us8ZA==
X-Google-Smtp-Source: ACHHUZ7zNVT9E5+KkqBP+ZTyfqvDGI2d6bY2hRADL+qOK3dL+ftIEtrLh4N7cS11/o6IrVHRuLLfI56tUId+yu2rsJQ=
X-Received: by 2002:ad4:5ce6:0:b0:625:e039:5b03 with SMTP id
 iv6-20020ad45ce6000000b00625e0395b03mr3237442qvb.54.1685119897248; Fri, 26
 May 2023 09:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524-intel_async_flip_check_hw-implicit-fallthrough-v1-1-83de89e376a1@kernel.org>
 <CAKwvOd=jZJouuNMd3Rvc--goA0EXPHcf6cHXUA6W1kXJg2ay2w@mail.gmail.com>
 <20230524184103.GA324296@dev-arch.thelio-3990X> <CAKwvOdm=Zk8YhrPptN3k7UQo+1n7Ws=Qox=BwTR9bbjPJJYz8A@mail.gmail.com>
 <39da7e41-dd07-b8bc-57b9-19b05fdfbeac@tessares.net>
In-Reply-To: <39da7e41-dd07-b8bc-57b9-19b05fdfbeac@tessares.net>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 26 May 2023 09:51:26 -0700
Message-ID: <CAKwvOdkFxUU4AM9WbcRK9FYHq0cK2H-x4i5_x7oYiE7=DjghhQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Fix clang -Wimplicit-fallthrough in intel_async_flip_check_hw()
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Nathan Chancellor <nathan@kernel.org>, jani.nikula@linux.intel.com, 
	joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
	tvrtko.ursulin@linux.intel.com, trix@redhat.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 25, 2023 at 1:30=E2=80=AFPM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Nick,
>
> On 24/05/2023 20:56, Nick Desaulniers wrote:
> > On Wed, May 24, 2023 at 11:41=E2=80=AFAM Nathan Chancellor <nathan@kern=
el.org> wrote:
> >>
> >> On Wed, May 24, 2023 at 11:32:32AM -0700, Nick Desaulniers wrote:
> >>> On Wed, May 24, 2023 at 8:38=E2=80=AFAM Nathan Chancellor <nathan@ker=
nel.org> wrote:
> >>>>
> >>>> Clang warns:
> >>>>
> >>>>   drivers/gpu/drm/i915/display/intel_display.c:6012:3: error: unanno=
tated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
> >>>>                   case I915_FORMAT_MOD_X_TILED:
> >>>>                   ^
> >>>>   drivers/gpu/drm/i915/display/intel_display.c:6012:3: note: insert =
'break;' to avoid fall-through
> >>>>                   case I915_FORMAT_MOD_X_TILED:
> >>>>                   ^
> >>>>                   break;
> >>>>   1 error generated.
> >>>>
> >>>> Clang is a little more pedantic than GCC, which does not warn when
> >>>> falling through to a case that is just break or return. Clang's vers=
ion
> >>>> is more in line with the kernel's own stance in deprecated.rst, whic=
h
> >>>> states that all switch/case blocks must end in either break,
> >>>> fallthrough, continue, goto, or return. Add the missing break to sil=
ence
> >>>> the warning.
> >>>>
> >>>> Fixes: 937859485aef ("drm/i915: Support Async Flip on Linear buffers=
")
> >>>> Reported-by: kernel test robot <lkp@intel.com>
> >>>> Closes: https://lore.kernel.org/202305241902.UvHtMoxa-lkp@intel.com/
> >>>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >>>> Closes: https://lore.kernel.org/CA+G9fYv68V3ewK0Qj-syQj7qX-hQr0H1MFL=
=3DQFNuDoE_J2Zu-g@mail.gmail.com/
> >>>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >>>
> >>> Thanks for the patch! I've never seen the closes tag before, that's
> >>> new to me. Can you tell me more about it?
> >>
> >> It is new to me (at least in the context of the kernel) as well. I onl=
y
> >> used it over Link: because checkpatch.pl told me to:
> >>
> >> WARNING: Reported-by: should be immediately followed by Closes: with a=
 URL to the report
> >> #26:
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >>
> >> WARNING: Reported-by: should be immediately followed by Closes: with a=
 URL to the report
> >> #27:
> >> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >>
> >> It was Link: for a bit but commit 44c31888098a ("checkpatch: allow
> >> Closes tags with links") changed it to Closes:. Looks odd to me but
> >> whatever the linter says I suppose.
> >>
> >> Thanks for the review!
> >>
> >> Cheers,
> >> Nathan
> >>
> >>> A few more tags
> >>>
> >>> Reported-by: Tom Rix <trix@redhat.com>
> >>> Link: https://lore.kernel.org/all/20230523125116.1669057-1-trix@redha=
t.com/
> >>> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> >
> > Ah then I guess my link tag should have been
> >
> > Closes: https://lore.kernel.org/all/20230523125116.1669057-1-trix@redha=
t.com/
> >
> > I hope the author of
> > commit 44c31888098a ("checkpatch: allow Closes tags with links")
> > has coordinated with the maintainer of b4, so that b4 recognizes Closes=
 tags.
> > b4 v0.12.2 does not pick up Closes tags.
>
> I'm sorry for the troubles caused by this series, that was not the
> intension.
>
> When looking at modifying b4 to support the Closes tag, I realised the
> Link tag from your previous message [1] was not taken as well. Was it
> just me?

oh? good find!

>
> If no, I just sent patches for b4, see [2]. I hope it will help!

appreciated! Thank you.

>
> Cheers,
> Matt
>
> [1]
> https://lore.kernel.org/all/CAKwvOd=3DjZJouuNMd3Rvc--goA0EXPHcf6cHXUA6W1k=
XJg2ay2w@mail.gmail.com/
> [2]
> https://lore.kernel.org/tools/20230525-closes-tags-v1-0-ed41b1773cb6@tess=
ares.net/T/
> --
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net



--=20
Thanks,
~Nick Desaulniers
