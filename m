Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F1B188A37;
	Wed,  4 Sep 2024 20:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482733; cv=none; b=dVXY6xbt3mEtsSWdXCxcZCSKRlu9dq6t3cvs77/NqWayNMdm4L/fZpxjGqS1g/Oire1LLekU479REgkKq5R9OCxiaAn3WvtzW1HHCUlrh1PiIOJkYle3giCaq8BEumzb1s1oi0+cGg4ET4B2jdq0gjcfY891ZmDAY1SfoV54rRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482733; c=relaxed/simple;
	bh=Dgm67RF7sLef7Ai2nvEooNOfaSun/YAmxcXhHOZZ8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlFmdtwL8yiH9QBZ0veNe8eR7CGNNDiogF1abJJoI2nYKz0G2ErCHXzeC7iXuahapfUfmENUblWLJW/6ftFobM1tEJWJC2rNiO5gx/PmUijEL95p/AiPjh9q0iNp2fG/FstOGkK6zNrsAzjSK/X9QXLm+4oGJpmffxoqrQPz4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CoailegH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CoailegH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E71C4CEC9;
	Wed,  4 Sep 2024 20:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482733;
	bh=Dgm67RF7sLef7Ai2nvEooNOfaSun/YAmxcXhHOZZ8NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoailegHKDAx5oBscDootf2VIpPONvw037tsRr3O0eFfIBUVyQvu77MWmwpL2d8xv
	 eiUhBzdu7CzOz/4s/dzFPMuFbEhoFu1PVkCAvjHRHcvaGk0cgw36eMx/5OagOSldSU
	 fZ7rs3GSrl+ogN0Smk1hX6E6zv+HxPb6LMTrzom6ZiTEFzddPD4rQLwxaF7mJjY9u+
	 i+dlshORdBUH8aUFYh6FxwfDFF82hJAF33+GTQNwdctlv9LoKEw+gshje8kDt0mhiU
	 EJ/YebvqI7viOJR6R5vsyipNQz156gOoeXtnyAkEhEexmgE/oeGFD5Szq8+KnJ5ezR
	 7cvRePDSGNlgQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 14/19] rust: provide proper code documentation titles
Date: Wed,  4 Sep 2024 22:43:42 +0200
Message-ID: <20240904204347.168520-15-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust 1.82.0's Clippy is introducing [1][2] a new warn-by-default lint,
`too_long_first_doc_paragraph` [3], which is intended to catch titles
of code documentation items that are too long (likely because no title
was provided and the item documentation starts with a paragraph).

This lint does not currently trigger anywhere, but it does detect a couple
cases we had in private cases if checking for private items gets enabled
(which we will do in the next commit):

    error: first doc comment paragraph is too long
      --> rust/kernel/init/__internal.rs:18:1
       |
    18 | / /// This is the module-internal type implementing `PinInit` and `Init`. It is unsafe to create this
    19 | | /// type, since the closure needs to fulfill the same safety requirement as the
    20 | | /// `__pinned_init`/`__init` functions.
       | |_
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#too_long_first_doc_paragraph
       = note: `-D clippy::too-long-first-doc-paragraph` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(clippy::too_long_first_doc_paragraph)]`

    error: first doc comment paragraph is too long
     --> rust/kernel/sync/arc/std_vendor.rs:3:1
      |
    3 | / //! The contents of this file come from the Rust standard library, hosted in
    4 | | //! the <https://github.com/rust-lang/rust> repository, licensed under
    5 | | //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
    6 | | //! see <https://github.com/rust-lang/rust/blob/master/COPYRIGHT>.
      | |_
      |
      = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#too_long_first_doc_paragraph

Thus clean the two instances we hit and enable the lint.

In addition, since we have a second `std_vendor.rs` file with a similar
header, do the same there too (even if that one does not trigger the lint,
because it is `doc(hidden)`).

Link: https://github.com/rust-lang/rust/pull/129531 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/12993 [2]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init/__internal.rs     | 7 ++++---
 rust/kernel/std_vendor.rs          | 2 ++
 rust/kernel/sync/arc/std_vendor.rs | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/init/__internal.rs b/rust/kernel/init/__internal.rs
index 29f4fd00df3d..163eb072f296 100644
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -15,9 +15,10 @@
 /// [this table]: https://doc.rust-lang.org/nomicon/phantom-data.html#table-of-phantomdata-patterns
 pub(super) type Invariant<T> = PhantomData<fn(*mut T) -> *mut T>;
 
-/// This is the module-internal type implementing `PinInit` and `Init`. It is unsafe to create this
-/// type, since the closure needs to fulfill the same safety requirement as the
-/// `__pinned_init`/`__init` functions.
+/// Module-internal type implementing `PinInit` and `Init`.
+///
+/// It is unsafe to create this type, since the closure needs to fulfill the same safety
+/// requirement as the `__pinned_init`/`__init` functions.
 pub(crate) struct InitClosure<F, T: ?Sized, E>(pub(crate) F, pub(crate) Invariant<(E, T)>);
 
 // SAFETY: While constructing the `InitClosure`, the user promised that it upholds the
diff --git a/rust/kernel/std_vendor.rs b/rust/kernel/std_vendor.rs
index 085b23312c65..d59e4cf4b252 100644
--- a/rust/kernel/std_vendor.rs
+++ b/rust/kernel/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
diff --git a/rust/kernel/sync/arc/std_vendor.rs b/rust/kernel/sync/arc/std_vendor.rs
index a66a0c2831b3..11b3f4ecca5f 100644
--- a/rust/kernel/sync/arc/std_vendor.rs
+++ b/rust/kernel/sync/arc/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
-- 
2.46.0

