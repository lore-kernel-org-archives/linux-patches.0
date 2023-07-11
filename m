Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BE81DDD6
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 17:43:23 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-98e39784a85so1429745366b.1
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 10:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689097401; x=1691689401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1sOEA7LLqdBUOo4mOxm2rOtiDruLii4dsgfvzEg/WM=;
        b=gQEi8wV3nrix50UeRaF1VHVbs9wmiDN39NR0/NL4Rz778g9o0tmrmSFylMhKpYqmaB
         pZLRgEXbvuoDOOu1yokXbDu6XRo3fhCzYauvjifg19En5ZCU1V2M9D/eFf3IHaaWm53H
         YEKeS/HKKBzW9I9cCFJdonXNHCkzT11vPgcC3I2bX/+hy1biZxhMsBbOBOhs5+W15h1X
         dWv1bACMhQQIaiHoOPqqEx3UWdtWyGYhJoo5LlkIIlWnO0VoKwA0tU9BJ8ka3Jd3+qta
         ETvEb79QXFfId11PMWDj6yil5SJT3q4bIvloHJgFmu9fo+FB91Nfyaj9uMvz3e0zEY6Q
         LuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689097401; x=1691689401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1sOEA7LLqdBUOo4mOxm2rOtiDruLii4dsgfvzEg/WM=;
        b=avFqZtr+AGMFH9UJtkXp6Ef3fSVWAZ90xIvQNCOlEpXVxcwEFOD/JHo8jWLzNyLLd5
         /5AHxSOIhZgKAsPZHGxpwedHKWFY6RGZmRs7TVUQhXbgBqO8nzivSBUITXW3sXJxKgvH
         ews/SP2y92BTTgw5fMPNrsYeuuIXUqCz5q6amXhgYu6Q1QX1/wf9981fG67gQr+nADqS
         4mmmzruIkBD0KmbtSWA8FZlFfamPpeGjcAT6CXQ2lOInct167SNqsi2+uA6Ve3Qdyrar
         exUIltnKqhMudMrTuEdBhAe76DNGxGyKfto50yHb3u6aIu+mCeBiVPiIHAnX6g11xpSa
         yWiw==
X-Gm-Message-State: ABy/qLYoOq5ua+eGaqJvcfrGt7BvHuCVo1OGkSiXzpZE28XrqlmzJPRo
	E5lgV//2Yl1zE3JOwC5f+MI=
X-Google-Smtp-Source: APBJJlHpHr6qlgMGUdSVvgx8ddrMIqtp6RBGw3PKjb4VHbi3skQwcm2b/t3zyfNfFeBYDvAaQ3goXQ==
X-Received: by 2002:a17:907:16a8:b0:96f:9cea:a34d with SMTP id hc40-20020a17090716a800b0096f9ceaa34dmr24212986ejc.21.1689097401002;
        Tue, 11 Jul 2023 10:43:21 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id h21-20020a170906261500b0099236e3f270sm1425309ejc.58.2023.07.11.10.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 10:43:20 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 6FE3E27C0054;
	Tue, 11 Jul 2023 13:43:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 11 Jul 2023 13:43:18 -0400
X-ME-Sender: <xms:tZStZIn5IvEDBPRlbkuQ-qaBYXU-lwj1W-V4nBUms6-gEKnsmpKQMg>
    <xme:tZStZH1xVzhNxUzIq_L6YE5HrKyfHVlIo7vP6lR9S65EwjI2tHjDLiEywpmVYkix7
    DQKguRBodb1hm2Xwg>
X-ME-Received: <xmr:tZStZGr4zYmXIN0MOxOB5m4rD1of_jns6-XP8_fbAPrUE_cX3Zcc6FlQkgM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfedtgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefhtedvgfdtueekvdekieetieetjeeihedvteehuddujedvkedtkeefgedv
    vdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:tZStZEltfex-IZ-RsqtiLgrPXWcLJLULQDO5ij8nIEWk8BJfAffezA>
    <xmx:tZStZG3iJqsFVEqXDplEDZUlvxq8EOa9W8MekYOE4ySYYi1AuaDFCA>
    <xmx:tZStZLvyXpJOZ9JgMCFmeitjH7AhWSu_6iGbSddbPedrmvz9GaS8TQ>
    <xmx:tpStZExy3AgXCohpqKz951OHXWdCLELiO15bl-huvucgg2QIHEsi2w>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jul 2023 13:43:17 -0400 (EDT)
Date: Tue, 11 Jul 2023 10:42:16 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v1] rust: add improved version of
 `ForeignOwnable::borrow_mut`
Message-ID: <ZK2UeFE1A4iRfePS@boqun-archlinux>
References: <20230710074642.683831-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710074642.683831-1-aliceryhl@google.com>

