Received: from mout-b-206.mailbox.org (mout-b-206.mailbox.org [195.10.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3EE28F6
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 09:35:09 +0000 (UTC)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-206.mailbox.org (Postfix) with ESMTPS id 4NX9FF23mNz9tNM;
	Wed, 14 Dec 2022 10:34:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyantec.com; s=default;
	t=1671010497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JECLRqzznZVJcQFxEyTyGBYjuCU4Zk5HVm/KjeUQy0I=;
	b=HwA7McrarJVH/sxyrgRgGr+zC/lc6vUMGrXbB/tPfqGIat/vDLQUeeEN7HVYKH+SAe69/X
	qkUjLPb4vIccxfoKgCP70xba6gUN+Nf10pRWqM19ElXmkU8Nm4n1bNvBqbvve3Y695x0BD
	pz/Ine/xCXK3TGkx9zS/MZiJnyH9mWgQQlgvEzNo7jtoEt1Le0Xy8fWBMLfd5O9TyzUvWw
	gr5JaRxFjsDLYr401Y5/pOY3bS41iBK0M0gjzWxMnsR57EH9ZtMW7d1m6FVowjMTRtdtWb
	/3LUycOpUR7lQDiXr7CT/8biL9mw+PGZswEr2KRhJklglw+SwcwiS3tuTXjekw==
Date: Wed, 14 Dec 2022 10:34:51 +0100
From: Finn Behrens <fin@nyantec.com>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: prelude: prevent doc inline of external imports
Message-ID: <20221214093451.zdyhmdyxwz73n6pe@imap.mailbox.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This shows exactly where the items are from, previously the items from
macros, alloc and core where shown as a decleration from the kernel crate,
this shows the correct path.

Signed-off-by: Finn Behrens <fin@nyantec.com>
---
 rust/kernel/prelude.rs | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 7a90249ee9b9..917721e791b6 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -11,15 +11,21 @@
 //! use kernel::prelude::*;
 //! ```
 
+#[doc(no_inline)]
 pub use core::pin::Pin;
 
+#[doc(no_inline)]
 pub use alloc::{boxed::Box, vec::Vec};
 
+#[doc(no_inline)]
 pub use macros::{module, vtable};
 
 pub use super::build_assert;
 
-pub use super::{dbg, pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
+// super::std_vendor is hidden, which makes the macro inline for some reason
+#[doc(no_inline)]
+pub use super::dbg;
+pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
 
 pub use super::static_assert;
 
-- 
2.31.1

