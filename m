Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F81DEFD6;
	Wed, 19 Mar 2025 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395259; cv=none; b=TSyEppcJ4KixNfuKdbI5oOkH4xhHPYuOSmKx9Cmfx7vq/mkPy7g0ipcuZCcGe5F4zxAY3TjqddiBowvx+Gp971DG9NMGvwsB5TZHvY+emWiOzASJ2oLMkRfX47mbQKporwqYqfsZdy21/Xs+niCpH1b/9x9y3dSTOwraH8r0Qmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395259; c=relaxed/simple;
	bh=K9k7usDLl1+254KTUCB9t9IKRSjmYgGkyHPLYAYJee0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4k446QgG+TtvCueZuvbVVsIEo2r35cGdKBVj5roeRF1T7vOGPnhSiF4n+7MROEsJqLWCS/xRzvf+waXcTsnQouFOkuzDdxpCYYcvctci39EWp66COZZJDUli1xwLY5z4bCuLC22y8/sC5wD048R4sxOkhCJvOPNukmB9CwbTtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8e/vmKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8e/vmKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E6C4CEE8;
	Wed, 19 Mar 2025 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395259;
	bh=K9k7usDLl1+254KTUCB9t9IKRSjmYgGkyHPLYAYJee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8e/vmKLZHefqhSNDn5VAyYjPGRxzLR+zEz19mgvgeI9FcS6QZRS+5dybM226KkUH
	 rkGVebpQG5rUEy+9Xi2tKeiZYzDEocssxuhGc5fa/uNJhD6vui4YQET6WNQT6pQR9j
	 27scBSel8vjiXsI5CwXMGZtvpm/YaRmLsCKYiBtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alban Kurti <kurti@invicto.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/166] rust: init: add missing newline to pr_info! calls
Date: Wed, 19 Mar 2025 07:31:54 -0700
Message-ID: <20250319143023.894074988@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Kurti <kurti@invicto.ai>

[ Upstream commit 6933c1067fe6df8ddb34dd68bdb2aa172cbd08c8 ]

Several pr_info! calls in rust/kernel/init.rs (both in code examples
and macro documentation) were missing a newline, causing logs to
run together. This commit updates these calls to include a trailing
newline, improving readability and consistency with the C side.

Fixes: 6841d45a3030 ("rust: init: add `stack_pin_init!` macro")
Fixes: 7f8977a7fe6d ("rust: init: add `{pin_}chain` functions to `{Pin}Init<T, E>`")
Fixes: d0fdc3961270 ("rust: init: add `PinnedDrop` trait and macros")
Fixes: 4af84c6a85c6 ("rust: init: update expanded macro explanation")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1139
Signed-off-by: Alban Kurti <kurti@invicto.ai>
Link: https://lore.kernel.org/r/20250206-printing_fix-v3-3-a85273b501ae@invicto.ai
[ Replaced Closes with Link since it fixes part of the issue. Added
  one more Fixes tag (still same set of stable kernels). - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/init.rs        | 12 ++++++------
 rust/kernel/init/macros.rs |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 6ef9f61820184..af1c77cc12b28 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -258,7 +258,7 @@ pub mod macros;
 ///     },
 /// }));
 /// let foo: Pin<&mut Foo> = foo;
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// ```
 ///
 /// # Syntax
@@ -310,7 +310,7 @@ macro_rules! stack_pin_init {
 ///     })?,
 /// }));
 /// let foo = foo.unwrap();
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// ```
 ///
 /// ```rust,ignore
@@ -335,7 +335,7 @@ macro_rules! stack_pin_init {
 ///         x: 64,
 ///     })?,
 /// }));
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// # Ok::<_, AllocError>(())
 /// ```
 ///
@@ -800,7 +800,7 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
     ///
     /// impl Foo {
     ///     fn setup(self: Pin<&mut Self>) {
-    ///         pr_info!("Setting up foo");
+    ///         pr_info!("Setting up foo\n");
     ///     }
     /// }
     ///
@@ -906,7 +906,7 @@ pub unsafe trait Init<T: ?Sized, E = Infallible>: PinInit<T, E> {
     ///
     /// impl Foo {
     ///     fn setup(&mut self) {
-    ///         pr_info!("Setting up foo");
+    ///         pr_info!("Setting up foo\n");
     ///     }
     /// }
     ///
@@ -1229,7 +1229,7 @@ impl<T> InPlaceInit<T> for UniqueArc<T> {
 /// #[pinned_drop]
 /// impl PinnedDrop for Foo {
 ///     fn drop(self: Pin<&mut Self>) {
-///         pr_info!("Foo is being dropped!");
+///         pr_info!("Foo is being dropped!\n");
 ///     }
 /// }
 /// ```
diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
index cb6e61b6c50bd..cb769a09e7426 100644
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -45,7 +45,7 @@
 //! #[pinned_drop]
 //! impl PinnedDrop for Foo {
 //!     fn drop(self: Pin<&mut Self>) {
-//!         pr_info!("{self:p} is getting dropped.");
+//!         pr_info!("{self:p} is getting dropped.\n");
 //!     }
 //! }
 //!
@@ -412,7 +412,7 @@
 //! #[pinned_drop]
 //! impl PinnedDrop for Foo {
 //!     fn drop(self: Pin<&mut Self>) {
-//!         pr_info!("{self:p} is getting dropped.");
+//!         pr_info!("{self:p} is getting dropped.\n");
 //!     }
 //! }
 //! ```
@@ -423,7 +423,7 @@
 //! // `unsafe`, full path and the token parameter are added, everything else stays the same.
 //! unsafe impl ::kernel::init::PinnedDrop for Foo {
 //!     fn drop(self: Pin<&mut Self>, _: ::kernel::init::__internal::OnlyCallFromDrop) {
-//!         pr_info!("{self:p} is getting dropped.");
+//!         pr_info!("{self:p} is getting dropped.\n");
 //!     }
 //! }
 //! ```
-- 
2.39.5



