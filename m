Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA7246B4
	for <patches@lists.linux.dev>; Tue, 30 May 2023 08:49:50 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-96f9cfa7eddso749436066b.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 01:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685436589; x=1688028589;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=sKvmcYNdw0/e/A3ebTbEuUOu5G8ColBz5GGjZ4+9ndk=;
        b=Vbdj6KueAzHTkZQx/3tFSDLBLrmoaxp+qeJQG9Yx46L/72isRnbTSayQMxXE5a2Qra
         a5zdb0QoE/fzNwQ4jnZxAlF4X5+jd5LL8Bkd+brSrDz1oAg8PECciFTFDYCCm5Hqb8x9
         LfIespmZFaroU1kKNOnHmWNBHeRPfN/v3ccMkLakbn3KtYdPO7TBKc/tUN+WjJrNNlIE
         Xg+4hf0POBYyhM/AHyHdLY4sC/7S9z1gWIujnWG6jHwFNciliYju7/bQ6wUNoeM9ecjw
         Wuhac5/GOYPEY0w4CVuK0+R3Ev8YfKxwV4PtTiuxsH0m1Oy7Bjw3XehRlxFwhZ1Jccrd
         nd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685436589; x=1688028589;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKvmcYNdw0/e/A3ebTbEuUOu5G8ColBz5GGjZ4+9ndk=;
        b=hM0/NR8+HMqR/Z6vSbOtrH1zdKBTZ5DKWYopMB0/krkbdq8VL4fDsrSgN97duD1b7T
         0i5TqT3fC1wFDS8yNlf9/OYzsD6vmgCeOcWkBx7ImwUmp+3mHDWNKYTEOXkjceT8fRX7
         za50hJNVvN4AkK5KTVKK2BccwY9fATEV02DHJbV1yVWpOp/NMTJnG5itSqOFVCND+Svn
         TRx5RuOfIUHjZ9VTPZfofZL0NsWA0Fsf5kTNaEQyVRgVVRJQG/7DSpr079AaYG6Yay4X
         MAs40+8I9njnpTNnqM1Xz4Eus79XjfpAmLJdMmx5PxZpOQMikZiEZJynlJffDR5Uft21
         Pqgg==
X-Gm-Message-State: AC+VfDwDrfPQs3fZ1yyyeNkE4jm3feecC0kyCCGnP71LRxX7AgfqUbLB
	k5p1SEKcVIseEDr6S5OHcc+VkQ==
X-Google-Smtp-Source: ACHHUZ7z3kEkvDHVP+7DvSK/H+8I5/Mb7V9cBL39bNad6iVtKtda2JsjDnstktVTcfupCl0tUR6XMA==
X-Received: by 2002:a17:907:7e94:b0:96f:a935:8998 with SMTP id qb20-20020a1709077e9400b0096fa9358998mr1738140ejc.39.1685436589164;
        Tue, 30 May 2023 01:49:49 -0700 (PDT)
Received: from localhost ([194.62.217.2])
        by smtp.gmail.com with ESMTPSA id uz16-20020a170907119000b00965a56f82absm7058798ejb.212.2023.05.30.01.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 01:49:48 -0700 (PDT)
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-6-aliceryhl@google.com>
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
Subject: Re: [PATCH v1 5/7] rust: workqueue: add helper for defining
 work_struct fields
