Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E139C276037;
	Tue, 27 May 2025 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366312; cv=none; b=UXyeANrwRVQ2PVOhyU36MVHNRRUUaYhRuRYg1DhXA2dD1ovUTd4WG71ECy3I74JusTVdk6Sp+ND9ezhgEA3GCtlbnZVFJU3qmSkJLqnCSiRhb7GZQgIR8N92ytod0qEO61CQ8vfv72Y3sts8to8ZTSWGwHY6fPZG+dmQelBfpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366312; c=relaxed/simple;
	bh=Dw1J+AKLFH/fI3dkSs1MYvNUCiojqlOIkcVQeMXRSTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9j/vm9XR0l8k3A7XXgrrl4hegUhLAM6R6PYmDhLzOZCD3WLv+DasivIbCv82XwZ1nzL98z2BcT1O3ZArZIgdkfnFEEecGpZ+v6kKyu9iGAtyQpixPa7fyUJDy+eqI0I8Zgew8vlOxB6tlSaRYoLKwKqHOE4xrA8+Pvce9ehNoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7uyj9Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7uyj9Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAF8C4CEE9;
	Tue, 27 May 2025 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366311;
	bh=Dw1J+AKLFH/fI3dkSs1MYvNUCiojqlOIkcVQeMXRSTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7uyj9WpbNUUzfbzAMvX9a3V6dU01MD2d0yW5iJ4Fhy8ENcepa+Ea28fySbGYJ46F
	 Zw7q4seP4jutvMNRH+IoMj0g8UXNnES3g98jc6j/VD/kRpTh73ERXPnwmsUJUDvBe4
	 tvmOb0UfnlQEHp/7fI455yU1ma/vnklGq3Z59mLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	kernel test robot <lkp@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 028/783] dma-mapping: Fix warning reported for missing prototype
Date: Tue, 27 May 2025 18:17:05 +0200
Message-ID: <20250527162514.261631314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

[ Upstream commit cae5572ec9261f752af834cdaaf5a0ba0afcf256 ]

lkp reported a warning about missing prototype for a recent patch.

The kernel-doc style comments are out of sync, move them to the right
function.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504190615.g9fANxHw-lkp@intel.com/

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
[mszyprow: reformatted subject]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250422114034.3535515-1-balbirs@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 67da08fa67237..051a32988040f 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -910,14 +910,6 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_coherent_mask);
 
-/**
- * dma_addressing_limited - return if the device is addressing limited
- * @dev:	device to check
- *
- * Return %true if the devices DMA mask is too small to address all memory in
- * the system, else %false.  Lack of addressing bits is the prime reason for
- * bounce buffering, but might not be the only one.
- */
 static bool __dma_addressing_limited(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
@@ -931,6 +923,14 @@ static bool __dma_addressing_limited(struct device *dev)
 	return !dma_direct_all_ram_mapped(dev);
 }
 
+/**
+ * dma_addressing_limited - return if the device is addressing limited
+ * @dev:	device to check
+ *
+ * Return %true if the devices DMA mask is too small to address all memory in
+ * the system, else %false.  Lack of addressing bits is the prime reason for
+ * bounce buffering, but might not be the only one.
+ */
 bool dma_addressing_limited(struct device *dev)
 {
 	if (!__dma_addressing_limited(dev))
-- 
2.39.5



