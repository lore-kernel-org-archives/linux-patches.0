Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C99A2CA7
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 19:05:06 +0000 (UTC)
Date: Wed, 14 Jun 2023 19:04:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=t3bxowmyhbatjofkruyu6tb3o4.protonmail; t=1686769497; x=1687028697;
	bh=ZzMB/I+fAe8MxfXLN2JRLaBJJfxV8VQgZ+RlEYm3UyE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=gMcafESwqJuzACruJ4O9mlVNWzlmZ/JN/KP5+Gb7Dn25F9zWS0kUcWjDLwAjOOa4w
	 O25K4b1HcbH/5GkWPGk8uXr6q62yaIIPgDQhZPiyHAIXwWaaTwu0llnHxBRB1Z6bu6
	 XN7BgXUSrtB/quZbRg+M5h2B+UMoJXG3zITMzTKaI9hxFaFldJ5f8FlCH5cSbX2w0W
	 QyAy2ljp+kJHudFJe/cZFNZKojllnQy/hvbUIsbM9vNABQyybmaOxxpPfSol6vuAX6
	 2Q6/g88kRq0E3fBbohcuVAhI3cyajF74b94im5WsgQDrNQZ+R2Sg4UB9ocodMr4WcT
	 qQpJ8SyTsk+QA==
To: Gary Guo <gary@garyguo.net>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: make `UnsafeCell` the outer type in `Opaque`
Message-ID: <-MHKDYSM29ri6c9QKvSWSeFjWwM8yj6uNgAZ-2hMzY_vEokxnrcETWGTZtcNCmgmMwH4VLswDOtRWhjfVboo360PSTXxYjhiffD5B7CkkH0=@proton.me>
In-Reply-To: <20230614194255.1fb8f6c0.gary@garyguo.net>
References: <20230614115328.2825961-1-aliceryhl@google.com> <20230614194255.1fb8f6c0.gary@garyguo.net>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> > /// Gets the value behind `this`.
> > @@ -266,7 +266,7 @@ pub fn get(&self) -> *mut T {
> > /// This function is useful to get access to the value without creating=
 intermediate
> > /// references.
> > pub const fn raw_get(this: *const Self) -> *mut T {
> > - UnsafeCell::raw_get(this.cast::<UnsafeCell<T>>())
> > + UnsafeCell::raw_get(this.cast::<UnsafeCell<MaybeUninit<T>>>()).cast::=
<T>()
>=20
>=20
> This can just be `this.cast_mut().cast()` since all types involved are
> transparent.

I would advise against that, see [1]. It would be bad for people to
assume that one is always allowed to do that. I also like it explicit here.

[1]: https://github.com/rust-lang/unsafe-code-guidelines/issues/281

--
Cheers,
Benno
