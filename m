Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB36F1AB528
	for <patches@lists.linux.dev>; Thu, 22 May 2025 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747907762; cv=none; b=K+g2688uwSlnHbazZVa57RXjTnaZBbWGXh2FaUF7lsMNsmoRo/u/qqKr/vTyO3FzV5lwVe8WkbglhgX8scWIFaM6EGo5qy2iByAZBu27jLMNLXChy8nV3HdKL0XsAC5TiEsKGYVAj1y0pqOetB7RVH5VuNY9PxNXv2tRSxY2vv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747907762; c=relaxed/simple;
	bh=zZQDvy6Qo42/2W4QwFrXPUZcYGV2s/FRajduLAvDQCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+Lfgf7f+44C4TVVhp4Xw/vWDZdcDqaZht+lUnUSxf0IEDHBup5gh3sA7xFzuCufKkrkvr2fp1v/kMDMoWTyuYRrLa9FckJuGzgdfB+SekWcTmPgcg3tLcnHlVfa0IxiL8lbiw4D54nB2u3NrBydgY/hXqSVFQY3eSRGtnSUji0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9xQt4fV; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9xQt4fV"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-231c38c9d9eso6208405ad.3
        for <patches@lists.linux.dev>; Thu, 22 May 2025 02:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747907760; x=1748512560; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G09KB2onuKyHVmfE50lXFfjm4aLc9EdRitHUC4rY5fE=;
        b=h9xQt4fV0EdGHstL6oHy3L7TQuR9Det5Evw+hKA0It9QPV7f1Yp29W2y2Cc18IXRFR
         HyC1jMgHCIseGOqWubFjEpxb85nvNNmjMgbIfoO2OnBxLM2Xp2qLzH7dW/TiYk5Np1l4
         1lBba/Sh3pP56qoXyVqy5/Kk5JMKqBU9JEt0PYezcKphlUD/IdXTzE45BBhsysVPMLsR
         bvjFwwyY8aAb5rsBrI4l2nO+v2gC4PxXpc51jvL5ubsB//xNVOKv7A679sSFSQAg5w7F
         blOuAl2pfFIGV574k3SyjkxZ0DU4DxdXgRVHh/O4/ZfOJ7y5+3rujxSfpU9oTz02KZXY
         xrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747907760; x=1748512560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G09KB2onuKyHVmfE50lXFfjm4aLc9EdRitHUC4rY5fE=;
        b=olu8g0bclmco1OHRk3oGW1w6TTSgGrkbjoZ0+zAZLfGsj8jwjVahGXSs5rnxUzR/Iu
         fNA9pFsP356gLBiFsOFzaAZWsWv8UopYkMOG9ZW/QkK+1CH0qApS/4UrqJqfAD1UUv7o
         vicZyBWaSKHeg1Toiodpfp946UymWweDp0l5MpLnyCTV05FHXGkGq3Yq+CwYTOhmD3UI
         jc5HJaaGOO4UiAGH+gZz45F4DSsjqonxpmYMcIubtp737+4O8P8EGwZaNPoKMgQqAJbl
         Dh0QsbGhI4ULOkYfHGRHRtkZGMnqmi/GQcHQtv5PtgKu87hX8CgC7qLPBb4jkcLfgNxg
         Hndg==
X-Forwarded-Encrypted: i=1; AJvYcCWTWJB8T0XShlqcynfiwlMeeaKEbfdx0D04Ao5l2Yrnd/ToEhQXJeio4ySUlIG/2jlpKnU4S5QG@lists.linux.dev
X-Gm-Message-State: AOJu0YzircMHxsteVt7QCD1su3BKxpcDEghmn6ZiNLL2ptVg3KxJmRDX
	XuWLrtMYaErXjZTasmabRu+hHQMuDrws8EN4u/MN8rOwNBIGnqUPQhc/GSVuqhwd8yuF6dWxhzl
	DTkvrRYFw0f/VYgio1qQyu8b1mhpugdg=
X-Gm-Gg: ASbGncu+uDi/J8ZrKN9rbw56EFeqPqtrsbbC6/6fkww7sgfiZcTh6Mhi9SIKBfPtxqD
	VtSeT9ssYoYpywiYYTwKc+MV2stYDRd6NNxSG0U/pNTVx2zw5xCL9ipEBPOrH+wyJ31l7agzpi1
	DavMe9neP5iauJj87k66DgSafLQ05Gnl2p
X-Google-Smtp-Source: AGHT+IFYIWC+n60Jh+NK0oH7ocg0CH8rKVpjvpng/mDoRMQvt9OfeYljH/Z2woY7cuOpizBcWnXFwX5FdQwCp7RVY2c=
X-Received: by 2002:a17:902:fc48:b0:224:88c:9255 with SMTP id
 d9443c01a7336-231d438c7f1mr136853785ad.3.1747907759865; Thu, 22 May 2025
 02:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520185555.825242-1-ojeda@kernel.org>
In-Reply-To: <20250520185555.825242-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 22 May 2025 11:55:46 +0200
X-Gm-Features: AX0GCFt5zXlczwrJWYedrmHdatCH6TtH7LDmwwL7WwbulsfmTEouK13Fcs43C90
Message-ID: <CANiq72mPJDA55t=TGz3wFBBch9iPxjQ0V_CV30XR6XijWnh3dw@mail.gmail.com>
Subject: Re: [PATCH] objtool/rust: relax slice condition to cover more
 `noreturn` Rust functions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	John Hubbard <jhubbard@nvidia.com>, Timur Tabi <ttabi@nvidia.com>, Kane York <kanepyork@gmail.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 8:56=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Developers are indeed hitting other of the `noreturn` slice symbols in
> Nova [1], thus relax the last check in the list so that we catch all of
> them, i.e.
>
>     *_4core5slice5index22slice_index_order_fail
>     *_4core5slice5index24slice_end_index_len_fail
>     *_4core5slice5index26slice_start_index_len_fail
>     *_4core5slice5index29slice_end_index_overflow_fail
>     *_4core5slice5index31slice_start_index_overflow_fail
>
> These all exist since at least Rust 1.78.0, thus backport it too.
>
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Timur Tabi <ttabi@nvidia.com>
> Cc: Kane York <kanepyork@gmail.com>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Joel Fernandes <joelagnelf@nvidia.com>
> Link: https://lore.kernel.org/rust-for-linux/20250513180757.GA1295002@joe=
lnvbox/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` early so that others can benefit on -next --
thanks everyone!

    Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")

Cheers,
Miguel
