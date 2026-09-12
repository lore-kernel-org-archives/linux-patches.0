Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C440403B0C;
	Sat, 12 Sep 2026 08:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202170; cv=none; b=Tmoe8pwFLq4zEE/0RTMzg57o9nb8nxAlXnRAmsX8O7OiguUx7pSf3bgn0s/cs98p21klBTccjCkCIblpxgdh0ildLwzjZktH/MJZJVrL2heWivyXAZ6hpvd4AizeBxD+qZhrHD6MDmeGPgIbb0T+nNExeYyJC8hf4K/ysUwKawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202170; c=relaxed/simple;
	bh=W63hKz3LGRM3iCBck2wq9HLLBhXBaxVh1mqjF3tD7Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJfuUoZbz4t7Z3ctA7zmUvoEIj/vg9l5xkn+0iyW+g1F02O36OR8qKRs29SyqBBD8bP4UC8CsiwurGXK+N72kQExRIh9PmwdmsdDpLbeBFufbmMtWYYrt8dynHUecwgBV3WY4x1sfr4gdcjnqgXlJt0F1plP0Fz+8YCLMP9gNdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OiX2+RD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OiX2+RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70B61F000FF;
	Sat, 12 Sep 2026 08:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202168;
	bh=+8LvbQHSxmJQxIaISry5fQj0Oj0vDwKq0pFFJEoicJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OiX2+RDojAqKNDtWYZH+YWV54RVJqgyNod1IF/u9zYMv6KsesIMdUHrJJKhTqr4C
	 XAidxoDYV2voLfDF6abT5tv67KNMxypECv3XAADozO34KdT/n8YLOWuYYl7ynTw66Q
	 hK+3SwGWseVeJY1GU/EOokG73QOsljq6jkhZ3aNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1094/1815] gpu: nova-core: clean up FSP FRTS comments
Date: Sat, 12 Sep 2026 08:47:24 +0200
Message-ID: <20260912065714.703735622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 848bf57e98e1678ce7a49eb4e0bf0502da95dc07 ]

Two comments in the FSP Chain of Trust message setup had drifted from
the code. One referred to a variable name that no longer exists, and
another described the unused sysmem FRTS fields as future work rather
than explaining why they are zero. Update both to describe the code as
it stands.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260603235034.131354-3-jhubbard@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Stable-dep-of: 5c9deba5578d ("gpu: nova-core: correct FRTS vidmem offset calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/fsp.rs | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/nova-core/fsp.rs b/drivers/gpu/nova-core/fsp.rs
index 78b90bfbfba4a..d2141b5450573 100644
--- a/drivers/gpu/nova-core/fsp.rs
+++ b/drivers/gpu/nova-core/fsp.rs
@@ -132,7 +132,8 @@ impl FspCotMessage {
         fsp_fw: &'a FspFirmware,
         args: &'a FmcBootArgs,
     ) -> Result<impl Init<Self> + 'a> {
-        // frts_offset is relative to FB end: FRTS_location = FB_END - frts_offset
+        // frts_vidmem_offset is measured from the end of FB, so FRTS sits at
+        // (end of FB) - frts_vidmem_offset.
         let frts_vidmem_offset = if !args.resume {
             let frts_reserved_size = fb_layout.heap.len() + u64::from(fb_layout.pmu_reserved_size);
 
@@ -164,8 +165,8 @@ impl FspCotMessage {
             msg.cot.gsp_fmc_sysmem_offset = fsp_fw.fmc_image.dma_handle();
             msg.cot.frts_vidmem_offset = frts_vidmem_offset;
             msg.cot.frts_vidmem_size = frts_size;
-            // frts_sysmem_* intentionally left at zero for now, but will be needed for e.g.
-            // systems without VRAM.
+            // frts_sysmem_* are left at zero because this path places FRTS in vidmem. The sysmem
+            // fields point to an FRTS buffer in sysmem instead, for systems without VRAM.
             msg.cot.gsp_boot_args_sysmem_offset = args.fmc_boot_params.dma_handle();
             msg.cot.sigs = *fsp_fw.fmc_sigs;
 
-- 
2.53.0



