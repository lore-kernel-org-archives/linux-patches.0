Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7614F10FB
	for <patches@lists.linux.dev>; Mon,  5 Jun 2023 14:50:58 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-977c88c9021so316184066b.3
        for <patches@lists.linux.dev>; Mon, 05 Jun 2023 07:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685976657; x=1688568657;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa3Kb0uleOyfAZUVBo8LLmiqNWtNL+oEgrNfP9PyhYY=;
        b=cqvmTTfD3rkn0C55pKA8zV8vG2QdW1k2W4cYDsDMg7He4X5pTW1bH7FuYTj8Nr5jkC
         DfeAO02ThiqyjfpXyEX6Kdpqvgi6f01e4RuEu+qCg/v4hjFra6AbmutaNApDu7Jk2Qhi
         x+61e1rd9O6gth4c3thedWKEfdjNXDTEDnGLsrbvZCzOd3txMFWJvsy46YNc1RQ0tXO/
         x/dEFsNLloLZzyDQiSreUVUdk/QzXypk09YUVqXE/y3+YNAUM5zfOXVdG4E9+17t5MUd
         vaWytz+O1CsFflPPd5O3EitW5Ig0HuJZOwcumLu52hm8w7V91UFtFMBaKP3hi7LWY57B
         dcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685976657; x=1688568657;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oa3Kb0uleOyfAZUVBo8LLmiqNWtNL+oEgrNfP9PyhYY=;
        b=DAVlCd00sddASm+0RvIsq9SuQHT482+ayqnq0EEr0FZJZG8Gi2EP18iQKMvIcuLp/J
         l1HySO62Byb4PTukjn7zgO+LEbjOc/5B1tSYGfRN8MTuF0FFDDMk3rQtBXsHftzcXyJQ
         PpfucRMVjpsV3c2rffbIM0GqmJuMhwnvwi/GdRvXF6aauF+EoefzFmWvbWGvpqQDZAD4
         /vz/A/jtC9mnEbTXHoQnfyJG/w0Q1QhzpkoQCgfJQzXGru+SAfbeVkgZwJqm1yBLWGGY
         7mZdl+NxzJy2QxjutYxHopdVPd+6U5wxB+Q2KHfPPcrIrVh+O8dVgrYrJR+/XpP/Pl4+
         6aug==
X-Gm-Message-State: AC+VfDyEudQrLebN+XBjtY89IDWd8MJHRiIQhhWB9cmloIDf0qEcel2w
	e9AannKQMIddWLzdA3Ce80WVVg==
X-Google-Smtp-Source: ACHHUZ7Abdsxz+XW7dDVkAMw8hmQmN9bR8Sw4/+it37KDlfDXlATezY3EHhhXjzCL1IyMjjOTACiXw==
X-Received: by 2002:a17:906:7956:b0:966:1fef:22d8 with SMTP id l22-20020a170906795600b009661fef22d8mr6587405ejo.7.1685976657235;
        Mon, 05 Jun 2023 07:50:57 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id ks9-20020a170906f84900b00965fdb90801sm4347893ejb.153.2023.06.05.07.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:50:56 -0700 (PDT)
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-4-aliceryhl@google.com>
 <87v8g61119.fsf@metaspace.dk> <20230605153142.28a4093c.gary@garyguo.net>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Alex  Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>,
 Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v2 3/8] rust: sync: add `Arc::{from_raw, into_raw}`
Date: Mon, 05 Jun 2023 16:49:53 +0200
In-reply-to: <20230605153142.28a4093c.gary@garyguo.net>
Message-ID: <87ttvmyncg.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Gary Guo <gary@garyguo.net> writes:

