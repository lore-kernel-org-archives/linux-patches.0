Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018845;
	b=iy9hMJ90JuSBQ/DDtZoOXwm90iztrHde2cpiO5rQoM8MzU6O7addnFmnGtEeUVe+51Kp
	 98hZktw+Wd+GKW7BSFkgfqcNow2XoIpd9Stx6OIKX1WwQviX+TsGc0yc/3ECDXOqQTz0M
	 5XBbv4X6xM5cH4SuYZZzRjAXrNPctpWfoWauRzQS4IqEOgRSnMxAI5Xup1PvCP+IWTREn
	 pqM+bMQ+/goCmBWQmmATjFdyH3x7wUMvfz/2Y6pmTTVq0msCXXB6uynpgXy4BxzWkjjvZ
	 9zIQ1UFhrsNA76gKKy2SISzj6jEJae9VtcNajxJJgjBxtL1uuwSfanj5uH3KFPwwCOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3DDbqIy+n5lEPNolyV5msy0odsjaffA2rXsBZmiP+1A=;
	b=Z7Cpp1r13hrN7TIDKqW+MKhz/ET+MrwliHc7YZPjsUDfKycMD9IbyrNF15Fmupluzjea
	 JR4WlWBOVPYnVqDoXp360ErVX3sM1lytMQK5tHP+oy0PTqnatPgRBUgr97dJlfP5IUniQ
	 +A/VRyOfvtKRwsRsGB0X32TcsjrBHA3IlCCsdFyWffOXQC7YzocBftCIr5rFLcHF/AuJ+
	 lLHdoMF5kPxz4YVTb/9CW7UQpQfHZVOURFLN7QaJPpmw3yixFzmdRahz9JgJbAG078XL1
	 QZsWGcR8Z/pSrVcnwBr+S9Os2uYeJeL34zsmjDLgYQxt1UXRb1tFXH5H7fThUZ+VO4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GHbxO/K+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1017606A31C;
	Wed, 18 Nov 2026 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHbxO/K+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232AD1F000C9;
	Wed, 18 Nov 2026 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018845;
	bh=3DDbqIy+n5lEPNolyV5msy0odsjaffA2rXsBZmiP+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHbxO/K+eTsYQung9yicwt2sGL9GW0j0rgmm8mhhpEUqjDnfe6DHt71rTF1EsivKb
	 z1HH3PD0+G4Ufa1Q/VvBeMhjSpkqr1RMsFk0o6i7AhOyHfmxApAY8dNQ4tfXRJ12vc
	 IfoWwO781bBBNAF1+SJOEyDbeuH3buYVMLcgL3hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1384/2651] rust: id_pool: document panics in `find_unused_id` and `release_id`
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118150337.845172474@linuxfoundation.org>
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
index 384753fe0e44a..c8b3465548027 100644
--- a/rust/kernel/id_pool.rs
+++ b/rust/kernel/id_pool.rs
@@ -224,7 +224,13 @@ pub fn grow(&mut self, mut resizer: PoolResizer) {
     /// Finds an unused ID in the bitmap.
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
     #[must_use]
     pub fn find_unused_id(&mut self, offset: usize) -> Option<UnusedId<'_>> {
@@ -236,6 +242,13 @@ pub fn find_unused_id(&mut self, offset: usize) -> Option<UnusedId<'_>> {
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



