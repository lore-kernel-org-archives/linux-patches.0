Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DEC18B03
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 15:28:48 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57704af0e64so8656707b3.0
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 08:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689866927; x=1690471727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQBUPgxHkhflJuYPJ1CvCZCjp5mdRng6N97hOUv3RDI=;
        b=umjfMOmncgfgLKwMNiEIs8577emiyzixkvve2v76Ldzq9BfJ2Gsva1zZuV7MmD+zEm
         V73fo4vHJKN3JL0aZkO4wToR1GGZI6zAUng+M3D7w8R7KOD5DI5XFt33icbHulyHxvhl
         D5+UKe8+wLNlI3Y0OlBtcRaD9X/Oh4SoHkKCK5pTRUk6deSnW5vy3T1AIqtzp6PAXLY5
         Dlwwx0Wxi+sgy88xAvX+Vq1+H+9JH46daacQaxG5vBeKlL61m/L52VErUYkIIgC/iY1p
         UgL6blkD2v7rwH7l2W/hozK4eWoRgzOMEkTe1YkafDUYMyaQvNAIvZ9dR7lwzd+z0uDI
         kQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689866927; x=1690471727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQBUPgxHkhflJuYPJ1CvCZCjp5mdRng6N97hOUv3RDI=;
        b=L6SIXQlZgOkcFCirjctijU97x+GNajQR1ilchnNxwh1w/SYuY5mvfUn1xT+2xt+oFC
         D3rGrfcoflt4fMuxk7cvSbn2MT0CWyqCsAfpJW9gD0meeOCaZ4ttrE1mWt3AA/D5lufV
         tWz3i45slMVwrjIuBT/DBJWnWaAhAIGd9198Yi/ts2Vpi9sjRQElZW9igb7h4s3liw/P
         1G4q8wUkTDOMAy/8rO7G78BbM7W78a6VQLgrdEhI32IE/iJMuQqz1pwBGRSECn0xKvKj
         Z55twI7bw2NlMBa4f1g9TyhDUJ1hgUTQMwdMPsG57IjYgcyq+CUv4qDypNhiQiv56alJ
         Y5wA==
X-Gm-Message-State: ABy/qLaw2ZsjW9IP8gwfhjLQ2usZBMTClzqNIqwHwFlYJakPgsUxwss4
	zd4t7CXEKgqXnz5Z0N3SO2/g36ynORX1DZU=
X-Google-Smtp-Source: APBJJlHVd3IS4h3/Z8+ztRjFttwDDD2vfU5J2lXiiefal1S5tDdZhnFP6jIvagOyWXs0jg7XbB3rIbKvJmNJOGM=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:ac4c:0:b0:57a:141f:b4f5 with SMTP id
 z12-20020a81ac4c000000b0057a141fb4f5mr61560ywj.7.1689866927507; Thu, 20 Jul
 2023 08:28:47 -0700 (PDT)
Date: Thu, 20 Jul 2023 15:28:17 +0000
In-Reply-To: <20230720152820.3566078-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230720152820.3566078-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230720152820.3566078-3-aliceryhl@google.com>
Subject: [RFC PATCH v1 2/5] rust: cred: add Rust bindings for `struct cred`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

Make it possible to access credentials from Rust drivers. In particular,
this patch makes it possible to get the id for the security context of a
given file.

Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/bindings/bindings_helper.h |  2 +
 rust/helpers.c                  | 22 +++++++++++
 rust/kernel/cred.rs             | 66 +++++++++++++++++++++++++++++++++
 rust/kernel/file.rs             | 15 ++++++++
 rust/kernel/lib.rs              |  1 +
 5 files changed, 106 insertions(+)
 create mode 100644 rust/kernel/cred.rs