On Mon, Jul 10, 2023 at 07:46:42AM +0000, Alice Ryhl wrote:
> Previously, the `ForeignOwnable` trait had a method called `borrow_mut`
> that was intended to provide mutable access to the inner value. However,
> the method accidentally made it possible to change the address of the
> object being modified, which usually isn't what we want. (And when we
> want that, it can be done by calling `from_foreign` and `into_foreign`,
> like how the old `borrow_mut` was implemented.)
> 
> In this patch, we introduce an alternate definition of `borrow_mut` that
> solves the previous problem. Conceptually, given a pointer type `P` that
> implements `ForeignOwnable`, the `borrow_mut` method gives you the same
> kind of access as an `&mut P` would, except that it does not let you
> change the pointer `P` itself.
> 
> This is analogous to how the existing `borrow` method provides the same
> kind of access to the inner value as an `&P`.
> 
> Note that for types like `Arc`, having an `&mut Arc<T>` only gives you
> immutable access to the inner `T`. This is because mutable references
> assume exclusive access, but there might be other handles to the same
> reference counted value, so the access isn't exclusive. The `Arc` type
> implements this by making `borrow_mut` return the same type as `borrow`.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> 
> This patch depends on https://lore.kernel.org/all/20230706094615.3080784-1-aliceryhl@google.com/
> 
>  rust/kernel/sync/arc.rs | 31 +++++++++-----
>  rust/kernel/types.rs    | 93 ++++++++++++++++++++++++++++++-----------
>  2 files changed, 89 insertions(+), 35 deletions(-)
>  
> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index d479f8da8f38..1c2fb36906b6 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -20,66 +20,111 @@
>  /// This trait is meant to be used in cases when Rust objects are stored in C objects and
>  /// eventually "freed" back to Rust.
>  pub trait ForeignOwnable: Sized {
> -    /// Type of values borrowed between calls to [`ForeignOwnable::into_foreign`] and
> -    /// [`ForeignOwnable::from_foreign`].
> +    /// Type used to immutably borrow a value that is currently foreign-owned.
>      type Borrowed<'a>;
>  
> +    /// Type used to mutably borrow a value that is currently foreign-owned.
> +    type BorrowedMut<'a>;
> +

I would probably want to say "if the `impl ForeignOwnable` doesn't have
the exclusive ownership, `BorrowedMut` should be the same as `Borrowed`"
for logical self-consistent, and even further make it as default as
follow:

	type BorrowedMut<'a> = Self::Borrowed<'a>;

	unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> Self::BorrowedMut<'a> {
	    Self::borrow(ptr)
	}

but it might be over-engineering (and require associated_type_defaults
and more)...

Anyway,

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

