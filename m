Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D794386
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 08:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SiNPyvX7"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7b0767462adso709218241.1
        for <patches@lists.linux.dev>; Fri, 06 Oct 2023 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696582323; x=1697187123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n24qAGfzmg1PVf0PveNVGT5psT/dnx8oFWzr/qUCoo0=;
        b=SiNPyvX7rXRUstvAMG1S8NE2tJCZkASl7qEY8DYXfXkB83biayCvAjWAus7m6Eb1Pg
         OPijpwB1COC8WBiCJR/utE8Bdcw9zhbCtKqQmu0mCVu+TpeXy6iZPqNDVKiHw4tMkwFd
         29K3vHHI1XKCoK6kF5XQayWAsGGoJGmaVsXwHfZO+jaSqRvvAGKPjvZxXbDn60NJaOPH
         pDu/SSGK1KicRKvPex2z4bru/3lVDnN43hOJGSQqcnOg5HFFDhBqElYjL+8rIUFGz/M3
         qTLqtWXIGc15Z3VtXiq/V5i/EkjdwTUR4JUIlTtWpfGfnEb17JZuT4XGPGTT89Rihx4d
         RdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696582323; x=1697187123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n24qAGfzmg1PVf0PveNVGT5psT/dnx8oFWzr/qUCoo0=;
        b=jrqgTcndf2xerAjUXhYtN3ahAVT1dub5Vurq2tS933FPPjyb5a0dhJ4iJptELFcsW3
         Ei7FKwM7cs5lDXJMHPssTL8VR8ZyQdZOABqyIaShfdqjT0ZBoeLhqEBXBdyVybuOkEuU
         +CbeR/pBn1oxOHTE4JJRRDXprqPOISJ408Q1DeznYj4S6g0VLb9EANEXVI1rvNsLDAxc
         WoG9obneTRkQnPA5afn5aizOlTS+nLdLGWeYszBGkBuu1SXmIwazKmeWbxnP88JE9JG5
         oIv9umzNifBvw3tVBLzi+Ah2ebY9qXFwi1TYnzbDqhR0JxdtevMSPW2CpwDw1Qki8NAw
         vXhg==
X-Gm-Message-State: AOJu0YxYUP3iKLmv6FsM0iOPjMFWZrodHUKUjwYTt4aneyCVCxRtFG5K
	MH0r5N9evIsXGNmhFRVJSI+8DlHA/okFOQnk1Xd0gg==
X-Google-Smtp-Source: AGHT+IHoD96RiVv8AYlQXO88pCDv26uNXotOZHGP73JCbfONRD7tBm4QR3mhTQvUJNddUUYkJSHTZdeEBZU0VFhJJfk=
X-Received: by 2002:a67:de97:0:b0:44e:849d:d2d3 with SMTP id
 r23-20020a67de97000000b0044e849dd2d3mr6989714vsk.16.1696582322929; Fri, 06
 Oct 2023 01:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231005210556.466856-1-ojeda@kernel.org> <20231005210556.466856-2-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 6 Oct 2023 10:51:51 +0200
Message-ID: <CAH5fLgj1uesdNxbbYu986sBLGRsWh3d+NCrE__haFm44kSJ+zQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: task: remove redundant explicit link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 11:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
> Starting with Rust 1.73.0, `rustdoc` detects redundant explicit
> links with its new lint `redundant_explicit_links` [1]:
>
>     error: redundant explicit link target
>       --> rust/kernel/task.rs:85:21
>        |
>     85 |     /// [`current`](crate::current) macro because it is safe.
>        |          ---------  ^^^^^^^^^^^^^^ explicit target is redundant
>        |          |
>        |          because label contains path that resolves to same desti=
nation
>        |
>        =3D note: when a link's destination is not specified,
>                the label is used to resolve intra-doc links
>        =3D note: `-D rustdoc::redundant-explicit-links` implied by `-D wa=
rnings`
>     help: remove explicit link target
>        |
>     85 |     /// [`current`] macro because it is safe.
>
> In order to avoid the warning in the compiler upgrade commit,
> make it an intra-doc link as the tool suggests.
>
> Link: https://github.com/rust-lang/rust/pull/113167 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
