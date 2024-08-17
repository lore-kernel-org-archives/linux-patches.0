Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300DB14F12F
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723901313; cv=none; b=oZbeSFvp1qe4+A9oV4EV3ky8f5AZL3hZ7VJTBuATDi9S506ZpOr03kQasU0EUcH7n7zfsYh1+ltkgErPahlFDcDDydwMHnhhZHP1RY7Y2WLGIqw4jvMIKje9kDQWds0tAak8eSuNGkZybYQd9zB60RMAHpe4WhU0NF6CmNiQGQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723901313; c=relaxed/simple;
	bh=bG7amRFd1SeXww/sW3fHII8B50Zcx0B+0CeTFObVS5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CxzqggWvxoZa4Bas48ixeZy2zwZ43Oj9YqvD0J1AR4Um8dVdKbmLP24uaDBmXsc8f+0csJVy+jgOJ2Mfy6qbG8ZW5WvsXlsUs3/ctCRREbjZ7U2Z3V/hrDEfCcpYA2KPPEDIAA3MZM7du9kXqwrFYtfZX7FB/d9N3QeYGi2MQ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T65b1/Xe; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T65b1/Xe"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7a103ac7be3so2034763a12.3
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723901309; x=1724506109; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w46CrKlXMkRvz2M8MkwLOk4U12EJHFtMw4PTZouv2zI=;
        b=T65b1/XeJ1fSfoPJFhwhIpsGWk9SHwz83W37Y07gU0Alrk3gFN0QFOyzGBtc37vGjI
         ApCBhBNor7dD3DpKTsTnYT5BGm1yWRTUVahaWpj7vzM0V1ezErTkzGgAKfVRu0fCUAP2
         7hPmImkaQA5UE2ICflkfHNfEqen4/6WvfYDiirg4wVkZBJduIWxQqI6TIc+u4j9LtNWY
         Oozrg4QjoUS70073p+oMh6uR3H5fmAWVF9J1m8/dUz2h/T0ilXF3doVBNbUAlP4VLpqP
         2USHUnLs9qHS06QWNBI/VjjtTw/ajHsgcWICR1gf52sNWDqKoQAtSScCXdHEUQQJib0R
         HxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723901309; x=1724506109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w46CrKlXMkRvz2M8MkwLOk4U12EJHFtMw4PTZouv2zI=;
        b=KxuGunOdwyvXcIqR7CQRS/Ke9dJwEfkg/3WQwJJs9PlblP9BoQzGA02OLBkyK2IExx
         HZFfaJEAb3/S9xLArVIZ/u2t8RaNpGpHKBh+SZHBQt46oO6Q8cYO9Cg6Z+bvqaQGD1tt
         jFIGH+PhKkhF9pQySdrqJBsyRW/qd7jDhguWrmbjSTJxA/JYT9o/Uc9PekI9Tpxea4b5
         YmogkUiRQ92nOIAkQbpF5W8eCmgZ72ro/vKJWbkMESSH2JfpqHNvNVWrMXu4l7iH3seE
         ug4VJXzEfLAt0xaSrP6yuY4cRqbuKt9MaPmUOITjunhgqZ75g7Ykoo1pHfsPpjl1ohWZ
         r/AA==
X-Forwarded-Encrypted: i=1; AJvYcCWHKVOOvbRK/Ao8/Xf0lbmhQmzLzi9G3dN8P+5x587jWQuq97rEu22s/aVGXxbA9CJcUeZ3iQUj4Mz4onhslhdwpG6yNJME5Q==
X-Gm-Message-State: AOJu0YwS8u1TFgHRniaxgC4Ve5huFmVLIQy7bugeMVlqhVtF8P6bNw4U
	JE3TFEIG3qV0+kM1x2laQ72aanBAjsznG63ZzBjc9WO1T3+zJ3nJ2C7Ea2YXi0nE8vrd2a2vAyY
	x0eiPvA+Klr7TmFfZg6PcosLgHyI=
X-Google-Smtp-Source: AGHT+IGkwUrq5cvtbg90rMni5kEuQpodzfRuOoYIc/r9GruV5MgAJHDJJ62APn+dxgexiydViJ0S2Xi0JWt3Vguy0T0=
X-Received: by 2002:a17:90a:ad93:b0:2c9:b72:7a1f with SMTP id
 98e67ed59e1d1-2d3e00f324cmr5497946a91.28.1723901309226; Sat, 17 Aug 2024
 06:28:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-4-ojeda@kernel.org>
 <20240817-heavy-dancing-whale-6ae13d@lindesnes>
In-Reply-To: <20240817-heavy-dancing-whale-6ae13d@lindesnes>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 17 Aug 2024 15:28:16 +0200
Message-ID: <CANiq72n60=dKdsu0X3CWLaCkEhnAHMuwRZZpwhiJMGkt0aGyUw@mail.gmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust: re-run Kconfig if the version text changes
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 2:58=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> If you send a v2, mind you consider reformatting so that this comment
> block stays <=3D 80 chars?

Sure.

> Do we already support rust in external kernel modules?  In top-level

If you mean out-of-tree modules, then yeah, they should generally work
(at least I test the build with a trivial one regularly, but perhaps
it is missing something), although they are not the highest priority.

> Makefile's oot-kmod 'prepare' target we check that the compiler
> (version) is the same as when the kernel itself was built.  If rust
> modules are supported, adding a similar check might be helpful.

That is a good point, I will take a look.

> Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>

Thanks!

Cheers,
Miguel
