Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC4D174E5
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:49:31 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c5cea5773e8so6670900276.1
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068970; x=1691660970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EqMekonA8uGHFD/lDqj3wOWtQfGKVNTfQouXEykc8E=;
        b=IhDUOhT0+DvvMgAAceahZcV7aUb3Zv9bWU0qe0g6pEouMuHOgruEFQzK3tcCGz0fY0
         dNS22UXL6tq2hBKNniRASmkbPF+d7fQXIRahB/BzW81ZQx4nJ09+2qAuZc7MquRblvcu
         B16dRYK5dohuej1KyH+5cySONL8YFRLl1Q4FqpPX0X8h3AiNYRFM0VgPDnlAdkr4qpm/
         aO71pzpqHLppLt/f+32LBAs2DjfHYu5qKmdBH+7BtfMChJq6jooxLy9I1mphNkfG77LK
         IxnqMigeSRhV5KTLFgtb17TR6635l4Rc3+dg1lFsZhZiQHhaTjpgXH3XCCbgqJ6YFuCn
         pqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068970; x=1691660970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EqMekonA8uGHFD/lDqj3wOWtQfGKVNTfQouXEykc8E=;
        b=XVUbZMBuEs58Cv+KJJYmAUW7sdAW0FbOMQG4PRhirMLY60lQEvD8MC4uvvJ+q8vSvC
         4m6i9XTZeE7FFcZXneh8zi/s+Tg4BwTDM1UQpu4KVMUMxj3E9HU/B+K35FgmKkgnfcBp
         OZHxVGLTdxIwaxXvRWT35jwIpaVQMYEDcDD6L1dE6OOMdWHFvfyLy/eV4NoDrzW0IOjb
         sCfTvB61rZMPvtShPFGi22jUXAU6yzzKRw8yeoMCU47FhDYqpLrGSzNGktY3WOt3IYVK
         96uU2ZMcJVJk7G75irxvp52s/2i5IHJnx2uiD14Nl2MRWPNfNpFq8bnewQzbKRRECJMd
         tY8w==
X-Gm-Message-State: ABy/qLbSvXn7EuNs6+satDJdgkLmcqR8IOg9138tdkVHXnseyoT3tCgU
	HMAFmNAj6trd5bWL6haWdaDkmM4iFVAsQBM=
X-Google-Smtp-Source: APBJJlHEHcRVDUW4+Y0GUJSVpFZcA3B0pSPwgs7AJhZbg/V8hUXtvAnY3gg+gxzZTCY2shizts2jw+x1sE8BMX0=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:cd09:0:b0:c6c:6122:5b69 with SMTP id
 d9-20020a25cd09000000b00c6c61225b69mr107979ybf.8.1689068970724; Tue, 11 Jul
 2023 02:49:30 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:33:01 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-8-aliceryhl@google.com>
Subject: [PATCH v3 7/9] rust: workqueue: implement `WorkItemPointer` for
 pointer types
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

This implements the `WorkItemPointer` trait for the pointer types that
you are likely to use the workqueue with. The `Arc` type is for
reference counted objects, and the `Pin<Box<T>>` type is for objects
where the caller has exclusive ownership of the object.

Co-developed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Andreas Hindborg (Samsung) <nmi@metaspace.dk>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
v2 -> v3:
 * Use `cast_mut` to cast pointer in `impl RawWorkItem for Arc`
 * Add Reviewed-by from Martin, Andreas, Benno.

 rust/kernel/workqueue.rs | 97 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index a7c972bda0ed..e760040762bd 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -28,8 +28,10 @@
 //!
 //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
 
-use crate::{bindings, prelude::*, sync::LockClassKey, types::Opaque};
+use crate::{bindings, prelude::*, sync::Arc, sync::LockClassKey, types::Opaque};
+use alloc::boxed::Box;
 use core::marker::PhantomData;
+use core::pin::Pin;
 
 /// A kernel work queue.
 ///
@@ -345,6 +347,99 @@ unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_typ
     )*};
 }
 
+unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
+where
+    T: WorkItem<ID, Pointer = Self>,
+    T: HasWork<T, ID>,
+{
+    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
+        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        let ptr = ptr as *mut Work<T, ID>;
+        // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+        let ptr = unsafe { T::work_container_of(ptr) };
+        // SAFETY: This pointer comes from `Arc::into_raw` and we've been given back ownership.
+        let arc = unsafe { Arc::from_raw(ptr) };
+
+        T::run(arc)
+    }
+}
+
+unsafe impl<T, const ID: u64> RawWorkItem<ID> for Arc<T>
+where
+    T: WorkItem<ID, Pointer = Self>,
+    T: HasWork<T, ID>,
+{
+    type EnqueueOutput = Result<(), Self>;
+
+    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool,
+    {
+        // Casting between const and mut is not a problem as long as the pointer is a raw pointer.
+        let ptr = Arc::into_raw(self).cast_mut();
+
+        // SAFETY: Pointers into an `Arc` point at a valid value.
+        let work_ptr = unsafe { T::raw_get_work(ptr) };
+        // SAFETY: `raw_get_work` returns a pointer to a valid value.
+        let work_ptr = unsafe { Work::raw_get(work_ptr) };
+
+        if queue_work_on(work_ptr) {
+            Ok(())
+        } else {
+            // SAFETY: The work queue has not taken ownership of the pointer.
+            Err(unsafe { Arc::from_raw(ptr) })
+        }
+    }
+}
+
+unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<Box<T>>
+where
+    T: WorkItem<ID, Pointer = Self>,
+    T: HasWork<T, ID>,
+{
+    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
+        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        let ptr = ptr as *mut Work<T, ID>;
+        // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+        let ptr = unsafe { T::work_container_of(ptr) };
+        // SAFETY: This pointer comes from `Arc::into_raw` and we've been given back ownership.
+        let boxed = unsafe { Box::from_raw(ptr) };
+        // SAFETY: The box was already pinned when it was enqueued.
+        let pinned = unsafe { Pin::new_unchecked(boxed) };
+
+        T::run(pinned)
+    }
+}
+
+unsafe impl<T, const ID: u64> RawWorkItem<ID> for Pin<Box<T>>
+where
+    T: WorkItem<ID, Pointer = Self>,
+    T: HasWork<T, ID>,
+{
+    type EnqueueOutput = ();
+
+    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool,
+    {
+        // SAFETY: We're not going to move `self` or any of its fields, so its okay to temporarily
+        // remove the `Pin` wrapper.
+        let boxed = unsafe { Pin::into_inner_unchecked(self) };
+        let ptr = Box::into_raw(boxed);
+
+        // SAFETY: Pointers into a `Box` point at a valid value.
+        let work_ptr = unsafe { T::raw_get_work(ptr) };
+        // SAFETY: `raw_get_work` returns a pointer to a valid value.
+        let work_ptr = unsafe { Work::raw_get(work_ptr) };
+
+        if !queue_work_on(work_ptr) {
+            // SAFETY: This method requires exclusive ownership of the box, so it cannot be in a
+            // workqueue.
+            unsafe { ::core::hint::unreachable_unchecked() }
+        }
+    }
+}
+
 /// Returns the system work queue (`system_wq`).
 ///
 /// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU multi-threaded. There are
-- 
2.41.0.255.g8b1d071c50-goog

