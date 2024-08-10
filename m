Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416BA156220
	for <patches@lists.linux.dev>; Sat, 10 Aug 2024 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723289866; cv=none; b=b9yUGJ+k87MW98zHqqbregniC6BQF3r6ReohqoSXrty9KdySktzKlMpP6QRSaoHw7pvrf9LrENxnlk4rBvQLXfI4rXsnnI2tvMZ5wUGMkdMFtYy5/N498eHs7hSF6AfjpXR8ey4HltnCAb043lvb7noWJiYhIDYdNX+NiwcVIaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723289866; c=relaxed/simple;
	bh=nyjMbTRKzIgup19D4QFqEmhTVziVhWMsAuiW5Ia3NJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUhRbDW5kP/d7MtD5WUSfNcBkoOyBv7zBAZDuwflBxame2eUk3cQ5JIADk86WpG/OnDJTKh94UQ3/+SssGQZGp1+2G6Vmtt5AzDhjz6Th7lC45aDt4JKzpVfYCEZKyCOt/ZKlqwgQAjTpspQ1+ztNXMwREE7JcXpqJwFZS50MSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbYRWpKQ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbYRWpKQ"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2cb5e0b020eso2320048a91.2
        for <patches@lists.linux.dev>; Sat, 10 Aug 2024 04:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723289864; x=1723894664; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyjMbTRKzIgup19D4QFqEmhTVziVhWMsAuiW5Ia3NJ8=;
        b=mbYRWpKQQgN9EgAp59vsNCTsCyYhQM46Jq08lt7jTaMjM+t4Hg8WCK4FBnv8AWyUl0
         g/RMVT+zgKY3CJQHyKRNSWsvG6FAujQEW25byRaui4FcyK0I5rH42ZrIYXdkpPc8K7V0
         J3MuIpY2fuNnkOtwAhTlqgrJJXM4yY0rl8YCbk6944P6SGIVfCeg9fWaYw5GukSBdHby
         bS2El6JfBFyi7kUAKDlcqBUmMMXzt1w4sIDV0lMbEkCjWRvr27JD8fddsuWy0lc+JcNG
         SG3UAnQ8KhuL2M0h9MRP6aLYYRr+4+6Y/hGu9IUrWtNcfzdnmzf6qaAd9tCg/iYjOlUq
         HOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723289864; x=1723894664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nyjMbTRKzIgup19D4QFqEmhTVziVhWMsAuiW5Ia3NJ8=;
        b=FgD/DjrFgzWr0zc2OpSTpU9G4DkW3A0w8jX9yiWFPF1hNyMLwK2C+da9OPSd35Dz+8
         ejVDOh/Z1K2l6r/0lYrrv1vST1Qiqar20W2+N5aCbeoXUZm6FEX77LMnqNNToQ4pEGbZ
         SzpjzLTsyNI33IejdZoTB22b7E6mmq/etqAYPERNbs8Wq4UaHymhl+xnn5Q8vLBw7VIL
         sBbwzDJSdFL27PfYgNiygDZH/R3zC1yJDWJugmklM5//McxNtxXPEQcwLR2n8V9WcdHq
         eCALPJIu/bh0GGV1nNYtYL36RoLWsU/InpaEYaAhVXbukISjFCYp7V0AB9hGT2jedlui
         NY1g==
X-Forwarded-Encrypted: i=1; AJvYcCUlLv2kzrTHuSNyy90kmF0i4Ng7JgZg1f16lgT2QWIZJVv9WQm+ld4TvtViQIKtd7tZDX3NNWz4LrNw9uyDeRaq4+z1p1QKhA==
X-Gm-Message-State: AOJu0YysbXnqUz/90vD21oCgGhnzKfabb3GZTKrwXh4Re4IqGl56nrnn
	SJeZrGp/b1vHQTM6H9StqLt2+Eyzp6erOjBRiGXFmegfxid/yvGMSO4xQq9cRbWjIPMajMEBEid
	MdjkqtMab+aZuYcl7gwRjkfunsJ8=
X-Google-Smtp-Source: AGHT+IGbxcou3CzpNZyydQ965UMSaM+Z4qXaE0eCioeDzM0foGhNOabnuSmRRl/OGET8O//67ZF0e5UgZi3e8GvIer4=
X-Received: by 2002:a17:90a:fe8d:b0:2c9:1012:b323 with SMTP id
 98e67ed59e1d1-2d1e804a767mr4955578a91.27.1723289864432; Sat, 10 Aug 2024
 04:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-3-ojeda@kernel.org>
 <CAK7LNATDZaGrqvugf7JBOvYvJTH=ZUacSvFZtiJW=9k24-wWHw@mail.gmail.com>
In-Reply-To: <CAK7LNATDZaGrqvugf7JBOvYvJTH=ZUacSvFZtiJW=9k24-wWHw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 13:37:32 +0200
Message-ID: <CANiq72=o7cRR909Q_Umr_Ssg5ZKhTXna5J2Nh-_goTGm4ssF-w@mail.gmail.com>
Subject: Re: [PATCH 2/6] kbuild: rust: make command for `RUSTC_VERSION_TEXT`
 closer to the `CC` one
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 7:53=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> Even if "rustc --version" starts to print multiple lines,
> it will not cause an immediate problem.
>
> $(shell ... ) (both Makefile and Kconfig) replaces a new line
> with a space.
>
> CONFIG_RUSTC_VERSION_TEXT is not broken in any way.
> It would be just longer than we would expect.

+1, I will update the commit message when I apply it (or if you prefer
a v2 if you are taking it, or if you want to drop this commit, please
let me know!).

Thanks for taking a look, Masahiro.

Cheers,
Miguel
