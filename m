Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E918F13D2B8
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 21:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128242; cv=none; b=VJ1bRMJGVOdf0ls/APXiVSvnFEibtnehVYpFgNj1DCk8GTZJuyTV9mSLeOZtU3IiPuJwshQn+9421oVjXvkNUY09V4QWQC+DjnOkCCskCU76Th00e6MtAqWa/XX4944Kq58C6ej+DtOfIFOd5bSIOnrWOiYr3uQrEXTs4vqggaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128242; c=relaxed/simple;
	bh=WkQita1UbMfMen1gzqw2QW7P3OKiOs39bLWHgZY5IA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U6kl3sahEZHHuYzAunK4bG8qHRFYdFJ+igRdwCTQTzFXfOCqeb8mtL/LBC5ikivBVyl/Ma737E0FmNOT0fzb/d85FJkrOXgBrrBdYmKcDLouv1rr4tHChrLyPdf3RybyVNJrsssLL0GocElGAyaIfh4wr5j1aFFxYr+RQ4z98ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZnxBY7QL; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZnxBY7QL"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58ce966a1d3so12862a12.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 14:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720128238; x=1720733038; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZUXkSX9WN+AQbdLcHROy2ZT3v7SVR09OPnTWoMgUyo=;
        b=ZnxBY7QLH4MrH7CuR2BD2YqY1omtejlNVc/0zKIFatieTmPoQQXNDKAjW+Md/rWORa
         V7m5brc5/EzFDtVSJjtD7+tURGoJ+jaTd3oXXGc6GS8SERrafN0ZMIzEJOJad/Kkn4Zg
         hHE/SXTPgZ1K/WdppT3OY9cIcKVkf9ZyI7nuT560ZoYWnTsqRJrEzdo5qBWEJw5GnO1z
         MR4LU4YleJ38XbRrAvuweWWPjNCmlaq0h+ckbnlyCqkFPAgd4SQpZ0LuGQFMLHNhG9BD
         V8S8emWQ+Z2Ha8/KHFEHunBDNWI5kbyWgJBAlaDBr6t8GxLyRuwu/FbuxCEaeXf5nywz
         9Zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720128238; x=1720733038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZUXkSX9WN+AQbdLcHROy2ZT3v7SVR09OPnTWoMgUyo=;
        b=oDkthLu1EOjcwEkd6pnQB1qijDfO1h1DbnuucYCkTjRoBKI2xl9Vx58SYp4n91W7lm
         Rpdgnj5YKXEjrX4MIDMT/7UNCa0cH2wuQAOMIVBnuxolJkIWjZG4h6tY8QHf8RQu17qd
         qZ/9dDCg348PV0KjBD1x0JkvZ18mvEHE7eDms3+rkp5PXyOcvETBWReXmXocTttgd677
         zvlURnUIGiVvL7+Gmij8ueWiuW2Ra/LALXxziu+yzUHxTEk0GGQwOsQfkOaQPbiiGoXv
         goLlM3rT1c/kOTFybD/QbdkVYY/EUiFcBxI4OP0zw504UUNiUyllbvvdsy9ocLQ7iFVl
         9/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpwLIOMJikKv/bK44bkLtDqzBFhdCoBeltAzk9BnGKKhnH3XJOSzm/6p6jRjK4DdXhTuZmcqaUmNLNrqqOOsLX15mDb5A1ag==
X-Gm-Message-State: AOJu0YxOxkKhVKa/WzPOHFjOD5TU5HGemo5NYathMSHKEHk+UWB9LLyx
	FxQIlyYNpZxpTXRKmgyuZWYSFJ0pbkp7nfh5tzuP8YxAvdxe8/3LL6646sgTtEdGgwZc1hx70Tt
	N3Q+l9eGP0wgGshtFRgQELG3NY8KQTBvEfmdi
X-Google-Smtp-Source: AGHT+IFNiC12ACDfwoCP+FCXjiKRvFZtf6R72oNOV5+4tIR6dsRZUTSkQftvcnrUomvX2XqiYI70nEOpdD0FSz54nrc=
X-Received: by 2002:a50:9fa1:0:b0:57c:b712:47b5 with SMTP id
 4fb4d7f45d1cf-58e02735e86mr205813a12.4.1720128237990; Thu, 04 Jul 2024
 14:23:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-update-ld-version-for-new-lld-ver-str-v1-1-91bccc020a93@kernel.org>
In-Reply-To: <20240704-update-ld-version-for-new-lld-ver-str-v1-1-91bccc020a93@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Thu, 4 Jul 2024 14:23:46 -0700
Message-ID: <CAFP8O3JUgH-tBJtqO-QS0HmO4mrFBE6Dz+tnrBcse=gw_Q_4vQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Update ld-version.sh for change in LLD version output
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 9:19=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> After [1] in upstream LLVM, ld.lld's version output is slightly
> different when the cmake configuration option LLVM_APPEND_VC_REV is
> disabled.
>
> Before:
>
>   Debian LLD 19.0.0 (compatible with GNU linkers)
>
> After:
>
>   Debian LLD 19.0.0, compatible with GNU linkers
>
> This results in ld-version.sh failing with
>
>   scripts/ld-version.sh: 19: arithmetic expression: expecting EOF: "10000=
 * 19 + 100 * 0 + 0,"
>
> because the trailing comma is included in the patch level part of the
> expression. Remove the trailing comma when assigning the version
> variable in the LLD block to resolve the error, resulting in the proper
> output:
>
>   LLD 190000
>
> With LLVM_APPEND_VC_REV enabled, there is no issue with the new output
> because it is treated the same as the prior LLVM_APPEND_VC_REV=3DOFF
> version string was.
>
>   ClangBuiltLinux LLD 19.0.0 (https://github.com/llvm/llvm-project a3c5c8=
3273358a85a4e02f5f76379b1a276e7714), compatible with GNU linkers
>
> Cc: stable@vger.kernel.org
> Fixes: 02aff8592204 ("kbuild: check the minimum linker version in Kconfig=
")
> Link: https://github.com/llvm/llvm-project/commit/0f9fbbb63cfcd2069441aa2=
ebef622c9716f8dbb [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  scripts/ld-version.sh | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
> index a78b804b680c..f2f425322524 100755
> --- a/scripts/ld-version.sh
> +++ b/scripts/ld-version.sh
> @@ -47,7 +47,9 @@ else
>         done
>
>         if [ "$1" =3D LLD ]; then
> -               version=3D$2
> +               # LLD after https://github.com/llvm/llvm-project/commit/0=
f9fbbb63cfcd2069441aa2ebef622c9716f8dbb
> +               # may have a trailing comma on the patch version with LLV=
M_APPEND_VC_REV=3Doff.
> +               version=3D${2%,}
>                 min_version=3D$($min_tool_version llvm)
>                 name=3DLLD
>                 disp_name=3DLLD
>
> ---
> base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
> change-id: 20240704-update-ld-version-for-new-lld-ver-str-b7a4afbbd5f1
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>

Thanks for catching the issue.
If we want to minimize the number of special cases, perhaps we can
adjust `version=3D${version%-*}` below to

version=3D${version%%[^0-9.]*}

(POSIX shell doc:
https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#:=
~:text=3DRemove%20Largest)

${version%%[^0-9.]*} is a simpler form than what glibc uses:

  "LLD"*)
  # Accept LLD 13.0.0 or higher
    AC_CHECK_PROG_VER(LD, $LD, --version,
                    [LLD.* \([0-9][0-9]*\.[0-9.]*\)],
                    [1[3-9].*|[2-9][0-9].*],



--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
