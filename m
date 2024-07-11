Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37FF156237
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720660; cv=none; b=oz1OmPHs9LSmk1LdPqN3+swwFx2IQBeiheR3Kpvx+MdpiQvhziOeQTa+xlW8JxvyOSzpb4r8lfk1RSe7StwkCza/65Vi0WH3tzcq6nvq5u9u6YN3yzNA13RnUyNoYbi35GCQger3fl7CLsqripHBKxQ2s70dwiX2PMsZ2E5nfyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720660; c=relaxed/simple;
	bh=vvosbZQCROt/9gCUMQ9029yo2M/stCbxLACDG7WVvAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dw4L7XqsN15FPIB0sc7HH+8FLRT6z/mG34HwisYyhNp+tnkOiboJ7IQFwpVPUaJnO6PNhF5Mokc7bKOf1mW8D0XC+n6t+dYQFEC3e507uNgnPv3Iv/3IkBS9VWcZumZsn85PYxBL2ghQmU8K3XY1q4IUQlrtIW0I1Z3nI0SfLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JCl7MUDw; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JCl7MUDw"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111b0so874317a12.3
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 10:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720720657; x=1721325457; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hd/aM4WVpnq9dMpWhQNC6P88qoE7zzksarngsyWfv5Y=;
        b=JCl7MUDweScTjCiSzjto7FuuBuTd/r3oTm5S0M1q76kPU/N7MIZL7VqQRwl3FlGHca
         IXeYyLKmSYGdBApor8kopoeUbmNdCDkfO4fBD/0MlLgZRtDNMV78C/okoZXEhxSXO7Uk
         J4m0Hvkyv/RuauZRNt0PMAMJLKOwzlkH39zhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720720657; x=1721325457;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hd/aM4WVpnq9dMpWhQNC6P88qoE7zzksarngsyWfv5Y=;
        b=fQD+XU1qUUtXhtySrUAe0FSrEjgyUcnJZbDfFjNJeokHucxFOJBhY2kX0m9mbmyW3p
         zIk2RI2ErhdUkuFJM/CPpyb+WXK/SvHvI1KslVJBlb1cg/cTJ2pJEyJnBIXIfRPJYMDz
         WcN6gu1OQDrXWkDGxY1jkUZPUSaWFWk4ePdkqAdhzt3GKLLFLKi1pXKDAt+PJl/gjPDb
         JQ+waiWgiloi8fdzEVxES9DMcCbt2ah9XU+GdEJcB/fGc3IFmBHO428im/VLwBCtWWi1
         xdmrUG7Gzuom01MOdrfUP+1mustm661dqSJ5EHwy/BmwJgWkmEDc3Cb6RjWSHsyLEw2d
         ilXA==
X-Forwarded-Encrypted: i=1; AJvYcCWavpZ8HFAr0XDmvpkPU24Pkupt3zVEjA1mnqxSMGfgXhVLRG4RmXGQ5dgcBzdZOYIxa5tfCyMUAXmyVYigfWg48T1a3/ygcw==
X-Gm-Message-State: AOJu0Yw8CjqucM3IqEstoKT0KqmgeVnrysMyQixe9DcbWqcbfogaLM5M
	TFdjICdZOGXrWYUeGmvHXo6XZmSrVXt8/GijPSw+d3pnRp5925sS7g+PLPh+0xOQeHNeNx44a0D
	Jc2AMLA==
