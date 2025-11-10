Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD3305E37
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762773444; cv=none; b=oYyu7HhZaRa1DhQnJdF4UkvI6YTqMUJiScTb/WgaXigU5T+RoEXAqkR7CJzU4/PdZgsyqZxfdxjwwp4VJCqxW3WqixxLY4K/17vd3YUMZACa9XhhdFAKffRpDj5nAcSExbakEwV/63CnNpsx3OHrL5kfa0CHPICbMyGBeJQWCXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762773444; c=relaxed/simple;
	bh=Qe3d2RAqo7YTKqv4jYgqUMxYnjMyEHYM/6ALuA5VeDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QZg5XYjkU5gXUBQmeTv8gdANPJ1mPCVVnp8RdY8f+K4Fvcj6Pq9qdr5neOe3UmB2ALZQD2gJF75Jj8MjAM+uLfYZO8hovP4fTkH6SJ9jFH8bj4tuzC1tqg/2LB3Qom5JoNv4yr7bGJE7jzR3BcP3zUnKyL2hQ0ZU82KP+sZPHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0Xqj6/U; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0Xqj6/U"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-378e18494b7so3615021fa.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762773441; x=1763378241; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qe3d2RAqo7YTKqv4jYgqUMxYnjMyEHYM/6ALuA5VeDc=;
        b=W0Xqj6/UzJbHwDZ0vaKes6GmSoO2/LNBI5N5DCZQZ518JulDieN6Tsqb9dqMDyugNb
         4hmPn2pxqiPKVD4QDIIDZRxfBwJPbA/06DH8EM+Z6r3IDcJQrnP+t+/L+xP0H8S8CrZR
         OR3e8XACZ1z8xsWz2q4qOgh+0a7fykebr0jKK+JTQq1w8yYQhe60kTpFKbM+lSaMQG7T
         P3G6JlAVS/frl2MvXodCTJsbQNRQ446I4G39NdbpLbSHWrJdW29hmFNwKJlOKSmBflmV
         3Pe7+lJAsHwsAA6yntuREiyBEXlqyqKr1Xt270zfcnvQQ0BZksqUy6RUqQIpPGIqDcb3
         W5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762773441; x=1763378241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qe3d2RAqo7YTKqv4jYgqUMxYnjMyEHYM/6ALuA5VeDc=;
        b=KYgiRFrI48ynG8tBzR/wqNTJ7L7OfAWcObFKK2hRAvOJvTdZ7Bb9gr4q7jCL6f+Nff
         5HMLGo95SVLAxRL9TKdXNXXHIxH+pWSuqlvi4KC2PaTE7F1IO08bT0aobE9DO2mnMWhj
         tebP96kBn9umqmEouBCiny55EO0PUieAv6fhJGbpyxfJOyicSa3FQ4i7uVOaqEdirk89
         Udc04RIdUffxUb8kc6EmP3IoaEStVgHylaPDoMJOzr3nOFJ3xahEdaCi1+Oyc8idFB/K
         xdYYB2VkDHYJaLrb2Ft+4P/EELz61qz5A7A9HDYMZTYIfBDoZoxnxyR1wb4vEmMRFm7J
         0C4g==
X-Forwarded-Encrypted: i=1; AJvYcCUE9JdrprfNvLatne/YpOM0Cli097OxgQR7VgZSudpoHX+iPDcUo0kKwNOTjrUCHPgqvUctvjVY@lists.linux.dev
X-Gm-Message-State: AOJu0YzGIQGqMuzCu8fR1jFdQqbfKO5BEbWEkUwNWnhxCt/IdBpNAv4p
	oVWjCH7YkVbEK3dyuDx1xZDr+Gfd0eFq9woe2KGcdcpELyZ1cMXR/kxocXMDSQctfqsZqL1uCso
	u7/V5xbkhNSBopPceVh8Ff0zCwCzkVgk=
X-Gm-Gg: ASbGncuzdDlTxkQcmCAEAunWbbqpqGx3JcYedZAAZpQlR4apEZ3BG24GVIuJv3/hCRa
	kcMIQZE4oBS5+LJ9ZycOTMZ2vnotYGRvkuwyqJnif7ZIGnAf+6lnIWolKhDT+ohpNErcF319JNr
	xA4qY5hoBbBQ6JO8DidJJkHb5HUTtDxhxPUfw1xpzQyWUc6dtKVSvoqfUq16HxWxihyRfL3ZHeg
	dcIO1GTXIJ/zzBrKZb5s3tNUx3c4aN6eApKHwyKjVNxyYp1e5Qzg/vsCJw07t8I0VsjwoRhxWFj
	9hSa2vZyx9ZHN8pztzlkYntA9ZdaPmONBf/d98gsKWiKlFJYfZNUlcxV6Vqd+okpa7757HRDaTS
	amv8=
X-Google-Smtp-Source: AGHT+IFBdQ/Kf/pBba056RwUp0V08lYe+9haO2B8HlujtJik6R+WJ/BwK9jrSO5+6zHV9sZYoG2V1Cx82A2l5RDsRZI=
X-Received: by 2002:a05:6512:104a:b0:594:253c:20ad with SMTP id
 2adb3069b0e04-5945f1e1fa8mr1168234e87.5.1762773440599; Mon, 10 Nov 2025
 03:17:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-5-ojeda@kernel.org>
 <aRHBu3RoOLTrMA8n@google.com>
In-Reply-To: <aRHBu3RoOLTrMA8n@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 12:17:02 +0100
X-Gm-Features: AWmQ_bkXotkhTxYYTuTPjRF1aS8uhIalsBfLfpXM8Q6vG63LofMfHcNy_ClSXmQ
Message-ID: <CANiq72kdkTif=HHL9ypoztDc8JiQUFCEuKyigQ_6ujXjR=cTyg@mail.gmail.com>
Subject: Re: [PATCH 04/18] rust: kbuild: add host library support
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 11:43=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> This is a library for the second case, not the first case, so it may
> make more sense to name this rule procmacrolibrary?

Making it more concrete sounds good to me. We can always rename later
if we find some other use.

Cheers,
Miguel
