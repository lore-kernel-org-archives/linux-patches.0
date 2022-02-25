Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7325523A1
	for <patches@lists.linux.dev>; Fri, 25 Feb 2022 14:28:02 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id ay5so2135593plb.1
        for <patches@lists.linux.dev>; Fri, 25 Feb 2022 06:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GFLYYQlWg1u4pZYXk6bRReVXN+TJXsDbN2Z5LBQlK4M=;
        b=p8yJD/xqCtSBUYd+XdI4r7XzAK9wzh0DDyKog2oClXns2LUfEgYqAuqDQNjbYXatnW
         zbEpuCCf4ph++RLETo4pfNvVRuNqTHEn0a37cTaYwf0/kSB3O3WxQeyiHfohtW/lj4cI
         7uKj8hgBtB0syhS+r/YATSgGeN0CgAwsyoT+8Np+nUYN+MI/2aG9mTzc6hKfqkBpUKkq
         H7mOVbnJtYwK93izxnczrYD6D+7xw7T3V4/iSIItJERkt508KW3Tnmet+UjCnuCoQL02
         /wQne9ZBl1VzkgYNH+PX4ntzKltw9/wq6Eyr05OYj4VTib22MfjWdz1bwu93JK+dhHUh
         Fk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GFLYYQlWg1u4pZYXk6bRReVXN+TJXsDbN2Z5LBQlK4M=;
        b=rGTQH6Azz/vRRHyhabpbJVhgLbpNtIAXohYooiQdAgQHMteI6+BsiYSXL2jGHR+CMz
         N/wCjWrqEC/lFUJvXleRXDWbmcd8/Rkw4oAfrUB297q8jW8+0cfin76Gwvplg+K3UVLd
         IMI+gL1hvHe5xAIgguSvdFBChcmITuVVEYN2Q6ymzX3Cq8314nmuCgM+5JBuHOWqajZZ
         2he8PerzXhd4Dnscg5JGoNtxE+EAYiVEpd8FKPLIQxr7Lcfs9QQ1aNofFGD8wtCzXbox
         ztIm6oswiiK63umVcjXNb0IwgYNjBCakte0O/Q9zrhJyVVCmMXo4lEFzlol3S36gWTDj
         zePw==
X-Gm-Message-State: AOAM53253fAsjc9gzQJFpppD/21oQf10waKfa6fRORhOaWs0grECR2uq
	iUgqN24RFBdZV3g2U4dSgh8FK6eNF5KpF2BJHWo=
X-Google-Smtp-Source: ABdhPJzR/AXKvc90+oYK7YNeq+OXjjqBlkF5sdO7ZjaNE7bcasrImCEo+W+cECzj2EjIirRbg3xkF33PwLe2Zwf5EpA=
X-Received: by 2002:a17:903:240a:b0:14e:dad4:5ce4 with SMTP id
 e10-20020a170903240a00b0014edad45ce4mr7833792plo.125.1645799281704; Fri, 25
 Feb 2022 06:28:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220218122019.130274-1-matenajakub@gmail.com>
 <20220218122019.130274-2-matenajakub@gmail.com> <20220218194338.5sdi7jwusfvh3b45@revolver>
In-Reply-To: <20220218194338.5sdi7jwusfvh3b45@revolver>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Fri, 25 Feb 2022 15:26:59 +0100
Message-ID: <CABsDyaLxkAcZb2GZTqXJM9kc5mtkk=N-hrdCHKn-jW+BC1x=RA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] [PATCH 1/4] mm: refactor of vma_merge()
To: Liam Howlett <liam.howlett@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mhocko@kernel.org" <mhocko@kernel.org>, 
	"mgorman@techsingularity.net" <mgorman@techsingularity.net>, "willy@infradead.org" <willy@infradead.org>, 
	"hughd@google.com" <hughd@google.com>, "kirill@shutemov.name" <kirill@shutemov.name>, 
	"riel@surriel.com" <riel@surriel.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"peterz@infradead.org" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 18, 2022 at 8:43 PM Liam Howlett <liam.howlett@oracle.com> wrot=
