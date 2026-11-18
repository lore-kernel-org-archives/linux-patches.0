Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025677;
	b=e74hBnXCp/MP/v2FAmp+0puAffF7KzY1ZLUmf+qYOX+YPXBcxAsPgoBXiQN3c+V30nvS
	 hH3iL2f1Z0U6zptHy3JZnPm9ZehCw5tSP2sSQ9rFGXxH450oYoLp2hjL9nADUZeVFUEyt
	 N+1qvIh3Eouxv5pRxSI8DRMg3pYSDXEiDPEaCGZpfLiYReEHAxeMffzKeZ7QA2smrdx8y
	 W/0uNZx9Ks+4iMtAAmh9DMnZDtdGlBPlsdSoPoI/q/vbPJj+AvxHohg5qUf5F4c7a4ceQ
	 rEyZg0Mh7xBMPvEj7NLO+A5qWQBF27HQJIxRz9xfuM7YirO1CgkAipB2C/aouPgxuTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=brPfg2fYfjKOzJm2CTm50spj6qW3I91PvCOzb0Njylo=;
	b=nNke/6XBspgbN8vuEI9xN/+sgPZ/SXMgfjKtUm9nvzAkkylWwdoHgR7yLtLTbsWHJrT2
	 28gtb3dReyJFe6oXnxr4XFb6c80Pal4720kkt9SbbdgZl/T7qQAzq9HRIrLy4rFyK6ras
	 +jqqn87kqTvFsuVSf5/sxWXg4eH/zphMVRHqswgvzkkQ5HOsGJ2JzKTWZRASew9rHDZfj
	 VsZuYqtV6JbF+VNlrICxmuhKepjOwFSJLlPatGjrgM8VRacg3BLDAh5pl2M01n0MdEBvu
	 0w6ZDIeMYkqH5pT1XZEFlUc8gQxoGS80pJ0Drle9jHmSoSneuv5saQvR1PyuHQUn7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAJx2OHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4BC606A31C;
	Wed, 18 Nov 2026 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAJx2OHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA351F000C4;
	Wed, 18 Nov 2026 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025677;
	bh=brPfg2fYfjKOzJm2CTm50spj6qW3I91PvCOzb0Njylo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAJx2OHZ/yok61PgNN/iPr3Y93Img4K5Nn7Kc7XJT7b7naBRFHlvR7xbntb+YGK5B
	 OJzerCUTdSoCCh+1Ers4sDtxdXF9gq8+Dh+cu5PNkPdj56DBNf3OWOdV5wHcLGo22E
	 IyDbObD/vBqsbigG3Gcwc8+hvqjWqtG/LXgAbO1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1165/2151] rust: id_pool: document panics in `find_unused_id` and `release_id`
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150204.593927473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgios Androutsopoulos <georgeandrout13@gmail.com>

[ Upstream commit 842c5beca0b369bb143b86d6ae63dbcd7c5f0988 ]

`find_unused_id()` calls `Bitmap::next_zero_bit()` and `release_id()`
calls `Bitmap::clear_bit()`, both of which panic when
`CONFIG_RUST_BITMAP_HARDENED` is enabled and the index is out of
bounds. Neither `IdPool` method documents this.

Add the missing `# Panics` sections and state the bounds requirement
on `offset` and `id`.

Fixes: 2cdae413cd3e ("rust: add dynamic ID pool abstraction for bitmap")
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/id_pool.rs | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
index 0b1f720a1f7df..7cb2f5a9a56ce 100644
--- a/rust/kernel/id_pool.rs
+++ b/rust/kernel/id_pool.rs
@@ -213,7 +213,13 @@ pub fn grow(&mut self, mut resizer: PoolResizer) {
     /// bitmap.
     ///
     /// Upon success, returns its index. Otherwise, returns [`None`]
-    /// to indicate that a [`Self::grow_request`] is needed.
+    /// to indicate that a [`Self::grow_request`] is needed. `offset` must be
+    /// within bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `offset` is out
+    /// of bounds.
     #[inline]
     pub fn acquire_next_id(&mut self, offset: usize) -> Option<usize> {
         let next_zero_bit = self.map.next_zero_bit(offset);
@@ -224,6 +230,13 @@ pub fn acquire_next_id(&mut self, offset: usize) -> Option<usize> {
     }
 
     /// Releases an ID.
+    ///
+    /// The `id` must be within bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `id` is out of
+    /// bounds.
     #[inline]
     pub fn release_id(&mut self, id: usize) {
         self.map.clear_bit(id);
-- 
2.53.0



