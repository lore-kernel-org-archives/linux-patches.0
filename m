Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7061F64CE8;
	Tue, 13 Feb 2024 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707785746; cv=none; b=CXFokEZ7sx+0U+RFY0yRhKRWJflFTPKtHqVEx3lrJWJDAVPWeT4qeeLTMNepCuwFHsS9I/DO9qy8hIs5QS5hMzTwb0TTDbKnZgYcpFPFqMrhcovhXQwpRyeu6PFPBW53c1sN0FZtVzS7ppRY0DTeFcylrQv9yl+5Fh0yK+R9yRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707785746; c=relaxed/simple;
	bh=x5LbtggR4Z3xaic6f6M9HxtLNo4SYpCsgxFez8n4Mqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5ej6mFN+6o1TMq7ScucUhCPQHv5kq9ph6vPEteThxn6Ix8HEy7Ugwhd96e2SOrS9xgtVlYMgyki373/kslfY+O9Znt4kuHVGNN9WkT/alMbKm2UcfOWIt/ixDRtNuIT/0ZaTj6j77ig1Y78pODwX3fNqUJ2XAhdnCL8CuLJeQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HH6dqeeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HH6dqeeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D075C433A6;
	Tue, 13 Feb 2024 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707785746;
	bh=x5LbtggR4Z3xaic6f6M9HxtLNo4SYpCsgxFez8n4Mqs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HH6dqeeMCz4ysgu5nOyiSwKFIVRhElfGwxll//vyMwoV5+dzYmBVbWne9Epn50sHC
	 Xv64bndEVgi2v47iqTNtM91j1nUk8TZQ1xRburn2kU7BqBRzGs7b8TwCGsHJX9xsOn
	 6XC256+nLTPFY/DiJ2hRMNRwmfmXB/gRcvckxZOMU8oU+hDjlN/2+9CnvrF+5lAbkZ
	 9wg3/lc5jeMv2lguto4nh62ncD0EFC5BV2yx+oFrL8Lo1xyDIKd3mXOdYKJ5BeUClh
	 UL1LRqm8+32I59VUAuWI7VMQ5XB6maGbHVorypG2rBo3VOkVYBPLO6lT9BxDxn9uI+
	 JQUndQiOOdjJw==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-51147d0abd1so4276629e87.1;
        Mon, 12 Feb 2024 16:55:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX7HTxr2S0eMcBroGBHrE3BfvpQtFykIijoTjiN9OJvQn21XKVTXA0ahlhMRBMSuTHaxWXUUiBfri5GEjwz0C2S/3NnxsAJzPoKhoSUjaax3NfhtxXvmYqqAjNxwtY=
X-Gm-Message-State: AOJu0Yybz+qfxJL+1QHqYcGS4DELEV0ZXs9h93bvjPi5EMzOc6GUkQuv
	iaYvT2p3F6xjZ6KCrgVvaODWLQmMATe1fmLk4tA1p1IPTwGj9yO0cbVlpLelLT6RZdrT42zB+SQ
	ne9X5jnt4ebFE9U5FJqQshY7eyt8=
X-Google-Smtp-Source: AGHT+IHKL6G3yu5doOJaxyZoeQuHPK6LLjZ7gg1ZT1vESg0Rl9kdoUbQ0BifEkJzoizI59vLRa0vB/zcugpsMQjVSQc=
X-Received: by 2002:ac2:4245:0:b0:511:4268:3a54 with SMTP id
 m5-20020ac24245000000b0051142683a54mr5659125lfl.29.1707785744497; Mon, 12 Feb
 2024 16:55:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
In-Reply-To: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 13 Feb 2024 09:55:07 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT1+K87M2f_8enCydaKgDPLP9E1ex-as85eC2hB49bkBA@mail.gmail.com>
Message-ID: <CAK7LNAT1+K87M2f_8enCydaKgDPLP9E1ex-as85eC2hB49bkBA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix changing ELF file type for output of gen_btf
 for big endian
To: Nathan Chancellor <nathan@kernel.org>
Cc: nicolas@fjasle.eu, ndesaulniers@google.com, morbo@google.com, 
	justinstitt@google.com, keescook@chromium.org, maskray@google.com, 
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 5:21=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o from ET_EXEC to ET_REL via
> dd, which works fine for little endian platforms:
>
>    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF.....=
.......|
>   -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.........=
.......|



I am afraid this dump is confusing.

The byte stream "03 00" is ET_DYN, as specified in ELF:



  Name        Value
  ------------------
  ET_REL        1
  ET_EXEC       2
  ET_DYN        3



It disagrees with your commit message "from ET_EXEC to ET_REL"

The dump for the old ELF was "02 00", wasn't it?





>   +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.........=
.......|
>
> However, for big endian platforms, it changes the wrong byte, resulting
> in an invalid ELF file type, which ld.lld rejects:


Fangrui pointed out this is true for inutils >=3D 2.35



>
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF.....=
.......|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>   +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|

 -  00 02
 +  01 02



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


Ditto.




>   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.........=
.......|
>
>   Type:                              REL (Relocatable file)
>
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
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



Do you want to send v2 to update the commit description?


The current code will work, but another approach might be to
update both byte 16 and byte 17 because e_type is a 16-bit field.


It works without relying on the MSB of the previous e_type being zero.
The comment does not need updating because the intention is obvious
from the code.


if is_enabled CONFIG_CPU_BIG_ENDIAN; then
        et_rel=3D'\0\1'
else
        et_rel=3D'\1\0'
fi

printf "${et_rel}" | dd of=3D${2} conv=3Dnotrunc bs=3D1 seek=3D16 status=3D=
none










> ---
> base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
> change-id: 20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-dbc55a1e129=
6
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Best Regards
Masahiro Yamada
