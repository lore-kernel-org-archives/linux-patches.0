Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA43107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9240CC433D7;
	Thu, 10 Nov 2022 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098540;
	bh=TpYB3dU1gfW4+Y/Ug35QXprZPPfBIkjSDAYCOHoY5AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=du9DSV2ffNd/eTmXOXKDHseXWj0fdF5SabVHYv4yY9lYA8lKRuij1VOdGWFShHAtc
	 bTqhBNIk0vwv6JuixnIUus4RHxpN17Um5v670GoXdzJUMBbt4AEdAeyp1ce1rL/Ym0
	 ocKKNzwuvsDkQF7Jf9ItZpObvEkQieohQpc6p5OTDauzvNQAfDtvXQY4lCNRTlutou
	 Udgxan5RLaUO9JzkdMw5qsGb71ODMcQ1iazpFdW+c3vGIE5l7xFvYbPWVMEZm1FRlh
	 yWBHn/c1S2XbCnuiib9TIxBZT5oG9diR0dH2BPSkQWKwCIdyL61bwYaWasi8EfMcRO
	 7Z8o0uDMfNoVQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 01/28] rust: prelude: split re-exports into groups
Date: Thu, 10 Nov 2022 17:41:13 +0100
Message-Id: <20221110164152.26136-2-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the prelude re-exports into groups: first the ones coming
from the `core` crate, then `alloc`, then our own crates and
finally the ones from modules from `kernel` itself (i.e. `super`).

We are doing this manually for the moment, but ideally, long-term,
this could be automated via `rustfmt` with options such as
`group_imports` and `imports_granularity` (both currently unstable).

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 495e22250726..f8219285d8c0 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -11,10 +11,14 @@
 //! use kernel::prelude::*;
 //! ```
 
-pub use super::{
-    error::{Error, Result},
-    pr_emerg, pr_info, ThisModule,
-};
-pub use alloc::{boxed::Box, vec::Vec};
 pub use core::pin::Pin;
+
+pub use alloc::{boxed::Box, vec::Vec};
+
 pub use macros::module;
+
+pub use super::{pr_emerg, pr_info};
+
+pub use super::error::{Error, Result};
+
+pub use super::ThisModule;
-- 
2.38.1

