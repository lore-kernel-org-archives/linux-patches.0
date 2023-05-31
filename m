Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE438182D9
	for <patches@lists.linux.dev>; Wed, 31 May 2023 18:15:13 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-3f805d07040so33750791cf.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685556912; x=1688148912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4b+59wHppr/MAOrrv0BsVtn85WuHM6SCc3RDy+wBhi0=;
        b=cqT7ghYaqkUUut2OKUbVefmlSGuaSwtHoTRSt2R222YM/q6B48JERjwVoquTtO5BFZ
         KqPPhVqbdxFjLxZ0ZU88uUGvpY2Woo6T4YTTB3WBzNvwuU2LUAWoQQrAP+rELMpMgfDF
         q7lHwoIj93a9Zoht6igBZwdrjr870Ah+K+KXIajHbTo6zHWI+HJTX8NGWrn1d+Jkf9Ah
         oV/+jvIjC7e8iG/7JQQ0LxHqD/yldfJJz+OGuGjh7ZzC2exbhb/OMmPMvmyq/iqsZRMb
         Rw4JL3o+jitTKkafgDKHkbg57+ZUKF/9d88Ex3C9hxUwq8cz9AXQD7xgt3Njc7RFEt0S
         r8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556912; x=1688148912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4b+59wHppr/MAOrrv0BsVtn85WuHM6SCc3RDy+wBhi0=;
        b=gLmx2NIky2nxQUTI+jdxe47InUegmoueKIOkru5cRI5rUReDxNywr3vO/XTO+4OqIS
         fSshlcpT2mN5mpQ6BIP8T77wd5xK38Gzv3P3/0yFjrGxEPCcRTEsKjAdjVpqSCh95Y7S
         qzGxM0fj4fGlZ6R4MMz9Xx+U5j/NAXAmGAYNN7GIdD51FSffhRIVOshk6lfGXafYc0tH
         phaUILkkWc8knxszeSNkcZUYCLbMTfJg25fUyR197tTHRUfMpCQKsux2KUOC8mGLOXYa
         uiJbA6zWi1h3jJg97Rhe8ZuCLXLz2SgCt6pkY8vNR6KMrqav3EMMN/vyN1pZLcz03wpZ
         T1gw==
X-Gm-Message-State: AC+VfDx++AY622ljrQ2f62u8tOOYpPyE4MJprKdMUap31n7JOhEtBVyy
	vCDqeNpYWCjdTeXrI2TrZryG/ONrkyailOGeA4I8c29as+t0cuzw
X-Google-Smtp-Source: ACHHUZ7T4rgiA3BO0y3KMEaoS9f/bCxbQDFGFDD5kLRyYagdle/SOfcwNa33gkxYPqyovM3MESJfqFVeGKj4+GafDVc=
X-Received: by 2002:a05:6902:102d:b0:ba8:6c1f:f5ad with SMTP id
 x13-20020a056902102d00b00ba86c1ff5admr8001103ybt.29.1685553263977; Wed, 31
 May 2023 10:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230531145939.3714886-1-aliceryhl@google.com>
In-Reply-To: <20230531145939.3714886-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:14:13 +0200
Message-ID: <CANiq72k6YKjPDqcT9g5BT5pYwypH5rLjwafcEEhddTfErcnNDA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Update thread safety markers
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 5:00=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> In Rust, the `Send` and `Sync` traits are used to mark in what ways a
> specific type is thread safe. In this patch series, I add some missing
> thread safety markers and improve the documentation related to them.
> This change will let you compile some code that would currently fail to
> compile even though it doesn't actually violate any thread safety rules.
>
> You can find a definition of what these marker traits mean at [1].
>
> Changes since v2:
>
>  * Removed "for example" as suggested in [2].
>  * Added Reviewed-by annotations from v2 review.
>
> [1]: https://stackoverflow.com/a/68708557/1704411
> [2]: https://lore.kernel.org/all/20230523165027.71600b4b.gary@garyguo.net=
/

Applied to `rust-next` -- thanks everyone (and Alice for taking the
effort to send this v3 even for the small change)!

Cheers,
Miguel
