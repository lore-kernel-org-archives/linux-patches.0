Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44169221F14
	for <patches@lists.linux.dev>; Sun,  4 May 2025 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746380049; cv=none; b=oqIdrYpxkAoZKZdB2MK/z36d44wrsyPceLs9nuS7ALHhv8SWj3w9pf7PD0JoboPFLhkaKJ9fsWnBFM9+B62iA+31r8HBVEkZcNJpNb9td1Ar2UJTNFJeWO/GjRN+GeW90cL/OKFncwSwLZLeEZ+bMGlc9KUJ9EdmiyBsawWhgVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746380049; c=relaxed/simple;
	bh=TI+IAdyGi+IL8Xy71Y9qCmSdPrRxiWOpnXzL5ViZOC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IwEqRguAmqoKxMnxiCnrtd++X+qvdomPUVYcc7CSAZRIGT4eN/4tDfJ8IXpOGmNKkdOfxQ2v9Xn0cMDoIX93E95KvXifjBx1qq6vMWmQ4RcerGYCauIGEWsmP/ZVPQ05Qyhjc4G8tvCE6vdsQNFSbkB0XcrE2/yAUx0DvOZQ0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SD00VhcT; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SD00VhcT"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30c44a87b9cso29548791fa.3
        for <patches@lists.linux.dev>; Sun, 04 May 2025 10:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746380045; x=1746984845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1fVaVItBBDC1ZD6iIEWvvKbSsgQoZnhQOhbzKdtWXs=;
        b=SD00VhcTU/iJjuEFDNRe1CJuswnv+9FLQ8Ay+/RMr8D0ja9qh6uub6w3OobAzqXY+c
         ed4CtGzuSmkhxfMtr0Y3Cmh9IA9a2RxDaygoSzeQxo2wCOuOGu3n6xFgZazgAO9nUrsd
         fh/BR4VmA7tP8+UgvPPX/j06MNU5JziZmAensqM1JDHWGrVdW1OADR3KTFYFqUaDjxbz
         TnmH1KcawWAOdpl8wqRR9DT1SGbARd2S8KlhiLdJYZOwMvS0LCOAzRfiUtVZm8WD2stx
         2BlLHEgqxoakYyFw26FOPWIJ/L1rBMQfMNbSZCCDFojxifHcxiMlDbSrX7l8XZntmaHa
         QAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746380045; x=1746984845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1fVaVItBBDC1ZD6iIEWvvKbSsgQoZnhQOhbzKdtWXs=;
        b=vYZSGqBSrWVwWP02eEMgbruV22D2ZYY0sIUB5eusJNRfnLu63KEnE91RXhR0U8D8FU
         /282D5JiR6IpNjl0cJIR8pa4WY5wck7JTKogFjYF8QVU757D+V7ZansJ+VhjGNUm8If+
         UXUjFqxoE8mgtn1rQ1wIuR5jVml5LGIT3orDJrEcJzYNY1kxNF0NCh6nSQtXRXJoetMN
         +6mu/MA5hAHN+81g5o5BHGnqxdsi3x4cDTBfomCRm3o8cDCGlGXQjja9OAqoVCJoCXa1
         7Si1desBu5zGcwzGZLA3ZO1sEwCPaAqHZxiA3TL5KMnhWkIT5vg4YawZlJy849Bcb7NA
         5YEw==
X-Forwarded-Encrypted: i=1; AJvYcCUu35zVs89o8aI/OAskTh6daFv8m4oOwHx0xtFigqEQr9u3/97F24hQ9xeSpE/y3YKSXa6tIPDi@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0vKseuPmXwo3SnLozNGK86KXidWWMqDTsg5Vtt5gRJU+bactH
	SDqqRyX3mVTsTYU/aG4+ieYaLeheBXNwo05vImtHmMT6OojzTzFExmEQDtN3cWQCfwL7clp27AV
	iibwhNV3WTyjM3YFKwp+r2ZNLYhg=
X-Gm-Gg: ASbGncuE1eA+18KnChGqm+9kzRgEg/44SPuVDFASUjdagA6YwS+dpR4E9ZY1Vld1mie
	V2SoLiMkJTf+pv7ddV0rVA/YmK7vQZtFR7vKBm51cJOFe/Q/tF8G6YhWjtynsC/767gngJ18wIr
	iu3fcmNQnfIFAdeASDu1CIdhT3097OO/OjufFJhHaVxTErwJda2GWa5bM=
