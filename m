Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85784481A6;
	Mon,  8 Apr 2024 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582976; cv=none; b=eCUitaAIf91/WWUUsGgueD0LVFfor7BDOG7/1Y0+5UknTIDsiEqjcbvOCfgXfz6qhATjK0gOq4eUJ746L47CJmHxI72UapE0lQdYwe3MJ4KerSijVanxvS8yrPfhDhKv6FGih6HK/P3U4UGLlDwNPJzas7FgS7IqAZ815HGVVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582976; c=relaxed/simple;
	bh=40tCne+Vum/hZREoJ+CAKf1M+GxUNNTCUpDJdu3PzhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkWdcJUuqYbtyTEQjfaQs5NfT5EffCUuXdBQdvxvqB1O9h5Jut5l6xcd29VDtiBoNPmHTW/I0BXpXA4G5SC88G4+F0zxHmfneyGzVsKAVoeJoVopDLvTghweaUZpbezpPgyuMCVYWOe62KrDSlXsNtdudGyh+MCaV08cqeFdns4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ne1dYlA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ne1dYlA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E804C433C7;
	Mon,  8 Apr 2024 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582976;
	bh=40tCne+Vum/hZREoJ+CAKf1M+GxUNNTCUpDJdu3PzhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne1dYlA893tegCsdrDKNaGKY1BUUO9SIlWCdyoE9tefIh4Mlx/WtSaTvrB03p1+c8
	 DHAeyPI1RPFBZ37IECs1isKvnVmgm4MRcaol9w1DyVkRJ7WckjtNAsWncEC3H6yi4J
	 THfmK6szLHIGMUDFTbfTTFW4OZCETq3u4klJcpTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 144/252] i40e: Simplify memory allocation functions
Date: Mon,  8 Apr 2024 14:57:23 +0200
Message-ID: <20240408125311.121592103@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit d3276f928a1d2dfebc41a82e967cd0dffeb540f8 ]

Enum i40e_memory_type enum is unused in i40e_allocate_dma_mem() thus
can be safely removed. Useless macros in i40e_alloc.h can be removed
as well.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  4 ----
 drivers/net/ethernet/intel/i40e/i40e_alloc.h  | 14 -------------
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    | 12 ++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 +++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  |  7 -------
 5 files changed, 14 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 100eb77b8dfe6..e72cfe587c89e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -51,7 +51,6 @@ static int i40e_alloc_adminq_asq_ring(struct i40e_hw *hw)
 	int ret_code;
 
 	ret_code = i40e_allocate_dma_mem(hw, &hw->aq.asq.desc_buf,
-					 i40e_mem_atq_ring,
 					 (hw->aq.num_asq_entries *
 					 sizeof(struct i40e_aq_desc)),
 					 I40E_ADMINQ_DESC_ALIGNMENT);
@@ -78,7 +77,6 @@ static int i40e_alloc_adminq_arq_ring(struct i40e_hw *hw)
 	int ret_code;
 
 	ret_code = i40e_allocate_dma_mem(hw, &hw->aq.arq.desc_buf,
-					 i40e_mem_arq_ring,
 					 (hw->aq.num_arq_entries *
 					 sizeof(struct i40e_aq_desc)),
 					 I40E_ADMINQ_DESC_ALIGNMENT);
