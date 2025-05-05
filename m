Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3111DBB37
	for <patches@lists.linux.dev>; Mon,  5 May 2025 06:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746425007; cv=none; b=e9pER8VU1UpnsNp7fYoqN4wMTdvlf64EfnYoCZvFCjZC2M1DrXH0kKcoaoltd0CtaDCZot1m1pbojBbIJRpmDEi0I1Vr0ZIVZp45JRv+AoOclNNMY2twK3U1gkDrEYP48HhkZHwqgON+q9towxgwaYvIVDHMFh+MHnRw8EvOVKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746425007; c=relaxed/simple;
	bh=jCK2w7LeIjsbCKLQlcSeAoUo2dKhwWTs/F2DR3ARB8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CjFu6E/QnKKQJWFnGaNiAPMay/mtPMuJXBioWdOYPfz3TS0gZQArZ9On27dS/IvlVgdOknItkAQ59+DCM+c6ZQAbmUKEyGdV1iZrdK3GctvgDsYlZDnmeZUtf8oPg/82fVgPO2/14oGv1mVL1SZ8NUVuNAi1TbB3fo0eSpL9zzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s4xZmggK; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s4xZmggK"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f2b05f87bcso44850166d6.3
        for <patches@lists.linux.dev>; Sun, 04 May 2025 23:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746425005; x=1747029805; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jCK2w7LeIjsbCKLQlcSeAoUo2dKhwWTs/F2DR3ARB8U=;
        b=s4xZmggKGBF4nfXWhbqxbYmdvZV7NwbhL5Ptl7/XaDU2MRihgfC20LVAUGHsN95fCd
         rCw/LlKjCok7kFtk9AZ0j2ubp97ZQlLtntQGbja05CmWQFkYwNF9L8yeFrTAZuplR461
         Ur0zsKmHrDF19BhB5Uu0cXws6AqAjYx7f5DP80RK4+lUsXc2uWZlmZT2I0OfYP+5TzN1
         F7UFMxUojl89l3Z6SWhCR9h2+14hUuOT55pMleBzC+C3ndTptF8+ZGiWSD0LKfDNUYR0
         cj/AcEOpe0+j7tBd9SUVukzhRLw00wRZdWjZTC3ISugu3dZiZ1LKm6ghMrrPa2abiiGS
         Y1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746425005; x=1747029805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jCK2w7LeIjsbCKLQlcSeAoUo2dKhwWTs/F2DR3ARB8U=;
        b=CjmREPArNk66KPjv6vn/RDu1vPSNyEVZzSR3WY4/0Xr+7/KyWarstpeIgewWH0DlJH
         QbKB69lpD4hLKQSpUFvei3SqsIg/hL7svTqhsw4s0i0xewMKoOXO75BOnXbUW6tC+KAq
         URmyp/FQI25Ce66RB0wjwFtZgkMX5Fi5cVLQ5wiJz/E8YINK1QDLvfd94TZUUeOCCHNl
         uvLE3VQC9OhNNpi2PfGwR3xiZ4vcVrabA/LETx6vBSSrzG33op9Sk8LOr0l7ShfCHzGZ
         hJBzqcyppsKXxe6rhmsqY1yhzr1ARElmUq0QeAbWiWXso+/j36DXUfJZVFEGbzlgmAl0
         NCVA==
X-Forwarded-Encrypted: i=1; AJvYcCUJibuyNa+dz2vDgS+D2Tnf7wOIPkAQ5nnujZddX1yc/PVzmEioUBOTUHtTO/fvYJkweYPpKmB8@lists.linux.dev
X-Gm-Message-State: AOJu0YznT4Y3GQJWVHOhWNmb2ycsWjB3JGmzeobJzt7cb0HDOb0uqw7+
	B+ha5kU6vaLBlcOm2vLhuAgWRWNjvryRUdWEpzvclGSGs8ZoV4nJQCDrjzH04oExVwcytkcSqSI
	QDeGGrWW1ahuJA9d0w4w3CFvNgyxy7Uwyfmfi
X-Gm-Gg: ASbGnctVtzgUpIne3fRMjiA1ncWRY7abrULpxwkZavAs2X3nLgXb7X+gFhyf9ggSYF+
	d8qNHBiHkEC4uhheaffW3nuiinyZ16ca4S4rJW4aW+3cNsUcGx9hgEk+m5K7ZKZUgvqvoAzh3iV
	Vy4mOa4W/AryGtSQWKbj69yT8BQ/ncmoQ2KQ==