X-Google-Smtp-Source: AGHT+IG3BPMuyCNjP04wtvQFtyhQTKd1TVMbK2dyxWSh0LOluMSF2a02gWr/kqKgo5kUT57TghSmCQ==
X-Received: by 2002:aa7:c495:0:b0:57d:669:caf2 with SMTP id 4fb4d7f45d1cf-594bbb4b2d5mr7334749a12.25.1720720656806;
        Thu, 11 Jul 2024 10:57:36 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bda3089dsm3671924a12.94.2024.07.11.10.57.35
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 10:57:36 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77d876273dso93296366b.0
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 10:57:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV0FHPPijlGe8b0xII6qR54DX9+KcbCN4cZz05MUjdI4OwAvhro+Ms1OAlfMxcdmD822RL7JfBvyQEJ618GwKxWNItWw2UEPw==
X-Received: by 2002:a05:6402:50c7:b0:578:638e:3683 with SMTP id
 4fb4d7f45d1cf-594bab80624mr9962641a12.5.1720720655663; Thu, 11 Jul 2024
 10:57:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709130513.98102-1-Jason@zx2c4.com> <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com> <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com> <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
 <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com> <ZpAR0CgLc28gEkV3@zx2c4.com>
In-Reply-To: <ZpAR0CgLc28gEkV3@zx2c4.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jul 2024 10:57:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=whGE_w46zVk=7S0zOcWv4Dp3EYtuJtzU92ab3pSnnmpHw@mail.gmail.com>
Message-ID: <CAHk-=whGE_w46zVk=7S0zOcWv4Dp3EYtuJtzU92ab3pSnnmpHw@mail.gmail.com>
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jul 2024 at 10:09, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> When I was working on this patchset this year with the syscall, this is
> similar somewhat to the initial approach I was taking with setting up a
> special mapping. It turned into kind of a mess and I couldn't get it
> working. There's a lot of functionality built around anonymous pages
> that would need to be duplicated (I think?).

Yeah, I was kind of assuming that. You'd need to handle VM_DROPPABLE
in the fault path specially, the way we currently split up based on
vma_is_anonymous(), eg

        if (vma_is_anonymous(vmf->vma))
                return do_anonymous_page(vmf);
        else
                return do_fault(vmf);

in do_pte_missing() etc.

I don't actually think it would be too hard, but it's a more
"conceptual" change, and it's probably not worth it.

> Alright, an hour later of fiddling, and it doesn't actually work (yet?)
> -- the selftest fails. A diff follows below.

May I suggest a slightly different approach: do what we did for "pte_mkwrite()".

It needed the vma too, for not too dissimilar reasons: special dirty
bit handling for the shadow stack. See

  bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
  b497e52ddb2a ("x86/mm: Teach pte_mkwrite() about stack memory")

and now we have "pte_mkwrite_novma()" with the old semantics for the
legacy cases that didn't get converted - whether it's because the
architecture doesn't have the issue, or because it's a kernel pte.

And the conversion was actually quite pain-free, because we have

  #ifndef pte_mkwrite
  static inline pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
  {
        return pte_mkwrite_novma(pte);
  }
  #endif

so all any architecture that didn't want this needed to do was to
rename their pte_mkwrite() to pte_mkwrite_novma() and they were done.
In fact, that was done first as basically semantically no-op patches:

   2f0584f3f4bd ("mm: Rename arch pte_mkwrite()'s to pte_mkwrite_novma()")
   6ecc21bb432d ("mm: Move pte/pmd_mkwrite() callers with no VMA to _novma()")
   161e393c0f63 ("mm: Make pte_mkwrite() take a VMA")

which made this all very pain-free (and was largely a sed script, I think).

> -                   !pte_dirty(pte) && !PageDirty(page))
> +                   !pte_dirty(pte) && !PageDirty(page) &&
> +                   !(vma->vm_flags & VM_DROPPABLE))

So instead of this kind of thing, we'd have

> -                   !pte_dirty(pte) && !PageDirty(page))
> +                   !pte_dirty(pte, vma) && !PageDirty(page) &&

and the advantage here is that you can't miss anybody by mistake. The
compiler will be very unhappy if you don't pass in the vma, and then
any places that would be converted to "pte_dirty_novma()"

We don't actually have all that many users of pte_dirty(), so it
doesn't look too nasty. And if we make the pte_dirty() semantics
depend on the vma, I really think we should do it the same way we did
pte_mkwrite().

Long-term, maybe we should just aim to always pass in the vma to the
pte_xyz() functions, but...

          Linus
