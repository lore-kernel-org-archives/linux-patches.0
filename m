Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863F31DF279;
	Wed, 19 Feb 2025 08:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954156; cv=none; b=Eu+ByeNXm9yhrpww39vy+YCJ0W6uP8i0vwvFKNOOPzjfPvgK0oLrPvE41xXgWQbjrskWHwhpxqEAQ1wQ9iED4GnkKLbfJjRj1vvPmt3nbAi8fB/8w5W5dsbrh9fHgpt5xaI3t0klhMDgTu5YrS5537q+gZt8kZMGbnY7CVLK5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954156; c=relaxed/simple;
	bh=aLh1X2GcFY4/yXwkDzPo7jgPtfhT4FWrLUrpRC9ICvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgW9G3whALszlGW2FCyryPpv16n+YDf2T9Y7a9fQfSPSZzh2CeScd8bfBKOSqvLPAvGb3L+8xuhATJ5uUj8QRDKY7vC942EpK7+AOkKgXVl0ezRYurl+op3aPYeM4+oDYDFXOSzentCjyuUbZTlBGEO0flst30EiGUH7joQWxoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deBI+SY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deBI+SY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D6BC4CED1;
	Wed, 19 Feb 2025 08:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954156;
	bh=aLh1X2GcFY4/yXwkDzPo7jgPtfhT4FWrLUrpRC9ICvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deBI+SY5Y5aLLkwhG/Vfcv40hs1WICAxDbAcYCdzAoQsxPuaVjyH6TmTYCvphqo/s
	 5t/akA6CpOh/H++0m54UwMLg9QR4u+O2tphTf4e6zhXpjIteu9sFq4nDYb75yCpP4l
	 WsfJxCdiEywsSnLUejgk4pZDMUBC2mVNqtUfUpz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 115/274] drm/xe: Carve out wopcm portion from the stolen memory
Date: Wed, 19 Feb 2025 09:26:09 +0100
Message-ID: <20250219082614.121732110@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit e977499820782ab1c69f354d9f41b6d9ad1f43d9 upstream.

The top of stolen memory is WOPCM, which shouldn't be accessed. Remove
this portion from the stolen memory region for discrete platforms.
This was already done for integrated, but was missing for discrete
platforms.

This also moves get_wopcm_size() so detect_bar2_dgfx() and
detect_bar2_integrated can use the same function.

v2: Improve commit message and suitable stable version tag(Lucas)

Fixes: d8b52a02cb40 ("drm/xe: Implement stolen memory.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250210143654.2076747-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit 2c7f45cc7e197a792ce5c693e56ea48f60b312da)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c |   54 ++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
@@ -57,12 +57,35 @@ bool xe_ttm_stolen_cpu_access_needs_ggtt
 	return GRAPHICS_VERx100(xe) < 1270 && !IS_DGFX(xe);
 }
 
+static u32 get_wopcm_size(struct xe_device *xe)
+{
+	u32 wopcm_size;
+	u64 val;
+
+	val = xe_mmio_read64_2x32(xe_root_tile_mmio(xe), STOLEN_RESERVED);
+	val = REG_FIELD_GET64(WOPCM_SIZE_MASK, val);
+
+	switch (val) {
+	case 0x5 ... 0x6:
+		val--;
+		fallthrough;
+	case 0x0 ... 0x3:
+		wopcm_size = (1U << val) * SZ_1M;
+		break;
+	default:
+		WARN(1, "Missing case wopcm_size=%llx\n", val);
+		wopcm_size = 0;
+	}
+
+	return wopcm_size;
+}
+
 static s64 detect_bar2_dgfx(struct xe_device *xe, struct xe_ttm_stolen_mgr *mgr)
 {
 	struct xe_tile *tile = xe_device_get_root_tile(xe);
 	struct xe_mmio *mmio = xe_root_tile_mmio(xe);
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
-	u64 stolen_size;
+	u64 stolen_size, wopcm_size;
 	u64 tile_offset;
 	u64 tile_size;
 
@@ -74,7 +97,13 @@ static s64 detect_bar2_dgfx(struct xe_de
 	if (drm_WARN_ON(&xe->drm, tile_size < mgr->stolen_base))
 		return 0;
 
+	/* Carve out the top of DSM as it contains the reserved WOPCM region */
+	wopcm_size = get_wopcm_size(xe);
+	if (drm_WARN_ON(&xe->drm, !wopcm_size))
+		return 0;
+
 	stolen_size = tile_size - mgr->stolen_base;
+	stolen_size -= wopcm_size;
 
 	/* Verify usage fits in the actual resource available */
 	if (mgr->stolen_base + stolen_size <= pci_resource_len(pdev, LMEM_BAR))
@@ -89,29 +118,6 @@ static s64 detect_bar2_dgfx(struct xe_de
 	return ALIGN_DOWN(stolen_size, SZ_1M);
 }
 
-static u32 get_wopcm_size(struct xe_device *xe)
-{
-	u32 wopcm_size;
-	u64 val;
-
-	val = xe_mmio_read64_2x32(xe_root_tile_mmio(xe), STOLEN_RESERVED);
-	val = REG_FIELD_GET64(WOPCM_SIZE_MASK, val);
-
-	switch (val) {
-	case 0x5 ... 0x6:
-		val--;
-		fallthrough;
-	case 0x0 ... 0x3:
-		wopcm_size = (1U << val) * SZ_1M;
-		break;
-	default:
-		WARN(1, "Missing case wopcm_size=%llx\n", val);
-		wopcm_size = 0;
-	}
-
-	return wopcm_size;
-}
-
 static u32 detect_bar2_integrated(struct xe_device *xe, struct xe_ttm_stolen_mgr *mgr)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);


