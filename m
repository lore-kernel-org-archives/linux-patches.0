Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C0117AA2
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 09:39:29 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5161e17f374so2336284a12.0
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 02:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685698767; x=1688290767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Olx8k/dMqft+QmN4YpoMce08+qwb537I3TMS0ysCxZA=;
        b=ezjQZoRV8omv8Hob3qBLfYZbMOSH4dDn3kv5BKMrZuM3LgKvuFJYiI05O5kFVGvifx
         a/fJ24Bk6+nmAgHXfawsb8+IvudoFoCX6sRZ27IZumaPDjhM05qi4p5jt9dEk8pVCqda
         fqv6JLn+ipCNIueD0s8H40ZHhJxqleMFSY+obFVIIVpY8nCnt/dzABdbx4TYtB+v/Me3
         R2MZwpNepVuSosWJPipPrnC8fgLsV9n7N+f0ly8oN1cnQrA+YXtsBvxdHuELy+x+871v
         7l8pWy5OSmnrNyogS7dk6xpg5vlNuT8s5yCqR8Z3klAmJMBxTyMZLOBfNAnuS9sLFkpU
         Y7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685698767; x=1688290767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Olx8k/dMqft+QmN4YpoMce08+qwb537I3TMS0ysCxZA=;
        b=Q3Q+LIvenn33lg6uFA0/lf5+TdVSLlXsHG4jUKu1BB0PGeiaLONhuCZ8fwCPB3Z69Z
         foY8aumjJEhWMTYQkUG2+8yyjPOhrPgtlFYZRTsrqpkKU1/eaHrMzfympyK2fgzqQSn+
         AO0pgifvsdBZdqDKqox7s4cdpAKXK418kPcuWVC1Z1hUpsmBPvJV6eYAZvVfk1STjk9R
         w0RkmWbFSdEsi1X5HrgHWSd23ir4OC02SM6wmQd3IeBvjXFULbGbaJghp5WL2E4/70ZF
         AICABGP+Zk+aiB+mxL2E544panEWprUYnljZc+anY1Zv3TJgWni80LUHUxb7tmLmdq/g
         49NQ==
X-Gm-Message-State: AC+VfDwpWQsNf2gBXxbjCQBxS5Q4hmwkj7oGLi8DkN5qIvCHQ44gsPF/
	N6ttA9GCRaj5rVHpDo7JAITkeVVy+4ttaoU=
X-Google-Smtp-Source: ACHHUZ4BkdBlmKvR8oPJvyxyU0q0fuKrriPC+45+KeXvCSarssDYLV/Y8tkx3Lt+ry38EmRik4pnh+YD+DnbBaw=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:9f28:0:b0:50c:749:b407 with SMTP id
 b37-20020a509f28000000b0050c0749b407mr905313edf.0.1685698767529; Fri, 02 Jun
 2023 02:39:27 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:39:25 +0000
