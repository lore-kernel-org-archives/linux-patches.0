Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB661C3C1F
	for <patches@lists.linux.dev>; Sun,  4 May 2025 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746379801; cv=none; b=taieoxZndxe98nWpRldRdt4dKXLmcNPdv+w+JWGdU4PTdcWx+O9pUU8ayzRiS9E6/4ozARGLjMAlUAACVELayHWXI+Y/EjBazoKGqLbQ1UYvW1C2xK2gZdJSm2QfKanO2OE6RsIjsB9nP6mzPIaNw27EY+OybfMUV3aDi+VTN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746379801; c=relaxed/simple;
	bh=UPZ/v/zVDaKn23W0QWjzgIyPsVG8PE2v13VVOn3wiUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJXNgeYV+tENaymYINvp5j0uKwGRaNA+ioXQDNCvdJsi+06p0TC0fB5ectVc6OnqZD7T3jBpvWJ2MtA2Bjb/QueZbsgchw/+/pWqzN6TViyZGCymLbKSgxTAQz4fHl7OV/MM0GJXJc0MdCtrbm4P4QxSij97G9pAChU1Ol7KM9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EP3fM0cd; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP3fM0cd"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30c2d427194so32433171fa.0
        for <patches@lists.linux.dev>; Sun, 04 May 2025 10:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746379797; x=1746984597; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqaANv92m4hTYV8OL5ZcTItvvIMVs56xMsm33zu7CQg=;
        b=EP3fM0cdiZZRMr1/zGmZCv9fQftXANpyS0e8VQTSREk2ojeB8cYimhb+TkR7pUdeQe
         scLFA4R9zM3LfevrSX0Rh6iKGRFcpB7Ur2Ue+P6HGbTnS4NjEy0Bopll++evdQCqJOl5
         4uzipUH46XBbwDw4vQzqePlk64bLMIG1UXm6xNqp4dgUUMQpchx94dBEYKtkXnuH0GQa
         c0IxpRscvHdUMDLXDviKgw30Nyb9yk9AEnlstS/35R5XSt5Mu4NG8hAokwmiQB6dyr16
         touJRzNY4LHk8/WA011hoPEpsLOgTsUnEJpF869dC7GVXLoKweYpMPQmWiskuun8Io9s
         r1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746379797; x=1746984597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqaANv92m4hTYV8OL5ZcTItvvIMVs56xMsm33zu7CQg=;
        b=Z0BHR4oEkroUpzmu7546cZ89070QqDO8rgR4YBcPYUZ4Bu72Mzrm+tJNa8AkWmdjgO
         AKVe0w4WncxjmTfExZ87nWV66DmH8glCbnZfx8L0ZAd/Ud1kmV+8hfMRtVBD0AWgxVW4
         7+t9kjonkqdPPzXx3TB1z1m86rTlgGJiYwgZ3h8fGX09szXgdyLioo8AEiUDmMbEpspo
         i1ze1SitvgKkW9ItNA1uQhFIuYupBdl/ieNjgRjuhMoji8v/yInOWf4LSnoUOKaAkNwb
         Ct07+mlBX1LvylCwcKuifdEKiXOMRRYQWfg0jGuo8SvVGO8Vhi9VYZGR4lAXr4PZh6No
         r48g==
X-Forwarded-Encrypted: i=1; AJvYcCWWYYFcwk9RtR+kd/YtBwax9IFxr/jw1ZEuUgbPRt+pQ2FHMSR/bqKSC5tMP4gNZPDgXl+V/Od3@lists.linux.dev
X-Gm-Message-State: AOJu0YyazTuB0NpiNfpwDL2S+5yKXsAzJdSF9xdTyhKNBprZ5tD683Ze
	nBKDb7/gBwshRwUqguZwmiYQJaO4A/c2LPfDAM39/P5w14C5eMy2oI/7dggKYiyMw7Imj0nuSNx
	LSvlnu9UqD0gtPq0Xan8s2Suf8DE=
X-Gm-Gg: ASbGncuVrLfvL5N4py/Nh9u7ruwIjdRfHgJzN+v5zcotJ2Fx13Yg3yPJIEA07vHO3Q8
	R3ERVrXazPyKRk++2YEQPx8dCqdHMg3cmJFVxlkhfS2mfoDUMRIlpmzbAxFBc+jJXt3cKJ/lkr8
	l8TKAzHnHT5+N+WGUCZCkEjgAx4eOgYo/bF1ZDXwAfuByZ/5CiJGO0Xk8=
