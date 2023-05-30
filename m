Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51112B75
	for <patches@lists.linux.dev>; Tue, 30 May 2023 08:31:54 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5149e65c244so2595406a12.3
        for <patches@lists.linux.dev>; Tue, 30 May 2023 01:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685435513; x=1688027513;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=MJQYbOMuQTVef8Cs7ix7ljcqRrk6TSmy6+5pQXd7gzo=;
        b=rXANOXgWT4NYULI+fE6EcmnNq5EhC/P9AdCJDTKm6vQBYkoh/cOrunAOez8PdWIPc5
         TLSevdnXC+iFqM3RRVBZCUgKmpgUSwnt7heN213Au6yDgGa+oWb2SZR5n1QI0yxp5mpv
         OdFhbeXz0F/RrRJATkIN9UAMglofaeEHak30DTQgW4+KiKlVCAJu32+JghslnDr2NNZi
         gUXoqzRKeVfhJWzDDRShkDqxNhI84oukN1CJj5UOE4Ue7zkn12tzyMXYv+nBy2n09OV9
         3zwqy4fhIhkv7L41aG+03cMyRdiZs2ayfgGhmmulNMstibzqIebGxOieGzX382+4NVs8
         ITUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685435513; x=1688027513;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJQYbOMuQTVef8Cs7ix7ljcqRrk6TSmy6+5pQXd7gzo=;
        b=XnasXugZApXaEFUwMyQ4MRJIHTZQdHiE9ONo/5bnsvDs2Na9BI+4H7Q+cRmvbyP57r
         D+g9zRXNztpOnyli8VvolWO8MFA4UMYFKLp57GeSwizwbECMII3+yFj0PPOwsRMhTO0X
         7c0vlJilsO5XGgsYZ2l/RY8TReB4G2HiBNyb536t+oft55kILpLlNqqfYEnn/YmHPBvD
         QDC/XAqZPKhFakKnBot4ujnEB4U5xjvWAMpxALBF6jNE9tOkC47pCzGm/L3F4XQQ27ea
         OHIpHgKevWtxtvrONTy13ZGdbejalKFnnrg9RKjxfAKgxxMo6/ubKOQGf09ahlimWrDc
         SYEg==
X-Gm-Message-State: AC+VfDxYLQ7nPN1LdF9VXeH5wUk2IvQwql+6BvZdOuZ/qayxLJJ/pvAq
	hWz9gPqnwLPB4ZwoIfK9NEm0VQ==
X-Google-Smtp-Source: ACHHUZ5RLFM80xV169QH9dQ9Q3eQL4jPiwDTSYZqE6xrZnVMXB59Mme2W+WduuL/FkYrIauoyuWF1g==
X-Received: by 2002:a05:6402:356:b0:50b:d34c:4710 with SMTP id r22-20020a056402035600b0050bd34c4710mr1322394edw.5.1685435512815;
        Tue, 30 May 2023 01:31:52 -0700 (PDT)
Received: from localhost ([194.62.217.2])
        by smtp.gmail.com with ESMTPSA id y25-20020a056402135900b0050bce352dc5sm4058158edw.85.2023.05.30.01.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 01:31:52 -0700 (PDT)
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-2-aliceryhl@google.com>
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
Subject: Re: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
Date: Tue, 30 May 2023 10:26:02 +0200
In-reply-to: <20230517203119.3160435-2-aliceryhl@google.com>
Message-ID: <87ttvu9q4o.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Define basic low-level bindings to a kernel workqueue. The API defined
> here can only be used unsafely. Later commits will provide safe
> wrappers.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/lib.rs       |  1 +
>  rust/kernel/workqueue.rs | 99 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 100 insertions(+)
>  create mode 100644 rust/kernel/workqueue.rs
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 676995d4e460..c718524056a6 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -47,6 +47,7 @@ pub mod str;
>  pub mod sync;
>  pub mod task;
>  pub mod types;
> +pub mod workqueue;
>  
>  #[doc(hidden)]
>  pub use bindings;
> diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
> new file mode 100644
> index 000000000000..e66b6b50dfae
> --- /dev/null
> +++ b/rust/kernel/workqueue.rs
> @@ -0,0 +1,99 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Work queues.
> +//!
> +//! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)

