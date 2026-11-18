Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017143;
	b=Hbyz0vhxAP03NYwrT6owvibK935f5G4YVV9Lj7AqBphRHY0H7oEAqmowMoGbiwuiHu3s
	 6V3+wYPZL2InxBRejptDmCRCR6b0z65EQLOuf8izAxW4G4ZYynKXAh5d7lxqhgxqd/Ece
	 gWqX+OpH49pXiOAWqnhEb0bwKo3bP+LVWWUICkxPqe7SW2Yu7mW3HwN4LDN+XrUppUTPI
	 L+LrgpXcoaq4M092aZMajOw77dyLtJV4DzbrRri4c3z/447cpQ4dEJISCWs9BN3h7QsG2
	 69wifNj2kNDFkWc15X/UlMDfFOohbT2xBZEln487jxuCN3HJlqyDOVfvXKsgKtDyvmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Wp9+1ecCBY/OYmw3V2sIgrF0FhdXb+kUrj/AHgEI3U=;
	b=sHb/4hwwbpOc7Bh1KpterDGVbthkjU+F+J6jDdK86eKZdToHn0NBULXhJjlLBShfZqk9
	 Cmge7gWKZiBtSGE0H82YPJ6RGozXAJjfBrwJotMDkJTdpOcEtlbUJ8S/NmKKeD4sZh6xM
	 Az2SDBiF2rpcnnDQZgKG/Rc47jSV1BD9h8iMlGNJYZOsWoi9bEFPLTNg0guLTlQh7ulZt
	 p1d+h41TfeXpzOvjEb0TZHFN8O+qYPsMgr9Q9XFkNZbmCNcz1YlK1oL0+MVanJ71XhhY7
	 BqGllE/4eC8jqTvT2C358PFiJw82YeYca0ZF4vhZm7uXYcOYN69M+oWb1yZYNDY633A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXIRFNFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F9606A338;
	Wed, 18 Nov 2026 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXIRFNFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A291F000C5;
	Wed, 18 Nov 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017143;
	bh=5Wp9+1ecCBY/OYmw3V2sIgrF0FhdXb+kUrj/AHgEI3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXIRFNFigY3aCOTqXmo3d+Qi3DJel3tPUTdPjOf9/xc8VMyQzBWzwg4lBaFtEB8OS
	 E9mCqKQlYtTtqOSP7MZ7wnqOVuPwuVxZbxtfTCp8NEoM3pRyWTO3ZnlVlrzYbdlNvX
	 ImWEX9wrF0/Uxn0B+Counhk9lKpn+gIZetseqP40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Kloiber <kernel@matt3o12.de>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0777/2651] rust: scatterlist: honor the devices maximum segment size
Date: Wed, 18 Nov 2026 15:33:37 +0100
Message-ID: <20261118150315.863750962@linuxfoundation.org>
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
index 9fbeb507b08c6..ff8f24dae9df4 100644
--- a/rust/helpers/dma.c
+++ b/rust/helpers/dma.c
@@ -49,3 +49,8 @@ __rust_helper void rust_helper_dma_set_max_seg_size(struct device *dev,
 {
 	dma_set_max_seg_size(dev, size);
 }
+
+__rust_helper unsigned int rust_helper_dma_get_max_seg_size(struct device *dev)
+{
+	return dma_get_max_seg_size(dev);
+}
diff --git a/rust/kernel/scatterlist.rs b/rust/kernel/scatterlist.rs
index b83c468b5c633..44eeafed05e39 100644
--- a/rust/kernel/scatterlist.rs
+++ b/rust/kernel/scatterlist.rs
@@ -350,15 +350,23 @@ fn new(
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



