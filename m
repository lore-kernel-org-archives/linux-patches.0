Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5821BB6BC
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736697073; cv=none; b=ZVarJdX2C29nHDPEI9/FpOvbywiv1WY5ckNGfjrSUfE7Nsbh/CkXyRlruVaG5khEmlggh1CO3MCN+t8I5tuPNyteXzbzN06lBBKRNhRh7fGwbStoOU3pjk4b1r1SFocJuAe8MJfvrIeX2bC2LEiQUMzMJHTG/zartlhTVjyhBO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736697073; c=relaxed/simple;
	bh=CAjVSJwg2hQJBUdPPkdWwoqTmFKoP7sCht21kA+Dvtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tnr/3uKebm6rcL6QrfJRJz+ypnu9/bV0MlRg72PAC4PxZnJulxFjXwm9gthVabsFludJ6IbDXvNLgoOu0c8C4GIMfEn8dAYNkzPouRf4Gp68LV+6ZvDd7hcOAdm6ysAGlW/cA4yNWC4y3AUievhkyYGSODW/hQ7gyMObOlda3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaf8f0ea963so700428666b.3
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736697070; x=1737301870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojo6rpVsQOShQmgPfJGcLHfKrOA2VqG0QBnNPGXTc9w=;
        b=HWtTlwXte1Tn0Xj0q6xk4pk25y8Eqm51BaoWhQ0ylcyMzWHGyHgBGSZbn0n6OuCxKv
         gNAXQ9ec5JVnftbQDLu6uaigZJkc9+uGbDMQ/3jN7ZnlH2BVrQ+uz68qxIKpuvlQC359
         /lez4KzQaTySumaYVDyBn8r/tayrd4RLgMyO23trXvipb/e4r2NWoblxQw3GhH6D8qcp
         ZzBIBsVj+UyBfDsYlR3iSj/tbLjHgqXxtx45y8iVjsz1VmInMWda4cUwUbdb9y6wjtr5
         4VOYpnvc0PRCajGr2nhm0PPp9kfne8IE9YAz40fIvy4alYYzBQQ+EDySVW/Q6Cj8WIiQ
         5H4g==
X-Forwarded-Encrypted: i=1; AJvYcCW2Chl6kECxwyZk1OwmyKhRvclL+G0P/pYF2pVzwRaVzZqxt9hf0nuvJ3ks+bPyiO+iBcT5F2AB@lists.linux.dev
X-Gm-Message-State: AOJu0YwkMKg+wvHejkv/ETnDFNVqTeinsZRg8eHd5TI2aoobs4zh/dg9
	3z46fuUQ92Vyd57w323rSiY5aItmLsYeI1yGvbFX5kPL1IAAc2CUTx07SYzG+8k=
X-Gm-Gg: ASbGnctqbMLB8Ei9Rv+w3GKyVwNEU/A3O/ZQ3UZI91/FuPIBWVWn55/7G13XmSCEAWf
	/0E5hlfu6P8zuCgS4PAl0iqyEp9ZVTN5x3XtjZmZVbZqmdrGLMNYd9M1Ok48JheVfyaFOXVll8w
	gglhqc81KxOfCkyreBuGQBqEjCchi7v3orr+tnf7uZwv8veZY3mps3Ft++Kpfr7P+lmfDvdiPB9
	/Uc2174eJdnhrWkp/jP5A5LPv1zH97quLKyV8rY0ioarhAFnsvbUDWk2SlJ2Q9gFVX/4bLRfBE9
	Kp9k+BJz4zg=
X-Google-Smtp-Source: AGHT+IGtLbNSJXYoI5p7jERycvRpReRW3MlfCHxuBUyHRVxXGhzn6qe/VbU8twkz3RatlnhDFdeaZw==
X-Received: by 2002:a17:907:3e9b:b0:aae:d199:6eae with SMTP id a640c23a62f3a-ab2ab6a38bbmr1470480266b.14.1736697069968;
        Sun, 12 Jan 2025 07:51:09 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905f04fsm386756666b.27.2025.01.12.07.51.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 07:51:09 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so6239753a12.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:51:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVDnQPROF5iC8eA5IH7zyLUpitzM89ncSiigklpexSiw/VGPZ00PYVtVO7NrkM05yAs0tR9wv2J@lists.linux.dev
X-Received: by 2002:a17:907:70c:b0:aa6:7d82:5411 with SMTP id
 a640c23a62f3a-ab2abc6ca52mr1659041866b.40.1736697069149; Sun, 12 Jan 2025
 07:51:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-3-ojeda@kernel.org>
In-Reply-To: <20250112152946.761150-3-ojeda@kernel.org>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jan 2025 10:50:32 -0500
X-Gmail-Original-Message-ID: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
X-Gm-Features: AbW1kvbn33SbtjplUZmkNvnmbm5gMpbukWC4yMx1bRK1ShqczijYBGnS7iH4t3o
Message-ID: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Newcomers to the kernel need to learn the different tags that are
> used in commit messages and when to apply them. Acked-by is sometimes
> misunderstood, since the documentation did not really clarify (up to
> the previous commit) when it should be used, especially compared to
> Reviewed-by.
>
> The previous commit already clarified who the usual providers of Acked-by
> tags are, with examples. Thus provide a clarification paragraph for
> the comparison with Reviewed-by, and give a couple examples reusing the
> cases given above, in the previous commit.
>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation=
/process/submitting-patches.rst
> index c7a28af235f7..7b0ac7370cb1 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's "=
yep, looks good to me"
>  into an Acked-by: (but note that it is usually better to ask for an
>  explicit ack).
>
> +Acked-by: is also less formal than Reviewed-by:.  For instance, maintain=
ers may
> +use it to signify that they are OK with a patch landing, but they may no=
t have
> +reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly,=
 a key
> +user may not have carried out a technical review of the patch, yet they =
may be
> +satisfied with the general approach, the feature or the user-facing inte=
rface.
> +
>  Acked-by: does not necessarily indicate acknowledgement of the entire pa=
tch.
>  For example, if a patch affects multiple subsystems and has an Acked-by:=
 from
>  one subsystem maintainer then this usually indicates acknowledgement of =
just
> --
> 2.48.0
>

This doesn't make sense as a distinction. What defines "thoroughly"?
To be honest, I think you should go the other way and become okay with
people sending Reviewed-by tags when people have looked over a patch
and consider it good to land.

To me, Acked-by mostly makes sense as a tag for people who *won't*
review the code, not for those who *will*. Blending Acked-by and
Reviewed-by just creates confusion.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
