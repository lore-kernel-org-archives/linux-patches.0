Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2605621CC9
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:57:49 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-514abe67064so694096a12.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 06:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685627867; x=1688219867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Il50p8nZECxcQJDqUwkg/ZOtCLHgjGH7eHBvIr+OJqA=;
        b=woEEVeXRdIaNOBTuxaLQGdFXHzH0XEF+niu0dsO9UeJfo1436BCJtmE9PIaMuBm1Gw
         2TlWaCgo7du6wZP7cPNRfr2NARZW9QeUN+Kyf/Oo6lnJMqGqm6GXcV5SZ+/8/PFjwFym
         1TX75spnYLhrC7D6K6gHyZYI+3ApgUJsV3Gz/G1Oux0qwDrekdin+1Hf2uXbma6agOuy
         xQdsi5wTSib1B2vfRftoFo/X8JejRIQDj5V8tDbJ6tSX2QeWnIVyIZzqyr9/i/ur/5G1
         aC7RuAJ9WiyhVR+6T1jXJDvmY7YeW0blKboqYpu4UoLPr3c77ZS/i6p5z0Yei5sMJm8a
         WcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685627867; x=1688219867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Il50p8nZECxcQJDqUwkg/ZOtCLHgjGH7eHBvIr+OJqA=;
        b=EgYh97hvbfzK1FbIM/mid9csa5WsgFmK/rXCAw9KvGLrj1w0F8itJXajcng3rUE/F9
         F/Hu649Z3ZYKkHsVsOLQnWMbvTEbh9/OWzou7X4cYDU8XZsliGBO0CfvmgFla2oP3aj6
         exwJlkUhLFtjVTRsI/1UGD+HD5xgWOWnCP3+lMTUNglaMMN1SaOPgJ/teHlfClVxaMFh
         7H8VRkwKS8m9JUkjMKZQe1iDuXZ4OYhVN4AFAK88Tc4HBVjSd6tcqLdNjOYSSzTHlOKM
         K3Y4JdjZsAr3N4ktS6gA+u2w4IiWx0/KnhMaqP4oZPqKbZuVvSvHrzmmdOBT+K30MQev
         mlLg==
X-Gm-Message-State: AC+VfDxDNMPumc8C17wPVJzKB/e45X0h71KJDF8q40byE9LScCce4tPE
	7SquIN5ltqoSD55judmuBHCV3OTDT2jmwn0=
X-Google-Smtp-Source: ACHHUZ7WvE4QJSoGfg6HWhpos46egMoDrUulcJUiBKGiTAvmV94C08JCqmzQITaMZhMI/RA5MuReTCwzHFong84=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:ab09:0:b0:50b:c88a:f7cd with SMTP id
 s9-20020a50ab09000000b0050bc88af7cdmr2009edc.4.1685627867420; Thu, 01 Jun
 2023 06:57:47 -0700 (PDT)
Date: Thu,  1 Jun 2023 13:49:46 +0000
In-Reply-To: <20230601134946.3887870-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601134946.3887870-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601134946.3887870-9-aliceryhl@google.com>
Subject: [PATCH v2 8/8] rust: workqueue: add examples
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This adds two examples of how to use the workqueue. The first example
shows how to use it when you only have one `work_struct` field, and the
second example shows how to use it when you have multiple `work_struct`
fields.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/workqueue.rs | 104 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index c302e8b8624b..cefcf43ff40e 100644
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
+//!             work <- Work::new(),
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
+//!             work_1 <- Work::new(),
+//!             work_2 <- Work::new(),
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
 
 use crate::{bindings, prelude::*, sync::Arc, types::Opaque};
-- 
2.41.0.rc0.172.g3f132b7071-goog

