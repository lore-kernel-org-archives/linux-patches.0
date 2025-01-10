Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D934A20ADE7
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505886; cv=none; b=S1E/TeOwXAPwDwn8vXZ/YBjVd6ZJCLsFMPgC6CZg+zlmPd6cLanMw/+Zvivbsbe3TXVXFMIey+oHS70zodDNC/AswcXJkmHVT7mW/rTexW1adjhLKirtN325mvRcDmqUuk+em9lZ1aatKGWgnkVQeIT0QrIsne8b9o27f7rtgXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505886; c=relaxed/simple;
	bh=apaSsDlajYXrbZl5767R8Vt/ZIAnyGYrQWSYGxJzByc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RdzcR7QWv3CTbz13f9s3326LTJduYi//DWCYwmSePLZO80MDqOnHVFClrRf/e8yMz0P9IQQC8b393MNCeaLj7sryKpWi9Xfg96+N2Ey0R+oKB0JH109LKMjFS2D/iksL+SOSAUQtoyQzaSygXdnX4l/uhH9+3KXbzfo2fk/hfks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NjrLtfcG; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjrLtfcG"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee534d6800so389817a91.2
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736505884; x=1737110684; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apaSsDlajYXrbZl5767R8Vt/ZIAnyGYrQWSYGxJzByc=;
        b=NjrLtfcG+nHuaXMS+qUuAtmG+CWYhx3iksgeVGnkCJaYDTEQYsANOPgQEkG/NepdUp
         vZru/aT0TSFbJ7JiOfv02XzyZkc6roCjqlVC4ZqlzgYlKMIAVQE3ltF0a3AeE1JBe9Uu
         U7A5rF+E72R0rTCW9BbhEeUFBrIMXi4XRrDx4di47p1L2xhlM5QL7w0/THyQ+JrFr21g
         YxyjNxhpjj4QZKHMgh9e3GoWQvUD1mlZqvOXVv9MUB9Lo7gOKMn6mj0oYOQvdgYyd3Pg
         vaUELrUmHE9q4a+0D7IStmBFK+73gCP+jl1C4l1cPRe9b0M1LUcWfLs3Sdz/aF/SVy3x
         IOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505884; x=1737110684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apaSsDlajYXrbZl5767R8Vt/ZIAnyGYrQWSYGxJzByc=;
        b=Pd9UuJGuwigqFvLw+UIwnHniBIcdK0wqgGLgxt7wP8f4LeB5k/o8a3Gfo7zH5YvBlX
         CMkimCiTPvpDyhs9x17LNPYCgyB6Oopg2eOqIXuYO2GbosIDk7AAO1eGm6gJideGedKC
         BawjibbdXigR2yOyAXSlCd3v4uRMLx2JJuyrMNvPmy5jIqrFp++6dRcQMG6y7BfFkN6x
         3N6OULf5QO1vnOYQUTNsy/2yBMlJgWSmUzo2zEKbSm848wXLiRYfnbu5UpDbaFJwuwwg
         F4De+CF8uVItqOefPaiclHx1IM7nysdiXBmgNF6L+AlJHkZOeoAb2VSlRVwpt8hofbYA
         jebw==
X-Forwarded-Encrypted: i=1; AJvYcCVFN/1a/Gvtd+0CAEsEcshInCWikDJrRLUbMdYdwwdiitoWSTSjx23i/eh1YHv6YfUY18xYsvIk@lists.linux.dev
X-Gm-Message-State: AOJu0YyNbmgZtmqZLUhWDMdD+jMudx9u2QITq6rmKlJssTAOMwW3kf23
	uT3n0/EIvWLOXT2Rj0xc0thkLKM9QF9FfGmsEmPcz4bTwn6lAqmUGN8HzHhNC7lwo0A5B9sCWqh
	pDzoIssyRbbMvlRqKKYDp5ZH2nrw=
X-Gm-Gg: ASbGncuEA637ji5WAf+/wBppTkDvsnMVlrXZfHEy2zb0gXIUd2kOA0IXVzu6RsqR+NA
	9qdlRLPnbACdfQpnA3AsfW3wXx4ssOu/m0LIdgg==
X-Google-Smtp-Source: AGHT+IHxuK/S4kHUOpCjd2bexoRn9sYk0/qvrZR7fXgjrU8ti29XU/dEB3faBBBUPXK5M7wDyzy7xK7OeE1MubNg9aU=
X-Received: by 2002:a17:90b:2545:b0:2f2:a9bd:afe9 with SMTP id
 98e67ed59e1d1-2f548f055ffmr5779092a91.2.1736505884313; Fri, 10 Jan 2025
 02:44:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241209212544.1977065-1-ojeda@kernel.org>
In-Reply-To: <20241209212544.1977065-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Jan 2025 11:44:31 +0100
X-Gm-Features: AbW1kvaHYeTBaUvMv9ak9NAyteWj06n1FXMZjLMaTEuz0GUjFQTH7pDQg7U0T80
Message-ID: <CANiq72nvHB0W_MexaJcwa6h6_n4iSVbJJBjH-M6MwOCJQFfC=Q@mail.gmail.com>
Subject: Re: [PATCH] rust: document `bindgen` 0.71.0 regression
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 10:25=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` 0.71.0 regressed [1] on the "`--version` requires header"
> issue which appared in 0.69.0 first [2] and was fixed in 0.69.1. It has
> been fixed again in 0.71.1 [3].
>
> Thus document it so that, when we upgrade the minimum past 0.69.0 in the
> future, we do not forget that we cannot remove the workaround until we
> arrive at 0.71.1 at least.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3039 [1]
> Link: https://github.com/rust-lang/rust-bindgen/issues/2677 [2]
> Link: https://github.com/rust-lang/rust-bindgen/blob/main/CHANGELOG.md#v0=
711-2024-12-09 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
