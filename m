Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709241B3955
	for <patches@lists.linux.dev>; Mon,  5 May 2025 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746424945; cv=none; b=iew+giILtBEMLy2EXKR7xzsqGoGtmcsRLWOzfLF499aBRkNWvkBi+WgpJuiC6RsiGz8wov+DcOHsPk+fU5ywuXAt/fd29P9OckvpgQaAbSHzThj+Wk7GURjSb7e8xCTGlWCQVvrbFMoFErFzam24b4OHHz/AFSPY2BtYgx5e/DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746424945; c=relaxed/simple;
	bh=B0QjVnWAO/yyvcSCk2bKDa1ahF/k3a5NiQuPxyp2vIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JP6G6r/oit/J6OXVIyrIVIleqt/D0U/pDBFqUWvi5BeZ9IF9tAQtYWOQ6iV7WKZ6fwnUBEni+S2J44DFWimB1ADt0oNjH6HNfo1poEbbYF0V8IEOpWHhTp4IokAQmBuuQ0Dij+tHzjwsP40rh3foLfdYi4E6THB4ib1SQ3064HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rYd62OEx; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rYd62OEx"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6e8f8657f29so41616126d6.3
        for <patches@lists.linux.dev>; Sun, 04 May 2025 23:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746424942; x=1747029742; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=03A52pl8wZ8tsDZymwaXxsvz/K8nNmWFzlMw0k70i/U=;
        b=rYd62OExCmSrROZI9QsuJ9ZMnRLpCnryVASrDYtwjM2VOs8ejDC5fW24VN7Kt4ldB/
         EGiUrHKkTnazmZ9VHYW1/eXsAghtnDRu2ZufoeeM68qVYF33Uam7Zd3vaycAkGiB3CuH
         UGlCJkPaIJuzaTl/8YC/2pCiguHBoDk3dRDtrF5Z2mF2DrnC79HEMmrRpuNgIVeoysK/
         V7pczyWv4fI5XP7k3n3XlG31LNODaAQMEhvyPakF6pudSsfN34w4WDcf7HcJOg3ZHb0z
         nQs6zfvGRw7LIWkqBqyqmenvAvVKqySNzdNeSHYYQIXqHbEusIod5LaVWbCTJF8XNCCJ
         O8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746424942; x=1747029742;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03A52pl8wZ8tsDZymwaXxsvz/K8nNmWFzlMw0k70i/U=;
        b=MYb2wMqVXjqMoJiXHRiLAX9exE1hGbeUJt6E5e0q5zE0jmF7b8xbxaa1/GW/FJjfV0
         E2IhtIha7DiLWx/Ptgcf/BjhQ2Y3tayXa3ZYKGvju3+vZcwb7jD1hTGLm0x0u+06P8mS
         fUmGexVCWNbAP3CzXpnwz0LG4Nahz46fUP75f1YQ1Ukun0bRPSYUNYIaNLQm2ql50iQg
         0CwBfCK9GBnoUT1SkagBFQisv+sIlA5FPVNq18h2lP6nbzAcdwWDUkZDJqTcD169kxDE
         Q4e+fJDFmMI4S+C7XZi54iXRefkclD5tR7jTSJRfnFCmnkRkWFhg7Phsmu01i8coEZf7
         B5JA==
X-Forwarded-Encrypted: i=1; AJvYcCW5YUdyQUe40EoTvkxdiy4rjMM4KWYy7SkWeqCgdZgEVBzck/FLL0g1OZSV1N//FdNTsf+vemA/@lists.linux.dev
X-Gm-Message-State: AOJu0YzXyupJNJkVW818B4N/j3LGm86YV3qUVgaJt7TsSkS37PUlpVqv
	n0t9gNrGIXplvephCMDMnrX44XjeZrueUJRMdxlqf41srsF/TxRuAg85C7oNHJQteN2+rpGFfft
	C/X0DmiSpIuVSURQ2wjOBHWU5shDLufkllteM
X-Gm-Gg: ASbGnct/45lCEkSDKZNkOy29iKVt3pOaCMQsnR8nKEiB0XExLTrAj6lkKljewuSkcFZ
	L6TtImYxMLd4ygmBT2ahO4KUT3+Sf5CCdTc1PXv5Vune3RyZYfL5xL08pM4amYWEbKFL1dMCv68
	T6S5OwvdNv4qBH6Ys+lBU7dBsNaC8Xre3bew==
X-Google-Smtp-Source: AGHT+IENwTVXLe0Zw2O1nUpfwQXnNBCVqTq4UiTlOPBV71cZTouue+7h2pZ+FTYfkSRyTTOhACxuS/VjEDiAolqr37Y=
X-Received: by 2002:a05:6214:23c6:b0:6e4:4194:df35 with SMTP id
 6a1803df08f44-6f528c3ec64mr103380936d6.9.1746424942052; Sun, 04 May 2025
 23:02:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-3-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-3-ojeda@kernel.org>
