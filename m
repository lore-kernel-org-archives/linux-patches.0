Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874882904
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 13:08:16 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso13817878wmo.0
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 06:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680268095;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=E8V1Bl8K2mO5BPBfvC+IG4HaObqCUBUdhVKIlW8yaQo=;
        b=D+VDfK4ViTsTLqpx0PYLWBqb8J4neG7eMOaU8bJKAHpCu3K2VVXJrxkgG7HWg3RF7O
         3YhBpfhQuOWzGFwPd9EmvBhb2eEAFocYMNDJPJ63OD12pRlFkZYUjZznBY6J4SL7/GRa
         HkrePY+ZI4Y/ouzuNx3DPy13aqAAt2vp+0saNScT4C60weOcSvZGni0SvWvojiB366yb
         a7Ku97b4NEoRLLi2nYa99gWk2ScH284ibaIerojT0XEi4+DAZIxIOtjVCdMvdE+cMlPb
         jAihkEPRJd+qbjGxkmWlVI6kKtUBJ+6S9Ff2/Ok/Ks1Hj7kA+poVXUGC5E3UfQtpTiuX
         wqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680268095;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8V1Bl8K2mO5BPBfvC+IG4HaObqCUBUdhVKIlW8yaQo=;
        b=yTk2+VEbEyLPAS0ihL2nfkIi465BTtfNjcVxUJ43rX0I7FXAfgaTPBMYTK3gjorgn5
         8+Xftl6p+EaHOriSogXaZmiNzh9tzI9M+7NKnJ6a1Tf22QV/zpeyAzxuReWUiAB6G+B9
         vmZT2T7G2tuUaJGAhnrEYLFyQ6G5Pjh5O7aGJ6IiWLtslfh9PGW0kgaxKZ9youBTMADC
         +35KaVe58oajEHlVfKkft5hXMgFqIKruvNdLIrtTql+WXjjgMhLXDLatTGU4xAeQ1zPY
         glDDsXrZsQofniIEft8QVEUjfPRREoMI9kbKL4S9YopK54HI36twCSM0kLsrYLWFo2cS
         5BrA==
X-Gm-Message-State: AO0yUKUPlo35ZaWgbzIpcQXjb3OcoU/jVM0kWleIIHmfXEqsqIXGaqgQ
	comv+6tw46849qFpfDIMCxFZTg==
X-Google-Smtp-Source: AK7set9GiuiV4b5e/vjtDk8YReJcNQd/gJiW/RM6IisXdlqLJy0t+QpeZbakT348E4FFd5LuKwCOKg==
X-Received: by 2002:a7b:c8c3:0:b0:3ed:711c:e8fe with SMTP id f3-20020a7bc8c3000000b003ed711ce8femr23029661wml.2.1680268094744;
        Fri, 31 Mar 2023 06:08:14 -0700 (PDT)
Received: from localhost ([194.62.217.4])
        by smtp.gmail.com with ESMTPSA id v16-20020a5d6110000000b002d89e113691sm2173758wrt.52.2023.03.31.06.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:08:14 -0700 (PDT)
References: <20230329223239.138757-14-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v3 13/13] rust: sync: add functions for initializing
 `UniqueArc<MaybeUninit<T>>`
Date: Fri, 31 Mar 2023 15:07:18 +0200
In-reply-to: <20230329223239.138757-14-y86-dev@protonmail.com>
Message-ID: <87v8ih1329.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Benno Lossin <y86-dev@protonmail.com>
>
> Add two functions `init_with` and `pin_init_with` to
> `UniqueArc<MaybeUninit<T>>` to initialize the memory of already allocated
> `UniqueArc`s. This is useful when you want to allocate memory check some
> condition inside of a context where allocation is forbidden and then
> conditionally initialize an object.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/sync/arc.rs | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 4ed6329a5e5f..64b0e9d67025 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -540,6 +540,30 @@ impl<T> UniqueArc<MaybeUninit<T>> {
>              inner: unsafe { Arc::from_inner(inner.cast()) },
>          }
>      }
> +
> +    /// Initialize `self` using the given initializer.
> +    pub fn init_with<E>(mut self, init: impl Init<T, E>) -> core::result::Result<UniqueArc<T>, E> {
> +        // SAFETY: The supplied pointer is valid for initialization.
> +        match unsafe { init.__init(self.as_mut_ptr()) } {
> +            // SAFETY: Initialization completed successfully.
> +            Ok(()) => Ok(unsafe { self.assume_init() }),
> +            Err(err) => Err(err),
> +        }
> +    }
> +
> +    /// Pin-initialize `self` using the given pin-initializer.
> +    pub fn pin_init_with<E>(
> +        mut self,
> +        init: impl PinInit<T, E>,
> +    ) -> core::result::Result<Pin<UniqueArc<T>>, E> {
> +        // SAFETY: The supplied pointer is valid for initialization and we will later pin the value
> +        // to ensure it does not move.
> +        match unsafe { init.__pinned_init(self.as_mut_ptr()) } {
> +            // SAFETY: Initialization completed successfully.
> +            Ok(()) => Ok(unsafe { self.assume_init() }.into()),
> +            Err(err) => Err(err),
> +        }
> +    }
>  }
>
>  impl<T: ?Sized> From<UniqueArc<T>> for Pin<UniqueArc<T>> {

