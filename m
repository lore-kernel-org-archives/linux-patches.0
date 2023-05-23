Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61B54A23
	for <patches@lists.linux.dev>; Tue, 23 May 2023 13:12:24 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-510d1972d5aso1377845a12.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 06:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684847542; x=1687439542;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=0q0Er/yr0XbigUrMhIwfZk39HhWZ+8VHyfxFw7/ahKc=;
        b=btePMZYW9idGfunVyuEfePLLz8XFXxwvMARByuGFiKJWjj5EKcyKTR618MPirBd/gK
         wEgg+AoHOL+7Iiv/Pk+PPhMhowKFvg+ke1NhKOHsLC730ldjYzBbb002338TVhfOB7pS
         cjTyLFddx2V/LfwE/betWSuWcu0lzkTYAZNcy0ciGG1bDeVSaWIDmlE+f94jz/hVWCRd
         l8ghP/Ffa2G6J+qivDbjHv3GoRs6mzWxvoGuf/fWYefB5XPCLrGxTL+FfMg2BbrygpGT
         NgE6ph5VZl3J1/D+ZMiLSk4TPxBFkfwLHrFDCNKDT4OW6llxobDUEzNpRAOs0vGkdu6D
         YFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684847542; x=1687439542;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q0Er/yr0XbigUrMhIwfZk39HhWZ+8VHyfxFw7/ahKc=;
        b=VrK2SuGn6dZgm5AqFq5gwYYe7mt9o60dxa9AbCVMM4dc25rX+g6MphFvHZPPrzPUZD
         Mw1SW4A9U8KuKLnZAmrrV4LZ5vVXlNnmVkD6RuTfQeJqZ3PYz9plXZGQXuS9XfpDEcsI
         GiORb0LZcIdsD6BezN895wBuYNFuam3efLKmqFKrP6crMKni6XRnDs0QlK4GmDPWnmuI
         vT2/2HSQNbh2LK9h9FYvTO+MI0LttkQ/PR8ohf/5KT9vkEIhqNbUUTyq/Q6l5hLQaYwc
         Luh2sDGc6x2k4AVG7Z3C5/L83PQYthIdugcX9FM5k9SGOiyYJ1fA2acD0ygUaveb08Dg
         dcwg==
X-Gm-Message-State: AC+VfDwyBwCLKRq4//mSoMO5BECp/fCUyrv7MCe/enSDMucjUXLUHkU/
	vZF6oV/ZqnVl96Qoh8NmzgSoxA==
X-Google-Smtp-Source: ACHHUZ5kRj4YI64xMUrX7IZ9VgWw2yKzW1DREBH8Y6Ov4ig+VK1Ktgn02UEEIY6ytj+sVlzxsFYwMA==
X-Received: by 2002:a05:6402:1217:b0:50b:faa1:e1d5 with SMTP id c23-20020a056402121700b0050bfaa1e1d5mr10125374edw.39.1684847542525;
        Tue, 23 May 2023 06:12:22 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id a36-20020a509ea7000000b0050bd2f16ef5sm4241224edf.84.2023.05.23.06.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:12:22 -0700 (PDT)
References: <20230517095905.3548100-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Ingo
 Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v1 1/2] rust: specify when `ARef` is thread safe
Date: Tue, 23 May 2023 15:11:13 +0200
In-reply-to: <20230517095905.3548100-1-aliceryhl@google.com>
Message-ID: <87y1lfdwei.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> An `ARef` behaves just like the `Arc` when it comes to thread safety, so
> we can reuse the thread safety comments from `Arc` here.
>
> This is necessary because without this change, the Rust compiler will
> assume that things are not thread safe even though they are.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/types.rs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index 29db59d6119a..9c8d94c04deb 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -321,6 +321,17 @@ pub struct ARef<T: AlwaysRefCounted> {
>      _p: PhantomData<T>,
>  }
>  
> +// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
> +// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
> +// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` directly, for
> +// example, when the reference count reaches zero and `T` is dropped.
> +unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
> +
> +// SAFETY: It is safe to send `&ARef<T>` to another thread when the underlying `T` is `Sync` for the
> +// same reason as above. `T` needs to be `Send` as well because a thread can clone an `&ARef<T>`
> +// into an `ARef<T>`, which may lead to `T` being accessed by the same reasoning as above.
> +unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}

Nit: I would prefer repeating the safety comment details, in case the
two drift apart in the future.


BR Andreas

> +
>  impl<T: AlwaysRefCounted> ARef<T> {
>      /// Creates a new instance of [`ARef`].
>      ///
>
> base-commit: ac9a78681b921877518763ba0e89202254349d1b

