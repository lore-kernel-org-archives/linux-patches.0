Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C41B6D0F
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736697195; cv=none; b=TQCYAP6gxrONEAyxc+ocJK7Aek/dUhgGsnGo7D+UEhXdE/m0oxo1S4lqw5ibdr6Fqqo3cH9jQYhrpSuiBoaIeaxfRorMTeb1BG2jjmpy0jbxByRqZUSAYBhK+J8agtro1l8m8BYzKPd6KOtxPnlbzIyl8DDwKxpeD/eGd5LXpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736697195; c=relaxed/simple;
	bh=XKtBIVcfYF7vCE3NonS7ml3BeozetTNvaD8SB5ergt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lhNfe2z3EQZpNBOrxCCDZjFJBsTnPCRy0BJagYm3R5Oy8fzSHObvwrgkBOn2C/SfVa/k22T9CPimLu3NylrUF25D9WlJLex87A8e8bEpJmZxc9UMLCX8zErKcsTCHCxaiWPcdBvBL8Em9dLyw3LS+K6pYuvanTfFB6laTcbHNnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso6332810a12.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:53:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736697191; x=1737301991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3x4xwrPgtF8mYskiSjFTuo3Zflp2B8uXfK32eBvHMY=;
        b=jHzPRR6K/niuJu4Gao4TeIc3seX84FRW+0wd1yVllu5bwRmesbgTVvU9CL6ie1JKB5
         Foio2g56q16g066IKfd2LK4yYkdwvejhrMBlW95o27B1U9SLRHLspfhRVNeRQ4UZUsLl
         N7vJcIKXOWlWEvxzX9wntuY4ockUNnZZIrbXPOr5OpQ/N+yRGicWsqvl+nRQ2pDDqgim
         zXdToHrOQ2o491HzgM3m5UcbPKOeakm8eP17iuOIEHFAuPToThNTuOe0g0IJFNr+RMSS
         ChYmbMWUbdMYqhSi0RBmneAuqHBND81TiA2bLhnlJFqWNSGvjXLLMD3DoD7clYTRMe83
         eCUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXYesPr6vUabyG9r6k2dvCmzEfiuvMEAN5f2sozk5fcbw+GgTYjmPPi9E0f3LLnWns3TL9MypG@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4uqDNvQtCoguQX7aLcRaWLyYsMQjZNqz7rQEWdxCHr+PnvtuK
	ysQjoAGpbBigT+UD7S1gZ1WgiYPam689WtE5PkWwZvo1Xxktny4JqfkVoubdy+o=
X-Gm-Gg: ASbGnctr/h9K0LPzla2Ao+/TpiRCDmyhBsBRbiTiqr3pNlNJl08obVWkTOUaSJig//k
	2E/Ipgq4378KTzuzaKSXjW+ricpF8co7fxOj+dHssfTkdfB7dCJpoBnDc8P4hbFKNTUGi5+2LKU
	Ow7uJTGv88265Ru5jXtH5HuC80UkIGhtCmuyXaKLOCnMvk2Zln8P+gpKrtWLVj9H0h38mtxV0ct
	fUqdanDJsIsEgB0Xyn/nX3UhgK5oJruDYVGjaGRm5Lv+5VPAXLC7A9xuWw6CVH4Bp6JBmIncaMU
	Sw/9iGAeU2I=
X-Google-Smtp-Source: AGHT+IGzemj4cxwZ+QB3z+PgmAm9215NsrFFOk+/2rSUrst8V7PycRlvfci3blo3RowDqb7WwI06Mw==
X-Received: by 2002:a17:907:94d3:b0:aa6:93c4:c68f with SMTP id a640c23a62f3a-ab2ab703fe3mr1528619866b.21.1736697191162;
        Sun, 12 Jan 2025 07:53:11 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9134403sm392687166b.90.2025.01.12.07.53.10
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 07:53:11 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa68b513abcso630490366b.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:53:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXF0TTDrMZ2mx2gFwSBVmfvvO+XdaVWA5lT64xun/X5YlN7lSvFjO3jEunASeqBhNuOdqdtz/70@lists.linux.dev
X-Received: by 2002:a17:907:da5:b0:aac:431:4ee7 with SMTP id
 a640c23a62f3a-ab2ab6a8e99mr1653988566b.5.1736697190836; Sun, 12 Jan 2025
 07:53:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-2-ojeda@kernel.org>
