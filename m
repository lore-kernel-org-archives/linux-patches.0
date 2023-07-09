Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570BD5C96
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 16:04:22 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-579efc32377so42116827b3.1
        for <patches@lists.linux.dev>; Sun, 09 Jul 2023 09:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688918661; x=1691510661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0KuvByoHXqktYCrSIjlqlmfrcAGG/sOVhs4IK75ISs=;
        b=fHzfS+XS7hDxpVUXH1JAWIvnmBSq0QBjlMylToZ/FmCp0WP1/o4SVsbcd56dk6UN2R
         2aFILPrCr+zBVhJGKhmSVQBocxLSdgmLzZ1NNIvQxu6PMPkgxfq7BalTlmt8YtVyC6sl
         bgmHJ8Utq6q6SOqipetr/WCWtbyEu7uueOGDcYKPeoX5M8qSZ8KD8aNIZQl6pnqPhmc9
         ZGMODxxv9a4EeA7bdahl4YsnauWBAWWeIeboLLmzDK5OqJKT2npCkCHaCf+ZkmSsZrep
         OIKK49fynQIgevEnEzf+HnvKPd2uZ1MmbmK7T8tlAKqt8YL2iQaikXYeKYhZJdioHUFj
         MYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688918661; x=1691510661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0KuvByoHXqktYCrSIjlqlmfrcAGG/sOVhs4IK75ISs=;
        b=jiYnagKfg3cxGncl6MMoVSg8Q3fAyDc+Er3NroTRy8E8dPJkZiwn3buM/xqvc71zLE
         IRFiSqx1ZFuuuZ9O0Mstf1zQ0IOW+wbb298pBtZUtGPynMQXCmVgOoCvOZelm+aS0sA6
         G2q/4O4aGXxs5kVPxbFkjYLkNh8rOkXXoKJfagyeIzWrSyfTU3SB/nVI9IKSbL3tMYkm
         z7BNqnRtOkU7qJK4OCFc+dwwzLExB6K9n5bJ2NLedqXyM7/llwdMwnKZu/KlhRkP6CyH
         ixpXuZNO+KS78xEvBZjrtAKx/iqZ4ud1c3i4vSWnM9DA4Kgx7kBXZqMI82VAKhFLhM0p
         2Udw==
X-Gm-Message-State: ABy/qLaRDjPjhZNScCIitv0qYatAMlBdBBfsq/DByzDHhjshOjJcO6Ug
	KHeFBocASTrsImfsj3/BgDSeplUDm6JPLb3PuE0xBQ==
X-Google-Smtp-Source: APBJJlEG5dgfk0Bp+rosc8yPULNzdLqJl8u/liKJjAw7PkUJ0zBiIb05b27NpeqMvxl/PVGgg7ZxJUv/bO7xDcDcFok=
X-Received: by 2002:a81:8353:0:b0:56d:325c:442 with SMTP id
 t80-20020a818353000000b0056d325c0442mr8553914ywf.31.1688918660952; Sun, 09
 Jul 2023 09:04:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230709111345.297026264@linuxfoundation.org> <20230709111345.516444847@linuxfoundation.org>
 <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info> <2023070904-customer-concise-e6fe@gregkh>
In-Reply-To: <2023070904-customer-concise-e6fe@gregkh>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 9 Jul 2023 09:04:09 -0700
Message-ID: <CAJuCfpFfc7tvv9CPMx=1b=X-1foiDZ+0bXkVUsFekWB_zNUnLw@mail.gmail.com>
Subject: Re: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when forking
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org, 
	patches@lists.linux.dev, David Hildenbrand <david@redhat.com>, 
	Jiri Slaby <jirislaby@kernel.org>, =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, 
	Jacob Young <jacobly.alt@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 9, 2023 at 6:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Jul 09, 2023 at 02:39:00PM +0200, Thorsten Leemhuis wrote:
> > On 09.07.23 13:14, Greg Kroah-Hartman wrote:
> > > From: Suren Baghdasaryan <surenb@google.com>
> > >
> > > commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.
> > >
> > > Patch series "Avoid memory corruption caused by per-VMA locks", v4.
> > >
> > > A memory corruption was reported in [1] with bisection pointing to th=
e
> > > patch [2] enabling per-VMA locks for x86.  Based on the reproducer
> > > provided in [1] we suspect this is caused by the lack of VMA locking =
while
> > > forking a child process.
> > > [...]
> >
> > Question from someone that is neither a C nor a git expert -- and thus
> > might say something totally stupid below (and thus maybe should not hav=
e
> > sent this mail at all).
> >
> > But I have to wonder: is adding this patch to stable necessary given
> > patch 8/8?
> >
> > FWIW, this change looks like this:
> >
> > > ---
> > >  kernel/fork.c |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
> > >             retval =3D -EINTR;
> > >             goto fail_uprobe_end;
> > >     }
> > > +#ifdef CONFIG_PER_VMA_LOCK
> > > +   /* Disallow any page faults before calling flush_cache_dup_mm */
> > > +   for_each_vma(old_vmi, mpnt)
> > > +           vma_start_write(mpnt);
> > > +   vma_iter_set(&old_vmi, 0);
> > > +#endif
> > >     flush_cache_dup_mm(oldmm);
> > >     uprobe_dup_mmap(oldmm, mm);
> > >     /*
> >
> > But when I look at kernel/fork.c in mainline I can't see this bit. I
> > also only see Linus' change (e.g. patch 8/8 in this series) when I look=
 at
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/=
kernel/fork.c
>
> Look at 946c6b59c56d ("Merge tag 'mm-hotfixes-stable-2023-07-08-10-43'
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
>
> Where Linus manually dropped those #ifdefs.
>
> Hm, I'll leave them for now in 6.4.y as that is "safer", but if Suren
> feels comfortable, I'll gladly take a patch from him to drop them in the
> 6.4.y tree as well.

Hi Greg,
Give me a couple hours to get back to my computer. Linus took a
different version of this patch and changed the description quite a
bit. Once I'm home I can send you the patchset that was merged into
his tree. Also let me know if you want to disable CONFIG_PER_VMA_LOCK
in the stable branch (the patch called "[PATCH 6.4 1/8] mm: disable
CONFIG_PER_VMA_LOCK until its fixed" which Linus did not take AFAIKT).
Thanks,
Suren.

>
> thanks,
>
> greg k-h
