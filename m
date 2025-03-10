Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087318DB24;
	Mon, 10 Mar 2025 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627131; cv=none; b=Z33oWSe7oxpAiq0zrUUDrRVlWdJfRZbVJ1r6eGNg3lqew4wkNdWgnAErLs48SzZkWxk4VnVxL0G5YboXpmncPu/7Dnp1ADXYxBgKF7i6yyAleELtyj47vVx2W/9NWCHKJxgBkpgpub+OhV7xDhz4Svip6/jek1buMfJJUGAwMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627131; c=relaxed/simple;
	bh=aYjdELwoCcVcSIUJvB1MUXqMGjwigL9IXeYrU6KC028=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC5LLWe8/4v5ZvegP0aXNcIMezom/0+GCKLCzve5Y6RRyyIzXVKAPiWI3WP8b6K+6zZwKwyA81kdgmHGbv58WHR4Kgd2CRspfQfMHNG3wAyYiXnnDsRdyZs39Kv9TGeylPBxTzg+hCPeFVRs/9jDGAUaWfmrlGg1Q+iZaLjETp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2OUzLUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2OUzLUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DAAC4CEE5;
	Mon, 10 Mar 2025 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627130;
	bh=aYjdELwoCcVcSIUJvB1MUXqMGjwigL9IXeYrU6KC028=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2OUzLUlgILaHqaIVo7F9s0Rj98ABm11JSAHcSc1+OnBdY2BWcUdDCYILTziGhA/s
	 dMmSffH/MimJrb3BubTZjEnv3/pwoWOAuHY1u8nL5UXRn3C5FM74V0ZXBSumhy2HSO
	 KtbOlXrs1higPNRlCP54ny6b34H61hSDzWhZbAbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 024/269] rust: provide proper code documentation titles
Date: Mon, 10 Mar 2025 18:02:57 +0100
Message-ID: <20250310170458.676597712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/__internal.rs     |    7 ++++---
 rust/kernel/std_vendor.rs          |    2 ++
 rust/kernel/sync/arc/std_vendor.rs |    2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -15,9 +15,10 @@ use super::*;
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
--- a/rust/kernel/std_vendor.rs
+++ b/rust/kernel/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
--- a/rust/kernel/sync/arc/std_vendor.rs
+++ b/rust/kernel/sync/arc/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,