X-Google-Smtp-Source: AGHT+IHFwQGId/qg0kBW+KYdkOs+J3tWLMwK0WAbCd1RELh3Re9uudfVzggOVnYlLipmaOIsCQoGNE89jzqxeW1+l7o=
X-Received: by 2002:a05:651c:b25:b0:30c:719:1145 with SMTP id
 38308e7fff4ca-320c44e62d7mr27278341fa.17.1746379796945; Sun, 04 May 2025
 10:29:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-6-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-6-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 4 May 2025 13:29:19 -0400
X-Gm-Features: ATxdqUHy3xw0YS_UixKAyjECkzgBxuNPadNnJTHr2K-h1SUeIdIon-i0DKnWu9Y
Message-ID: <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] rust: str: take advantage of the `-> Result` support
 in KUnit `#[test]`'s
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

On Fri, May 2, 2025 at 5:54=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Since now we have support for returning `-> Result`s, we can convert some
> of these tests to use the feature, and serve as a first user for it too.
>
> Thus convert them.
>
> This, in turn, simplifies them a fair bit.
>
> We keep the actual assertions we want to make as explicit ones with
> `assert*!`s.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Alice pointed this out in another thread but: one of the downsides of
returning Result is that in the event of failure the line number where
the error occurred is no longer contained in the test output. I'm =F0=9F=91=
=8E
on this change for that reason.