>      /// Converts a Rust-owned object to a foreign-owned one.
>      ///
>      /// The foreign representation is a pointer to void.
>      fn into_foreign(self) -> *const core::ffi::c_void;
>  
> -    /// Borrows a foreign-owned object.
> -    ///
> -    /// # Safety
> -    ///
> -    /// `ptr` must have been returned by a previous call to [`ForeignOwnable::into_foreign`] for
> -    /// which a previous matching [`ForeignOwnable::from_foreign`] hasn't been called yet.
> -    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> Self::Borrowed<'a>;
> -
>      /// Converts a foreign-owned object back to a Rust-owned one.
>      ///
>      /// # Safety
>      ///
> -    /// `ptr` must have been returned by a previous call to [`ForeignOwnable::into_foreign`] for
> -    /// which a previous matching [`ForeignOwnable::from_foreign`] hasn't been called yet.
> -    /// Additionally, all instances (if any) of values returned by [`ForeignOwnable::borrow`] for
> -    /// this object must have been dropped.
> +    /// The provided pointer must have been returned by a previous call to [`into_foreign`], and it
> +    /// must not be passed to `from_foreign` more than once.
> +    ///
> +    /// [`into_foreign`]: Self::into_foreign
>      unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self;
> +
> +    /// Borrows a foreign-owned object immutably.
> +    ///
> +    /// This method provides a way to access a foreign-owned value from Rust immutably. It provides
> +    /// you with exactly the same abilities as an `&Self` when the value is Rust-owned.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The provided pointer must have been returned by a previous call to [`into_foreign`], and if
> +    /// the pointer is ever passed to [`from_foreign`], then that call must happen after the end of
> +    /// the lifetime 'a.
> +    ///
> +    /// [`into_foreign`]: Self::into_foreign
> +    /// [`from_foreign`]: Self::from_foreign
> +    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> Self::Borrowed<'a>;
> +
> +    /// Borrows a foreign-owned object mutably.
> +    ///
> +    /// This method provides a way to access a foreign-owned value from Rust mutably. It provides
> +    /// you with exactly the same abilities as an `&mut Self` when the value is Rust-owned, except
> +    /// that this method does not let you swap the foreign-owned object for another. (That is, it
> +    /// does not let you change the address of the void pointer that the foreign code is storing.)
> +    ///
> +    /// Note that for types like [`Arc`], an `&mut Arc<T>` only gives you immutable access to the
> +    /// inner value, so this method also only provides immutable access in that case.
> +    ///
> +    /// In the case of `Box<T>`, this method gives you the ability to modify the inner `T`, but it
> +    /// does not let you change the box itself. That is, you cannot change which allocation the box
> +    /// points at.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The provided pointer must have been returned by a previous call to [`into_foreign`], and if
> +    /// the pointer is ever passed to [`from_foreign`], then that call must happen after the end of
> +    /// the lifetime 'a.
> +    ///
> +    /// The lifetime 'a must not overlap with the lifetime of any other call to [`borrow`] or
> +    /// `borrow_mut` on the same object.
> +    ///
> +    /// [`into_foreign`]: Self::into_foreign
> +    /// [`from_foreign`]: Self::from_foreign
> +    /// [`borrow`]: Self::borrow
> +    /// [`Arc`]: crate::sync::Arc
> +    unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> Self::BorrowedMut<'a>;
>  }
>  
>  impl<T: 'static> ForeignOwnable for Box<T> {
>      type Borrowed<'a> = &'a T;
> +    type BorrowedMut<'a> = &'a mut T;
>  
>      fn into_foreign(self) -> *const core::ffi::c_void {
>          Box::into_raw(self) as _
>      }
>  
> -    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> &'a T {
> -        // SAFETY: The safety requirements for this function ensure that the object is still alive,
> -        // so it is safe to dereference the raw pointer.
> -        // The safety requirements of `from_foreign` also ensure that the object remains alive for
> -        // the lifetime of the returned value.
> -        unsafe { &*ptr.cast() }
> -    }
> -
>      unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self {
>          // SAFETY: The safety requirements of this function ensure that `ptr` comes from a previous
>          // call to `Self::into_foreign`.
>          unsafe { Box::from_raw(ptr as _) }
>      }
> +
> +    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> &'a T {
> +        // SAFETY: The safety requirements of this method ensure that the object remains alive and
> +        // immutable for the duration of 'a.
> +        unsafe { &*ptr.cast() }
> +    }
> +
> +    unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> &'a mut T {
> +        // SAFETY: The safety requirements of this method ensure that the pointer is valid and that
> +        // nothing else will access the value for the duration of 'a.
> +        unsafe { &mut *ptr.cast_mut().cast() }
> +    }
>  }
>  
>  impl ForeignOwnable for () {
>      type Borrowed<'a> = ();
> +    type BorrowedMut<'a> = ();
>  
>      fn into_foreign(self) -> *const core::ffi::c_void {
>          core::ptr::NonNull::dangling().as_ptr()
>      }
>  
> -    unsafe fn borrow<'a>(_: *const core::ffi::c_void) -> Self::Borrowed<'a> {}
> -
>      unsafe fn from_foreign(_: *const core::ffi::c_void) -> Self {}
> +
> +    unsafe fn borrow<'a>(_: *const core::ffi::c_void) -> Self::Borrowed<'a> {}
> +    unsafe fn borrow_mut<'a>(_: *const core::ffi::c_void) -> Self::BorrowedMut<'a> {}
>  }
>  
>  /// Runs a cleanup function/closure when dropped.
> 
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 172f563976a9..f152a562c9c3 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -232,26 +232,35 @@ pub fn ptr_eq(this: &Self, other: &Self) -> bool {
>  
>  impl<T: 'static> ForeignOwnable for Arc<T> {
>      type Borrowed<'a> = ArcBorrow<'a, T>;
> +    // Mutable access to the `Arc` does not give any extra abilities over
> +    // immutable access.
> +    type BorrowedMut<'a> = ArcBorrow<'a, T>;
>  
>      fn into_foreign(self) -> *const core::ffi::c_void {
>          ManuallyDrop::new(self).ptr.as_ptr() as _
>      }
>  
> -    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
> -        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
> -        // a previous call to `Arc::into_foreign`.
> -        let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
> -
> -        // SAFETY: The safety requirements of `from_foreign` ensure that the object remains alive
> -        // for the lifetime of the returned value.
> -        unsafe { ArcBorrow::new(inner) }
> -    }
> -
>      unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self {
>          // SAFETY: By the safety requirement of this function, we know that `ptr` came from
>          // a previous call to `Arc::into_foreign`, which guarantees that `ptr` is valid and
>          // holds a reference count increment that is transferrable to us.
> -        unsafe { Self::from_inner(NonNull::new(ptr as _).unwrap()) }
> +        unsafe { Self::from_inner(NonNull::new_unchecked(ptr as _)) }
>      }
> +
> +    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
> +        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
> +        // a previous call to `Arc::into_foreign`.
> +        let inner = unsafe { NonNull::new_unchecked(ptr as *mut ArcInner<T>) };
> +
> +        // SAFETY: The safety requirements ensure that we will not give up our
> +        // foreign-owned refcount while the `ArcBorrow` is still live.
> +        unsafe { ArcBorrow::new(inner) }
> +    }
> +
> +    unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
> +        // SAFETY: The safety requirements for `borrow_mut` are a superset of the safety
> +        // requirements for `borrow`.
> +        unsafe { Self::borrow(ptr) }
> +    }
>  }
> 
> base-commit: d2e3115d717197cb2bc020dd1f06b06538474ac3
> prerequisite-patch-id: b493b9015cb19f599c4bc03127733193b11ca822
> -- 
> 2.41.0.255.g8b1d071c50-goog
> 
