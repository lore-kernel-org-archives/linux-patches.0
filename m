Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DEDDDC1
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gVDfMOL/"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso5146a12.1
        for <patches@lists.linux.dev>; Thu, 14 Dec 2023 23:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702625540; x=1703230340; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WBgQ0RRzgqnmZ3XZ9HE9mOgeSOlW1hZnBjKkbHULK9A=;
        b=gVDfMOL/mpYl70ToFtaTMuIKLf96vqvsIgn9bvdxw9auYbX8YJH4/pnfaQUhRoxw/e
         xSo/EohchCt2iUWBXno+IxC3cWN8Q8Ah5LqAfEFBu6t98QPn904pImBlULroL3kuCZ79
         RM57hIWTeCQIHKFqs/Jzi4uTAxQHW8a3eaC29KJ0Mnsdnh2X7V7pum19HC6Gs6O8xy+m
         XR/aoeprJPY+RbbBotf7i72F6u13clkOEjvjh+iOA5aX7h7GJjYDh2aMJ/Y/3XPpOAVv
         l9c0ew4sbYwD9XVK1lLRA0rVe8a3weUDS4RLyNMDtG5roKsC7VxA59UkE5vd7i+zNa8Q
         LYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702625540; x=1703230340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBgQ0RRzgqnmZ3XZ9HE9mOgeSOlW1hZnBjKkbHULK9A=;
        b=MpMMGNn3WjoXGL1TqMq2lj3z4vLEWT6H7fYPRyRjCM/SDqeWJ3d5wPxyBysFyWSemk
         rjiDEqbVe3vLmP4A118mMGJQqhuV3yu/UqB0/RdZfgTsJUkxFP04flL3fqp9yo9S8Gxn
         e45lRWFwITnBYpnG0zV01sJKuTBYJfVvk6IAqmmyltZG8kTFWPvI8vnFStqrF3PVc9MO
         E10ovLhCFYHbEr5DqUfI6kIhJW8eYq9u5TJ+8ec9r9UcEJaJxq3KyELlbmgpNjR7ZotY
         O7csDxeTQdKJn5WaTxEtp4cXURH6FcnslIen1h5hF7CNZpK25CfREfLAdO0+diiQ9hRm
         jUCw==
X-Gm-Message-State: AOJu0YzdS8FDaWV7B7824VbHiJnYHsY53i9sa0+0zzs6RT5QZghgtbVM
	pQIPyyTfMa7cwHGYKGbxsNoJQ2V1lyS7FF2TZAVJJg==
X-Google-Smtp-Source: AGHT+IGesnjLVLJ84vFW1jXverm9Mnye7w53Deyh36eervZHBV0YODyv1sStVxPb2jQ6aAQFJ03uRrFulM2921ax9Y8=
X-Received: by 2002:a50:d7ca:0:b0:54a:ee8b:7a8c with SMTP id
 m10-20020a50d7ca000000b0054aee8b7a8cmr748714edj.0.1702625539704; Thu, 14 Dec
 2023 23:32:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214092958.377061-1-ojeda@kernel.org>
In-Reply-To: <20231214092958.377061-1-ojeda@kernel.org>
From: David Gow <davidgow@google.com>
Date: Fri, 15 Dec 2023 15:32:06 +0800
Message-ID: <CABVgOSkyZ1fi2nRdPvwvq0vSzkT7Fo5ycoSuQ5Qzb9a9oaFCGA@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.74.1
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000816006060c8766a7"