diff --git a/rust/kernel/cred.rs b/rust/kernel/cred.rs
new file mode 100644
index 000000000000..ca3fac4851a2
--- /dev/null
+++ b/rust/kernel/cred.rs
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Credentials management.
+//!
+//! C header: [`include/linux/cred.h`](../../../../include/linux/cred.h)
+//!
+//! Reference: <https://www.kernel.org/doc/html/latest/security/credentials.html>
+
+use crate::{
+    bindings,
+    types::{AlwaysRefCounted, Opaque},
+};
+
+/// Wraps the kernel's `struct cred`.
+///
+/// # Invariants
+///
+/// Instances of this type are always ref-counted, that is, a call to `get_cred` ensures that the
+/// allocation remains valid at least until the matching call to `put_cred`.
+#[repr(transparent)]
+pub struct Credential(pub(crate) Opaque<bindings::cred>);
+
+// SAFETY: By design, the only way to access a `Credential` is via an immutable reference or an
+// `ARef`. This means that the only situation in which a `Credential` can be accessed mutably is
+// when the refcount drops to zero and the destructor runs. It is safe for that to happen on any
+// thread, so it is ok for this type to be `Send`.
+unsafe impl Send for Credential {}
+
+// SAFETY: It's OK to access `Credential` through shared references from other threads because
+// we're either accessing properties that don't change or that are properly synchronised by C code.
+unsafe impl Sync for Credential {}
+
+impl Credential {
+    /// Creates a reference to a [`Credential`] from a valid pointer.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `ptr` is valid and remains valid for the lifetime of the
+    /// returned [`Credential`] reference.
+    pub unsafe fn from_ptr<'a>(ptr: *const bindings::cred) -> &'a Credential {
+        // SAFETY: The safety requirements guarantee the validity of the dereference, while the
+        // `Credential` type being transparent makes the cast ok.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Get the id for this security context.
+    pub fn get_secid(&self) -> u32 {
+        let mut secid = 0;
+        // SAFETY: The invariants of this type ensures that the pointer is valid.
+        unsafe { bindings::security_cred_getsecid(self.0.get(), &mut secid) };
+        secid
+    }
+}
+
+// SAFETY: The type invariants guarantee that `Credential` is always ref-counted.
+unsafe impl AlwaysRefCounted for Credential {
+    fn inc_ref(&self) {
+        // SAFETY: The existence of a shared reference means that the refcount is nonzero.
+        unsafe { bindings::get_cred(self.0.get()) };
+    }
+
+    unsafe fn dec_ref(obj: core::ptr::NonNull<Self>) {
+        // SAFETY: The safety requirements guarantee that the refcount is nonzero.
+        unsafe { bindings::put_cred(obj.cast().as_ptr()) };
+    }
+}
diff --git a/rust/kernel/file.rs b/rust/kernel/file.rs
index 99657adf2472..d379ae2906d9 100644
--- a/rust/kernel/file.rs
+++ b/rust/kernel/file.rs
@@ -7,6 +7,7 @@
 
 use crate::{
     bindings,
+    cred::Credential,
     error::{code::*, Error, Result},
     types::{ARef, AlwaysRefCounted, Opaque},
 };
@@ -138,6 +139,20 @@ pub unsafe fn from_ptr<'a>(ptr: *const bindings::file) -> &'a File {
         unsafe { &*ptr.cast() }
     }
 
+    /// Returns the credentials of the task that originally opened the file.
+    pub fn cred(&self) -> &Credential {
+        // SAFETY: The file is valid because the shared reference guarantees a nonzero refcount.
+        //
+        // This uses a volatile read because C code may be modifying this field in parallel using
+        // non-atomic unsynchronized writes. This corresponds to how the C macro READ_ONCE is
+        // implemented.
+        let ptr = unsafe { core::ptr::addr_of!((*self.0.get()).f_cred).read_volatile() };
+        // SAFETY: The lifetimes of `self` and `Credential` are tied, so it is guaranteed that
+        // the credential pointer remains valid (because the file is still alive, and it doesn't
+        // change over the lifetime of a file).
+        unsafe { Credential::from_ptr(ptr) }
+    }
+
     /// Returns the flags associated with the file.
     ///
     /// The flags are a combination of the constants in [`flags`].
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 650bfffc1e6f..07258bfa8960 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -31,6 +31,7 @@
 #[cfg(not(testlib))]
 mod allocator;
 mod build_assert;
+pub mod cred;
 pub mod error;
 pub mod file;
 pub mod init;
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index c5b2cfd02bac..d89f0df93615 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -6,9 +6,11 @@
  * Sorted alphabetically.
  */
 
+#include <linux/cred.h>
 #include <linux/errname.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
 #include <linux/wait.h>
diff --git a/rust/helpers.c b/rust/helpers.c
index 072f7ef80ea5..e13a7da430b1 100644
--- a/rust/helpers.c
+++ b/rust/helpers.c
@@ -22,12 +22,14 @@
 
 #include <linux/bug.h>
 #include <linux/build_bug.h>
+#include <linux/cred.h>
 #include <linux/err.h>
 #include <linux/errname.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/refcount.h>
 #include <linux/sched/signal.h>
+#include <linux/security.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 
@@ -144,6 +146,26 @@ struct file *rust_helper_get_file(struct file *f)
 }
 EXPORT_SYMBOL_GPL(rust_helper_get_file);
 
+const struct cred *rust_helper_get_cred(const struct cred *cred)
+{
+	return get_cred(cred);
+}
+EXPORT_SYMBOL_GPL(rust_helper_get_cred);
+
+void rust_helper_put_cred(const struct cred *cred)
+{
+	put_cred(cred);
+}
+EXPORT_SYMBOL_GPL(rust_helper_put_cred);
+
+#ifndef CONFIG_SECURITY
+void rust_helper_security_cred_getsecid(const struct cred *c, u32 *secid)
+{
+	security_cred_getsecid(c, secid);
+}
+EXPORT_SYMBOL_GPL(rust_helper_security_cred_getsecid);
+#endif
+
 /*
  * We use `bindgen`'s `--size_t-is-usize` option to bind the C `size_t` type
  * as the Rust `usize` type, so we can use it in contexts where Rust
-- 
2.41.0.255.g8b1d071c50-goog

