Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F147F4D
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 21:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484599; cv=none; b=IUaKkk3Nq+9XJCh3VskoaGpMnYWtEE4mBYQGHVqnsZCPWAqsnkn/KOqXt6+5koDlYYLBquxiWikjiBgB/VZCMziFFnKoRh2DtJg64ckz8PfOqLza2iY/0cT45lHLGkv19k55zXbLb2CwaAJ8TXHlNHHDfZAGnuUb+IGw/VveALU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484599; c=relaxed/simple;
	bh=z/1GcMiLGE2rHSFEqhZvLGeKhghzMwgRmPxqcTBrj1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gzIBsEpZNoJxQPmkq32FkU/elwDvXRhNHMBJQAmxZCqD56FELPEUeDersWxyHJAES1WnioHpzDyNVi9VrLx3pgTTxymyrowHxKqvOQyP71wbhpu/T7KwAMz8kiS9o92vTLnnxal6U7CCPM9IaEYof8emq4xsTUynU6buDC6ZqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2VwCfll; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2VwCfll"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7143c9e68a3so4095b3a.0
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 14:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725484597; x=1726089397; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/1GcMiLGE2rHSFEqhZvLGeKhghzMwgRmPxqcTBrj1g=;
        b=L2VwCfllbFWZJPXwKjsmtvEn9cgtccsz3aKnWUl71/dHigxQCXmVbPzOaet/cVF515
         3RmiQkMH236EkDxim3r2zSzQNjWd5Gzli1zZFYUaf9eJUjmP3vAGhDvLAuSWzvA/uOPv
         NrPzXN2rBww3gnuQZbdjfvRCJfipdbyImZXUG8oY/itmsMGAQ/Bc/6TgKsL0XNNgOYRf
         oHh4BWRpPaYIBWZnPq3x5W3JTaK7+4KBOsJ/RDxDlpPKOjCkUU8RUywkMwtAC4JHNjkL
         VI7zaXLqLMwh/yEEBRw92+jqsYDm7IFQOnXH/LX9oVh4q7yDoa4CCGRfpCCgSyPoH60f
         kJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725484597; x=1726089397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/1GcMiLGE2rHSFEqhZvLGeKhghzMwgRmPxqcTBrj1g=;
        b=c4viSQt2pYKcUDAg0Dmp6AJsicpqtZSwOfwEST3fCG6Cpn4/NAsRSVPfRf5Y+dZ0NK
         g6XspnHuyVyiqaTi7zcWU69QzPzmL34pxC50inrV3UtdvXeykqMtitVxbKCw+RM+tneS
         5fUSeIegJqrCPsCeVysbB62uRTNdC9CxeKE7Yi+1qr4EluXjJTzQVvemt+/CUGheG3IW
         7pIWx3zGL/M9B9AbVg6oiQkQzLw5QkN2XXmLuaGANryx5dB6Pq+EapuHLCq5n70rwT1C
         YBZ8XQ1WObWCY9SWaigbuSSWJakeXlFG/0mTsbN1u/taSnpkrIuJ2xrGy/YhhUwvlsgu
         vvew==
X-Forwarded-Encrypted: i=1; AJvYcCWXkpXxCgwpX4lK4lS5VkDBFPUjgZG9NIru0mVIZAWuNhPsNJmQ7sCIdjeiCbhY+9giWMSlsseC@lists.linux.dev
X-Gm-Message-State: AOJu0YxpMk00u8SiqdJkvG5E92f3tzy/dL1Tvtk+1Gt5tu0r9rdw5VFq
	0u2BgV8MLhkVBVS2PzrFXBOjV8rQMVWwmabO0u7Mi2p2fb1zC9SVI3QgAChqt+zwlztSYENpY+R
	aF3Sk7PTP4v3YanITosxXlehcxJk=
X-Google-Smtp-Source: AGHT+IECOjX6+cc3J5pmZJ7COQWLiR4DxSa2AEtFoWMmYTEsU/aqmrfc/2G96Po35zcWza7gSUJgGY59zigAkoOgxo8=
X-Received: by 2002:a05:6a21:328d:b0:1c3:b106:d293 with SMTP id
 adf61e73a8af0-1ccee3cc4femr12176334637.3.1725484597426; Wed, 04 Sep 2024
 14:16:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904144229.18592-1-ojeda@kernel.org>
In-Reply-To: <20240904144229.18592-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 23:16:24 +0200
Message-ID: <CANiq72k3Fs6Cj7mnhQaNdS4bAWjsvg_=0+EcH_hUhX97BMwUjw@mail.gmail.com>
Subject: Re: [PATCH] rust: avoid `box_uninit_write` feature
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Matt Gilbride <mattgilbride@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Like commit 0903b9e2a46c ("rust: alloc: eschew
> `Box<MaybeUninit<T>>::write`"), but for the new `rbtree` and `alloc` code=
.
>
> That is, `feature(new_uninit)` [1] got partially stabilized [2]
> for Rust 1.82.0 (expected to be released on 2024-10-17), but it
> did not include `Box<MaybeUninit<T>>::write`, which got split into
> `feature(box_uninit_write)` [3].
>
> To avoid relying on a new unstable feature, rewrite the `write` +
> `assume_init` pair manually.
>
> Link: https://github.com/rust-lang/rust/issues/63291 [1]
> Link: https://github.com/rust-lang/rust/pull/129401 [2]
> Link: https://github.com/rust-lang/rust/issues/129397 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks Alice and Matt for the quick reviews!

Cheers,
Miguel
