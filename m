Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920AB2F99B8;
	Wed, 19 Nov 2025 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763578316; cv=none; b=NSp9xh1CrJ8RPOkVESLejTIxxZUXiKUck8lXmeJqLguo12cjVjrBtElb38rvM8EWSHilQwlo6zhLy1K9qUIPy9XYnY+zdL8uWu2ddwv/3J78orzfCwIqAsfC0JESBWWkQZSo2TOhTPox4fO81Tgz0+vTie5Rxf0DnJs2olIi+rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763578316; c=relaxed/simple;
	bh=PkOBwPEezWn9aLoNHY3STaK8mXqJcevm3iUEGhwfAAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nnlXcMnwi95TUtLjFf5qlVmMJts3sXi+kXqsjyipVwbwtZw69XjJCoqbhfLL/LP7u5najfQyCgVJrji2mB49ui46X+6aTdVIdu7+Xa8pxkjTPRN4MVkJ2tybxoNNc+Jn6W41TeWlfkCAYc+sONkiVYAQGouqCszHNDO/cymsETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1dKt5zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1dKt5zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F6CC4CEF5;
	Wed, 19 Nov 2025 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763578315;
	bh=PkOBwPEezWn9aLoNHY3STaK8mXqJcevm3iUEGhwfAAk=;
	h=From:To:Cc:Subject:Date:From;
	b=a1dKt5zcz9lnD12NJScmuXv2gebueX0IRCei5yljl3kTe8oAZs9Ctew72meq6GAlU
	 lrHgl4H4x8Cfsfk9a95N7VkbU43aRpTsBqPRBW2LrDkwO0dPDKQYQRkqo9otJ9XeNx
	 /i46yiFmyaH4m3xv6vAUnLfVNWC5AgbrjHlrnFD2jNFxswYnmqS/wBcorOfY2CidPN
	 eHmLQp2etRuBvaeYgJTLVucVhyDBSBT0C6h8t6dfw0Qg4UZGpJ6MjStD9lm1eBpeD5
	 e9Sb2hPKu3DhXPjZ386xetjAJGQ1zZl1Y3RdHpuElCS5QlqRvVZ9yok20uBtm2B1Dm
	 mXVL2mbF5zz0g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: slice: fix broken intra-doc links
Date: Wed, 19 Nov 2025 19:51:25 +0100
Message-ID: <20251119185125.1411151-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In older versions of Rust, the compiler doesn't know about the newer
`as_flattened*` methods, thus `rustdoc` complains about the intra-doc
links, e.g.

     error: unresolved link to `slice::as_flattened`
      --> rust/kernel/slice.rs:19:23
       |
    19 | /// [`as_flattened`]: slice::as_flattened
       |                       ^^^^^^^^^^^^^^^^^^^ the primitive type `slice` has no associated item named `as_flattened`
       |
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

Thus fix them by using an URL instead.

Fixes: 88622323dde3 ("rust: enable slice_flatten feature and provide it through an extension trait")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I have seen this in -next -- please feel free to take it or rebase if
preferred etc., of course. Thanks!

 rust/kernel/slice.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/slice.rs b/rust/kernel/slice.rs
index 6ca91a4fd1f2..ca2cde135061 100644
--- a/rust/kernel/slice.rs
+++ b/rust/kernel/slice.rs
@@ -16,22 +16,22 @@
 ///
 /// This trait can be removed once the MSRV passes 1.80.
 ///
-/// [`as_flattened`]: slice::as_flattened
-/// [`as_flattened_mut`]: slice::as_flattened_mut
+/// [`as_flattened`]: https://doc.rust-lang.org/std/primitive.slice.html#method.as_flattened
+/// [`as_flattened_mut`]: https://doc.rust-lang.org/std/primitive.slice.html#method.as_flattened_mut
 #[cfg(not(CONFIG_RUSTC_HAS_SLICE_AS_FLATTENED))]
 pub trait AsFlattened<T> {
     /// Takes a `&[[T; N]]` and flattens it to a `&[T]`.
     ///
     /// This is an portable layer on top of [`as_flattened`]; see its documentation for details.
     ///
-    /// [`as_flattened`]: slice::as_flattened
+    /// [`as_flattened`]: https://doc.rust-lang.org/std/primitive.slice.html#method.as_flattened
     fn as_flattened(&self) -> &[T];

     /// Takes a `&mut [[T; N]]` and flattens it to a `&mut [T]`.
     ///
     /// This is an portable layer on top of [`as_flattened_mut`]; see its documentation for details.
     ///
-    /// [`as_flattened_mut`]: slice::as_flattened_mut
+    /// [`as_flattened_mut`]: https://doc.rust-lang.org/std/primitive.slice.html#method.as_flattened_mut
     fn as_flattened_mut(&mut self) -> &mut [T];
 }

--
2.52.0
