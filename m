Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166071990CE
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775477; cv=none; b=GGEkyweeib4cG7TW8r07wfNsqq8j243MKiTuDESQQZZcf8FOB+VcVigWRDvjw0PQ+CYirfHZOhoTZ3vowOXhQP4m0uleyhmoKvg58+oIlQYaUaaEs7kErrD1REwMZgmjscwTazi74WANwy1r9RRUXOtTzPTbYU0M8GQvNkieHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775477; c=relaxed/simple;
	bh=B/nWxWSuvalMGnUtnURKHG5HNXcPjMpI5YfholgjWCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P057HRe3vpFkyMVIL/lBcM9MW0AOnHAWWLEOZsZfH69gq96IFpUFnYlM9v7DOM8YxJhiPnEuZqQitKXsWwcMg3aV6qPDZV2E5vvT5LAXo24+DLfP2bfgBBvP41gXFh+LhWalMcn5uRSY53tBGYkQ6J/2vwgoDyeMN2ZXvsEXo5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nw8g1fwZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nw8g1fwZ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57c5ec83886so9939a12.1
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 08:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717775472; x=1718380272; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPvYVfHAHLIq4Iro9sltEbUBk0XQCsjazy7jWcwOLxU=;
        b=nw8g1fwZ4OrH1LgLICYpzx4HaI4n6r2vfEzYgennpHfnyKaID5feKgXHFZmKgENxrF
         5VcWr9OesyI5jQF1POpgV1bCUVi0jO+3Pimtnon9MC4HDooKnyCmnLPyXTT68zeiX3gE
         9fNeFqyokfr+D3mdFXhi1K38Ff7p3ZAMBIoXUIBVtz+clYhIwUm1eeiNLJvSOIFdJi4h
         aDbeo5Xqxi0taixYa/b9S/i/XOKeoizgBT8byRngSYENDH0xnj2lmeMZA3VcceK/ntbE
         DdCbncGYsqiDba+g8g3GCDt+s+v0ShxsgdYGYmy/NVh/1khkYjlQpDHZNR35vFIZLnVC
         BDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717775472; x=1718380272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPvYVfHAHLIq4Iro9sltEbUBk0XQCsjazy7jWcwOLxU=;
        b=BS/e4Awoxw2q310GmJZ/rEbjpl52GIKZctDLY1M4xvqfyf4hTc0Fa47tkki5hdlT+l
         3NgwfA1FYXIDw0U8uO1rR0+JuP8ABBySg4hXq0SPq+A0kb7nOzLAWxq1BEBk4b8ixK2O
         fX259e1p7t63UwUu8YAsm1jxnPkQOO3uyiHbF6g+we2FYXdwcONameSKQsVwM2QYpIcO
         +T7vse7rZOOjEdYvbperZBVef39PgTXfa8tGemDzX2eOxW6M2xEYJAYkhOIVMC5lLYhO
         Jws7zghN/o8FbMKIZiFHtxHdbK1POdbfTOdfIE7A8va1XBDJfFSxYjXRvKNTHlng6eax
         S1iA==
X-Forwarded-Encrypted: i=1; AJvYcCUHZGXdGR4sVvMbaJKTdqmeL+VQkXxBjfbM8PQykGhKAKSFOSws+iKe0IptxXwH37UZsULY7eD9uKSQ51R1pCAFpihKanCxbA==
X-Gm-Message-State: AOJu0Yw4BhMF23FV+SHhELv/qmwTjUlKRKHSxxhW6NJKhCM/F/u0cGRa
	MYbLehkxd5jpOqBRmFfBv1OkF9lQQ+xCoufnHBxX13z4m+ylRpP9sBtV+b+pcPR+9ZZ0ky9HrCU
	w6tJfiWytti5uJ1XqIesFYQCXsXtKpHVXmwxk
X-Google-Smtp-Source: AGHT+IFeaOng9QTrsWteV8BPFpGm8tSsyktUl7ikHk3iad/5dvNpRpMcHTMxQVUYRtOOO2V2JmvFuTBVrMMVB25rokM=
X-Received: by 2002:aa7:c0c5:0:b0:57c:5ffb:9917 with SMTP id
 4fb4d7f45d1cf-57c5ffb99b5mr135769a12.4.1717775472242; Fri, 07 Jun 2024
 08:51:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
 <CAG48ez0P3EDXC0uLLPjSjx3i6qB3fcdZbL2kYyuK6fZ_nJeN5w@mail.gmail.com>
 <Zlm-26QuqOSpXQg7@zx2c4.com> <CAG48ez3VhWpJnzHHn4NAJdrsd1Ts9hs0zvHa6Pqwatu4wV63Kw@mail.gmail.com>
 <ZmMamtll1Yq1yfxc@zx2c4.com> <CAG48ez0pan8aLGjHtoDdrpiP+e5YrGeuD_RzDXgzUwkUvWYLjA@mail.gmail.com>
