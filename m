Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B12505BD;
	Mon,  3 Mar 2025 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021848; cv=none; b=nWshctLYODlvswOAi3GysyQWNr0O/zcXusxklJ6uOn3I/jyXx1lamCv7oRVCTACD+htj253TAQT/xZ33VCAAmJ+iDyJQl/YMAuBzV8p/Ztp8jDuvboAF+v10Q3pMVT7toy83OM8egEayAhL4ZNjfK/EEvhs5poq/fRj5vW/pHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021848; c=relaxed/simple;
	bh=5Kdi1+i5loqwY0ml8dmNdGirIwYOZwACywcQEByZK8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tFiMUugh/rm0HKhFZfq+TX016oUunKo3WMkTEWMUSV7Hm3oLbZG5a1wuO4hB4OYq/jnszj+3ye6X3T6CliPRiGK6J1jF0G8UeyNiXsF2ThX+ngsKi3+c+D4CuAhEOg/BG7XSaKhaxlx9eob9y6ENRUaJc8E7mZIkU2pECXjnNNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9FujtbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9FujtbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62116C4CED6;
	Mon,  3 Mar 2025 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741021847;
	bh=5Kdi1+i5loqwY0ml8dmNdGirIwYOZwACywcQEByZK8g=;
	h=From:To:Cc:Subject:Date:From;
	b=u9FujtbMiOLOlkssx81AVx0jqri7xyHoDGYx7BDyIu96oTt2zLum7D4xNzPFeVwvU
	 S6LAYMrJVSeB2Qjo/QXHJA1TCdQI9lmSrKshegBAOUXn/i4JnAhUqG60kqTaFhrCWl
	 OiZQ2K3acZGKmyfGp9A1MIMP0LkePelGeZNuL1aEIeWtKZMhGGlIUpJFwYbgBLmd2B
	 QSWxEJFU1ddOoVwQLdaoYeQWEFJ8WHsf3/5E/0ANg0TY1so0x2d1vz8gUGyGvwKhCw
	 fuQo6XpCBVMyI2r9K2Nx5ObQ3TyUtYuOaAdZfCxAFKjQi8IGWRgexF4kC2QyRXsrid
	 lADXrYjLvhmHw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] rust: remove leftover mentions of the `alloc` crate
Date: Mon,  3 Mar 2025 18:10:30 +0100
Message-ID: <20250303171030.1081134-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and
`GlobalAlloc`") we stopped using the upstream `alloc` crate.

Thus remove a few leftover mentions treewide.

Cc: stable@vger.kernel.org # Also to 6.12.y after the `alloc` backport lands
Fixes: 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and `GlobalAlloc`")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 2 +-
 rust/kernel/lib.rs                 | 2 +-
 scripts/rustdoc_test_gen.rs        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 4aa50e5fcb8c..6d2607870ba4 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -145,7 +145,7 @@ Rust standard library source
 ****************************
 
 The Rust standard library source is required because the build system will
-cross-compile ``core`` and ``alloc``.
+cross-compile ``core``.
 
 If ``rustup`` is being used, run::
 
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 398242f92a96..7697c60b2d1a 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -6,7 +6,7 @@
 //! usage by Rust code in the kernel and is shared by all of them.
 //!
 //! In other words, all the rest of the Rust code in the kernel (e.g. kernel
-//! modules written in Rust) depends on [`core`], [`alloc`] and this crate.
+//! modules written in Rust) depends on [`core`] and this crate.
 //!
 //! If you need a kernel C API that is not ported or wrapped yet here, then
 //! do so first instead of bypassing this crate.
diff --git a/scripts/rustdoc_test_gen.rs b/scripts/rustdoc_test_gen.rs
index 5ebd42ae4a3f..76aaa8329413 100644
--- a/scripts/rustdoc_test_gen.rs
+++ b/scripts/rustdoc_test_gen.rs
@@ -15,8 +15,8 @@
 //!   - Test code should be able to define functions and call them, without having to carry
 //!     the context.
 //!
-//!   - Later on, we may want to be able to test non-kernel code (e.g. `core`, `alloc` or
-//!     third-party crates) which likely use the standard library `assert*!` macros.
+//!   - Later on, we may want to be able to test non-kernel code (e.g. `core` or third-party
+//!     crates) which likely use the standard library `assert*!` macros.
 //!
 //! For this reason, instead of the passed context, `kunit_get_current_test()` is used instead
 //! (i.e. `current->kunit_test`).

base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
-- 
2.48.1

