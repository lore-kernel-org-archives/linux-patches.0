Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AC612B70
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 10:01:34 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59f8134ec00so66189847b3.3
        for <patches@lists.linux.dev>; Tue, 26 Sep 2023 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695722494; x=1696327294; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSjOVj3NEZLcZiR/Ha2dwc9eHr7RbUTNTjvX8TFLRcY=;
        b=3M6VAIkfye4Mjl1FSXbx45o2D4lIzpizGteCwipUI0YiwtFD07PiZ6KpkYaHvug95W
         g9DPNO7KMDPqjGgXLJm2qwQw0kvsVTEtySHZl7TAmHfKDu66JkCcSWGjsx4CNJ9pzCBX
         lDmpM2IilVioxP5tMqwxPNym0Y5L+m6XwPtzoqAM9ezyCbyigAcQAmE/SC8a1IGRf15D
         QCxl2Oj2b8tSHUiWZ4is4vi4kqrajgjCPuz4lHnSV3zFgEdcw7nU7QyO3NIDUyPCvQP0
         zooQ/ukxy7ECBKDMB7UXbAHZUmySJzMHfsDatyySwIsVFMus69yt0kdY0cyK+CpwKCGN
         7a8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695722494; x=1696327294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSjOVj3NEZLcZiR/Ha2dwc9eHr7RbUTNTjvX8TFLRcY=;
        b=NxR7bBj2MxI7ojnEQuZAkcUjv37ToFRystSzTcYRMBCtjEbfCLHGurFKDe7NoV0kMf
         5OLVzG1UAu91UsX03joo7iAlWCSZi3TVRECjQAuEmZpcByIYMmaSLz1h9xWZKR0hJn/w
         0oF/SJkeS5kEbiJeyW+0e+OWdGRqe9sfUMVVN8ZONtgV+sSBdO62KqhLWoKt6guk8tiE
         RPIAwg+nJ0LZn36dQGdDlZVYDxJjP3RfcMTEKqlgmcrC3Q3TtCl1H5opz96BScRiveEl
         84UPC0VWvxfXnl4oxWug8MvS6ZnayGPY5b+F3H+qughZT3tIS4oHx2d/Ft5/CI/J9ZLo
         JUpw==
X-Gm-Message-State: AOJu0YwIpq+c03BTTQssGBxzNcVKPR+QOr7TLF/53GUYzyTJ5EISwuU4
	xDadov6/jaEUDypoR4GOxcn7/sr7CUSVnmQ=
X-Google-Smtp-Source: AGHT+IENb6kAQt3SlryXf26yUjvt3kHMvyFyfMBdt8l5kkIskKFOxg0e0rnYFWlj/Hfa6u+U/vGJjT4sf4b0An8=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:9c44:0:b0:d80:16bc:4e41 with SMTP id
 x4-20020a259c44000000b00d8016bc4e41mr91493ybo.0.1695722493787; Tue, 26 Sep
 2023 03:01:33 -0700 (PDT)
Date: Tue, 26 Sep 2023 10:01:30 +0000
In-Reply-To: <ESFnxZLcZD-JbNp5PHtrjAdophrPm9gOJR1C5kwsvw6errySiqsG7zbs-0bKWKGrq3Phz7-of0M1znwoTNYAZATTHBhUaFehe5bHP1YksCw=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ESFnxZLcZD-JbNp5PHtrjAdophrPm9gOJR1C5kwsvw6errySiqsG7zbs-0bKWKGrq3Phz7-of0M1znwoTNYAZATTHBhUaFehe5bHP1YksCw=@proton.me>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926100130.2213190-1-aliceryhl@google.com>
Subject: Re: [PATCH v4 4/7] rust: workqueue: add helper for defining
 work_struct fields
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="utf-8"

>> +impl<T: ?Sized, const ID: u64> Work<T, ID> {
>> +    /// Creates a new instance of [`Work`].
>> +    #[inline]
>> +    #[allow(clippy::new_ret_no_self)]
>> +    pub fn new(name: &'static CStr, key: &'static LockClassKey) -> impl PinInit<Self>
>> +    where
>> +        T: WorkItem<ID>,
>> +    {
>> +        // SAFETY: The `WorkItemPointer` implementation promises that `run` can be used as the work
>> +        // item function.
>> +        unsafe {
>> +            kernel::init::pin_init_from_closure(move |slot| {
>> +                let slot = Self::raw_get(slot);
>> +                bindings::init_work_with_key(
>> +                    slot,
>> +                    Some(T::Pointer::run),
>> +                    false,
>> +                    name.as_char_ptr(),
>> +                    key.as_ptr(),
>> +                );
>> +                Ok(())
>> +            })
>> +        }
> 
> I would suggest this instead:
> ```
>         pin_init!(Self {
>             // SAFETY: The `WorkItemPointer` implementation promises that `run` can be used as the
>             // work item function.
>             work <- Opaque::ffi_init(|slot| unsafe {
>                 bindings::init_work_with_key(
>                     slot,
>                     Some(T::Pointer::run),
>                     false,
>                     name.as_char_ptr(),
>                     key.as_ptr(),
>                 )
>             }),
>             _inner: PhantomData,
>         })
> ```

I tried setting up a patch with a few nits fixed, including this one.
However, I ran into an error when adding #[pin_data] to the Work struct:

error: defaults for const parameters are only allowed in `struct`, `enum`, `type`, or `trait` definitions
   --> rust/kernel/workqueue.rs:192:28
    |
192 | pub struct Work<T: ?Sized, const ID: u64 = 0> {
    |                            ^^^^^^^^^^^^^^^^^

This nit can be fixed when #[pin_data] is updated to support default
values in struct declarations.

Alice
