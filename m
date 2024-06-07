Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718D195808
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773198; cv=none; b=PXopLu2gD1h2J3ZQO5ot9AtbQENcqcMP55XBVDKTwjvUO9XcCRPQ7S/fi0wDMNYDjGkqoOBZCY1LZFxy8MaCHS6NSUX9GGAdX4ElTnuu7xRYpv88cvpA45fb5Brc5rj+KgKle82g73zMJkJeF8CnEzm4ymqQrAljCZBpVJag8ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773198; c=relaxed/simple;
	bh=7n0apmTpqZ+tog798fnZb4ZTZm7Gl3vutnIWL1LYnuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJ2d/9jMT8DbQD0drAOBMOQKa96ry7japQmSU+cLBwReEaEoW1uuwJZFKzx0pqnjFEJf7dLiMWOWasRenkGI6I4uVr4yYalv0T/VJySey5NGDAJE39kd0aIkZ8ozvEVmxVdGDrdF+arXes8GcRooTESyGQW67Ptwg6h7U7IJUoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P7bSSSxU; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P7bSSSxU"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5750a8737e5so18230a12.0
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717773195; x=1718377995; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F9DLoOIliT2vV+jCDlYYVBA1v56GjGd/sBFCy6REvhs=;
        b=P7bSSSxUwv4K0xyuIjki0R3OYxzHlWe6FawyLyRb+42yDChA3P23aS2zq1oV5sbWO6
         mHQdejVPuptLyDxB8VY8EoedQLptoOnX50Rd0FSzRwWCblN/yZU1hsGPvwPBstz9uM3y
         4+toZhcnZARlA0+78pitiM1iCp0MQjlboBzzgNuJFbvr7PWZ2NmWNi7dYesr6gIo4ME7
         EhZj0CyE3RIQdAH7nkCEXvKwJDUihGMfUicwpBnD70huBnewlSmyv/5cP2HGw119zo+t
         sp2i/1jo+VaDWIK6A9O6jJ4UplWjqef3k3T3w4YwyHDpf69K33CbfVQUzuIywflMvl9M
         zMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717773195; x=1718377995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F9DLoOIliT2vV+jCDlYYVBA1v56GjGd/sBFCy6REvhs=;
        b=PjRktvazQWf6zQMDv8+6fKo7IykCnqtZu7U24gtJSQas2OZXcblEkF6uU4QXJBXB6h
         m6YI6ERHF3zjmfXGDeieiIAzzLANuvUnmv4qMMcEAcPkVHGbmTTLSUETLsN5UG9swX68
         PFHybK3Vhw6XhfTKjpDfSPbPhhRK6vSvF7lg+3NVItaKoMF++l544GA6JLeo5pRvEn+e
         xa79uJ830agxiuV/LJcbzuWptyqfWDp0zUDtjEpY7mx4wh+M7+HLuM2oCHc7qb1TVWNO
         6q4vZil/4Hm9mNcBtmRM6Jnr7RFpzxvLrNqkFZ6yvBvQsh02xE66GC4SwzSg5zejPlPX
         kKZg==
X-Forwarded-Encrypted: i=1; AJvYcCUgQ0gpb9Ca3FBXLUEzEtkJLOOiFpJpbO/LzDmlR2Wn+uCK/de0/HUJArLDv8wfHDVvmBQOEnSNplVRM86NY29+dcpai3L3cQ==
X-Gm-Message-State: AOJu0YxnZENvwf3d0tbfmW9N7esxPUMvi3DDzTplucL+/SbJ28ynnl93
	PfNp3nlay2ryf9BDbWD0LT6A40cG5EfwtJ/1qxfsLfZ0LXSqtYWgm0OG8UBwI04WXjRGOu0vPrI
	Do9Tq0KgzZP7h8COZc94XXhfrSZZ3sMyCIWoY
