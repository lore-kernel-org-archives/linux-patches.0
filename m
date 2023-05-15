Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC818C18
	for <patches@lists.linux.dev>; Mon, 15 May 2023 19:09:50 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-965e4be7541so2298707666b.1
        for <patches@lists.linux.dev>; Mon, 15 May 2023 12:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684177789; x=1686769789;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=eFN3riFsUX1aJRke3gkBwMCKuLwmmi07T3ndOLDE1rE=;
        b=VOV8h1KkyY041gieBzFWVDYmm77Y0kEVHfmmBrRS94nWAjdcrIHJicpi5dpBL0RGtc
         apvToY3T3UaYZl4IxZjJPnRrHyst5B2jLO7YkD1ZDpmRswVNsdcEdA6DfYmcWa412HRF
         aIbxdqjMIQJ0Jtc7zWMywleKuM+kVXECqeNegXfkQML2Hk/gWA9qnxkXy8IxC1VFDFGh
         8waZS49PIiJZ/5PWc/sqyFer0kTJiaBnZexS++5In6HGJcxoDoKLyzSWsNXGHeGN3Bzi
         cUX1JL9Jwzg5sWMylB9MTpIMq+xOAPd4vvHGaMtmDIwia4ysgm10nCS3/5H526nMpzHa
         PPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684177789; x=1686769789;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFN3riFsUX1aJRke3gkBwMCKuLwmmi07T3ndOLDE1rE=;
        b=FZfxWI7sCfeaWe8hDP9mrB+Ai8VriXi8RGJXhxrMYKWPwKfTxcFpRnL010oxCo8RNw
         GYsMH0WVbqhNmwjrY87sRdkdQHKisGVwPGnHKDD6oFgC1OhPmapoNJYMJ/iL+2NlADSy
         ArPps+YrL6xSsQnDXftRTE+/A/2X9BlV7O8qodsnej8KaIyujA1DTcyq74w/934ZOQdz
         CfogfLRpI5xFdNQYLIrkgHG2xXb2AR3L6eCs9lJ7VgpYOmxU36gAPzlqTbBcgb/PqWLQ
         om0G750ViB3eiLwu5YtRJ497NQEo9T8bfMG8bOn4bxZaLWFQhLSJlphsR6z5vUefcT/9
         6o7g==
X-Gm-Message-State: AC+VfDwbYdNz/p4EsoWjH4yQEDx5SESWX6lqgRu8dT4gzsmW9e1tHnMM
	eKTg3sSAFO122Vu5njD9FBl6jQ==
X-Google-Smtp-Source: ACHHUZ6xoBq5iKbeuoQ9ODrTl6E57S/8BHMQ8gP6REFxuQcxS8sRjPcAEpK0ls47icDh8mQwvmJ1Pg==
X-Received: by 2002:a17:906:eeca:b0:965:d17b:292 with SMTP id wu10-20020a170906eeca00b00965d17b0292mr29875482ejb.60.1684177788655;
        Mon, 15 May 2023 12:09:48 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id v21-20020a1709060b5500b00965e68b8df5sm9898010ejg.76.2023.05.15.12.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 12:09:48 -0700 (PDT)
References: <20230502124015.356001-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: error: allow specifying error type on `Result`
Date: Mon, 15 May 2023 21:09:20 +0200
In-reply-to: <20230502124015.356001-1-aliceryhl@google.com>
Message-ID: <877ct9o1hh.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Currently, if the `kernel::error::Result` type is in scope (which is
> often is, since it's in the kernel's prelude), you cannot write
> `Result<T, SomeOtherErrorType>` when you want to use a different error
> type than `kernel::error::Error`.
>
> To solve this we change the error type from being hard-coded to just
> being a default generic parameter. This still lets you write `Result<T>`
> when you just want to use the `Error` error type, but also lets you
> write `Result<T, SomeOtherErrorType>` when necessary.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/error.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index 5f4114b30b94..01dd4d2f63d2 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -177,7 +177,7 @@ impl From<core::convert::Infallible> for Error {
>  /// Note that even if a function does not return anything when it succeeds,
>  /// it should still be modeled as returning a `Result` rather than
>  /// just an [`Error`].
> -pub type Result<T = ()> = core::result::Result<T, Error>;
> +pub type Result<T = (), E = Error> = core::result::Result<T, E>;
>  
>  /// Converts an integer as returned by a C kernel function to an error if it's negative, and
>  /// `Ok(())` otherwise.
>
> base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162

