Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875C13DDAE
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760900486; cv=none; b=ZB7tGFT+hx96kKqpb+p6jeFyzlBzLkRF1CvQ3IVjuPobVziSGwBn1mx72LG9Qevbl1i+1L/ZroxipZelNz5GloYI8A2TxXM5bcbQ+AamMRZs2yK4BhkOT0yojV/K2iL+jI9EfJaYAO4Aid1ELnWl4xN0i4AzNFx6GFmDtn7f5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760900486; c=relaxed/simple;
	bh=N6oBlf88V+X4V5N7lbg0Z2/a2FgY0X2uO4yeWGr/fH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hNWH0nFeQIUfY6s+QgSHGTTIvzehoszo+th+HZIh4SDZGViIKkrAG5OF2eH3hvlUmpNdqqCnYK/bsuEPJX39T/9a3VTGPhVq9C8WrTgfb2R0DDROWsk99ACsv4nm/NR/cEglDU/GZ9FSon5WjjI328H8EYVPTgGjIqWerc0WhbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLc9d2gX; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLc9d2gX"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33450918e4fso506346a91.1
        for <patches@lists.linux.dev>; Sun, 19 Oct 2025 12:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760900484; x=1761505284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0EJ7gzHyhyTuLiaSvoYLggBrx/bbuMIAVpkTav441jk=;
        b=YLc9d2gX8UFaTwK+mPrWF5ian/oZkMj5cCXi2kUEisA1J+teL6diXhuI47LsEmUNkA
         Xh1DvzTqXj3HUr+A0/mYFMb8VIOMsaCp5PPO4Gn5YNRyoTFxptuciEAKESCdW34t2Ny6
         KB5yWeYjnj/utUeuwKQeC/aVbekDGWxUqhxhsHTui4vAPrYkNdq4TuvkZs13Q9ptman5
         w6qhRCTcseoIz1Y1uU4JCO7H20N5s3f87Yt+ooEt+8Ak3y0LhkIu3wUtx0hM3EvhpADA
         PFiRF0X65BaLLbPJv9ypEC2nQuyunV/jNw2ZfJUd5s0LrwFPtQdFpgnZc8DocvLWM5+A
         UjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760900484; x=1761505284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0EJ7gzHyhyTuLiaSvoYLggBrx/bbuMIAVpkTav441jk=;
        b=SyXMwOSNYGC1hEulU/lMNwCsLJnmLLBHKcBg3oL26N2b65fWqIdfxbIsrAzgxYN8ko
         dZH33ZLEj1XCBNfCbS+IrAxSjhFhf+/w3PJ0WSbzaylJQOfIKjL/eLR+10MfKD+QgcII
         ScQJ6qM4pw6opT2RP4mumrrYhBvEt7pb3IOpeSb4bzZni4HoQ9jozI2taONsGvG5s5kf
         BnWwUdIVENWYWUggGcFgMp+teMRU88lTIMlckSnbdVZcab40sxAXjaoyHHk5GUwIXrmc
         UqfEesIUotxD3YjSWH80tRmG5fWuY+mJEqswIFokBuit8crCsQV7c6T64ukf4Dv0oyv9
         haXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4RCYcNH/cluTbcv6217PeAdvAbsUr2S4QG5lgu0LtTtMiQV6X8bypdiBqyDrY6K3NNSp3eXgs@lists.linux.dev
X-Gm-Message-State: AOJu0YxJRFt3CzQSIBKMNU+5rEQVbKaTu2lLrLWye15KJxU2SqS9wSa1
	S/p6Icjzda29X5S7OBvyrpxzrUfNUfnjomtUBUIXOoYGA/b2YCU948BjCAXArOD0UNxy+cg8UBa
	Bu1cyfw3p1vC3jLx7BmM7qp0WEcZHOnE=
X-Gm-Gg: ASbGnctWlhMdt5DMJEu1bxpwGhmf7gFAwHJBkeW8RZAeOuL7bzhTWQx70U1mhoG9dPt
	/B3dmtMH0X1P5gjNY46k3+QSEdwUokD9lGTkdxPGgB/e+2l4cxvwq+L6FWEi5nZJ6AFiQSPBRAk
	Khte3GFoWIFfASl9hBcTbDFYJdpppP5AP/mt4LYq61wLdQxpHuY9X3aE/fO5JnsAsr8NPezNvF7
	IxQtrGmquieWOLDTVn5vy+UPuqxhl+KZ/X3hda+a0lgWvMQipnOvgglr9x9Xv+zubFM9uZBgM+8
	ACm2gxBQ6F1xa40zPjQyFXbYyU4XleUNV4L8T+szVGx0r+FELIW6/fkAL30AaLIhDq8d829YFTs
	30dk=
X-Google-Smtp-Source: AGHT+IH01Zp7Kv3YR610YIrHBC7qgKnb4bJrOZJOKSp2IPxLyP7uL/gDGXWoA6wL1HkkjvVFr8A00rAVeHz/QkcsVMc=
X-Received: by 2002:a17:902:f550:b0:274:506d:7fe5 with SMTP id
 d9443c01a7336-290c9cfec04mr77331165ad.4.1760900484175; Sun, 19 Oct 2025
 12:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016232118.1419895-1-ojeda@kernel.org>
In-Reply-To: <20251016232118.1419895-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 19 Oct 2025 21:01:12 +0200
X-Gm-Features: AS18NWDyESJna8eLVVdolUWQrhFdWWW4rqvJ2M-P6m9yEz3NGpLoYYFNiU5MU9E
Message-ID: <CANiq72nFr0rfNpGfXGMrRVnvGtk0RdeLowvF1MciJbhbTQwLxQ@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: fix formatting
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Burak Emir <bqe@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Yury Norov <yury.norov@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 1:21=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> We do our best to keep the repository `rustfmt`-clean, thus run the tool
> to fix the formatting issue.
>
> Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formattin=
g
> Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
> Fixes: 0f5878834d6c ("rust: bitmap: clean Rust 1.92.0 `unused_unsafe` war=
ning")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> This one will go on top of:
>
>     https://lore.kernel.org/rust-for-linux/20251010174351.948650-1-ojeda@=
kernel.org/

For completeness: I applied this one together with the others and they
got merged by Linus. The tree is now again `rustfmt`-clean.

Thanks!

Cheers,
Miguel
