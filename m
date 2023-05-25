Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B60101E4
	for <patches@lists.linux.dev>; Thu, 25 May 2023 13:51:10 +0000 (UTC)
Date: Thu, 25 May 2023 13:50:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=5aoyqs344fhubkfvtkwrcry4xi.protonmail; t=1685022668; x=1685281868;
	bh=6YZpbdH442xI5ahkra+Rj8DusW4wlxrFG6pdXqv769o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cic8tsuMcaYjh0AMhivCkzsA+0kzurdnfjqVM765he8bkT8tkQgrvp089nwYJM+CV
	 d+5g0t8hYTSg+UVnh9GdmI8mJLILcuAojija4H84jbglWtt0EBe2Vn9aJKC/O+ndFc
	 enZU/AhuEDoBcJU1vjw3OcCmojJcjBzMj+SXv9FUe37Ha7+TUNuxFXiTj3g76iXmsX
	 rLbrf1JqGnl8uRanlVDMT5auqTdYbAvMWVpo1jB5AL8AKyijOWa7Wca+tgus1dozq4
	 krlOwEsJagjMUrOKP6xRyLSc607E20mjjNLUrOSJXWGbY4wyx0NkWBlEbrQbv1Mbcn
	 hz7mlX575i33w==
To: Alice Ryhl <aliceryhl@google.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Subject: Re: [PATCH v1 2/2] rust: sync: implement `AsRef<T>` for `Arc<T>`
Message-ID: <DT_8UBvti_dML0vOrXVfUwNnTjhHlhBsioFDBIudjzzxjJl1SCTHU6cn5qjmZj3wTt7r8R1PFDStDv2C2IAjMj4Ubbpy5r587LkyfJEa4VY=@proton.me>
In-Reply-To: <20230517200814.3157916-2-aliceryhl@google.com>
References: <20230517200814.3157916-1-aliceryhl@google.com> <20230517200814.3157916-2-aliceryhl@google.com>
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
> This trait lets you use `Arc<T>` in code that is generic over smart
> pointer types.
>=20
> The `AsRef` trait should be implemented on all smart pointers. The
> standard library also implements it on the ordinary `Arc`.
>=20
> Co-developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   rust/kernel/sync/arc.rs | 6 ++++++
>   1 file changed, 6 insertions(+)
>=20
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 274febe3bb06..9ec911e4a0c7 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -264,6 +264,12 @@ impl<T: ?Sized> Deref for Arc<T> {
>       }
>   }
>=20
> +impl<T: ?Sized> AsRef<T> for Arc<T> {
> +    fn as_ref(&self) -> &T {
> +        self.deref()
> +    }
> +}
> +
>   impl<T: ?Sized> Clone for Arc<T> {
>       fn clone(&self) -> Self {
>           // INVARIANT: C `refcount_inc` saturates the refcount, so it ca=
nnot overflow to zero.
> --
> 2.40.1.606.ga4b1b128d6-goog
>=20

--=20
Cheers,
Benno
