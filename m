Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004AE11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:20 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94a34a0b75eso257482066b.1
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 03:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693219759; x=1693824559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OAlJg4PuI7woDTN+Wm0bsiKVHLOIDSV75p/+lEqw6kA=;
        b=XnFwXu5YDpx5+Ab0UAmbjNTDztHVXo9CpSwyE2EFlfbXimUQ5lTwlHIAnFZ3t4o49C
         k/jepCs7z98GXEWCJcoe5gcXzqGfQav18Rx1BMZSWghaROBGzXVbHA50JxL2MZHpaptC
         yPxz4zg56rnMJr92kMj43rgQCUc96IXT4tO9fEbl4OH7M0JITbMUWr10opQHVb8RQuAT
         ij4nHODutJ3XLY2UeJiaNc1P2vjVtvyuGbWQV8THNGvw9JgExkGgjjPocqY3aXyQWCpM
         r0IfP83Cr06VOIw5+26XpEag2RfKq/l0D6uEOOfBEdfrD40nfEP/mlSB9xDvl3x5uggH
         3q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693219759; x=1693824559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAlJg4PuI7woDTN+Wm0bsiKVHLOIDSV75p/+lEqw6kA=;
        b=jAoZIX5k8ZFmgTOnKOXEkCJ5owqh72e+0F6z1tWBiTrYXjdjSty55YRLnBnCvF8O30
         v3eoG/mImaNdebyN5PvoelDD5qbasHTYWhBaAJdD7hlwHWG+pWn3r+8BTCkRMzItX0ae
         v+HTkFjgkD7f8LIMBINFJvuoGmmB8WZcq1DQGthz4fC3TZ1bXj0VmDsqCZ1n/ByZqcM3
         nKbBZJsne6pG96pPDe6RBd9j6ExLdFhLF+hKAnnzXDze9GkEXIwZfrkKxY1FSCiswvch
         Qh41pNC4olbvu2K/yFV7HVMmSyQW0GaqJp1bpZmuCGBPYzzPhaGfaZhs3l1G2b25cfQt
         es6w==
X-Gm-Message-State: AOJu0Yyk9OlnRtg4akv6LnuiSxmdengr1Wove1WO8bzyAGuWxAbnnDo1
	9IaI+EKF0Z2nnEy3F5WZlIcl15SXmdUcvFg=
X-Google-Smtp-Source: AGHT+IGlSInn2X6uUdlEjdFRXR4sN14V7sjkE1qqya78L0m3DBmtXEEaU3Orgvxl9fEF3KQmjDsnQRr0V0Fh5Xk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:8aaf:b0:9a1:ebcf:bcbc with SMTP
 id mu47-20020a1709068aaf00b009a1ebcfbcbcmr373856ejc.4.1693219759144; Mon, 28
 Aug 2023 03:49:19 -0700 (PDT)
Date: Mon, 28 Aug 2023 10:48:07 +0000
In-Reply-To: <20230828104807.1581592-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230828104807.1581592-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230828104807.1581592-8-aliceryhl@google.com>
Subject: [PATCH v4 7/7] rust: workqueue: add examples
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Martin Rodriguez Reboredo <yakoyoku@gmail.com>, 
	Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"

This adds two examples of how to use the workqueue. The first example
shows how to use it when you only have one `work_struct` field, and the
second example shows how to use it when you have multiple `work_struct`
fields.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Andreas Hindborg (Samsung) <nmi@metaspace.dk>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
v3 -> v4:
 * Use `new_work!` macro.
 * Fix example imports.

 rust/kernel/workqueue.rs | 106 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 40ccc53f6e93..b67fb1ba168e 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -26,6 +26,112 @@
 //!  * The `WorkItemPointer` trait is implemented for the pointer type that points at a something
 //!    that implements `WorkItem`.
 //!
