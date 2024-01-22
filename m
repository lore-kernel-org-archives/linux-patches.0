Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C964CE11
	for <patches@lists.linux.dev>; Mon, 22 Jan 2024 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935461; cv=none; b=QsOmB/0SlPLeuptKZRmep50Z7XSO4udq+r+lHSJ75jddOTHOd+fac3VLQf6uwtexuKn+q0XugBnl/fcbkIP0C3dJogDsjWLJSt2zXUCzmiFcHiW8cAr1zOE+e/DjDcB3B/NDxV5zu0X+CaMJtb4smVD20FM7jpgAKkphhCrqDsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935461; c=relaxed/simple;
	bh=dbTjgoR71IIADj4OTs/qmqArIX3aIs/ADiasXrZWiOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gipV7YIzaFzAy3DcQCZ1WSEzneiolrQLBBV2JF1FFQCcTXhV1huPfmJHWGUrcipMXJj6TmtmPTe2i2f98URlTesAQk6FFFrRNyudrQzgtqvPpl8a3HDwr1GjPph8MdktGb1fGFPTXYHzCAdlZriRBEhs5liY5dZoof8mGvzeVIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8457sYZ; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8457sYZ"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5f0629e67f4so31912337b3.3
        for <patches@lists.linux.dev>; Mon, 22 Jan 2024 06:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705935459; x=1706540259; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbTjgoR71IIADj4OTs/qmqArIX3aIs/ADiasXrZWiOE=;
        b=Y8457sYZi9Cb7ZAf4qkTu0j1mNXHShTWpTQfM1BrnBWnNi+F4cuemoYi19wnYJBP39
         4GZrKLnkMBvPpSX6ytoKEp9kpqkn20T0aUfKCHsPpH1Ns66j0c/jBdx/K36H0jM+q1DH
         adqhZaKvV9iTopIEdXLVRQF5rdwf3vOAekVtIu5lBryyar2PiMzddZZhxZxe0ev5wJkG
         eL1wJflNpqEe2JvYukLKslnl/ebxO/N28PilBAawUIH8NO3tgndnayqLtKkh+RcVig5K
         vQbJ51a0Td8mgtvSQ4zsGnxoUbxA6+AqHNOXNCspCJ0f0VaBj3nxPeRMZlY6qHyU4R30
         bqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935459; x=1706540259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbTjgoR71IIADj4OTs/qmqArIX3aIs/ADiasXrZWiOE=;
        b=TrJLIaltUag05ORdhTW3bUsAdUoAxdP7v1ZO1L4uj3dzl/5vnHxaO0siKOkWYv8OfQ
         j18eggBhy1oX6QRVk3RkmKt9PX4/+5pzFEOw609QN7UcOk96OAhrSxT4JU3cT5muhbUx
         m/M/xXphuyGmPdto8+AUgm+eHwmuiYYoaBlyR6rhFSIPppE0U9qG3RAu1UcA5ISKrAod
         gVyfwWGp23c2dwrdMnGYq5nKce8JUX2rhqm4IYJEHd7PwlacVE/dyRCvdWLkRKG85fMf
         w6mJh6IiNyZIALXSPA79v+MhKuxpMYHwZEJ6y12aPBBhicrIt7h/un/We+gibAwsP0BS
         EdgA==
X-Gm-Message-State: AOJu0YzFDruMAVCG0b9jMRwT87KWZmShW3jgLo8S7pQumeBvWVfXLLBQ
	Eresz3VwLL0qMQdPhrHJ7kqbHY/RXjaznJISDnrqrc/8vjbplgfuPAGO1LA3jyiK5JbXP97ThkF
	7AhR6V8uL6wKfETsspOOT+Ie84eE=
X-Google-Smtp-Source: AGHT+IHnzUFy2p7+kzamAfzR3Cl3NIAZ1jewG5eGKn99WPEvuGAIsldzYT/dpEHMVi27978kTvLjmfmnsNil4jXRYOM=
X-Received: by 2002:a25:ac1c:0:b0:dc2:3562:d234 with SMTP id
 w28-20020a25ac1c000000b00dc23562d234mr2243208ybi.12.1705935458861; Mon, 22
 Jan 2024 06:57:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231224172128.271447-1-ojeda@kernel.org>
In-Reply-To: <20231224172128.271447-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 22 Jan 2024 15:57:27 +0100
Message-ID: <CANiq72nxur+5ms8QSUmFUcCU=RU0GYvkYggDvGxr4uowNEeSNg@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.75.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 24, 2023 at 6:21=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.74.1 to 1.75.0
> (i.e. the latest) [1].

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
