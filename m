Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E902221B9CE
	for <patches@lists.linux.dev>; Tue,  5 Aug 2025 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754383374; cv=none; b=HwcwuG7H5Au67eIYVrOa3WbSegzoWErLDqxKNiU3VWvMxMuBLU9ZqWsES2F+mZQ5YOG0JCvW/PHHuPlmkllZMT4K+ItYzYvEhw4kkhUQTjImaYHYk0a2+MmNSxfAdcg4yO+mIUswzvQSa3xN4vPfEtEy87NMFS+QHyBaosinu+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754383374; c=relaxed/simple;
	bh=LVuuvIOXyaDckGRowOdAF0iCB3B9x3e7m6JtLCAG7og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKMjsl669ND2yE+m4jzx+U+FDJufJFxwJUKu4SNCWL2IVYYOCuxhV+jy0HacYewoI0s/QdeG92prBP5zOZgn9+vWKF56PKpXRpdVRpoOOVtjUuF2MUUrwCla+Kc20i8PReFmOqzySbpJ9SlEWhYKXHkirYnHTAQJoiMQXlvi9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FN2TDOGX; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FN2TDOGX"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b7834f2e72so3321767f8f.2
        for <patches@lists.linux.dev>; Tue, 05 Aug 2025 01:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754383371; x=1754988171; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EC3P05sIQH2f4RvTxjQQwotKae6prFyn6jtQODb9ESI=;
        b=FN2TDOGXA3PHaot93bG+GF+4/HGAQtkBbF9ziAEC0WHGTr5C7GPNKFsKpEQxZNsIC3
         RXLsBLyXttUin1uc149xojmExoGv9zNHLLngXNGV59ZJvqAyEoo8qWQPa91r4t2d5zC5
         hkznD17Pi0dp/ygNK8uNjKA4C3vmosv8GszskRwsJoXrIlYdUvbUSyRK0sx017gflka8
         /M9i+zOzc6Kt3dkvFr5Wxt/IKgZi/Ct5KIqyjsqBK6hC/LjaUn7/G4euYBsszlTq31Uu
         j8Ywn0krE/2/VQIQVZQECPMJHPGH77B9UR8yiI7NLNw9k3YnsaZ9Qf3ICjvrIgUyO0DX
         0yPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383371; x=1754988171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EC3P05sIQH2f4RvTxjQQwotKae6prFyn6jtQODb9ESI=;
        b=qIgo04sJYR/OJzzG4ZiF+RckIJW24WDIlrYM7+AGpb1d35jg7w3bLX7LaoW3vUM2i/
         JfX5Mf/05ZjDkmpbqz8WzwyJClYbUVyV9irhPciZ9jWYR8eXzsi+uo5YF64tBchlFCIo
         pbNqCX6GqUKAjkCsm+iDTtoZLQyZQpsiRTJcKFYeKseEe0X61Khd+OUVcGsIcIrU8DNo
         sdNJDMObM8WR4jfWjN1eZIzNgGI6BIPCrpQ3RtTQA52HAfGhrnUXrDQZ3pV2lAF45KVa
         x93N62h97v3t+3WuYaTt7aDnl1EDezsYVhjHdB4NAGS2XDdYDPRB9FXBJ8h/NnI17lvX
         xIDg==
X-Forwarded-Encrypted: i=1; AJvYcCU/74DYUb0V1JT/KQzwLA/u0iShhllMIFYBXP47UphOxs/YJTlQBSELX8BrSq7MAKJWrip/lN9n@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/omk3dETnSYpDx/UVVd4+hYj5IFoSErQfUAjHv/cU+bLeUWeY
	NSCqeAjBIIDgiQ62dNBWuvRn2m0XGTROfwQCpAbLwW4hsvsd7dWCjgX+KOMnIJNE1EgISAAqt7d
	MdRs/54dJKOEfKlBDFE3vR7mlv3ti1oIOvtXTlb2w
X-Gm-Gg: ASbGnctOR9W3pVcIhPq3meR1JLVAM7WW7115vQNX3+eHMkAZVO2mky0uA4FaxzG4sad
	TgZwcf07o32mKD1bZnUtAsczt4pCJxnzIL1+6oyBw/WJ5XJE033D+Iqw80svOY9o3jrUKzJT54h
	8nMV04VpWaUJCsFMa7PhRRlqfOuFu+11gMvZBYMdYFpZCnXJLi5FqGa4VRFqothQ0JLeM3D+wFH
	UCPrLW+s1Y4iJ20rvHrUut0ZlYcFVCgV52cHL8xdOTBUKo2
X-Google-Smtp-Source: AGHT+IGtAV56xPSuv3qJG0TJb6qDD4qvA7fD8oX2CreP4OCwWwwKK5eD+igWG1oRFqoLugM9orOt5fMF8aMdW05tgpQ=
X-Received: by 2002:a05:6000:2289:b0:3a5:52b2:fa65 with SMTP id
 ffacd0b85a97d-3b8d946a541mr9866566f8f.5.1754383371062; Tue, 05 Aug 2025
 01:42:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250804171311.1186538-1-ojeda@kernel.org>
In-Reply-To: <20250804171311.1186538-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 5 Aug 2025 10:42:38 +0200
X-Gm-Features: Ac12FXx19FT9ynQWIxH_U--Fjwzz6tXLnl6QKMiOty5H-9vNPyzv9MLJrTEPKps
Message-ID: <CAH5fLgiERU2Q0+BAR2P5vb-mTeNe=wbS-b_38bjhc+WOD+bXyw@mail.gmail.com>
Subject: Re: [PATCH] rust: faux: fix C header link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 4, 2025 at 7:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Starting with Rust 1.91.0 (expected 2025-10-30), `rustdoc` has improved
> some false negatives around intra-doc links [1], and it found a broken
> intra-doc link we currently have:
>
>     error: unresolved link to `include/linux/device/faux.h`
>      --> rust/kernel/faux.rs:7:17
>       |
>     7 | //! C header: [`include/linux/device/faux.h`]
>       |                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ no item named `includ=
e/linux/device/faux.h` in scope
>       |
>       =3D help: to escape `[` and `]` characters, add '\' before them lik=
e `\[` or `\]`
>       =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D warni=
ngs`
>       =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_in=
tra_doc_links)]`
>
> Our `srctree/` C header links are not intra-doc links, thus they need
> the link destination.
>
> Thus fix it.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/rust-lang/rust/pull/132748 [1]
> Fixes: 78418f300d39 ("rust/kernel: Add faux device bindings")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
