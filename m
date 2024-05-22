Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253908289A
	for <patches@lists.linux.dev>; Wed, 22 May 2024 10:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716375145; cv=none; b=JMpOGd5TtIIUBgmatZk0K+dN5GCfJa+IoQj1uHWjZQ0YE45Lr5D8ztZyeh/N/oZIzvsuH7faAhljIDVUq2uRY8iXAohDnxVXTf843h7UybVjmHPh3nAEj7MaH80rtIBqY9BstSFsg2f3coioRZ06RpB9hL6VvLbSS49gc+/DidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716375145; c=relaxed/simple;
	bh=0Y93dPhHvn01+Vtk2BQihtxVDdioBUNBOZ0XK/IR2XE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LDTFIyMe/KAaa6XDLsnAbC3XQGj5iOavBJe3kFdl/59bWt95+b+lPzI0UH2AmimaZUw7qOAItlhHGkTm7AxmL+eVWY7uwW1rF/7Te6rgAgcy5ToStSrbKDXFtiPFHBcZ2JEkAlrWZPSdlPWAJ5UsDhIXDmV4+oMCQ8rMaGOQ5f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ldLh3NFJ; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldLh3NFJ"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-24544cfbc69so2232877fac.3
        for <patches@lists.linux.dev>; Wed, 22 May 2024 03:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716375143; x=1716979943; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Y93dPhHvn01+Vtk2BQihtxVDdioBUNBOZ0XK/IR2XE=;
        b=ldLh3NFJ01whAJ2eG5QaB4BbJoe3rACwb9zwL1xEJmFX4d8OdlHZs70TO5nk4wE15y
         AOaP9R4Eq88HSitgN+gM/5SMOUnzTZrB9x/hJRx5I0A1zOJP/CGgiHDaM+H/vDkMwrPD
         lJLgsUJl3kbHVVWMHaQ7Zmqj6d0tnX/I/m23fOcoDZCO2vMInVTDnPk9Nr2xAbTQVcwn
         1fxMzDryWheO6bpgvrqLtrAxP3t86tuq8Y6zNmSb34PdDs0htuotyF7RM43UUSFsse80
         UNFoNef5mis/u4/akMO4GLy/yW2rjcnjsPUyMBJ1YCsLhLGt+VcRnLR7fJ5lqlm04xre
         Jb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716375143; x=1716979943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Y93dPhHvn01+Vtk2BQihtxVDdioBUNBOZ0XK/IR2XE=;
        b=A5yw1XHudWjEmOGoh5nacvAEUIi0DHcLTeMqujwsUPZqitdg2Qim6TXSeq6OkVs7rJ
         fEUccxejdJ62IhFYykLjT05wsqVICXSyJ0tgax4nncqXOBAr/DGD7nJNk4qekJQB88Zn
         UAQfrc9KqQGS65HyBWOy17/dbBdZLULzCg62T0heIdy98c/8ZGeQGkbVs0+nJi6b1kni
         9Qhjf2b6bqSCekj+2xphk98qsA6Jo0HQt6lJGVC4/hCp7lhQVpHvBjBrsqjeuvEZ24wS
         HAF0cz1m/IytHL1RNsr7it5jKPXCsHM7CH0iTOZjuegGnMOW4Tb3QXP8cVBQNTeGj515
         aJvA==
X-Forwarded-Encrypted: i=1; AJvYcCUeenp4juPbLU9L1cnf64M1vGzujl993+2tigzBZw2KkrYwY1nKqQc+dWo8C6roN/e3yMheu9dxvD6rvPbvs1QP61e+GJEHDQ==
X-Gm-Message-State: AOJu0Yym329E47XjzYgdYb7fCiciaHk6uCkjvgzYtpQXaXE2ky9kWtE3
	4DrEO/qcPRt2c1zgy681/l6Wp1jWOFoXpEvdKoJ+rmXkVEUbIVWvffobwpt482wmxWhgRFAbh0x
	mpgVLsjEAmT7Wro/bhKA5V8fc/lo=
X-Google-Smtp-Source: AGHT+IG/AS4kJMzfIgzw3AMuTS/nlyyPXYuhXOPvLaLt3mE1VVgwbiK0gwIGfRoZ7lTb+QeX9+yvLRcXGPalXpvNf7Y=
X-Received: by 2002:a05:6870:e253:b0:24c:5018:e6a5 with SMTP id
 586e51a60fabf-24c68aebcb5mr1986514fac.5.1716375143007; Wed, 22 May 2024
 03:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-2-ojeda@kernel.org>
 <CAK7LNATPx2wTEM=KDmGtcH8vVTB4suOhh-CUQKP54F8wtPWDiw@mail.gmail.com>
 <CANiq72mcdtNie=t=HHhZnjQa7gQiDZin+TYP_7Rgi4kL83H2BA@mail.gmail.com> <CAK7LNASYYYsiZUaA1StD9kWO0WBC0PBPtfY7u32g94WtOPFZgw@mail.gmail.com>
In-Reply-To: <CAK7LNASYYYsiZUaA1StD9kWO0WBC0PBPtfY7u32g94WtOPFZgw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 22 May 2024 12:52:09 +0200
Message-ID: <CANiq72mzTaKYJqNcv1qT3nXEbh_t7CwaAqxCuYNcx9eHOZf7wQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: rust: apply `CONFIG_WERROR` to all Rust targets
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 12:14=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.=
org> wrote:
>
> What does "everything else" mean exactly?

Everything but the host programs. Or as many targets as possible, if
you think there are other cases that we should avoid.

> Why is the .config required for generating documentation?

`rustdoc` sees the code in a similar way as the compiler (it uses
parts of the compiler); in particular, it processes conditional
compilation like the compiler. So we need a given configuration to
generate it.

Cheers,
Miguel