e:
>
> * Jakub Mat=C4=9Bna <matenajakub@gmail.com> [220218 07:21]:
> > Refactor vma_merge() to make it shorter, more understandable and
> > suitable for tracing of successful merges made possible by following
> > patches in the series.
> >
> > Signed-off-by: Jakub Mat=C4=9Bna <matenajakub@gmail.com>
> > ---
> >  mm/mmap.c | 81 +++++++++++++++++++++++++++----------------------------
> >  1 file changed, 39 insertions(+), 42 deletions(-)
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 1e8fdb0b51ed..b55e11f20571 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1172,6 +1172,9 @@ struct vm_area_struct *vma_merge(struct mm_struct=
 *mm,
> >       pgoff_t pglen =3D (end - addr) >> PAGE_SHIFT;
> >       struct vm_area_struct *area, *next;
> >       int err;
> > +     int merge_prev =3D 0;
> > +     int merge_both =3D 0;
> > +     int merge_next =3D 0;
>
> You set these as true, can you please use booleans?

As you mentioned in another email. This corresponds with one of the
following patches,
but you are right, booleans should be used here.

>
> >
> >       /*
> >        * We later require that vma->vm_flags =3D=3D vm_flags,
> > @@ -1191,65 +1194,59 @@ struct vm_area_struct *vma_merge(struct mm_stru=
ct *mm,
> >       VM_WARN_ON(addr >=3D end);
> >
> >       /*
> > -      * Can it merge with the predecessor?
> > +      * Can we merge predecessor?
> >        */
> >       if (prev && prev->vm_end =3D=3D addr &&
> >                       mpol_equal(vma_policy(prev), policy) &&
> >                       can_vma_merge_after(prev, vm_flags,
> >                                           anon_vma, file, pgoff,
> >                                           vm_userfaultfd_ctx, anon_name=
)) {
> > -             /*
> > -              * OK, it can.  Can we now merge in the successor as well=
?
> > -              */
> > -             if (next && end =3D=3D next->vm_start &&
> > -                             mpol_equal(policy, vma_policy(next)) &&
> > -                             can_vma_merge_before(next, vm_flags,
> > -                                                  anon_vma, file,
> > -                                                  pgoff+pglen,
> > -                                                  vm_userfaultfd_ctx, =
anon_name) &&
> > -                             is_mergeable_anon_vma(prev->anon_vma,
> > -                                                   next->anon_vma, NUL=
L)) {
> > -                                                     /* cases 1, 6 */
> > -                     err =3D __vma_adjust(prev, prev->vm_start,
> > -                                      next->vm_end, prev->vm_pgoff, NU=
LL,
> > -                                      prev);
> > -             } else                                  /* cases 2, 5, 7 =
*/
> > -                     err =3D __vma_adjust(prev, prev->vm_start,
> > -                                      end, prev->vm_pgoff, NULL, prev)=
;
> > -             if (err)
> > -                     return NULL;
> > -             khugepaged_enter_vma_merge(prev, vm_flags);
> > -             return prev;
> > +             merge_prev =3D true;
>
> You could set area =3D prev here and simplify the if statements below.

Thanks I will.

>
> >       }
> > -
> >       /*
> > -      * Can this new request be merged in front of next?
> > +      * Can we merge successor?
> >        */
> >       if (next && end =3D=3D next->vm_start &&
> >                       mpol_equal(policy, vma_policy(next)) &&
> >                       can_vma_merge_before(next, vm_flags,
> > -                                          anon_vma, file, pgoff+pglen,
> > -                                          vm_userfaultfd_ctx, anon_nam=
e)) {
> > +                                     anon_vma, file, pgoff+pglen,
> > +                                     vm_userfaultfd_ctx, anon_name)) {
> > +             merge_next =3D true;
> > +     }
> > +     /*
> > +      * Can we merge both predecessor and successor?
> > +      */
> > +     if (merge_prev && merge_next)
> > +             merge_both =3D is_mergeable_anon_vma(prev->anon_vma, next=
->anon_vma, NULL);
> > +
> > +     if (merge_both) {        /* cases 1, 6 */
> > +             err =3D __vma_adjust(prev, prev->vm_start,
> > +                                     next->vm_end, prev->vm_pgoff, NUL=
L,
> > +                                     prev);
> > +             area =3D prev;
>
> I don't think you need all three booleans since merge_both is only used
> here.

This again corresponds with one of the following patches, but in this
patch merge_both is not needed.

>
> > +     } else if (merge_prev) {                        /* cases 2, 5, 7 =
*/
> > +             err =3D __vma_adjust(prev, prev->vm_start,
> > +                                     end, prev->vm_pgoff, NULL, prev);
> > +             area =3D prev;
> > +     } else if (merge_next) {
> >               if (prev && addr < prev->vm_end)        /* case 4 */
> >                       err =3D __vma_adjust(prev, prev->vm_start,
> > -                                      addr, prev->vm_pgoff, NULL, next=
);
> > -             else {                                  /* cases 3, 8 */
> > +                                     addr, prev->vm_pgoff, NULL, next)=
;
> > +             else                                    /* cases 3, 8 */
> >                       err =3D __vma_adjust(area, addr, next->vm_end,
> > -                                      next->vm_pgoff - pglen, NULL, ne=
xt);
> > -                     /*
> > -                      * In case 3 area is already equal to next and
> > -                      * this is a noop, but in case 8 "area" has
> > -                      * been removed and next was expanded over it.
> > -                      */
>
> I think the above comment is still true?

Yes, it is. It just slipped away.

>
> > -                     area =3D next;
> > -             }
> > -             if (err)
> > -                     return NULL;
> > -             khugepaged_enter_vma_merge(area, vm_flags);
> > -             return area;
> > +                                     next->vm_pgoff - pglen, NULL, nex=
t);
> > +             area =3D next;
> > +     } else {
> > +             err =3D -1;
> >       }
>
> If you initialize err to something, you can drop this else.

Thank you, that sounds better.

>
> >
> > -     return NULL;
> > +     /*
> > +      * Cannot merge with predecessor or successor or error in __vma_a=
djust?
> > +      */
> > +     if (err)
> > +             return NULL;
> > +     khugepaged_enter_vma_merge(area, vm_flags);
> > +     return area;
> >  }
> >
> >  /*
> > --
> > 2.34.1
> >
