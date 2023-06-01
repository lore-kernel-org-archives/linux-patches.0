Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4523DF;
	Thu,  1 Jun 2023 19:21:33 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6261890b4d7so11259246d6.1;
        Thu, 01 Jun 2023 12:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685647292; x=1688239292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+p9XIZJG/A6xmQ4kFGTK7aR6dtQd2oet/kCPom82kk=;
        b=rfpYO41fkXDWP4QQsgPDC8asAst8GxcVu9e6BWaGIAFZTNq0m8jWBr/wGETMqRZgId
         l9lumKeDbuKaKlds+JBfU/0BPXVdGxvo1bSTAqbjJG2L7O5Mk6aa8XFIuLLCAMmW0eTr
         FIejmDcM4QfsPxiobduZEODF70BPd8PS2R85Rt5Og8fMW2kJfRCGqV1b0oVFL8r3/KOr
         Eptr0m/jYQmoxerdR2xGnjIvYzrIlEiVu1SbuA1DSrB3NCquAM9EgJKYB7e8IOyiUFIh
         1PE02+DlzMzWmhNqU8TGVv0s+cnoGuTG92AvYik+D/WFS7yI+7UrYA0OZ02hgIs3ZYHM
         BnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685647292; x=1688239292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+p9XIZJG/A6xmQ4kFGTK7aR6dtQd2oet/kCPom82kk=;
        b=aGlH/IR88HAmcQkSTzrUZFgqm5+bnJVCav2s1anp+IjB0muG6MWFNYK8pPULuhGPIs
         FXM7ACJARuw9enF8cmhttBSjCBwQ0Ez8+zAAQ6nTaIxA0uK6YwO6Cql6AcwU0wwSzcuM
         JJoaMkycTIFCnnNmlydm+xfVXGeREXi7zuAtakcVqe+7HUxFbLqhA0Zz/gavwZgKe7J/
         n+LfQO5U4iRUkIbMVewn2+RZwBTjUGcyJCQ5zH6omIVEl3mMBd/H+uWB4oCiX4Bj3Zt+
         UXlvuD+kKzGyA3M6nC4gCvaDSthowWYfXDkaSFrgPmPNU800kdGCAQz5N6ZGmenpg8sn
         NSlA==
X-Gm-Message-State: AC+VfDwcm9pfTJOok1qGvihlQ6B1Y37W3qiu/5z1VlV8ZkIXT8OcOw3N
	K/ZuPLb4XBY2lv0udmwaKVL4Anjww+k/UzyqByA=
X-Google-Smtp-Source: ACHHUZ7Q5WF2c1H0jlery4o2IQf3X/dz60h5oQj06l0/Lo5V5iRN1dyj9i+/klKbMcQvuYlj4gSASFFbjczTnIAdaZY=
X-Received: by 2002:a05:6214:62e:b0:624:fedf:48ec with SMTP id
 a14-20020a056214062e00b00624fedf48ecmr10943476qvx.37.1685647292019; Thu, 01
 Jun 2023 12:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v2-1-84912684ac35@kernel.org>
 <CAJD7tkYymYNHt9NfYq3s5KR0BytzD8bCo7oaR8T7C2hXZdgGpw@mail.gmail.com>
In-Reply-To: <CAJD7tkYymYNHt9NfYq3s5KR0BytzD8bCo7oaR8T7C2hXZdgGpw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 1 Jun 2023 12:21:21 -0700
Message-ID: <CAKEwX=OCC+W2+wdryiO3ieWT0cMzqcim_5N3y4ZQisQBL9F9LA@mail.gmail.com>
Subject: Re: [PATCH v2] zswap: Avoid uninitialized use of ret in zswap_frontswap_store()
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org, sjenning@redhat.com, 
	ddstreet@ieee.org, vitaly.wool@konsulko.com, ndesaulniers@google.com, 
	trix@redhat.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 11:36=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com>=
 wrote:
>
> On Thu, Jun 1, 2023 at 11:34=E2=80=AFAM Nathan Chancellor <nathan@kernel.=
org> wrote:
> >
> > Clang warns:
> >
> >   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized whenev=
er 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   mm/zswap.c:1327:9: note: uninitialized use occurs here
> >    1327 |         return ret;
> >         |                ^~~
> >   mm/zswap.c:1183:2: note: remove the 'if' if its condition is always f=
alse
> >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1184 |                 goto reject;
> >         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence thi=
s warning
> >    1158 |         int ret;
> >         |                ^
> >         |                 =3D 0
> >   1 error generated.
> >
> > This condition used to return -ENOMEM by going to the shrink label, so
> > set ret to -ENOMEM in the if block explicitly to avoid using it
> > uninitialized.
> >
> > Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
> > Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Thanks!
>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
>
> > ---
> > Changes in v2:
> > - Change ret to -ENOMEM to match this condition's previous return value
> >   (Yosry)
> > - Link to v1: https://lore.kernel.org/r/20230601-zswap-cgroup-wsometime=
s-uninitialized-v1-1-35debdd19293@kernel.org
> > ---
> >  mm/zswap.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index cff93643a6ab..30092d9a3b23 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type, =
pgoff_t offset,
> >          * local cgroup limits.
> >          */
> >         objcg =3D get_obj_cgroup_from_page(page);
> > -       if (objcg && !obj_cgroup_may_zswap(objcg))
> > +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > +               ret =3D -ENOMEM;
> >                 goto reject;
> > +       }
> >
> >         /* reclaim space if needed */
> >         if (zswap_is_full()) {
> >
> > ---
> > base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> > change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247ed
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
Acked-by: Nhat Pham <nphamcs@gmail.com>
