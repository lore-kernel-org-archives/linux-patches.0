Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130088F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:54:27 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:54:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299665; x=1680558865;
	bh=c1SYY0A1KylQEiGsgr7yJxl7OSG6W1YCjWLUakx2GG0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ecaPmHShyhmlyjowiPezN9aHf9KTDyMQu5g50xbfnkbXTq2q65c6pZj7jECrNgzpK
	 upLffycjxrpuun1Gudt0U1QPUXxNVN5B8FSpLqOo7DVVbtFbe71e9ISuhabesxdL7O
	 8nkKN8xlmhhWgjhUmjJ6ZfDTEpyAug2603lIwxbmSW/CV2r73Hi/f8kZvGZeINyy11
	 WZl4upbV4yyycbZVz/ZH4UfUUBKeqXpaVb/zVVlVPDWLIUkTQFHzVLNo6T0PMRh8zB
	 8OwilGUr/Wcva3KDEbqgOFs/sD+3SCYEaLDXGlk7ZSAFsZB/Jlo9cqzDWjWgxqAu7u
	 blNTI3gfJ7bzA==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <a.hindborg@samsung.com>
Subject: [PATCH v4 12/15] rust: prelude: add `pin-init` API items to prelude
Message-ID: <20230331215053.585759-13-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Benno Lossin <y86-dev@protonmail.com>

Add `pin-init` API macros and traits to the prelude.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/prelude.rs | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 0bc1c97e5604..fcdc511d2ce8 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -18,7 +18,7 @@ pub use core::pin::Pin;
 pub use alloc::{boxed::Box, vec::Vec};

 #[doc(no_inline)]
-pub use macros::{module, vtable};
+pub use macros::{module, pin_data, pinned_drop, vtable};

 pub use super::build_assert;

@@ -27,8 +27,12 @@ pub use super::build_assert;
 pub use super::dbg;
 pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr=
_notice, pr_warn};

+pub use super::{init, pin_init, try_init, try_pin_init};
+
 pub use super::static_assert;

 pub use super::error::{code::*, Error, Result};

 pub use super::{str::CStr, ThisModule};
+
+pub use super::init::{InPlaceInit, Init, PinInit};
--
2.39.2


