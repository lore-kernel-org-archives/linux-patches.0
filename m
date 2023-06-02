Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA0F17AA2
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 09:37:45 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-974566553ccso81065866b.3
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 02:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685698663; x=1688290663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g6hKGnk7+yrdCqGxFZXtFZSCtr3Hs69nhywa4vN9dQk=;
        b=k++9SNiv/OO3O33g9/9eTroGH9b5hGlPNSi00zMI+3lKBu4RkFuIC1EcEe7KD/jbaz
         w7M2YFlWaueUEZ3ZBRhBGEljk4CX6XobHPYEr/cMV88eHC8OdecDaOMfZJuBeqInAwD+
         AS49oX1gWO0jWTyaCmjdNL7X0Yk+k7i5creGBmVCLkabQjlsHTPe5sA28usbmDCXYCRJ
         4ZptKGmHboTtMeV00P4JBm95Ws+ym2erT/xlVh4nZgISW78geGc+StYhiNHOeV4sSw4e
         PAkVnBlceCInTUdm4jIK/4AJvO4dTSuhgWJSM/z4SZ2w33u+uzuwv+yyv44kgQKOdQGn
         uWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685698663; x=1688290663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g6hKGnk7+yrdCqGxFZXtFZSCtr3Hs69nhywa4vN9dQk=;
        b=dj4FRsDbN5dlSayuBHbVDjhQcuT9xssADnKPmg/AKIODxtpzncUFm705N4LOvn1sU3
         CCX6Nec5ZJfVe/FRVBGJVwag2BI4moy0hEFhr/HX05NaL5MrLgUNGBX6BbKJlSG5pZYq
         ngeKl4Hsc0mF9NF2AfF18vftOzedmNDlBl9+koBIKtZ55edGYGd2MXEHmJnbo6eu9hgn
         KrVy6Gd28hhfjlTO+CJQy2rC7jkqbn86/86Bc3I6ugKy41lPzqf5NRSO0KyPhYbSy1wP
         jNTFy++7KW/bJQ9IBVZotVXMZxsK8wt0aNilR5pncHLv3ddorio9Om62FCHkSJVGTcjp
         gycw==
X-Gm-Message-State: AC+VfDx9+U0nliXpoM6cqtM/vM0IO29ZlDXa9svYWMsvmR9JdX5EYBkO
	ciXZYNQPyhlxRWdfZwyy1FgpbZCKyxsd3MM=
X-Google-Smtp-Source: ACHHUZ6JmHF0O7xB25c4LZS3SBpbPu8gJ1LUrG2oig85p/mrkugigxAcAyjZYDiO5uEzwymT7yTtjwNZQO8JTzA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:5a69:b0:974:5e62:2afc with SMTP
 id my41-20020a1709065a6900b009745e622afcmr502336ejc.13.1685698663640; Fri, 02
 Jun 2023 02:37:43 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:37:41 +0000
In-Reply-To: <ZHkI8LXrqUOJ7G5E@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZHkI8LXrqUOJ7G5E@boqun-archlinux>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602093741.1040283-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 5/8] rust: workqueue: add helper for defining
 work_struct fields
From: Alice Ryhl <aliceryhl@google.com>
To: boqun.feng@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Boqun Feng <boqun.feng@gmail.com> writes:
> On Thu, Jun 01, 2023 at 01:49:43PM +0000, Alice Ryhl wrote:
>> +/// Defines the method that should be called directly when a work item is executed.
>> +///
>> +/// Typically you would implement [`WorkItem`] instead. The `run` method on this trait will
>> +/// usually just perform the appropriate `container_of` translation and then call into the `run`
>> +/// method from the [`WorkItem`] trait.
>> +///
>> +/// This trait is used when the `work_struct` field is defined using the [`Work`] helper.
>> +///
>> +/// # Safety
>> +///
>> +/// Implementers must ensure that [`__enqueue`] uses a `work_struct` initialized with the [`run`]
>> +/// method of this trait as the function pointer.
>> +///
>> +/// [`__enqueue`]: RawWorkItem::__enqueue
>> +/// [`run`]: WorkItemPointer::run
>> +pub unsafe trait WorkItemPointer<const ID: u64>: RawWorkItem<ID> {
>> +    /// Run this work item.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// The provided `work_struct` pointer must originate from a previous call to `__enqueue` where
>> +    /// the `queue_work_on` closure returned true, and the pointer must still be valid.
>> +    unsafe extern "C" fn run(ptr: *mut bindings::work_struct);
>> +}
>> +
>> +/// Defines the method that should be called when this work item is executed.
>> +///
>> +/// This trait is used when the `work_struct` field is defined using the [`Work`] helper.
>> +pub trait WorkItem<const ID: u64 = 0> {
>> +    /// The pointer type that this struct is wrapped in. This will typically be `Arc<Self>` or
>> +    /// `Pin<Box<Self>>`.
>> +    type Pointer: WorkItemPointer<ID>;
> 
> This being an associate type makes me wonder how do we want to support
> the following (totally made-up by me, but I think it makes sense)?:
> 
> Say we have a struct
> 
> 	pub struct Foo {
> 		work: Work<Foo>,
> 		data: Data,
> 	}
> 
> 	impl Foo {
> 		pub fn do_sth(&self) {
> 			...
> 		}
> 	}
> 
> and we want to queue both Pin<Box<Foo>> and Arc<Foo> as work items, but
> the following doesn't work:
> 
> 	// Pin<Box<Foo>> can be queued.
> 	impl WorkItem for Foo {
> 		type Pointer = Pin<Box<Foo>>;
> 		fn run(ptr: Self::Pointer) {
> 			ptr.do_sth();
> 		}
> 	}
> 
> 	// Arc<Foo> can also be queued.
> 	impl WorkItem for Foo {
> 		type Pointer = Arc<Foo>;
> 		fn run(ptr: Self::Pointer) {
> 			ptr.do_sth();
> 		}
> 	}
> 
> Of course, we can use new type idiom, but that's not really great, and
> we may have more smart pointer types in the future.
> 
> Am I missing something here?

Basically, you're asking "is it possible to use the same `work_struct`
field for several different pointer types"?

When creating the function pointer to store in the `work_struct`, the
function pointer _must_ know what the pointer type is. Otherwise it
cannot call the right `WorkItem::run` method or perform the correct
`container_of` operation. (E.g. an `Arc` embeds a `refcount_t` before
the struct, but a `Box` does not.)

With an associated type there is no problem with that. Associated types
force you to make a choice, which means that the `work_struct` knows
what the pointer type is when you create it. Supporting what you suggest
means that we must be able to change the function pointer stored in the
`work_struct` after initializing it.

This is rather tricky because you can call `enqueue` from several
threads in parallel; just setting the function pointer before you call
`queue_work_on` would be a data race. I suppose you could do it by
implementing our own `queue_work_on` that sets the function pointer
_after_ successfully setting the `WORK_STRUCT_PENDING_BIT`, but I don't
think this patchset should do that.

Alice
