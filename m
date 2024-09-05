Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F51D1940A1
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523039; cv=none; b=O82Y1g95IAloBvK0kryi3EYxI4hEsCdnS6tdIgKMYAfcUElMQ1V3dOvb23q6cPFbSAfAXkzTVkRAgptyRMZHTAUjH1ksIoNWyazS10bFii0jo13ZrAz79F+CTuXDS3gN+mCQMIgQIKfhf3N+NNznIH6KGcyw5NzXB44jCKzlFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523039; c=relaxed/simple;
	bh=/15VqRopHjfs3Vag1wk1OqFB52SnvYMNDXanIJRXvYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QB6qOq68iDdA0kAwGDcVI5E+VdjKPWte8M+7x3ssE/92+EBKsyJJWU2zkwObseJFNEUy3YK/mL9aBnASgU2q5vh1ZiHFw7OctHWYZzK3Zy223O77PfSn6Fc7m4/ippShZYelNJNyJmIsUDuYA1IW7KURUVs4kSOhIgd0mox7v8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oGmYHTKQ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oGmYHTKQ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso3160705e9.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523037; x=1726127837; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7YrEnRdBza8n37TnMfyYmOU2+akv+XRSo40dZskXfA=;
        b=oGmYHTKQfloJjFbEzi3aa3TCauptP3iG4nKjIYR6G9zEVfpxA3Lpc6AHGkFGyDV6Ji
         1An/5KPyON4vOXpNAPyRer3OmwERicY+M/wxfPZZYHZg/PX21Ou9WoMZ2VQBKJkEqAQY
         KmdkQQK5koKvtyobFPxG8KE72b199JtxKZKSQIIGvSqdhlIPCVYqQt0V7ig35hQPGdcr
         GHzT4wKn4ONQxNsCVvtWutCWzA3pQtEPLoibmF4Fq3Ubqmne80CRvwFQD0Kdwjzt2rTq
         zvAAYNJWDMsZa38urC1olHCyIA3dRpMIMrVBL/Ordia5OKFpMokOUB28GUU0J4RYfcGL
         On9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523037; x=1726127837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q7YrEnRdBza8n37TnMfyYmOU2+akv+XRSo40dZskXfA=;
        b=G9ItzHtGnvT7k+evjo4zVlgtKWFs6ZYi85pQf282/5/exTYlO+7VClxhdmDqMYWgcR
         ChxJy8eHBEAHudDQUTjj458BWQMmwYO8ZW5YQk+LVLYmiw0BQ2ZofMun3Il+Zt0Xo3Sy
         hdMPofX1W5uS0Qww7B56C1eFYo91tdbtnzKv4Q9oyR19SZGJN6LC8KzAI6oMX5X/sWlr
         Grchqwf98+KbkR7wm+ipBhK6QX4lkakY61MCKs+BGDEQgzsnfwgu9kG9egZGGiECfkuB
         ln541Q2qU16DdWu1hpFjUtoZ2CzgMgumMkmiBAmgsQvW/5frnjNM1UAwhlXvkI4KyZ5t
         mEwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqe/mWw1mCz42Hi5p4Oo+UMS8TnsNOLFqWDSwBRQ4IaEMn54d3atjQYFkCA3A2P50bjsTMDsEN@lists.linux.dev
X-Gm-Message-State: AOJu0YwzcG8fl8HNUgwuIne2f8NBhYgcNagTLo724/hPSiPTy5RT6mrh
	MrtoY4MWCdZq2dF1n+AVqY79cWupPWHMdCbGrwzT08tcXV9ikSMbmglNCCA6I1kIQRn3AWQcItG
	sfFqFSrMd1RBZlbYDejq8GBAkH62ZSkWV5W4w
X-Google-Smtp-Source: AGHT+IFGxSk5gvaezHEawui3mVYKQEAynuLTKFXTokKk6E856Tt9Cj3ku4PsaYI/2eDBJp3YhF0CWjK1PgsgItKLriw=
X-Received: by 2002:a05:600c:1551:b0:428:ea8e:b48a with SMTP id
 5b1f17b1804b1-42c8de5f5c3mr45944275e9.8.1725523036325; Thu, 05 Sep 2024
 00:57:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-2-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 09:57:02 +0200
Message-ID: <CAH5fLghM7mLjaivcErwwMGREvdJJMosHDLdCn-RUbdqJQo-DwQ@mail.gmail.com>
Subject: Re: [PATCH 01/19] rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Perform the same clean commit b2516f7af9d2 ("rust: kernel: remove
> `#[allow(clippy::new_ret_no_self)]`") did for a case that appeared in
> workqueue in parallel in commit 7324b88975c5 ("rust: workqueue: add
> helper for defining work_struct fields"):
>
>     Clippy triggered a false positive on its `new_ret_no_self` lint
>     when using the `pin_init!` macro. Since Rust 1.67.0, that does
>     not happen anymore, since Clippy learnt to not warn about
>     `-> impl Trait<Self>` [1][2].
>
>     The kernel nowadays uses Rust 1.72.1, thus remove the `#[allow]`.
>
>     Link: https://github.com/rust-lang/rust-clippy/issues/7344 [1]
>     Link: https://github.com/rust-lang/rust-clippy/pull/9733 [2]
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