> ---
>  rust/kernel/str.rs | 68 ++++++++++++++++++++--------------------------
>  1 file changed, 30 insertions(+), 38 deletions(-)
>
> diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
> index cf2caa2db168..8dcfb11013f2 100644
> --- a/rust/kernel/str.rs
> +++ b/rust/kernel/str.rs
> @@ -576,25 +576,9 @@ macro_rules! c_str {
>  mod tests {
>      use super::*;
>
> -    struct String(CString);
> -
> -    impl String {
> -        fn from_fmt(args: fmt::Arguments<'_>) -> Self {
> -            String(CString::try_from_fmt(args).unwrap())
> -        }
> -    }
> -
> -    impl Deref for String {
> -        type Target =3D str;
> -
> -        fn deref(&self) -> &str {
> -            self.0.to_str().unwrap()
> -        }
> -    }

These changes don't depend on returning `Result` from the tests
AFAICT. Can they be in a separate patch?

> -
>      macro_rules! format {
>          ($($f:tt)*) =3D> ({
> -            &*String::from_fmt(kernel::fmt!($($f)*))
> +            CString::try_from_fmt(kernel::fmt!($($f)*))?.to_str()?
>          })
>      }
>
> @@ -613,66 +597,72 @@ macro_rules! format {
>          \\xf0\\xf1\\xf2\\xf3\\xf4\\xf5\\xf6\\xf7\\xf8\\xf9\\xfa\\xfb\\xf=
c\\xfd\\xfe\\xff";
>
>      #[test]
> -    fn test_cstr_to_str() {
> +    fn test_cstr_to_str() -> Result {
>          let good_bytes =3D b"\xf0\x9f\xa6\x80\0";
> -        let checked_cstr =3D CStr::from_bytes_with_nul(good_bytes).unwra=
p();
> -        let checked_str =3D checked_cstr.to_str().unwrap();
> +        let checked_cstr =3D CStr::from_bytes_with_nul(good_bytes)?;
> +        let checked_str =3D checked_cstr.to_str()?;
>          assert_eq!(checked_str, "=F0=9F=A6=80");
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_cstr_to_str_invalid_utf8() {
> +    fn test_cstr_to_str_invalid_utf8() -> Result {
>          let bad_bytes =3D b"\xc3\x28\0";
> -        let checked_cstr =3D CStr::from_bytes_with_nul(bad_bytes).unwrap=
();
> +        let checked_cstr =3D CStr::from_bytes_with_nul(bad_bytes)?;
>          assert!(checked_cstr.to_str().is_err());
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_cstr_as_str_unchecked() {
> +    fn test_cstr_as_str_unchecked() -> Result {
>          let good_bytes =3D b"\xf0\x9f\x90\xA7\0";
> -        let checked_cstr =3D CStr::from_bytes_with_nul(good_bytes).unwra=
p();
> +        let checked_cstr =3D CStr::from_bytes_with_nul(good_bytes)?;
>          // SAFETY: The contents come from a string literal which contain=
s valid UTF-8.
>          let unchecked_str =3D unsafe { checked_cstr.as_str_unchecked() }=
;
>          assert_eq!(unchecked_str, "=F0=9F=90=A7");
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_cstr_display() {
> -        let hello_world =3D CStr::from_bytes_with_nul(b"hello, world!\0"=
).unwrap();
> +    fn test_cstr_display() -> Result {
> +        let hello_world =3D CStr::from_bytes_with_nul(b"hello, world!\0"=
)?;
>          assert_eq!(format!("{}", hello_world), "hello, world!");
> -        let non_printables =3D CStr::from_bytes_with_nul(b"\x01\x09\x0a\=
0").unwrap();
> +        let non_printables =3D CStr::from_bytes_with_nul(b"\x01\x09\x0a\=
0")?;
>          assert_eq!(format!("{}", non_printables), "\\x01\\x09\\x0a");
> -        let non_ascii =3D CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0").=
unwrap();
> +        let non_ascii =3D CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0")?=
;
>          assert_eq!(format!("{}", non_ascii), "d\\xe9j\\xe0 vu");
> -        let good_bytes =3D CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\=
0").unwrap();
> +        let good_bytes =3D CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\=
0")?;
>          assert_eq!(format!("{}", good_bytes), "\\xf0\\x9f\\xa6\\x80");
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_cstr_display_all_bytes() {
> +    fn test_cstr_display_all_bytes() -> Result {
>          let mut bytes: [u8; 256] =3D [0; 256];
>          // fill `bytes` with [1..=3D255] + [0]
>          for i in u8::MIN..=3Du8::MAX {
>              bytes[i as usize] =3D i.wrapping_add(1);
>          }
> -        let cstr =3D CStr::from_bytes_with_nul(&bytes).unwrap();
> +        let cstr =3D CStr::from_bytes_with_nul(&bytes)?;
>          assert_eq!(format!("{}", cstr), ALL_ASCII_CHARS);
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_cstr_debug() {
> -        let hello_world =3D CStr::from_bytes_with_nul(b"hello, world!\0"=
).unwrap();
> +    fn test_cstr_debug() -> Result {
> +        let hello_world =3D CStr::from_bytes_with_nul(b"hello, world!\0"=
)?;
>          assert_eq!(format!("{:?}", hello_world), "\"hello, world!\"");
> -        let non_printables =3D CStr::from_bytes_with_nul(b"\x01\x09\x0a\=
0").unwrap();
> +        let non_printables =3D CStr::from_bytes_with_nul(b"\x01\x09\x0a\=
0")?;
>          assert_eq!(format!("{:?}", non_printables), "\"\\x01\\x09\\x0a\"=
");
> -        let non_ascii =3D CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0").=
unwrap();
> +        let non_ascii =3D CStr::from_bytes_with_nul(b"d\xe9j\xe0 vu\0")?=
;
>          assert_eq!(format!("{:?}", non_ascii), "\"d\\xe9j\\xe0 vu\"");
> -        let good_bytes =3D CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\=
0").unwrap();
> +        let good_bytes =3D CStr::from_bytes_with_nul(b"\xf0\x9f\xa6\x80\=
0")?;
>          assert_eq!(format!("{:?}", good_bytes), "\"\\xf0\\x9f\\xa6\\x80\=
"");
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_bstr_display() {
> +    fn test_bstr_display() -> Result {
>          let hello_world =3D BStr::from_bytes(b"hello, world!");
>          assert_eq!(format!("{}", hello_world), "hello, world!");
>          let escapes =3D BStr::from_bytes(b"_\t_\n_\r_\\_\'_\"_");
> @@ -683,10 +673,11 @@ fn test_bstr_display() {
>          assert_eq!(format!("{}", non_ascii), "d\\xe9j\\xe0 vu");
>          let good_bytes =3D BStr::from_bytes(b"\xf0\x9f\xa6\x80");
>          assert_eq!(format!("{}", good_bytes), "\\xf0\\x9f\\xa6\\x80");
> +        Ok(())
>      }
>
>      #[test]
> -    fn test_bstr_debug() {
> +    fn test_bstr_debug() -> Result {
>          let hello_world =3D BStr::from_bytes(b"hello, world!");
>          assert_eq!(format!("{:?}", hello_world), "\"hello, world!\"");
>          let escapes =3D BStr::from_bytes(b"_\t_\n_\r_\\_\'_\"_");
> @@ -697,6 +688,7 @@ fn test_bstr_debug() {
>          assert_eq!(format!("{:?}", non_ascii), "\"d\\xe9j\\xe0 vu\"");
>          let good_bytes =3D BStr::from_bytes(b"\xf0\x9f\xa6\x80");
>          assert_eq!(format!("{:?}", good_bytes), "\"\\xf0\\x9f\\xa6\\x80\=
"");
> +        Ok(())
>      }
>  }
>
> --
> 2.49.0
>
>
