Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517434CF5;
	Wed, 16 Apr 2025 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806080; cv=none; b=DlkAyhrklBDw8+2sBPYfqa9mbiJB7rPO3u5H1rCs+1Lr7B/qPn4oH5AuvL2+vKUzehouhet+no5emGfIFlc7caQll10VD05+hEaI1q2ytgdWytCTD2Fub3KqqQAcB/84z6XeTYq9R8ZRGFmFdsxT0cvd+PIqxaUDULQzoKYy1P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806080; c=relaxed/simple;
	bh=imFebmYu1OY9KuHZh3bQW3/s6Grl8SJUmxkN69et5F8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hvWD121PWfFC4RTKJ8A/wKfM7bAFK5/jm5+KT24869B0suOkH1hVBYCnDWF2V9i6NWnHMJWeikTmdA2ZMnWlwTCYNaOnSs4cQeVDjgqIsbsO8rC3lPvJI+6fGnHFwoFLzcJS8EqDeUSZYT1o/pN8lEoG4iVHezjjxRxxbU5UD/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRbHAmp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRbHAmp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D7AC4CEE2;
	Wed, 16 Apr 2025 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744806079;
	bh=imFebmYu1OY9KuHZh3bQW3/s6Grl8SJUmxkN69et5F8=;
	h=From:To:Cc:Subject:Date:From;
	b=BRbHAmp3UstI/QNOKyxuO5RLnMeIZo4Pe0oEIr6HKpI5EDVWh4jwenh9s4eX+Fy0B
	 m19Gvf4bTmrPdtEFOyWk9xBFF81NDPdiBcBxm0FJ7E141il7SMRmyMnIyqkfFI7isW
	 dJDM8mq2HUTS7Tqzl508VQO2tV0aG6i6UVqHiLpnoB1I7h8cxZDeNAbdaPFfrVw2bD
	 FGMfzZ9eV/fnsBffCXRLz7FNMgsMGgVgb2mrgQmVUqV99GEUlwoyHy6NQD9hVCIWOU
	 qfIrow6FOsNluKe2AZu6SvqnmrZmFtRrzIBKXR/h1CFTyrWXUoXaGPeVFttG5ueGgt
	 jHdHT4I3LrDMg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] drm/panic: use `///` for private items too
Date: Wed, 16 Apr 2025 14:21:06 +0200
Message-ID: <20250416122106.2554208-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`///` should still be used for private items [1]. Some of the items in
this file do so already, so do it for a few other clear candidates in
the file.

Link: https://lore.kernel.org/rust-for-linux/20250416112454.2503872-1-ojeda@kernel.org/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Not sure if you would consider it a fix, but please feel free to add Fixes: etc.
if so. Thanks!

 drivers/gpu/drm/drm_panic_qr.rs | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index f2a99681b998..642e3240a014 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -315,7 +315,7 @@ fn get_header(&self) -> (u16, usize) {
         }
     }

-    // Returns the size of the length field in bits, depending on QR Version.
+    /// Returns the size of the length field in bits, depending on QR Version.
     fn length_bits_count(&self, version: Version) -> usize {
         let Version(v) = version;
         match self {
@@ -331,7 +331,7 @@ fn length_bits_count(&self, version: Version) -> usize {
         }
     }

-    // Number of characters in the segment.
+    /// Number of characters in the segment.
     fn character_count(&self) -> usize {
         match self {
             Segment::Binary(data) => data.len(),
@@ -569,8 +569,8 @@ struct EncodedMsgIterator<'a> {
 impl Iterator for EncodedMsgIterator<'_> {
     type Item = u8;

-    // Send the bytes in interleaved mode, first byte of first block of group1,
-    // then first byte of second block of group1, ...
+    /// Send the bytes in interleaved mode, first byte of first block of group1,
+    /// then first byte of second block of group1, ...
     fn next(&mut self) -> Option<Self::Item> {
         let em = self.em;
         let blocks = em.g1_blocks + em.g2_blocks;
@@ -638,7 +638,7 @@ fn clear(&mut self) {
         self.data.fill(0);
     }

-    // Set pixel to light color.
+    /// Set pixel to light color.
     fn set(&mut self, x: u8, y: u8) {
         let off = y as usize * self.stride as usize + x as usize / 8;
         let mut v = self.data[off];
@@ -646,13 +646,13 @@ fn set(&mut self, x: u8, y: u8) {
         self.data[off] = v;
     }

-    // Invert a module color.
+    /// Invert a module color.
     fn xor(&mut self, x: u8, y: u8) {
         let off = y as usize * self.stride as usize + x as usize / 8;
         self.data[off] ^= 0x80 >> (x % 8);
     }

-    // Draw a light square at (x, y) top left corner.
+    /// Draw a light square at (x, y) top left corner.
     fn draw_square(&mut self, x: u8, y: u8, size: u8) {
         for k in 0..size {
             self.set(x + k, y);
@@ -784,7 +784,7 @@ fn is_version_info(&self, x: u8, y: u8) -> bool {
         vinfo != 0 && ((x >= pos && x < pos + 3 && y < 6) || (y >= pos && y < pos + 3 && x < 6))
     }

-    // Returns true if the module is reserved (Not usable for data and EC).
+    /// Returns true if the module is reserved (Not usable for data and EC).
     fn is_reserved(&self, x: u8, y: u8) -> bool {
         self.is_alignment(x, y)
             || self.is_finder(x, y)
@@ -793,13 +793,14 @@ fn is_reserved(&self, x: u8, y: u8) -> bool {
             || self.is_version_info(x, y)
     }

-    // Last module to draw, at bottom left corner.
+    /// Last module to draw, at bottom left corner.
     fn is_last(&self, x: u8, y: u8) -> bool {
         x == 0 && y == self.width - 1
     }

-    // Move to the next module according to QR code order.
-    // From bottom right corner, to bottom left corner.
+    /// Move to the next module according to QR code order.
+    ///
+    /// From bottom right corner, to bottom left corner.
     fn next(&self, x: u8, y: u8) -> (u8, u8) {
         let x_adj = if x <= 6 { x + 1 } else { x };
         let column_type = (self.width - x_adj) % 4;
@@ -812,7 +813,7 @@ fn next(&self, x: u8, y: u8) -> (u8, u8) {
         }
     }

-    // Find next module that can hold data.
+    /// Find next module that can hold data.
     fn next_available(&self, x: u8, y: u8) -> (u8, u8) {
         let (mut x, mut y) = self.next(x, y);
         while self.is_reserved(x, y) && !self.is_last(x, y) {
@@ -841,7 +842,7 @@ fn draw_data(&mut self, data: impl Iterator<Item = u8>) {
         }
     }

-    // Apply checkerboard mask to all non-reserved modules.
+    /// Apply checkerboard mask to all non-reserved modules.
     fn apply_mask(&mut self) {
         for x in 0..self.width {
             for y in 0..self.width {
@@ -852,7 +853,7 @@ fn apply_mask(&mut self) {
         }
     }

-    // Draw the QR code with the provided data iterator.
+    /// Draw the QR code with the provided data iterator.
     fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
         // First clear the table, as it may have already some data.
         self.clear();

base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
--
2.49.0
