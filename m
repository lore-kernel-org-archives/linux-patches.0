Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE5A231A30;
	Fri, 10 Oct 2025 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118272; cv=none; b=iSaRi6uWhn34vFVJnLoQsvP1uFtkqi2osG4DeKW3pSqA3rcyyhEmDZJpzFSifaMGgtSDbfK5o+IYeTd7dk6mKnms0ln8cH+Dr1jjHb8XVeINigM4aHO1FyoZ6CtncpNb79tFSyffgr5LLcsk/E+NPvXACn1rELsnbWQrzdcc/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118272; c=relaxed/simple;
	bh=O7/bjHM+l6J8JLrW0eLWostgUJ5Nl0LYFfN4tBaYkIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFxLkU2lka1NCvB8gIp/x3v/9nefPaGo6poYTcndGRq4bWe0zY5bF9QwptXg5QkucuNsGcDpcN2FkCf/5Fni9NezrSh65s+Fz1FCrAgg9gnpMe/oSYfQY4bWo7ReuMQZl8r16Ev97RXGrgTLBn+Ik8cajG/wyOwy4DGCVyUv6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVlww11Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVlww11Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB85BC4CEFE;
	Fri, 10 Oct 2025 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760118272;
	bh=O7/bjHM+l6J8JLrW0eLWostgUJ5Nl0LYFfN4tBaYkIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVlww11ZjxiAHIDJr58Zrsbblim2/3VpjuicUsy1UX1n/tH9vs1qqv9P0jMQ51Nv0
	 Q+y/nLiJ/bui4/fiQKHth4BoIDvjQwANa808B4DiLrO0PV899/PIkcZWG17dLLnEu6
	 NqgISiJARP+dJK3alYYC8Qs40ErXB8rz0j29GiUhalngipcwnYWfFddnW1mlYA0eSs
	 gfcuUAnz8A5JoY8fp8hxlCwkPn4RY3wYFzV5g+06X1oUeccCcM0tWWnPJb3wAxewF/
	 eKpliZf0+C8hCN/kO7pjD+ULJLcH5aPSxHXOs0OvVpxZ0dsYM4WfI7NexORMaE6N/6
	 tayciRwW01T0g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/3] rust: alloc: employ a trailing comment to keep vertical layout
Date: Fri, 10 Oct 2025 19:43:50 +0200
Message-ID: <20251010174351.948650-3-ojeda@kernel.org>
In-Reply-To: <20251010174351.948650-1-ojeda@kernel.org>
References: <20251010174351.948650-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Apply the formatting guidelines introduced in the previous commit to
make the file `rustfmt`-clean again.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index e94aebd084c8..ac8d6f763ae8 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -9,7 +9,7 @@
 };
 use crate::{
     fmt,
-    page::AsPageIter,
+    page::AsPageIter, //
 };
 use core::{
     borrow::{Borrow, BorrowMut},
-- 
2.51.0

