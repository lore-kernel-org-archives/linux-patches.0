Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A519311724
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707801638; cv=none; b=DpjpYSiwhDlgabO2MtyarkBzt5iKDQiyP12DIF7q+kaDA6BU6mLaylAx3CP8cCOzBZ22PfeTHGm/h6mPq0J+7a9sFAsKMdPYOzjmXFlxLy2w0z7MaUQwgKKhN/e5UYKxPNE0T1ZX+pPziDOGuLhzq8FZx2MVx0W1VTZ9Jy5vhes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707801638; c=relaxed/simple;
	bh=6UxNgBbLmEd9k8EtkUtoBRblPssIxgoKWBIO4OHyBlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ys9l82n4Zod1sa+kwIpynl9xJg5B/qWRtcj+CwkfwQKen8uCHcSgw9NM6FrSS3QND0a/EIclKI2OTH0FB8gKJZqCkVYz1KftJbqWPyq9rezZOAEhNtCvVRDyqncLeTphQgd/Yimp5yJgmHnbfc7YISYAPUNQGVv6MnilwO8WH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OWHzjQwB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OWHzjQwB"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-410c9f17c9eso24695e9.0
        for <patches@lists.linux.dev>; Mon, 12 Feb 2024 21:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707801635; x=1708406435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jsA6Vin23ehyR7Ij/sBXeXrDTbKj+YLFziDzOlAwThM=;
        b=OWHzjQwBR50sPUR5gmR4IgGSLK3HdhH9ULzf+kGYIgVLdkovuqgp6aN6gGCVKhZsNb
         bXH+IovDFKTPDKDMzKq8YioIBO73qf+T+VTwAL283cIXKf/JqocJ2uQMaYRncB5d3BcW
         gBvT52BldYX0anrxhgwumLX33fnZbW/LrOADiXWwm7mjmcXKD+/qQnaPwAi54Vop/Z9F
         Wv9QGf4wzjS5IMBU3EYrdevlccoHji7bMtH9jrHIBsATJkoHQD9qCJC/iztV0eE/IaPB
         Hlonx0NdI96e+G1JuQ92Mih9SXr+GrAOamKCiqqcG+0DH3HX3tqLD0+Mme8cY8grcqGi
         796g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707801635; x=1708406435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsA6Vin23ehyR7Ij/sBXeXrDTbKj+YLFziDzOlAwThM=;
        b=X9rmuyJWaHIrq93dNCkFDJa/Yo6a1S7O68C1sdHMHQ5OJUIwqQ0I3SFlQ52u79JYXo
         aEELmNBYwwMKu08aBWn9/m0Z+e7zB2pWeUn/Ltoy6yY80yxayAmgIiEsFX+dqtQ7fEtK
         aYrr+XwTodgNakqjs2xwRY+5SljNbG3ONXcpoAxSYu4c29xygGU2PvYY/wbNEdb6yIGa
         IEk14XeHx1ud4Luml12vjrFlAdDnstmYpLuO3t+Ij5k+b5wl3hUu5985nUZvFjRXE6fD
         HxblOfKY8ySRFMw5yXAacsW6ICrTkipB4KCHempG7NKUXA9UksvH54CPOjo237YnaZZO
         utIg==
X-Forwarded-Encrypted: i=1; AJvYcCXblRs6LfiWqP9Ybg4exAqnZMvTa18e1I63WrWjpEuTnvTByzi8H3nUQc3+bSqpzPOcKASw3QaMyALQl8MIdVw71yhhRfhDvg==
X-Gm-Message-State: AOJu0YwH/r+fCuwZckJLRe3mHi/VfxSOPk7Rf0Bbr6o3UjJ+vymvVlV1
	KFSSsEdDw8bIRzfvZuAi1O4Z9/zddydTkXkxkcNGBUGTX/wgWSzTBkel3CVlkfo/UkRGVuUH46x
	sGZNRUW6BwbGxDoVYAC2gO0Q2afmSrMWsrfk0
X-Google-Smtp-Source: AGHT+IHFi6Ul8/IpSL5dH9UF36vlNNuEWfYaVHz0ux89RLv8jLsict9IUa3/bcTp+oAhjprbpCQkEDOI202dHtcpqvw=
X-Received: by 2002:a05:600c:1d92:b0:411:c715:667 with SMTP id
 p18-20020a05600c1d9200b00411c7150667mr1145wms.5.1707801634918; Mon, 12 Feb
 2024 21:20:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240207-s390-lld-and-orphan-warn-v1-0-8a665b3346ab@kernel.org> <20240207-s390-lld-and-orphan-warn-v1-11-8a665b3346ab@kernel.org>
In-Reply-To: <20240207-s390-lld-and-orphan-warn-v1-11-8a665b3346ab@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Mon, 12 Feb 2024 21:20:21 -0800
Message-ID: <CAFP8O3LhKW4Cg5LQQVmAmFtT4Psap+izrDV+6Bb1zp4yC1WrNg@mail.gmail.com>
Subject: Re: [PATCH 11/11] s390: Link vmlinux with '-z notext'
To: Nathan Chancellor <nathan@kernel.org>
Cc: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ndesaulniers@google.com, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 4:15=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> ld.bfd defaults to '-z notext' (although it is customizable with the
> '--enable-textrel-check' configure option) but ld.lld defaults to '-z
> text', which causes issues with building the kernel due to the presence
> of dynamic relocations in sections that are not writable.
>
>   ld.lld: error: relocation R_390_64 cannot be used against local symbol;=
 recompile with -fPIC
>
> Add '-z notext' to avoid these errors, as this is expected, which
> matches other architectures.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

This follows arm64/powerpc/loongarch/riscv.
LGTM.

Reviewed-by: Fangrui Song <maskray@google.com>

> ---
>  arch/s390/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/s390/Makefile b/arch/s390/Makefile
> index 73873e451686..994f9b3d575f 100644
> --- a/arch/s390/Makefile
> +++ b/arch/s390/Makefile
> @@ -15,7 +15,7 @@ KBUILD_CFLAGS_MODULE +=3D -fPIC
>  KBUILD_AFLAGS  +=3D -m64
>  KBUILD_CFLAGS  +=3D -m64
>  KBUILD_CFLAGS  +=3D -fPIE
> -LDFLAGS_vmlinux        :=3D -pie
> +LDFLAGS_vmlinux        :=3D -pie -z notext
>  aflags_dwarf   :=3D -Wa,-gdwarf-2
>  KBUILD_AFLAGS_DECOMPRESSOR :=3D $(CLANG_FLAGS) -m64 -D__ASSEMBLY__
>  ifndef CONFIG_AS_IS_LLVM
>
> --
> 2.43.0
>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
