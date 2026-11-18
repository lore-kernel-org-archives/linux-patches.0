Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024336;
	b=cpxiZTy64SpWUK/6NnhInGDGaeCo2ZbOqAeZeo/Xh+VmELycaTvDnFThdBdu9PAWtwof
	 ztoQKpfToZ8IQlHQrOLUKoGEJzLW4fg7p8FBqZ6brBFvy++BGj9iGBkt9d2YZpHKMSfFA
	 VzHhrdSY1DQg/j3r0vRv7G01box9kD5t8psykpFE6zkfCC397Vgyf7lzEri3RNWbhxvbg
	 3wb+7xrgn0dNkkj54OJL4gsoWqujabIkZBltHIC9ZYLHvrU/svlMzJghu2bisRUxI4pI3
	 hhjnJTGhZMbmOXu9QIMchVh/y6jZR6hRQ2gbRdSFh6KXnc8LBNe1s3cAkFgmFoVGd8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n47GjVk1gephpnWyCS0uQh9+axFczxWJT/B+5hIgwXE=;
	b=MK4wbWjFst0PyrsA4GZpvjWIwOakbOea7zEeI2KpSIpsMrZnMfrgyan+8owaDEcbc7oj
	 DEeei25X6cqOiN/QnbNHP/LhXix2+hc07QKxlpHAZjduNR54WNWUhWkZEDnV1PvLVWZoA
	 W8wsD/DkQvUd7IKgVxquhZhgPxApghyQRFXYeY69nXukuz6WSG4cSFJ+5qVQx3jHQMgd7
	 tTajNfHe2Fy/jXrPHgXGj1nqHgL7ed4QKZzCbAgOqqI6wDLg1ix2ULd3v+tKOtFwWG6qj
	 gIE4xLp8v9wUSJldhfbpzba9rMdoU1J9Exv3/B+HqEMRoerbJXpLwrNq0dFxGNnE8bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8MTgS54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A92360A2628;
	Wed, 18 Nov 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8MTgS54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1561F000C5;
	Wed, 18 Nov 2026 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024336;
	bh=n47GjVk1gephpnWyCS0uQh9+axFczxWJT/B+5hIgwXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8MTgS54SVvfxtvAtxCwqbFhuW7HRFKZafuScyE8PRZX5HtAMIM3cKb/U4YzHvT1z
	 EEt418buwXDjdOnLUeb/j9XB2wVWb63rC+kxMOik20rGZQEOmUKkIrSXqHtUmFcdX5
	 SZPuE7lKr+B567t+rzm/5HVBIuTjqK59Krrkh5VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Kloiber <kernel@matt3o12.de>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0687/2151] rust: scatterlist: honor the devices maximum segment size
Date: Wed, 18 Nov 2026 15:40:22 +0100
Message-ID: <20261118150146.818386252@linuxfoundation.org>
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

From: Matteo Kloiber <kernel@matt3o12.de>

[ Upstream commit c15c5befd6d6150e92ab7c6c7fde1088e0f543e6 ]

SGTable::new() caps segment length at dma_max_mapping_size() only, which
limits the DMA mapping path (e.g. swiotlb), not the device itself. The
per-device limit from dma_set_max_seg_size() is ignored, so contiguous
page segments can be longer than the declared max segment size,
potentially causing problems for future drivers that use this
abstraction.

Fixes: 05aa6fb1c21d ("rust: scatterlist: Add abstraction for sg_table")
Signed-off-by: Matteo Kloiber <kernel@matt3o12.de>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260913210828.125655-3-kernel@matt3o12.de
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/helpers/dma.c         |  5 +++++
 rust/kernel/scatterlist.rs | 12 ++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/rust/helpers/dma.c b/rust/helpers/dma.c
index 20413428a4960..7b73f69a1a093 100644
--- a/rust/helpers/dma.c
+++ b/rust/helpers/dma.c
@@ -46,3 +46,8 @@ __rust_helper void rust_helper_dma_set_max_seg_size(struct device *dev,
 {
 	dma_set_max_seg_size(dev, size);
 }
+
+__rust_helper unsigned int rust_helper_dma_get_max_seg_size(struct device *dev)
+{
+	return dma_get_max_seg_size(dev);
+}
diff --git a/rust/kernel/scatterlist.rs b/rust/kernel/scatterlist.rs
index 9709dff60b5a9..2ae0a438ca3a3 100644
--- a/rust/kernel/scatterlist.rs
+++ b/rust/kernel/scatterlist.rs
@@ -349,15 +349,23 @@ fn new(
             page_vec.push(page.as_ptr(), flags)?;
         }
 
+        // Cap segments at both the DMA mapping-path limit and the device's declared
+        // max segment size.
+        //
         // `dma_max_mapping_size` returns `size_t`, but `sg_alloc_table_from_pages_segment()` takes
         // an `unsigned int`.
         //
         // SAFETY: `dev.as_raw()` is a valid pointer to a `struct device`.
-        let max_segment = match unsafe { bindings::dma_max_mapping_size(dev.as_raw()) } {
+        let max_mapping_size = match unsafe { bindings::dma_max_mapping_size(dev.as_raw()) } {
             0 => u32::MAX,
-            max_segment => u32::try_from(max_segment).unwrap_or(u32::MAX),
+            max_mapping_size => u32::try_from(max_mapping_size).unwrap_or(u32::MAX),
         };
 
+        // SAFETY: `dev.as_raw()` is a valid pointer to a `struct device`.
+        let max_seg_size = unsafe { bindings::dma_get_max_seg_size(dev.as_raw()) };
+
+        let max_segment = max_mapping_size.min(max_seg_size);
+
         Ok(try_pin_init!(&this in Self {
             // SAFETY:
             // - `page_vec` is a `KVec` of valid `struct page *` obtained from `pages`.
-- 
2.53.0



