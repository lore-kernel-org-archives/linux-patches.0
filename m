Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706FE3911CD
	for <patches@lists.linux.dev>; Wed, 13 May 2026 03:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778641594; cv=none; b=TtqWgfbgRslpxbcpIOjPwZkcikEiQbpEOawqDyZzGSzPUZsqHKJBPTEGQAgwshfGhzqUtaLfq2ZsVDay+ivqZg1O2pr7YEQPp9x4jhX+GKpwTdNYBDphu/3YVJYuQk4I+CX9/KJvWJBBnWq92jfqjXjLeGlc4ycaezimlVmrN14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778641594; c=relaxed/simple;
	bh=2FYu66EO6vVTIr4kxrE0IOHu6oZkI5WGpQMrpxngQ/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPFiZ7KADr6oEJ0JGV4OwOZIEshVC4IRyu0kDXP8W9JxsVK8YYqm7GvdjmGhdE73eAvvrly5a06CmrEonO3RlALc8F0ezEsUMj806cC4va5ZVkznZYa87grN/fTA37MmVqnReFB5JqzVaSL9uRQtAOhUv+rcUpfZOS4L5zefjsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKH/ADQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKH/ADQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD3C2BCFC
	for <patches@lists.linux.dev>; Wed, 13 May 2026 03:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778641594;
	bh=2FYu66EO6vVTIr4kxrE0IOHu6oZkI5WGpQMrpxngQ/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qKH/ADQUWT4OpC0s44qwsKkp9Q+rL4BS1brg1sSt0mC27D+9BKV/hR+ZcfJM2Z4YX
	 60zE9GbP5P1IO9oo08IOYFnkpmiKapp1ifo1eqQkawI/14P2ty80e1d3YeP37bBGE/
	 MDiLeGW1/mElUaB7VOxBb704iMEpkJ/pBIqL/sTLQaab//0HnpQ8OIwSoTmBx/sJ1i
	 YHtev/4v2a8YaQ606ePAdfGek3Fny4WQBttb1rjAYUVibM8KpA1Cdmw3ts4vnxEaIE
	 b7lLmBJJmJmnIMaBY7+voM6DjD4+EkXFBajFPJCwxteWdVrRLCH41Xa3cYW5ozlxuV
	 tmegyxYbj8XJA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso9617989a12.1
        for <patches@lists.linux.dev>; Tue, 12 May 2026 20:06:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/JNwKZcG9EOlSVae1ArWkT/hNnDa3R4o7kKYnx9QYrOxsQf2TCVMem/xc3TMh3kp1RlM2xEpPe@lists.linux.dev
X-Gm-Message-State: AOJu0YyfUxsJIlPj/ObOnyqRGcZi9xrJTGdvI44Xo8ICVRPIH5IrXo4B
	/UZwa47o4CTpRNTtBbbEMdMOZh4qNi/+VyRkTkuE/XJtP5bF2ENehqfeGcDxHWYL35H3tB1gUFc
	2ea5wdD4Rhuy/9SR9M14kGJodrHrWzw0=
X-Received: by 2002:a17:906:4786:b0:bd3:2b8a:2164 with SMTP id
 a640c23a62f3a-bd3bfb9f635mr84611266b.16.1778641592860; Tue, 12 May 2026
 20:06:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260512173940.376401154@linuxfoundation.org> <20260512205250.313933-1-ojeda@kernel.org>
 <agOhSMXZGSv0bPhX@google.com>
In-Reply-To: <agOhSMXZGSv0bPhX@google.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 13 May 2026 11:06:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6GFmKrJpVgaShCzUigZByvQkXQy_2qGcyaJ089Q6chWg@mail.gmail.com>
X-Gm-Features: AVHnY4JhLdvfmwJivpMfBvuNwmW2QV0KoWSoIRaMnLuYY6_EF5PB2geRX9XhU-I
Message-ID: <CAAhV-H6GFmKrJpVgaShCzUigZByvQkXQy_2qGcyaJ089Q6chWg@mail.gmail.com>
Subject: Re: [PATCH 6.18 091/270] LoongArch: KVM: Compile switch.S directly
 into the kernel
To: Sean Christopherson <seanjc@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Dave Hansen <dave.hansen@linux.intel.com>, 
	chenhuacai@loongson.cn, lixianglai@loongson.cn, patches@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 5:53=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, May 12, 2026, Miguel Ojeda wrote:
> > On Tue, 12 May 2026 19:38:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoun=
dation.org> wrote:
> > >
> > > 6.18-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Xianglai Li <lixianglai@loongson.cn>
> > >
> > > commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.
> > >
> > > If we directly compile the switch.S file into the kernel, the address=
 of
> > > the kvm_exc_entry function will definitely be within the DMW memory a=
rea.
> > > Therefore, we will no longer need to perform a copy relocation of the
> > > kvm_exc_entry.
> > >
> > > So this patch compiles switch.S directly into the kernel, and then re=
move
> > > the copy relocation execution logic for the kvm_exc_entry function.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > For loongarch64, I am seeing a bunch of errors like:
> >
> >     arch/loongarch/kvm/switch.S:201:1: error: unrecognized instruction =
mnemonic
> >     EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
> >     ^
> >
> > `EXPORT_SYMBOL_FOR_KVM` does not exist in 6.18. Does this need a subset
> > of commit 6276c67f2bc4 ("x86: Restrict KVM-induced symbol exports to KV=
M
> > modules where obvious/possible")?
>
> Either that or just convert EXPORT_SYMBOL_FOR_KVM() =3D> EXPORT_SYMBOL_GP=
L().  If
> that's somewhat scriptable for ongoing LTS backports, that's probably the=
 best
> option.  EXPORT_SYMBOL_FOR_KVM() will only work for 6.18, and the list of=
 backports
> needed to get EXPORT_SYMBOL_FOR_MODULES() working on older LTS kernels lo=
oks to
> be non-trivial
>
> If we do end up backporting EXPORT_SYMBOL_FOR_KVM() and others, we might =
as well
> also grab a subset of 01122b89361e ("perf: Use EXPORT_SYMBOL_FOR_KVM() fo=
r the
> mediated APIs") to ensure a kvm_types.h stub is present on all archs.  Th=
at way
> EXPORT_SYMBOL_FOR_KVM() usage in arch-neutral code will also work.
I have already noticed Greg about this before.

And I think the best solution is to use EXPORT_SYMBOL_GPL().

If Greg doesn't want to adjust manually, please drop this patch and I
will send one.



Huacai

>
> diff --git include/asm-generic/Kbuild include/asm-generic/Kbuild
> index 295c94a3ccc1..9aff61e7b8f2 100644
> --- include/asm-generic/Kbuild
> +++ include/asm-generic/Kbuild
> @@ -32,6 +32,7 @@ mandatory-y +=3D irq_work.h
>  mandatory-y +=3D kdebug.h
>  mandatory-y +=3D kmap_size.h
>  mandatory-y +=3D kprobes.h
> +mandatory-y +=3D kvm_types.h
>  mandatory-y +=3D linkage.h
>  mandatory-y +=3D local.h
>  mandatory-y +=3D local64.h
>
>
