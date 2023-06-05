Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018CB20EA
	for <patches@lists.linux.dev>; Mon,  5 Jun 2023 18:47:44 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-96fdc081cb3so760284466b.2
        for <patches@lists.linux.dev>; Mon, 05 Jun 2023 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685990863; x=1688582863;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=QKLg1ub3QLvqs44m/Kyl00r/aR+KfWT5fRNSdNPBVaA=;
        b=D3PY2SpXRXhmI+VRHSFhX74K72xfYGs4bg3CwY/L4eq9suCeFWG/+rIZkKabYOY7yR
         oCUF+9wvRRrQgCCbs0xDQPzXYf9DqdAoqNKInLcvzw6isxkfF8941P2NM5Koe2UaNjEJ
         YS7sQNa6jE3+f1TgZGm8ohHci8XSwy3OumZO0U+sliuqtN6HkB9TQF0+62hr0TbWs2g3
         g/kMp9wDv6UrQHevgj2hPPTUBUkoqcjWO8S/X+6IsaCxH+VYss3ehSby3DVQZ3nLb5c+
         Ya09nZKTyi6eH7PobYs9+BEOKqSa+NXQ+r/BnnHe95sfNfsLdE6v2mRvDz+zbHYhy+T+
         hyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685990863; x=1688582863;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKLg1ub3QLvqs44m/Kyl00r/aR+KfWT5fRNSdNPBVaA=;
        b=OzZtxiC2EGtQLUyg0plRut5F8Pz7hQNCQw5ZzMcKfyq7kWgLP+G+VC50pHdcozwlnI
         nf5iilaT8MV6jKau1RjbCVkEK2I3VrNFzWlGLl1b6GsUfr7GWe6XfZl068tqDzzb9wYZ
         L5vE342v4/z5EHBu4G5st67Vtc35xMpCPzZoGrqKwi7OmStkyLftTmYeyk4LQr6AFlx2
         81KjZkWvLr3XYXL4tFdJ6wqX9RAagmOjWJCaVVELKaqScTg4GykiUNTG3m0T7dAPyjd/
         cAbJmyVPjwJ9DMQizF7DmzDPgO7ZkTLe6Kd/WWTt80uSyd7drXTCr/TRG3fIfQz6TeJM
         yorA==
X-Gm-Message-State: AC+VfDzZqZyRxBkoyAku/GTiAJ0B5sYNMNmteHS6CYvHJzSuRqbltjVf
	df+CGQUXKyrlFL65ONFqTuPHEQ==
X-Google-Smtp-Source: ACHHUZ66dLziEHTGGDZdVtvXcecgb6CoOrlaZmrhRU/KNjgiKUc/Y+Olvmx1iiwQfSXjcJRZcicEFg==
X-Received: by 2002:a17:906:58ce:b0:974:1e0e:9bd2 with SMTP id e14-20020a17090658ce00b009741e0e9bd2mr7286872ejs.14.1685990862652;
        Mon, 05 Jun 2023 11:47:42 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709067d5200b0096a27dbb5b2sm4483515ejp.209.2023.06.05.11.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 11:47:42 -0700 (PDT)
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-4-aliceryhl@google.com>
 <87v8g61119.fsf@metaspace.dk> <20230605153142.28a4093c.gary@garyguo.net>
 <ZH34psABEaq1bHtg@Boquns-Mac-mini.local>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>,
 Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v2 3/8] rust: sync: add `Arc::{from_raw, into_raw}`
Date: Mon, 05 Jun 2023 20:34:24 +0200
In-reply-to: <ZH34psABEaq1bHtg@Boquns-Mac-mini.local>
Message-ID: <87pm69zqya.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Boqun Feng <boqun.feng@gmail.com> writes:

