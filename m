Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE6817F9
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 14:32:23 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d187so14354052pfa.10
        for <patches@lists.linux.dev>; Tue, 01 Mar 2022 06:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eOtRz7uwqvvpGVdB7/JDXN6VIkmPBXC91IW15jwGmcU=;
        b=HnoLWfolcQSFWB3mEvyxtZlXLEYifzyTr676lggHyxkL6dy53ymdlm6Vc7IQ6cFzav
         H3adyC9CDF9LXL+btATLfe1rxKoPYmKmtZXMf1OZV4sGDcjacA/3jOua4V8POnvTHknD
         pM6wa5rA3NzHu/QafM9YvRR3wcFr872qhbTFJYwEGvLS9WE4f0fNCS7atIJaNm55Je6E
         3X3yI2Jof0Y1PLvnWM+7z69m6Jp7MkMQJZrV+4K/3BPTEtaYbTMCI6CfNkLTfmTOL9K9
         nsqa2ATnDp7oCk2VOMjY2Jm4XILPa6t8zWT6AB8yjbYZifpdSaBQY7yyZAyl5ZD61Htd
         262Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eOtRz7uwqvvpGVdB7/JDXN6VIkmPBXC91IW15jwGmcU=;
        b=m640yD6za1FnryxdgTd7LIRUHYNmSuMFIDgeagWxpbectEcARQPR6LqzjmwPwPvoF/
         liNXABbArbc0wxGRurZRp1GGSTOOEtvZirj8JxpGztP0A0gxUarEWT2K2zL+Lu+h2aLc
         spuu/D2j+ZOrVcy0kvzeCQTNq1BHDLkzCBjIbo24iBpEVeh1XW3fttzZk3+cskVdkNnm
         RfXfRWFHfW/TrR+MjDu7JIy4R3mKb4SXWV9+yzkZm7ah+yPoN0xUTvBodxYXfmjkdGmg
         woSuiiC2gmZ+UiuF0PogYlZ4k1ewFwlnn5RPFJm6oQNmCSUlRcl9F9aDkz0JpGNxm9mC
         8ifQ==
X-Gm-Message-State: AOAM530aJho+ffP8DdUA4z3+X6DIERhPL/y9DPqKXXXuXpwtOJFG3xOU
	4LlPBODvjJz2yFbiOc2H4AUY6y2y2dY3cgSDDu8=
X-Google-Smtp-Source: ABdhPJxy3Efv5wjxMwk05ZULSks28z+OmahtT5ghxTdbVXmtuZUXdvE1wbS3lmCJT0jT+Yx2wZi8n+JnIGwZsPK6Ubc=
X-Received: by 2002:a65:5a06:0:b0:375:81c9:74b1 with SMTP id
 y6-20020a655a06000000b0037581c974b1mr22205369pgs.122.1646145143311; Tue, 01
 Mar 2022 06:32:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220218122019.130274-1-matenajakub@gmail.com>
 <20220218122019.130274-3-matenajakub@gmail.com> <20220218195047.bplrholzx4h2id2i@revolver>
In-Reply-To: <20220218195047.bplrholzx4h2id2i@revolver>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Tue, 1 Mar 2022 15:31:00 +0100
Message-ID: <CABsDya+vtfKAbEjA-33_yTQXOgSj6T_whcqB=p3=ZkvCTTHGFA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] [PATCH 2/4] mm: adjust page offset in mremap
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

On Fri, Feb 18, 2022 at 8:50 PM Liam Howlett <liam.howlett@oracle.com> wrot=
e:
>
> * Jakub Mat=C4=9Bna <matenajakub@gmail.com> [220218 07:21]:
> > Adjust page offset of a VMA when it's moved to a new location by mremap=
.
> > This is made possible for all VMAs that do not share their anonymous
> > pages with other processes. Previously this was possible only for not
> > yet faulted VMAs.
> > When the page offset does not correspond to the virtual address
> > of the anonymous VMA any merge attempt with another VMA will fail.
>
> I don't know enough to fully answer this but I think this may cause
> issues with rmap?  I would think the anon vma lock is necessary but I
> may be missing something.

Lock ordering for memory management is specified at the beginning of
mm/rmap.c file and implies that in order to lock anon_vma->rwsem, you
first have to lock mm->mmap_lock. mm->mmap_lock is locked in mremap
syscall via mmap_write_lock_killable(). Moreover in the newly
introduced function update_faulted_pgoff() there is a condition that
checks if the vma does not share some physical pages with other
processes. And therefore other processes shouldn't interfere with the
locks either.

