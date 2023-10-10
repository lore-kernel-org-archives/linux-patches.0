Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249356126
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J61vikCh"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3214cdb4b27so5625090f8f.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 10:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696957410; x=1697562210; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFoVNhEfSzp1dSw6NNvj7gLh7P8v4ACYe4VP+0F2LtQ=;
        b=J61vikChnkymvqxw3dYeq3K2OyPRiJTQKM4I56v2qD9JeMLOcozj3OUugktqy0mEZX
         64ua8/4AShp8EkcNGv0JS2R9Q9deImE4fCuQDK0MFwDSMnuxmcN7RVCj6YrsIyFYeIY5
         I0/nht6+S3mNYUhQfXBDRWxM1+cIcOO0uAlGL1e8n2XDX7ub0cJtAQ1otUsR/kL493Ap
         9W4l8kkJIgoa0nzmhAjuji9joiZhtpKKbArKhlPwxbpf4sPuSIKkZC/HXxoaspz+C+3c
         5tn25Fd4PIMgDL29LGU9duBpZ5Dt3M/DFLJKN28dAhOWA2FXwSKo/gofJG/vR9IsTWO7
         m76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957410; x=1697562210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XFoVNhEfSzp1dSw6NNvj7gLh7P8v4ACYe4VP+0F2LtQ=;
        b=IUl805EzYJnyP+0egsI+FyW/BuaMI679dbadqXWvZWLiZGSFUoL6/fUWY1pxp5+xNd
         /K88Sztl1Pr393QvNF7fUf4rGIRaGJ2Oqp76rPflbBLxnJJqi9O3KVqaPjDqBwpQSBcF
         RBrUjplyDY9cx6NGOPoXSI2idTPVzjAIp8u4JgZE3Vt/gO/Ig+XGQH86Zzg3CoTnQGKS
         l51lNS1zWPaLpek4RE6E3W4Au+JJlfJrTVG8PlHrEZ34CWrvlkvv4tLnOkqxtNjrlQMJ
         KkePFUYmaKalZuoPJFj71M+KLdSm/vVB7YHr1AcESpivalBD0GTIpngJdiAJCALc4iq2
         9HOQ==
X-Gm-Message-State: AOJu0YxICgKztbajq3CjdQ82IxCio/LNybi5mTmbQA1ifr1UeAxAAvU6
	zy47iWyE4I69AXQ4WRfiO7e46KENA0y9mkAthwIYCA==
X-Google-Smtp-Source: AGHT+IFvbHj9Ji4Gx2B+d7UqMkOjFTULnHJKFnwQml1FPaJtrvtIokyrSZyrZGy3HfybqA0GtEnC+FoTEPkMROGBCyo=
X-Received: by 2002:a5d:4b11:0:b0:31a:e772:ddf6 with SMTP id
 v17-20020a5d4b11000000b0031ae772ddf6mr17138614wrq.39.1696957410061; Tue, 10
 Oct 2023 10:03:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
In-Reply-To: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 10 Oct 2023 10:03:15 -0700
Message-ID: <CAKwvOdnMeM4YArw=hyVkev11cLfks5gaXWXNK+Wo0bcbeuMZHg@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: build: Allow LTO to be selected
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, trix@redhat.com, samitolvanen@google.com, twd2.me@gmail.com, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 3, 2023 at 12:17=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> From: Wende Tan <twd2.me@gmail.com>
>
> Allow LTO to be selected for RISC-V, only when LLD >=3D 14, since there i=
s an
> issue [1] in prior LLD versions that prevents LLD to generate proper
> machine code for RISC-V when writing `nop`s.
>
> I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
> on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
> can boot to shell using an archriscv rootfs on QEMU.
>
> I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
> image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
> `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
> separate patch further.
>
> Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> object file when manipulating the files in that subfolder, rather than
> LLVM bitcode.
>
> [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
>     commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
>
> Tested-by: Wende Tan <twd2.me@gmail.com>
> Signed-off-by: Wende Tan <twd2.me@gmail.com>
> Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Perhaps worth a v4 due to linker relaxation resulting in boot failures
you observed:
https://github.com/ClangBuiltLinux/linux/issues/1942 ?

--=20
Thanks,
~Nick Desaulniers
