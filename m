Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047321079
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:53:18 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba802c775caso1315719276.2
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685627597; x=1688219597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=emM0vnYZP8ovSB9/0L28X7xu1W1tC2o+UTrpcckUn6I=;
        b=xiQpeTApD8EOPRLGvqOEbGnwk5VdgbS481DnQDIEFxEdsz/On6iBdKRYTdwC4GSgKB
         ph6LBgaidNw+WGSeSHFktPPsUZz32+fyRaDVJAIFfZN/e98wVfiftPu+6Uks3ZrG/Wbm
         qYQSoWdlUuUSFuYtP5XYH42+XrgljkWS1ibSt+8a48D1yXNfxUsbCgVXQcRA1QlmnIjo
         DJdJK+53Kf/Rf7wXCzRaWFXdwIBLvTbOxI3Iofy7tLQ5FmIGaCokuy9i65leoDsK3Jb1
         vHup+pJUEoS+DZOCrHTg5fJDr1NpU8/R+Ig1RUYXj7GDgRTXdO1bvBdOXfCNqJXcUIMb
         lzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685627597; x=1688219597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=emM0vnYZP8ovSB9/0L28X7xu1W1tC2o+UTrpcckUn6I=;
        b=TU12Qmwtn25FPM1YArlr/CKLUNEoEOnXqGMACiSI2Gx48HKSc6lA9GXZknTI6QzhiQ
         LErWj5lGyntRGgkLm+eMGWDH8pmEsqOOw8QoIwKj4yw34hbBRtjuqTFxHnqWJzvDFyn1
         exzYhiUGqAUUEMuEhtJV780+SvkO6TEQZFHAJ1niSM2O6SObQ7OtvnLUF/9HDEBFJrp3
         gGyNZs0OJJOE/SOD3/li3pYNoCKObsS9QknT3di4kJREzitpaJTKjiwAPKnPxOZdeyBX
         vVKYuagLc8kRMnUOsYwpR4EErQ2JaLA3lE8tFyRAcLpVR8zeJoTD+gLAFApJ1kdZVkkw
         8kSQ==
X-Gm-Message-State: AC+VfDwrn/qcvfEXUIF5ofM9EIhTsv5NCeu6ZD2laWUJoXbF55piJmAq
	0zIqCTp+Nv5cEkJ6DO12KDOi7RXczBVRxWs=
X-Google-Smtp-Source: ACHHUZ6D9pKmfatjre8+3n+W1GuZF8ZhsQLF+BiTz9FLkUqyRuqeWMNbDcq1x6MUBFd9q5UdZjwDyQhhHBy0eaU=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:a8e:b0:b1d:5061:98e3 with SMTP
 id cd14-20020a0569020a8e00b00b1d506198e3mr5275183ybb.6.1685627597196; Thu, 01
 Jun 2023 06:53:17 -0700 (PDT)
Date: Thu,  1 Jun 2023 13:49:41 +0000
In-Reply-To: <20230601134946.3887870-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601134946.3887870-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601134946.3887870-4-aliceryhl@google.com>
Subject: [PATCH v2 3/8] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

These methods can be used to turn an `Arc` into a raw pointer and back,
in a way that preserves the metadata for fat pointers.

This is done using the unstable ptr_metadata feature [1]. However, it
could also be done using the unstable pointer_byte_offsets feature [2],
which is likely to have a shorter path to stabilization than
ptr_metadata.

Link: https://github.com/rust-lang/rust/issues/81513 [1]
Link: https://github.com/rust-lang/rust/issues/96283 [2]
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
---
 rust/kernel/lib.rs      |  1 +
 rust/kernel/sync/arc.rs | 42 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 7ea777b731e6..ad9142928fb1 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -17,6 +17,7 @@
 #![feature(const_refs_to_cell)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
+#![feature(ptr_metadata)]
 #![feature(receiver_trait)]
 #![feature(unsize)]
 
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index a89843cacaad..684be9f73aca 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -24,7 +24,7 @@
 };
 use alloc::boxed::Box;
 use core::{
-    alloc::AllocError,
+    alloc::{AllocError, Layout},
     fmt,
     marker::{PhantomData, Unsize},
     mem::{ManuallyDrop, MaybeUninit},
@@ -212,6 +212,46 @@ unsafe fn from_inner(inner: NonNull<ArcInner<T>>) -> Self {
         }
     }
 
+    /// Convert the [`Arc`] into a raw pointer.
+    ///
+    /// The raw pointer has ownership of the refcount that this Arc object owned.
+    pub fn into_raw(self) -> *const T {
+        let ptr = self.ptr.as_ptr();
+        core::mem::forget(self);
+        // SAFETY: The pointer is valid.
+        unsafe { core::ptr::addr_of!((*ptr).data) }
+    }
+
+    /// Recreates an [`Arc`] instance previously deconstructed via [`Arc::into_raw`].
+    ///
+    /// This code relies on the `repr(C)` layout of structs as described in
+    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
+    /// can only be called once for each previous call to [`Arc::into_raw`].
+    pub unsafe fn from_raw(ptr: *const T) -> Self {
+        let refcount_layout = Layout::new::<bindings::refcount_t>();
+        // SAFETY: The caller guarantees that the pointer is valid.
+        let val_layout = unsafe { Layout::for_value(&*ptr) };
+        // SAFETY: We're computing the layout of a real struct that existed when compiling this
+        // binary, so its layout is not so large that it can trigger arithmetic overflow.
+        let val_offset = unsafe { refcount_layout.extend(val_layout).unwrap_unchecked().1 };
+
+        // This preserves the metadata in the pointer, if any.
+        //
+        // Note that `*const T` and `*const ArcInner<T>` have the same metadata as documented at
+        // <https://doc.rust-lang.org/std/ptr/trait.Pointee.html>.
+        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);
+        let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
+        let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);
+
+        // SAFETY: By the safety requirements we know that `ptr` came from `Arc::into_raw`, so the
+        // reference count held then will be owned by the new `Arc` object.
+        unsafe { Self::from_inner(NonNull::new_unchecked(ptr)) }
+    }
+
     /// Returns an [`ArcBorrow`] from the given [`Arc`].
     ///
     /// This is useful when the argument of a function call is an [`ArcBorrow`] (e.g., in a method
-- 
2.41.0.rc0.172.g3f132b7071-goog