Date: Tue, 30 May 2023 10:44:19 +0200
In-reply-to: <20230517203119.3160435-6-aliceryhl@google.com>
Message-ID: <87leh69par.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> The main challenge with defining `work_struct` fields is making sure
> that the function pointer stored in the `work_struct` is appropriate for
> the work item type it is embedded in. It needs to know the offset of the
> `work_struct` field being used (even if there are several!) so that it
> can do a `container_of`, and it needs to know the type of the work item
> so that it can call into the right user-provided code. All of this needs
> to happen in a way that provides a safe API to the user, so that users
> of the workqueue cannot mix up the function pointers.
>
> There are three important pieces that are relevant when doing this. This
> commit will use traits so that they know about each other according to
> the following cycle:
>
>  * The pointer type. It knows the type of the work item struct.
>  * The work item struct. It knows the offset of its `work_struct` field.
>  * The `work_struct` field. It knows the pointer type.
>
> There's nothing special about making the pointer type know the type of
> the struct it points at. Pointers generally always know that
> information.
>
> However, making the `work_struct` field know about the pointer type is
> less commonly seen. This is done by using a generic parameter: the
> `work_struct` field will have the type `Work<T>`, where T will be the
> pointer type in use. The pointer type is required to implement the
> `WorkItemAdapter` trait, which defines the function pointer to store in
> the `work_struct` field. The `Work<T>` type guarantees that the
> `work_struct` inside it uses `<T as WorkItemAdapter>::run` as its
> function pointer.
>
> Finally, to make the work item struct know the offset of its
> `work_struct` field, we use a trait called `HasWork<T>`. If a type
> implements this trait, then the type declares that, at the given offset,
> there is a field of type `Work<T>`. The trait is marked unsafe because
> the OFFSET constant must be correct, but we provide an `impl_has_work!`
> macro that can safely implement `HasWork<T>` on a type. The macro
> expands to something that only compiles if the specified field really
> has the type `Work<T>`. It is used like this:
>
> ```
> struct MyWorkItem {
>     work_field: Work<Arc<MyWorkItem>>,
> }
>
> impl_has_work! {
>     impl HasWork<Arc<MyWorkItem>> for MyWorkItem { self.work_field }
> }
> ```
>
> So to summarize, given a pointer to an allocation containing a work
> item, you can use the `HasWork<T>` trait to offset the pointer to the
> `work_struct` field. The function pointer in the `work_struct` field is
> guaranteed to be a function that knows what the original pointer type
> was, and using that information, it can undo the offset operation by
> looking up what the offset was via the `HasWork<T>` trait.
>
> This design supports work items with multiple `work_struct` fields by
> using different pointer types. For example, you might define structs
> like these:
>
> ```
> struct MyPointer1(Arc<MyWorkItem>);
> struct MyPointer2(Arc<MyWorkItem>);
>
> struct MyWorkItem {
>     work1: Work<MyPointer1>,
>     work2: Work<MyPointer2>,
> }
> ```
>
> Then, the wrapper structs `MyPointer1` and `MyPointer2` will take the
> role as the pointer type. By using one or the other, you tell the
> workqueue which `work_struct` field to use. This pattern is called the
> "newtype" pattern.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/helpers.c           |   8 ++
>  rust/kernel/workqueue.rs | 183 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 190 insertions(+), 1 deletion(-)
>
> diff --git a/rust/helpers.c b/rust/helpers.c
> index 81e80261d597..7f0c2fe2fbeb 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -26,6 +26,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/sched/signal.h>
>  #include <linux/wait.h>
> +#include <linux/workqueue.h>
>  
>  __noreturn void rust_helper_BUG(void)
>  {
> @@ -128,6 +129,13 @@ void rust_helper_put_task_struct(struct task_struct *t)
>  }
>  EXPORT_SYMBOL_GPL(rust_helper_put_task_struct);
>  
> +void rust_helper___INIT_WORK(struct work_struct *work, work_func_t func,
> +			     bool on_stack)
> +{
> +	__INIT_WORK(work, func, on_stack);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper___INIT_WORK);
> +
>  /*
>   * We use `bindgen`'s `--size_t-is-usize` option to bind the C `size_t` type
>   * as the Rust `usize` type, so we can use it in contexts where Rust
> diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
> index 22205d3bda72..7509618af252 100644
> --- a/rust/kernel/workqueue.rs
> +++ b/rust/kernel/workqueue.rs
> @@ -4,7 +4,8 @@
>  //!
>  //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
>  
> -use crate::{bindings, types::Opaque};
> +use crate::{bindings, prelude::*, types::Opaque};
> +use core::marker::{PhantomData, PhantomPinned};
>  
>  /// A kernel work queue.
>  ///
> @@ -98,6 +99,186 @@ pub unsafe trait WorkItem {
>          F: FnOnce(*mut bindings::work_struct) -> bool;
>  }
>  
> +/// Defines the method that should be called when a work item is executed.
> +///
> +/// This trait is used when the `work_struct` field is defined using the [`Work`] helper.
> +///
> +/// # Safety
> +///
> +/// Implementers must ensure that [`__enqueue`] uses a `work_struct` initialized with the [`run`]
> +/// method of this trait as the function pointer.
> +///
> +/// [`__enqueue`]: WorkItem::__enqueue
> +/// [`run`]: WorkItemAdapter::run
> +pub unsafe trait WorkItemAdapter: WorkItem {
> +    /// Run this work item.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Must only be called via the function pointer that [`__enqueue`] provides to the
> +    /// `queue_work_on` closure, and only as described in the documentation of `queue_work_on`.
> +    ///
> +    /// [`__enqueue`]: WorkItem::__enqueue
> +    unsafe extern "C" fn run(ptr: *mut bindings::work_struct);
> +}
> +
> +/// Links for a work item.
> +///
> +/// This struct contains a function pointer to the `T::run` function from the [`WorkItemAdapter`]
> +/// trait, and defines the linked list pointers necessary to enqueue a work item in a workqueue.
> +///
> +/// Wraps the kernel's C `struct work_struct`.
> +///
> +/// This is a helper type used to associate a `work_struct` with the [`WorkItemAdapter`] that uses
> +/// it.
> +#[repr(transparent)]
> +pub struct Work<T: ?Sized> {
> +    work: Opaque<bindings::work_struct>,
> +    _pin: PhantomPinned,
> +    _adapter: PhantomData<T>,
> +}
> +
> +// SAFETY: Kernel work items are usable from any thread.
> +//
> +// We do not need to constrain `T` since the work item does not actually contain a `T`.
> +unsafe impl<T: ?Sized> Send for Work<T> {}
> +// SAFETY: Kernel work items are usable from any thread.
> +//
> +// We do not need to constrain `T` since the work item does not actually contain a `T`.
> +unsafe impl<T: ?Sized> Sync for Work<T> {}
> +
> +impl<T: ?Sized> Work<T> {
> +    /// Creates a new instance of [`Work`].
> +    #[inline]
> +    #[allow(clippy::new_ret_no_self)]
> +    pub fn new() -> impl PinInit<Self>
> +    where
> +        T: WorkItemAdapter,
> +    {
> +        // SAFETY: The `WorkItemAdapter` implementation promises that `T::run` can be used as the
> +        // work item function.
> +        unsafe {
> +            kernel::init::pin_init_from_closure(move |slot| {
> +                bindings::__INIT_WORK(Self::raw_get(slot), Some(T::run), false);
> +                Ok(())
> +            })
> +        }
> +    }
> +
> +    /// Get a pointer to the inner `work_struct`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The provided pointer must not be dangling. (But it need not be initialized.)
> +    #[inline]
> +    pub unsafe fn raw_get(ptr: *const Self) -> *mut bindings::work_struct {
> +        // SAFETY: The caller promises that the pointer is valid.
> +        //
> +        // A pointer cast would also be ok due to `#[repr(transparent)]`. We use `addr_of!` so that
> +        // the compiler does not complain that `work` is unused.
> +        unsafe { Opaque::raw_get(core::ptr::addr_of!((*ptr).work)) }
> +    }
> +}
> +
> +/// Declares that a type has a [`Work<T>`] field.
> +///
> +/// # Safety
> +///
> +/// The [`OFFSET`] constant must be the offset of a field in Self of type [`Work<T>`]. The methods on
> +/// this trait must have exactly the behavior that the definitions given below have.
> +///
> +/// [`Work<T>`]: Work
> +/// [`OFFSET`]: HasWork::OFFSET
> +pub unsafe trait HasWork<T> {
> +    /// The offset of the [`Work<T>`] field.
> +    ///
> +    /// [`Work<T>`]: Work
> +    const OFFSET: usize;
> +
> +    /// Returns the offset of the [`Work<T>`] field.
> +    ///
> +    /// This method exists because the [`OFFSET`] constant cannot be accessed if the type is not Sized.
> +    ///
> +    /// [`Work<T>`]: Work
> +    /// [`OFFSET`]: HasWork::OFFSET
> +    #[inline]
> +    fn get_work_offset(&self) -> usize {
> +        Self::OFFSET
> +    }
> +
> +    /// Returns a pointer to the [`Work<T>`] field.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The pointer must not be dangling. (But the memory need not be initialized.)
> +    ///
> +    /// [`Work<T>`]: Work
> +    #[inline]
> +    unsafe fn raw_get_work(ptr: *mut Self) -> *mut Work<T>
> +    where
> +        Self: Sized,
> +    {
> +        // SAFETY: The caller promises that the pointer is not dangling.
> +        unsafe { (ptr as *mut u8).add(Self::OFFSET) as *mut Work<T> }
> +    }
> +
> +    /// Returns a pointer to the struct containing the [`Work<T>`] field.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The pointer must not be dangling. (But the memory need not be initialized.)
> +    ///
> +    /// [`Work<T>`]: Work
> +    #[inline]
> +    unsafe fn work_container_of(ptr: *mut Work<T>) -> *mut Self
> +    where
> +        Self: Sized,
> +    {
> +        // SAFETY: The caller promises that the pointer is not dangling.
> +        unsafe { (ptr as *mut u8).sub(Self::OFFSET) as *mut Self }
> +    }
> +}
> +
> +/// Used to safely implement the [`HasWork<T>`] trait.
> +///
> +/// # Examples
> +///
> +/// ```
> +/// use kernel::sync::Arc;
> +///
> +/// struct MyStruct {
> +///     work_field: Work<Arc<MyStruct>>,
> +/// }
> +///
> +/// impl_has_work! {
> +///     impl HasWork<Arc<MyStruct>> for MyStruct { self.work_field }
> +/// }
> +/// ```
> +///
> +/// [`HasWork<T>`]: HasWork
> +#[macro_export]
> +macro_rules! impl_has_work {
> +    ($(impl$(<$($implarg:ident),*>)?
> +       HasWork<$work_type:ty>
> +       for $self:ident $(<$($selfarg:ident),*>)?
> +       { self.$field:ident }
> +    )*) => {$(
> +        // SAFETY: The implementation of `raw_get_work` only compiles if the field has the right
> +        // type.
> +        unsafe impl$(<$($implarg),*>)? $crate::workqueue::HasWork<$work_type> for $self $(<$($selfarg),*>)? {
> +            const OFFSET: usize = $crate::offset_of!(Self, $field) as usize;
> +
> +            #[inline]
> +            unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_type> {
> +                // SAFETY: The caller promises that the pointer is not dangling.
> +                unsafe {
> +                    ::core::ptr::addr_of_mut!((*ptr).$field)
> +                }
> +            }

What is the reason for overriding the default implementation of `raw_get_work()`?

BR Andreas

> +        }
> +    )*};
> +}
> +
>  /// Returns the system work queue (`system_wq`).
>  ///
>  /// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU multi-threaded. There are