X-Google-Smtp-Source: AGHT+IGPMxqd0sS97U++gnBsqEZPVrUZfRwIlskJo59E9ztn9Pt0KLJkD6dhH3UrFgDvnNH+4Hs2QD2Lsv0U6k41ak8=
X-Received: by 2002:ad4:5f08:0:b0:6eb:28e4:8518 with SMTP id
 6a1803df08f44-6f528cf30eemr87945456d6.34.1746425004509; Sun, 04 May 2025
 23:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-6-ojeda@kernel.org>
 <CAJ-ks9n7u3WkYmJCVc18c_cKod6DaB7KrA7NXbOuD3E3TYbvpQ@mail.gmail.com>
 <CANiq72nEHy5wvOyPzW4DLu9aE_MxTx1gq7AJ-f_Ny4E6bbOJ5g@mail.gmail.com>
 <CAJ-ks9krSxo_DWFJdccP+SYJhX4WF0hXdq-20Rtf3doMp_2zDw@mail.gmail.com> <CANiq72kLz7nXOKR+f=pNCu=hEEs6XQV_oDr9-xB_sq7N+svQ3A@mail.gmail.com>
In-Reply-To: <CANiq72kLz7nXOKR+f=pNCu=hEEs6XQV_oDr9-xB_sq7N+svQ3A@mail.gmail.com>
From: David Gow <davidgow@google.com>
Date: Mon, 5 May 2025 14:03:13 +0800
X-Gm-Features: ATxdqUGTECUSW1WA8h9_OcBfkVaUpBooGoacLVYmuAnyAtfvJWLDiRDFFUC3cJE
Message-ID: <CABVgOSkctH7wnNm+Dy4=kszzwURmV0Ac8CXcKwJjv9-iSLo2Jw@mail.gmail.com>
Subject: Re: [PATCH 5/7] rust: str: take advantage of the `-> Result` support
 in KUnit `#[test]`'s
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <rmoar@google.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000d273f06345d4218"

--0000000000000d273f06345d4218
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 5 May 2025 at 05:54, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, May 4, 2025 at 8:23=E2=80=AFPM Tamir Duberstein <tamird@gmail.com=
> wrote:
> >
> > I see. Up to you, obviously, but ISTM that this degree of freedom is
> > unnecessary, but perhaps there's a benefit I'm underappreciating?
>
> Well, having this allows one to write code like the rest of the kernel
> code, instead of, say, `.unwrap()`ing or `assert!`ing everywhere.
>
> So easier to read, easier to copy-paste from normal code, and people
> (especially those learning) wouldn't get accustomed to seeing
> `.unwrap()`s etc. everywhere.
>
> Having said that, C KUnit uses the macros for things that require
> stopping the test, even if "unrelated" to the actual test, and it does
> not look like normal code, of course. They do have `->init()` which
> can return a failure, but not the test cases themselves.
>
> David perhaps has some advice here. Perhaps test functions being
> fallible (like returning `int`) were considered (or asserts for
> "unrelated" things) for C at some point and discarded.

The decision to not have a return value for tests predates me (if
Brendan's around, maybe he recalls the original reason here), but I
suspect it was mostly in order to encourage explicit assertions, which
could then contain the line number of the failure.

We use the KUnit assertions for "unrelated" failures as well mainly as
that's the only way to end a test early if it's not entirely contained
in one function. But it's not _wrong_ for a test to mark itself as
failed (or skipped) and then return early if that makes more sense.

> The custom `?` is quite tempting, to get the best of both worlds,
> assuming we could make it work well.

I'm definitely a fan of using '?' over unwrap() here, if only because
it won't trigger an actual panic. That being said, if it turns out to
be easier to have a variant of unwrap(), that'd work, too.

The fact that not all Result Errs implement Debug makes having a nice
way of printing it a bit more fun, too.


-- David

--0000000000000d273f06345d4218
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
pjANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgA75bZsLzg0/8leRZj5UMhDCE2jBc
86F9akUla2WfkXowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUw
NTA1MDYwMzI1WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEASdrJmLUwSIrsP68YbzxPLjsPwK9qg1NqUKYdzo+NdsTN+0WBJRkCyJIN3c4Sf8Bi
sJWQSpMrzkKiOu9sPlJvyf6p72poloDKAgChnM6dVOvMc2AAoPw0aTpiq7NCoVf4IC5KxC1EXKmm
nrHB5F8rKBRCODXjrdA448zXyYyHg4Bcm1xdh0PyuJslBzCSRrrC6HanL6iyFoIJ7j4pT5BhpSnE
LMBenPDouXAUGPsNePAwpxw61VasCdDDfkCry13U84dVUmef5UidIwqzXQAIOidOps3CYdhZobqf
g9RWLRjeT8Zh4+rA2CU1Hjc3p4E4k70+H3jlhZjAlPtnP6Yfig==
--0000000000000d273f06345d4218--
