Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A940642377A;
	Thu, 16 Jul 2026 14:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210435; cv=none; b=hd6bgmhNvuVwZ9HiFPfg3pX4p/PbSfNsimv8ZZ/ZwqOLxiVxRnhdg+WoCXONzsR/xPdG6IxKIAHwPcBu4ypVYURfFEeG6OEJ+KkDAg/yzlb8dwuAAizxeqSHenB7pWDgNJGHvX8vCAzCdSYkE5PZ8ZpRGZoxohOaduYtuciKmeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210435; c=relaxed/simple;
	bh=/u/guZawipIoVGuCON5Ldlt1tDWYNxrE0opLgLl+Egc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwNeH8pLHOr8463atB/SvCuWw1AXuMkFjCM2aM9VKC1tfra0e8E0yan8dPos/MFcNH5ca9otAKPCP9owFOdad53i/Kt0BJ+1TV91fwWXiOtQAo8AZD2ebRd0gxwOM9PP6d1ydCzq+APX9ZMCaJPULrmie710iWixOTpu0Qt0Pac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+IpRZot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+IpRZot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E231F000E9;
	Thu, 16 Jul 2026 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210434;
	bh=+Z+JNgyxVDXeN3rfxDnr3yK83KH0eLTMeUWHRD/HACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+IpRZot+sCVqiqcq9b8ogwqF++UfOxIxeETWg/2O41JbUWUXGTmw7LdI5ay8QIcK
	 e2uq3x5bb5kSSphoJi7D8+PJ0Q9Mu1X2CNUtVWroQLxrnHjMxIJQV59cU0hsTEi1x0
	 7yUrPECmejcluNNLsljMnbFhOfrP4QCmQ5V2sLt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/480] rust: str: clean unused import for Rust >= 1.98
Date: Thu, 16 Jul 2026 15:25:53 +0200
Message-ID: <20260716133044.820152381@linuxfoundation.org>
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

[ Upstream commit 3fff4271809b57182c4011811e96556bdd4cb2f9 ]

Starting with Rust 1.98.0 (expected 2026-08-20), the compiler has changed
how the resolution algorithm works [1] in upstream commit c4d84db5f184
("Resolver: Batched import resolution."), and it now spots:

    error: unused import: `flags::*`
     --> rust/kernel/str.rs:7:9
      |
    7 |         flags::*,
      |         ^^^^^^^^
      |
      = note: `-D unused-imports` implied by `-D warnings`
      = help: to override `-D warnings` add `#[allow(unused_imports)]`

It happens to not be needed because the `prelude::*` already provides
the flags.

Thus clean it up.

Cc: stable@vger.kernel.org # Needed in 6.18.y and later (prelude added to `str`).
Link: https://github.com/rust-lang/rust/pull/145108 [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260609104152.261145-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/str.rs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 3a276bc32962d9..22cefbc9852360 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -4,7 +4,6 @@
 
 use crate::{
     alloc::{
-        flags::*,
         AllocError,
         KVec, //
     },
-- 
2.53.0



