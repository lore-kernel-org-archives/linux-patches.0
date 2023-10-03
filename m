Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8FB3D972
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 22:29:51 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59f4f2a9ef0so21828987b3.2
        for <patches@lists.linux.dev>; Tue, 03 Oct 2023 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696372190; x=1696976990; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dAD+NyD8rwm68rv+KcO6kIHA2BI/1BAlT5OkmuE/mvM=;
        b=XYnyJ2cob9Ya1r2+4s1EUIxdXh6KvDaiSR76QLUEtSk5GuCJeV1CH686yJfjo6ZqtO
         +SCFLD0imO1qqqDyjQ1QYpHqjgDzRu1h43zyuVAIZPd4KpzJCLwQh7GOQafUD2dW5n0r
         jQC/JJcmv+xZj8mZH4UgAfwhtxdLVAZgsjCRDhxo/maTzUSKZev0TMgOvG6nyeCfvi12
         xaNMS5zjRQQ3nCC2yxS5iO55hCfWAEqf2dpcYZakVQWqHrEJLL5SjHXLOlGqVX3YeN3T
         v07P34rvhNyIrOkY5v2n6wEJ4GjQREPbGkE37Kxbj6dUKmSn/tiBcUqtOmDPxu6vVxfG
         Ij4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696372190; x=1696976990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAD+NyD8rwm68rv+KcO6kIHA2BI/1BAlT5OkmuE/mvM=;
        b=uioLAnN3+K86gyJd3MjcC9vqSx5vL7RMHnNrnyFbb43VGa08TS1K9rAlI9hnfJPxJ4
         7y++5uUwOPSglh5aGRkF+irTDwa40YhjNNFeItvRG+ggD+2A+Rk+WE5HYrEonf3D1wkU
         NcZHOkOZq49jI4D/SSq8aRFLPAD3VlIPkEi3YwO4pL9UAgGarb5UBPYr8Jovc47NR84K
         wB3QlpX5dkeYedev9Rmf/kB36vEMNe2rgP+MxM2ia332ewXHlIAop4lnvvI/oQOV1hie
         OETyrSi7Mh/BnbhgIQvZOhc0K3TXJ7tqcy9vP+wD9QZNCMkRKYQbFPxXD7GzIbe8TG8s
         xufQ==
X-Gm-Message-State: AOJu0YzdLeQDSHNE5HIxj5Cmln/Ab6XBYOhKQzdVkmFC4EJy9dxTJgW8
	7vCpY0VXSxDb0ml7pi4L38C2W9TrAcUMG4w=
X-Google-Smtp-Source: AGHT+IEkB0IrCc6Hhu4Q5FKQXGRZYIEeC/u6PqBK0M9bMkwyR8qfAToV0+g3PXMwAURU6yARQ/hdo4TlOU5ndFY=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:248:0:b0:d8c:cc9b:81cc with SMTP id
 69-20020a250248000000b00d8ccc9b81ccmr8747ybc.3.1696372190665; Tue, 03 Oct
 2023 15:29:50 -0700 (PDT)
Date: Tue,  3 Oct 2023 22:29:47 +0000
In-Reply-To: <CVZ2KU4KK5YH.2HVL1F6X93YLL@pogg>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CVZ2KU4KK5YH.2HVL1F6X93YLL@pogg>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231003222947.374039-1-aliceryhl@google.com>
Subject: Re: [PATCH v4 7/7] rust: workqueue: add examples
From: Alice Ryhl <aliceryhl@google.com>
To: k.shelekhin@ftml.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, nmi@metaspace.dk, 
	ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	tj@kernel.org, wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="utf-8"

