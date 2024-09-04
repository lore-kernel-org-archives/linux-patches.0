Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1373017623F;
	Wed,  4 Sep 2024 20:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482732; cv=none; b=YjBdT+FxVJ2CoqzOemLEJgMnFuC3U6yc0f3wRMBVX7jGUtMbz1s87v78g6UHtN5VeqI1RnkiX9s9VrCmGX6kUcFKpvlILHm9U5EJigtn9fIAop9s5tBRUxG5F2pGDXhVx1EnGfAeicHgud/KHCQDKyP6pRe5mUSvMSJ6ZRmyhbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482732; c=relaxed/simple;
	bh=Ssl2889E1Mv3hIu22VdL53Z2yZNkmUfjHy2j46S1dHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXrlLbIPBX6fzm6gBfLO3eBXk8jelTxUHhPhmBhVHaMDsW+JOhRTJOdoHD51THpnazGacz2FxH//hazoGvj+IjHrfeySDmgtUaKPcXfwUUTQhihp6CHv3Ur+H0RKeGX0FgnS+wlqwXiHZ+L41/O3MyNgTQezlAH6pbUSuoWPVi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0qIz8o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0qIz8o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5BBC4CEC2;
	Wed,  4 Sep 2024 20:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482729;
	bh=Ssl2889E1Mv3hIu22VdL53Z2yZNkmUfjHy2j46S1dHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0qIz8o637Pfw6aqEIzaiKbAl/YwPYiKx9t10pD/8bXV2M/Gc2OfBZte+bV7BcvyB
	 R82nuuOhx0aRtBMWToA82Jmr9XdE/IUEcAsXWAhNaRiu7zDyXy6APCkFjW0E+f6Zhe
	 dr2av2UuQgivstItV3XBw3ND94BL780gzvJ/r58NfOqhdAFDrxvEDybWhOKX4RR1WY
	 vJpeuKTRPs9IP2yhNUVuKdfs9SC8UsP9aetJb1XXBDo5LEyZ1Hu/VWd6wNYiyr6Jl/
	 5tN8ExSQ9R0V9e3UKb8GJuB+KVz+2eUvfXVTuW8eNbi8G6gr4s2+d6u9HGkqvDPQjj
	 JlwMwpzNOMWsw==
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
Subject: [PATCH 13/19] rust: rbtree: fix `SAFETY` comments that should be `# Safety` sections
Date: Wed,  4 Sep 2024 22:43:41 +0200
Message-ID: <20240904204347.168520-14-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tag `SAFETY` is used for safety comments, i.e. `// SAFETY`, while a
`Safety` section is used for safety preconditions in code documentation,
i.e. `/// # Safety`.

Fix the three instances recently added in `rbtree` that Clippy would
have normally caught in a public item, so that we can enable checking
of private items in the next commit.

Fixes: 98c14e40e07a ("rust: rbtree: add cursor")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/rbtree.rs | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/rbtree.rs b/rust/kernel/rbtree.rs
index 48ceb9560bf5..48e552799e17 100644
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -884,7 +884,8 @@ fn get_neighbor_raw(&self, direction: Direction) -> Option<NonNull<bindings::rb_
         NonNull::new(neighbor)
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has immutable access to `node` for the duration of 'b.
     unsafe fn to_key_value<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b V) {
@@ -894,7 +895,8 @@ unsafe fn to_key_value<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b V) {
         (k, unsafe { &*v })
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has mutable access to `node` for the duration of 'b.
     unsafe fn to_key_value_mut<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b mut V) {
@@ -904,7 +906,8 @@ unsafe fn to_key_value_mut<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b
         (k, unsafe { &mut *v })
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has immutable access to the key for the duration of 'b.
     unsafe fn to_key_value_raw<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, *mut V) {
-- 
2.46.0

