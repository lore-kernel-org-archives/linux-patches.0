Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B34441E6D4;
	Thu, 16 Jul 2026 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208972; cv=none; b=bZ8J5vHyrPlqmUQu5Ax8Slp9KbbS3dvDQMuZzGZAsonf5tzHXMP7zwksGfxZdkTIxY0Frx/JcZz8POrzhUow5XHOnw4O6W59Eczq6xpSIsigp1Jcp1ClkYMzQyAYP8Hz4aUc6CH3TinbSj07LT9oFPSnwvgTLrchQFd+mJocUl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208972; c=relaxed/simple;
	bh=SE8hjb5PexuCFyiboENz4u1TQFlELQSvsHC2XA8ob08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD92YdSowJKgJZSlr+GvPHvZ9E9lh8hKqnajHZfyChI/8fyPuVjSzwds67mVEDSfPY8/O6HREHRsnmsOB8cOhw43RIENKq1NcebCNyQbKTk07Wwpko+4vl4+CqhKacDiWVhF6N+5CDuLDCQZ3jIxCT/p94Cydo0OREkYvpfEmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=My6cAJWV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="My6cAJWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BAE1F000E9;
	Thu, 16 Jul 2026 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208971;
	bh=jeUheyQIR13Lfq2jOBUKdk7eu5lhoxhoWTxWPzt6M/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=My6cAJWVFnfBctt8uXlO0eyt6l7P+kb5K70+bP1iP5d3OVjmICEk1Ljk68ZNjXepH
	 A5m2WdX1v/Jm9uyjFoEDV/HfWY/n1dwomJhUmFTbMIx8L8zEkCC435UY8i6S1zK4nu
	 vTpL4LxbZWA1zVWNEjZYv9mnS+EC6PpLHYfH2KQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 001/518] rust: str: use the "kernel vertical" imports style
Date: Thu, 16 Jul 2026 15:24:29 +0200
Message-ID: <20260716133047.809653397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 724a93a9f6033800b02a3530dbcb464638448e7f ]

Convert the imports to use the "kernel vertical" imports style [1].

No functional changes intended.

Link: https://docs.kernel.org/rust/coding-guidelines.html#imports [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260609104152.261145-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 3fff4271809b ("rust: str: clean unused import for Rust >= 1.98")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/str.rs | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 8311d91549e15e..a7fccd4c4f3b18 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -3,14 +3,28 @@
 //! String representations.
 
 use crate::{
-    alloc::{flags::*, AllocError, KVec},
-    error::{to_result, Result},
-    fmt::{self, Write},
-    prelude::*,
+    alloc::{
+        flags::*,
+        AllocError,
+        KVec, //
+    },
+    error::{
+        to_result,
+        Result, //
+    },
+    fmt::{
+        self,
+        Write, //
+    },
+    prelude::*, //
 };
 use core::{
     marker::PhantomData,
-    ops::{Deref, DerefMut, Index},
+    ops::{
+        Deref,
+        DerefMut,
+        Index, //
+    }, //
 };
 
 pub use crate::prelude::CStr;
-- 
2.53.0



