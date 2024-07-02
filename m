Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6BB4CB23
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901692; cv=none; b=G5XFanZDR0zJn75/HNNJrKH9cDWxpL4rl9600CdCnYQsMSQ+qgR9XbVcVfpuilr25yGL4E9IhD2LNglb7i/Mj1sAQeHpPYQxUgi6Gcqse0jKEksxftNVCUkoniMU5vG8Ko1HT9l5HWO8sgIa9YgQITYSA/Kxg35r/JUrai3LL88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901692; c=relaxed/simple;
	bh=pJLbr97ZcJmIstk3829Yol82mUBfeqKgdCDrOnJSUWI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0BN6WM7HY7NFCXAZlkJQXkmW8gi0stEfqdirshhbeRoQiYA1+DpyxuMJgTioJ4XnXrZq8EZyigSMMdfwGEQke4+KSZirJ0/tkS4w7OMsS7LghjTpxQHcsNJHNPmSaJgvNTXafU7aePxC7KMat1imbSZfr0belzlYmB9IcJBiDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=D6c7imaR; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="D6c7imaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=abfdaa263rdfdi2xhukkc4emkq.protonmail; t=1719901689; x=1720160889;
	bh=1y0bYAfpS02/2yoYIaQkGAqT8Yh0A7VVxasMlNBr9yY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=D6c7imaRSYIfSQAujmH+l8zWYbhZBLs6rHp13COfMOxmJ9mRjx1cExIZ5ipUzfeKo
	 6wFMLqicLcBDjBw4L+8/mv0wtbq9wGYoWjK/S6hhGT5DKxF2il2JzHfCeZRxbyahSC
	 hscoe72Seybjano37IiuA8mxpWrZHrlBjdNCtXqFUY5W75uEcTSKoqfm62eONkFgrS
	 Jrq7PZikHNlaieufq96cVPOveE6wuqv677CCklETzDbVyKuUUYEni6a4yRochCq7qa
	 xjmA8oLKHl2VcQ3A8iTm8epJiSvD+CHq1R/fL6ay7A4JSeCiSJNLzicL9FMIQkfVYa
	 e8dQ66qVhD0RA==
Date: Tue, 02 Jul 2024 06:28:03 +0000
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 02/13] rust: init: simplify from `map_err` to `inspect_err`
Message-ID: <b379184a-c1ca-47b5-856f-62144edf3baf@proton.me>
In-Reply-To: <CANiq72kMaPm2OsGb3o0VUtdoMhSUoo8QEsCFzVjYFtCThvNJ1w@mail.gmail.com>
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-3-ojeda@kernel.org> <ap7u5hpgfdzYgTkobIleYc0uolBIsAVbq56CwMJG6k4x57wXeEtu4fpLpgSOvQtbJHvB6D0J1wlBaqDV-xt2owlVejhfABUv_ivILyJ2J9o=@protonmail.com> <CANiq72kMaPm2OsGb3o0VUtdoMhSUoo8QEsCFzVjYFtCThvNJ1w@mail.gmail.com>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: e08b99f84c62c4cfa206ef6818fc00e68acef6a6
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.07.24 23:58, Miguel Ojeda wrote:
> On Mon, Jul 1, 2024 at 10:05=E2=80=AFPM Bj=C3=B6rn Roy Baron
> <bjorn3_gh@protonmail.com> wrote:
>>
>> The formatting here is a bit weird. I would have expected the ) ending t=
he inspect_err call to be placed on a new line given that the unsafe block =
isn't placed on the same line as the start of the inspect_err call either. =
This seems to be a case where rustfmt mostly gives up on formatting. If I d=
eindent the comment and unsafe block rustfmt will keep it that way and if I=
 add a trailing space to the inspect_err line it will keep it and emit an e=
rror that it left behind trailing whitespace. Maybe add a block around the =
comment and unsafe block to make rustfmt work again?
>=20
> Benno: any preference here? Or even open coding it.

I would put the comment outside of the closure:

    let val =3D unsafe { &mut *slot };
    // SAFETY: `slot` is considered pinned.
    let val =3D unsafe { Pin::new_unchecked(val) };
    // SAFETY: `slot` was initialized above.
    (self.1)(val).inspect_err(|_| unsafe { core::ptr::drop_in_place(slot) }=
)

---
Cheers,
Benno