> On Fri, 02 Jun 2023 12:51:08 +0200
> "Andreas Hindborg (Samsung)" <nmi@metaspace.dk> wrote:
>
>> Alice Ryhl <aliceryhl@google.com> writes:
>>=20
>> > From: Wedson Almeida Filho <walmeida@microsoft.com>
>> >
>> > These methods can be used to turn an `Arc` into a raw pointer and back,
>> > in a way that preserves the metadata for fat pointers.
>> >
>> > This is done using the unstable ptr_metadata feature [1]. However, it
>> > could also be done using the unstable pointer_byte_offsets feature [2],
>> > which is likely to have a shorter path to stabilization than
>> > ptr_metadata.
>> >
>> > Link: https://github.com/rust-lang/rust/issues/81513 [1]
>> > Link: https://github.com/rust-lang/rust/issues/96283 [2]
>> > Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
>> > Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> > Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
>> > ---
>> >  rust/kernel/lib.rs      |  1 +
>> >  rust/kernel/sync/arc.rs | 42 ++++++++++++++++++++++++++++++++++++++++-
>> >  2 files changed, 42 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
>> > index 7ea777b731e6..ad9142928fb1 100644
>> > --- a/rust/kernel/lib.rs
>> > +++ b/rust/kernel/lib.rs
>> > @@ -17,6 +17,7 @@
>> >  #![feature(const_refs_to_cell)]
>> >  #![feature(dispatch_from_dyn)]
>> >  #![feature(new_uninit)]
>> > +#![feature(ptr_metadata)]
>> >  #![feature(receiver_trait)]
>> >  #![feature(unsize)]
>> >=20=20
>> > diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
>> > index a89843cacaad..684be9f73aca 100644
>> > --- a/rust/kernel/sync/arc.rs
>> > +++ b/rust/kernel/sync/arc.rs
>> > @@ -24,7 +24,7 @@
>> >  };
>> >  use alloc::boxed::Box;
>> >  use core::{
>> > -    alloc::AllocError,
>> > +    alloc::{AllocError, Layout},
>> >      fmt,
>> >      marker::{PhantomData, Unsize},
>> >      mem::{ManuallyDrop, MaybeUninit},
>> > @@ -212,6 +212,46 @@ unsafe fn from_inner(inner: NonNull<ArcInner<T>>)=
 -> Self {
>> >          }
>> >      }
>> >=20=20
>> > +    /// Convert the [`Arc`] into a raw pointer.
>> > +    ///
>> > +    /// The raw pointer has ownership of the refcount that this Arc o=
bject owned.
>> > +    pub fn into_raw(self) -> *const T {
>> > +        let ptr =3D self.ptr.as_ptr();
>> > +        core::mem::forget(self);
>> > +        // SAFETY: The pointer is valid.
>> > +        unsafe { core::ptr::addr_of!((*ptr).data) }
>> > +    }
>> > +
>> > +    /// Recreates an [`Arc`] instance previously deconstructed via [`=
Arc::into_raw`].
>> > +    ///
>> > +    /// This code relies on the `repr(C)` layout of structs as descri=
bed in
>> > +    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-s=
tructs>.
>> > +    ///
>> > +    /// # Safety
>> > +    ///
>> > +    /// `ptr` must have been returned by a previous call to [`Arc::in=
to_raw`]. Additionally, it
>> > +    /// can only be called once for each previous call to [`Arc::into=
_raw`].
>> > +    pub unsafe fn from_raw(ptr: *const T) -> Self {
>> > +        let refcount_layout =3D Layout::new::<bindings::refcount_t>();
>> > +        // SAFETY: The caller guarantees that the pointer is valid.
>> > +        let val_layout =3D unsafe { Layout::for_value(&*ptr) };
>> > +        // SAFETY: We're computing the layout of a real struct that e=
xisted when compiling this
>> > +        // binary, so its layout is not so large that it can trigger =
arithmetic overflow.
>> > +        let val_offset =3D unsafe { refcount_layout.extend(val_layout=
).unwrap_unchecked().1 };
>> > +
>> > +        // This preserves the metadata in the pointer, if any.
>> > +        //
>> > +        // Note that `*const T` and `*const ArcInner<T>` have the sam=
e metadata as documented at
>> > +        // <https://doc.rust-lang.org/std/ptr/trait.Pointee.html>.
>> > +        let metadata =3D core::ptr::metadata(ptr as *const ArcInner<T=
>);=20=20
>>=20
>> Thanks for updating the comment with the link. I looked into this and I
>> find that what we are doing here, even though it works, does not feel
>> right at all. We should be able to do this:
>>=20
>>         let metadata =3D core::ptr::metadata(ptr);
>>         let ptr =3D (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>>         let ptr =3D core::ptr::from_raw_parts_mut(ptr, metadata);
>>=20
>> but the way `Pointee::Metadata` is defined will not allow this, even
>> though we know it is valid. I would suggest the following instead:
>>=20
>>         let metadata =3D core::ptr::metadata(ptr);
>>         // Convert <T as Pointee>::Metadata to <ArcInner<T> as
>>         // Pointee>::Metadata. We know they have identical representatio=
n and thus this is OK.
>>         let metadata: <ArcInner<T> as Pointee>::Metadata =3D *unsafe {
>>             &*((&metadata as *const <T as Pointee>::Metadata as *const (=
))
>>                 as *const <ArcInner<T> as Pointee>::Metadata)
>>         };
>
> This could just be a `transmute_copy`.

Even better =F0=9F=91=8D

BR Andreas

>
>>         let ptr =3D (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>>         let ptr =3D core::ptr::from_raw_parts_mut(ptr, metadata);
>>=20
>> Even though it is a bit more complex, it captures what we are trying to
>> do better.
>
> I agree this captures the semantics better.
>
> Best,
> Gary

