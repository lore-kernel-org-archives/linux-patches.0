Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448B825743D;
	Fri,  7 Mar 2025 22:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387961; cv=none; b=WtsCC5Z6ukL0X6AcvCmImdJ3X6crjt/68mlxTolSNM1VIY73N+PHbHRc/YAy16JZ2XYQyRm2aIR8XVdEx484fN9iRfONt2nX9jHxc7YijOISTa/DkxHV2REuWPbJ+iUI5ufS6OYMclON1CAjhQOT2P1EHcC46bH75nc7BcS+swc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387961; c=relaxed/simple;
	bh=x09Tw1njTamUUai9ybUHaxJhy8Yxr/Y5HYW2aI9Y2Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAXccLjZUiihqZ96Clk5q7klo1gz/waF7rW9vIh+GCAXT4OUD8ehTbyk4fR1m2yNiI5X9lN6uhg7vfxKTI8mSsW8OKzGNfXBE2qsvZeSjq4fCqSyWFYeDX0djP+Ym3VrUBU9xS5RXdnf0K0bfc38S4ZjmhCbUKJmzN4d1ZZ51+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbewqeKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbewqeKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05588C4CED1;
	Fri,  7 Mar 2025 22:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387961;
	bh=x09Tw1njTamUUai9ybUHaxJhy8Yxr/Y5HYW2aI9Y2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbewqeKK2i41496H2ZtFLPFZV/hRBvRh3Do3hf520ZOqGrqTzLAGd/RJDBySD89nd
	 WwzIChlqrw3LxmCGC6/74F8FvklaiumcFcNItXDPMzS4bQpuYGf3MQZ2H2iBB+kbYL
	 9ZfZT7bG/zjPQXng+OtXUPNr8doucqz7gxkmVfX9h4ASbAbueEPkjpkbP8gqaSBVb8
	 n3hFzXTIM8djJdx0T+7sN2+0BD4ACF3Zq3nWLFIlfTyDlmJSOwUN6GSbHHst9OnCjx
	 GBwi1g2dBhpVNDeLDYczJvLD9+Hbw9JDDdup/Lm0PXRHxmAe0yRgcFhuW24Tvp7dW1
	 mHerP1ZT+XClg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 46/60] rust: alloc: update module comment of alloc.rs
Date: Fri,  7 Mar 2025 23:49:53 +0100
Message-ID: <20250307225008.779961-47-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 8ae740c3917ff92108df17236b3cf1b9a74bd359 upstream.

Before we remove Rust's alloc crate, rewrite the module comment in
alloc.rs to avoid a rustdoc warning.

Besides that, the module comment in alloc.rs isn't correct anymore,
we're no longer extending Rust's alloc crate.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-28-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index c6024afa3739..f2f7f3a53d29 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-//! Extensions to the [`alloc`] crate.
+//! Implementation of the kernel's memory allocation infrastructure.
 
 #[cfg(not(any(test, testlib)))]
 pub mod allocator;
-- 
2.48.1