In-Reply-To: <CAG48ez0pan8aLGjHtoDdrpiP+e5YrGeuD_RzDXgzUwkUvWYLjA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 7 Jun 2024 17:50:34 +0200
Message-ID: <CAG48ez1k0J013tYLfmnT8NXRpG_5BR10xnH8r-yRvTLpJe-nLA@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 5:12=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Fri, Jun 7, 2024 at 4:35=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.co=
m> wrote:
> > On Fri, May 31, 2024 at 03:00:26PM +0200, Jann Horn wrote:
> > > On Fri, May 31, 2024 at 2:13=E2=80=AFPM Jason A. Donenfeld <Jason@zx2=
c4.com> wrote:
> > > > On Fri, May 31, 2024 at 12:48:58PM +0200, Jann Horn wrote:
> > > > > On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason=
@zx2c4.com> wrote:
> > > > > > c) If there's not enough memory to service a page fault, it's n=
ot fatal.
> > > > > [...]
> > > > > > @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_are=
a_struct *vma, unsigned long address,
> > > > > >
> > > > > >         lru_gen_exit_fault();
> > > > > >
> > > > > > +       /* If the mapping is droppable, then errors due to OOM =
aren't fatal. */
> > > > > > +       if (vma->vm_flags & VM_DROPPABLE)
> > > > > > +               ret &=3D ~VM_FAULT_OOM;
> > > > >
> > > > > Can you remind me how this is supposed to work? If we get an OOM
> > > > > error, and the error is not fatal, does that mean we'll just keep
> > > > > hitting the same fault handler over and over again (until we happ=
en to
> > > > > have memory available again I guess)?
> > > >
> > > > Right, it'll just keep retrying. I agree this isn't great, which is=
 why
> > > > in the 2023 patchset, I had additional code to simply skip the faul=
ting
> > > > instruction, and then the userspace code would notice the inconsist=
ency
> > > > and fallback to the syscall. This worked pretty well. But it meant
> > > > decoding the instruction and in general skipping instructions is we=
ird,
> > > > and that made this patchset very very contentious. Since the skippi=
ng
> > > > behavior isn't actually required by the /security goals/ of this, I
> > > > figured I'd just drop that. And maybe we can all revisit it togethe=
r
> > > > sometime down the line. But for now I'm hoping for something a litt=
le
> > > > easier to swallow.
> > >
> > > In that case, since we need to be able to populate this memory to mak=
e
> > > forward progress, would it make sense to remove the parts of the patc=
h
> > > that treat the allocation as if it was allowed to silently fail (the
> > > "__GFP_NOWARN | __GFP_NORETRY" and the "ret &=3D ~VM_FAULT_OOM")? I
> > > think that would also simplify this a bit by making this type of
> > > memory a little less special.
> >
> > The whole point, though, is that it needs to not fail or warn. It's
> > memory that can be dropped/zeroed at any moment, and the code is
> > deliberately robust to that.
>
> Sure - but does it have to be more robust than accessing a newly
> allocated piece of memory [which hasn't been populated with anonymous
> pages yet] or bringing a swapped-out page back from swap?
>
> I'm not an expert on OOM handling, but my understanding is that the
> kernel tries _really_ hard to avoid failing low-order GFP_KERNEL
> allocations, with the help of the OOM killer. My understanding is that
> those allocations basically can't fail with a NULL return unless the
> process has already been killed or it is in a memcg_kmem cgroup that
> contains only processes that have been marked as exempt from OOM
> killing. (Or if you're using error injection to explicitly tell the
> kernel to fail the allocation.)
> My understanding is that normal outcomes of an out-of-memory situation
> are things like the OOM killer killing processes (including
> potentially the calling one) to free up memory, or the OOM killer
> panic()ing the whole system as a last resort; but getting a NULL
> return from page_alloc(GFP_KERNEL) without getting killed is not one
> of those outcomes.

Or, from a different angle: You're trying to allocate memory, and you
can't make forward progress until that memory has been allocated
(unless the process is killed). That's what GFP_KERNEL is for. Stuff
like "__GFP_NOWARN | __GFP_NORETRY" is for when you have a backup plan
that lets you make progress (perhaps in a slightly less efficient way,
or by dropping some incoming data, or something like that), and it
hints to the page allocator that it doesn't have to try hard to
reclaim memory if it can't find free memory quickly.
