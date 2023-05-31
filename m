Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21617736
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:45:16 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso13422977276.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685555116; x=1688147116;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ixsxZNXu/M3OVZiMitemEDxPF4LdK6ucQ3Y5NhAgzBo=;
        b=HjBJ1RwOD8NBFHeZ93p5PlWWp7idk+djRZgJNBaOG+S2ZxyefEOxXiRFp1l0IH1rkd
         b0/o0lKY/7GSD04VQgECi4ljdzajwT06ogTKbJUw4jLBMDM6TJRAe/IoQVIU6Sc8veyD
         LFIZgDpz8t7kq95Gepu51pYqs6GCg1QcV8+7R+xX0BOZUdgYSoG22JYBZt9XUGqfuudp
         UGrK4Jd/9Iocz9dtvQ3xokWhzqps07uuCSMjkqLGTgOrj7Moipl6HnPHl6SjWV2PmzJT
         ED5dpjDTw3DY61odABawGqoawr39ZGrhtwIMAyVXSZba/z0es+7FyXS5slqkBXQjyoZT
         nFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685555116; x=1688147116;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ixsxZNXu/M3OVZiMitemEDxPF4LdK6ucQ3Y5NhAgzBo=;
        b=KqIpgw7tHS0hLaw9vMiaxxUDmOR+ChUOg2gt5uSS4Phh8jPdsDLXHsLIvUnmUC2cwa
         KhmgjaAemfXYfoXHXwmGpLJYT2tQl9/2kSczqOcHvK/qpwroTGHa92GuAdeGq/708hYp
         QzQemsp6CB6xv7WPEKzIujNV+KSf3u740tQPTX8KOVlPB+pxHyFaIXGBRnd/yGpr32of
         XKM9pyp0XhYi9S9ukLE4nf2ZRzfydgy5vEzBFaUI0WUaVWGylxlWyn3F1Kvf0DCC9byq
         O6u9liMMSXB5YOxlkvqGTM7KyUIuKVtmognz7lJ6SxgQLqgwgqwZKh3p0LZsWfMfCfOv
         0fIg==
X-Gm-Message-State: AC+VfDxFKemV+I2OOTQAFtN5iRIMrOZgfmfIHwYqjmhxUhsbwaBYHaKQ
	3jNUiQFDCXjdGKWFb4G6wRRzRm87mnG7QSU=
X-Google-Smtp-Source: ACHHUZ55IUaRfDCO8+rKTBtQpf8sLbbhlT/ndhaIvhehFzwS9X3QN3q38STkEwIQoSNhMK4QiwGPewfj8QtFwlQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:84d1:0:b0:ba8:3401:a466 with SMTP id
 x17-20020a2584d1000000b00ba83401a466mr2646176ybm.6.1685555116046; Wed, 31 May
 2023 10:45:16 -0700 (PDT)
Date: Wed, 31 May 2023 17:44:50 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531174450.3733220-1-aliceryhl@google.com>
Subject: [PATCH v1] rust: error: integrate Rust error type with `errname`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Sven Van Asbroeck <thesven73@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Gary Guo <gary@garyguo.net>

This integrates the `Error` type with the `errname` by making it
accessible via the `name` method or via the `Debug` trait.

Co-Developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-Developed-by: Sven Van Asbroeck <thesven73@gmail.com>
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/error.rs            | 39 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 50e7a76d5455..dc8691f83253 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -10,6 +10,7 @@
 #include <linux/refcount.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
+#include <linux/errname.h>
 
 /* `bindgen` gets confused at certain things. */
 const gfp_t BINDINGS_GFP_KERNEL = GFP_KERNEL;
diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 5f4114b30b94..59ff362028d0 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -4,12 +4,15 @@
 //!
 //! C header: [`include/uapi/asm-generic/errno-base.h`](../../../include/uapi/asm-generic/errno-base.h)
 
+use crate::str::CStr;
+
 use alloc::{
     alloc::{AllocError, LayoutError},
     collections::TryReserveError,
 };
 
 use core::convert::From;
+use core::fmt;
 use core::num::TryFromIntError;
 use core::str::Utf8Error;
 
@@ -113,6 +116,42 @@ impl Error {
         // SAFETY: self.0 is a valid error due to its invariant.
         unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
     }
+
+    /// Returns a string representing the error, if one exists.
+    #[cfg(not(testlib))]
+    pub fn name(&self) -> Option<&'static CStr> {
+        // SAFETY: Just an FFI call, there are no extra safety requirements.
+        let ptr = unsafe { bindings::errname(-self.0) };
+        if ptr.is_null() {
+            None
+        } else {
+            // SAFETY: The string returned by `errname` is static and `NUL`-terminated.
+            Some(unsafe { CStr::from_char_ptr(ptr) })
+        }
+    }
+
+    /// Returns a string representing the error, if one exists.
+    ///
+    /// When `testlib` is configured, this always returns `None` to avoid the dependency on a
+    /// kernel function so that tests that use this (e.g., by calling [`Result::unwrap`]) can still
+    /// run in userspace.
+    #[cfg(testlib)]
+    pub fn name(&self) -> Option<&'static CStr> {
+        None
+    }
+}
+
+impl fmt::Debug for Error {
+    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
+        match self.name() {
+            // Print out number if no name can be found.
+            None => f.debug_tuple("Error").field(&-self.0).finish(),
+            // SAFETY: These strings are ASCII-only.
+            Some(name) => f
+                .debug_tuple(unsafe { core::str::from_utf8_unchecked(name) })
+                .finish(),
+        }
+    }
 }
 
 impl From<AllocError> for Error {

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.41.0.rc0.172.g3f132b7071-goog

