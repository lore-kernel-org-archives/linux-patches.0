Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9A3EEBA
	for <patches@lists.linux.dev>; Mon,  5 May 2025 06:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746424938; cv=none; b=BfMForsiJ948HjhmzpABQ2+8P2gpOJxTZ8Efv4YoZdpKRxUs+htDO20BBjEULFhrZ013j1J+2s9HFmxWmzo9xJSVWfVqsNc25Au65gZy2moZrNd14KJw7IJHM1PdmHNhx++ABD0jYAltNIJsKX40Jra1SL72eubt/VwlQCFWf64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746424938; c=relaxed/simple;
	bh=4sbg6ymhkyW/FKS9s/U4xEps4g4EO/fqk2Db8UPs3dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jKsh9rzMM9w3yO11UIPX9jlYCff91hYbI2D1y/lBZWV7K8aLcwWc21LYH58hbQUYRHn8CQQmghdBAcrsG6u9H8BpDRPJcHGewYRlXAdeXykXEpLbK5lQnB60rw5LPNRDo0IV0aSbMPmMDrgZ5g6srnWv57QD0dHdZppGo983snw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OhkQWomc; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OhkQWomc"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6f2b05f87fdso42911506d6.2
        for <patches@lists.linux.dev>; Sun, 04 May 2025 23:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746424935; x=1747029735; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kAVcmICawq2dBV8MifondGvQG2Puksul4i45UZuVP1w=;
        b=OhkQWomcmIiW5tXrAS4tDYqHYFqh+K+Xg7moTBO47qUsueiMs6wCl8bvqBm9p/RfCn
         jim0kfT0OgFMr60NPxbcShxX4ljgHLOQt/MxGlzV8n2yX/QZKDaptWMwwDNapctG/rJ3
         Dv/GHJFIlD55g24XHY1+hpMwxg4w7W8EAULk9AK0Uwu/fIpwk4oyBm+meUzr6jxd74nq
         2xe9gVBYGlp0kAC1RUsCf0HOgBt8Jt5BrL3JFRnfk9ITY4NnzPf81GFdJ/LhtEl/BdNv
         iBUtjjk9d6+dbc01bXEx9etccqELZysv4m0PnNVPEdhfrAdFrqUV6hsNafjraUWbBDhK
         jXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746424935; x=1747029735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kAVcmICawq2dBV8MifondGvQG2Puksul4i45UZuVP1w=;
        b=T5a031pvFGvWiAibZGoSGUTwNVhQ8S0lqAsHPGH4ZO9EEsi2sFsSYZuQfFWDx4IP22
         WUKe0jRsiEdGKUACFH8vKOifWiBii8nxy1y43OjLZEzrHzPFP2CTuksQLB3VjCQXpt0A
         vZ6yzwVbuysm9UBCz7BEmJfO/0E1zowSqtlVZMPnLczOc4qMYKIe6/VC2uigib0mvT5j
         t4i6ZMf3Sbo/0/EXoZKQ+UIKbP23RssQj9nykKkOEwUyOTFhRm/Ahw+U4BIqb5yNx2X3
         QxquqElhNtfPDEGImSENz/iMMYYVEz0+Et/hpLdZjO6XF9PJerrVIQMA/ipQS71UnWiX
         hICw==
X-Forwarded-Encrypted: i=1; AJvYcCXfVM1IN0EVXaAntq4wLmSc1fViLrz608ijyP3vKBTAJrQRxM3b1FUn16jV8o1GI5/WPQYeh85J@lists.linux.dev
X-Gm-Message-State: AOJu0Yzih/ODNbD9PAC00MskoQ146glb60jqQLPNsixdyMpCe6PluXws
	lWidh8wRERpMaJDl9u27t4lh5zKyVgOGkT3Ih8tDTruJepxHucyu4S3fcWuQj58D/ETey4lKPcI
	gZLIXrDHnduyDTQhmQDFCP1kKr+m86xiMDxEa
X-Gm-Gg: ASbGncsZ07U3pftsZxSv+Oe/ay3j/0b/sHU0fOqDipYLYk2/h5Iqb0fuHDFhvclCijh
	7PKyrWEnwnbQqJxjh5MyFYExhyOY8FzXH2w1THF/WeSm0kFR+k082WT2SyH8ml9vt5R3OqO7cy1
	d2KHSEF5vIarQbkOSOU/Cc3X0=
X-Google-Smtp-Source: AGHT+IFz19h0gtF/Pkgj8MIlU04lhiA1UrobGXAJyyRiR553mQw9E+ThHfqS3TMI0jLj9Ed3i4AtmKEStU/WCDquLjw=
X-Received: by 2002:a05:6214:ac1:b0:6e4:4331:aae6 with SMTP id
 6a1803df08f44-6f51580c1fbmr162530186d6.39.1746424934881; Sun, 04 May 2025
 23:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-2-ojeda@kernel.org>