--000000000000816006060c8766a7
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Dec 2023 at 17:30, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> This is the next upgrade to the Rust toolchain, from 1.73.0 to 1.74.1
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> No unstable features (that we use) were stabilized.
>
> Therefore, the only unstable features allowed to be used outside the
> `kernel` crate are still `new_uninit,offset_of`, though other code to
> be upstreamed may increase the list (e.g. `offset_of` was added recently).
>
> Please see [3] for details.
>
> # Other improvements
>
> Rust 1.74.0 allows to use `#[repr(Rust)]` explicitly [4], which can be
> useful to be explicit about particular cases that would normally use
> e.g. the C representation, such as silencing lints like the upcoming
> additions we requested [5] to the `no_mangle_with_rust_abi` Clippy lint
> (which in turn triggered the `#[repr(Rust)]` addition).
>
> Rust 1.74.0 includes a fix for one of the false negative cases we reported
> in Clippy's `disallowed_macros` lint [6] that we would like to use in
> the future.
>
> Rust 1.74.1 fixes an ICE that the Apple AGX GPU driver was hitting [7].
>
> # Required changes
>
> For this upgrade, no changes were required (i.e. on our side).
>
> # `alloc` upgrade and reviewing
>
> The vast majority of changes are due to our `alloc` fork being upgraded
> at once.
>
> There are two kinds of changes to be aware of: the ones coming from
> upstream, which we should follow as closely as possible, and the updates
> needed in our added fallible APIs to keep them matching the newer
> infallible APIs coming from upstream.
>
> Instead of taking a look at the diff of this patch, an alternative
> approach is reviewing a diff of the changes between upstream `alloc` and
> the kernel's. This allows to easily inspect the kernel additions only,
> especially to check if the fallible methods we already have still match
> the infallible ones in the new version coming from upstream.
>
> Another approach is reviewing the changes introduced in the additions in
> the kernel fork between the two versions. This is useful to spot
> potentially unintended changes to our additions.
>
> To apply these approaches, one may follow steps similar to the following
> to generate a pair of patches that show the differences between upstream
> Rust and the kernel (for the subset of `alloc` we use) before and after
> applying this patch:
>
>     # Get the difference with respect to the old version.
>     git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>     git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>         cut -d/ -f3- |
>         grep -Fv README.md |
>         xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>     git -C linux diff --patch-with-stat --summary -R > old.patch
>     git -C linux restore rust/alloc
>
>     # Apply this patch.
>     git -C linux am rust-upgrade.patch
>
>     # Get the difference with respect to the new version.
>     git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>     git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>         cut -d/ -f3- |
>         grep -Fv README.md |
>         xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>     git -C linux diff --patch-with-stat --summary -R > new.patch
>     git -C linux restore rust/alloc
>
> Now one may check the `new.patch` to take a look at the additions (first
> approach) or at the difference between those two patches (second
> approach). For the latter, a side-by-side tool is recommended.
>
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1741-2023-12-07 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/rust/pull/114201 [4]
> Link: https://github.com/rust-lang/rust-clippy/issues/11219 [5]
> Link: https://github.com/rust-lang/rust-clippy/issues/11431 [6]
> Link: https://github.com/rust-lang/rust/issues/117976#issuecomment-1822225691 [7]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

KUnit tests pass on x86_64 and UML.

Tested-by: David Gow <davidgow@google.com>

Cheers,
-- David

--000000000000816006060c8766a7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPnwYJKoZIhvcNAQcCoIIPkDCCD4wCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz5MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
ddIn9n5Jt6Z1o79zxraLMEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQCMAAwgZoGCCsG
AQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouse
LHIb0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
Y2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQBtHFwIgQZjer5K
H+4Q+wns10k7qN+4wN2Uf+JsyOYjukaMEgdLErfA1wwtQ9uHkoYQZcWBuVVkQFa5hI+sqI2m1Weq
riMCFSiU38s1tADdMX12IMfJRN60Nznhrw+nPyDRZqRhUTW24TwnHorkDnFPW8PHo7fAw4FrpI0n
impZAng7ccvvK09K3ZuhwTIxJMsPXCZYsrXWORTw5sczRAP6XvKbPBJnsJoSTe5dFBPBHOQJOGhU
qWfEfWnWMJPF3LxSGLpLFQXO3RwQqmxv08avwXfVPouh1xuB3FX7rpDabT8YDhu9JgIZkLEKko7L
yQt6zWwng7k8YF/jGbiAta6VMYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
R2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAy
MDIwAhABzgV+4+mJnUzG7XDy6d2uMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAC
M38eg4Seni29aYkYGqng9kqeTWsutLtzL05Ba87C6zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMzEyMTUwNzMyMjBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsG
CSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEASFmgrfkaSQpzpfFhUkpS
FLY+2dg9geYTk9jx42UwdDnGLEzBvBiZki7i7rAUbl+YYLFkgv1D3PH5kwlWjfNShCmfFgcRk7fB
CRVwWrwIGiVDIny0Cuprfwdy8609e7K8ClWuujqYZJDEyr+EGe9FOIPljFqE3JfEpNG3oiKC8TxS
U+62rLwC1qI/+GsVXQC+RZx0PxYlnJrQlLJFxBGDP11arVKFQitnr4KEA33YYy8lSQCHgMy9d73N
CMfQFZLXYcskB/jfI14dtacWeYVy6EzilnNdy3dVsBTudjB5K7J4Z24N8D2jO+7Moq28d0GsDG9K
ju3ASAx0D6u8Zb9Brw==
--000000000000816006060c8766a7--
