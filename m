Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B437B26B2C7
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116973; cv=none; b=sEsbq0Kd8Iq7uY/+rKwf4O71R3uUvCpL8AzujuiEoJCWriNUROpK8XsmrL2lLPxczXUBOFYKEGhag+Y0GepxDPsaobfDnm5Eg70PDMSk/N5acp0So9n4ddBS6Dvd6zIjzOmM/81WW7HlXrE48lZCYUSduEsifbmSdx75lWRExJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116973; c=relaxed/simple;
	bh=adZcLq55jVTFstm2wiUyPAojCL69dADb1wgZoxsdoWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BYnfQVRx497exeGEjhT+z6GXO3Xyfzq62DJGlTVYhiv0fAHek62JDlnW51nW9WyaDUr1PntM/2lb5Y/+yznzZVVWNQHcifAZ27EpnwCh8dy6Ze1OIAxNEq6mENZvvITcPjvsOqkzwSzTcqOBJu80RYgrOiX9kio6q/b/dSsT2uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TTnomF7V; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TTnomF7V"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2264c9d0295so193185ad.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 05:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744116971; x=1744721771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RG/xhtnV6ZnPncZ3zkgyPrvXLOKL/ebp3OOD18MDPvE=;
        b=TTnomF7V6XCmhSD4dCbZuu1uA4MnJHrKsEGrRRQIggkPDvxjVtlY+cs4ySRLph7YFa
         IrXmUmcX5+Ri5Np9QTA4fAljOi2jXeq0nq6kH6fC0tvzJ2anlBcfA0o1h+nJd10B9M9J
         J2AG0VXmOH9DTvHzlIm9UisEScOAQ1M+/fE9uAg8tsZtF4jBKoSlYIcQF1Gfvs3SIE2y
         n2WdPYFUE9pbaxEgBduJZM1wOMTx4K5i08dDiBf4yNKwDpD21lObuP2pNv63tea6hec/
         aGQHukpffwU2snp5WaRrf5mPjbEXVvFOb73lzFw3B48+jvPmlh4F7yO2IXrgubm3n0qD
         qUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744116971; x=1744721771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RG/xhtnV6ZnPncZ3zkgyPrvXLOKL/ebp3OOD18MDPvE=;
        b=ndEBYuZNMIt0Va3NSGbq5uH4kDLQ3M3VKtWfCy4qhnZbLY0SyA98AlsR2mORfuv7Cb
         s27o8TNTScRF+S6YXqkUefiewtlYF4NGN+A6RysrfZlcczqqWOVlNTv9yZu+cofhz4Kx
         cDLPy+vZ+mfdDvuXysuGbxIyqECNOhj8audzkx3V2k1Bxw4QHCkK9i2jAoNo1ZNjZHvf
         5DvxV7FtWj9Qo7LTPtOtoV7Oh/Q2IJLDkWnVejiizEsvNSrHpAxsuRBmIKO/rZJoJdyT
         64oLNQOu5bO4VaXrEOBMT/L7mYPMTRZZBaTPj+2iTDQh19b59Bw+RQLL3XhoCoNspRJB
         gxeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJaqeHuIySfnU0yuWuay4cyw4EbKKwrWBPO2VP5MJu509koV1T0Eg+zW+OefhcZggKO/FhsCiz@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6aVZpMBMAGHhKYo0tcawiZe2EbkaS4gpfsWqA95rMwnvLKPDO
	41xOZVHm1BTYVSs2P0+Wm97fUseMIVAKrcrxVlYdMs2JWAKCp2S8SjiXkiCI4xzskJ0THWZhGmb
	VNCASwidVugbQg92gDK2AgnV4Noej2C+5/fiX
X-Gm-Gg: ASbGncuGwUZy3LL/MtuIFihkggmbrMFnkG4vAYCmZv9h9YRZvqfDyETYISShSfRDqjk
	S/9y2A1XJVwa4dZtx558D56dv8DI+/gfE6GYjfaQUMOG5+155keZCj3AfG7AOkNJSsLQY8AkXnV
	DhuzMIvfxWYAIrEb/+z2adWt8wc3EN9QyG4VKlJGGV/Rj1YsB7qnncD2AVXALpPXb5KDSSuA==
