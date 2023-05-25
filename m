Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62D101E4
	for <patches@lists.linux.dev>; Thu, 25 May 2023 13:50:41 +0000 (UTC)
Date: Thu, 25 May 2023 13:50:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1685022631; x=1685281831;
	bh=zrKoenzJ8TmNRT2hbEcxAT6emLjyT9JVKNO/jWBLi6o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mqeKCYXMvIT3+oSAyZN/f5r8+cqY6dEblI8myjSOk+FrCmwaYy8qN2zxqCkLygIUm
	 3aFiNS8tng85MYyg6HAREuIAYhVAN9KdbGpgzZUEUo2Jt3z5PHDz1kjYxxkxawlgr4
	 m9zDqrgckSm3JHUtI1YGCAuJ0htGrZmx6jILccmnW6rMbIr67pX/6bt7XH/dmDdSHk
	 bjuxA9uf5hsze3/Y4MVTd6A4OHhp8KPOF3hWe+Byy9w9Fi1hMPUei76lXvNcBTuMY/
	 mxJr3Wi1YUHRIhBc/lqhl5zeTVtWdNozI/MoUh64jJbeLd0ZaHjkdpdbKn/NmGsB7n
	 QjsjuReNfpbXQ==
To: Alice Ryhl <aliceryhl@google.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Subject: Re: [PATCH v1 1/2] rust: sync: add `Arc::ptr_eq`
Message-ID: <8OGX9YR7yYJm2Wv91cDK7yCWzMfkP5k3fYARJsX9yFoXoIIsY7wDmT-6A7yl5KFphSKMZV3jExRfKNaBOJN2Uwv07-XzNSl78rUabPljec8=@proton.me>
In-Reply-To: <20230517200814.3157916-1-aliceryhl@google.com>
References: <20230517200814.3157916-1-aliceryhl@google.com>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/17/23 22:08, Alice Ryhl wrote:
> Add a method for comparing whether two `Arc` pointers reference the same
> underlying object.
>=20
> This comparison can already be done by getting a reference to the inner
> values and comparing whether the references have the same address.
> However, writing `Arc::ptr_eq(a, b)` is generally less error-prone than
> doing the same check on the references, since you might otherwise
> accidentally compare the two `&Arc<T>` references instead, which wont
> work because those are pointers to pointers to the inner value, when you
> just want to compare the pointers to the inner value.
>=20
> Also, this method might optimize better because getting a reference to
> the inner value involves offsetting the pointer, which this method does
> not need to do.
>=20
> Co-developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   rust/kernel/sync/arc.rs | 5 +++++
>   1 file changed, 5 insertions(+)
>=20
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index e6d206242465..274febe3bb06 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -221,6 +221,11 @@ impl<T: ?Sized> Arc<T> {
>           // reference can be created.
>           unsafe { ArcBorrow::new(self.ptr) }
>       }
> +
> +    /// Compare whether two [`Arc`] pointers reference the same underlyi=
ng object.
> +    pub fn ptr_eq(this: &Self, other: &Self) -> bool {
> +        core::ptr::eq(this.ptr.as_ptr(), other.ptr.as_ptr())
> +    }
>   }
>=20
>   impl<T: 'static> ForeignOwnable for Arc<T> {
>=20
> base-commit: ac9a78681b921877518763ba0e89202254349d1b
> --
> 2.40.1.606.ga4b1b128d6-goog
>=20

--=20
Cheers,
Benno
