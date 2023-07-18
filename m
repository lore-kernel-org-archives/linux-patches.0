Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C7610EA
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 08:08:36 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f58444a410so2585e87.0
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 01:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689667715; x=1692259715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ELkQ3twXq0Tf0LNtUooauwlKvxKmgieTPFdQtWvrswA=;
        b=4UF5GNeiBKVFm0+yZQUFBRmz8TxfKjLJ6YskeC/NaIq2dt4xf83EcVGhv2oLq/jsjg
         StX1MLcr4uLaL7JsqR3Oz0FvBvL+GKSZirwU+U6YkNAIlyer4v9HJ5f1nMcSETyIJQMa
         fIgSN2YwOhZtMUm4MKTl2i77GwOPiQBLzE0hcLNRYWebVeUGZbIyZkNNmUMUWiaKr9gI
         0ggACNswSVmWpzR+F7R5M4iO3KsQTOrxlCAu1Po+RUBXntF3qJFxTzN6B/+j3pDgRId8
         xPOgDFwq0nD3LGEaDOJYJL20O1S8iKQGgN8fXI32alzQwrtIwb+pE69yX6bQIsPM8BE6
         3VRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689667715; x=1692259715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELkQ3twXq0Tf0LNtUooauwlKvxKmgieTPFdQtWvrswA=;
        b=CDe5TQpsHC/UAEHDR3ea464ldqRAaCZLAzFMdO1m5UwL5Dlpgxl/wOFfHw6jnVYqVx
         Im1yoDtJlLsMhkrLLKPBd6dc6qiIrn2xvOqLNgOuWEViQHJohHTTpvf/BVmNLkkHbdMa
         Q3OiwdnmoOmkQak2v/Xn2Oq4jVvoaW7unjN7waGn6pV0aQKe7jAyswcv9ekglZUW03Ay
         izlCGLEP69FsA/ejJ3SQ0Rjr1q/5Nrh/cBEcNngoBGo49kAzaoYFpFl8hXIc70I9U1hI
         /Rb99e/268MxbAlwiSFYTczu6FMNlWUjz5x02CNiQQSZwAYTRYNchyze/N2PO1uEymf4
         /skw==
X-Gm-Message-State: ABy/qLZNT0lCLEMUxOBBTgSl6c0/q7yHgHExeLWY88kef+M55JbmrUdh
	pH7Y0fROwLVTKwrWtMWqov1BIIBXIo34YdeX4LfrUw==
X-Google-Smtp-Source: APBJJlGLaFFk7Vkqi/94iNUIZ9ZVJA4JKr8ckZuOZCbr1qdQbT+2LWbXDDwnaK9Se6fEXbQDvJMOii/1F3GVcwxWXq8=
X-Received: by 2002:a19:c212:0:b0:4f7:5f7d:2f95 with SMTP id
 l18-20020a19c212000000b004f75f7d2f95mr49812lfc.1.1689667714876; Tue, 18 Jul
 2023 01:08:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718052752.1045248-1-ojeda@kernel.org> <20230718052752.1045248-2-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-2-ojeda@kernel.org>
From: David Gow <davidgow@google.com>
Date: Tue, 18 Jul 2023 16:08:22 +0800
Message-ID: <CABVgOSma4wc6u2fU9SmK0N4EB9djL=TqKU90dzWokL-DqU5Crw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] kunit: test-bug.h: include `stddef.h` for `NULL`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f550dd0600be6b51"

--000000000000f550dd0600be6b51
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Jul 2023 at 13:28, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> The header uses `NULL` in both `CONFIG_KUNIT=y` and `=n` cases,
> but does not include it explicitly.
>
> When `CONFIG_KUNIT=y`, the header is already getting included via
> the other headers, so it is not a problem for users.
>
> However, when `CONFIG_KUNIT=n`, it is not, and thus a user could hit
> a build error when including `kunit/test-bug.h`, like we are doing
> later in this series [1].
>
> Thus include `linux/stddef.h`, and do so outside the `#if`, since it
> is used in both cases.
>
> Reported-by: Boqun Feng <boqun.feng@gmail.com>
> Closes: https://lore.kernel.org/rust-for-linux/ZJ8cNUW3oR2p+gL1@boqun-archlinux/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: David Gow <davidgow@google.com>

Thanks!
-- David

>  include/kunit/test-bug.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/kunit/test-bug.h b/include/kunit/test-bug.h
> index 30ca541b6ff2..47aa8f21ccce 100644
> --- a/include/kunit/test-bug.h
> +++ b/include/kunit/test-bug.h
> @@ -9,6 +9,8 @@
>  #ifndef _KUNIT_TEST_BUG_H
>  #define _KUNIT_TEST_BUG_H
>
> +#include <linux/stddef.h> /* for NULL */
> +
>  #if IS_ENABLED(CONFIG_KUNIT)
>
>  #include <linux/jump_label.h> /* For static branch */
> --
> 2.41.0
>
> --
> You received this message because you are subscribed to the Google Groups "KUnit Development" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kunit-dev+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/kunit-dev/20230718052752.1045248-2-ojeda%40kernel.org.

--000000000000f550dd0600be6b51
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
9IGQSBx2i4m+hGXJpET+MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQCMAAwgZoGCCsG
AQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouse
LHIb0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
Y2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQCRI3Z4cAidgFcv
Usqdz765x6KMZSfg/WtFrYg8ewsP2NpCxVM2+EhPyyEQ0k0DhtzdtGoI/Ug+jdFDyCKB9P2+EPLh
iMjMnFILp7Zs4r18ECHlvZuDZfH9m0BchXIxu5jLIuQyKUWrCRDZZEDNr510ZhhVfYSFPA8ms1nk
jyzYFOHYQyv5IfML/3IBFKlON5OZa+V8EZYULYcNkp03DdWglafj7SXZ1/XgAbVYrC381UvrsYN8
jndVvoa1GWwe+NVlIIK7Q3uAjV3qLEDQpaNPg1rr0oAn6YmvTccjVMqj2YNwN+RHhKNzgRGxY5ct
FaN+8fXZhRhpv3bVbAWuPZXoMYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
R2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAy
MDIwAhABAz5xDls09r2CKyYRqnNbMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCr
mGSr3VwEFgpPPXp5AOQ0e7Fj+m9XQ2chqiffqdWXHDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMzA3MTgwODA4MzVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsG
CSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAh02PpzUnpIS7pV8w50uN
RG7xtgF9aTIdMl1jSWs120EjwUSuR/S6EAAcDGAcuIeT38zxU4oOhynfcDQxrBKCgzSuz+628CiD
uqh1lOjph+rLZl+33roJnmdGmqytiPGxZnmu51gYByFRONJlwwvFBu9OJWC2vttxfGwEJmtUxw9u
lvHA2D2c3lnBYLtrJzi/6XWoZO3jn3oBkcZJDvPHsIgrkKw3E/yqQL7AZ/zjcdoOQapuIX2uhjPh
8eQ/zVCQNytq+nRTn0mluhZWWji6ONlXR5kxAJmZHnJIBRRlYvhq26SRtUoHWrlb/qgt/t5vZmti
7eH7PFDGsLy2LRmnig==
--000000000000f550dd0600be6b51--