@@ -136,7 +134,6 @@ static int i40e_alloc_arq_bufs(struct i40e_hw *hw)
 	for (i = 0; i < hw->aq.num_arq_entries; i++) {
 		bi = &hw->aq.arq.r.arq_bi[i];
 		ret_code = i40e_allocate_dma_mem(hw, bi,
-						 i40e_mem_arq_buf,
 						 hw->aq.arq_buf_size,
 						 I40E_ADMINQ_DESC_ALIGNMENT);
 		if (ret_code)
@@ -198,7 +195,6 @@ static int i40e_alloc_asq_bufs(struct i40e_hw *hw)
 	for (i = 0; i < hw->aq.num_asq_entries; i++) {
 		bi = &hw->aq.asq.r.asq_bi[i];
 		ret_code = i40e_allocate_dma_mem(hw, bi,
-						 i40e_mem_asq_buf,
 						 hw->aq.asq_buf_size,
 						 I40E_ADMINQ_DESC_ALIGNMENT);
 		if (ret_code)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_alloc.h b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
index a6c9a9e343d11..4b2d8da048c64 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
@@ -6,23 +6,9 @@
 
 struct i40e_hw;
 
-/* Memory allocation types */
-enum i40e_memory_type {
-	i40e_mem_arq_buf = 0,		/* ARQ indirect command buffer */
-	i40e_mem_asq_buf = 1,
-	i40e_mem_atq_buf = 2,		/* ATQ indirect command buffer */
-	i40e_mem_arq_ring = 3,		/* ARQ descriptor ring */
-	i40e_mem_atq_ring = 4,		/* ATQ descriptor ring */
-	i40e_mem_pd = 5,		/* Page Descriptor */
-	i40e_mem_bp = 6,		/* Backing Page - 4KB */
-	i40e_mem_bp_jumbo = 7,		/* Backing Page - > 4KB */
-	i40e_mem_reserved
-};
-
 /* prototype for functions used for dynamic memory allocation */
 int i40e_allocate_dma_mem(struct i40e_hw *hw,
 			  struct i40e_dma_mem *mem,
-			  enum i40e_memory_type type,
 			  u64 size, u32 alignment);
 int i40e_free_dma_mem(struct i40e_hw *hw,
 		      struct i40e_dma_mem *mem);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
index 96ee63aca7a10..7451d346ae83f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -22,7 +22,6 @@ int i40e_add_sd_table_entry(struct i40e_hw *hw,
 			    enum i40e_sd_entry_type type,
 			    u64 direct_mode_sz)
 {
-	enum i40e_memory_type mem_type __attribute__((unused));
 	struct i40e_hmc_sd_entry *sd_entry;
 	bool dma_mem_alloc_done = false;
 	struct i40e_dma_mem mem;
@@ -43,16 +42,13 @@ int i40e_add_sd_table_entry(struct i40e_hw *hw,
 
 	sd_entry = &hmc_info->sd_table.sd_entry[sd_index];
 	if (!sd_entry->valid) {
-		if (I40E_SD_TYPE_PAGED == type) {
-			mem_type = i40e_mem_pd;
+		if (type == I40E_SD_TYPE_PAGED)
 			alloc_len = I40E_HMC_PAGED_BP_SIZE;
-		} else {
-			mem_type = i40e_mem_bp_jumbo;
+		else
 			alloc_len = direct_mode_sz;
-		}
 
 		/* allocate a 4K pd page or 2M backing page */
-		ret_code = i40e_allocate_dma_mem(hw, &mem, mem_type, alloc_len,
+		ret_code = i40e_allocate_dma_mem(hw, &mem, alloc_len,
 						 I40E_HMC_PD_BP_BUF_ALIGNMENT);
 		if (ret_code)
 			goto exit;
@@ -140,7 +136,7 @@ int i40e_add_pd_table_entry(struct i40e_hw *hw,
 			page = rsrc_pg;
 		} else {
 			/* allocate a 4K backing page */
-			ret_code = i40e_allocate_dma_mem(hw, page, i40e_mem_bp,
+			ret_code = i40e_allocate_dma_mem(hw, page,
 						I40E_HMC_PAGED_BP_SIZE,
 						I40E_HMC_PD_BP_BUF_ALIGNMENT);
 			if (ret_code)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 17ab6a1c53971..46b7a428808a8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -137,14 +137,14 @@ struct device *i40e_hw_to_dev(struct i40e_hw *hw)
 }
 
 /**
- * i40e_allocate_dma_mem_d - OS specific memory alloc for shared code
+ * i40e_allocate_dma_mem - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to fill out
  * @size: size of memory requested
  * @alignment: what to align the allocation to
  **/
-int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
-			    u64 size, u32 alignment)
+int i40e_allocate_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem,
+			  u64 size, u32 alignment)
 {
 	struct i40e_pf *pf = i40e_hw_to_pf(hw);
 
@@ -158,11 +158,11 @@ int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
 }
 
 /**
- * i40e_free_dma_mem_d - OS specific memory free for shared code
+ * i40e_free_dma_mem - OS specific memory free for shared code
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
+int i40e_free_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem)
 {
 	struct i40e_pf *pf = i40e_hw_to_pf(hw);
 
@@ -175,13 +175,13 @@ int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
 }
 
 /**
- * i40e_allocate_virt_mem_d - OS specific memory alloc for shared code
+ * i40e_allocate_virt_mem - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to fill out
  * @size: size of memory requested
  **/
-int i40e_allocate_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem,
-			     u32 size)
+int i40e_allocate_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem,
+			   u32 size)
 {
 	mem->size = size;
 	mem->va = kzalloc(size, GFP_KERNEL);
@@ -193,11 +193,11 @@ int i40e_allocate_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem,
 }
 
 /**
- * i40e_free_virt_mem_d - OS specific memory free for shared code
+ * i40e_free_virt_mem - OS specific memory free for shared code
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-int i40e_free_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem)
+int i40e_free_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem)
 {
 	/* it's ok to kfree a NULL pointer */
 	kfree(mem->va);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index 997569a4ad57b..70cac3bb31ec3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -36,18 +36,11 @@ struct i40e_dma_mem {
 	u32 size;
 };
 
-#define i40e_allocate_dma_mem(h, m, unused, s, a) \
-			i40e_allocate_dma_mem_d(h, m, s, a)
-#define i40e_free_dma_mem(h, m) i40e_free_dma_mem_d(h, m)
-
 struct i40e_virt_mem {
 	void *va;
 	u32 size;
 };
 
-#define i40e_allocate_virt_mem(h, m, s) i40e_allocate_virt_mem_d(h, m, s)
-#define i40e_free_virt_mem(h, m) i40e_free_virt_mem_d(h, m)
-
 #define i40e_debug(h, m, s, ...)				\
 do {								\
 	if (((m) & (h)->debug_mask))				\
-- 
2.43.0



