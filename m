Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED81A3029
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 16:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725293586; cv=none; b=m+fRxGukhC0QpPf5tgG+MfR238xdM1kpvaNFUS8HuJTArJTTASeejzGDtXtnLhOo7npZWsq6lvKpqrYUgb6p9fLQqTX5pU4cXfOcQ3DGo1EqOS30FeimpoHxjiwmpstXIc1IxTXPadf4bYXkIWVjBH5veJqERd2MyuqTlHPQ5BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725293586; c=relaxed/simple;
	bh=PkLOxCkNizd+ybNJD8OQZ9G2dup++KSG86ccKsgVnhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egt9b3ZskcagVPTHVIxJfJoUosABdM2ydhb7oLgId740DU/KTd6q00jJJP9qLHO6L0DlCJbksKr87EG5S3jjTsPqe2mgw6iilc/dF6KI4Y6lSjvtrMjc9VaXEKrLdlSxFhaYwxeMkdCetTsYXHhALEOnD7dGR99M7itsTSYRBIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dA+gb+PH; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dA+gb+PH"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c3d8105646so233653a12.2
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 09:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725293584; x=1725898384; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yr9ly3s1ev80tCY18uK4VK3dnJNlLG79YNi6DNJ7ijE=;
        b=dA+gb+PHKz0Uq83BwLexUd5kjhY6zzG7cb2rWzyfmVasWR+a0rhMKVvMln8gfW/tkt
         A3rpqE2wGc50Z2gFVOBIbAYSxUW4p8vCYf6Wu0+NqqPuWqrM6uxddzLHfh01sn62v/Vd
         9HD98eTPU0TnHEDTtxKnKq+v4fD/weMyH37E/SA3VISiVPO/OE9a1K8oHtGfASYDWFYH
         OTsHpfmBwahrNqxeQ0CQzxYmy2YFIH1GgG0Fn2g3xN/Ta5Epcgfhb+FRuGFdpYM9KgPH
         fZUEca0xh0xBEDGWel7WRLrk6OJt1TTphymfYytABdjZ+B8U8u61nBsXlnNTMvAcj6Sq
         viGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725293584; x=1725898384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yr9ly3s1ev80tCY18uK4VK3dnJNlLG79YNi6DNJ7ijE=;
        b=WWn6WHng4VAAGWdYy77SoYIJ8H5AxfS6AZ6DvcbF33GU48PbHmCJVlxZTARsbP/nQt
         lQKLc2zYBJhAx1giOEtOWQ3hfkBfKfFNag0jzrrFrhdWo/MZRSigl1PgkmkbFTf4QEzn
         4+b+4sGDj33vOgL/AHQ6rpiooPEx3IfV8/bk/We/CN1yLgivmcJKWVJ2151/jV7sjywK
         yxtbUYoQW494n60I1qi9XPF7yGXvNDF3tuoQkzBSX8DusaeIF0GhKp0ADTjh68hFqbLu
         1JCxAzlWF0UcmsUtxtcufc2gc4zRPCqwI7WqWvCpn2EIWH/kRQpsjdhu4LDhHKWDCLRS
         pm5g==
X-Forwarded-Encrypted: i=1; AJvYcCWtQHGxkl6k8GZB2z79/USSdExr4CbY6aDGAknqgy2swceifDcx02ZEh6WroO0tZgk/eaCFKnpV@lists.linux.dev
X-Gm-Message-State: AOJu0YyxcFR/kxIXEPShX0vg26dD9860g5Pfx/0CY9XMDa7q+Eb60DYC
	O4/adQ7p+OaUPkkyhqXIzNCNVHPt+PlZt0jIAT0FdbBRvXhnhZ333zjU2mFx8GJIgbgSD4nvXGZ
	926YNLiHa1tuahcPqi/WnyhoDPXI=
X-Google-Smtp-Source: AGHT+IG5OODsTRRpis5CT4TCncYMiLySZFpswVaAEd9Nxpgz+7EyIi7uVv+lu/Q8Iy7I+QK6/OvqoMocd9JvdSQvX4s=
X-Received: by 2002:a17:902:f2c9:b0:205:5410:8f54 with SMTP id
 d9443c01a7336-20554108f91mr38988105ad.11.1725293584259; Mon, 02 Sep 2024
 09:13:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902160828.1092891-1-ojeda@kernel.org>
In-Reply-To: <20240902160828.1092891-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Sep 2024 18:12:52 +0200
Message-ID: <CANiq72kV90EjHGitEVO4GQFYtQJZ_3-1rkXJnOwez7u7Ph+Z3g@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: pahole-version: improve overall checking and
 error messages
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 6:09=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> +if ! command -v "$@" >/dev/null; then
> +       echo >&2 "***"
> +       echo >&2 "*** pahole '$@' could not be found. pahole will not be =
used."
> +       echo >&2 "***"
> +       exit 1
> +fi

We may not want to print a warning in this case if this case/setup is
too common, though.

Cheers,
Miguel
