Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E093064F
	for <patches@lists.linux.dev>; Thu, 31 Mar 2022 02:00:29 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1115468wmz.4
        for <patches@lists.linux.dev>; Wed, 30 Mar 2022 19:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Du/Js+FvvpIYuoisSnYlkJOOp8s1sRdSEud8rdDTEgU=;
        b=nFQFnWvIaPB2V9gt02OcrjCOoghyJbTcd8D909FGkapfOo3oRMSI9492fvwfVMrY3T
         Gq0cEBmomkZ9l0tcs0OGGTLjMhGshGuYdp+lBXC2BDZGJlKmSur5E/05o/IN6Li4t8Kk
         eTMnjjg6eGJBGwaaid3TLu1a5uMw8fn6UpLGBNQphcf+t5mS3dRVsBAQkhLTvuYM5kR9
         7xZycbvHe3+Pn/RJqRen8Q0cEYWMNjc/Cw07g9SlL3MH0geX+pf+19cWpiBtoyord+w/
         oUe5EqdEC5C1YFekeGtABUJbUyZZ9pcGO7PcBS19XVacoN6bJKho9Bgweq0HnVwq97f3
         jRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Du/Js+FvvpIYuoisSnYlkJOOp8s1sRdSEud8rdDTEgU=;
        b=32iotZRgyD8UQv5eVjCCX7dUqFwYeC33u/vnBvRWnbejrCzjH88iSdsLE7qG3ZM/fn
         0Ht6ksAejStbuvtpw6nZ817bIIn1g8ocEuCep/+9Ek1zEe5UfZTj9ecPSrmvj16wv2yy
         2zbkrXZi/Y1OQW4hRaP4Yh6x1AmgUW4LJ7/dcDhNWEmzskofcJhFgMXJ2IB/mwvgCvP+
         83hVPHJ9iXA99Qlho3KZyv1QzCDx6/IvR89nLrn8luLDgKgTFKEioitujctV/yby4KtP
         OB9ASb30qOMHjC6+vr8VNUaDScoXjHZOUANVAiJrPVZCKvXqNUP0+YyI8F4YdCmlYkcs
         LKZA==
X-Gm-Message-State: AOAM531vo31xGbHkLHMXBtOWFxE/076rOGzoholqRXJh8cKERWYFjgKg
	zah65sSWYwwpauu4M4V91sL8QNmR4pZoI+NNii7JsQ==
X-Google-Smtp-Source: ABdhPJwc7cIZrbcDtT8oN3Uc/i8d7OuUgxfn6/gsSmmOZtKtUns5P8AZUjMI9YJfo8Xv3zrLvlgeH46KQa1wtE9NM+0=
X-Received: by 2002:a1c:7906:0:b0:38c:8cfa:cbb0 with SMTP id
 l6-20020a1c7906000000b0038c8cfacbb0mr2445694wme.163.1648692028147; Wed, 30
 Mar 2022 19:00:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220330234528.1426991-1-nathan@kernel.org> <20220330234528.1426991-3-nathan@kernel.org>
In-Reply-To: <20220330234528.1426991-3-nathan@kernel.org>
From: David Gow <davidgow@google.com>
Date: Thu, 31 Mar 2022 10:00:17 +0800
Message-ID: <CABVgOSnX+bYKvGeJDeKpM8tCe_fCzYC4=6Eh3EUV54SK2SC7Bg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "um: clang: Strip out -mno-global-merge from USER_CFLAGS"
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Kees Cook <keescook@chromium.org>, 
	linux-kbuild@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-um <linux-um@lists.infradead.org>, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000b287a605db7a06c5"

--000000000000b287a605db7a06c5
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 31, 2022 at 7:46 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> This reverts commit 6580c5c18fb3df2b11c5e0452372f815deeff895.
>
> This patch is buggy, as noted in the patch linked below. The root cause
> has been solved by removing '-mno-global-merge' for the entire kernel.
>
> Link: https://lore.kernel.org/r/20220322173547.677760-1-nathan@kernel.org/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Looks good to me: getting rid of -mno-global-merge entirely is nicer, anyway.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David

--000000000000b287a605db7a06c5
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
G7p3AiuB2sgfq6cOpbO5MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQCMAAwgZoGCCsG
AQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9n
c2F0bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouse
LHIb0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
Y2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQBsL34EJkCtu9Nu
2+R6l1Qzno5Gl+N2Cm6/YLujukDGYa1JW27txXiilR9dGP7yl60HYyG2Exd5i6fiLDlaNEw0SqzE
dw9ZSIak3Qvm2UybR8zcnB0deCUiwahqh7ZncEPlhnPpB08ETEUtwBEqCEnndNEkIN67yz4kniCZ
jZstNF/BUnI3864fATiXSbnNqBwlJS3YkoaCTpbI9qNTrf5VIvnbryT69xJ6f25yfmxrXNJJe5OG
ncB34Cwnb7xQyk+uRLZ465yUBkbjk9pC/yamL0O7SOGYUclrQl2c5zzGuVBD84YcQGDOK6gSPj6w
QuBfOooZPOyZZZ8AMih7J980MYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
R2xvYmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAy
MDIwAhABQeVybOOpR4bOOXZYL5T3MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCD9
dTJ3C1ML/jXUB2jWCjpYGFbLWDtAavKA8DvwSr7e/TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMjAzMzEwMjAwMjhaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsG
CSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAJCySVqF1qIZbPhMhq6+/
BvcbQuYwUKMwe64ZdWNCNfa8ZM1DhEk/gwp5+lnmAeIYSuDIwql+RplAPAn1+nQPWh2nP7kT5Bpa
pjACyaLX21TYfsQe4ctBRsdJKikKu1t+TQRRen4a7xOEM+jk7l04bEbSPiyEULQFodzPKYw6Xhd6
YS2MX0OPOuLS4ACybo1cm8MgAxyVC3O8SrIUPTSVHHFIkhTxjOrto/H2ubz9FEbWzH9gVVKzc56b
zK46MsKKeULiygPXgY4ta1HTm3NG2hQfhFF/FVu4TOsq4eJpuk0A/8g71GH8OWeBs97pubzKg3Sx
NBPCKJ7ivys9Vbi1zA==
--000000000000b287a605db7a06c5--