In-Reply-To: <20230601183209.371fd898.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601183209.371fd898.gary@garyguo.net>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602093925.1040727-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 8/8] rust: workqueue: add examples
From: Alice Ryhl <aliceryhl@google.com>
To: gary@garyguo.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Gary Guo <gary@garyguo.net> writes:
> On Thu,  1 Jun 2023 13:49:46 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>> This adds two examples of how to use the workqueue. The first example
>> shows how to use it when you only have one `work_struct` field, and the
>> second example shows how to use it when you have multiple `work_struct`
>> fields.
>> 
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> ---
>>  rust/kernel/workqueue.rs | 104 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 104 insertions(+)
>> 
>> diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
>> index c302e8b8624b..cefcf43ff40e 100644
>> --- a/rust/kernel/workqueue.rs
>> +++ b/rust/kernel/workqueue.rs
>> @@ -26,6 +26,110 @@
>>  //!  * The `WorkItemPointer` trait is implemented for the pointer type that points at a something
>>  //!    that implements `WorkItem`.
>>  //!
>> +//! ## Example
>> +//!
>> +//! This example defines a struct that holds an integer and can be scheduled on the workqueue. When
>> +//! the struct is executed, it will print the integer. Since there is only one `work_struct` field,
>> +//! we do not need to specify ids for the fields.
>> +//!
>> +//! ```
>> +//! use kernel::prelude::*;
>> +//! use kernel::sync::Arc;
>> +//! use kernel::workqueue::{self, Work, WorkItem};
>> +//!
>> +//! #[pin_data]
>> +//! struct MyStruct {
>> +//!     value: i32,
>> +//!     #[pin]
>> +//!     work: Work<MyStruct>,
>> +//! }
>> +//!
>> +//! impl_has_work! {
>> +//!     impl HasWork<Self> for MyStruct { self.work }
>> +//! }
>> +//!
>> +//! impl MyStruct {
>> +//!     fn new(value: i32) -> Result<Arc<Self>> {
>> +//!         Arc::pin_init(pin_init!(MyStruct {
>> +//!             value,
>> +//!             work <- Work::new(),
>> +//!         }))
>> +//!     }
>> +//! }
>> +//!
>> +//! impl WorkItem for MyStruct {
>> +//!     type Pointer = Arc<MyStruct>;
>> +//!
>> +//!     fn run(this: Arc<MyStruct>) {
>> +//!         pr_info!("The value is: {}", this.value);
>> +//!     }
>> +//! }
>> +//!
>> +//! /// This method will enqueue the struct for execution on the system workqueue, where its value
>> +//! /// will be printed.
>> +//! fn print_later(val: Arc<MyStruct>) {
>> +//!     let _ = workqueue::system().enqueue(val);
>> +//! }
>> +//! ```
>> +//!
>> +//! The following example shows how multiple `work_struct` fields can be used:
>> +//!
>> +//! ```
>> +//! use kernel::prelude::*;
>> +//! use kernel::sync::Arc;
>> +//! use kernel::workqueue::{self, Work, WorkItem};
>> +//!
>> +//! #[pin_data]
>> +//! struct MyStruct {
>> +//!     value_1: i32,
>> +//!     value_2: i32,
>> +//!     #[pin]
>> +//!     work_1: Work<MyStruct, 1>,
>> +//!     #[pin]
>> +//!     work_2: Work<MyStruct, 2>,
>> +//! }
>> +//!
>> +//! impl_has_work! {
>> +//!     impl HasWork<Self, 1> for MyStruct { self.work_1 }
>> +//!     impl HasWork<Self, 2> for MyStruct { self.work_2 }
>> +//! }
>> +//!
>> +//! impl MyStruct {
>> +//!     fn new(value_1: i32, value_2: i32) -> Result<Arc<Self>> {
>> +//!         Arc::pin_init(pin_init!(MyStruct {
>> +//!             value_1,
>> +//!             value_2,
>> +//!             work_1 <- Work::new(),
>> +//!             work_2 <- Work::new(),
>> +//!         }))
>> +//!     }
>> +//! }
>> +//!
>> +//! impl WorkItem<1> for MyStruct {
>> +//!     type Pointer = Arc<MyStruct>;
>> +//!
>> +//!     fn run(this: Arc<MyStruct>) {
>> +//!         pr_info!("The value is: {}", this.value_1);
>> +//!     }
>> +//! }
>> +//!
>> +//! impl WorkItem<2> for MyStruct {
>> +//!     type Pointer = Arc<MyStruct>;
>> +//!
>> +//!     fn run(this: Arc<MyStruct>) {
>> +//!         pr_info!("The second value is: {}", this.value_2);
>> +//!     }
>> +//! }
>> +//!
>> +//! fn print_1_later(val: Arc<MyStruct>) {
>> +//!     let _ = workqueue::system().enqueue::<Arc<MyStruct>, 1>(val);
> 
> Nothing bad about explicit, but I just want to confirm that you could
> write
> 
> 	let _ = workqueue::system().enqueue::<_, 1>(val);
> 
> here, right?

Yes, you can also do that.
