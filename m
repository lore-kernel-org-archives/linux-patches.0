Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EA8610D
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 09:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738920907; cv=none; b=XbEzvnzjiTU99V9sUE1vefTheOqfTHCaq1/MGQSM5eEWavspNhdiKR+pXzKsoo1YaUohaf/tSX3YFIbP5pBjzKMkAFEQZHPz+J2JUl8E6xrfv2p6mlCY2zEu7j7D30gF+QR8PHr6fcyq0jwGtCaY7ufPEoBGPyptrhybmots0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738920907; c=relaxed/simple;
	bh=WpzvF9szQZoGnzPsK8JGH5qUWtlXbF0BSAjLUqm0mEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hR9gqFc+c63KT2+G84j9yDcbmwsGIUtCRonXIhZi2mrLXWliLYF27r+e6MFBROsQt9RA/SOcT6j3ShiQzo/rGTdu16fv89hvwT56BG5itBI3P0svIBAJ4q+fdGJQr+TnNxSXD5wP0DTFBLDz6WZ6vJOxtNOR+S7UqkaGetFMZ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nx9DNaNX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nx9DNaNX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4362f61757fso17990975e9.2
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 01:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738920903; x=1739525703; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2480EBnA/WUX+Abw4NwvBh7SdyU1bom5NZ1qUtPF8aE=;
        b=Nx9DNaNXOVhv8oELsiqKKwgnFBJJFy5uPQUppyXXynX9bG2ViheC/KqkXAvF5LHQZY
         nDm6Mg/tyBQrZInlOxOaVu3xxjMJdO1ER0NS+VRKoQIH/n1iC0vNd4jLJ+X2t+J+KvP9
         GKBrNls/ukz1EHsvgsi7d7cjLJki8V28+eipfinUsOO3n8g/uHAsvByqA5bkGgDwHPkH
         Rk8H94dpXK/B4/SoPLhRynNfaRVM+3nbJ8JpbbbtfNjCEEnVSjhJ3Hws9yxx9RIuZMRS
         b6c2cSY0NGzwwt46PXHGL5GZppNLv2xiIOUKIv21h1GHkXgWlfjETuGr2b7iYPTR2GgL
         JqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738920903; x=1739525703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2480EBnA/WUX+Abw4NwvBh7SdyU1bom5NZ1qUtPF8aE=;
        b=REgtrK32eWe3eQOB4NngxoXH4hFBPLmUBcxXFDerGlrZmUO/aLjIvdaXQXw9Ao31Co
         M+VFuMW8cUopMixuzE0CV/ICG0+RqYYPWtUks0VACZYwC2UPOmyHe8HlWIL9jO3B1cPX
         QJLCsjohNCnASk93wgzN7Ad9r6DAd5kdc6H5NOePeHvvE0ObsPtPY8v3n6MR8EMtXH7X
         AvhLoBKY/leYBnLxqYTFI0XU8VY2Mt6ftNs98hBN+iTWZw24CCu8FzgNV2iBT9YdYMpn
         Ioowv3Do+9ZVIs7esk3p4k/BaI3GEUllba7loEDhGpT+Q1j6uISwarlHA1NLVUrYsevg
         e0Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXM6G0GezlAs4hx/QFhURvqvYQyD5JpULJzeOmGDf9yRxcJFxbrQGJgtznhWGqBHIFPHQ7vknO0@lists.linux.dev
X-Gm-Message-State: AOJu0YwkbvJReJj8GQy5YXSTQVe2dt5259LwBtb/rqPgDeE7aaFc4LiH
	6KSACl1j+/vLBlotcKISmpjiLhBQPw1VhKjSbLFWSLAk8bw6vz7TnlPDbJtEvBMJCbb1VE22U6r
	SlpDP7tdLI8xSP/pgdq4MPBzZMgwlBX72/zQL
X-Gm-Gg: ASbGncsGoD9DGFNdGnuLOs/oZ4fVLcbycRhEu6IdvZ+veVC7QfLo9xcpJWUMTJPcLNO
	WQU+pAnITkojQDSVxAjuGfQPFdZsBKdV4r72mKAYWw8EpUDdIDzLh7SzqP/PFTGXptSgjlOmpdY
	HOrkKoTgJ6QZ5d0eLZeRY4Cp+dKu8=
X-Google-Smtp-Source: AGHT+IGhUSNu9zvLoiFSofDY0OMxcNSFAl8TddmlA05himP+cOcm5XjI5yjsyVV0T3Kj//6iMl8vsfnlp3YycnJZYfQ=
X-Received: by 2002:a05:600c:1d96:b0:431:12a8:7f1a with SMTP id
 5b1f17b1804b1-43924991035mr24650525e9.16.1738920903421; Fri, 07 Feb 2025
 01:35:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206232022.599998-1-ojeda@kernel.org>
In-Reply-To: <20250206232022.599998-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 7 Feb 2025 10:34:51 +0100
X-Gm-Features: AWEUYZmEX6j_hGQINsn4AjZPTMCvx9Pp7UkxCKUDf-6T5E1oNpjkEWdcnoNHXT4
Message-ID: <CAH5fLgiJDrNPe4hT4HrpC+bcskWtBcZdcvAfdnqpY1eTHVWk0A@mail.gmail.com>
Subject: Re: [PATCH] rust: rbtree: fix overindented list item
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Yutaro Ohno <yutaro.ono.418@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 12:20=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.86.0 (to be released 2025-04-03), Clippy will have
> a new lint, `doc_overindented_list_items` [1], which catches cases of
> overindented list items.
>
> The lint has been added by Yutaro Ohno, based on feedback from the kernel
> [2] on a patch that fixed a similar case -- commit 0c5928deada1 ("rust:
> block: fix formatting in GenDisk doc").
>
> Clippy reports a single case in the kernel, apart from the one already
> fixed in the commit above:
>
>     error: doc list item overindented
>         --> rust/kernel/rbtree.rs:1152:5
>          |
>     1152 | ///     null, it is a pointer to the root of the [`RBTree`].
>          |     ^^^^ help: try using `  ` (2 spaces)
>          |
>          =3D help: for further information visit https://rust-lang.github=
.io/rust-clippy/master/index.html#doc_overindented_list_items
>          =3D note: `-D clippy::doc-overindented-list-items` implied by `-=
D warnings`
>          =3D help: to override `-D warnings` add `#[allow(clippy::doc_ove=
rindented_list_items)]`
>
> Thus clean it up.
>
> Cc: Yutaro Ohno <yutaro.ono.418@gmail.com>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is =
pinned in older LTSs).
> Fixes: a335e9591404 ("rust: rbtree: add `RBTree::entry`")
> Link: https://github.com/rust-lang/rust-clippy/pull/13711 [1]
> Link: https://github.com/rust-lang/rust-clippy/issues/13601 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
