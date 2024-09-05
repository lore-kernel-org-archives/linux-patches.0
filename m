Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9711198831
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523726; cv=none; b=h9mJWZLj3Grsdyam1yBZfB54RLJUcaxJ31MN8bCfpYFaIk3S2mG25K1tArbALHk93yMz4gSZT19zLi8ifVxezKNDLLTkcwp5jaNCpPunh3L+6KlueoYLJyT8Z8WqdFc90auFQF6M4GdGYyektMLxiYCOnBa/BxlwCA9qtr0aqLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523726; c=relaxed/simple;
	bh=xqZg/l2THvP8uncvI9Cu7hfQMDrgjo8lpwLhFau+B9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OY2f69UYZhYBhbf/72y5RicjVIzp2wrtXGhY1WfeVE1szRLG84fBtwKkMZA9BsRu8wS2G8zjonECu1AHOloNb98B0hZWEU8r00ThMXlY+cmvZtY3sKTOhFYuLgbKExQOlpD9qiY0xnLlXbjT9uDXEZNruJVzqKXBG22ciM+5UuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pCIGkk+M; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pCIGkk+M"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-374ca7a10d4so243587f8f.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523722; x=1726128522; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONdEvXfVoiXfsYQMbOpzUUsoqTAmilUWNgbBaxjquTY=;
        b=pCIGkk+MTTaRpz2qDKuCc4z74Ur4EqL/AAZ+z4mZsXt4ZsG1qT4bP+caEdSgtDLVuz
         47mE+zW2HMXqxsof/Xj9n1gANgdMfm/aCRYDSNe+sd16MAzrGEU10epnhz4wO0C6XUKe
         qWUmwy5t0v1tFivCE2E3S/QLjVa0vOXfaOMZI96t1cu1DUlfp/a6MmVZHtFiN4EIlf69
         bI4upOONtHDuJxqbRcYqfSdLlMhnfi0GB54dzXDB6dkLENkPiIrE5eWEmn/TjLR/cKCI
         t52uN3BqRKTSsSfKb4npDrJXBNjCkAk5XL5kXmcvJVGpk3XY0KCKPYE1cGVhWaCz566s
         2ORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523722; x=1726128522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONdEvXfVoiXfsYQMbOpzUUsoqTAmilUWNgbBaxjquTY=;
        b=uyK3X2NKdk4Sks03CmdZNonqlQZOUuH9r+K/GHsFjZwxa8E2gk1Wrczonkcdf5tl5H
         8/d3PxLVOdTZ7sw5+majGgsV6PbIMiVTjdjlRZM/bsaEhGrLROoa++m0a8K6+0OtuPDB
         rDI5KVa6D6Jr+DIPuc7M/C9fX/HlzsFxMmQ4kq1dkfiU1xoVrgfDZkntSchVHwqrDwvq
         dCxOcp3eZ9vIpMVJGp+c/IZ+19QP2JtdtFhYDoZvoOnd9zTBhjHzcEm1yzwxriAzquHT
         ONuW4kcv/LIEBI3Ztzt3ncm9tlYIZRzeaklwHZujI3mkGFl9KGZRtzxfWGeXBnwWsI/U
         H77g==
X-Forwarded-Encrypted: i=1; AJvYcCXM0svLLnd9Wp1fdV0N/HIa5qVfbFTNe8qEG5tuyMglM+1mcxQVq6kOvwT+OAfj/Oyie/1zVRI2@lists.linux.dev
X-Gm-Message-State: AOJu0YxhSR3Rx0OyKCWSJOreOjlmfZ136guckdb4At8YU99IPbxZbUwt
	fW0IpnV8xIYB9dTMsp+h9S8agiF0KuwuTT2E6+aSkCbkpUXc/ArDpE5QLJxU8tcoOLF8t4f4Tld
	7Ek2LpV9xBB9gNBuYIqbyJLQxwgV0LP9fEPeX
X-Google-Smtp-Source: AGHT+IGsREicwoeAI200xxv8pWIQ63uvfqObyTQjW4hGxPg3+tWUrCKJv/mwyAASMfYa7V/peuF92e+l9osm8aA3AWk=
X-Received: by 2002:adf:e2cb:0:b0:367:9881:7d66 with SMTP id
 ffacd0b85a97d-3749b589884mr15156149f8f.41.1725523722016; Thu, 05 Sep 2024
 01:08:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-8-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-8-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:08:30 +0200
Message-ID: <CAH5fLggDQzNx_uxT+Yw1tMP3fHZSRWTN0RcQEb40bcPL6KgT5A@mail.gmail.com>
Subject: Re: [PATCH 07/19] rust: enable `clippy::ignored_unit_patterns` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.73.0, Clippy introduced the `ignored_unit_patterns` lint [1]:
>
> > Matching with `()` explicitly instead of `_` outlines the fact that
> > the pattern contains no data. Also it would detect a type change
> > that `_` would ignore.
>
> There is only a single case that requires a change:
>
>     error: matching over `()` is more explicit
>        --> rust/kernel/types.rs:176:45
>         |
>     176 |         ScopeGuard::new_with_data((), move |_| cleanup())
>         |                                             ^ help: use `()` in=
stead of `_`: `()`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#ignored_unit_patterns
>         =3D note: requested on the command line with `-D clippy::ignored-=
unit-patterns`
>
> Thus clean it up and enable the lint -- no functional change intended.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/ignored_=
unit_patterns [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
