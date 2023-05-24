Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C40FC8FE
	for <patches@lists.linux.dev>; Wed, 24 May 2023 10:25:23 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-94a342f7c4cso129807666b.0
        for <patches@lists.linux.dev>; Wed, 24 May 2023 03:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684923922; x=1687515922;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=f0vs38PViABW+zuXJqvyRz3u5yR81HvMlP/tGJCSQAU=;
        b=D0Ic8jMe0KSV9PxV4AuXm9f6luNuZ/9vqmTjTtXVoS05oyVNuEW0Am+PHqwFNshkyo
         dIxZEgxTqwJOU7XIvYbkUBeb2eZA+rlgx705vBO5HFmOVOWRokdQWd+88H/jrv5t4m6u
         Lp+OdEo6Ix3JncEYybIuRFNLGrB6hber1jFfARgKYcDDACW4WfzEi3xwx69CAELC2FSG
         btyC0ZdxAZQz/sjPXy7lVdUSOv/91LeNkf40RigQBbksI97kRCIo6W2V0aIwGI6ROPN1
         FCg+sCzKjyLE8RiYuh//ycBLNo2MqKGMnljbB7wl7TUmPVf+mI3RPsJ9QUkBahPu9E4Q
         4ffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684923922; x=1687515922;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0vs38PViABW+zuXJqvyRz3u5yR81HvMlP/tGJCSQAU=;
        b=fMd2x1C3cFF5LBpV3KcbR2Ps5iGkqKTUAzieNkdIv4YJU6RU5eWSlm4QwQgL/gl9L3
         2LVT+u4Da7Z183CdUi/7C6dWjxpTyqliK1ZnmbOgAI31ercVmE0uSwMty46IT74fgWrs
         WvN8eoRYS8ZnfOPuoBJW1NtyJFeemxKDd5RIy/lrtg+dQnNYAGmJp6mzLsMDdNQgwFbg
         gpdNDTVXTfaFR2Boofp77YGqJz8aHeDubFXlP679oZB62XxSPCWW+d51CL72sHON4FGI
         xUsFdXFR100fcgyaXJEAif4vmZZi8TIv/WlsL2oSJEnllQdwODQ0Y1W/ugfCWHz91w8w
         583g==
X-Gm-Message-State: AC+VfDwQqdhdrZQ/Zwuoo3QxD2UnBoBBgmiy5esDgOEttPit6E/bX/3q
	AhKTrneh/q6ZIGppRmlRtgZJZQ==
X-Google-Smtp-Source: ACHHUZ58w/aBobDAw1TtECnPCfMwkJVq4+4C489eHsFqtWr6NJ/729DNxuSqdmL/g8leDm7LH6d6KA==
X-Received: by 2002:a17:907:9495:b0:953:8249:1834 with SMTP id dm21-20020a170907949500b0095382491834mr17767022ejc.16.1684923922186;
        Wed, 24 May 2023 03:25:22 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id og34-20020a1709071de200b0096f7e6d0063sm5561004ejc.75.2023.05.24.03.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 03:25:21 -0700 (PDT)
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-4-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
Date: Wed, 24 May 2023 12:20:36 +0200
In-reply-to: <20230517203119.3160435-4-aliceryhl@google.com>
Message-ID: <87edn6do1b.fsf@metaspace.dk>
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
> These methods can be used to turn an `Arc` into a raw pointer and back,
> in a way that preserves the metadata for fat pointers.
>
> This is done using the unstable ptr_metadata feature [1]. However, it
> could also be done using the unstable pointer_byte_offsets feature [2],
> which is likely to have a shorter path to stabilization than
> ptr_metadata.
>
> Link: https://github.com/rust-lang/rust/issues/81513 [1]
> Link: https://github.com/rust-lang/rust/issues/96283 [2]
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/lib.rs      |  1 +
>  rust/kernel/sync/arc.rs | 44 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index cdf9fe999328..82854c86e65d 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -22,6 +22,7 @@
>  #![feature(generic_associated_types)]
>  #![feature(new_uninit)]
>  #![feature(pin_macro)]
> +#![feature(ptr_metadata)]
>  #![feature(receiver_trait)]
>  #![feature(unsize)]
>  
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index e6d206242465..7c55a9178dfb 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -210,6 +210,50 @@ impl<T: ?Sized> Arc<T> {
>          }
>      }
>  
> +    /// Convert the [`Arc`] into a raw pointer.
> +    ///
> +    /// The raw pointer has ownership of the refcount that this Arc object owned.
> +    pub fn into_raw(self) -> *const T {
> +        let ptr = self.ptr.as_ptr();
> +        core::mem::forget(self);
> +        // SAFETY: The pointer is valid.
> +        unsafe { core::ptr::addr_of!((*ptr).data) }
> +    }
> +
> +    /// Recreates an [`Arc`] instance previously deconstructed via [`Arc::into_raw`].
> +    ///
> +    /// This code relies on the `repr(C)` layout of structs as described in
> +    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
> +    /// can only be called once for each previous call to [`Arc::into_raw`].
> +    pub unsafe fn from_raw(ptr: *const T) -> Self {
> +        // SAFETY: The safety requirement ensures that the pointer is valid.
> +        let val_align = core::mem::align_of_val(unsafe { &*ptr });
> +        let refcount_size = core::mem::size_of::<Opaque<bindings::refcount_t>>();
> +
> +        // Use the `repr(C)` algorithm to compute the offset of `data` in `ArcInner`.
> +        //
> +        // Pseudo-code for the `#[repr(C)]` algorithm can be found here:
> +        // <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>
> +        let mut val_offset = refcount_size;
> +        let val_misalign = val_offset % val_align;
> +        if val_misalign > 0 {
> +            val_offset += val_align - val_misalign;
> +        }
> +
> +        // This preserves the metadata in the pointer, if any.
> +        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);

I can't follow this. How does this work? `ptr` was for field
`inner.data: T`, but we are casting to `ArcInner<T>`.

> +        let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
> +        let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);

Metadata was obtained from a pointer pointing to `inner.data`, we then
move it back to beginning of `ArcInner<T>` and then reconstruct the
potentially fat pointer with metadata from the pointer to `T`? How can
this be right?

BR Andreas

> +
> +        // SAFETY: By the safety requirements we know that `ptr` came from `Arc::into_raw`, so the
> +        // reference count held then will be owned by the new `Arc` object.
> +        unsafe { Self::from_inner(NonNull::new_unchecked(ptr)) }
> +    }
> +
>      /// Returns an [`ArcBorrow`] from the given [`Arc`].
>      ///
>      /// This is useful when the argument of a function call is an [`ArcBorrow`] (e.g., in a method

