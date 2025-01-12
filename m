Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600182CAB
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736712826; cv=none; b=clL3snUY1E5jg5KzP8kQ+OHDVJPVCMLLUztHhiXzm8PCNzbeU8nkgx8nT6lzT/qI3RFUdPICscfz1ow1MakS22gOHSK7G1z/gSsc+zcnyKGsWQauh4UXlowdXmDQS0k6qYCpCy6zMED3NIiG33PqV7MuQXAm2xehHwAAv6vNJmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736712826; c=relaxed/simple;
	bh=Muf3z0isG+soYtWVUitdFt2H1GC2kKpxxukt7MKvCfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYbGgdntZTW2K6q8yZuT90Qlek2dD4ZLEG2fz+us7tf5YP5HeHgBuNVAzc0Z0/HKwwovA9DwyAC9FAj3UR/a/ClIOzmvqQb0bhUCAHLNVnBW8fyFEOJ31A1nCndA1JWbvyAws8Ou9AErOBU5bHIzAoPei0+oPHeJX82j+kXpHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d96944401dso6038433a12.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 12:13:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736712822; x=1737317622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qj4Z2SDQvq3fGmtNpPU2AScGVxBCS61Rjutm/KzPYAU=;
        b=onpNplZj1LL13kjyyzweirY9VNeXFD2gGyPsieUM5T9Q2MNO6UZBlvLEH7qsEC/noW
         LnGWWW86NQ/U5b7tSzoptqmEWodS4Nj6jCenG+P/lbrF94p/hyRQZLTd7herq/3RzoeI
         o8Rtq4w5ZQDwmbDSkyDXmgF9elMZsNaWvsAc4hvRBpNU2Y+kyeFl0rl8iTdN/Fsn0h1X
         dLQOU05/0fHiRcT527k9BBu0xzqDn6oE3OlZySIs99ey3P6aQt2hpuDL4R2T32z3oJ9W
         spbwA/mmxQwXw+oGCE8QJrgc2RW1n4sIVm5tm2o53s2HZUZlpEvNv2eX7llzSeSRojzU
         ikgg==
X-Forwarded-Encrypted: i=1; AJvYcCXSt01l6p6tt+cI8zJMhCx6q6WE5cocsJKnAkgR0ahZQfPwJVfKpTLzNKwVi19LR+qLEOg3kCvX@lists.linux.dev
X-Gm-Message-State: AOJu0YxrBxyacHXfFdgRGWk3kSaivGGGExWGn5zod9QCSZVoRrQCB8cG
	hos086M815BLKddVCFfAhl72ZjAr+5zM4Jht1/SalZt+C6gEg/rzbJswtIuTc6g=
X-Gm-Gg: ASbGncsvoVfrRV2QhtmNFoNi/FV+5EQFkZ7QheXDmn5Ph7fcBE/LYDzm/gYceSg0wSr
	A9EigkLQm2Bc+ahaWjSGcbJsB7L+w9tWaZ9Jh7wXkSic5MIcre/E1IRDMAAI4Z9G/e1zX16srlR
	m0zWZWm17AxIoziT2/BmttJXQL2q6rUkuukj88jzjPBs91kqpXsw/Exi/wdhF8eyOakw01A8yIn
	XoAbipiSNzceYMYLQ0bWsE9Bq0lF7S/ikY7TRu4+DmDhrVfwhVCi10hsLu7yY5wIMaTanaPqGH/
	dwhSJ52TCsI=
X-Google-Smtp-Source: AGHT+IEaFWx7vmMu+mHePehu3q4YUH43N6nvC13Q2M7W4+zcM9HradL5HZCXCqUsPxZkMUk2gTIPSw==
X-Received: by 2002:a17:907:9711:b0:aa6:1e9a:e45a with SMTP id a640c23a62f3a-ab2abdc368emr1533518066b.46.1736712822228;
        Sun, 12 Jan 2025 12:13:42 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9562551sm411249266b.123.2025.01.12.12.13.41
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 12:13:41 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d0ac27b412so4751659a12.1
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 12:13:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2V6JYs9jZz5on09xiWm5x74YeyrlpJrrZFFBUIIbcWASfhlp0/eC8IGfNrMxMkAtUl1WS3bod@lists.linux.dev
X-Received: by 2002:a17:907:1c8c:b0:aa6:7cf3:c6ef with SMTP id
 a640c23a62f3a-ab2ab70a362mr1619489366b.15.1736712821014; Sun, 12 Jan 2025
 12:13:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
 <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com>
 <CAEg-Je9Cs54SkvhzbSq=2v2QYMo=mwUuGqFcs6cvi7nFgw6+Ug@mail.gmail.com> <878qrfdcro.fsf@trenco.lwn.net>
In-Reply-To: <878qrfdcro.fsf@trenco.lwn.net>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jan 2025 15:13:04 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-phx0EmhAYsJnmxZ-NKVhER6ddMZgXTbCVaqC+2jGSAQ@mail.gmail.com>
X-Gm-Features: AbW1kvY7CPJkAZ34-1s7jKPL5Kwhqxb661Axv4EULjtx6fvBdg8Uy7E2dA07D48
Message-ID: <CAEg-Je-phx0EmhAYsJnmxZ-NKVhER6ddMZgXTbCVaqC+2jGSAQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Jonathan Corbet <corbet@lwn.net>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 2:59=E2=80=AFPM Jonathan Corbet <corbet@lwn.net> wr=
ote:
>
> Neal Gompa <neal@gompa.dev> writes:
>
> > I've had my Reviewed-by tags silently ignored or deliberately stripped
> > because even though I've done a technical review, the maintainer does
> > not believe that I did. Therefore, what I am saying is that
> > maintainers seem to speciously decide whether an Acked-by or
> > Reviewed-by tag is appropriate or not *after* someone has sent it.
> >
> > This is the fundamental problem I have right now. This decision is not
> > the maintainer's to make, it is the submitter's.
>
> There *are* people who seem to make a game of getting as many such tags
> into the repository as possible.  I think a bit of maintainer discretion
> is important here; I don't believe that there is a fundamental right to
> inject a tag into somebody else's patch...?
>

I think there's a difference between not being collected in review
cycles and being stripped on application/merge to the Git repo. The
latter is something I've experienced before.




--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
