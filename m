Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E11C8616
	for <patches@lists.linux.dev>; Mon,  5 May 2025 06:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746424980; cv=none; b=P9HIvzHI0XciecCFtvwVx5+zX/x1dcvCRk5kikFyQLPaOLOjhAVaQ7eBSN+9lbrQinlSvYv11diXg2m/nrmlx/+JYNQPaW8ep5zNQLm+z3PnyqkW2iYWjJ389TJ30QqTbB1kNkqCxIbOYjZFcANI80KHoP62/pBvLw+BptAe5Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746424980; c=relaxed/simple;
	bh=qZ8InLVGfzT9zdleoVRzEjh+O+d6hD2G9CZ+lKGoz+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OnCT5cMpZ2ueNKg9d3sC5eueT7Bbs2kW2ap3PwDx1rwoqDU4FZKW6bDTLyusuxd2U1UcpE0NZ9V9k0si62Grj3MIFwLbGFComOsqk/9BqQidHMnkhZ5ZIRvKCnvJV1GnCMtwnpdrRjeeL2eI1mff+mv8gzwQlyQfkitqTutaEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W3vHk4fW; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W3vHk4fW"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e8ec399427so39866976d6.2
        for <patches@lists.linux.dev>; Sun, 04 May 2025 23:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746424977; x=1747029777; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ysVbPbZP1J60W2vsbc0G71PdhPHKQBXS7DDisUYSY0M=;
        b=W3vHk4fWtUp3DEzJHGbovghXgSYWQNS0AstL1bgWwfAfgYTQsnGwUJKbopB5ZwMJMr
         XpTjyKqfpW+ZihZy0tzO+bKM+bcYw3NvIy+4CF04p0Hb7N9L4N/9EzNpEOlaEQBXDBj0
         GdrpbXjVjEvMgmcokskuL7PLSX9SKpXZGsW8D4R10Q3QQHY+Oq3+I7iASz0KQIQ3+d8T
         uCawNUyrP0g8c0ctoRU9cp8AU7waD0ELD3ZLgWx87zSrQ70Ffc7uFemUQh9V2B31Pclu
         Ws/feNl8lNCEpiTiCZTHE/cjLVoNFJnsBTnZehRsQXbfKk9XKhKOZAGKDsKt/+BJRPHJ
         9eSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746424977; x=1747029777;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysVbPbZP1J60W2vsbc0G71PdhPHKQBXS7DDisUYSY0M=;
        b=DSW3r4RWM0k2a/HJjKG6QlhJGtC6uYMMznbTTLaZJvXHnFUsyYKN2phJFFXvr/UiHU
         //RclrHa1oI7N32p92Df6mdMwRHm0Sr/N6xJ8fZdKRgKDcV9etgZkp6dgAAjvN86Xtpa
         EcrTg8NRxsTgWqrmBHLIYwrGV6ljEeFQ1fRrtIJ/Qv+lz9Cvmr26GBWlyW2EyGf9vfPg
         JhQLij/PjphibP9dl2crq/0YX/qYtvQd8SaTsTQb71wX0QmFmIbbR+NPCO7ffMO4OhgW
         Cjol+4UBWILj+TmfVt1zksYxctiyArp8M1mknZuF0r49TugkA6F5RAd2xqWpob+DuCTP
         dDng==
X-Forwarded-Encrypted: i=1; AJvYcCUXQk1LHFxYyPGroXgHEk91iQL+chB18u2AsEGgZIs3NPY7enUTM7LrYpTZpSR5iUMs3oVmkAfG@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0A4q+nmJXpXi1qBk741Z4EHj8gv936spAzctmAiLAorJFGGRT
	+WeJDVI1kWTRynrZhrSyd5FYrQI02PQ8C682GBInFZPkkUKPi62vLvBILFVs2EvCjW8Xsl08Ddr
	X8mnCbNyG5eoxqmgI131jpmf3tOmb8M3lCP0h
X-Gm-Gg: ASbGnctFuZHiD9oHcJjgaM/XHSHbO145GbG0bngCBssxN/2Kye03kxUNwnTv8TpCUCg
	vKSBd5izTLN1FXO7rX0Jy7YIyFkWnJKZXGZ32HA6M1WnPmXSGGqI4qjCNGsXN3eiloOhaxf/+k+
	/VrxOfwC3v+RiJsD2SbURGu44=
X-Google-Smtp-Source: AGHT+IHvnBRkLV0yPC58kQDugMI0D05YJSCJ/82ITf12XDS/cMie5SVaCSotW3gGLYrpmHO0sLSvZoZHB/qdZc9r06s=
X-Received: by 2002:a05:6214:1307:b0:6f4:c824:9d3d with SMTP id
 6a1803df08f44-6f52384eceemr125534656d6.37.1746424976931; Sun, 04 May 2025
 23:02:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-8-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-8-ojeda@kernel.org>
