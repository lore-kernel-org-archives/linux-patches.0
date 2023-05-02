Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60BB8F62
	for <patches@lists.linux.dev>; Tue,  2 May 2023 18:05:55 +0000 (UTC)
Date: Tue, 02 May 2023 18:05:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1683050746; x=1683309946;
	bh=znP+osTE6o5AJ/qvNTfPmzh+zPk8QH79B6JsIRrwNuA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=l3A8wvNYGDLcC28ydvG/pfcymsjWjUmOqECSmGEVnXNt9j//sHKxmyTHSjgYngZgJ
	 CvGT/32QrU9mR9wVpjdPEObBZKph3hZsYNA4pgHKACtmqM7zkzzg3ou7rAYKESlokE
	 Pq5FwaBzWokMSF7oic8i0avf87th5+u5dzXE4jepOGdfFI9+SkjHwj7WFfmify2/UL
	 ipfrxpGlrwkW/oKRqLuYozja6DhMo2cHfE82wfQFZ1ds0J7+/TSnbJCRgokSQ6D4cZ
	 ncBoMajboMugZz5XbkovvxLdi/RUc2PC4MPdtTFpkI4RMpIEMkaKBhRw4k9m0Il9+Q
	 BSmOkKPoA27yQ==
To: Alice Ryhl <aliceryhl@google.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: error: allow specifying error type on `Result`
Message-ID: <Er7lvaSfICjicKWuIRGmTFh0P6hhG2fXUcky3Nt-Gr4XghX46r4bR9vUlggldACzw8CasUm6TuXT4U0Yxqh5tJsdctOPuDDysBTarB6FENc=@proton.me>
In-Reply-To: <20230502124015.356001-1-aliceryhl@google.com>
References: <20230502124015.356001-1-aliceryhl@google.com>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02.05.23 14:40, Alice Ryhl wrote:
> Currently, if the `kernel::error::Result` type is in scope (which is
> often is, since it's in the kernel's prelude), you cannot write
> `Result<T, SomeOtherErrorType>` when you want to use a different error
> type than `kernel::error::Error`.
>=20
> To solve this we change the error type from being hard-coded to just
> being a default generic parameter. This still lets you write `Result<T>`
> when you just want to use the `Error` error type, but also lets you
> write `Result<T, SomeOtherErrorType>` when necessary.
>=20
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   rust/kernel/error.rs | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index 5f4114b30b94..01dd4d2f63d2 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -177,7 +177,7 @@ impl From<core::convert::Infallible> for Error {
>   /// Note that even if a function does not return anything when it succe=
eds,
>   /// it should still be modeled as returning a `Result` rather than
>   /// just an [`Error`].
> -pub type Result<T =3D ()> =3D core::result::Result<T, Error>;
> +pub type Result<T =3D (), E =3D Error> =3D core::result::Result<T, E>;
>=20
>   /// Converts an integer as returned by a C kernel function to an error =
if it's negative, and
>   /// `Ok(())` otherwise.
>=20
> base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
> --
> 2.40.1.495.gc816e09b53d-goog
>=20

