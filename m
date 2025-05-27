Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177F10E0
	for <patches@lists.linux.dev>; Tue, 27 May 2025 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748304780; cv=none; b=QOoLZh8vs4gR7k0LNYG1mRQn1LntlGqCjk1fcvPLwo6r3Y2hOcE+/uCXtL+t/K1pEP64o62HLznZjbvtjOIAvKvjyYD/N5/1wyNVmkBmS0uEgRTgkWko1JStD+S/9xGTx8BsPTrrIB0OCtflAl7/cwEd2V/6h8kU8+Cn5jRRBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748304780; c=relaxed/simple;
	bh=ShvoaIDylmqmCO/4tqPQuAPuovRvMewoIpt2vjGQa/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CF6nQddDhoc9fmDE3obqtRrruLS/Pj8qWYy3BImRosR0U5BomUtpz9QZIHy/3bIGoNSMuz4iXfNvePxMt4bMKuRyhWa6PCiN2G3nfK+KocENOlN+lFdavhXo2WOd2lgeAm/Zb6+h3DmcminTc9jwt71qTZFYKJ93PnBRLVKOkRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ec4gf1vj; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ec4gf1vj"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-311676255c3so98572a91.3
        for <patches@lists.linux.dev>; Mon, 26 May 2025 17:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748304778; x=1748909578; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDUVHJC72R11plYvEJN4plaYAB5GiKYQgfvLL/uyWH4=;
        b=Ec4gf1vjT/9RsYxGzQhRSfZ+1cWHzyVCh28saB9MoC2cJQnRWjNpCNF+wZMZKk6NaJ
         HSCxBZEKZWx75xyg/MWT8coqPBtRx8tEOatIDNRjlmxd6PF5qbO5iFEJwm8DWwE7NwMo
         HQ0Y6nT5G8A0ODRnoiFDpywZUhkZrufFEV8RILfxpiJgXaVTVoKrbX1oSvByuYhfdXYA
         ar/eZ95oFT/V7HIDFW0KL9fKNh2U7YK+Pv+BUy0ok8MhktxZAOmb/qbU8m7nVN1OHyFu
         +uIgdhVxcFTuygzWwpjMQwVG4uKzO0W2Z+GtRlPAODOJRZWIJw7AMtge5cnLcZsgsVaZ
         ESbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748304778; x=1748909578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDUVHJC72R11plYvEJN4plaYAB5GiKYQgfvLL/uyWH4=;
        b=mNCbXz8a3C39sIHNmuD3XgeMdLo0Bq6Xn6rRtcnFE4JvCH92psw1v31sUspeUwF6UY
         ANQ6LcLNOXWyORyAqtoujdt+dSrWbMS6C/Sn6ezPs/CDri+MrC8f6mipGn3+YQPN0jAP
         3I/EmP3NtUU6Vb1h8eDyCOEvgoD0fO/yaeLxhzD8xWfW6MdVHPtivq+3QRhUq9l+s6gr
         JTu+6KroabD9Oz1nOn3HRT+I8MKI97Uw6LKG8L8VjDscIzprKmikcnn4IgWmrsKMzrsq
         b1YMJnFT7dwb7yI9u95kB2Rl+AGvFtcNE3bEKNUlLsWuJlN/Cub0OPLkr5fgGi4vHV1+
         15ww==
X-Forwarded-Encrypted: i=1; AJvYcCWBktFs48NRMuqs2bKMpFKLl8xa5Suk2enGPVT6Ql3IXoz2LDTT/S9WeMJ8d/FIElwBmS8CwXNB@lists.linux.dev
X-Gm-Message-State: AOJu0YyT++2xgExRW03bnMnmVWN5J5LSajCy0qFTZ/kwZardaQHsbFHU
	60kjvLHX1gUpdWs9vGb8ZtrdI1u6bnYTGVDitGI+5v49ajvkG+mNk9mOlDusysh1l+0UnYB/cge
	3K8gvDUFCxLZWAUqChiWTq7O5j1ZYolYMUJt0RBk6cw==
X-Gm-Gg: ASbGncsO2PNIHzTuws1/30x0eAwPFizNIjzCE8SbdioxbquO9sgO8bc/wlOWMJuFSNM
	lpqtYTYU5HxWCvs+K37vJPsNV9EBtst5EYFAHD+FLHxaU/yQnAKAYyJoTXbhxIC7HJqoCPVSRIj
	Z0WEKb20EgcE6M6Mr0ZwE7y2///fHnYh4O
X-Google-Smtp-Source: AGHT+IGP6WSH1KR6xEx1oB8OliPNzy9iZnUE2S1clmoqmPisa2Cs0N5JoYvUV6KeHWSF04V6hwfbzOMIFPpxAN9AOFs=
X-Received: by 2002:a17:90b:3ec1:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-3110f0ee9b7mr6504882a91.1.1748304777913; Mon, 26 May 2025
 17:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <CANiq72mj2yv4E7Dd+19fmP9xGWELdv6JwXULpu91oq0BMzob+g@mail.gmail.com>
In-Reply-To: <CANiq72mj2yv4E7Dd+19fmP9xGWELdv6JwXULpu91oq0BMzob+g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 May 2025 02:12:46 +0200
X-Gm-Features: AX0GCFuWVeWoWd2QF4i5h3bZPOTXxZwG0hZtocU1fZDNtHBMsACg5wKAztA9UY8
Message-ID: <CANiq72=q66Xvihm9t3hbtJVAcB+f-aRRY9+amSEWBZrCjTcyUQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] Rust KUnit `#[test]` support improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 2:10=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
>     [ Split from the next commit as suggested by Tamir. - Miguel ]
>
>     [ Split the `CString` simplification into a new commit. - Miguel ]

By the way, I kept the tags from David and Danilo in that new commit,
since it was really a pure split, but of course let me know if someone
doesn't want that.

Cheers,
Miguel
