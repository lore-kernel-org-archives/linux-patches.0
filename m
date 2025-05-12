Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9E1B4227
	for <patches@lists.linux.dev>; Mon, 12 May 2025 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057749; cv=none; b=DjErFAnONu6zaiXgXoChZEjapuRN9XLrwJKVhZQ5FTZo1UHece9TxHZAHhKOCtQF1goHnqhAurWdiVy8Hyw9ZNhD4ncbijz4zHOnZ0z3l4KI4p501bqFaA1dhg1JCmyl9iVWgDCPO7pYiLzK+FsdwQSimE+wRBrb03/QkQu6u58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057749; c=relaxed/simple;
	bh=ecOwOv/tl1SZggHfXmBR/Ac/gL88Z6uCeya51l7i5s4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QBe/jH5HSA4HmSBBurFN5bIVlE3JHLMq2RvmAWCc4t8HSP8T+RxLdpDUY00ykCZ5taLC7ZPzbNAIAJiPxCAAGYDeBEePIeX3hJqqH4QXeIfdYJ5h0UyMwYlzIYEjSziqBdr7cKKwcOVpHy35XyEQOxyikZF6kFOYGhsYsC2QxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OHt4eKoj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OHt4eKoj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-af90510be2eso321551a12.3
        for <patches@lists.linux.dev>; Mon, 12 May 2025 06:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747057747; x=1747662547; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecOwOv/tl1SZggHfXmBR/Ac/gL88Z6uCeya51l7i5s4=;
        b=OHt4eKoj6DYLCG5FONMIu/rL2QqcaRfJwotMzVz75T1GE47urMj6VJo/p1z/pru3te
         2+RJ4ltZxGfHnFMDzzchb4va5sKvQteAav68t/HqbAPn+N2iOEloML4NIpLgm4cIsjuL
         6Hk1Efy+5cO6ZesqdoT9CiPetHbslgwC3bbY70CpVQoutUIsp5Nshd7zV0gTrkOLj/Qs
         RHZTzcErjAU3HOV5ccKT6rmXQKib+XIepmOuPH9XHMTopeVPPH6lyeAVe8Q2TUsasbil
         XoxXfrPH9vTElqPFzFKy7+HIVklyt5lhBJHJ8sUMxMAOZzXcbMhZC+TO4oL6tzOZ4gJ1
         edvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747057747; x=1747662547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecOwOv/tl1SZggHfXmBR/Ac/gL88Z6uCeya51l7i5s4=;
        b=fXg7Fv7/Aj8PpZBXMOInwvSK9FXvJqNfY8lVIp6tMFXnOd2MCBU0hfEW7T+eS53B+d
         GANwbxwBWU1gjWiURn6qXLtJ8RK9da/XILSjf3YnJfDTpycPpMwLxx2Ej66miuWvQgVB
         upDo57VIhrFkSCVJmEq8GoNjQiQr3b4oDh3TTB1MwXPAN1ZzmehepnQXCntf9uC9pbZx
         /MEB4gMO+AzxzG22g7VT3AuIypgLpvG74FkduBYoxOSATSNN0QwfM6ax30SFeoZkHCNb
         +KlA4h4lHbbFz9ZFjmtdbfeMmYDvbYkTnFagn1yI+DRIS88BsyrKqER1x6HDXVHqWnkc
         I3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdhw/pmyh4BM4dzKqzXTp9ojImX+yPNM2T4+GK8n4XNo6KHHjuCJ9u96L2e//o5wJgbyij2bQ5@lists.linux.dev
X-Gm-Message-State: AOJu0YzHUtYzzCjmGNrTD7mkIg9FasEK2aRGE1UAF+zzwn3SpK7VdNef
	rck07RAnOVCYvkUoEPC8b+2QWpmRK6hCxTCbxCg0DN0Ldd49tk9tY20azxZnAVHkzmojCvrIzvu
	lDfA6reuUx2amrl1S27IHyJ1WXBM=
X-Gm-Gg: ASbGnctG0G/Z5aWevLeVmmGOpgqLdUyKhpT4DS699XiaaqB8tuIAYnRhUtS1GlNlaGL
	noauc67LthJ6k7Fo2qXt1/IX30+dLljLKoSrP1IRpT85IOS/cUYKizgGB2GmpSvsTrx+JvflfuN
	o4HgKHem27+NZ8Muqj4glDthZXobtfESIG
X-Google-Smtp-Source: AGHT+IHTTag+8vW0X11zkMUQsXFhHUEewmAyyfu0IIkctyB/3aBLXt/7xM6iegzN1p9dvov24n1X5WoMWcZY0VNXDjk=
X-Received: by 2002:a17:903:194f:b0:223:5c33:56ae with SMTP id
 d9443c01a7336-22fc917f6bemr67201325ad.11.1747057746917; Mon, 12 May 2025
 06:49:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429151445.438977-1-ojeda@kernel.org>
In-Reply-To: <20250429151445.438977-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 May 2025 15:48:54 +0200
X-Gm-Features: AX0GCFsxmjZElBhRtsW5XAzgsdGMIFmsa9C1Hm1k-1Jh5fb2q-AD7f9ja3wKR8I
Message-ID: <CANiq72=2ZLrQqzVznA5O=2SDdHHETWUtc0MiLHP_Bx7n=vzLqw@mail.gmail.com>
Subject: Re: [PATCH] rust: uaccess: take advantage of the prelude and
 `Result`'s defaults
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 5:15=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The `kernel` prelude brings `Result` and the error codes; and the prelude
> itself is already available in the examples automatically.
>
> In addition, `Result` already defaults to `T =3D ()`.
>
> Thus simplify.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
