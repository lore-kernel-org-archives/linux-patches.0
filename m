Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3801C182AE
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:56:49 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57704af0e64so61439447b3.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689069408; x=1691661408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVqEtgaoR84mlWb1xo2bD1CrEq4VPJW4ZXsIrXT2SxY=;
        b=JiS7r4oSjpoYeZAQokPiDZbRIRNXbzoWPZL7NF+5rzbH6mH2Rcy5+beBc9ND3C54Cz
         Aus5Cg913qXuDxwKJCGdRWmHr05KJU0rJAHeg88AZD7kauK/bKXdTeDKY4hHqsiAXQQL
         giwWgikoRtreQUO/DBn4FxwrAoqmcTXpHQalZUi4p2Udagcl0C2V8fzJ4YAZqbRHjs39
         J4t57iEQpS8/MHp0zwe9jwefzUlWJejQ8XzKTLzsg3oq45gSz8Ajf7nQvIF4XLItT28/
         qIgL6zZDPEwioH0kLhbOCQCI7+NjZMZFYtDBdbaMW78mZpZzOwkCwthKHdajV8J2epzt
         5zxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689069408; x=1691661408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVqEtgaoR84mlWb1xo2bD1CrEq4VPJW4ZXsIrXT2SxY=;
        b=BKRK0vsZXeG34toYkippNr2QkPxIMCYYPLcMiRMXkhZnKCCQmDQR02zRvE+XRY3Hm9
         Lg8MQFrp8a5Pg9lgcL15ZuVpi/H/51HBsGebXBXI+nJm4lu/oA3A0fI8lecZGix1qXOA
         e+bg4NwC9elFFTr1y3kGLf749ubjvHxoGZHTLSzED3uOMwN4Bfih3f59113YkEarTVPZ
         IqZrevdf6Ltci6xwqadOkT6qsN1GNEcT5mC9vccDhxJ7MZaXuBPajmG1WJh0EsF2JyvP
         FEWqYpOBZennugTTYdk5e2tj3Th312ORf+uLh5jYchcfcs6XZRFZ91ivjX35fZagZKOH
         5vXg==
X-Gm-Message-State: ABy/qLYRdZeqte1qnlaz3CNx7o6YxQCYAPU/cKrKSfHS+Q3hU20eHwks
	Aep4AUJHLT+FiUQm2OC8TyT3A2LTTig8RNQ=
X-Google-Smtp-Source: APBJJlFwdJ2E18U3JX8SbmAFB8eni9sLplKZ6ovLgHTWvsced2a62emZj0SesAoyMkw4Bdoxegyik2qJMVn43mc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:764f:0:b0:57a:141f:b4f5 with SMTP id
 j15-20020a81764f000000b0057a141fb4f5mr139132ywk.7.1689069408101; Tue, 11 Jul
 2023 02:56:48 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:33:03 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-10-aliceryhl@google.com>
Subject: [PATCH v3 9/9] rust: workqueue: add examples
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
v2 -> v3:
 * Use LockClassKey in constructors in examples.
 * Add Reviewed-by from Martin, Gary, Andreas, Benno.

 rust/kernel/workqueue.rs | 104 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 3a3a8b52bfd9..482d3eeae7d8 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -26,6 +26,110 @@
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
+//!             work <- Work::new(kernel::static_lock_class!()),
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
+//!             work_1 <- Work::new(kernel::static_lock_class!()),
+//!             work_2 <- Work::new(kernel::static_lock_class!()),
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
2.41.0.255.g8b1d071c50-goog

