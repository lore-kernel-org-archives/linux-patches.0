Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A89153BA
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 09:23:36 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-3f9dd2fabe2so27628921cf.3
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 02:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686821016; x=1689413016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGOHFXjoBS2ub7744MFzAfGB3y1RlKfr94cgOk8utvg=;
        b=bQPiUW2V/29fzHAWymvAuQKmj6vXfz5zArXjocuKNgdfoFxWwTMHtWWS1g/dPGmOk9
         gdnCT1uCVb+1TPiOdR0qq9Xp55gm3Kw4HgkiENLdyJ7Em6K1KJ56gxXpvgsUQyLNq9hH
         iRHuY2mIidQd/qDJsBLM0FfcS3GxlHfjBgvZa/zwYlokG3p8IZ9nGTQi/FWiMwiarjy3
         rjXZVu71fjJjFrKCb9n7BsQc+43Pj4ZMEH0O1Kb23mLVDUQz36LbEcCldXeIWmrYPNp4
         rNR5x2LPD5WKSr8vCsvMUGSl3NUds51A18JWFiHz6B0U1hBuYdtMcdL11Jg3SHP+d5SN
         hUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686821016; x=1689413016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGOHFXjoBS2ub7744MFzAfGB3y1RlKfr94cgOk8utvg=;
        b=XLveTnSn98UnWKwsdhppLupxC1K+MCrvGF9swv41UVK+kpCWt+gQQAeuCGSCWNmS9D
         BFH1l9jI2tRTpPC2F7Sr6T9ZwfV5W0S3OKyZD4KnzTd7v6GzIIDuP4uSSiUcGVB1S5Sq
         YnaT0vs7149PEaj6WJyyJYVjoWwmMIyxRadUd2oDXgJvLYww3bfnHXNOY3kPtkHA8sET
         eZt104Dyla9hvQjVWlMTnciMwbXoIj7yZBPceJWeTg01x0q8KZdu5GVVCoCa7wT8+Vr7
         VX6KzyhoOfGDfFzZBnUaFxl5gVDMvJdlQE0WG9RDcLjgheBi+t3q0SWRWfbYbcsquC7G
         WD9w==
X-Gm-Message-State: AC+VfDyFm68GaKF8CJpRILnsVTnruCZeX8UE6Hbm1vulEnOtXjE+PGY2
	l27m6vNwwwMUAyDwNAR0zlfldKgLUzkBdDeUaxA=
X-Google-Smtp-Source: ACHHUZ5Xi1q7Qr8BpQtJ7QY25OlQp8ICSTCgK7JFeKCy6nELV0YWKp8eHxludT1KOtcxg84RnehJIFUxL8ijvgsUqx8=
X-Received: by 2002:a05:622a:589:b0:3f9:d70f:ff6b with SMTP id
 c9-20020a05622a058900b003f9d70fff6bmr5547763qtb.56.1686821015825; Thu, 15 Jun
 2023 02:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-1-ojeda@kernel.org> <20230614180837.630180-6-ojeda@kernel.org>
 <49dad8fe-c509-6c43-559e-13a82563d3d0@gmail.com>
In-Reply-To: <49dad8fe-c509-6c43-559e-13a82563d3d0@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 11:23:24 +0200
Message-ID: <CANiq72mq4wYJ77qDKYWTO=FkA1AYat2rJd63Gps9aUrP82c9dQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 5:52=E2=80=AFAM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> I can't remember that if this panic it will mention the path on it.
> Though if it does, then use something more explicit than
> `.unwrap()`.

It doesn't print it, and I am happy to make things more explicit, but
in which case(s) do you see it failing?

> Please do not use unwrap here, one can easily create a path that
> it's not compliant under `rust/test/doctests/kernel` and get no
> clue about where this script has failed. Use `.expect()` or
> something else instead.

The folder is removed every time, so that should not happen I think.
Yes, you can still hack things and call the script manually, but I
wouldn't call that "easily".

Nevertheless, I am happy to change it if we think there is a risk,
e.g. `rustdoc` changing the pattern (though we pin the version so
far).

Thanks for taking a look Martin!

Cheers,
Miguel
