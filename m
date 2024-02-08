Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4534F5E9
	for <patches@lists.linux.dev>; Thu,  8 Feb 2024 21:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707429046; cv=none; b=KeSXG3GLNisT0PAURI4pKaCOoVxO1fLRwECBlm+G6tutGC+P0rbMxzLnmULn32UFFpgz/MeHWsu75thxs+9LMqbE+u6KmfDCrAI0jaxSxqkkfkpeMmuBiU7PVZv+2CW3TGgyyifbxm8N8MomNnyzhihF7+f3d7Uu20kziaZ2n3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707429046; c=relaxed/simple;
	bh=kUygteJBS6KCH//gRa+4ItB8/T9NYxGBC59L0JWpVSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DQwKI6g5BnyjUpajrd/8u4LB4irc3dxwj2apeqH2jH++nDe0th828qidfGZfqePecZ1qnawMQzxEE3A9FOJWVA/wVApm2MpWi/NpfMZ8vOJznu3QKmDryU6gthWKpDPnuTgo4yN7VS6LUnMOU3ZQysfuhVGUOfqA0bnZc1kaELc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uv/xTUUR; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uv/xTUUR"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a3122b70439so33032766b.3
        for <patches@lists.linux.dev>; Thu, 08 Feb 2024 13:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707429042; x=1708033842; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rk2Mf+CYgNj0rrQ4AtP2FsCs3Z7W5vLJ8AK+GUlsuys=;
        b=Uv/xTUURJb+jOen5WVSclkrgY1QS3WUMtk74rLW7l7yg57swrpGJFzxBuQ6ydyQWr7
         03SWEQOWAJfh+jd9RJT2MAOcfWSECWQQROhevsEdREW+j8rGXUsk2AGcmgqTjYqXzFhv
         ADyDrYSV3Ka8wtiXRxVXKm6eS9giIffth4p2jDckXTLRbiG12ZWFW3pyAx8sOHufQlBM
         IsjXNcrpc8T9kPgOBL7giBAUFmvURy0KP7W/6SvUzgP4/uKwj0+/TLmJiNQLC5FzMyXF
         WjcRhMlXXMND3ro1J0Msa6aD+Xztihat6h+9dhjUGJOPJgJtb7Z3Tz+jPRNtcNuMJABa
         WKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707429042; x=1708033842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rk2Mf+CYgNj0rrQ4AtP2FsCs3Z7W5vLJ8AK+GUlsuys=;
        b=ZR3KFbwVZJKJb/b/61WKPVpL30xa1WJy3+KRf8/wIaUzFP/itEbNKQqpBe9pG2KXGD
         uwqKCJ69vBCJsp0pXxwgoqjRgJeRw0iTUTnH/dOrKTxMsdFHw64l02a34Y7Y4U0/XRu/
         POr0A75z437aT5EUXZnSeFjzyzYGOkZma+gZdFvn9koTTjlWxLNRgcrYWyV54Y/GHVFV
         YjuMRcplmSrA/Meq4mZIbEe5bOlMnJVEzLDcZTrGtoNLYv+cKPQ36jFMb82iXBoXZR/Q
         CkdyPplJejQRLGG9v/teXEw8ekXvOZfnbWy7IGJ+Kn8F2cPcvxQk0BYuEMEpoMVLAIRL
         OoRg==
X-Gm-Message-State: AOJu0Yyhlhx1mf/ef2+x9hRcFtti7QqCyg2WqYDxITDlAMzqGS2HFKcW
	KBekXfxTAz2gEJ327t+F5gds41dolHsFA2htygvFYSrOcjsCSqFCWH3nD99sdXGB1irQdbzeDA8
	0I0d2Doh0n7krkIM93QiO4z/vKgzN0peOB4YO
X-Google-Smtp-Source: AGHT+IHJV6Lqt0M69QP75rhTnc4EGw8bgsYHixzIOWzmQ/W0T5fBOc4OYsmaq0/5BaxifVnY2kb+0zD0SFv1RUA+6eM=
X-Received: by 2002:a17:907:39a:b0:a38:5302:89ec with SMTP id
 ss26-20020a170907039a00b00a38530289ecmr380516ejb.42.1707429041842; Thu, 08
 Feb 2024 13:50:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
In-Reply-To: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 8 Feb 2024 13:50:29 -0800
Message-ID: <CAFhGd8pfMjkdTWx3HnVRpZNgbOy7KkvuD5vytP0G+0ByY_++9w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix changing ELF file type for output of gen_btf
 for big endian
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com, 
	morbo@google.com, keescook@chromium.org, maskray@google.com, 
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 12:21=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o from ET_EXEC to ET_REL via
> dd, which works fine for little endian platforms:
>
>    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF.....=
.......|
>   -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.........=
.......|
>   +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.........=
.......|
>
> However, for big endian platforms, it changes the wrong byte, resulting
> in an invalid ELF file type, which ld.lld rejects:
>
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF.....=
.......|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>   +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>
>   Type:                              <unknown>: 103
>
>   ld.lld: error: .btf.vmlinux.bin.o: unknown file type
>
> Fix this by using a different seek value for dd when targeting big
> endian, so that the correct byte gets changed and everything works
> correctly for all linkers.
>
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF.....=
.......|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>
>   Type:                              REL (Relocatable file)
>
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Tested-by: Justin Stitt <justinstitt@google.com>

> ---
>  scripts/link-vmlinux.sh | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index a432b171be82..8a9f48b3cb32 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -135,8 +135,15 @@ gen_btf()
>         ${OBJCOPY} --only-section=3D.BTF --set-section-flags .BTF=3Dalloc=
,readonly \
>                 --strip-all ${1} ${2} 2>/dev/null
>         # Change e_type to ET_REL so that it can be used to link final vm=
linux.
> -       # Unlike GNU ld, lld does not allow an ET_EXEC input.
> -       printf '\1' | dd of=3D${2} conv=3Dnotrunc bs=3D1 seek=3D16 status=
=3Dnone
> +       # Unlike GNU ld, lld does not allow an ET_EXEC input. Make sure t=
he correct
> +       # byte gets changed with big endian platforms, otherwise e_type m=
ay be an
> +       # invalid value.
> +       if is_enabled CONFIG_CPU_BIG_ENDIAN; then
> +               seek=3D17
> +       else
> +               seek=3D16
> +       fi
> +       printf '\1' | dd of=3D${2} conv=3Dnotrunc bs=3D1 seek=3D${seek} s=
tatus=3Dnone
>  }
>
>  # Create ${2} .S file with all symbols from the ${1} object file
>
> ---
> base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
> change-id: 20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-dbc55a1e129=
6
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
