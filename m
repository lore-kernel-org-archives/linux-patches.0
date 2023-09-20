Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782FC37153
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1695216454; x=1695475654;
	bh=PGDMuGdonWyqQS7tKOGrzkv2onBWctuAXKEGB2SBFGE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Hio3ZS9LsAQ9QNgq+GpyB08MIJ8QMb47XNleQ3WrEvgywj0O90+fvKcWC8x3dSdcr
	 puoG/i5QTjqXUR3NhAXUMxcjnna3RLviYn4xzkoIYXUPmMvVx/UtrK079/xOJDeFKq
	 ON0W2zSyOK53K78Qq3mcYyIDm4YJpRHCOYVtGL37cQCJa0ggtICGoA/esSKvSqyVTu
	 +2OK3W8ROtEv2LlFVacE2LYtuDsiJjpWOgRBaHBwJo6FcnzViUDgx7n1NFmIxems24
	 HbnS3mkHiQrlAF+VW0FtDC1eep6mINnJPvxJVfaomvjChR59TD52EnrPPIPONH5zCG
	 yxHCah82TNj3A==
Date: Wed, 20 Sep 2023 13:27:32 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] MAINTAINERS: add Maintainer Entry Profile field for Rust
Message-ID: <42e03dc3-fe08-a32d-1db4-31cfb25b71c5@proton.me>
In-Reply-To: <20230830165949.127475-2-ojeda@kernel.org>
References: <20230830165949.127475-1-ojeda@kernel.org> <20230830165949.127475-2-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30.08.23 18:59, Miguel Ojeda wrote:
> The `P:` field allows a URI, and we have been adding information
> on how to contribute to the Rust subsystem to our webpage for a
> while now (and other relevant topics, e.g. branches, third-party
> crates, Rust unstable features...).
>=20
> The webpage/document does not currently follow the headings of
> the Maintainer Entry Profile, but it does nevertheless answer
> some of the questions we have got so far from contributors and
> it covers partially some of the topics there.
>=20
> Thus link to our "Contributing" document [1].
>=20
> Link: https://rust-for-linux.com/contributing [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7c8088e9a11b..a27b673b01c3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18561,6 +18561,7 @@ S:=09Supported
>   W:=09https://rust-for-linux.com
>   B:=09https://github.com/Rust-for-Linux/linux/issues
>   C:=09zulip://rust-for-linux.zulipchat.com
> +P:=09https://rust-for-linux.com/contributing
>   T:=09git https://github.com/Rust-for-Linux/linux.git rust-next
>   F:=09Documentation/rust/
>   F:=09rust/
> --
> 2.42.0
>=20

Reviewed-by: Benno Lossin <benno.lossin@proton.me>