I think we need to add workqueue.h to rust/bindings/bindings_helper.h
with this commit. It is probably transitively included as is, but it
would be the right thing to explicitly include it.

BR Andreas

> +
> +use crate::{bindings, types::Opaque};
> +
> +/// A kernel work queue.
> +///
> +/// Wraps the kernel's C `struct workqueue_struct`.
> +///
> +/// It allows work items to be queued to run on thread pools managed by the kernel. Several are
> +/// always available, for example, `system`, `system_highpri`, `system_long`, etc.
> +#[repr(transparent)]
> +pub struct Queue(Opaque<bindings::workqueue_struct>);
> +
> +// SAFETY: Kernel workqueues are usable from any thread.
> +unsafe impl Send for Queue {}
> +unsafe impl Sync for Queue {}
> +
> +impl Queue {
> +    /// Use the provided `struct workqueue_struct` with Rust.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that the provided raw pointer is not dangling, that it points at a
> +    /// valid workqueue, and that it remains valid until the end of 'a.
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::workqueue_struct) -> &'a Queue {
> +        // SAFETY: The `Queue` type is `#[repr(transparent)]`, so the pointer cast is valid. The
> +        // caller promises that the pointer is not dangling.
> +        unsafe { &*(ptr as *const Queue) }
> +    }
> +
> +    /// Enqueues a work item.
> +    ///
> +    /// This may fail if the work item is already enqueued in a workqueue.
> +    pub fn enqueue<T: WorkItem + Send + 'static>(&self, w: T) -> T::EnqueueOutput {
> +        let queue_ptr = self.0.get();
> +
> +        // SAFETY: There are two cases.
> +        //
> +        //  1. If `queue_work_on` returns false, then we failed to push the work item to the queue.
> +        //     In this case, we don't touch the work item again.
> +        //
> +        //  2. If `queue_work_on` returns true, then we pushed the work item to the queue. The work
> +        //     queue will call the function pointer in the `work_struct` at some point in the
> +        //     future. We require `T` to be static, so the type has no lifetimes annotated on it.
> +        //     We require `T` to be send, so there are no thread-safety issues to take care of.
> +        //
> +        // In either case we follow the safety requirements of `__enqueue`.
> +        unsafe {
> +            w.__enqueue(move |work_ptr| {
> +                bindings::queue_work_on(bindings::WORK_CPU_UNBOUND as _, queue_ptr, work_ptr)
> +            })
> +        }
> +    }
> +}
> +
> +/// A work item.
> +///
> +/// This is the low-level trait that is designed for being as general as possible.
> +///
> +/// # Safety
> +///
> +/// Implementers must ensure that `__enqueue` behaves as documented.
> +pub unsafe trait WorkItem {
> +    /// The return type of [`Queue::enqueue`].
> +    type EnqueueOutput;
> +
> +    /// Enqueues this work item on a queue using the provided `queue_work_on` method.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Calling this method guarantees that the provided closure will be called with a raw pointer
> +    /// to a `struct work_struct`. The closure should behave in the following way:
> +    ///
> +    ///  1. If the `struct work_struct` cannot be pushed to a workqueue because its already in one,
> +    ///     then the closure should return `false`. It may not access the pointer after returning
> +    ///     `false`.
> +    ///  2. If the `struct work_struct` is successfully added to a workqueue, then the closure
> +    ///     should return `true`. When the workqueue executes the work item, it will do so by
> +    ///     calling the function pointer stored in the `struct work_struct`. The work item ensures
> +    ///     that the raw pointer remains valid until that happens.
> +    ///
> +    /// This method may not have any other failure cases than the closure returning `false`. The
> +    /// output type should reflect this, but it may also be an infallible type if the work item
> +    /// statically ensures that pushing the `struct work_struct` will succeed.
> +    ///
> +    /// If the work item type is annotated with any lifetimes, then the workqueue must call the
> +    /// function pointer before any such lifetime expires. (Or it may forget the work item and
> +    /// never call the function pointer at all.)
> +    ///
> +    /// If the work item type is not [`Send`], then the work item must be executed on the same
> +    /// thread as the call to `__enqueue`.
> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool;
> +}

