Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B21DDC0F;
	Wed, 19 Mar 2025 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394945; cv=none; b=UUszTCDWDPj4gxeokUA0b8dpn+anEiYoUxAzlfYAjGNC7Q3l5Gky7XgRAqYZ0df+N2hoXmbgbDCVahZeYQIkG29Ve/ZrQCm61wE/Iblou8pwAX5INJBAaX7Fh71q2izT2TF+cMvd0Seuz1Vj1VIOMS3wODMVu2G89Pc7xHYGo14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394945; c=relaxed/simple;
	bh=ivPmp4ljzvfst/IqrSt25DzU+/N07Sg1uht4qaaWfOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pti8O79i6IMXSwxomAfdn73aneBsQ84BHFYgrxB9zxpxmb+/0dgrCPs1BAqAfvbpK2V5zhoePpA2IpS7LYLoTt0xz2iFzO0oKsd2IHmglBTrcRzVP3uN8v4NVeI2xAXedtFIl8+wEhcuzI9MsgzOa8B8eIQhr9jCvjb6Bxk6fsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Em2Kspar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em2Kspar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E1DC4CEE8;
	Wed, 19 Mar 2025 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394945;
	bh=ivPmp4ljzvfst/IqrSt25DzU+/N07Sg1uht4qaaWfOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em2Kspar4Yn2lj0TQrjh6OBL2H9xMsAL5wUm4q2UfdabXWTyosZMnJBPl/TZ+rRat
	 a4EgqsnzCQ/sY2u2WQhMOjU//A9Np3lJUtZQlTqo4g6fx3dvI8qyzTfKLKlgrRWZxo
	 pYSTH1VlrDH7y0Vg7aFrCygMGL85H5dtfvJDUEjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 168/241] rust: remove leftover mentions of the `alloc` crate
Date: Wed, 19 Mar 2025 07:30:38 -0700
Message-ID: <20250319143031.880790495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,7 +145,7 @@ Rust standard library source
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


