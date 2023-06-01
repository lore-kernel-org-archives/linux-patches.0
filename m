Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F6223DF;
	Thu,  1 Jun 2023 18:46:47 +0000 (UTC)
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-75afa109e60so100804485a.2;
        Thu, 01 Jun 2023 11:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685645206; x=1688237206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hvF2IOpQDKKFJsjxOYinWe29JU4zPVFXfARnEjYEpc=;
        b=CudqLc3iGXdiDlwjQ87B0qlglY0tFiDqdOoRiRGDe2IPiAeGkxawJXLplzRWbsYwbQ
         nrtaOpAejeXrWToc1nALUJQXjFOhG7gep1FNh1kJhYWLxWTyeofFe8v4CkAZEmOtL2ZS
         HUkTOCtslz9vR+OyKGbYMh3yn30xIMV641o55kWqv+tanPWV704AWQor2ywTvm9I6xHB
         2KHeLxR/hvyMoeu6Zydn+r3ORXdoQ4pkUDrYHJFNK5iNCtxBsalkAuHcEIL8fFwL5lrW
         32DWyuHAK+i+CF7FFrrZXriZrwEcmmT/h64pa8JZkZ8nSW7fgLZRcVtdRfO4guUCFdgJ
         mxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685645206; x=1688237206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hvF2IOpQDKKFJsjxOYinWe29JU4zPVFXfARnEjYEpc=;
        b=k9whErKEYEPQfGl2OLW8os/wRt1ldvgjBUkj70ohZ+mGDCY7Yk8f/Vg7lrOH6iIHpC
         JX7y3D6gdUpmg3/gMf73PcprZ0v9D5RSmFU2WuPJG1Dctk4J8Q1W2Uk0xYBTGk0Vk73F
         vQ28Q38H5mGOeIWQGH7VfFfqvNbdZCNptk+lA6ynfW5+tJrmOuka6/SFh4rpuw2wJ/mt
         X0ZlZjN99XyNodcZiY+UYE6EfI/B73Aav5RpGUQUm4Wus43zkAawxDW/M3DtKqxUpOzu
         fv01dD9hMxZez+hQwK3ZkeExtVsat1t2y2L+azJI03iIucZCjO5+koBywEbynmjcTfYl
         qGnA==
X-Gm-Message-State: AC+VfDwkuMBocjSt+MjxCnKDQGDhFs+TeHRqiSwVJfg9RmnBSaeiWd+W
	fGQgZEjLMddgDUAS0G8cA79p68O6N4kMPEAUxjQ=
X-Google-Smtp-Source: ACHHUZ5UwRU26uBSdsIbRD1oAwk2ErCsS1QlxAyzOGA6fKt8uEjAfypc/nihEAbgl9nKyKFuT8xLRIuQfOfh/LV2MB4=
X-Received: by 2002:a05:6214:da9:b0:625:aa49:19f1 with SMTP id
 h9-20020a0562140da900b00625aa4919f1mr12128770qvh.62.1685645205917; Thu, 01
 Jun 2023 11:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
 <CAJD7tkYZxbEyP6-yjcobws_6Cvjib9c9YnBQRBjhwrK3KaHs7A@mail.gmail.com>
 <20230601181849.GA1528196@dev-arch.thelio-3990X> <CAJD7tkZHfmY_0-Many96y5YCb2K_+nfoe2WHkPDPXb2x3hBRdQ@mail.gmail.com>
In-Reply-To: <CAJD7tkZHfmY_0-Many96y5YCb2K_+nfoe2WHkPDPXb2x3hBRdQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 1 Jun 2023 11:46:34 -0700
Message-ID: <CAKEwX=NEFcESOhHTkKneY5i8t9-LOTS_Y=Pfpz7ZaEi5cdk71Q@mail.gmail.com>
Subject: Re: [PATCH] zswap: Avoid uninitialized use of ret in zswap_frontswap_store()
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org, sjenning@redhat.com, 
	ddstreet@ieee.org, vitaly.wool@konsulko.com, ndesaulniers@google.com, 
	trix@redhat.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 11:26=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
> On Thu, Jun 1, 2023 at 11:18=E2=80=AFAM Nathan Chancellor <nathan@kernel.=
org> wrote:
> >
> > On Thu, Jun 01, 2023 at 11:09:48AM -0700, Yosry Ahmed wrote:
> > > On Thu, Jun 1, 2023 at 8:26=E2=80=AFAM Nathan Chancellor <nathan@kern=
el.org> wrote:
> > > >
> > > > Clang warns:
> > > >
> > > >   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized wh=
enever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> > > >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> > > >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >   mm/zswap.c:1327:9: note: uninitialized use occurs here
> > > >    1327 |         return ret;
> > > >         |                ^~~
> > > >   mm/zswap.c:1183:2: note: remove the 'if' if its condition is alwa=
ys false
> > > >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> > > >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >    1184 |                 goto reject;
> > > >         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence=
 this warning
> > > >    1158 |         int ret;
> > > >         |                ^
> > > >         |                 =3D 0
> > > >   1 error generated.
Ooops that's my bad. Thanks for the fix!
> > > >
> > > > Set ret to -EINVAL, which seems to best match the situation the com=
ment
> > > > mentions and matches an earlier bailout due to an unsupported type =
or
> > > > situation.
> > >
> > > Shouldn't this be -ENOMEM? I think this was the error code returned i=
n
> > > this situation before 6804144bf1cf.
> >
> > Sure, I can update this to be -ENOMEM if that is appropriate. I am not
> > sure it actually matters though, since as far as I can tell, this
> > function is only called via the ->store() call in __frontswap_store(),
> > which is only called by frontswap_store(), which in turn is only called=
 by
> > swap_writepage() and its return value is only checked against 0, no
> > other error values. I could be missing a macro call though.
> >
> > If I should send a v2, please let me know.
>
> You are right that no one actually checks the error code now, but it
> would be nice to stay consistent, just in case we want to do proper
> error handling at some point :)
I agree with Yosry - I think ENOMEM is more appropriate here as well.



>
> >
> > Cheers,
> > Nathan
> >
> > > > Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap"=
)
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com=
/
> > > > Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com=
/
> > > > Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> > > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > > ---
> > > >  mm/zswap.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index cff93643a6ab..e8313e2f5807 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned ty=
pe, pgoff_t offset,
> > > >          * local cgroup limits.
> > > >          */
> > > >         objcg =3D get_obj_cgroup_from_page(page);
> > > > -       if (objcg && !obj_cgroup_may_zswap(objcg))
> > > > +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > > > +               ret =3D -EINVAL;
> > > >                 goto reject;
> > > > +       }
> > > >
> > > >         /* reclaim space if needed */
> > > >         if (zswap_is_full()) {
> > > >
> > > > ---
> > > > base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> > > > change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff424=
7ed
> > > >
> > > > Best regards,
> > > > --
> > > > Nathan Chancellor <nathan@kernel.org>
> > > >
> > > >
