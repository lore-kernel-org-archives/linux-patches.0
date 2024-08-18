Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB3514831F
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724018168; cv=none; b=RrfApqzszDrGXHgParJmstMyw5blxAuCwR+ynib3bSpfhAPWSVPAjQ6vldgzqeMWKIB+mUffgcmpmuqYQyUCxkHMXI4ByxvJJlz0WwKnqQFy9G5jcyYpgKYR+krvdXTOGTIKW2Y1tcg9ypVkMYYaQa7cjLxI+kbEYAq79WTX3X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724018168; c=relaxed/simple;
	bh=7XQrBstONpqqg5tBlz3FmFfN5Ko3xGJY1McB5aTD4Yo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXTRlxulu8CJjsQzABprWLZ70+pDtstuDyEazLSzGX8vYnAT1J1ml5PIdNjMKzr+TBJFItB4eQJ+GLOVs1F30a4DwUjmYYL6tU4cmWFeYV3dhapuihG1vnHcU//zdryDN5nsO4fkKvM6587Bi6jIwl+wTmPimAxMcto7KNpOiv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E066flYB; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E066flYB"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d3da6d3f22so2278881a91.0
        for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724018166; x=1724622966; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XQrBstONpqqg5tBlz3FmFfN5Ko3xGJY1McB5aTD4Yo=;
        b=E066flYBiI4P4JlGZfbbVCSthwcFI+ZsOSFjApgw5OuVMReRr0yJzkWkOmuqvS4SsB
         oFlX3xGKCCj5cxVWCw9U1d0hboZZxUZ//kAvPzfwEC2zFf26WeD+E4gRF3ipCOMQ61Kp
         kDHL8e+SMo/vmiLSr+U9Hv6R7fcqQUyTCGUbTnfd5T2SLEY7Zq1BdXU59MZCbeFp9Hjk
         kBsl7UnDizhMBs6DIoTaQ5jeLiP9TZ6j+mwsBUEtVv5dX3OJpxYfEBU3g3mkPbJyKqe2
         RACSJaEZmSK7xePUvjS3r2k4qpyvsuz9beBUbNMHatgGfMmtXH9SwmLDGpSeon7n3N0s
         r7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724018166; x=1724622966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XQrBstONpqqg5tBlz3FmFfN5Ko3xGJY1McB5aTD4Yo=;
        b=aDKS5tzqR7bArK4uY6PhlymC0QcpgvmfbfYKJFGM/pTTAbmJ2FKZCkwBLwq/z44+nB
         AlkpRR9fNI0M+FL5eWxEvkWTt3cVvXAIMwhDX8OudgmIKymejbobWxlsgnwrFERu5dN/
         jSmQijiSK9W66TJnNV1XF5eyIcWjZ0ZvN2VGUnxRsby/KWYuCwwOvs1lIvUA6Vq9jwh7
         O3LB2neO0uwl5ufIkduZs4nLusxRj+PLn1Hb85BzPybvuAn9TL4vD4Sa66grs+Tnh3Y/
         gXnTV3yTt72EN5+VW7oGFq5J1TFyfLpbuRnYIhEwb6CWeg6GL2xGDR++8nihcGT0RIBk
         oxDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjbllxDIRw93r94Qn3oOQUeHoQsOif8/hmBi0qT6jI8SaiCWv48VdTn3S04wJD3KvKPefK4fDc@lists.linux.dev
X-Gm-Message-State: AOJu0YzVkSgQxWALmWT7FeIGCJSB29tEBbQZLFEknEXsiSHsehWY5Sly
	quijj4yKhbDKtH0JKhuSIVVQzSHoh3SvYSLw0kj3SxzGphEv02QzqhSqbk+18wb3yacbEezAZah
	c/dGX9PXXvHQe2G5v9geI7RLxRkM=
X-Google-Smtp-Source: AGHT+IEZ4gT6nABs/K41mitZD0wdXrUuQ4YqCSCqh1GuMK83jxlywWLfsBWcImdS1SuTQf9stCTv0wBYynhUq+X4s0Q=
X-Received: by 2002:a17:90a:1f81:b0:2c9:80cd:86b4 with SMTP id
 98e67ed59e1d1-2d3dffc0f90mr9173142a91.11.1724018166043; Sun, 18 Aug 2024
 14:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240818141249.387166-1-ojeda@kernel.org> <20240818191938.20ee1766.gary@garyguo.net>
In-Reply-To: <20240818191938.20ee1766.gary@garyguo.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 18 Aug 2024 23:55:53 +0200
Message-ID: <CANiq72mF4=o82Ju7y8wrq+5fCVbungWf2iry2S=1McQ03DJOSQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: enable rustdoc's `--generate-link-to-definition`
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 18, 2024 at 8:19=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> Thanks for doing this! When I visited rust.docs.kernel.org yesterday I
> noticed that the definition links already existed, and it was very
> useful.
>
> Reviewed-by: Gary Guo <gary@garyguo.net>

Thanks Gary, I appreciate that. Yeah, you caught me, I enabled it a
week or two ago. I am very glad you already found it useful :)

Cheers,
Miguel
