Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE18218BC36;
	Fri,  7 Mar 2025 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387871; cv=none; b=IaQFHlMPhavWHtanKbZEXXoMVf2miy8RilczuINMEG2NO5wx5wFgyJIlGkPMoU30tPpVM34ce56soQgp7kYv19Emsk2rbSn08JxPiLJC/h485S8S9KmOx2TWJ0nVUCPJiC5Moj816o1BrBTvk4FFBhaKOCKHHLnTwIkWoZ0WCYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387871; c=relaxed/simple;
	bh=SOlMiKuEczto121p9Bu+Mj2SwW5vz4hifwvwJfXJIQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUkd76AizgNYcOwX6ewGb599GZT1FZ9M/bepB1EVkk4JXE3a15L28wZ0ARkZQyHRPOWdGfoeIhRPkaFUIWIBwUcoQuClok9KnNxHHJ2eVW+wsn0alLyyW11x3Tp+IYJ7Dx7JIGH/rT64P3y8Y+4V9SZUrl+KU4abFUwzAZHkRQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWbzT9jG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWbzT9jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7341EC4CEE8;
	Fri,  7 Mar 2025 22:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387871;
	bh=SOlMiKuEczto121p9Bu+Mj2SwW5vz4hifwvwJfXJIQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWbzT9jGrKx1Vxu3o+R2dFT9EQr8AWGEbDiNb75pEIytivOqtpxrJ5CZ0Zg2gXD0Z
	 DAEULh+9bb1nzjj9MgvfIqJxFyUpnOY9NTM5SRKxzIh/ClfOdzCFXl3VuMk9J7NaS7
	 2oJV/bfXjF9FN5ky9wH2d/ce4VGNURUvJ8Ap5V6IYP+xhaW0tBzAOlAYbIY6dskggk
	 vpvisNLCLNcew6g4If4Ukk7B6YYEh5Vlwk5SF+ug7JfWr2psW5Ej6sVcRhVuI1FiST
	 3GhrtGbBbfBBRPPtHOKuy/SX5WabT1vHFTXu7xAy0LmDOmGaSHj1iexYCUmOAKe4yV
	 eF/VtTDRkp3zA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 13/60] rust: provide proper code documentation titles
Date: Fri,  7 Mar 2025 23:49:20 +0100
Message-ID: <20250307225008.779961-14-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 2f390cc589433dfcfedc307a141e103929a6fd4d upstream.

Rust 1.82.0's Clippy is introducing [1][2] a new warn-by-default lint,
`too_long_first_doc_paragraph` [3], which is intended to catch titles
of code documentation items that are too long (likely because no title
was provided and the item documentation starts with a paragraph).

This lint does not currently trigger anywhere, but it does detect a couple
cases if checking for private items gets enabled (which we will do in
the next commit):

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

Thus clean those two instances.

In addition, since we have a second `std_vendor.rs` file with a similar
header, do the same there too (even if that one does not trigger the lint,
because it is `doc(hidden)`).

Link: https://github.com/rust-lang/rust/pull/129531 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/12993 [2]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [3]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-15-ojeda@kernel.org
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
2.48.1