X-Google-Smtp-Source: AGHT+IGgwajHKpYdDWMQLIOmMJsfkmT9wQMD93gE5Vvy1QzU36KDO2gHuZ/Tqx8lOxhLvhtrGDMlAetFVDjv7C4htvM=
X-Received: by 2002:a50:fb96:0:b0:572:988f:2f38 with SMTP id
 4fb4d7f45d1cf-57aa6e8e2e9mr588051a12.6.1717773194672; Fri, 07 Jun 2024
 08:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
 <CAG48ez0P3EDXC0uLLPjSjx3i6qB3fcdZbL2kYyuK6fZ_nJeN5w@mail.gmail.com>
 <Zlm-26QuqOSpXQg7@zx2c4.com> <CAG48ez3VhWpJnzHHn4NAJdrsd1Ts9hs0zvHa6Pqwatu4wV63Kw@mail.gmail.com>
 <ZmMamtll1Yq1yfxc@zx2c4.com>
In-Reply-To: <ZmMamtll1Yq1yfxc@zx2c4.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 7 Jun 2024 17:12:38 +0200
Message-ID: <CAG48ez0pan8aLGjHtoDdrpiP+e5YrGeuD_RzDXgzUwkUvWYLjA@mail.gmail.com>
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

On Fri, Jun 7, 2024 at 4:35=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com>=
 wrote:
> On Fri, May 31, 2024 at 03:00:26PM +0200, Jann Horn wrote:
> > On Fri, May 31, 2024 at 2:13=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4=
.com> wrote:
> > > On Fri, May 31, 2024 at 12:48:58PM +0200, Jann Horn wrote:
> > > > On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason@z=
x2c4.com> wrote:
> > > > > c) If there's not enough memory to service a page fault, it's not=
 fatal.
> > > > [...]
> > > > > @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_=
struct *vma, unsigned long address,
> > > > >
> > > > >         lru_gen_exit_fault();
> > > > >
> > > > > +       /* If the mapping is droppable, then errors due to OOM ar=
en't fatal. */
> > > > > +       if (vma->vm_flags & VM_DROPPABLE)
> > > > > +               ret &=3D ~VM_FAULT_OOM;
> > > >
> > > > Can you remind me how this is supposed to work? If we get an OOM
> > > > error, and the error is not fatal, does that mean we'll just keep
> > > > hitting the same fault handler over and over again (until we happen=
 to
> > > > have memory available again I guess)?
> > >
> > > Right, it'll just keep retrying. I agree this isn't great, which is w=
hy
> > > in the 2023 patchset, I had additional code to simply skip the faulti=
ng
> > > instruction, and then the userspace code would notice the inconsisten=
cy
> > > and fallback to the syscall. This worked pretty well. But it meant
> > > decoding the instruction and in general skipping instructions is weir=
d,
> > > and that made this patchset very very contentious. Since the skipping
> > > behavior isn't actually required by the /security goals/ of this, I
> > > figured I'd just drop that. And maybe we can all revisit it together
> > > sometime down the line. But for now I'm hoping for something a little
> > > easier to swallow.
> >
> > In that case, since we need to be able to populate this memory to make
> > forward progress, would it make sense to remove the parts of the patch
> > that treat the allocation as if it was allowed to silently fail (the
> > "__GFP_NOWARN | __GFP_NORETRY" and the "ret &=3D ~VM_FAULT_OOM")? I
> > think that would also simplify this a bit by making this type of
> > memory a little less special.
>
> The whole point, though, is that it needs to not fail or warn. It's
> memory that can be dropped/zeroed at any moment, and the code is
> deliberately robust to that.

Sure - but does it have to be more robust than accessing a newly
allocated piece of memory [which hasn't been populated with anonymous
pages yet] or bringing a swapped-out page back from swap?

I'm not an expert on OOM handling, but my understanding is that the
kernel tries _really_ hard to avoid failing low-order GFP_KERNEL
allocations, with the help of the OOM killer. My understanding is that
those allocations basically can't fail with a NULL return unless the
process has already been killed or it is in a memcg_kmem cgroup that
contains only processes that have been marked as exempt from OOM
killing. (Or if you're using error injection to explicitly tell the
kernel to fail the allocation.)
My understanding is that normal outcomes of an out-of-memory situation
are things like the OOM killer killing processes (including
potentially the calling one) to free up memory, or the OOM killer
panic()ing the whole system as a last resort; but getting a NULL
return from page_alloc(GFP_KERNEL) without getting killed is not one
of those outcomes.
