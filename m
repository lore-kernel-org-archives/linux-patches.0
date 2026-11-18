Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018848;
	b=Bm6fOMfJEXrje7mrNOCDZC8Trvgw60Klnsa0gbblECfBS4TZmAFXgkNg3wESP636yzjb
	 Ji/8AORkYBJ7xj28n6W3CczAflWCF0T6tpneK0vlBx1LkoKyYzxGGfQSwvk4MqWmWr3+M
	 kTZvT0OsnWIDKxiJBkgOxaMCGIFiW5gYBYZY510Boq321IrsvrFrb2PkHUvOdMKzvhSf4
	 /YI2inHumMVNbBNtERYlSmkGPeQuDNNmX9QyZ/dA8a7+GGOaWI9RomgMF5xrC7qrrJ/03
	 YjTs993tbMMzRLq3oznkprq7C/rybuOMCONtU2R/dsSFJw2YDkVfPRsNwlTRAEzi/9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1m6OoMavc4uKEmX3ZsrzSWZWWmprhSXrPxoh/tJDP6s=;
	b=gWRzA7OkaHAdkEia7WT+t50M9eoelBT9l9lveCoyHKs1hcZFyucj8sy2jCOaeZjKppTH
	 SlOTq3MJIREUbQqt2Oc33T6/v4uIpBmVAHAMTavzk+mZI3n+m58lKqx3eXIBe0rq6L19i
	 /YdamMbX4OwblX915brVRvuVBN70OFll6j3FFzUytZyowfPZlxhPUu5Zlbjza1PkW0v3q
	 IIwSwfd7zBFzI+OJTLamuXrJedWqODE59/zR0RDrJUiYkFtnjYV5ORjXxVnwj4Satjmco
	 SoV9hnVdwiX5COsmKaEVDw9cBONn1codPLux0utoGnJ0TxjJWBhW0WcbqYTnVsz0bvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YHOZZjQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92810606A31C;
	Wed, 18 Nov 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHOZZjQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75B41F000C8;
	Wed, 18 Nov 2026 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018848;
	bh=1m6OoMavc4uKEmX3ZsrzSWZWWmprhSXrPxoh/tJDP6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHOZZjQ/1B/5++wA0MkFCYUPz5rckq97C854zVwHxyzzgHhOpKhsjIk0RNisppz1y
	 xAYgJMNbKChaQs6i+PXw+ua93KqvGPryLCM60icscWCNRvNL5F2WdBa7H/+AYg+U2v
	 kHZh5lcSVYjSGcbXbw7jONNzQA2h3PE1ioQY8NQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1385/2651] rust: bitmap: document panics in `next_bit` and `next_zero_bit`
Date: Wed, 18 Nov 2026 15:43:45 +0100
Message-ID: <20261118150337.879129214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgios Androutsopoulos <georgeandrout13@gmail.com>

[ Upstream commit a73b4d1fa7d334a5f7de5bb0a14726530f66196e ]

`next_bit()` and `next_zero_bit()` use `bitmap_assert!()` to check
that `start` is less than `self.len()`, which panics when
`CONFIG_RUST_BITMAP_HARDENED` is enabled. However, neither function
has a `# Panics` section, and both document that `None` is returned
for exactly the input that triggers the panic.

Update the documentation of `next_bit()` and `next_zero_bit()` to add
the missing `# Panics` sections, add the missing blank doc comment line
before `Returns` in `next_zero_bit()`, and simplify the wording.

Fixes: 11eca92a2cae ("rust: add bitmap API.")
Closes: https://github.com/Rust-for-Linux/linux/issues/1252
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bitmap.rs | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index 053821fff74b7..4b4c6fef41257 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -487,7 +487,13 @@ pub fn last_bit(&self) -> Option<usize> {
 
     /// Finds next set bit, starting from `start`.
     ///
-    /// Returns `None` if `start` is greater or equal to `self.nbits`.
+    /// Returns `None` if no bits are set on or after the given index. The
+    /// index `start` must be in bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `start` is
+    /// out of bounds.
     #[inline]
     pub fn next_bit(&self, start: usize) -> Option<usize> {
         bitmap_assert!(
@@ -507,7 +513,14 @@ pub fn next_bit(&self, start: usize) -> Option<usize> {
     }
 
     /// Finds next zero bit, starting from `start`.
-    /// Returns `None` if `start` is greater than or equal to `self.len()`.
+    ///
+    /// Returns `None` if no bits are zero on or after the given index. The
+    /// index `start` must be in bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `start` is
+    /// out of bounds.
     #[inline]
     pub fn next_zero_bit(&self, start: usize) -> Option<usize> {
         bitmap_assert!(
-- 
2.53.0



