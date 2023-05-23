Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9231EA9E
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:10:17 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-510dabb3989so1788195a12.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684851016; x=1687443016;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=odrvmB6aW4j6WyrX5D9zci+31pxZ6H0l+pIfR4FXqCA=;
        b=fX0B1I3mDg+racPxVnxeOqxxRwy6lp6PV/FCCoavnXihWp9UDWN7EoPie56ykAnZtt
         VmEAzbp8dcpTCXc7NGSAKbD+eGoPP9hwt2lYcR9UNQthJUpWVbRobigDsUVEdNTnNAPt
         bG7a9e+ZxNzUocpgq3GBtQQLjrCqwOdVTzUF/2tkCWfIh5fR5kSVySey7fpu0zep4x6Q
         6AuLbKaiaJrkovHKqFCg2L5jY9zxfQWDGsDsS1tTNEdi2B245dKaQmGmnENc1aeYpQi4
         o2uZVgqr5kO91R3hceNVJd/Vb5bj+94Gy8lK5Vp0J+p+JjtHM2VHgAN5ED3rnZT2Gj0F
         shWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684851016; x=1687443016;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odrvmB6aW4j6WyrX5D9zci+31pxZ6H0l+pIfR4FXqCA=;
        b=Q+EjwzoR/PqsjplmWHvjE/wsO+zlEbLYVkl1aF3JjY9ai5/Y+U6ZiqtC086VFUkleM
         KwefJ/Ev/3jti8OkwRkxLt7nqbGCyZXiDK+edVxlWLI17mXC3LPkfPe6xPmaIIHtT9aZ
         wgndp4ECZXLLvw7Cir59TCqjEdquGYoRWp1Z7ZSH9zUBeTZbp1bf0/b+lAVeb74pvUpx
         yui3I/cYX12WwpMcpyArGLgT1/yU3emMsuawhaHIH9cLx26iNXo4wS4fvWgxzI45Qp1z
         KTzoWif5fjjfB/rkiR3f1P+/DDtzSpEIDohd/UaHQl0qexmWnTmdn3dzccwQyxy6rnSG
         cXjQ==
X-Gm-Message-State: AC+VfDzt+q8GfPuWGypKSiW5oOlZe4gEP4RZ+Y9YnqDwH+NKQSGPmJJq
	5gjvxYX8xE8BYz/8ieuql9Up0A==
X-Google-Smtp-Source: ACHHUZ7SM0VxVHLY8BYml2BOqyofBDB/Imz9MBd9cH0Y3XZmo86yfhM9UPtUBbWqshb2x8JogJRgkg==
X-Received: by 2002:a17:907:8390:b0:953:37eb:7727 with SMTP id mv16-20020a170907839000b0095337eb7727mr11055069ejc.43.1684851015849;
        Tue, 23 May 2023 07:10:15 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id v3-20020a170906858300b0096a68648329sm4482396ejx.214.2023.05.23.07.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:10:15 -0700 (PDT)
References: <ZGVLo1V4kjx_lep5@slm.duckdns.org>
 <20230517222219.3191560-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: tj@kernel.org, alex.gaynor@gmail.com, benno.lossin@proton.me,
 bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net,
 jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org,
 patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
 wedsonaf@gmail.com
Subject: Re: [PATCH v1 0/7] Bindings for the workqueue
Date: Tue, 23 May 2023 16:08:20 +0200
In-reply-to: <20230517222219.3191560-1-aliceryhl@google.com>
Message-ID: <87mt1vdtq1.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> On Wed, 17 May 2023 11:48:19 -1000, Tejun Heo wrote:
>> I tried to read the patches but am too dumb to understand much.
>
> The patch is more complicated than I would have liked, unfortunately.
> However, as I mentioned in the cover letter, simplifications should be
> on their way.
>
> Luckily, using the workqueue bindings is simpler than the bindings
> themselves.
>
>> Any chance you can provide some examples so that I can at least
>> imagine how workqueue would be used from rust side?
>
> Yes, of course!

If you have bandwidth for it, it would be awesome to see some examples
in the series as well (for /samples/rust).

BR Andreas

>
> The simplest way to use the workqueue is to use the `try_spawn` method
> introduced by the last patch in the series. With this function, you just
> pass a function pointer to the `try_spawn` method, and it schedules the
> function for execution. Unfortunately this allocates memory, making it
> a fallible operation.
>
> To avoid allocation memory, we do something else. As an example, we can
> look at the Rust binder driver that I am currently working on. Here is
> how it will be used in the binder driver: First, the `Process` struct
> will be given a `work_struct` field:
>
> #[pin_data]
> pub(crate) struct Process {
>     // Work node for deferred work item.
>     #[pin]
>     defer_work: Work<Arc<Process>>,
>
>     // Other fields follow...
> }
>
> Here, we use the type `Work<Arc<Process>>` for our field. This type is
> the Rust wrapper for `work_struct`. The generic parameter to `Work`
> should be the pointer type used to access `Process`, and in this case it
> is `Arc<Process>`. The pointer type `Arc` is used for reference
> counting, and its a pointer type that owns a ref-count to the inner
> value. (So e.g., it decrements the ref-cout when the arc goes out of
> scope.) Arc is an abbreviation of "atomic reference count". This means
> that while it is enqueued in the workqueue, the workqueue owns a
> ref-count to the process.
>
> Next, binder will use the `impl_has_work!` macro to declare that it
> wants to use `defer_work` as its `work_struct` field. That looks like
> this:
>
> kernel::impl_has_work! {
>     impl HasWork<Arc<Process>> for Process { self.defer_work }
> }
>
> To define the code that should run when the work item is executed on the
> workqueue, binder does the following:
>
> impl workqueue::ArcWorkItem for Process {
>     fn run(self: Arc<Process>) {
>         // this runs when the work item is executed
>     }
> }
>
> Finally to schedule it to the system workqueue, it does the following:
>
> let _ = workqueue::system().enqueue(process);
>
> Here, the `enqueue` call is fallible, since it might fail if the process
> has already been enqueued to a work queue. However, binder just uses
> `let _ =` to ignore the failure, since it doesn't need to do anything
> special in that case.
>
> I hope that helps, and let me know if you have any further questions.
>
> Alice

