Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343D28EBFE;
	Sat, 19 Jul 2025 23:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752967530; cv=none; b=eziQUYpBm2TxY+WjpcJ+9h+W/YAnI4yadxGrprxjDpt9PDjBb4Z0jhQrmrNSBQMKqeuxjO2GRUPRgv9yWknVKSR+uQaBr1e5tzB6hdnISp7jpbxK7K6/xr8NJM2SxEMEnkzYKVTqpsz5Bebpu9veqfbukaC4LsTRr51OMJIEVAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752967530; c=relaxed/simple;
	bh=peq7X5T5L9rleO+1sgszgJjNh6IB635WmU1jTfpTxO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cxABsiiJX8+5j71bf0f+jMATsQ7ik1mfcQtFVWtrLof7F+0Rmm1XKLdPZSTiFlJw1SyMjsSiSA01prsu4POO/C9ofx5aM64rm0656ObtkRmCx8tB7cNT4oHgL/cdqhYFeoElmD5JcUJWAq5DIeAXdiX7SIndxh5gRAoiUB+Q2cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jg4RU7lE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jg4RU7lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A313EC4CEE3;
	Sat, 19 Jul 2025 23:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752967530;
	bh=peq7X5T5L9rleO+1sgszgJjNh6IB635WmU1jTfpTxO4=;
	h=From:To:Cc:Subject:Date:From;
	b=Jg4RU7lEmQ4jX6Fx0S8H/+jdvExKWA11Bz68Q1EhxUlFku9BqA6aVDr6GS96uK8+6
	 /IU0YJhiE2gR09bsH8NzfRZDY0LBIRSt0ljRNB5JmgoFTZGYcYQsuao8/7h4Tr2T5x
	 +xrWnxgxWlhp1TxGCi2AdVXdrXwLFUo8sWUPFi1A8xwg/eS9KG5/IeYCv/1/QEkkmv
	 CFzQJolyz+PPE7Kk39NERKGXGvVYyleBjm+0WinbLPeIkA6R3T8oOABYNDjuW8b6Rw
	 x1PxJAcFkzGXpb/hSS3Zv6nOgdeL+7QP+KK/Tex/V6Gi27TyaH+WZI8FwYPURZAFSS
	 AyKFw2F15ntsQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: list: remove nonexistent generic parameter in link
Date: Sun, 20 Jul 2025 01:25:00 +0200
Message-ID: <20250719232500.822313-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`ListLinks` does not take a `T` generic parameter, unlike
`ListLinksSelfPtr`.

Thus fix it, which makes it also consistent with the rest of the links
in the file.

Fixes: 40c53294596b ("rust: list: add macro for implementing ListItem")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/list/impl_list_item_mod.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/list/impl_list_item_mod.rs b/rust/kernel/list/impl_list_item_mod.rs
index f4c91832a875..202bc6f97c13 100644
--- a/rust/kernel/list/impl_list_item_mod.rs
+++ b/rust/kernel/list/impl_list_item_mod.rs
@@ -17,13 +17,13 @@
 /// [`ListLinks<ID>`]: crate::list::ListLinks
 /// [`ListItem`]: crate::list::ListItem
 pub unsafe trait HasListLinks<const ID: u64 = 0> {
-    /// Returns a pointer to the [`ListLinks<T, ID>`] field.
+    /// Returns a pointer to the [`ListLinks<ID>`] field.
     ///
     /// # Safety
     ///
     /// The provided pointer must point at a valid struct of type `Self`.
     ///
-    /// [`ListLinks<T, ID>`]: crate::list::ListLinks
+    /// [`ListLinks<ID>`]: crate::list::ListLinks
     unsafe fn raw_get_list_links(ptr: *mut Self) -> *mut crate::list::ListLinks<ID>;
 }
 

base-commit: cc84ef3b88f407e8bd5a5f7b6906d1e69851c856
-- 
2.50.1

