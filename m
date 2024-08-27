Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5FD1A073A
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724758193; cv=none; b=LwGGG+jYroUKGSAbpHwxJ1l3g3jHtiiR5HpAt5WLRsjsuTR+/jeqy6vOnsX42LExyGGLRH15+/tXzBefMZSsNCdruDYi7W/aipHAPYlfAXvIMXb5EJk2TkgshhpLi+/QePAAfo6spThfmS8tCX/Z0XMUi+FgV8laA5+UgEe6BcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724758193; c=relaxed/simple;
	bh=+43B6/JbpVKu0hFl46VVj/w0OgSocDCI+2b3hAAyd4Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOW1dG38Kwoh+8u9n+id9VI0CuffytWBQMSvHeGCa1c8t3s3aXiBVjD/qvhOnS6MgAyieVVTvCaQI1tpRP9rHidVPENQQpPObd2YUVvM5eNafYAvgfCOGKvvdb1nHOkLi5PbShTcc+e0a4qI6D4p7ntjcW6dUpvh7zLXKMmaGNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=HckPVHkb; arc=none smtp.client-ip=185.70.40.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="HckPVHkb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=qibilhcbmvcwtkwa7t56s2jbyu.protonmail; t=1724758189; x=1725017389;
	bh=UD1URxsfhMWiJnrxLbXbQXgJOaPyOvPDnAzrg556c7I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=HckPVHkb+8WeMdxC4PWwJK0Ki3rgWST/8VqKG6lmFm7lNbviv07Fv6TRfWhfP7281
	 q5reFWa8TsnGwbkUm1bSRrYmqw+2OV1OhdI7mggAqDMPppro1PgcaO/BHXWB/JyRaU
	 J9dqj7quKUUtGLTExve8LyDwL2WeeLZbeCEGHR4qAf8VhH6gfmqH/zS7oGJ+SQg/HG
	 YKr6YyKlMVI4PFJoVbwXETKGhiNZETRmp5NvDjmcudY5dcQoV6iJE7rvnndyxegxCL
	 AJWHAr5sXKMs9HglZPp3ODVGnqDDRbrhODlheWaMGKicd3ROZhmn3P3VKNcENrl9eY
	 aOYEfzbFsHIcQ==
Date: Tue, 27 Aug 2024 11:29:43 +0000
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: allow `stable_features` lint
Message-ID: <ab399fac-4b10-4ed9-ac28-55797a17fff2@proton.me>
In-Reply-To: <CAH5fLghhgWdJHdOR7TYwGADecsqBtOF08+S4v3RimeFsqvdfuw@mail.gmail.com>
References: <20240827100403.376389-1-ojeda@kernel.org> <CAH5fLghhgWdJHdOR7TYwGADecsqBtOF08+S4v3RimeFsqvdfuw@mail.gmail.com>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: 1f32787fee00135068b97665210541854ede4f56
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 27.08.24 12:39, Alice Ryhl wrote:
> On Tue, Aug 27, 2024 at 12:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> =
wrote:
>>
>> Support for several Rust compiler versions started in commit 63b27f4a007=
4
>> ("rust: start supporting several compiler versions"). Since we currently
>> need to use a number of unstable features in the kernel, it is a matter
>> of time until one gets stabilized and the `stable_features` lint warns.
>>
>> For instance, the `new_uninit` feature may become stable soon, which
>> would give us multiple warnings like the following:
>>
>>     warning: the feature `new_uninit` has been stable since 1.82.0-dev
>>     and no longer requires an attribute to enable
>>       --> rust/kernel/lib.rs:17:12
>>        |
>>     17 | #![feature(new_uninit)]
>>        |            ^^^^^^^^^^
>>        |
>>        =3D note: `#[warn(stable_features)]` on by default
>>
>> Thus allow the `stable_features` lint to avoid such warnings. This is
>> the simplest approach -- we do not have that many cases (and the goal
>> is to stop using unstable features anyway) and cleanups can be easily
>> done when we decide to update the minimum version.
>>
>> An alternative would be to conditionally enable them based on the
>> compiler version (with the upcoming `RUSTC_VERSION` or maybe with the
>> unstable `cfg(version(...))`, but that one apparently will not work for
>> the nightly case). However, doing so is more complex and may not work
>> well for different nightlies of the same version, unless we do not care
>> about older nightlies.
>>
>> Another alternative is using explicit tests of the feature calling
>> `rustc`, but that is also more complex and slower.
>=20
> You mention a bunch of alternatives, but I agree that this is the best
> way forward. It's very simple. Only possible disadvantage could be if
> we forget to remove features when raising the MSRV, but I don't think
> that's a big risk.

What even are the risks associated with enabling an already stable
feature?

---
Cheers,
Benno

