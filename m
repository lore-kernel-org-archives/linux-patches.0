Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C471C82F4;
	Wed, 19 Mar 2025 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395109; cv=none; b=L7RuPhwkY0URvsykavsvYTp9utoKYA9Zfzulj8vq4ONFYlnpDvh3LSBKKIXxNmK7pXndlJz8WplMriO3PCVKMiD5WTwNFBkiGXs8GfPo2yT2ue6cNYQl1IBv0zkm7SW4zHbTljlHxmpEav0+4Kt+r96MKnuAwauTmmWo1b8OZ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395109; c=relaxed/simple;
	bh=Cz20XJo/ZKLAZULIXHL6/+2cbw1Isyp2fEm29zEJM6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DImptgLTWiCzEtxuPRnxaFrZowKmZ7uDcZ6LQy8mNVR5PN60uDuW4vuBK3p4mMhbG8/ux/st4R2B+UP4nqzzJFOHKiun6Az3oDmC8N2Ht+fj8VvYOVhV2h8eAdZWXlgSkFga5+NOKOXd1r6n1uG2z3GA0x4SboKQSkF2pzWkE0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwz6Q6ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwz6Q6ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397FDC4CEE4;
	Wed, 19 Mar 2025 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395109;
	bh=Cz20XJo/ZKLAZULIXHL6/+2cbw1Isyp2fEm29zEJM6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwz6Q6ty7oYFLTQfI5vv7v/BmJJSMa4v88uHoCeGUqv7g6GL2pbWXa7/tNhysxVNw
	 IVapPrIFM6dZP+kQxEcksrQkGqazlpRqn4wlyIE/IVcXxehlsZo+JGeLZvwChp0EXj
	 BJoIqIQNvSMX82ZMVwsnjL2+uRtnds+QE1Iy5w2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 163/231] rust: remove leftover mentions of the `alloc` crate
Date: Wed, 19 Mar 2025 07:30:56 -0700
Message-ID: <20250319143030.866672924@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 374908a15af4cd60862ebc51a6e012ace2212c76 upstream.

In commit 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and
`GlobalAlloc`") we stopped using the upstream `alloc` crate.

Thus remove a few leftover mentions treewide.

Cc: stable@vger.kernel.org # Also to 6.12.y after the `alloc` backport lands
Fixes: 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and `GlobalAlloc`")
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250303171030.1081134-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/quick-start.rst |    2 +-
 rust/kernel/lib.rs                 |    2 +-
 scripts/rustdoc_test_gen.rs        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -128,7 +128,7 @@ Rust standard library source
 ****************************
 
 The Rust standard library source is required because the build system will
-cross-compile ``core`` and ``alloc``.
+cross-compile ``core``.
 
 If ``rustup`` is being used, run::
 
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