In-Reply-To: <20250502215133.1923676-2-ojeda@kernel.org>
From: David Gow <davidgow@google.com>
Date: Mon, 5 May 2025 14:02:00 +0800
X-Gm-Features: ATxdqUHZERB2C3U4u6kShNMtwcE3PTFscuVcnOz4kZR6nB5RLwbx3SVgk-Qjzpo
Message-ID: <CABVgOSnTYwYtoMXCC-mUxV=A2quCrA+CD1Qe32n=qddxLKpcUw@mail.gmail.com>
Subject: Re: [PATCH 1/7] rust: kunit: support KUnit-mapped `assert!` macros in `#[test]`s
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
	boundary="000000000000e7f90106345d3d62"

--000000000000e7f90106345d3d62
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 05:51, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> The KUnit `#[test]` support that landed recently is very basic and does
> not map the `assert*!` macros into KUnit like the doctests do, so they
> panic at the moment.
>
> Thus implement the custom mapping in a similar way to doctests, reusing
> the infrastructure there.
>
> In Rust 1.88.0, the `file()` method in `Span` may be stable [1]. However,
> it was changed recently (from `SourceFile`), so we need to do something
> different in previous versions. Thus create a helper for it and use it
> to get the path.
>
> With this, a failing test suite like:
>
>     #[kunit_tests(my_test_suite)]
>     mod tests {
>         use super::*;
>
>         #[test]
>         fn my_first_test() {
>             assert_eq!(42, 43);
>         }
>
>         #[test]
>         fn my_second_test() {
>             assert!(42 >= 43);
>         }
>     }
>
> will properly map back to KUnit, printing something like:
>
>     [    1.924325]     KTAP version 1
>     [    1.924421]     # Subtest: my_test_suite
>     [    1.924506]     # speed: normal
>     [    1.924525]     1..2
>     [    1.926385]     # my_first_test: ASSERTION FAILED at rust/kernel/lib.rs:251
>     [    1.926385]     Expected 42 == 43 to be true, but is false
>     [    1.928026]     # my_first_test.speed: normal
>     [    1.928075]     not ok 1 my_first_test
>     [    1.928723]     # my_second_test: ASSERTION FAILED at rust/kernel/lib.rs:256
>     [    1.928723]     Expected 42 >= 43 to be true, but is false
>     [    1.929834]     # my_second_test.speed: normal
>     [    1.929868]     not ok 2 my_second_test
>     [    1.930032] # my_test_suite: pass:0 fail:2 skip:0 total:2
>     [    1.930153] # Totals: pass:0 fail:2 skip:0 total
>
> Link: https://github.com/rust-lang/rust/pull/140514 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Nice! While I do think there may still be some cases where we might
want to use KUnit-specific macros in the future (particularly if we
have more complex, multithreaded test contexts), this is definitely
better for most cases.

I also managed to test it against the 1.88 nightly, and the message is
looking good.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David


