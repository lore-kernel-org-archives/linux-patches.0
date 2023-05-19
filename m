Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8E7C
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:29:07 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6aaf43edb78so195720a34.1
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456147; x=1687048147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oPtCHkDQxb8jka0MLHwCfUFpyGiljZFSFC0icEAAC9c=;
        b=WvvuohwzWbQMIqyo0Tzftsi/sG5397/XLweRRcG1vh0hG+QBoE2wwGa/O/h2/pdiJ7
         ybl96LPl6r4rNLMpopdKkAPJ9KkyohPoKN3Z/b32KKMKCESmC94V4IJuhQn6SEN/z4k3
         nBWAO6N0idBtV51Oumk7XIq66LtNBpoC89jiTggavlyTPE1CRwY9nXf1tDPttb55AseL
         f1NLdcqnx0olMKmv35FIkQRawFtpOiHR5q4jNwLqCEfywkvZnyHFPQX8oqArOwzbyQUN
         laXjp4GA3e1f6iXdl9IDejXUMzLik/Q9U4dXEOX519rwmwG2DynUwMp7TII1JHS/RAEN
         FNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456147; x=1687048147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPtCHkDQxb8jka0MLHwCfUFpyGiljZFSFC0icEAAC9c=;
        b=D3BEReUmS+Qn7UYU8xgDOzbZCpT3oGNCB9TVeto/1E44rmqST6JV/twb49LagBNAjW
         fm8oKsoqGxPDJIrTJQPfwCEadybqkzjB9ezq9vyaKr8RrME1ZJJ3HavmH+qFEDDs4pEt
         OsQUHiZedDAvJOTfEEndAjml9FL443SjEbg3v5oo4/IULfEtWWv3wzQyQ11+UjGCj2t8
         KUSzbldnb7P9jkX922AQ/QamifI6/jmM45JpoPSW6J5CI1jyxP6shLh3w2lSCgwAyqAZ
         r4sqMR1lRs+bj830lBd4jHsLUyfHBNVH+EgigENB8pXJ9KGlIiJ1zUX7OZqmivpfq+1k
         98xg==
X-Gm-Message-State: AC+VfDy+FF60DwTe205Mz/dboIhIrm6eI60e/Tj4zzTK7L3Sngcxojzs
	YNwmGuJUXXRU7wUPHFWoSCc=
X-Google-Smtp-Source: ACHHUZ56NPeOBvdWmdOifZBkybGA0d+n6hi1s/Lb1LWLzH3Y5qH852YLu8wlX/GQBQdqLRCU4FazEg==
X-Received: by 2002:a05:6830:1208:b0:6a7:cdb1:88ff with SMTP id r8-20020a056830120800b006a7cdb188ffmr390175otp.14.1684456146947;
        Thu, 18 May 2023 17:29:06 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id h7-20020a056830164700b006a62aac5736sm1185054otr.28.2023.05.18.17.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:29:06 -0700 (PDT)
Message-ID: <b54801cd-1afb-2190-3b8a-4a095d04fdff@gmail.com>
Date: Thu, 18 May 2023 21:17:21 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-7-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230517203119.3160435-7-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> This commit introduces `ArcWorkItem`, `BoxWorkItem`, and
> `define_work_adapter_newtype!` that make it possible to use the
> workqueue without any unsafe code whatsoever.
> 
> The `ArcWorkItem` and `BoxWorkItem` traits are used when a struct has a
> single `work_struct` field.
> 
> The `define_work_adapter_newtype!` macro is used when a struct has
> multiple `work_struct` fields. For each `work_struct` field, a newtype
> struct is defined that wraps `Arc<TheStruct>`, and pushing an instance
> of the newtype to a workqueue will enqueue it using the associated
> `work_struct` field. The newtypes are matched with `work_struct` fields
> by having the T in `Work<T>` be the newtype.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]
> +
> +unsafe impl<T> WorkItem for Arc<T>
> +where
> +    T: ArcWorkItem + HasWork<Self> + ?Sized,
> +{
> +    type EnqueueOutput = Result<(), Self>;
> +
> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool,
> +    {
> +        let ptr = Arc::into_raw(self);
> +
> +        // Using `get_work_offset` here for object-safety.
> +        //
> +        // SAFETY: The pointer is valid since we just got it from `into_raw`.
> +        let off = unsafe { (&*ptr).get_work_offset() };
> +
> +        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
> +        // `Work<Self>` in the same allocation.
> +        let work_ptr = unsafe { (ptr as *const u8).add(off) as *const Work<Self> };
> +        // SAFETY: The pointer is not dangling.
> +        let work_ptr = unsafe { Work::raw_get(work_ptr) };
> +
> +        match (queue_work_on)(work_ptr) {

Match for boolean is not a good pattern in my eyes, if-else should be
used instead. Also aren't the parens around the closure unnecessary?

> +            true => Ok(()),
> +            // SAFETY: The work queue has not taken ownership of the pointer.
> +            false => Err(unsafe { Arc::from_raw(ptr) }),
> +        }
> +    }
> +}
> +
> [...]
> +
> +unsafe impl<T> WorkItem for Pin<Box<T>>
> +where
> +    T: BoxWorkItem + HasWork<Self> + ?Sized,
> +{
> +    // When a box is in a workqueue, the workqueue has exclusive ownership of the box. Therefore,
> +    // it's not possible to enqueue a box while it is in a workqueue.
> +    type EnqueueOutput = ();
> +
> +    unsafe fn __enqueue<F>(self, queue_work_on: F)
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool,
> +    {
> +        // SAFETY: We will not used the contents in an unpinned manner.
> +        let ptr = unsafe { Box::into_raw(Pin::into_inner_unchecked(self)) };
> +
> +        // Using `get_work_offset` here for object-safety.
> +        //
> +        // SAFETY: The pointer is valid since we just got it from `into_raw`.
> +        let off = unsafe { (&*ptr).get_work_offset() };
> +
> +        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
> +        // `Work<Self>` in the same allocation.
> +        let work_ptr = unsafe { (ptr as *mut u8).add(off) as *mut Work<Self> };
> +        // SAFETY: The pointer is not dangling.
> +        let work_ptr = unsafe { Work::raw_get(work_ptr) };
> +
> +        match (queue_work_on)(work_ptr) {

Same as above.

> +            true => {}
> +            // SAFETY: This method requires exclusive ownership of the box, so it cannot be in a
> +            // workqueue.
> +            false => unsafe { core::hint::unreachable_unchecked() },
> +        }
> +    }
> +}
> +
> [...]
> +
> +/// Helper macro for structs with several `Work` fields that can be in several queues at once.
> +///
> +/// For each `Work` field in your type `T`, a newtype struct that wraps an `Arc<T>` or
> +/// `Pin<Box<T>>` should be defined.
> +///
> +/// # Examples
> +///
> +/// ```

