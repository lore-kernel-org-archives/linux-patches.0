Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3247B1EB5EE;
	Wed, 19 Mar 2025 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395136; cv=none; b=r2yv9Ywxvr5EFHMaS2Ai4tuSP7xy6UNceoBuD8hO49QSdginTRyj1WZj0oPp+vvOlu07LlddbOOKydth/4CsL1/TzjUCN/82GtHLKJnJf/I4MLVU4NfAuZdenbfehHmRvH0UHEhNurWUAc8gwyJGLc6DuaGLkN6MRsmIzjnwFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395136; c=relaxed/simple;
	bh=x4GDPEAqk5yCGjGQok1WTdX7ghpZsD2on7V/yshr2ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLGK2qOz1j57+xgvc6digNxr8p5nx+zTenJZ3zQozYBBxXMAYBkjcYDdFlA6C25GDWhn32rQ1bpFsYGbI6v4uiAYCr+YHYo4rh5RThEZM1DSBiJqsDdpDYJyB60WplkBlBUxtdwR36TZc+Uy9sLQ/9TklCQlbexkrg+UFYjBaek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkKVSb0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkKVSb0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0513EC4CEE9;
	Wed, 19 Mar 2025 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395136;
	bh=x4GDPEAqk5yCGjGQok1WTdX7ghpZsD2on7V/yshr2ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkKVSb0nOGJ9kVZwDon5tMcem/Uzgq9w993VzQECsBmND6LTm0vwbrFp2YJQ2tfOW
	 iAaRW4w5FLE3+CFDeqygxN+odCHvHZ70MdRwk03R2zfECYvWDPcqWVObX4b7Lo65Eb
	 VKIT/rW5fzXhvOOWbUR0EyjtmztEj1Nmy4V+M9e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alban Kurti <kurti@invicto.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/231] rust: init: add missing newline to pr_info! calls
Date: Wed, 19 Mar 2025 07:31:35 -0700
Message-ID: <20250319143031.834349867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d201954bd43f0..90bfb5cb26cd7 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -259,7 +259,7 @@ pub mod macros;
 ///     },
 /// }));
 /// let foo: Pin<&mut Foo> = foo;
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// ```
 ///
 /// # Syntax
@@ -311,7 +311,7 @@ macro_rules! stack_pin_init {
 ///     }, GFP_KERNEL)?,
 /// }));
 /// let foo = foo.unwrap();
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// ```
 ///
 /// ```rust,ignore
@@ -336,7 +336,7 @@ macro_rules! stack_pin_init {
 ///         x: 64,
 ///     }, GFP_KERNEL)?,
 /// }));
-/// pr_info!("a: {}", &*foo.a.lock());
+/// pr_info!("a: {}\n", &*foo.a.lock());
 /// # Ok::<_, AllocError>(())
 /// ```
 ///
@@ -866,7 +866,7 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
     ///
     /// impl Foo {
     ///     fn setup(self: Pin<&mut Self>) {
-    ///         pr_info!("Setting up foo");
+    ///         pr_info!("Setting up foo\n");
     ///     }
     /// }
     ///
@@ -970,7 +970,7 @@ pub unsafe trait Init<T: ?Sized, E = Infallible>: PinInit<T, E> {
     ///
     /// impl Foo {
     ///     fn setup(&mut self) {
-    ///         pr_info!("Setting up foo");
+    ///         pr_info!("Setting up foo\n");
     ///     }
     /// }
     ///
@@ -1318,7 +1318,7 @@ impl<T> InPlaceWrite<T> for UniqueArc<MaybeUninit<T>> {
 /// #[pinned_drop]
 /// impl PinnedDrop for Foo {
 ///     fn drop(self: Pin<&mut Self>) {
-///         pr_info!("Foo is being dropped!");
+///         pr_info!("Foo is being dropped!\n");
 ///     }
 /// }
 /// ```
diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
index 1fd146a832416..b7213962a6a5a 100644
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