+//! ## Example
+//!
+//! This example defines a struct that holds an integer and can be scheduled on the workqueue. When
+//! the struct is executed, it will print the integer. Since there is only one `work_struct` field,
+//! we do not need to specify ids for the fields.
+//!
+//! ```
+//! use kernel::prelude::*;
+//! use kernel::sync::Arc;
+//! use kernel::workqueue::{self, Work, WorkItem};
+//! use kernel::{impl_has_work, new_work};
+//!
+//! #[pin_data]
+//! struct MyStruct {
+//!     value: i32,
+//!     #[pin]
+//!     work: Work<MyStruct>,
+//! }
+//!
+//! impl_has_work! {
+//!     impl HasWork<Self> for MyStruct { self.work }
+//! }
+//!
+//! impl MyStruct {
+//!     fn new(value: i32) -> Result<Arc<Self>> {
+//!         Arc::pin_init(pin_init!(MyStruct {
+//!             value,
+//!             work <- new_work!("MyStruct::work"),
+//!         }))
+//!     }
+//! }
+//!
+//! impl WorkItem for MyStruct {
+//!     type Pointer = Arc<MyStruct>;
+//!
+//!     fn run(this: Arc<MyStruct>) {
+//!         pr_info!("The value is: {}", this.value);
+//!     }
+//! }
+//!
+//! /// This method will enqueue the struct for execution on the system workqueue, where its value
+//! /// will be printed.
+//! fn print_later(val: Arc<MyStruct>) {
+//!     let _ = workqueue::system().enqueue(val);
+//! }
+//! ```
+//!
+//! The following example shows how multiple `work_struct` fields can be used:
+//!
+//! ```
+//! use kernel::prelude::*;
+//! use kernel::sync::Arc;
+//! use kernel::workqueue::{self, Work, WorkItem};
+//! use kernel::{impl_has_work, new_work};
+//!
+//! #[pin_data]
+//! struct MyStruct {
+//!     value_1: i32,
+//!     value_2: i32,
+//!     #[pin]
+//!     work_1: Work<MyStruct, 1>,
+//!     #[pin]
+//!     work_2: Work<MyStruct, 2>,
+//! }
+//!
+//! impl_has_work! {
+//!     impl HasWork<Self, 1> for MyStruct { self.work_1 }
+//!     impl HasWork<Self, 2> for MyStruct { self.work_2 }
+//! }
+//!
+//! impl MyStruct {
+//!     fn new(value_1: i32, value_2: i32) -> Result<Arc<Self>> {
+//!         Arc::pin_init(pin_init!(MyStruct {
+//!             value_1,
+//!             value_2,
+//!             work_1 <- new_work!("MyStruct::work_1"),
+//!             work_2 <- new_work!("MyStruct::work_2"),
+//!         }))
+//!     }
+//! }
+//!
+//! impl WorkItem<1> for MyStruct {
+//!     type Pointer = Arc<MyStruct>;
+//!
+//!     fn run(this: Arc<MyStruct>) {
+//!         pr_info!("The value is: {}", this.value_1);
+//!     }
+//! }
+//!
+//! impl WorkItem<2> for MyStruct {
+//!     type Pointer = Arc<MyStruct>;
+//!
+//!     fn run(this: Arc<MyStruct>) {
+//!         pr_info!("The second value is: {}", this.value_2);
+//!     }
+//! }
+//!
+//! fn print_1_later(val: Arc<MyStruct>) {
+//!     let _ = workqueue::system().enqueue::<Arc<MyStruct>, 1>(val);
+//! }
+//!
+//! fn print_2_later(val: Arc<MyStruct>) {
+//!     let _ = workqueue::system().enqueue::<Arc<MyStruct>, 2>(val);
+//! }
+//! ```
+//!
 //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
 
 use crate::{bindings, prelude::*, sync::Arc, sync::LockClassKey, types::Opaque};
-- 
2.42.0.rc1.204.g551eb34607-goog