There must be those work macro and type imports here I think.

> +/// struct MyStruct {
> +///     work1: Work<MyStructWork1>,
> +///     work2: Work<MyStructWork2>,
> +/// }
> +///
> +/// impl_has_work! {
> +///     impl HasWork<MyStructWork1> for MyStruct { self.work1 }
> +///     impl HasWork<MyStructWork2> for MyStruct { self.work2 }
> +/// }
> +///
> +/// define_work_adapter_newtype! {
> +///     struct MyStructWork1(Arc<MyStruct>);
> +///     struct MyStructWork2(Arc<MyStruct>);
> +/// }
> +///
> +/// impl MyStructWork1 {
> +///     fn run(self) {
> +///         // ...
> +///     }
> +/// }
> +///
> +/// impl MyStructWork2 {
> +///     fn run(self) {
> +///         // ...
> +///     }
> +/// }
> +/// ```
> +///
> +/// This will let you push a `MyStructWork1(arc)` or `MyStructWork2(arc)` to a work queue. The [`Arc`]
> +/// can be in two work queues at the same time, and the `run` method on the wrapper type is called
> +/// when the work item is called.
> +///
> +/// [`Arc`]: crate::sync::Arc
> +#[macro_export]
> +macro_rules! define_work_adapter_newtype {
> +    (
> +        $(#[$outer:meta])*
> +        $pub:vis struct $name:ident(
> +            $(#[$innermeta:meta])*
> +            $fpub:vis Arc<$inner:ty> $(,)?
> +        );
> +        $($rest:tt)*
> +    ) => {
> +        $(#[$outer])*
> +        $pub struct $name($(#[$innermeta])* $fpub $crate::sync::Arc<$inner>);
> +
> +        unsafe impl $crate::workqueue::WorkItem for $name {
> +            type EnqueueOutput = ::core::result::Result<(), $name>;
> +
> +            unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
> +            where
> +                F: ::core::ops::FnOnce(*mut $crate::bindings::work_struct) -> bool,
> +            {
> +                let ptr = $crate::sync::Arc::into_raw(self.0);
> +
> +                // SAFETY: The pointer is not dangling since we just got it from Arc::into_raw.
> +                let work_ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::raw_get_work(ptr.cast_mut()) };
> +
> +                // SAFETY: The pointer is not dangling.
> +                let work_ptr = unsafe { $crate::workqueue::Work::raw_get(work_ptr) };
> +
> +                match (queue_work_on)(work_ptr) {

Same as what I've said on those `WorkItem` impls.

> +                    true => Ok(()),
> +                    // SAFETY: The work queue has not taken ownership of the pointer.
> +                    false => Err($name(unsafe { $crate::sync::Arc::from_raw(ptr) })),
> +                }
> +            }
> +        }
> [...]
> +    };
> +
> +    (
> +        $(#[$outer:meta])*
> +        $pub:vis struct $name:ident(
> +            $(#[$innermeta:meta])*
> +            $fpub:vis Pin<Box<$inner:ty>> $(,)?
> +        );
> +        $($rest:tt)*
> +    ) => {
> +        $(#[$outer])*
> +        $pub struct $name($(#[$innermeta])* $fpub ::core::pin::Pin<::alloc::boxed::Box<$inner>>);
> +
> +        unsafe impl $crate::workqueue::WorkItem for $name {
> +            type EnqueueOutput = ();
> +
> +            unsafe fn __enqueue<F>(self, queue_work_on: F)
> +            where
> +                F: ::core::ops::FnOnce(*mut $crate::bindings::work_struct) -> bool,
> +            {
> +                // SAFETY: We will not used the contents in an unpinned manner.
> +                let boxed = unsafe { ::core::pin::Pin::into_inner_unchecked(self.0) };
> +                let ptr = ::alloc::boxed::Box::into_raw(boxed);
> +
> +                // SAFETY: The pointer is not dangling since we just got it from Box::into_raw.
> +                let work_ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::raw_get_work(ptr) };
> +
> +                // SAFETY: The pointer is not dangling.
> +                let work_ptr = unsafe { $crate::workqueue::Work::raw_get(work_ptr) };
> +
> +                match (queue_work_on)(work_ptr) {

Same as above.

> +                    true => {},
> +                    // SAFETY: This method requires exclusive ownership of the box, so it cannot be in a
> +                    // workqueue.
> +                    false => unsafe { ::core::hint::unreachable_unchecked() },
> +                }
> +            }
> +        }
> +
> [...]
