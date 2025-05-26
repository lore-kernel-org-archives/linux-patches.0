Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60B619BBA;
	Mon, 26 May 2025 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748273362; cv=none; b=kF76roQ/JD2UUeVJUUCd7fKrjZIYgOubev6355w1v8sesjFUvnceVz+I11SjdFx4iFzbwl9CsuNvbCz1akm0ajLghP0FHjIg2xv5ly7S8R13xIq1cy59+ubyONXdugvReJl539ZpnSBvX1OGR0t71w0HAEWlf+eHcU9Xmjp4wXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748273362; c=relaxed/simple;
	bh=UGDOMvdte6iMfA6q2PDQL+PWjQMSVkq//uih22upj4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PuSwxBW8eSDMrDPRHpazqndR8HhrcKcLOkw7Iwic2xvtiG0we9VZ5moySGEKgCtYBrKEXlTK6SXdMzu+g73OZNN6DDKlCHA1e3iq5msD/hm0/iHB8ood4o+qVdkWC/zFQlP6ObdiY9kGkhFcYW9Ksp7HLMdwdpAEp0ULDFys/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT8y8DnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT8y8DnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA3BC4CEE7;
	Mon, 26 May 2025 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748273361;
	bh=UGDOMvdte6iMfA6q2PDQL+PWjQMSVkq//uih22upj4M=;
	h=From:To:Cc:Subject:Date:From;
	b=FT8y8DnBIbl8Xrk49HTam8cB3criwbcZL0j/xvzrdAbUQlwOYhRImmpwJrZCjBjfX
	 89lAURpxKtJUL392egm8jiuMz/5c29WDfPx/I4JHhV4PVLOKrvhSaNKDHRTfwJrd5p
	 X7AyL99zU7SWyovInVSSKKTfDNY+S4YMwW81cM0t5sihvjm7LY08BUftFMHDxH1srS
	 skctPotaJjnQCx11NgUGkPb5AEPOk1XlRUBopgBGzT9VJfwciE7wX9ErLT1pG6R3PQ
	 hqOX7Ym2aCDUr0o0ClUfgKPv9fXh1P5cEO/iRbtuLmei4MdSZ/ao5TpaoP+lvs76Py
	 X5FxKn1WvzgVQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/2] rust: init: re-enable doctests
Date: Mon, 26 May 2025 17:29:13 +0200
Message-ID: <20250526152914.2453949-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a30e94c29673 ("rust: init: make doctests compilable/testable")
made these tests buildable among others, but eventually the pin-init
crate was made into its own crate [1] and the tests were marked as
`ignore` in commit 206dea39e559 ("rust: init: disable doctests").

A few other bits got changed in that reorganization, e.g. the
`clippy::missing_safety_doc` was removed and the `expect` use.

Since there is no reason not to build/test them, re-enable them.

In order to do so, tweak a few bits to keep the build clean, and also use
again `expect` since this is one of those places where we can actually
do so.

Link: https://lore.kernel.org/all/20250308110339.2997091-1-benno.lossin@proton.me/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 8d228c237954..78cadfcd4392 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -29,15 +29,15 @@
 //!
 //! ## General Examples
 //!
-//! ```rust,ignore
-//! # #![allow(clippy::disallowed_names)]
+//! ```rust
+//! # #![expect(clippy::disallowed_names, clippy::undocumented_unsafe_blocks)]
 //! use kernel::types::Opaque;
 //! use pin_init::pin_init_from_closure;
 //!
 //! // assume we have some `raw_foo` type in C:
 //! #[repr(C)]
 //! struct RawFoo([u8; 16]);
-//! extern {
+//! extern "C" {
 //!     fn init_foo(_: *mut RawFoo);
 //! }
 //!
@@ -66,12 +66,12 @@
 //! });
 //! ```
 //!
-//! ```rust,ignore
-//! # #![allow(unreachable_pub, clippy::disallowed_names)]
+//! ```rust
+//! # #![expect(unreachable_pub, clippy::disallowed_names)]
 //! use kernel::{prelude::*, types::Opaque};
 //! use core::{ptr::addr_of_mut, marker::PhantomPinned, pin::Pin};
 //! # mod bindings {
-//! #     #![allow(non_camel_case_types)]
+//! #     #![expect(non_camel_case_types, clippy::missing_safety_doc)]
 //! #     pub struct foo;
 //! #     pub unsafe fn init_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}

base-commit: f4daa80d6be7d3c55ca72a8e560afc4e21f886aa
-- 
2.49.0