>  init/Kconfig           |  3 +++
>  rust/Makefile          |  3 ++-
>  rust/kernel/kunit.rs   |  1 -
>  rust/macros/helpers.rs | 16 ++++++++++++++++
>  rust/macros/kunit.rs   | 28 +++++++++++++++++++++++++++-
>  rust/macros/lib.rs     |  4 ++++
>  6 files changed, 52 insertions(+), 3 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 63f5974b9fa6..5f442c64c47b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -140,6 +140,9 @@ config LD_CAN_USE_KEEP_IN_OVERLAY
>  config RUSTC_HAS_COERCE_POINTEE
>         def_bool RUSTC_VERSION >= 108400
>
> +config RUSTC_HAS_SPAN_FILE
> +       def_bool RUSTC_VERSION >= 108800
> +
>  config PAHOLE_VERSION
>         int
>         default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
> diff --git a/rust/Makefile b/rust/Makefile
> index 3aca903a7d08..075b38a24997 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -402,7 +402,8 @@ quiet_cmd_rustc_procmacro = $(RUSTC_OR_CLIPPY_QUIET) P $@
>                 -Clink-args='$(call escsq,$(KBUILD_PROCMACROLDFLAGS))' \
>                 --emit=dep-info=$(depfile) --emit=link=$@ --extern proc_macro \
>                 --crate-type proc-macro \
> -               --crate-name $(patsubst lib%.$(libmacros_extension),%,$(notdir $@)) $<
> +               --crate-name $(patsubst lib%.$(libmacros_extension),%,$(notdir $@)) \
> +               @$(objtree)/include/generated/rustc_cfg $<
>
>  # Procedural macros can only be used with the `rustc` that compiled it.
>  $(obj)/$(libmacros_name): $(src)/macros/lib.rs FORCE
> diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
> index 1604fb6a5b1b..2659895d4c5d 100644
> --- a/rust/kernel/kunit.rs
> +++ b/rust/kernel/kunit.rs
> @@ -323,7 +323,6 @@ mod tests {
>
>      #[test]
>      fn rust_test_kunit_example_test() {
> -        #![expect(clippy::eq_op)]
>          assert_eq!(1 + 1, 2);
>      }
>
> diff --git a/rust/macros/helpers.rs b/rust/macros/helpers.rs
> index a3ee27e29a6f..57c3b0f0c194 100644
> --- a/rust/macros/helpers.rs
> +++ b/rust/macros/helpers.rs
> @@ -86,3 +86,19 @@ pub(crate) fn function_name(input: TokenStream) -> Option<Ident> {
>      }
>      None
>  }
> +
> +pub(crate) fn file() -> String {
> +    #[cfg(not(CONFIG_RUSTC_HAS_SPAN_FILE))]
> +    {
> +        proc_macro::Span::call_site()
> +            .source_file()
> +            .path()
> +            .to_string_lossy()
> +            .into_owned()
> +    }
> +
> +    #[cfg(CONFIG_RUSTC_HAS_SPAN_FILE)]
> +    {
> +        proc_macro::Span::call_site().file()
> +    }
> +}
> diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
> index 4f553ecf40c0..eb4f2afdbe43 100644
> --- a/rust/macros/kunit.rs
> +++ b/rust/macros/kunit.rs
> @@ -101,6 +101,8 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
>      // ```
>      let mut kunit_macros = "".to_owned();
>      let mut test_cases = "".to_owned();
> +    let mut assert_macros = "".to_owned();
> +    let path = crate::helpers::file();
>      for test in &tests {
>          let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
>          let kunit_wrapper = format!(
> @@ -114,6 +116,27 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
>              test, kunit_wrapper_fn_name
>          )
>          .unwrap();
> +        writeln!(
> +            assert_macros,
> +            r#"
> +/// Overrides the usual [`assert!`] macro with one that calls KUnit instead.
> +#[allow(unused)]
> +macro_rules! assert {{
> +    ($cond:expr $(,)?) => {{{{
> +        kernel::kunit_assert!("{test}", "{path}", 0, $cond);
> +    }}}}
> +}}
> +
> +/// Overrides the usual [`assert_eq!`] macro with one that calls KUnit instead.
> +#[allow(unused)]
> +macro_rules! assert_eq {{
> +    ($left:expr, $right:expr $(,)?) => {{{{
> +        kernel::kunit_assert_eq!("{test}", "{path}", 0, $left, $right);
> +    }}}}
> +}}
> +        "#
> +        )
> +        .unwrap();
>      }
>
>      writeln!(kunit_macros).unwrap();
> @@ -152,7 +175,10 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
>          }
>      }
>
> -    let mut new_body = TokenStream::from_iter(new_body);
> +    let body = new_body;
> +    let mut new_body = TokenStream::new();
> +    new_body.extend::<TokenStream>(assert_macros.parse().unwrap());
> +    new_body.extend(body);
>      new_body.extend::<TokenStream>(kunit_macros.parse().unwrap());
>
>      tokens.push(TokenTree::Group(Group::new(Delimiter::Brace, new_body)));
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 9acaa68c974e..8bd7906276be 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -6,6 +6,10 @@
>  // and thus add a dependency on `include/config/RUSTC_VERSION_TEXT`, which is
>  // touched by Kconfig when the version string from the compiler changes.
>
> +// TODO: check that when Rust 1.88.0 is released, this would be enough:
> +// #![cfg_attr(not(CONFIG_RUSTC_HAS_SPAN_FILE), feature(proc_macro_span))]
> +#![feature(proc_macro_span)]
> +
>  #[macro_use]
>  mod quote;
>  mod concat_idents;
> --
> 2.49.0
>

--000000000000e7f90106345d3d62
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
pjANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgUK3/EqcOGO9Y5rt76cagcZTjYYF2
Pg44A3wewLDKv1EwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUw
NTA1MDYwMjE1WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAKnccjcI3NMcGQ0x/pwdJczsMo7ZIWirv1pMHBXEu7runF7mCpBa9mn1G5JF9poX/
jG7u/Z0bVb6fvJ0iMOeDiIm46UZbSRHj+Hz00ht7gnwYsmBKsF+/jiBIh0j0ZVE3JzYCnpBLf15h
h2zHczk+cHEc18o8N7SHoEWvo9vslqCW1tCtJdKhXMntQpzuk1RxAvqnPNCbvbVyRMJ5+qGk1FVd
Ey5byuG+4e9FRaLaXGbOpoFBpIKkwirELNEVpFpK6gvbrgueY7bDleucbTh6AzJNhbXJCvjQY59B
ys/dXxJbuv0ReNgNV+Xls3+iv0PGKorE8KQ5W88nuHpQGvnGcQ==
--000000000000e7f90106345d3d62--
