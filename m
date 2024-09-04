Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E17218FDBB;
	Wed,  4 Sep 2024 20:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482752; cv=none; b=j2V1qMu5czQhFu3TeQenjd6oaMyB3O5L3i6T1RuJPo8tXAaS7RFYNjs82/RGaV9xtt47h/LjsrVGRuEIlLPdLLbdSkNxc/Zju9sNJeGyrhU5eICkft67NOTp7wFcVuTR/976ramKhnZwbyOAMvaSVCmhl11Z76nwgWpcUdLZ7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482752; c=relaxed/simple;
	bh=Gln31nQ0hbxwsmmxUuwdP/R/XMmAD97Munol/XkULzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSZcb/Lsp8uli+KWmi5Hs1tLRHgKYxTULEFoZpCDlStIbKC4qeAZ9miX287WujF5/82bbfXtRglGWmI7a+ZY2bjf+JDVWPuS48vcdlfdNk4wWYz59FVZNP4eGMLKywAB3fqM/m8Vm4Gl9zb4uMnb10j6QDe6r8W1uJVeQEK3SF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHAeA/I4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHAeA/I4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322DEC4CEC2;
	Wed,  4 Sep 2024 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482752;
	bh=Gln31nQ0hbxwsmmxUuwdP/R/XMmAD97Munol/XkULzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHAeA/I4a0F8/1m82vsBGH9+5MMtsuNKp+oGEJSrZqL74/2oUVURo8CPeRh8gEUXh
	 14Lrta0V8zEGDfOXNyLUo73D+s0KXSCJ86utYnPWH7DSiiAvVeZkWpN/o1QaG+dSwU
	 tUitEzhSDQDwYjW2P9JyJfeihZrB9MleJpW8IvXR0XUY/tpJ35DW6mi3/TkLUyS1/i
	 VospzDdHRjUfg7uxtkiXgJBxg854FsHF2TwDD6Z9CALpde7tddBDpEz1fflZG1BO4G
	 4F9DmI/ag+XEy56C4+8hVPVBusY+0r3i+11yzgs88lEWkvqjL0CFB8LFhfIFt8qAXU
	 0m4DyT21aWhaQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 19/19] rust: std_vendor: simplify `{ .. macro! .. }` with inner attributes
Date: Wed,  4 Sep 2024 22:43:47 +0200
Message-ID: <20240904204347.168520-20-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is cleaner to have a single inner attribute rather than needing
several hidden lines to wrap the macro invocations.

Thus simplify them.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/std_vendor.rs | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/std_vendor.rs b/rust/kernel/std_vendor.rs
index 8b4872b48e97..8f27d447a7fc 100644
--- a/rust/kernel/std_vendor.rs
+++ b/rust/kernel/std_vendor.rs
@@ -73,8 +73,7 @@
 /// Naive factorial implementation:
 ///
 /// ```rust
-/// # #[expect(clippy::disallowed_macros)]
-/// # {
+/// # #![expect(clippy::disallowed_macros)]
 /// fn factorial(n: u32) -> u32 {
 ///     if dbg!(n <= 1) {
 ///         dbg!(1)
@@ -84,7 +83,6 @@
 /// }
 ///
 /// dbg!(factorial(4));
-/// # }
 /// ```
 ///
 /// This prints to the kernel log:
@@ -129,11 +127,9 @@
 /// invocations. You can use a 1-tuple directly if you need one:
 ///
 /// ```
-/// # #[expect(clippy::disallowed_macros)]
-/// # {
+/// # #![expect(clippy::disallowed_macros)]
 /// assert_eq!(1, dbg!(1u32,)); // trailing comma ignored
 /// assert_eq!((1,), dbg!((1u32,))); // 1-tuple
-/// # }
 /// ```
 ///
 /// [`std::dbg`]: https://doc.rust-lang.org/std/macro.dbg.html
-- 
2.46.0