X-Google-Smtp-Source: AGHT+IFyamF8RcqpJvT2dSEWif+d5rOCh4OSVEjZqb+pQd2Q0cuRNjgqKpf6zhLQZxEF5YWTjhukqOAdH4NUN/9xXZw=
X-Received: by 2002:a17:902:ce01:b0:21f:3f5c:d24c with SMTP id
 d9443c01a7336-22ab6e6223emr2928445ad.0.1744116970209; Tue, 08 Apr 2025
 05:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104851.256868745@linuxfoundation.org> <20250408104902.301772019@linuxfoundation.org>
In-Reply-To: <20250408104902.301772019@linuxfoundation.org>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 8 Apr 2025 05:55:57 -0700
X-Gm-Features: ATxdqUFOuhmpGo_chEBVF0UBujpRLi9z7SKanq8MnuNt1HRJ4w5pBBd_ytweB1Q
Message-ID: <CAGtprH_Sm7ycECq_p+Qz3tMK0y10qenJ=DFiw-kKNn3d9YwPaQ@mail.gmail.com>
Subject: Re: [PATCH 6.13 444/499] x86/tdx: Fix arch_safe_halt() execution for
 TDX VMs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	Ryan Afranji <afranji@google.com>, Andy Lutomirski <luto@kernel.org>, Brian Gerst <brgerst@gmail.com>, 
	Juergen Gross <jgross@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 5:29=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.13-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Vishal Annapurve <vannapurve@google.com>
>
> commit 9f98a4f4e7216dbe366010b4cdcab6b220f229c4 upstream.
>
> Direct HLT instruction execution causes #VEs for TDX VMs which is routed
> to hypervisor via TDCALL. If HLT is executed in STI-shadow, resulting #VE
> handler will enable interrupts before TDCALL is routed to hypervisor
> leading to missed wakeup events, as current TDX spec doesn't expose
> interruptibility state information to allow #VE handler to selectively
> enable interrupts.
>
> Commit bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
> prevented the idle routines from executing HLT instruction in STI-shadow.
> But it missed the paravirt routine which can be reached via this path
> as an example:
>
>         kvm_wait()       =3D>
>         safe_halt()      =3D>
>         raw_safe_halt()  =3D>
>         arch_safe_halt() =3D>
>         irq.safe_halt()  =3D>
>         pv_native_safe_halt()
>
> To reliably handle arch_safe_halt() for TDX VMs, introduce explicit
> dependency on CONFIG_PARAVIRT and override paravirt halt()/safe_halt()
> routines with TDX-safe versions that execute direct TDCALL and needed
> interrupt flag updates. Executing direct TDCALL brings in additional
> benefit of avoiding HLT related #VEs altogether.
>
> As tested by Ryan Afranji:
>
>   "Tested with the specjbb2015 benchmark. It has heavy lock contention wh=
ich leads
>    to many halt calls. TDX VMs suffered a poor score before this patchset=
.
>
>    Verified the major performance improvement with this patchset applied.=
"
>
> Fixes: bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Tested-by: Ryan Afranji <afranji@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20250228014416.3925664-3-vannapurve@googl=
e.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/Kconfig           |    1 +
>  arch/x86/coco/tdx/tdx.c    |   26 +++++++++++++++++++++++++-
>  arch/x86/include/asm/tdx.h |    4 ++--
>  arch/x86/kernel/process.c  |    2 +-
>  4 files changed, 29 insertions(+), 4 deletions(-)
>

Hi Greg,

This patch depends on commit 22cc5ca5de52 ("x86/paravirt: Move halt
paravirt calls under CONFIG_PARAVIRT"). I will respond to the other
thread with a patch for commit 22cc5ca5de52 after resolving conflicts.

Regards,
Vishal
