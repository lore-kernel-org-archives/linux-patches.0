Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97F1E2847
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 08:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740989165; cv=none; b=k51ExCRNwIxt6dU5Xp2Uu3mJ0GRoBRDdDvmbhwLPYTHejUVJMAY02gbJHU+FcGgGALU98Isbg/LhiALZIk7OyfytnMeB7I935eXpwp/oQbvKDjZfL04ZthdAiK0znCAK0XVqSDggy35+KunjqrnEp/eHsLOzUn0HHNWCuJH5EzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740989165; c=relaxed/simple;
	bh=IH4Qw4OZUiaQzCHILHMnQ5Z2BcYMRjESRbrTXR7+1/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XBp3l0fVBTFNGb7cTRVBB7QQVRbnPKI8R1Anum8P3q2rOs+HEisC6sXPDsIuKnA3GNUC5/WEZ8gtxRs1TwMfhQxfXgJzfMm+dqlafrAP2g6UH+z0R7evDM5DhtegAmzPNA4izeptutC5KDBdXdYiQhQ16oKKQLqb0n6Dc99bw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bAGOwRp5; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bAGOwRp5"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-390df942558so3241550f8f.2
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 00:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740989162; x=1741593962; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0iUVs2ZQh+M1rl5kLkJ/YPcqr6UkD+Cttj33+uPFnc=;
        b=bAGOwRp5fC0SHPexCiBm0jBut5IHJzsL8U0WFc+kcplpBZIPggp2Il0Rlwmcr/P7QI
         3rlS94hHKVeVZ27LFdOIoSXSMC4hTaRs8vTpWLMshbjOKRloyskgy0v+tjSd1fBq8xNY
         RTzIL5QhYAqxFvC6TWRGm+qmO5NhxpxCu9ud/0Tr1ScxZeP36wJbwFqYKB2TNHXA8MnH
         0/7V/mqiM5Gwp4/i/qGrCpBg/dfNRK79VCjM3isItf3jAJ1TbE3vkskorWrEF9XP+btT
         VtNOous4c022KF7RA8VSy/U45jZRRQgny33ri7txrtmZ++mTMmdU/M5psfpSWby4cFUQ
         PQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740989162; x=1741593962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0iUVs2ZQh+M1rl5kLkJ/YPcqr6UkD+Cttj33+uPFnc=;
        b=PkRCAuCcENnZjembvtaiiSzvYW2l7rasR/MP1/t+8Oyo55D9vdQTr2Mba5VRaUmYH0
         s/njPfwiJn1y+hUO+LppQ6oz4h6HrIOmkWNZ7BEbv9z8yHgvSRDU78a1ddyizgEnjCpR
         QdJJ7YfBva4TjuqR6a8LuFa+3A5BvP4RKLnhfm7gzVcGPqkV/Zk5JOUqpQdyjcu5U/kD
         vO/pO+G/919XS9xRlNX7ByafdeC5qFtSZyybKpWZyUIJOfFF0o/jEoenWAvh0FuitQ/c
         w5kEJXkM78BiylDHzd+6P7mEdztEcGrUjAEMNedF+D9gEAtlbGVQGJxACRa3ck2YejL2
         0Tnw==
X-Forwarded-Encrypted: i=1; AJvYcCU4x9wiisLbD04r/XEvz1KBeoygM8mRgi2UPN20mT1MtBNFofIhw0G74M9nm+VWmj+iJV2igBvG@lists.linux.dev
X-Gm-Message-State: AOJu0YxJ5pMEhAkrWjIEgRfj9n+3dmETDqAfw7OcjR0kbhPFzfovRWUa
	GnxJsmbuHRmb2aB3t6LOeEQFLGkNOfCGGJrLwh2SITp2CRzgeZng55AKB/SmWokYGqq00RpE2PH
	1JuOdHmvRgIHVVXbrJlM3QFWj8Kd6XkW1s4Y6
X-Gm-Gg: ASbGncu3++JRbR5hUleWd8YrJy5tweuAsy5UsybudzvPckY3grpwcFY6Qal2MOkDsLS
	Wb5bXZ+DgBQVSd5tlVWd6ZMiADGsZcTjNzfQUz7helAJVBJsItqj8JvAHEvlPI6/mklvfk1j1Fi
	mB/SOtaS0Zv+pfoPAs8ixON92ciaS0E7Rivm90CbtFNAM8MfkcMYFTJs7a
X-Google-Smtp-Source: AGHT+IEk6318AFfc1LcVsJJ84wt3g9PnbPRWzDdM7m2/xTI/OwzWoyIK3cmNaUT7+G0p9cZPZuhg9T+sy8bKgxhf/+k=
X-Received: by 2002:a5d:5f91:0:b0:38f:3c8a:4bf4 with SMTP id
 ffacd0b85a97d-390ec7cd27fmr9441896f8f.6.1740989162420; Mon, 03 Mar 2025
 00:06:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org>
In-Reply-To: <20250301231602.917580-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 3 Mar 2025 09:05:49 +0100
X-Gm-Features: AQ5f1JrxAQw0Rq7Ilhd1yFsj2dY9VjMUraWB3QJMgYSvaEWDQVWq8PuNQusYF1c
Message-ID: <CAH5fLgjhMfk1vZCc242vKYnTN13Ss23VhVhaAjwU67Z5qhP9mA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/panic: use `div_ceil` to clean Clippy warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, =?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 12:17=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> Clippy warns:
>
>     error: manually reimplementing `div_ceil`
>        --> drivers/gpu/drm/drm_panic_qr.rs:548:26
>         |
>     548 |         let pad_offset =3D (offset + 7) / 8;
>         |                          ^^^^^^^^^^^^^^^^ help: consider using =
`.div_ceil()`: `offset.div_ceil(8)`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#manual_div_ceil
>
> And similarly for `stride`. Thus apply the suggestion to both.
>
> The behavior (and thus codegen) is not exactly equivalent [1][2], since
> `div_ceil()` returns the right value for the values that currently
> would overflow.
>
> Link: https://github.com/rust-lang/rust-clippy/issues/14333 [1]
> Link: https://godbolt.org/z/dPq6nGnv3 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
