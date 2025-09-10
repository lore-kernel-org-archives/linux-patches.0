Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC771A9B24;
	Wed, 10 Sep 2025 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757512951; cv=none; b=juP8XxYO5U2BEVNNlZCR8c+9pCH0B9JR+In2tr/3U4KSdUJVu0i5lTLlbh9WoGT4VaE/L/STSVtWvekDGc4xTZpyq0tDl+Vh0vCnVqbeSO0FavHRJ+6cRD5437qJQo9oBmsq9HuP3AY+oICsRgLekjWGxYHO7aEFZo92tlc3vpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757512951; c=relaxed/simple;
	bh=7gKOy4mWIIMJn2O0tOIMxnNykK3kocaGWGSOwj2zmqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jRA7mRtCzlabWAyMXWeE9bAywOoMWExwZHQTsFNKB6Vkyt49tbcGAwliIFNE7TGU/xZeI3FMYcnStvuEbb7aIArO+WNbCA6i5Sa50og0qejdjFeORWNZyQHQZ66uIvfc4xXfhUWaZSnxL/nO/adhoJWmPet/issmWU8Bu3mo98g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuR9s6yT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuR9s6yT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF0C4CEEB;
	Wed, 10 Sep 2025 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757512951;
	bh=7gKOy4mWIIMJn2O0tOIMxnNykK3kocaGWGSOwj2zmqM=;
	h=From:To:Cc:Subject:Date:From;
	b=AuR9s6yTQMWSQQvZN4WZuBjynUVlZ+rMRegF68lQI2v/4PQUTdPDXhp1LzfaGPl1n
	 0irZG11cclU7p+rEyLHZAoBXvm+m1Tc6uUXvSI3mD12RlChp7WwE/tMUV1qYNV5Ags
	 9t3Z22UE/GwcJuJr4JiWBSXQcl/l19ASwWMCMTFLrtx1tIr+eVpAW68ozO7rjlqaOE
	 pmtZMEBHvRFOZumP9/OgoBP24ZdDjKFecaN2IIxNNVO59uH+Qlyndh9+EX8CAHwLzO
	 XQV/BfFHizW3KMvJlQoz6m5lk5arf1UhuCffW7JwvCelvlaMlJAB1cwW1AkMbmjQ94
	 kpQmSXjpnJDUg==
From: Miguel Ojeda <ojeda@kernel.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: maple_tree: fix intra-doc link
Date: Wed, 10 Sep 2025 16:02:12 +0200
Message-ID: <20250910140212.997771-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple `Occupied` intra-doc links are broken:

    error: unresolved link to `Occupied`
      --> rust/kernel/maple_tree.rs:96:46
       |
    96 |     /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
       |                                              ^^^^^^^^ no item named `Occupied` in scope
       |
       = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

    error: unresolved link to `Occupied`
       --> rust/kernel/maple_tree.rs:135:36
        |
    135 |     /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
        |                                    ^^^^^^^^ no item named `Occupied` in scope
        |
        = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`

Thus fix them.

Fixes: 7f51d867d2ed ("rust: maple_tree: add MapleTree")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Andrew: as usual, please feel free to rebase if that is what you
normally do, of course. This was in next-20250910. Thanks!

 rust/kernel/maple_tree.rs | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 31b6c13d08ef..e72eec56bf57 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -93,8 +93,7 @@ pub fn new() -> impl PinInit<Self> {
     /// # Errors
     ///
     /// If the maple tree already contains a range using the given index, then this call will
-    /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
-    /// allocation fails.
+    /// return an [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails.
     ///
     /// # Examples
     ///
@@ -132,8 +131,8 @@ pub fn insert(&self, index: usize, value: T, gfp: Flags) -> Result<(), InsertErr
     /// # Errors
     ///
     /// If the maple tree already contains an overlapping range, then this call will return an
-    /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
-    /// or if the requested range is invalid (e.g. empty).
+    /// [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails or if the
+    /// requested range is invalid (e.g. empty).
     ///
     /// # Examples
     ///

base-commit: a3bff28df80b33386863823262550491155e896b
--
2.51.0
