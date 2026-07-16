Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1030C319601;
	Thu, 16 Jul 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210433; cv=none; b=GZaeuvk9Jcyuhjb5qCcHJuBXsQbBY2v3tNAxgSVEw/vRSs9M0HFf2q6d6ETLSGkaFhC4eDtowL/QBp4oAfyXk7ytZxh7hpuxKe0hN3odDHPJHT4N6/TKOuEjRhFsgCjZRAXiZwba6SKx1Y9ig34IuulUEn117Yjhwbs8QeJ9Cwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210433; c=relaxed/simple;
	bh=H/C/D/8ndnM0bunoHjlAW8orHo5uwpTa3X28EfOtAXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpZdegJjfchwN6oCGUlXPBQKYeC4wm82p/ZKDiMS6xIgTRP9eRN4+8eLl42xLdF3gK/fHsrO2Z8XdmDGIXZXmum11OKb1CoX295hiwr2irDsXpTz7pYxDAQlt21laX3mVS/yxP0319D4/fKQGtVHCzA0hq5b+BoreyvCEP6WGjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSpFNBL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSpFNBL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7620A1F000E9;
	Thu, 16 Jul 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210432;
	bh=wCzTDoULjNj+9A/xgq4xc9GPu2pOkIU71P71CW1lniY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSpFNBL+cDJXRxCM9ZINglJRZFN3oDP2b8WhHwXx92Sbjem54ogyD9F0oZHFU38wy
	 x1plXW/bItRJHqBkGy43mIL/iZGNPJYf48eIY+e6bH/0gFZySH5L2kzba96zGzdCEQ
	 gzSuijjagaamMaUf3wjofJC5stMhIA84OnCWr1dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/480] rust: str: use the "kernel vertical" imports style
Date: Thu, 16 Jul 2026 15:25:52 +0200
Message-ID: <20260716133044.798318862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 rust/kernel/str.rs | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 8992fedabaf0f7..3a276bc32962d9 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -3,14 +3,29 @@
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
-    ops::{self, Deref, DerefMut, Index},
+    ops::{
+        self,
+        Deref,
+        DerefMut,
+        Index, //
+    }, //
 };
 
 /// Byte string without UTF-8 validity guarantee.
-- 
2.53.0



