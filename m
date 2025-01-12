Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608E14A099
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736706773; cv=none; b=T4WGlUr7wJ2VY/gDy9AlAkvYM+Tg6tLA+y1W1/E0OOkoSByooabA3tRBG7M4DjO2VB2O96sWYY2VQxG2ToxHdPI5EqarDhC+f2eqGL1RqYYbVO5whpsymrla9eWG/OYwPiw1fKDMsDW981rxBJtaNg4Y9IGonYfz6yzm7s+q+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736706773; c=relaxed/simple;
	bh=yhvI24/fVs78yt1gcCwNGyYwQ0Y2pgqQMWlzSDMmOLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OZR+O0VQIMrd0CrHG8Fr/XDlKhOiQVp1y2Zy1W4xBpfHL08JCWcFt7BeM8bkH/DeU323hqsa7QBz3/njxyYCgg2hGJOypkPLxvbTo2Od6u7KXkPmq4n2rqyxw1z9P64lIfw4VG8X0ZZ4rnQnH6fJ2Ol3D3p0GZHsDxGCSZUvs4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ay1RUhxH; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ay1RUhxH"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2162699e0ccso5472095ad.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 10:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736706772; x=1737311572; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqdXteI6po77iy2QSprlVR4R07cOMcPi4KkHxst/BpI=;
        b=ay1RUhxHXpl/Me6hNn4oOBKRAEOAfqBiLBiLfg9mV//WctoxCw8L656HEcy6DHnjjU
         M34cha5XLz4ZDoTQf5XhcHxOR7P0SW/QaQmadCVe4BYQpeF8SNHo6cfkMmyG2TFFnVVs
         nbxun78dYayWXvcDqjA+Py7tIKQ9MCVf9BjYYl+wyI69VnJqmk0BRgpMLfGCA7fwWJIP
         d0udmVgxdBOUbnKKRiVkELvLX8DDhUGrETUgwmoxPmMpwJi2SqO1ZZQgmOAEbruaeGNQ
         Qp7mbYl/u2wUD1F0tPRwEttAJlvdKd+YQVA9xQ1REQN6B3KSWqsCUIbRVsK4b42KbMfP
         96KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736706772; x=1737311572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqdXteI6po77iy2QSprlVR4R07cOMcPi4KkHxst/BpI=;
        b=Cy0ElhG+h8dwd8/cvq+KKkgWHt/LypCzGkwau1K96ufqPv+mS7pnJDuP4BmVfYCVP3
         HPBXAWXV5uY3xm/2wZ6rF82fnqmtg8PYS1KuLkSvXsjsJcMbJr/5W2ydEDHFZnyKDL/i
         EqDULzFXLyyotw1bDJ4udM62b1n2tLJNhBh/g41V6DTFWHc8pJj2ne8FU3XxJxcEBvPn
         6lSwwlaiKWcAfmgozuLssUtdaV89GQl8hTSfm2uBNdfKd3y8dLescoL7dyT0+ewkY4QS
         W0R525D1D/kIskKz87/heKn1V6spA1l8pbBeLWc8ie6Bz7MwSLtW8UucMUDs2a5H+aNF
         iPKA==
X-Forwarded-Encrypted: i=1; AJvYcCWKVITufDR5WBrej96B7fGr0E9T/EagaPBHzv9bevhIleGBu+5P6KmEGF9PUp3EETArnjdv7NAv@lists.linux.dev
X-Gm-Message-State: AOJu0YybPQTclkZjnI+PrgLguvSUBRFfF+F3pgxsJ+SKi6UyBWQnTmJ3
	OUl6dS6CG3/sTXMdFF4qLTNXVHOhP0k8gw8BSIg7M++npBEY4pCcidX5gxrQRFz2Uqb7Poc9oSL
	9L6C2NV1fLHWs+xtlWiPC6on/2xM=
X-Gm-Gg: ASbGncuUrRjAKYmSPiu3XplkJ33MgKHazzG3AE0ptoX5Xswbw7RSS50YcNjir16xEIW
	H6ADr9YeUPd/b0anfYgL+6jNtk5aKNixyGFdyeA==
X-Google-Smtp-Source: AGHT+IE68VS9F2h8PG0xQDi2AIsVODYBWEuZjRHGRen0i7cGHQvgFb8+PBSL1XOvezWGmnqEQlgbvKcD96RTRggxziQ=
X-Received: by 2002:a17:903:184:b0:215:9a73:6c4f with SMTP id
 d9443c01a7336-21a83f5b625mr102738325ad.6.1736706771683; Sun, 12 Jan 2025
 10:32:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-2-ojeda@kernel.org>
 <CAK7LNATPx2wTEM=KDmGtcH8vVTB4suOhh-CUQKP54F8wtPWDiw@mail.gmail.com>
 <CANiq72mcdtNie=t=HHhZnjQa7gQiDZin+TYP_7Rgi4kL83H2BA@mail.gmail.com>
 <CAK7LNASYYYsiZUaA1StD9kWO0WBC0PBPtfY7u32g94WtOPFZgw@mail.gmail.com>
 <CANiq72mzTaKYJqNcv1qT3nXEbh_t7CwaAqxCuYNcx9eHOZf7wQ@mail.gmail.com>
 <CAK7LNAQkUik_VW7j-d56Pr4NnExxDnjMfWSwtxvijH4q4Onctg@mail.gmail.com> <878qrig5f5.fsf@kernel.org>
In-Reply-To: <878qrig5f5.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 12 Jan 2025 19:32:39 +0100
X-Gm-Features: AbW1kvbarXXNox8Aqm6y6l8o9SVEsvFhrrvSgxGIdEGR5pO0-K6aJ8d8RCBOZ0w
Message-ID: <CANiq72nNTc+XLBZxcSBD9beZ+OocEEYQcNOM_e7Be55LuJ1M4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: rust: apply `CONFIG_WERROR` to all Rust targets
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:33=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> @Miguel: Should I look into exempting host programs, or do you already
> have an idea of how to implement?

I will send a v2. I may take the chance to already apply the first
patch into `rust-next`, since that could go in already.

> Regarding host programs, it would be nice to set werror for those. How
> does C do this? Is W=3De enough?

Neither `CONFIG_WERROR` nor `W=3De` apply to C host programs.

However, you may already do:

    make ... HOSTCFLAGS=3D-Werror

And for Rust:

    make ... HOSTRUSTFLAGS=3D-Dwarnings

I could perhaps add that into the docs.

I hope that helps, and thanks for the tags!

Cheers,
Miguel
