Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E227446CF
	for <patches@lists.linux.dev>; Sun, 25 Aug 2024 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724590223; cv=none; b=gAb680agoPwU9Z2PPmaeC4CdX6EN3eBmn9mVPi6O5ebYKwALsoEAnzJSkfzBoE50SRDpYT8IUEaKa/gBr/c7dMvb2bTq1lLUmI/8ZYXohF2FYgiYgBcApBt1BOmit9Ga/2X6h+Qv3oh+TISx0BV4ggsDM6CdAtHKlv1YaUlnBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724590223; c=relaxed/simple;
	bh=wSsxZ7dI6+X7NQkH4B/DRRARY/PktUAwIQOrsJoOArI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuhnPJzWUJP6dOhZj8T4xfostI9u732z6KnHqwDEvN625bbWtcxRtQ95RiWl7y0rh2VFsGRjnlIfGJkpH4Tq2olJxrjtGtK8iG2tb4h++COOgzBTeDyFB4phZjIPfj6IzfqtHZHN919sog96OWngxGQUpJOrZg3tDjy3C7svaWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrG4z3HW; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrG4z3HW"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-72703dd2b86so544339a12.1
        for <patches@lists.linux.dev>; Sun, 25 Aug 2024 05:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724590221; x=1725195021; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSsxZ7dI6+X7NQkH4B/DRRARY/PktUAwIQOrsJoOArI=;
        b=PrG4z3HW6Xf8efi1vm/4QjG8y5mFZHEZlFkdD9d5FWToPndrwx6K+gVnKBaJwh34uJ
         1N1gq6hbduW91YLBN/BLGBWOP4bZNeqz9MmsldenBGQuAhq6gY/saFo0S5E3vE3ZUJFq
         e/Z3whqbUFsHN94rrP16UBDR69FsaZ8CnI337YjGlV2WUcw2jUiF7GdDFZY7PaKvFu+E
         d7rJGX6nR1YfFs5v8ylbAsV9jEFQ+NmM5N/RnxQ1DX0E97kjyELKdlDu1C3eKBRp9o/8
         P5GVNcPTsKfS4PfvWy5Ni9fCnFPahfM2utr2S4tNynkLTxEj/ez4ElP4c8czTxwAEMmg
         OlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724590221; x=1725195021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSsxZ7dI6+X7NQkH4B/DRRARY/PktUAwIQOrsJoOArI=;
        b=YJn1rNDwZxVTYKZt/dSwcdrJ0GrPkVX0ZqX0tgxGfO5qIhk0ESwa16nrXxajQ9sgHc
         r3YA+DtOQR7zgixMOKoq/boPlfprOyYSHeg2TMtzNTDsWpPGtGIQbHksXJdbCkk9QQrk
         jSHXxwk++KJSX8rbL6rIdTWmqeJAKINKJSYGnK5Uzg+V7tdHqBY9NNJ1NQsqlFuf0h3S
         QM1At9cG8b7vNsIiGeEBDBsYEu36vgwa0swCPUsYo/HudyU/wbF7MEYWylBPanOx/mPV
         Z2blmz9G7hpkD3JhCIKlUFqH3Is98UzG9wN4olxa38VUphI8F1j0GjD/1c2H4drMuJjS
         Cr2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgt+B3/HY8mvuSf8v+AdEqdnAwHjLQEfa7KOIApWIe7cf1Wu4aNkiWZuuX4Glnd6zvzxE+wqeR@lists.linux.dev
X-Gm-Message-State: AOJu0YypqnxkByeFF4V9HnvTQjGP15IQD3hxttlQ1rkV7yrBYKDCr31c
	Rm5pWzHa+6YPPUEy7nEhKKx2ytuJgn/pjRBKcX89f7gTxOkyqzXEMuRza8rnPiD4A4Y+2YP6QYe
	bcYILQ9BHd3J6KWx5kzhMSGYVKNs=
X-Google-Smtp-Source: AGHT+IGUP/DfaB8aEfaxtY39P9KCRZBTpgnKO6o0P+JJlI1mDdidaAOCtFLZX+kqLiI2gqH878tXcACHcJ7jVSFugBU=
X-Received: by 2002:a17:90b:2e83:b0:2d3:c2a3:2383 with SMTP id
 98e67ed59e1d1-2d6465fad68mr5180628a91.0.1724590221151; Sun, 25 Aug 2024
 05:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816181514.45696-1-ojeda@kernel.org>
In-Reply-To: <20240816181514.45696-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 Aug 2024 14:50:09 +0200
Message-ID: <CANiq72k9_B6zvB=WumaNfb6VhYYUH_HH0RF4duJGtA23bwqRqA@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: quick-start: add Debian Testing
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	=?UTF-8?Q?Fabian_Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 8:15=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Debian Testing is now also providing recent Rust releases (outside of
> the freeze period), like Debian Unstable (Sid).
>
> Thus add it to the list.
>
> Cc: Fabian Gr=C3=BCnbichler <debian@fabian.gruenbichler.email>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