X-Google-Smtp-Source: AGHT+IHjlg5r+GtZPby1N3y/lBB/JYkis+ONns+ydoYTgWyGUU7+7O4MuOnenH2xOKWDCtegS00Wd//KowDVF/l59is=
X-Received: by 2002:a2e:be1b:0:b0:308:fbd5:9d2d with SMTP id
 38308e7fff4ca-323525056damr11809611fa.37.1746380045047; Sun, 04 May 2025
 10:34:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-3-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-3-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 4 May 2025 13:33:28 -0400
X-Gm-Features: ATxdqUGeVFcwO9nOZqJQZmUYd49yvR_Ewg1ZcZNRyKblGfpu9Gz2cSxTrocB1zc
Message-ID: <CAJ-ks9=v8E_bV+oJ-bdm3KZW2dfrFdiCmeVLs+bgK8oVu6BCUA@mail.gmail.com>
Subject: Re: [PATCH 2/7] rust: kunit: support checked `-> Result`s in KUnit `#[test]`s
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 5:53=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Currently, return values of KUnit `#[test]` functions are ignored.
>
> Thus introduce support for `-> Result` functions by checking their
> returned values.
>
> At the same time, require that test functions return `()` or `Result<T,
> E>`, which should avoid mistakes, especially with non-`#[must_use]`
> types. Other types can be supported in the future if needed.

Why not restrict this to Result<(), E>?

>
> With this, a failing test like:
>
>     #[test]
>     fn my_test() -> Result {
>         f()?;
>         Ok(())
>     }
>
> will output:
>
>     [    3.744214]     KTAP version 1
>     [    3.744287]     # Subtest: my_test_suite
>     [    3.744378]     # speed: normal
>     [    3.744399]     1..1
>     [    3.745817]     # my_test: ASSERTION FAILED at rust/kernel/lib.rs:=
321
>     [    3.745817]     Expected is_test_result_ok(my_test()) to be true, =
but is false

Is it possible to include the error in the output?

>     [    3.747152]     # my_test.speed: normal
>     [    3.747199]     not ok 1 my_test
>     [    3.747345] not ok 4 my_test_suite
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/kunit.rs | 25 +++++++++++++++++++++++++
>  rust/macros/kunit.rs |  3 ++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
> index 2659895d4c5d..f43e3ed460c2 100644
> --- a/rust/kernel/kunit.rs
> +++ b/rust/kernel/kunit.rs
> @@ -164,6 +164,31 @@ macro_rules! kunit_assert_eq {
>      }};
>  }
>
> +trait TestResult {
> +    fn is_test_result_ok(&self) -> bool;
> +}
> +
> +impl TestResult for () {
> +    fn is_test_result_ok(&self) -> bool {
> +        true
> +    }
> +}
> +
> +impl<T, E> TestResult for Result<T, E> {
> +    fn is_test_result_ok(&self) -> bool {
> +        self.is_ok()
> +    }
> +}
> +
> +/// Returns whether a test result is to be considered OK.
> +///
> +/// This will be `assert!`ed from the generated tests.
> +#[doc(hidden)]
> +#[expect(private_bounds)]
> +pub fn is_test_result_ok(t: impl TestResult) -> bool {
> +    t.is_test_result_ok()
> +}
> +
>  /// Represents an individual test case.
>  ///
>  /// The [`kunit_unsafe_test_suite!`] macro expects a NULL-terminated lis=
t of valid test cases.
> diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
> index eb4f2afdbe43..9681775d160a 100644
> --- a/rust/macros/kunit.rs
> +++ b/rust/macros/kunit.rs
> @@ -105,8 +105,9 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: Toke=
nStream) -> TokenStream {
>      let path =3D crate::helpers::file();
>      for test in &tests {
>          let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapper_{}", t=
est);
> +        // An extra `use` is used here to reduce the length of the messa=
ge.
>          let kunit_wrapper =3D format!(
> -            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kun=
it) {{ {}(); }}",
> +            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kun=
it) {{ use kernel::kunit::is_test_result_ok; assert!(is_test_result_ok({}()=
)); }}",
>              kunit_wrapper_fn_name, test
>          );
>          writeln!(kunit_macros, "{kunit_wrapper}").unwrap();
> --
> 2.49.0
>
>
