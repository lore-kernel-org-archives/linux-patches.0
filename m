Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FEB17736
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:10:04 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-bacf7060678so530276.0
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685553003; x=1688145003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5hNAeMykYH6m+pjlK4ZKQGtK0LDuyxxmWVTG0iy4gk=;
        b=RgBb769DkAHCjoOyku0LjFwuuuVlYaimpuChbm/e6uqQonNgWj6Wkw86cPMdU6eXz3
         IKYl4uH6w2nuanrD3CiroKb7ap7n18bm2RMoeLg/lKSqp/8MdBmzkuXUOIldyx2OkRT3
         ZzxCY3GKi2PQtdVqYrIBrp+fD4+xUvumOR+8v200q+Pmz6dY7YhinaEm8VmIbSzMeb3H
         S0ZI1aUrGebHJfqc29jWbkXjDdoLXBgdVvnvhT1Hd/QL3kg3qRFs8A5YuV4dpOsgxydk
         6tsP9dzvIlUb7JwM8sIneb6X4//FQJ755f8Khi6Ktc4kjIQAgt/l6LC7qbc8+/mXs584
         Hgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685553003; x=1688145003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5hNAeMykYH6m+pjlK4ZKQGtK0LDuyxxmWVTG0iy4gk=;
        b=FNx7FeM58rHG4GsbK0rPKcpZS1jRIRn0FZqwRHZMT2EBhtjIoyl6e95QUdCZp15ZHn
         X+ygnSAzrolGe33XMEfMELqyCpJqEC1HlX/+gjQIHfqpn2UkDIrte4yzsPg2oW6RdZ2A
         4X3mNCZT8vGqUtaWtNTM/iA2ro7JcU3P51nq05hQhOWInrrE5V6k+A5UW9bPADV7hU2M
         wtONHBUkQvwBhFbLHG5fVUaQ+bpeVJ7pUujDM53jbK3ZagnTOpYTLl+ikUEt+fe2Edvf
         Ym99VJEFfNncdaNrb2SAFNyi+qvmAUoZr/TfFFYr1Ku9cYZTRXZzlaekgt89cc0sXBKr
         YGzg==
X-Gm-Message-State: AC+VfDyt+eqAA2blX2QjlCxuZzILctr+Kx1DlSm33A7PsEdIT167gAiW
	6BzZUEClxJA6yQ1oOc6+rVuFPISqw0N+whttDjU=
X-Google-Smtp-Source: ACHHUZ6gziPlD75sFBIWzYJKukeguq7CTPeNtKJWb7F/xT/sDpz2WsRUhNOlU+011ytGs8Qg/NrtXYae3YXJc9tUeRs=
X-Received: by 2002:a25:e64f:0:b0:bac:fd8d:94b5 with SMTP id
 d76-20020a25e64f000000b00bacfd8d94b5mr18876773ybh.13.1685553003652; Wed, 31
 May 2023 10:10:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503141016.683634-1-aliceryhl@google.com>
In-Reply-To: <20230503141016.683634-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:09:52 +0200
Message-ID: <CANiq72k6kSHPNjQr+PEB3KGO05M0mGet5un7jVeNeS_02uEzZQ@mail.gmail.com>
Subject: Re: [PATCH v2] rust: str: add conversion from `CStr` to `CString`
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Martin Rodriguez Reboredo <yakoyoku@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 3, 2023 at 4:10=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> These methods can be used to copy the data in a temporary c string into
> a separate allocation, so that it can be accessed later even if the
> original is deallocated.
>
> The API in this change mirrors the standard library API for the `&str`
> and `String` types. The `ToOwned` trait is not implemented because it
> assumes that allocations are infallible.
>
> Reviewed-by: Benno Lossin <benno.lossin@proton.me>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
