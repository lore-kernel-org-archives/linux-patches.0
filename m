Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879FB1FA0
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18F8C433CA;
	Tue, 18 Jul 2023 05:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689658115;
	bh=kbTYD/XHSLwWeaw9PdvZppJ7Vxhric46YCXiOC0rb7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpXWXHzomibZLxv1UpxZchEbd5njAUz1GR3pxZBw4eP0lOOPTJfuprkjv9Vnx8LyS
	 d5FL/iTrjuxUnwidjnNKZ9cUcNxX/b0Y1i9+tr6aARA2a1pZ4iesoQ/1mwpErfPg1Z
	 Qd34M0ydPtf4LHDgpZ2riK9LG/1BosVKFvnwhJx/Dy/3N1xVvyQJmUr2bxtalrJyIs
	 OvJShMv7iQbfmVgnljGj6YQSnEK15aKora5+xq1DVMTmUEkHf41ykTQngxzR1RuYUR
	 uguZn3i4Gb9oJqAYCtev8R0UVnlGbQgAY+yffxfXmUPFR7jLj4WgKNpzn4kgr2PsaW
	 iar/JX8uH3ndA==
From: Miguel Ojeda <ojeda@kernel.org>
To: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: [PATCH v2 4/7] rust: sync: make doctests compilable/testable
Date: Tue, 18 Jul 2023 07:27:49 +0200
Message-ID: <20230718052752.1045248-5-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>
References: <20230718052752.1045248-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rust documentation tests are going to be build/run-tested
with the KUnit integration added in a future patch, thus
update them to make them compilable/testable so that we
may start enforcing it.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/sync/arc.rs           | 9 +++++++--
 rust/kernel/sync/lock/mutex.rs    | 1 +
 rust/kernel/sync/lock/spinlock.rs | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index a89843cacaad..1ecb2efab51e 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -73,6 +73,7 @@
 /// assert_eq!(cloned.b, 20);
 ///
 /// // The refcount drops to zero when `cloned` goes out of scope, and the memory is freed.
+/// # Ok::<(), Error>(())
 /// ```
 ///
 /// Using `Arc<T>` as the type of `self`:
@@ -98,6 +99,7 @@
 /// let obj = Arc::try_new(Example { a: 10, b: 20 })?;
 /// obj.use_reference();
 /// obj.take_over();
+/// # Ok::<(), Error>(())
 /// ```
 ///
 /// Coercion from `Arc<Example>` to `Arc<dyn MyTrait>`:
@@ -121,6 +123,7 @@
 ///
 /// // `coerced` has type `Arc<dyn MyTrait>`.
 /// let coerced: Arc<dyn MyTrait> = obj;
+/// # Ok::<(), Error>(())
 /// ```
 pub struct Arc<T: ?Sized> {
     ptr: NonNull<ArcInner<T>>,
@@ -337,7 +340,7 @@ fn from(item: Pin<UniqueArc<T>>) -> Self {
 /// # Example
 ///
 /// ```
-/// use crate::sync::{Arc, ArcBorrow};
+/// use kernel::sync::{Arc, ArcBorrow};
 ///
 /// struct Example;
 ///
@@ -350,12 +353,13 @@ fn from(item: Pin<UniqueArc<T>>) -> Self {
 ///
 /// // Assert that both `obj` and `cloned` point to the same underlying object.
 /// assert!(core::ptr::eq(&*obj, &*cloned));
+/// # Ok::<(), Error>(())
 /// ```
 ///
 /// Using `ArcBorrow<T>` as the type of `self`:
 ///
 /// ```
-/// use crate::sync::{Arc, ArcBorrow};
+/// use kernel::sync::{Arc, ArcBorrow};
 ///
 /// struct Example {
 ///     a: u32,
@@ -370,6 +374,7 @@ fn from(item: Pin<UniqueArc<T>>) -> Self {
 ///
 /// let obj = Arc::try_new(Example { a: 10, b: 20 })?;
 /// obj.as_arc_borrow().use_reference();
+/// # Ok::<(), Error>(())
 /// ```
 pub struct ArcBorrow<'a, T: ?Sized + 'a> {
     inner: NonNull<ArcInner<T>>,
diff --git a/rust/kernel/sync/lock/mutex.rs b/rust/kernel/sync/lock/mutex.rs
index 923472f04af4..09276fedc091 100644
--- a/rust/kernel/sync/lock/mutex.rs
+++ b/rust/kernel/sync/lock/mutex.rs
@@ -63,6 +63,7 @@ macro_rules! new_mutex {
 /// assert_eq!(e.c, 10);
 /// assert_eq!(e.d.lock().a, 20);
 /// assert_eq!(e.d.lock().b, 30);
+/// # Ok::<(), Error>(())
 /// ```
 ///
 /// The following example shows how to use interior mutability to modify the contents of a struct
diff --git a/rust/kernel/sync/lock/spinlock.rs b/rust/kernel/sync/lock/spinlock.rs
index 979b56464a4e..91eb2c9e9123 100644
--- a/rust/kernel/sync/lock/spinlock.rs
+++ b/rust/kernel/sync/lock/spinlock.rs
@@ -61,6 +61,7 @@ macro_rules! new_spinlock {
 /// assert_eq!(e.c, 10);
 /// assert_eq!(e.d.lock().a, 20);
 /// assert_eq!(e.d.lock().b, 30);
+/// # Ok::<(), Error>(())
 /// ```
 ///
 /// The following example shows how to use interior mutability to modify the contents of a struct
-- 
2.41.0