On Tue, Oct 3, 2023 at 10:13PM Konstantin Shelekhin <k.shelekhin@ftml.net> wrote:
> +//! #[pin_data]
> +//! struct MyStruct {
> +//!     value: i32,
> +//!     #[pin]
> +//!     work: Work<MyStruct>,
> +//! }
> +//!
> +//! impl_has_work! {
> +//!     impl HasWork<Self> for MyStruct { self.work }
> +//! }
> +//!
> +//! impl MyStruct {
> +//!     fn new(value: i32) -> Result<Arc<Self>> {
> +//!         Arc::pin_init(pin_init!(MyStruct {
> +//!             value,
> +//!             work <- new_work!("MyStruct::work"),
> +//!         }))
> +//!     }
> +//! }
> +//!
> +//! impl WorkItem for MyStruct {
> +//!     type Pointer = Arc<MyStruct>;
> +//!
> +//!     fn run(this: Arc<MyStruct>) {
> +//!         pr_info!("The value is: {}", this.value);
> +//!     }
> +//! }
> +//!
> +//! /// This method will enqueue the struct for execution on the system workqueue, where its value
> +//! /// will be printed.
> +//! fn print_later(val: Arc<MyStruct>) {
> +//!     let _ = workqueue::system().enqueue(val);
> +//! }
>
> I understand that this is highly opionated, but is it possible to make
> the initialization less verbose?

The short answer is yes. There are safe alternatives that are much less
verbose. Unfortunately, those alternatives give up some of the features
that this design has. Specifically, they give up the feature that allows
you to embed the work_struct inside custom structs. I need to be able to
embed the work_struct inside of custom structs, so I did not go that
route.

There are also some parts of this (mainly `impl_has_work!`) that I am
unhappy with. I would be happy to see a solution that doesn't need it,
but I couldn't figure out how to avoid it.

> Because the C version looks much, much cleaner and easier to grasp:
>
>     struct my_struct {
>         i32 value;
>         struct work_struct work;
>     };
> 
>     void log_value(struct work_struct *work)
>     {
>         struct my_struct *s = container_of(work, struct my_struct, work);
>         pr_info("The value is: %d\n", s->value);
>     }
> 
>     void print_later(struct my_struct &s)
>     {
>         INIT_WORK(&s->work, log_value);
>         schedule_work(&s->work);
>     }

Although I think that a part of this is just whether you are familiar
with Rust syntax, there is definitely some truth to this. Your code is a
lot closer to the machine code of what actually happens here. Perhaps it
would be interesting to see what you get if you just unsafely do exactly
the same thing in Rust? It would look something like this:

    struct MyStruct {
        value: i32,
        work: bindings::work_struct,
    }

    unsafe fn log_value(work: *mut bindings::work_struct) {
        unsafe {
            let s = container_of!(work, MyStruct, work);
            pr_info!("The value is: {}", (*s).value);
        }
    }

    unsafe fn print_later(s: *mut bindings::work_struct) {
        unsafe {
            bindings::INIT_WORK(&mut (*s).work, log_value);
            bindings::schedule_work(&mut (*s).work);
        }
    }

(I didn't try to compile this.)

The problem with this approach is that it uses unsafe in driver code,
but the goal behind Rust abstractions is to isolate all of the related
unsafe code. The idea being that drivers using the workqueue do not need
any unsafe code to use it. This means that, assuming these workqueue
abstractions are correct, no driver can accidentally cause memory
unsafety by using the workqueue wrong.

The main difficult part of making this happen is the container_of
operation. We need to somehow verify *at compile time* that the
container_of in log_value really is given a pointer to the work field of
a MyStruct. Other than the things that are just how Rust looks, most of
the verbosity is necessary to make this compile-time check possible.

Another thing it does is handle proper transfer of ownership. In my
original example, MyStruct is reference counted (due to the use of Arc),
so the workqueue passes ownership of one refcount to the workqueue,
which eventually passes the refcount to run. When `this` goes out of
scope at the end of `run`, the refcount is decremented and the struct is
freed if the refcount dropped to zero.

If you wanted to just have exclusive ownership of my_struct, you could
do that by using Box instead of Arc. In either case, the ownership is
correctly passed to run, and you cannot accidentally forget to free it
at the end of log_value.

So, ultimately there's a tradeoff here. The code corresponds less
directly to what the machine code will be. On the other hand, it will be
*more* difficult to use incorrectly since incorrect uses will usually
result in compilation errors. The claim of Rust is that this tradeoff is
worth it.

Alice