> On Mon, Jun 05, 2023 at 03:31:42PM +0100, Gary Guo wrote:
>> On Fri, 02 Jun 2023 12:51:08 +0200
>> "Andreas Hindborg (Samsung)" <nmi@metaspace.dk> wrote:
>> 
>> > Alice Ryhl <aliceryhl@google.com> writes:
>> > 
>> > > From: Wedson Almeida Filho <walmeida@microsoft.com>
>> > >
>> > > These methods can be used to turn an `Arc` into a raw pointer and back,
>> > > in a way that preserves the metadata for fat pointers.
>> > >
>> > > This is done using the unstable ptr_metadata feature [1]. However, it
>> > > could also be done using the unstable pointer_byte_offsets feature [2],
>> > > which is likely to have a shorter path to stabilization than
>> > > ptr_metadata.
>> > >
>> > > Link: https://github.com/rust-lang/rust/issues/81513 [1]
>> > > Link: https://github.com/rust-lang/rust/issues/96283 [2]
>> > > Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
>> > > Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>> > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> > > Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
>> > > ---
>> > >  rust/kernel/lib.rs      |  1 +
>> > >  rust/kernel/sync/arc.rs | 42 ++++++++++++++++++++++++++++++++++++++++-
>> > >  2 files changed, 42 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
>> > > index 7ea777b731e6..ad9142928fb1 100644
>> > > --- a/rust/kernel/lib.rs
>> > > +++ b/rust/kernel/lib.rs
>> > > @@ -17,6 +17,7 @@
>> > >  #![feature(const_refs_to_cell)]
>> > >  #![feature(dispatch_from_dyn)]
>> > >  #![feature(new_uninit)]
>> > > +#![feature(ptr_metadata)]
>> > >  #![feature(receiver_trait)]
>> > >  #![feature(unsize)]
>> > >  
>> > > diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
>> > > index a89843cacaad..684be9f73aca 100644
>> > > --- a/rust/kernel/sync/arc.rs
>> > > +++ b/rust/kernel/sync/arc.rs
>> > > @@ -24,7 +24,7 @@
>> > >  };
>> > >  use alloc::boxed::Box;
>> > >  use core::{
>> > > -    alloc::AllocError,
>> > > +    alloc::{AllocError, Layout},
>> > >      fmt,
>> > >      marker::{PhantomData, Unsize},
>> > >      mem::{ManuallyDrop, MaybeUninit},
>> > > @@ -212,6 +212,46 @@ unsafe fn from_inner(inner: NonNull<ArcInner<T>>) -> Self {
>> > >          }
>> > >      }
>> > >  
>> > > +    /// Convert the [`Arc`] into a raw pointer.
>> > > +    ///
>> > > +    /// The raw pointer has ownership of the refcount that this Arc object owned.
>> > > +    pub fn into_raw(self) -> *const T {
>> > > +        let ptr = self.ptr.as_ptr();
>> > > +        core::mem::forget(self);
>> > > +        // SAFETY: The pointer is valid.
>> > > +        unsafe { core::ptr::addr_of!((*ptr).data) }
>> > > +    }
>> > > +
>> > > +    /// Recreates an [`Arc`] instance previously deconstructed via [`Arc::into_raw`].
>> > > +    ///
>> > > +    /// This code relies on the `repr(C)` layout of structs as described in
>> > > +    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
>> > > +    ///
>> > > +    /// # Safety
>> > > +    ///
>> > > +    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
>> > > +    /// can only be called once for each previous call to [`Arc::into_raw`].
>> > > +    pub unsafe fn from_raw(ptr: *const T) -> Self {
>> > > +        let refcount_layout = Layout::new::<bindings::refcount_t>();
>> > > +        // SAFETY: The caller guarantees that the pointer is valid.
>> > > +        let val_layout = unsafe { Layout::for_value(&*ptr) };
>> > > +        // SAFETY: We're computing the layout of a real struct that existed when compiling this
>> > > +        // binary, so its layout is not so large that it can trigger arithmetic overflow.
>> > > +        let val_offset = unsafe { refcount_layout.extend(val_layout).unwrap_unchecked().1 };
>> > > +
>> > > +        // This preserves the metadata in the pointer, if any.
>> > > +        //
>> > > +        // Note that `*const T` and `*const ArcInner<T>` have the same metadata as documented at
>> > > +        // <https://doc.rust-lang.org/std/ptr/trait.Pointee.html>.
>> > > +        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);  
>> > 
>> > Thanks for updating the comment with the link. I looked into this and I
>> > find that what we are doing here, even though it works, does not feel
>> > right at all. We should be able to do this:
>> > 
>> >         let metadata = core::ptr::metadata(ptr);
>> >         let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>> >         let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);
>> > 
>> > but the way `Pointee::Metadata` is defined will not allow this, even
>> > though we know it is valid. I would suggest the following instead:
>> > 
>> >         let metadata = core::ptr::metadata(ptr);
>> >         // Convert <T as Pointee>::Metadata to <ArcInner<T> as
>> >         // Pointee>::Metadata. We know they have identical representation and thus this is OK.
>> >         let metadata: <ArcInner<T> as Pointee>::Metadata = *unsafe {
>> >             &*((&metadata as *const <T as Pointee>::Metadata as *const ())
>> >                 as *const <ArcInner<T> as Pointee>::Metadata)
>> >         };
>> 
>> This could just be a `transmute_copy`.
>> 
>
> Or just `transmute`:
>
> 	let metadata = unsafe {
> 		core::mem::transmute<_, <ArcInner<T> as
> 		Pointee>>::Metadata>(metadata)
> 	};
>
> ? Since `Pointee::Metadata` is `Copy`.

I like `transmute_copy()` better for being more explicit.

>
> Regards,
> Boqun
>
>> >         let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>> >         let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);
>> > 
>> > Even though it is a bit more complex, it captures what we are trying to
>> > do better.
>> 
>> I agree this captures the semantics better.
>> 
>
> I actually wish that we could use `wrapping_byte_offset`[1], and just
>
> 	// `*const T` and `*const ArcInner<T>` should have the same
> 	// metdata, so convert the pointer type first.
> 	let ptr = ptr as *const ArcInner<T>;
>
> 	// .. and then adjust the byte offset.
> 	let ptr = ptr.wrapping_byte_offset(-val_offset);
>
> This may be the opposite direction as Andreas proposed ;-), but the
> result is less code.

Idk, it is sort of similar to the original approach. I think it is a
good idea to be a bit explicit about what we are doing here.

BR Andreas
