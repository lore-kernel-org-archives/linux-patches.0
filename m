Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C21DC12B
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 19:54:03 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-5703cb4bcb4so41277177b3.3
        for <patches@lists.linux.dev>; Sun, 09 Jul 2023 12:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688932442; x=1691524442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6pXGSwyhnHN/RAuNqa0NiZhHV7cOEEEIZDSxSE950g=;
        b=oQiwCtaaXWHKXlac5UAGZP8F00RD6Mz1qQlqRmA848N2SnogesPZuSU6zxi5olI7QH
         ljCI1chSTKTd+f96VO9yLjJRXwDyN7M+c6r18HNDTqQMrfWlbZakLwGP3UyN151sIZL9
         Era2IVRbGNaL3Vdn8cO9/skiAW9zFtT4NfXECz7D8kN7HAEdiT8Pfp97cC7SQhqbXnxW
         +qUUdY9FH0myc4gSwJLREikac043ew2L6iTcJuw7uKQtZv19kyASNDwCBM8NmtszIZUc
         XYwRlZFGr46QGyZYzfikFbpLxjxgRThktTb8SAkdbUTkjXldHJes0eCz0VDSbpQd7pmO
         t6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688932442; x=1691524442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y6pXGSwyhnHN/RAuNqa0NiZhHV7cOEEEIZDSxSE950g=;
        b=KyFoNKqayG7cvb8F0UouMnI4MZ2z9QXj02wTxd/e6wZ/9X9ziasZW+pJYnT1ZI/CoJ
         +4Aa5eJutWa+290a9X/1I03wnJPwh5GfIb9L8mquecBCTPWLpivRNGowms0d4MA0MvdM
         HQGAwgTWCTfzKyNLcyjUJsbsq3904NMgw+xe5Oo6uGQ72rip91y46G53GLx7twTlgze0
         +vUr4s3/3WW6pCqfp7fa7BBJ6kABCtlPCR570y1M8RnEd6JkG5YAcDy19TR5RID+stTT
         ss3N99BDxUPQCr7IWb1rVO1rbYM2MhjXR95U7vQlP8CYJfrGMp7wCdvtz3O3lESxy2SP
         g3gg==
X-Gm-Message-State: ABy/qLYF3rddKTbVDtHznQcHaZ9E8Sq3tlWB+L+FDUhi1zX4QX6OM3Rl
	FDD7VnyQevPtqMY10QVzN5ZIHgZwBG2Loy2zAZT27g==
X-Google-Smtp-Source: APBJJlHOjDvY3L2P2C6aH8eYw1mR/shBrau/mhWuDtkzbIzH3ruBtpOcMB+PmmsbbkpVkBJz3By6zXKwWzxrdUfg55I=
X-Received: by 2002:a81:a010:0:b0:57a:2e83:4daf with SMTP id
 x16-20020a81a010000000b0057a2e834dafmr11477270ywg.32.1688932441782; Sun, 09
 Jul 2023 12:54:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230709111345.297026264@linuxfoundation.org> <20230709111345.516444847@linuxfoundation.org>
 <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info> <2023070904-customer-concise-e6fe@gregkh>
 <CAJuCfpFfc7tvv9CPMx=1b=X-1foiDZ+0bXkVUsFekWB_zNUnLw@mail.gmail.com> <2023070931-conjuror-dweeb-bb4b@gregkh>
In-Reply-To: <2023070931-conjuror-dweeb-bb4b@gregkh>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 9 Jul 2023 19:53:50 +0000
Message-ID: <CAJuCfpHgq_2sZVw7Vv9TuNgBHLO_9f_KAmQ73kFY+093GdMfRg@mail.gmail.com>
Subject: Re: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when forking
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org, 
	patches@lists.linux.dev, David Hildenbrand <david@redhat.com>, 
	Jiri Slaby <jirislaby@kernel.org>, =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, 
	Jacob Young <jacobly.alt@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 9, 2023 at 7:48=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Jul 09, 2023 at 09:04:09AM -0700, Suren Baghdasaryan wrote:
> > On Sun, Jul 9, 2023 at 6:32=E2=80=AFAM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Jul 09, 2023 at 02:39:00PM +0200, Thorsten Leemhuis wrote:
> > > > On 09.07.23 13:14, Greg Kroah-Hartman wrote:
> > > > > From: Suren Baghdasaryan <surenb@google.com>
> > > > >
> > > > > commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.
> > > > >
> > > > > Patch series "Avoid memory corruption caused by per-VMA locks", v=
4.
> > > > >
> > > > > A memory corruption was reported in [1] with bisection pointing t=
o the
> > > > > patch [2] enabling per-VMA locks for x86.  Based on the reproduce=
r
> > > > > provided in [1] we suspect this is caused by the lack of VMA lock=
ing while
> > > > > forking a child process.
> > > > > [...]
> > > >
> > > > Question from someone that is neither a C nor a git expert -- and t=
hus
> > > > might say something totally stupid below (and thus maybe should not=
 have
> > > > sent this mail at all).
> > > >
> > > > But I have to wonder: is adding this patch to stable necessary give=
n
> > > > patch 8/8?
> > > >
> > > > FWIW, this change looks like this:
> > > >
> > > > > ---
> > > > >  kernel/fork.c |    6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > >
> > > > > --- a/kernel/fork.c
> > > > > +++ b/kernel/fork.c
> > > > > @@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
> > > > >             retval =3D -EINTR;
> > > > >             goto fail_uprobe_end;
> > > > >     }
> > > > > +#ifdef CONFIG_PER_VMA_LOCK
> > > > > +   /* Disallow any page faults before calling flush_cache_dup_mm=
 */
> > > > > +   for_each_vma(old_vmi, mpnt)
> > > > > +           vma_start_write(mpnt);
> > > > > +   vma_iter_set(&old_vmi, 0);
> > > > > +#endif
> > > > >     flush_cache_dup_mm(oldmm);
> > > > >     uprobe_dup_mmap(oldmm, mm);
> > > > >     /*
> > > >
> > > > But when I look at kernel/fork.c in mainline I can't see this bit. =
I
> > > > also only see Linus' change (e.g. patch 8/8 in this series) when I =
look at
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
log/kernel/fork.c
> > >
> > > Look at 946c6b59c56d ("Merge tag 'mm-hotfixes-stable-2023-07-08-10-43=
'
> > > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
> > >
> > > Where Linus manually dropped those #ifdefs.
> > >
> > > Hm, I'll leave them for now in 6.4.y as that is "safer", but if Suren
> > > feels comfortable, I'll gladly take a patch from him to drop them in =
the
> > > 6.4.y tree as well.
> >
> > Hi Greg,
> > Give me a couple hours to get back to my computer. Linus took a
> > different version of this patch and changed the description quite a
> > bit. Once I'm home I can send you the patchset that was merged into
> > his tree. Also let me know if you want to disable CONFIG_PER_VMA_LOCK
> > in the stable branch (the patch called "[PATCH 6.4 1/8] mm: disable
> > CONFIG_PER_VMA_LOCK until its fixed" which Linus did not take AFAIKT).
>
> No rush, you can do this on Monday.
>
> I took the patches that Linus added to his tree already into the stable
> 6.4.y tree, and it's in the -rc release I pushed out a few hours ago.

I just checked your stable master branch and it's perfectly in sync
with Linus' tree.

>
> So if you want to look at the -rc release, that would be great, the full
> list of patches can be seen here:
>         https://lore.kernel.org/r/20230709111345.297026264@linuxfoundatio=
n.org

Let me sync git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
to see what's happening there.
Thanks,
Suren.

>
> thanks,
>
> greg k-h