From: David Gow <davidgow@google.com>
Date: Mon, 5 May 2025 14:02:44 +0800
X-Gm-Features: ATxdqUF8CsR4W9w3FVi75qqgqr3prGPC0Y2_AW4HmQuTefiWbq5MSME8G2N-tLc
Message-ID: <CABVgOS=bnn-G_DjEUh_Odq2iHJ-xg7R-DR4krjZd+o9R3-Pr0w@mail.gmail.com>
Subject: Re: [PATCH 7/7] Documentation: rust: testing: add docs on the new
 KUnit `#[test]` tests
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
	boundary="00000000000068867b06345d40da"

--00000000000068867b06345d40da
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 05:52, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> There was no documentation yet on the KUnit-based `#[test]`s.
>
> Thus add it now.
>
> It includes an explanation about the `assert*!` macros being mapped to
> KUnit and the support for `-> Result` introduced in these series.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Assuming all of the other changes go through, this looks good to me.

It _may_ be useful to add some notes about when to choose KUnit tests
versus rusttest host tests: particularly around cross-compiling and/or
the need to call kernel APIs / access global kernel state. But some of
that is covered in the general kernel testing / KUnit documentation in
Documentation/dev-tools, anyway.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David



>  Documentation/rust/testing.rst | 71 ++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>
> diff --git a/Documentation/rust/testing.rst b/Documentation/rust/testing.rst
> index 6337b83815ab..f43cb77bcc69 100644
> --- a/Documentation/rust/testing.rst
> +++ b/Documentation/rust/testing.rst
> @@ -130,6 +130,77 @@ please see:
>
>         https://rust.docs.kernel.org/kernel/error/type.Result.html#error-codes-in-c-and-rust
>
> +The ``#[test]`` tests
> +---------------------
> +
> +Additionally, there are the ``#[test]`` tests. Like for documentation tests,
> +these are also fairly similar to what you would expect from userspace, and they
> +are also mapped to KUnit.
> +
> +These tests are introduced by the ``kunit_tests`` procedural macro, which takes
> +the name of the test suite as an argument.
> +
> +For instance, assume we want to test the function ``f`` from the documentation
> +tests section. We could write, in the same file where we have our function:
> +
> +.. code-block:: rust
> +
> +       #[kunit_tests(rust_kernel_mymod)]
> +       mod tests {
> +           use super::*;
> +
> +           #[test]
> +           fn test_f() {
> +               assert_eq!(f(10, 20), 30);
> +           }
> +       }
> +
> +And if we run it, the kernel log would look like::
> +
> +           KTAP version 1
> +           # Subtest: rust_kernel_mymod
> +           # speed: normal
> +           1..1
> +           # test_f.speed: normal
> +           ok 1 test_f
> +       ok 1 rust_kernel_mymod
> +
> +Like documentation tests, the ``assert!`` and ``assert_eq!`` macros are mapped
> +back to KUnit and do not panic. Similarly, the
> +`? <https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator>`_
> +operator is supported, i.e. the test functions may return either nothing (i.e.
> +the unit type ``()``) or ``Result`` (i.e. any ``Result<T, E>``). For instance:
> +
> +.. code-block:: rust
> +
> +       #[kunit_tests(rust_kernel_mymod)]
> +       mod tests {
> +           use super::*;
> +
> +           #[test]
> +           fn test_g() -> Result {
> +               let x = g()?;
> +               assert_eq!(x, 30);
> +               Ok(())
> +           }
> +       }
> +
> +If we run the test and the call to ``g`` fails, then the kernel log would show::
> +
> +           KTAP version 1
> +           # Subtest: rust_kernel_mymod
> +           # speed: normal
> +           1..1
> +           # test_g: ASSERTION FAILED at rust/kernel/lib.rs:335
> +           Expected is_test_result_ok(test_g()) to be true, but is false
> +           # test_g.speed: normal
> +           not ok 1 test_g
> +       not ok 1 rust_kernel_mymod
> +
> +If a ``#[test]`` test could be useful as an example for the user, then please
> +use a documentation test instead. Even edge cases of an API, e.g. error or
> +boundary cases, can be interesting to show in examples.
> +
>  The ``rusttest`` host tests
>  ---------------------------
>
> --
> 2.49.0
>

--00000000000068867b06345d40da
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
pjANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgOhQm0Yv11IA1aNt2BDEqXeGrdQyk
TPPAIbQlAzNgT78wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUw
NTA1MDYwMjU3WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAHAUjESrxyvjoVU0k2C2LVRJjE/PvT+1dIsnv4725cHFM5U52xL/ulCmu40rvbWGd
M4Uy4UG7Qhsen5zvQ5aOFPur0LluhfSAvdPQ2jyXghLbak3qmF1vK++KIYP0f/Ede1YL4bOJ151O
lk3iLeBn+yyDR4uQFAVP2++k/UlXi2tKB+64q8SEeYsboyOz2dygF5FSoEmiWCTUL1I20SPCS7de
FIA1KsnWVLjOu1Yi/ZCYJlTnWKIa2726YnshM5sImNxets/b/LkY4HcwXff6Ke/QWP1041spMq14
tI1NenSClwQE8vMRpDhqabDL8MP+wZ55SzhI5Qq4NGLyo1DKWw==
--00000000000068867b06345d40da--
