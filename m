Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C42E1C57;
	Thu, 16 Oct 2025 23:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760656891; cv=none; b=OGh1svOfsYLu9i3/TczxbXxswM+8IaGWM/D7fGCzxFZVdTHa5PEXlj/mJSrV5GWdHhrllBVbR8FYRl0hSiJlU8/wndsdk2wcllNr9ep+27oiD7b1TWXr8ZLk11y3QG5/7JE1YU4yn/O59FZXezxjYpJ27tP6VRdAtDdAguVtfL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760656891; c=relaxed/simple;
	bh=lhnZdjQAspu8z7emtfhvrNr16HucRHE64ZrpEWkb9e8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bWn9GSidewR4B00XDt4ml5KFNmSR/APIOz6TayhJdp3Vv1N6B0T+tDrZLuOE4AZbSZWiARj5Eb1W0k78UbTtdK8NTLtKbaIjHUMjMu4k+Zt7rby5shRzVLpICPxL8bDxvsjhmJzC8LUOR83SyLUS2kyOTGNdwKjG0Hd1rGWoANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRyGjdY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRyGjdY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC33C4CEF1;
	Thu, 16 Oct 2025 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760656891;
	bh=lhnZdjQAspu8z7emtfhvrNr16HucRHE64ZrpEWkb9e8=;
	h=From:To:Cc:Subject:Date:From;
	b=CRyGjdY/waPRSekH+tFc/yr5IXsl4uy0BOCBFuheN8EO7xtbkzmceJIj7gYNuVMhX
	 5lZJ95n0KnYMseXDEDQDCiUJkrWUOV+IWVisHzaUIS0pW48pXtiVycrZq3Baw8XW6b
	 uOXap3lt6hcTCFx/CwGcHg/QzUI20+tqK/zf/LIDI2+ulunhNHmuoJ+D6Siy+1gdMP
	 l6XzOZ5JrOCGWWN6wv8v6GXELagnAsxS5EIZSx0bJ0vQQ90d0sO/BKVIGORsaCZCFz
	 tYyEgs5QElchLvsEfyZZkzmSfj0wawH3bGP/hHsFJFOygSdOYgjcp4Of9RPNGcPW9+
	 kp0FvtAObJ38g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>,
	Burak Emir <bqe@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>,
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
Subject: [PATCH] rust: bitmap: fix formatting
Date: Fri, 17 Oct 2025 01:21:18 +0200
Message-ID: <20251016232118.1419895-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We do our best to keep the repository `rustfmt`-clean, thus run the tool
to fix the formatting issue.

Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formatting
Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
Fixes: 0f5878834d6c ("rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
This one will go on top of:

    https://lore.kernel.org/rust-for-linux/20251010174351.948650-1-ojeda@kernel.org/

 rust/kernel/bitmap.rs | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index 711b8368b38f..aa8fc7bf06fc 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -167,7 +167,9 @@ fn deref(&self) -> &Bitmap {
         let ptr = if self.nbits <= BITS_PER_LONG {
             // SAFETY: Bitmap is represented inline.
             #[allow(unused_unsafe, reason = "Safe since Rust 1.92.0")]
-            unsafe { core::ptr::addr_of!(self.repr.bitmap) }
+            unsafe {
+                core::ptr::addr_of!(self.repr.bitmap)
+            }
         } else {
             // SAFETY: Bitmap is represented as array of `unsigned long`.
             unsafe { self.repr.ptr.as_ptr() }
@@ -184,7 +186,9 @@ fn deref_mut(&mut self) -> &mut Bitmap {
         let ptr = if self.nbits <= BITS_PER_LONG {
             // SAFETY: Bitmap is represented inline.
             #[allow(unused_unsafe, reason = "Safe since Rust 1.92.0")]
-            unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
+            unsafe {
+                core::ptr::addr_of_mut!(self.repr.bitmap)
+            }
         } else {
             // SAFETY: Bitmap is represented as array of `unsigned long`.
             unsafe { self.repr.ptr.as_ptr() }

base-commit: 32f072d9eaf9c31c2b0527a4a3370570a731e3cc
--
2.51.0
