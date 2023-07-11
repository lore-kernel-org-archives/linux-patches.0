Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AC174E5
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:51:42 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-51bee352ffcso3598140a12.1
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689069101; x=1691661101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zbG7B9nIgqjfOv4qsNLCa5ebcFdm5P+XcawO//zctYU=;
        b=7Xc/ddVUS0wM3GZO2B4AprynVg9zdVzLcyIeszTINkZEhMbnLLiUtLRsb31FPVbX+v
         reQxDAqLJm+3phY6MBudaf4zuQd3YTfi3efTF+dNuZZPIMi/HvDNP4c9t15xV+K4FS8g
         bPzRHP1jHv7jqqPKvzwHsdoUsaCbRef/eh2j0FzqjsqyDcUO58KAGbPPrzd6DCPoqkZq
         L96g8upUP6Gt22M0M29/DcrWSC4naOOb1Png3Bexwc5Jat8/ZKWqUtvKMqIktDrjeDB7
         3pMGuxOJDNc9X/dC13LsiOoPu86DyMohr6aEJhuJwhn+ud67Cv5yGn7RgjgL3hmjY1NS
         dCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689069101; x=1691661101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zbG7B9nIgqjfOv4qsNLCa5ebcFdm5P+XcawO//zctYU=;
        b=JgK5UTp9l1FHTQcE4oLv2MS7D51OFtBQalqTI3RCiDyucycHavwGKp30du3vOQ8dIn
         8Z8SY1+aHgwmU2mIKIHlcB8ctDjmtZySF9oMiiyiy8K7IQgmSh/HbJl3bAh6G5blACRD
         R4JloUszqSTQ/FH/UXX9bxV9rrHLqwKzMUf0KWZouZ1Aqb2RImltbtnnV5n0szjXMzck
         XIt+eFzhtFO8UTHl84MdeJrC4Z4DCJBYZ60vRY1fO4XHwC0PU0x+kwWkIoiRbS5PoCd3
         hQfp94O7n5a8JzjTtwzlFl6AzExssf492Wgjbx+hNUeS0S65Gd0iFsefu4PxdX23v9/+
         5fdQ==
X-Gm-Message-State: ABy/qLbwfqDa0HO2HvdCeP3GvEK5Ap24+NMT0bKfhpxGX9uwMn3qp9ek
	7E6IgtyF6fFj3mCSXCksVBakEt2BLjWchcI=
X-Google-Smtp-Source: APBJJlE4smX4x/n67nbfyh8iudWSD9Gcs4zDhbXl2mIlHlCvPXFVOvfDZHgJiam+NfqpPVdh/Liaa42mYVELhI4=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cd0f:0:b0:51b:e4c5:547c with SMTP id
 z15-20020a50cd0f000000b0051be4c5547cmr79456edi.4.1689069100681; Tue, 11 Jul
 2023 02:51:40 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:33:02 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-9-aliceryhl@google.com>
Subject: [PATCH v3 8/9] rust: workqueue: add `try_spawn` helper method
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

This adds a convenience method that lets you spawn a closure for
execution on a workqueue. This will be the most convenient way to use
workqueues, but it is fallible because it needs to allocate memory.

Co-developed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Andreas Hindborg (Samsung) <nmi@metaspace.dk>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
v2 -> v3:
 * Use a LockClassKey when constructing `ClosureWork`.
 * Add Reviewed-by from Martin, Andreas, Benno.

 rust/kernel/workqueue.rs | 43 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index e760040762bd..3a3a8b52bfd9 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -29,6 +29,7 @@
 //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
 
 use crate::{bindings, prelude::*, sync::Arc, sync::LockClassKey, types::Opaque};
+use alloc::alloc::AllocError;
 use alloc::boxed::Box;
 use core::marker::PhantomData;
 use core::pin::Pin;
@@ -87,6 +88,44 @@ pub fn enqueue<W, const ID: u64>(&self, w: W) -> W::EnqueueOutput
             })
         }
     }
+
+    /// Tries to spawn the given function or closure as a work item.
+    ///
+    /// This method can fail because it allocates memory to store the work item.
+    pub fn try_spawn<T: 'static + Send + FnOnce()>(&self, func: T) -> Result<(), AllocError> {
+        let init = pin_init!(ClosureWork {
+            work <- Work::new(kernel::static_lock_class!()),
+            func: Some(func),
+        });
+
+        self.enqueue(Box::pin_init(init).map_err(|_| AllocError)?);
+        Ok(())
+    }
+}
+
+/// A helper type used in `try_spawn`.
+#[pin_data]
+struct ClosureWork<T> {
+    #[pin]
+    work: Work<ClosureWork<T>>,
+    func: Option<T>,
+}
+
+impl<T> ClosureWork<T> {
+    fn project(self: Pin<&mut Self>) -> &mut Option<T> {
+        // SAFETY: The `func` field is not structurally pinned.
+        unsafe { &mut self.get_unchecked_mut().func }
+    }
+}
+
+impl<T: FnOnce()> WorkItem for ClosureWork<T> {
+    type Pointer = Pin<Box<Self>>;
+
+    fn run(mut this: Pin<Box<Self>>) {
+        if let Some(func) = this.as_mut().project().take() {
+            (func)()
+        }
+    }
 }
 
 /// A raw work item.
@@ -347,6 +386,10 @@ unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_typ
     )*};
 }
 
+impl_has_work! {
+    impl<T> HasWork<Self> for ClosureWork<T> { self.work }
+}
+
 unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
 where
     T: WorkItem<ID, Pointer = Self>,
-- 
2.41.0.255.g8b1d071c50-goog