From: David Gow <davidgow@google.com>
Date: Mon, 5 May 2025 14:02:09 +0800
X-Gm-Features: ATxdqUF9V_rvhFyRGFAGYXIbVphSS3lW64Xn1BEyDIoe-HUn4JUFA_DHxJFMkSY
Message-ID: <CABVgOSm8T+_kXY78sioUHEcG7rYApfWK2Gfxkrvw94Dz57G0oQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] rust: kunit: support checked `-> Result`s in KUnit `#[test]`s
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <rmoar@google.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000054fb7e06345d3eaf"

--00000000000054fb7e06345d3eaf
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 05:51, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Currently, return values of KUnit `#[test]` functions are ignored.
>
> Thus introduce support for `-> Result` functions by checking their
> returned values.
>
> At the same time, require that test functions return `()` or `Result<T,
> E>`, which should avoid mistakes, especially with non-`#[must_use]`
> types. Other types can be supported in the future if needed.
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
>     [    3.745817]     # my_test: ASSERTION FAILED at rust/kernel/lib.rs:321
>     [    3.745817]     Expected is_test_result_ok(my_test()) to be true, but is false
>     [    3.747152]     # my_test.speed: normal
>     [    3.747199]     not ok 1 my_test
>     [    3.747345] not ok 4 my_test_suite
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

This is a neat idea. I think a lot of tests will still want to go with
the () return value, but having both as an option seems like a good
idea to me.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David


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
>  /// The [`kunit_unsafe_test_suite!`] macro expects a NULL-terminated list of valid test cases.
> diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
> index eb4f2afdbe43..9681775d160a 100644
> --- a/rust/macros/kunit.rs
> +++ b/rust/macros/kunit.rs
> @@ -105,8 +105,9 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
>      let path = crate::helpers::file();
>      for test in &tests {
>          let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
> +        // An extra `use` is used here to reduce the length of the message.
>          let kunit_wrapper = format!(
> -            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kunit) {{ {}(); }}",
> +            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kunit) {{ use kernel::kunit::is_test_result_ok; assert!(is_test_result_ok({}())); }}",
>              kunit_wrapper_fn_name, test
>          );
>          writeln!(kunit_macros, "{kunit_wrapper}").unwrap();
> --
> 2.49.0
>

