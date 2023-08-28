Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A3411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:17 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d74711fd72eso3651427276.3
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 03:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693219757; x=1693824557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7MHrwaqRQcEpiQUM63plXyMym72xBHnTiBqMbx7wZw=;
        b=AMPWN1b/UHqT75qKL7kIoe84TxjmLd12ffSET1Hw3zrmkOFwbRpVrKJO0Cmu7vKTqw
         jfM29FhtKEndG/pyh+fyXScGgQ140AUwIHMKysjW4X30MuZL6l1pHcgbC8sMj6pGTcQg
         2Ri1T9Ff9aeccFLlJ7RFWqFTXHKVbYFBdd+Z/df0DE/2fxuDdKIYf27868XQW/VMM1TO
         zbX6u8EEd7oD6xVBxHDRTMcxMHou4uyuSZBG7YFDP7dVo5k0nGnqDwM3WA9RLTHJp56j
         4lJ4E+8lhveVrs7QXiPHz6Sord4FCuGSmK8HAEvJRIQb9QAYu1p22PwiEw3zNHdwAPIp
         DUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693219757; x=1693824557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7MHrwaqRQcEpiQUM63plXyMym72xBHnTiBqMbx7wZw=;
        b=H0Lw1iRc8iSYPkn4/YGS1lrBlkmASjmVG8Ks8Ys1PRUE6NxT6mRMDp7Z3YxRjEBcuf
         5F/OMXndj8HaLIpCy3O06yULNqvOGTP5BjHAYrGI15nWW+6gB8uJrAFU7bOZxVruySXw
         u6+v8OxlFNwkoRK1Odmqi79TyisHzL94XKEvk3tl0hUe5RKNknLS1Ivm1i9fkIRmxRDi
         +sWLGBqvfhdokJ2n5KOcIPf4hLFHvcYad5rggEfK6Vkg95zmWBEUhLeqGKFGJYsd37P0
         UF9XfkGS+EMFx9zayFN7vJI7N+YpgKfZbJ48dULTBJC0A08AJtNUirPOP5HfV+qe1rnM
         v2Lw==
X-Gm-Message-State: AOJu0Yxkt0Sz/V+rU+P1uznNghEyat8o4krca/261aSzKdjCqsVQePXk
	ei8h3jPhbey7fghGMxNG8hjEKeM4IOqUPmI=
X-Google-Smtp-Source: AGHT+IG68V4CQ3Yh0kd1RgiLluj29FsB8LO+ZlUEBBe9LgdPfKf4r19liQXmPNdRsJc4iZq4rzAmSeqTtzQT/Do=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d6c7:0:b0:d4b:df05:3500 with SMTP id
 n190-20020a25d6c7000000b00d4bdf053500mr875605ybg.11.1693219756887; Mon, 28
 Aug 2023 03:49:16 -0700 (PDT)
Date: Mon, 28 Aug 2023 10:48:06 +0000
In-Reply-To: <20230828104807.1581592-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230828104807.1581592-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230828104807.1581592-7-aliceryhl@google.com>
Subject: [PATCH v4 6/7] rust: workqueue: add `try_spawn` helper method
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
v3 -> v4:
 * Use new `new_work!` macro.

 rust/kernel/workqueue.rs | 43 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index c1334c48b96b..40ccc53f6e93 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -29,6 +29,7 @@
 //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
 
 use crate::{bindings, prelude::*, sync::Arc, sync::LockClassKey, types::Opaque};
+use alloc::alloc::AllocError;
 use alloc::boxed::Box;
 use core::marker::PhantomData;
 use core::pin::Pin;
@@ -96,6 +97,44 @@ pub fn enqueue<W, const ID: u64>(&self, w: W) -> W::EnqueueOutput
             })
         }
     }
+
+    /// Tries to spawn the given function or closure as a work item.
+    ///
+    /// This method can fail because it allocates memory to store the work item.
+    pub fn try_spawn<T: 'static + Send + FnOnce()>(&self, func: T) -> Result<(), AllocError> {
+        let init = pin_init!(ClosureWork {
+            work <- new_work!("Queue::try_spawn"),
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
@@ -365,6 +404,10 @@ unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_typ
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
2.42.0.rc1.204.g551eb34607-goog

