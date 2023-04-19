Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7902219D
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 12:31:14 +0000 (UTC)
Date: Wed, 19 Apr 2023 12:30:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1681907464; x=1682166664;
	bh=LbKgikniMFbDyFN2g7zWAoErWCoMlEFPq1fVjDbUYh8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=W+vrUebuJp1hiaq5J6Yn0guavbN34v+IU5fOapkRumgszhzjBMXFFFHcpMEbT0G4C
	 ZXKilDurS+3o5ptA5jQS/Mt0ddLeJJBmW66gZWd/IhQLVTt/XKOrWBEDEdp25Tzi+O
	 d9L3k23CouM0jZ6YjIHmogFZOgMjFN2oIEiAgM+FYH5osEj8L3xQ19wsYl9Vzp96KQ
	 kih/4GNsISO83sMmwiCenYVPMcDdca1S3NCmDJGv+ATJSXKPCGJzPOyNNtSM8BPwi6
	 HtNPG/fSeY2uDPVpPbRM2d1B73iFMPTDYxCGPwS8TiyMojBNzdU1dYChuOMz6y7F6j
	 pZtB11+AvOD4Q==
To: Miguel Ojeda <ojeda@kernel.org>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Masahiro Yamada <masahiroy@kernel.org>, Stephen Boyd <swboyd@chromium.org>, Jean Delvare <jdelvare@suse.de>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] .gitattributes: set diff driver for Rust source code files
Message-ID: <n1uzeazgD17rPkhbZbkXpMaba7JXVdm5YIzUzi18_8UKwUYtXOPgBBJePJ0VMMc4X8pEoLtA4ypsco4CQ1WPC_PIoPmQB9m1S3cAQOC5p_M=@proton.me>
In-Reply-To: <20230418233048.335281-1-ojeda@kernel.org>
References: <20230418233048.335281-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 19.04.23 01:30, Miguel Ojeda wrote:
> Git supports a builtin Rust diff driver [1] since v2.23.0 (2019).
>=20
> It improves the choice of hunk headers in some cases, such as
> diffs within methods, since those are indented in Rust within
> an `impl` block, and therefore the default diff driver would
> pick the outer `impl` block instead (rather than the method
> where the changed code is).
>=20
> For instance, with the default diff driver:
>=20
>      @@ -455,6 +455,8 @@ impl fmt::Write for RawFormatter {
>               // Amount that we can copy. `saturating_sub` ensures we get=
 0 if `pos` goes past `end`.
>               let len_to_copy =3D core::cmp::min(pos_new, self.end).satur=
ating_sub(self.pos);
>=20
>      +        test_diff_driver();
>      +
>               if len_to_copy > 0 {
>                   // SAFETY: If `len_to_copy` is non-zero, then we know `=
pos` has not gone past `end`
>                   // yet, so it is valid for write per the type invariant=
s.
>=20
> With the Rust diff driver:
>=20
>      @@ -455,6 +455,8 @@ fn write_str(&mut self, s: &str) -> fmt::Result =
{
>               // Amount that we can copy. `saturating_sub` ensures we get=
 0 if `pos` goes past `end`.
>               let len_to_copy =3D core::cmp::min(pos_new, self.end).satur=
ating_sub(self.pos);
>=20
>      +        test_diff_driver();
>      +
>               if len_to_copy > 0 {
>                   // SAFETY: If `len_to_copy` is non-zero, then we know `=
pos` has not gone past `end`
>                   // yet, so it is valid for write per the type invariant=
s.
>=20
> Thus set the `rust` diff driver for `*.rs` source files.
>=20
> Link: https://git-scm.com/docs/gitattributes#_defining_a_custom_hunk_head=
er [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

> ---
>   .gitattributes | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/.gitattributes b/.gitattributes
> index c9ba5bfc4036..2325c529e185 100644
> --- a/.gitattributes
> +++ b/.gitattributes
> @@ -2,3 +2,4 @@
>   *.[ch] diff=3Dcpp
>   *.dts diff=3Ddts
>   *.dts[io] diff=3Ddts
> +*.rs diff=3Drust
>=20
> base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
> --
> 2.40.0
> 