In-Reply-To: <20250112152946.761150-2-ojeda@kernel.org>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jan 2025 10:52:34 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-qKHDvwzxB_5yTg=p_K6ON9_8LrUYw3OvGtBF-mjGsng@mail.gmail.com>
X-Gm-Features: AbW1kvY-uy6tr_CtwQsH_qQj4stu4DxhiqcHXV_FSmxTLN_RPZL6FE7-pv4wzFA
Message-ID: <CAEg-Je-qKHDvwzxB_5yTg=p_K6ON9_8LrUYw3OvGtBF-mjGsng@mail.gmail.com>
Subject: Re: [PATCH 1/3] docs: submitting-patches: clarify Acked-by and
 introduce "# Suffix"
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Acked-by is typically used by maintainers. However, sometimes it is
> useful to be able to accept the tag from other stakeholders that may not
> have done a deep technical review or may not be kernel developers. For
> instance:
>
>   - People with domain knowledge, such as the original author of the
>     code being modified.
>
>   - Userspace-side reviewers for a kernel uAPI patch, like in DRM --
>     see Documentation/gpu/drm-uapi.rst:
>
>     > The userspace-side reviewer should also provide an Acked-by on the
>     > kernel uAPI patch indicating that they believe the proposed uAPI
>     > is sound and sufficiently documented and validated for userspace's
>     > consumption.
>
>   - Key users of a feature, such as in [1].
>
> Thus clarify that Acked-by may be used by other stakeholders (but most
> commonly by maintainers).
>
> Since, in these cases, it may be confusing why an Acked-by is/was
> provided, allow and suggest to provide a "# Suffix" explaining it.
>
> The "# Suffix" for Acked-by is already being used to clarify what part
> of the patch a maintainer is acknowledging, thus also mention "# Suffix"
> in the relevant paragraph.
>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72m4fea15Z0fFZauz8N2mad=
kBJ0G7Dc094OwoajnXmROOA@mail.gmail.com/ [1]
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation=
/process/submitting-patches.rst
> index 1518bd57adab..c7a28af235f7 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -463,9 +463,17 @@ If a person was not directly involved in the prepara=
tion or handling of a
>  patch but wishes to signify and record their approval of it then they ca=
n
>  ask to have an Acked-by: line added to the patch's changelog.
>
> -Acked-by: is often used by the maintainer of the affected code when that
> +Acked-by: is meant to be used by those responsible for or involved with =
the
> +affected code in one way or another.  Most commonly, the maintainer when=
 that
>  maintainer neither contributed to nor forwarded the patch.
>
> +Acked-by: may also be used by other stakeholders, such as people with do=
main
> +knowledge (e.g. the original author of the code being modified), userspa=
ce-side
> +reviewers for a kernel uAPI patch or key users of a feature.  Optionally=
, in
> +these cases, it can be useful to add a "# Suffix" to clarify its meaning=
::
> +
> +       Acked-by: The Stakeholder <stakeholder@example.org> # As primary =
user
> +
>  Acked-by: is not as formal as Signed-off-by:.  It is a record that the a=
cker
>  has at least reviewed the patch and has indicated acceptance.  Hence pat=
ch
>  mergers will sometimes manually convert an acker's "yep, looks good to m=
e"
> @@ -477,7 +485,7 @@ For example, if a patch affects multiple subsystems a=
nd has an Acked-by: from
>  one subsystem maintainer then this usually indicates acknowledgement of =
just
>  the part which affects that maintainer's code.  Judgement should be used=
 here.
>  When in doubt people should refer to the original discussion in the mail=
ing
> -list archives.
> +list archives.  A "# Suffix" may also be used in this case to clarify.
>
>  If a person has had the opportunity to comment on a patch, but has not
>  provided such comments, you may optionally add a ``Cc:`` tag to the patc=
h.
> --
> 2.48.0

This makes sense to me.

Reviewed-by: Neal Gompa <neal@gompa.dev>



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
