Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97032280CD6;
	Tue, 27 May 2025 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368681; cv=none; b=lIQAG6C3NKv8nclgHc4jx3x25GZXllTkEmvjcHGvHxYh8QRmOYHPPw1uYmGHUaAP4Jkf0VucVqcbkVirXvs0xzh771OZzgqybuKBOOv55cTBp5Yub3B/gHgSr5OFkdco9rVS6bj28YE1nEYa20BmRvTk18f13eYZsBRfASI9L2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368681; c=relaxed/simple;
	bh=wXqauVk2B5YAV5Ye1gxg5MmRod8C08AQwi0IRuzEWeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDB2SlFfqv+QEpCtqYIwCrLZhsZpVEnvNYWxuPXIABwqGtpUGamC6eUZ3MYhZQQ5jLWQ68fuipwlVBnDc7fBesOzXqHAEMWsht5Y6ktR/UeyPqKz6tjvuKPmSh6z9EGakqwdTLoBEST1A2Nz12WBnw6JPgyCsGAcCU0zfFqdilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHJQLGWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHJQLGWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A0EC4CEE9;
	Tue, 27 May 2025 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368681;
	bh=wXqauVk2B5YAV5Ye1gxg5MmRod8C08AQwi0IRuzEWeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHJQLGWS/sFwuGKrGa8/6G5yZ6wviUDEUHr+qNifS06xuG6uJXZUAUYdMB8nHghyA
	 jqZ+HfrpGISNibj1riZpLVcg0JLR7Sf8SuLf/fF0h0qd8zx/1ekwxusNvyzaXl0mZX
	 YIU20NuHpSWcSSZKVeX1bGjfWN78aoQLcbhJfWiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 775/783] drm/xe: Use xe_mmio_read32() to read mtcfg register
Date: Tue, 27 May 2025 18:29:32 +0200
Message-ID: <20250527162544.689976291@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 84b6f8503b29a6cc5a82848253a97c09a95fdf49 ]

The mtcfg register is a 32-bit register and should therefore be
accessed using xe_mmio_read32().

Other 3 changes per codestyle suggestion:
"
xe_mmio.c:83: CHECK: Alignment should match open parenthesis
xe_mmio.c:131: CHECK: Comparison to NULL could be written "!xe->mmio.regs"
xe_mmio.c:315: CHECK: line length of 103 exceeds 100 columns
"

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://lore.kernel.org/r/20250513153010.3464767-1-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d2662cf8f44a68deb6c76ad9f1d9f29dbf7ba601)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index a48f239cad1c5..9c2f60ce0c948 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -76,12 +76,12 @@ static void mmio_multi_tile_setup(struct xe_device *xe, size_t tile_mmio_size)
 		 * is fine as it's going to the root tile's mmio, that's
 		 * guaranteed to be initialized earlier in xe_mmio_init()
 		 */
-		mtcfg = xe_mmio_read64_2x32(mmio, XEHP_MTCFG_ADDR);
+		mtcfg = xe_mmio_read32(mmio, XEHP_MTCFG_ADDR);
 		tile_count = REG_FIELD_GET(TILE_COUNT, mtcfg) + 1;
 
 		if (tile_count < xe->info.tile_count) {
 			drm_info(&xe->drm, "tile_count: %d, reduced_tile_count %d\n",
-					xe->info.tile_count, tile_count);
+				 xe->info.tile_count, tile_count);
 			xe->info.tile_count = tile_count;
 
 			/*
@@ -173,7 +173,7 @@ int xe_mmio_init(struct xe_device *xe)
 	 */
 	xe->mmio.size = pci_resource_len(pdev, GTTMMADR_BAR);
 	xe->mmio.regs = pci_iomap(pdev, GTTMMADR_BAR, 0);
-	if (xe->mmio.regs == NULL) {
+	if (!xe->mmio.regs) {
 		drm_err(&xe->drm, "failed to map registers\n");
 		return -EIO;
 	}
@@ -338,8 +338,8 @@ u64 xe_mmio_read64_2x32(struct xe_mmio *mmio, struct xe_reg reg)
 	return (u64)udw << 32 | ldw;
 }
 
-static int __xe_mmio_wait32(struct xe_mmio *mmio, struct xe_reg reg, u32 mask, u32 val, u32 timeout_us,
-			    u32 *out_val, bool atomic, bool expect_match)
+static int __xe_mmio_wait32(struct xe_mmio *mmio, struct xe_reg reg, u32 mask, u32 val,
+			    u32 timeout_us, u32 *out_val, bool atomic, bool expect_match)
 {
 	ktime_t cur = ktime_get_raw();
 	const ktime_t end = ktime_add_us(cur, timeout_us);
-- 
2.39.5



