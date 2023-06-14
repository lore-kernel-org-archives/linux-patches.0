Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39DC134A7
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 22:09:42 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-bcb6dbc477eso1135427276.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 15:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686780582; x=1689372582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxCYYqgD5haUCkeC5DXhN+uLq5/abXQjgXDwO+5hkwc=;
        b=dT92Uk2SGyIBASdn2lfY84qqz+cSYS7DEvwolim1KJ8NqEiRlMaf1uBLM07S7UDzZ9
         uk6HN3gXsTCujof6V+SQ1/Bl9SqtIB9ZpOiLjEGQSDaKbgB61qVRT2dwKZ9oXuiSWSjg
         6xMvZNJuUxLs1vEaz33tbMB3hxiBKlS4jJ2jCVfSm8Jcj2+T++v1CSo6VtmQSo2y+yfu
         lXnrSLtbB0dCwiw2twlcqaOJywLugz/d62mngkgHiJGB4WNogu5g8ZFV1e3D01bxUxrB
         lGvak+5Ctw+fJY7TSslNIB20RU3R40WYKl4YxNjs+vwTheNvj8jmcMWPmMumtRbIFSO/
         AnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686780582; x=1689372582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxCYYqgD5haUCkeC5DXhN+uLq5/abXQjgXDwO+5hkwc=;
        b=MXr5rQaKxnNPU0dmLdWgQP1uGvcF7i2Z/6cMQGuNPZNIWheAjr/bIeNSQeo+nADGiv
         mPXhegzxOqzJKqZHAVCyeHpMAIC+AnnMR0ZtQAH8UukVa2kD06v4SJBpk1oftmQxbx/L
         FB3QcwKta+qpmA8UfhpvQUMu0Zh8U+qyjQyf9bGm7fFOS8W6jlrBYLrlx1QtdemEa1s8
         eFGBcLOzNUwmvekW0lSKaqLVO9T0BNlxSAfLdyG9PUtAqxLrvYt4hs0AZL3vs5km0vfu
         uUpuoYtpMLCj58lTQ9Frcreq7/G3Oxi/mZ0Nj9sXT1WblmqpV2N14cttT3UlivdlnIQi
         mFrA==
X-Gm-Message-State: AC+VfDxV9ydxk4Sl/T2NjTuJpMxv+7MTVzpdNSCq36x+whNpPesekg16
	f0DWp11g6AB0sDY9uma3KqGwkt8JnuLpmvkN8LA=
X-Google-Smtp-Source: ACHHUZ5Ki7h45tEWuN2EE3YC5f6+IiHoRICcZpFhSuZgR2mQeCO1yeN+ZS7sLNMFWqW3qJyi2KZE+OGtbEesC1AoGK0=
X-Received: by 2002:a25:9343:0:b0:bca:bc83:d315 with SMTP id
 g3-20020a259343000000b00bcabc83d315mr2765786ybo.48.1686780581786; Wed, 14 Jun
 2023 15:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-1-ojeda@kernel.org> <20230614180837.630180-6-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-6-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 00:09:30 +0200
Message-ID: <CANiq72mM+=XBWXBqrgkBcSwR2GtC=PX5WwTB8+-Tm0wVOMtgPg@mail.gmail.com>
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
To: Miguel Ojeda <ojeda@kernel.org>
Cc: David Gow <davidgow@google.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 8:09=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> +/// Prints a KUnit error.

Nit: this should be "info" instead.

By the way, we may want to have "raw" `pr_*!` macros without the
module prefix for cases like this in the future, in `print.rs`. But,
for the moment, I added these two ad-hoc ones here.

Cheers,
Miguel
