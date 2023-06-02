Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4B5C8C0
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 10:37:19 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-30ae4ec1ac7so1699828f8f.2
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 03:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685702237; x=1688294237;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=9p+yTt6cvg8vUG2ftzRzXYP4tvdzivt6ek/MD3BvSqg=;
        b=kMiA0W7FHdz+uujDyp0kMsyzJlr0kkcny33kPt906dUVlKCKD83JF+0PCWCCjGNQOQ
         Vg2ngl7CN+L4oz8hEMY0vJa5jNykeoNYEkyntjxLl7hOZUOp8TUpwFzvrOpFWdXFsctr
         nczNfwOEQLhUKGHlJ8b/edYweXe+1pSa6IEGolmPpSL+Y/YUxpPJRaKwVBnVJYTvv9w8
         WSrhb45ryLpEUm0PPLn/XvevfdZ8cNiN4R4+h32FfSrIycN+Hf8z1pMWkPfkU5pldWX8
         V5NuW9oYeN+2TtsOcuJKNcKvOH2zKIL2+IQnUkaymEQzBeTlwxsOalSM1FoeBVH6z5Ar
         eYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685702237; x=1688294237;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9p+yTt6cvg8vUG2ftzRzXYP4tvdzivt6ek/MD3BvSqg=;
        b=YuucMUNCecsmgYSGf55lulF5UEJ4GYbJGXWVWu8dNHscvi2dHfSAJcO8lPwweR+389
         x9tz5ZSNADk1iXoqXgteeM2EE6imnQ5jEDjy0wFQXU//2PQBtiBEjZwbloWQiWGRcX76
         UOj6EVZ3Dkxups0WQ8YEUbyNWHkqP1/lRZW7XODGc/JWBiebKRZGrI2UKEBIoDmlS/uG
         4chA3UBP1uiai0IeN/pWGgbBht6re7r1ngDNhGIOgn0Ud0cSkLneQtkYtaOquQFzaT/A
         0kyu6pUNRHsT3KG54EnQUVLh/dx+wXRzQSIUq4MRz0D2tMj0MqvbOct+yF2IKR/w2dRx
         sfXQ==
X-Gm-Message-State: AC+VfDzL41DWlKSAa212bIhTWF9X+UAtW6pfCyDn+x9Q41P5wQpDNYcN
	7rvpqHsMwZfGSYAi2SJnmodNbQ==
X-Google-Smtp-Source: ACHHUZ4HwsJe1KA49rn8/TM8DLfaBgWKcx6yNCY8IZEEFTpdXwm5jYa5kA5SGOfYUFHM0lNuBWAkLQ==
X-Received: by 2002:a05:6000:1043:b0:30a:e542:c5c9 with SMTP id c3-20020a056000104300b0030ae542c5c9mr4017690wrx.24.1685702237707;
        Fri, 02 Jun 2023 03:37:17 -0700 (PDT)
Received: from localhost ([147.161.155.99])
        by smtp.gmail.com with ESMTPSA id k9-20020a056000004900b002c71b4d476asm1279740wrx.106.2023.06.02.03.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 03:37:17 -0700 (PDT)
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-3-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Wedson Almeida
 Filho <walmeida@microsoft.com>, Martin Rodriguez Reboredo
 <yakoyoku@gmail.com>
Subject: Re: [PATCH v2 2/8] rust: add offset_of! macro
Date: Fri, 02 Jun 2023 12:33:51 +0200
In-reply-to: <20230601134946.3887870-3-aliceryhl@google.com>
Message-ID: <875y862lr7.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> From: Wedson Almeida Filho <walmeida@microsoft.com>
>
> This macro is used to compute the offset of a field in a struct.
>
> This commit enables an unstable feature that is necessary for using
> the macro in a constant. However, this is not a problem as the macro
> will become available from the Rust standard library soon [1]. The
> unstable feature can be disabled again once that happens.
>
> The macro in this patch does not support sub-fields. That is, you cannot
> write `offset_of!(MyStruct, field.sub_field)` to get the offset of
> `sub_field` with `field`'s type being a struct with a field called
> `sub_field`. This is because `field` might be a `Box<SubStruct>`, which
> means that you would be trying to compute the offset to something in an
> entirely different allocation. There's no easy way to fix the current
> macro to support subfields, but the version being added to the standard
> library should support it, so the limitation is temporary and not a big
> deal.
>
> Link: https://github.com/rust-lang/rust/issues/106655 [1]
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> ---
>  rust/kernel/lib.rs     | 35 +++++++++++++++++++++++++++++++++++
>  scripts/Makefile.build |  2 +-
>  2 files changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index eaded02ffb01..7ea777b731e6 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -14,6 +14,7 @@
>  #![no_std]
>  #![feature(allocator_api)]
>  #![feature(coerce_unsized)]
> +#![feature(const_refs_to_cell)]
>  #![feature(dispatch_from_dyn)]
>  #![feature(new_uninit)]
>  #![feature(receiver_trait)]
> @@ -98,3 +99,37 @@ fn panic(info: &core::panic::PanicInfo<'_>) -> ! {
>      // instead of `!`. See <https://github.com/rust-lang/rust-bindgen/issues/2094>.
>      loop {}
>  }
> +
> +/// Calculates the offset of a field from the beginning of the struct it belongs to.
> +///
> +/// # Examples
> +///
> +/// ```
> +/// #[repr(C)]
> +/// struct Test {
> +///     a: u64,
> +///     b: u32,
> +/// }
> +///
> +/// assert_eq!(kernel::offset_of!(Test, b), 8);
> +/// ```
> +#[macro_export]
> +macro_rules! offset_of {
> +    ($type:path, $field:ident) => {{

Could we add a descriptive comment?

           // Prevent deref coersion to `$field` by requiring `$type`
           // has a field named `$field`

BR Andreas

> +        let $type { $field: _, .. };
> +        let tmp = ::core::mem::MaybeUninit::<$type>::uninit();
> +        let outer = tmp.as_ptr();
> +        // To avoid warnings when nesting `unsafe` blocks.
> +        #[allow(unused_unsafe)]
> +        // SAFETY: The pointer is valid and aligned, just not initialised; `addr_of` ensures that
> +        // we don't actually read from `outer` (which would be UB) nor create an intermediate
> +        // reference.
> +        let inner = unsafe { ::core::ptr::addr_of!((*outer).$field) } as *const u8;
> +        // To avoid warnings when nesting `unsafe` blocks.
> +        #[allow(unused_unsafe)]
> +        // SAFETY: The two pointers are within the same allocation block.
> +        unsafe {
> +            inner.offset_from(outer as *const u8) as usize
> +        }
> +    }};
> +}
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 78175231c969..819510694769 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
>  # Compile Rust sources (.rs)
>  # ---------------------------------------------------------------------------
>  
> -rust_allowed_features := new_uninit
> +rust_allowed_features := const_refs_to_cell,new_uninit
>  
>  rust_common_cmd = \
>  	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \

