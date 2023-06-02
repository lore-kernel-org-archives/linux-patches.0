Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1C7258F
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 14:43:48 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-96fdc081cb3so298844166b.2
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 07:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685717027; x=1688309027;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=HiT9+FOvSDgrU3EvO2uC6SOYObLJTSqPECXVlks7Q4s=;
        b=fksRSXQg0xd3o1gTujB1C0oLz9ZjsAd3ALsBJe5SOmG8a7VsgwnlpGsy+0b0Dr4n/U
         A4xJkyFLkDK6juw5/aZ2kwz5HO2LE9pilpukOvPJnIISikBNmK3rx+9SWwDP005MOXW7
         t6/VW6H02HYL4IcsB2Xjsp//RX6Dj75OYqSaMqXolzbcaYJ9sEZsCbC8ydd+NfgXn14E
         CJF7yDuNXWygqVKFAyodAQaUg8IhnemQjQAYBLmaWZk9Dz22/E7hqH9IDFmrorcnV9g5
         o3QvyeLNBiVlBTBUd1G2cEW4AUlipOG1mLgjiEWLoE/+Qc/7JzOSkBN0SmJ6uJ8WkzPw
         PxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685717027; x=1688309027;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HiT9+FOvSDgrU3EvO2uC6SOYObLJTSqPECXVlks7Q4s=;
        b=P4/b3QVd6KUH/bhGG3LYotIjb1Scme0YwtK+poZpPuasJeTfkubFo9kpntUCt6aFkU
         Nesr3CjLqjWYfO7XPYlKdWR7LhlvArDuDRiJlMzGIWw1m+UmlJ6ENp6LkMk8PPEz0gD8
         v2px4m74lNMiM+M5cZl4itT6ztFOHxDMCJp9ZwIetZchj87kZz1N+rVx1hLPjjiRQzvZ
         FtzOVnUW+6i6vDC3f9UzgBz8PWoo+BJPIUwXQ/KpFlJdtWf1CQdYKP8QaCoMuzrCHtOM
         WM2WUjGaw5Rgeok2lEWgXfIcumM5YucGzmXIReULbIS/f3SVrdG1Lbq9Hhz+fcj3WJVu
         B9zw==
X-Gm-Message-State: AC+VfDz5GfMsFt84m8zesKBNSKEKe3UfgmtNSBf7DqAHhdtr7qvJdmRJ
	YWAF8MCmNaqhy9gPWFKE8iPmnw==
X-Google-Smtp-Source: ACHHUZ4vu/ybbB860ST000hxSx+G25W11XyrRD4vZ7zPqf4TWeGuIiYRh2boQPz9XQfe7pptwDHqGA==
X-Received: by 2002:a17:907:7b98:b0:973:940e:a01b with SMTP id ne24-20020a1709077b9800b00973940ea01bmr12464509ejc.60.1685717027127;
        Fri, 02 Jun 2023 07:43:47 -0700 (PDT)
Received: from localhost ([194.62.217.2])
        by smtp.gmail.com with ESMTPSA id a22-20020a1709063e9600b0096637a19dccsm816565ejj.210.2023.06.02.07.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 07:43:46 -0700 (PDT)
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-8-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 7/8] rust: workqueue: add `try_spawn` helper method
Date: Fri, 02 Jun 2023 16:43:33 +0200
In-reply-to: <20230601134946.3887870-8-aliceryhl@google.com>
Message-ID: <87bkhx2acd.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> This adds a convenience method that lets you spawn a closure for
> execution on a workqueue. This will be the most convenient way to use
> workqueues, but it is fallible because it needs to allocate memory.
>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Andreas Hindborg (Samsung) <nmi@metaspace.dk>

> ---
>  rust/kernel/workqueue.rs | 43 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
> index f06a2f036d8b..c302e8b8624b 100644
> --- a/rust/kernel/workqueue.rs
> +++ b/rust/kernel/workqueue.rs
> @@ -29,6 +29,7 @@
>  //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
>  
>  use crate::{bindings, prelude::*, sync::Arc, types::Opaque};
> +use alloc::alloc::AllocError;
>  use alloc::boxed::Box;
>  use core::marker::{PhantomData, PhantomPinned};
>  use core::pin::Pin;
> @@ -87,6 +88,44 @@ pub fn enqueue<W, const ID: u64>(&self, w: W) -> W::EnqueueOutput
>              })
>          }
>      }
> +
> +    /// Tries to spawn the given function or closure as a work item.
> +    ///
> +    /// This method can fail because it allocates memory to store the work item.
> +    pub fn try_spawn<T: 'static + Send + FnOnce()>(&self, func: T) -> Result<(), AllocError> {
> +        let init = pin_init!(ClosureWork {
> +            work <- Work::new(),
> +            func: Some(func),
> +        });
> +
> +        self.enqueue(Box::pin_init(init).map_err(|_| AllocError)?);
> +        Ok(())
> +    }
> +}
> +
> +/// A helper type used in `try_spawn`.
> +#[pin_data]
> +struct ClosureWork<T> {
> +    #[pin]
> +    work: Work<ClosureWork<T>>,
> +    func: Option<T>,
> +}
> +
> +impl<T> ClosureWork<T> {
> +    fn project(self: Pin<&mut Self>) -> &mut Option<T> {
> +        // SAFETY: The `func` field is not structurally pinned.
> +        unsafe { &mut self.get_unchecked_mut().func }
> +    }
> +}
> +
> +impl<T: FnOnce()> WorkItem for ClosureWork<T> {
> +    type Pointer = Pin<Box<Self>>;
> +
> +    fn run(mut this: Pin<Box<Self>>) {
> +        if let Some(func) = this.as_mut().project().take() {
> +            (func)()
> +        }
> +    }
>  }
>  
>  /// A raw work item.
> @@ -325,6 +364,10 @@ unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_typ
>      )*};
>  }
>  
> +impl_has_work! {
> +    impl<T> HasWork<Self> for ClosureWork<T> { self.work }
> +}
> +
>  unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
>  where
>      T: WorkItem<ID, Pointer = Self>,

