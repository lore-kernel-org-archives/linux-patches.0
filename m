Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D6757E0
	for <patches@lists.linux.dev>; Sun,  5 May 2024 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714948516; cv=none; b=SnGfS+sqynGLj1CtY239jhHZxUl69du5L02+QdMAfktsijtvpp17WPsjiUpGRiaCgeYMdd2j5k2HdxQISRYJKH0nSRdJhdKF14NgxIiMw/PEexaGlbhh1+RKM32X/O2NeRNZMYiZouvK7OChOR2TZZ8/4oiH5nL6rRmlnxdvvfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714948516; c=relaxed/simple;
	bh=5nyiTBRMziL6N5Q12s/U+aXAf/VH5cNzREjrocYZTLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kmryf3FB9RiN9vHPKf1WGLC52wxmfkYj396mZfwe8OxKlNwxs3LmjcN+kSIkNmVa8ujxc7QHOHZA6S3GcifJluvD3Wg5RHyRxm3VcWaNGR6ilsPKMBClMGKvVFXAUcrxGYcGwrqv+calvtLhDOVSFrSr23H/NGKFXynb2pghRe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=INOJtkaH; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INOJtkaH"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f4496af4cdso1021675b3a.0
        for <patches@lists.linux.dev>; Sun, 05 May 2024 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714948514; x=1715553314; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nyiTBRMziL6N5Q12s/U+aXAf/VH5cNzREjrocYZTLc=;
        b=INOJtkaHmH6W1bMlgkiA1ANMIwdYWSEQtp8bbSIECSc8ArloiY8O7lawhLJ3d1clsD
         3BM9DDvE8kzdMSGqeoGft8ghTdSpCKfVw3t/OdXCENAu7IF43Av5DLM0lgKRBS8dnzbg
         UQ3GK4fjzcDoSL3IQ9Jm3/sHATnqrvsmnc0TxH0fIsGgeqmQMmlrDv8jxdLCIiLaDuve
         YEa0IkZZqjgvSpa+8QuRI2kw0EDlNtzfOTEolt57H9WTjZ1UEIyeJCWE6TC4nzStqhjm
         LqqN4oZrZwTEQ0gr87KlHW+dUl9sO4/xC4C81mH/IrOx6sb9vlka7Q9wYPfnYIw3osso
         NzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714948514; x=1715553314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nyiTBRMziL6N5Q12s/U+aXAf/VH5cNzREjrocYZTLc=;
        b=FXBX1z+MbWqFniiLij2k7lXuyRi9el1p6WFczx2j8HLQXb+PyOL28GUeLMFjjw3ajo
         E6fUWSJaL5u2wEMLZ5V/1JnLHucq4tDz1aHUAsQUCaTYoXwwRy2iqWAvPoFZIzMGasRp
         SZ6I+fZT3HhYrexILe6CzyW7qEvl43hCV+Zt2RWYdmJPZLmlqfTTiOgtKneIrPneR5LK
         nFq0lVSnaHqi3aLJa5rXTORCmgJMKj2zUbLyl7jBUkBWb4G+mZyuoWO53h+ijyPPpK5U
         0vWBLMLxxC5i+97j4ijyQGHrbm60Jgu9y5vF9V1J+lg0RlDyhG7jkNHEwZ4bTM+YwFEl
         JXAA==
X-Forwarded-Encrypted: i=1; AJvYcCVQy9nFYscN98Nx3czanUlyJASz52sSUntNIRBn7u3h+PpNQZ8sRTuARgxzTxgVUjvEh0uxZ+M+5S0iDy46Lnv0X0cC8rS9SQ==
X-Gm-Message-State: AOJu0YyvcnvjqlFC4ND/KLkzR+NJPe1Rm+lsBGGhjZInA0JMnjxTwrJH
	CaSsXTg8hdcthRKkadWiei80zxTvQcJfhv5eneofw8qK4w/vSjhBkjQY47bJlEGrAq5hT8uNvtg
	zQ778R/87SW1GVbdnhLyMp1E6UGs=
X-Google-Smtp-Source: AGHT+IH7PuoU5b3Xs8+VHP178x4FKbxo1mR1uv20n2JhJfudeVeUD+yvCcY54OyIjFzbfc7HxxFfp2J6S3jj3t6jMI8=
X-Received: by 2002:a05:6a00:1483:b0:6ed:1012:9565 with SMTP id
 v3-20020a056a00148300b006ed10129565mr10204972pfu.15.1714948514184; Sun, 05
 May 2024 15:35:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401212303.537355-1-ojeda@kernel.org>
In-Reply-To: <20240401212303.537355-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 6 May 2024 00:33:49 +0200
Message-ID: <CANiq72n4TuUbKZGNEWXVYKj1f0B8KgjXntVg98FuthiqwVjk_w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.78.0 upgrade
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the first upgrade without the `alloc` fork.
>
> In other words, it is based on top of Wedson's "Allocation APIs" series
> [1], applied on top of the current `rust-next`, i.e. commit 9ffe2a730313
> ("rust: str: add {make,to}_{upper,lower}case() to CString").
>
> Please note that Rust 1.78.0 will be released in a month (2024-05-02).

[ Added a few more details and links I mentioned in the list. - Miguel ]

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
