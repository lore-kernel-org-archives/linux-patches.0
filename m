Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D4058AA7
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712051212; cv=none; b=Vtli0BIulsVo8MuTGnqjLKuDFhF4vKZXs5OZJTnr/YwEiWUjSY/1EoQAozQyLY0YQxLht4tHlgWKLhX5cmKFHzCpfxeWUuG8I7ltuwUnXzKPMRfH8uQL8fj0Qs+lJVb9Dg9S2bDZeE5IPOTmlbRtl38hj7fSP9k0EBdhrHGrt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712051212; c=relaxed/simple;
	bh=5KWH23f+CkrAqT9Dewsp1JwFaTdF1nWGTz25jhY/NPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElOn/LfU1AEtGaUkBj+hzjGJ8EniKUkpOkZGS2UwxuwDJMFif0mWqaKImXdKwsiibJcr/OM4rJEEPE0/TdZmtJWHrd7v2rb4ffdTft3+jXr+Li7U+XqHmx0YQ2lDQC+qfi9HmcnFCIdMoWuco35r55gUsic7uLlyktgf55oWOCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3egMjlEL; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3egMjlEL"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4d870fb9f5cso1838175e0c.3
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712051209; x=1712656009; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57Qln/YxVwij9SZ8Uk2+ZQTIMAfQPcYDAn1WRCFZujE=;
        b=3egMjlEL1fidmeCs8vOFXlV/orhpPg2ywSFfFO4ExYTwKgpNAfpBxjvfsX3PEWDjgI
         mdWeKuVtglZghJ9h9LMFVfKRIwdXJ/1vhHea2f6Q2T57Cz0wngoy0IOx5ob6xq1gReBJ
         PjWJZRc+8b0HzClnXApC+3X2YWHA1v70IwxAL2AvqiiMkylJL0caxsgcsjDZcGvNe9Gr
         obpb7Ddf0/hZHNfnHIaEFQkndTeGEpR+BxA17cTj5gI7UoSW6k7Osz2a/dbSNXh6Yqof
         hyxRePJelyLKdjzJlqn8ic7lurQjsdsJIyE8zeA9+FLKWIlNzdmBKg7ORVrk+yhP5xD3
         3C/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712051209; x=1712656009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=57Qln/YxVwij9SZ8Uk2+ZQTIMAfQPcYDAn1WRCFZujE=;
        b=HGJ+D5qAd9E4wmJEy+D+7vgiXHqHMwbJQc5ib7l+JECJH1YKFRDY265RgfNwv43Pu/
         F22aBkvJX+xVx7ceHC60Y7AhBA4ZbhGlkm4+ju8uZ+K6zLWWtj6Flymm8BiYxKMgE4Se
         vsEXLPuxfEtbmfrtkbay9vBrLNlg8+uG+KbL1kktcPdZ/ifY4Pz/ugzPWBjPOmlBdRWO
         epkKpkWPvx8dJZxOLCdVHoPWTgLioJbqcuPUnb+KCEQB7j9IT9edw48iqbsM3nsaiaIE
         uE3hjujwfu6r7BRwyFlQJAGFryXu5mvQoWcLEwQGRBhC4wZVyslK+QLDBfS73KbBJd+F
         XMsw==
X-Forwarded-Encrypted: i=1; AJvYcCWyAqt+u055gkniwTWfj+pdrSe/y8VGm8p2VBt/LW7YJp6jiUXvC0y8sDXsgfkdqxSxojVXPcrjJOzVI8EJyUWDEqVtXLvZoQ==
X-Gm-Message-State: AOJu0YzpfrskFcJwxOOC4bjqcn+hlYt73mTcZ7eJ8p3SVMVMCoQynFOc
	FgyZo/YKsHS7JdEy5lmQNwwQB3/BcCVQAcZdYyVkg6lbA3C90+MOTNxOch0NK9m+i2Km4fH7XNL
	AxC51F6ZAfIQiHFME80uaZSspOy+e4FJQcERK
X-Google-Smtp-Source: AGHT+IGQf3QzhQLw9j6incX1IXi9f33qMcGOHachbPjJXSe8XAem2rfd7FCRPcCKfwdQFdRHcq9OG/7bKX/RqoZHYWY=
X-Received: by 2002:a05:6122:c90:b0:4d3:4aad:22d4 with SMTP id
 ba16-20020a0561220c9000b004d34aad22d4mr9329783vkb.0.1712051209441; Tue, 02
 Apr 2024 02:46:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401212303.537355-1-ojeda@kernel.org> <20240401212303.537355-2-ojeda@kernel.org>
In-Reply-To: <20240401212303.537355-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Apr 2024 11:46:38 +0200
Message-ID: <CAH5fLgh7jbq8ea4CBJJRPY3gfm6=-_ck2mqArWDG6s+bLfMr7g@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: sync: implement `Default` for `LockClassKey`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In the upcoming Rust 1.78.0, Clippy suggests to implement `Default` even
> when `new()` is `const`, since `Default::default()` may call `const`
> functions even if it is not `const` itself [1]:
>
>     error: you should consider adding a `Default` implementation for `Loc=
kClassKey`
>       --> rust/kernel/sync.rs:31:5
>        |
>     31 | /     pub const fn new() -> Self {
>     32 | |         Self(Opaque::uninit())
>     33 | |     }
>        | |_____^
>
> Thus implement it.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/10903 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
