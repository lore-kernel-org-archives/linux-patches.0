Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505EE13EFF5;
	Wed, 14 Feb 2024 21:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707946689; cv=none; b=TmLDGa0drVyEz6b3uJujsptBI0Y1HF25omJLsl2R/082M055fEnSDB4b/4gzth0/2KIcWUhnPTNM85PSwAux+bNDqKlE4YRDJ91eVl2hmHteu970Hj3GtBVc+ZCXgr98yviRD+a6rtOVwRfCjhbjpE8/LTA7vy8fWiN8NbPZp/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707946689; c=relaxed/simple;
	bh=UUPKAcrXV3sriobv5a2MejWKkdWDLFLi5VZHMfDG010=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CW7VkYQAMMsuSEEWaTtSf3sf9KWxj77qKLZqO0iquOYS9A/X5s3DZJNUYpOY/i5N0MAH+vRLVBYGbj5gUEe9hEzyYUjjCxK16aHi4lczqzq9cr3IVlAceC0AqKp28Gbsb5+P8FdznoXE4tc7vxy5xPn9ZSzxF19RuJF2oqmz1Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/X0U+Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/X0U+Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF85C433F1;
	Wed, 14 Feb 2024 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707946689;
	bh=UUPKAcrXV3sriobv5a2MejWKkdWDLFLi5VZHMfDG010=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u/X0U+JqFqRNrle6IPy7xdizrvaz3w5fRFbyoqrUiaiJlrKgKcKMx7PgqLeGr4Xr+
	 A8OahwP6epdjZgFXgJp9etsF42qn1YNLAzEoNquyTvQn04s/HuDPNSYQ75mJRqil6o
	 iFL30I83YlRm0BkOeGXyvIibjhmqIslDKIWkxSHp5Cu0b3JYXKC+ftnguU4BSRaUv7
	 vFLHEezVEDfSF+h86rJ59/eAuA8uSDyGG0zx/HHWae92vnPYBhJhLqwUdLmX3cytIg
	 M/vF+UxTGRRg8l3p8Jb/Hn19d4ty/6QmtpKryPL64pkOay57Tokhs1bVZtSbVq93BL
	 D/wuRiM9XEZaQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5114b2b3b73so233425e87.0;
        Wed, 14 Feb 2024 13:38:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVv7xDYvhj9ecN8SXJDp/VqIo4Lxme5MXJyPLAVictmKmZxQBf9zE+6JKkirRG6cId5j7ns5QfedBomZsvUj1JD3lDSwQQW5S7pajV00fva/z+932eki64oeWnphHc=
X-Gm-Message-State: AOJu0YxBg03wI+BT0cI92hsXcqpkgIvqG0iKIaa/4J/MKAy7fLGVBXP0
	9IklEE/irvxOCWc60dyqEo05/6YtxKzSz97pEvibhLKEonSSpfW4Ha1j4Vd3EYXG/VvOz8O7Rsl
	YviNRWfZNKzgRA7Jep1zi2u3ZUwo=
X-Google-Smtp-Source: AGHT+IGaYKxN9IyHvOKM2lTDAnhg9bpSWHXdMQSUzrkADaDd9GpHqhCli3rtc+UYqlFqe/KCZCHWjCJQjugyya5+E0A=
X-Received: by 2002:a05:6512:781:b0:511:a690:45dd with SMTP id
 x1-20020a056512078100b00511a69045ddmr31552lfr.16.1707946687494; Wed, 14 Feb
 2024 13:38:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240212-fix-elf-type-btf-vmlinux-bin-o-big-endian-v2-1-22c0a6352069@kernel.org>
In-Reply-To: <20240212-fix-elf-type-btf-vmlinux-bin-o-big-endian-v2-1-22c0a6352069@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 15 Feb 2024 06:37:31 +0900
X-Gmail-Original-Message-ID: <CAK7LNATZAh9fa8rd6jLwdEGUBHkAs9e4hZh=WvKeNLkGs2=8Aw@mail.gmail.com>
Message-ID: <CAK7LNATZAh9fa8rd6jLwdEGUBHkAs9e4hZh=WvKeNLkGs2=8Aw@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: Fix changing ELF file type for output of
 gen_btf for big endian
To: Nathan Chancellor <nathan@kernel.org>
Cc: nicolas@fjasle.eu, ndesaulniers@google.com, morbo@google.com, 
	justinstitt@google.com, keescook@chromium.org, maskray@google.com, 
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 11:06=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o to ET_REL via dd, which works
> fine for little endian platforms:
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
> Fix this by updating the entire 16-bit e_type field rather than just a
> single byte, so that everything works correctly for all platforms and
> linkers.
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
> While in the area, update the comment to mention that binutils 2.35+
> matches LLD's behavior of rejecting an ET_EXEC input, which occurred
> after the comment was added.
>
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to linux-kbuild/fixes.
Thanks.


--=20
Best Regards
Masahiro Yamada