--00000000000054fb7e06345d3eaf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIUnQYJKoZIhvcNAQcCoIIUjjCCFIoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghIEMIIGkTCCBHmgAwIBAgIQfofDAVIq0iZG5Ok+mZCT2TANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNDdaFw0zMjA0MTkwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFI2IFNNSU1FIENBIDIwMjMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYydcdmKyg
4IBqVjT4XMf6SR2Ix+1ChW2efX6LpapgGIl63csmTdJQw8EcbwU9C691spkltzTASK2Ayi4aeosB
mk63SPrdVjJNNTkSbTowej3xVVGnYwAjZ6/qcrIgRUNtd/mbtG7j9W80JoP6o2Szu6/mdjb/yxRM
KaCDlloE9vID2jSNB5qOGkKKvN0x6I5e/B1Y6tidYDHemkW4Qv9mfE3xtDAoe5ygUvKA4KHQTOIy
VQEFpd/ZAu1yvrEeA/egkcmdJs6o47sxfo9p/fGNsLm/TOOZg5aj5RHJbZlc0zQ3yZt1wh+NEe3x
ewU5ZoFnETCjjTKz16eJ5RE21EmnCtLb3kU1s+t/L0RUU3XUAzMeBVYBEsEmNnbo1UiiuwUZBWiJ
vMBxd9LeIodDzz3ULIN5Q84oYBOeWGI2ILvplRe9Fx/WBjHhl9rJgAXs2h9dAMVeEYIYkvW+9mpt
BIU9cXUiO0bky1lumSRRg11fOgRzIJQsphStaOq5OPTb3pBiNpwWvYpvv5kCG2X58GfdR8SWA+fm
OLXHcb5lRljrS4rT9MROG/QkZgNtoFLBo/r7qANrtlyAwPx5zPsQSwG9r8SFdgMTHnA2eWCZPOmN
1Tt4xU4v9mQIHNqQBuNJLjlxvalUOdTRgw21OJAFt6Ncx5j/20Qw9FECnP+B3EPVmQIDAQABo4IB
ZTCCAWEwDgYDVR0PAQH/BAQDAgGGMDMGA1UdJQQsMCoGCCsGAQUFBwMCBggrBgEFBQcDBAYJKwYB
BAGCNxUGBgkrBgEEAYI3FQUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUM7q+o9Q5TSoZ
18hmkmiB/cHGycYwHwYDVR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwewYIKwYBBQUHAQEE
bzBtMC4GCCsGAQUFBzABhiJodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vcm9vdHI2MDsGCCsG
AQUFBzAChi9odHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9yb290LXI2LmNydDA2
BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL3Jvb3QtcjYuY3JsMBEG
A1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0BAQwFAAOCAgEAVc4mpSLg9A6QpSq1JNO6tURZ4rBI
MkwhqdLrEsKs8z40RyxMURo+B2ZljZmFLcEVxyNt7zwpZ2IDfk4URESmfDTiy95jf856Hcwzdxfy
jdwx0k7n4/0WK9ElybN4J95sgeGRcqd4pji6171bREVt0UlHrIRkftIMFK1bzU0dgpgLMu+ykJSE
0Bog41D9T6Swl2RTuKYYO4UAl9nSjWN6CVP8rZQotJv8Kl2llpe83n6ULzNfe2QT67IB5sJdsrNk
jIxSwaWjOUNddWvCk/b5qsVUROOuctPyYnAFTU5KY5qhyuiFTvvVlOMArFkStNlVKIufop5EQh6p
jqDGT6rp4ANDoEWbHKd4mwrMtvrh51/8UzaJrLzj3GjdkJ/sPWkDbn+AIt6lrO8hbYSD8L7RQDqK
C28FheVr4ynpkrWkT7Rl6npWhyumaCbjR+8bo9gs7rto9SPDhWhgPSR9R1//WF3mdHt8SKERhvtd
NFkE3zf36V9Vnu0EO1ay2n5imrOfLkOVF3vtAjleJnesM/R7v5tMS0tWoIr39KaQNURwI//WVuR+
zjqIQVx5s7Ta1GgEL56z0C5GJoNE1LvGXnQDyvDO6QeJVThFNgwkossyvmMAaPOJYnYCrYXiXXle
A6TpL63Gu8foNftUO0T83JbV/e6J8iCOnGZwZDrubOtYn1QwggWDMIIDa6ADAgECAg5F5rsDgzPD
hWVI5v9FUTANBgkqhkiG9w0BAQwFADBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBS
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
YE9NAgMBAAGjggHgMIIB3DAeBgNVHREEFzAVgRNkYXZpZGdvd0Bnb29nbGUuY29tMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFHgsCGkO2Hex
N6ybc+GeQEb6790qMFgGA1UdIARRME8wCQYHZ4EMAQUBAjBCBgorBgEEAaAyCgMDMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQC
MAAwgZoGCCsGAQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWdu
LmNvbS9jYS9nc2F0bGFzcjZzbWltZWNhMjAyMzBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3J0MB8GA1UdIwQYMBaA
FDO6vqPUOU0qGdfIZpJogf3BxsnGMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vY2EvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3JsMA0GCSqGSIb3DQEBCwUAA4ICAQAs
exV05yVDmPhHRqOq9lAbfWOUvEf8zydxabZUHna6bayb83jD2eb9nMGGEprfuNBRmFg35sgF1TyN
+ieuQakvQYmY8tzK49hhHa2Y3qhGCTqYTHO3ypHvhHsZiGbL0gmdgB9P8ssVIws//34ae99GUOxo
XKTxPwwsQ5Arq42besv3/HXAW+4nRAT8d3ht5ZWCHc5rjL/vdGzu7PaYo3u0da69AZ8Sh4Gf5yoc
QANr2ZkMrxXbLmSmnRvbkQrzlZp2YbTFnczx46429D6q75/FNFOL1vAjxtRAPzkyACvW0eKvchza
TMvvD3IWERLlcBL5yXpENc3rI8/wVjqgAWYxlFg1b/4b/TCgYe2MZC0rx4Uh3zTIbmPNiHdN6QZ9
oDiYzWUcqWZ5jCO4bMKNlVJXeCvdANLHuhcC8FONj5VzNgYXs6gWkp9/Wt6XnQPX4dF4JBa8JdL/
cT46RJIzoiJHEx/8syO5FparZHIKbkunoq6niPsRaQUGeqWc56H4Z1sQXuBJN9fhqkIkG0Ywfrwt
uFrCoYIRlx4rSVHpBIKgnsgdm0SFQK72MPmIkfhfq9Fh0h8AjhF73sLO7K5BfwWkx1gwMySyNY0e
PCRYr6WEVOkUJS0a0fui693ymMPFLQAimmz8EpyFok4Ju066StkYO1dIgUIla4x61auxkWHwnzGC
Al0wggJZAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKjAo
BgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjYgU01JTUUgQ0EgMjAyMwIQAcDMKctW1GQKDKqEUSh4
pjANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgNhAn3f/12NBagT16C9hg3zgKpV5j
dovMJa/O80pk87kwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUw
NTA1MDYwMjIyWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAbtntQIDFJxZgiRYx58ewaZKuQ6/YKOyKdhry66d8ZEGpfXUUTq1QtPSGV6CpJJFh
pj5hKgAb6BWnPPzG45NyJ8gvyv9K5Xx9GtcAU0p84f9lQrtq6J1+rtDWw1F41y/z9duU2urCPfgp
cJxPQnofMVlBfMOeUEjwz02al9CELPyGLbRRQbH5iCLg+ZgOEAPJiFdZfLJwXHsYnW2lX4JrxNQt
mv7VS0ATjlvViIPgbscw9CFYlbdR75Omn/tAVTxGmKdFvOFQSnXYG60hDaUvnQrHQGkj1t8GdtxC
74wFLjTnRKC9LzQ6n3X6PGjTvqsPaEfi/PNW/a7ve84Q3UoC4g==
--00000000000054fb7e06345d3eaf--