>
> >
> > Signed-off-by: Jakub Mat=C4=9Bna <matenajakub@gmail.com>
> > ---
> >  mm/mmap.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 95 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index b55e11f20571..8d253b46b349 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -3224,6 +3224,91 @@ int insert_vm_struct(struct mm_struct *mm, struc=
t vm_area_struct *vma)
> >       return 0;
> >  }
> >
> > +bool rbst_no_children(struct anon_vma *av, struct rb_node *node)
> > +{
> > +     struct anon_vma_chain *model;
> > +     struct anon_vma_chain *avc;
> > +
> > +     if (node =3D=3D NULL) /* leaf node */
> > +             return true;
> > +     avc =3D container_of(node, typeof(*(model)), rb);
> > +     if (avc->vma->anon_vma !=3D av)
> > +             /*
> > +              * Inequality implies avc belongs
> > +              * to a VMA of a child process
> > +              */
> > +             return false;
> > +     return (rbst_no_children(av, node->rb_left) &&
> > +     rbst_no_children(av, node->rb_right));
> > +}
> > +
> > +/*
> > + * Check if none of the VMAs connected to the given
> > + * anon_vma via anon_vma_chain are in child relationship
> > + */
> > +bool rbt_no_children(struct anon_vma *av)
> > +{
> > +     struct rb_node *root_node;
> > +
> > +     if (av =3D=3D NULL || av->degree <=3D 1) /* Higher degree might n=
ot necessarily imply children */
> > +             return true;
> > +     root_node =3D av->rb_root.rb_root.rb_node;
> > +     return rbst_no_children(av, root_node);
> > +}
> > +
> > +/**
> > + * update_faulted_pgoff() - Update faulted pages of a vma
> > + * @vma: VMA being moved
> > + * @addr: new virtual address
> > + * @pgoff: pointer to pgoff which is updated
> > + * If the vma and its pages are not shared with another process, updat=
e
> > + * the new pgoff and also update index parameter (copy of the pgoff) i=
n
> > + * all faulted pages.
> > + */
> > +bool update_faulted_pgoff(struct vm_area_struct *vma, unsigned long ad=
dr, pgoff_t *pgoff)
> > +{
> > +     unsigned long pg_iter =3D 0;
> > +     unsigned long pg_iters =3D (vma->vm_end - vma->vm_start) >> PAGE_=
SHIFT;
> > +
> > +     /* 1.] Check vma is not shared with other processes */
> > +     if (vma->anon_vma->root !=3D vma->anon_vma || !rbt_no_children(vm=
a->anon_vma))
> > +             return false;
> > +
> > +     /* 2.] Check all pages are not shared */
> > +     for (; pg_iter < pg_iters; ++pg_iter) {
> > +             bool pages_not_shared =3D true;
> > +             unsigned long shift =3D pg_iter << PAGE_SHIFT;
> > +             struct page *phys_page =3D follow_page(vma, vma->vm_start=
 + shift, FOLL_GET);
> > +
> > +             if (phys_page =3D=3D NULL)
> > +                     continue;
> > +
> > +             /* Check page is not shared with other processes */
> > +             if (page_mapcount(phys_page) > 1)
> > +                     pages_not_shared =3D false;
> > +             put_page(phys_page);
> > +             if (!pages_not_shared)
> > +                     return false;
> > +     }
> > +
> > +     /* 3.] Update index in all pages to this new pgoff */
> > +     pg_iter =3D 0;
> > +     *pgoff =3D addr >> PAGE_SHIFT;
> > +
> > +     for (; pg_iter < pg_iters; ++pg_iter) {
> > +             unsigned long shift =3D pg_iter << PAGE_SHIFT;
> > +             struct page *phys_page =3D follow_page(vma, vma->vm_start=
 + shift, FOLL_GET);
> > +
> > +             if (phys_page =3D=3D NULL)
> > +                     continue;
> > +             lock_page(phys_page);
> > +             phys_page->index =3D *pgoff + pg_iter;
> > +             unlock_page(phys_page);
> > +             put_page(phys_page);
> > +     }
> > +     return true;
> > +}
> > +
> >  /*
> >   * Copy the vma structure to a new location in the same mm,
> >   * prior to moving page table entries, to effect an mremap move.
> > @@ -3237,15 +3322,19 @@ struct vm_area_struct *copy_vma(struct vm_area_=
struct **vmap,
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *new_vma, *prev;
> >       struct rb_node **rb_link, *rb_parent;
> > -     bool faulted_in_anon_vma =3D true;
> > +     bool anon_pgoff_updated =3D false;
> >
> >       /*
> > -      * If anonymous vma has not yet been faulted, update new pgoff
> > +      * Try to update new pgoff for anonymous vma
> >        * to match new location, to increase its chance of merging.
> >        */
> > -     if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
> > -             pgoff =3D addr >> PAGE_SHIFT;
> > -             faulted_in_anon_vma =3D false;
> > +     if (unlikely(vma_is_anonymous(vma))) {
> > +             if (!vma->anon_vma) {
> > +                     pgoff =3D addr >> PAGE_SHIFT;
> > +                     anon_pgoff_updated =3D true;
> > +             } else {
> > +                     anon_pgoff_updated =3D update_faulted_pgoff(vma, =
addr, &pgoff);
> > +             }
> >       }
> >
> >       if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_par=
ent))
> > @@ -3271,7 +3360,7 @@ struct vm_area_struct *copy_vma(struct vm_area_st=
ruct **vmap,
> >                        * safe. It is only safe to keep the vm_pgoff
> >                        * linear if there are no pages mapped yet.
> >                        */
> > -                     VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
> > +                     VM_BUG_ON_VMA(!anon_pgoff_updated, new_vma);
> >                       *vmap =3D vma =3D new_vma;
> >               }
> >               *need_rmap_locks =3D (new_vma->vm_pgoff <=3D vma->vm_pgof=
f);
> > --
> > 2.34.1
> >
