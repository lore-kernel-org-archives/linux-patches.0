Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019461;
	b=XD5q5cVjNsuYpBIexj+S54U+IdK+b3pObLOIiNYhWqPkcTYMtsJuhtbxyqSKBi3I92Li
	 5gwq1qeQ2vhf0vvT26NERgUfeECoNlE8JrKdwrGvviTcOHnd9mNodUrekg+jwaW77fWKQ
	 Javxnqc8Lz1erz+ncfWKNoRFN/EA51CXH6nh+Z2A/WxMQVjXQmtcM6awMWBLB9qYlOqjl
	 Nqik52CA0YPTBGUENc6u1p3NyjrPRhLwo374BmHIFSC17HJ3rFkZ+Ay3caEfJOx4Jaj5j
	 hZmI6jIxEeR2XliHGiVhh+vks/0IeXQ/0pxmfUto5jJSfZNEel+3CrhRMhRRjh994CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KqGMsG3w5am7PXgWoSOPG/+SQYK+fphDwHPgXhql0QI=;
	b=kyd8CsCzlIa0fxibD/jKhGS7busbXsq39yX1gVhMdYdDNFBYL88gH4Z6tYuh20/Qfbf0
	 tPTrr20oLMt92wJ0XKxIkXUqCAdLouAmJ8C/5a2eNiiKOxQIam9EmTxhB5d7PLKteVuvB
	 oCyRW4i/4VV3NwgP+Qz18o5Igj1GcruH7KBh8orbNXvkpdBdTIPCdCVuykYthDepzgScI
	 tMQFNfkTnLqIbmeQSs+e9zI5ucGsNL+GTVR5jhucs6P5gpCDxu8IYXSCK+iwcfTyUWk3h
	 o+XjHMWfF4dnkIBvjHr+CUvW5qSS7cRJoiAY6ohcEPprEIQnsuLZRBs6TwKQsV283Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RumUNJ7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574E606A33B;
	Wed, 18 Nov 2026 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RumUNJ7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8CF1F000C4;
	Wed, 18 Nov 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019461;
	bh=KqGMsG3w5am7PXgWoSOPG/+SQYK+fphDwHPgXhql0QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RumUNJ7GGB7yE2cgiYvBOs/fcRzyCYg6A4Pt/WUJz4IeAPGBl5kuVR8hFJRTLZhuz
	 I1EdoUWOABAPtjhIVjd0w4FncS8H8wtEZf802vpVw3Vzfi8oZQdNvLVY0bTMNuY8Nf
	 d/FwBOywcczS+GHCUXJbZLbOjJWfJMnOW+Fnf36o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1603/2651] dmaengine: ste_dma40: Preserve the LCPA I/O address space
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118150345.551831422@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 42c31fec1ca76b8b5f7759def122d418dff2cd4b ]

The LCPA area is mapped with devm_ioremap(), but lcpa_base and the
per-channel lcpa pointer lack __iomem annotations. This loses the I/O
address space and makes sparse warn when d40_current_addr() assigns
LCPA register addresses to its __iomem pointers.

Annotate both pointers and the LCPA argument of d40_log_lli_lcpa_write()
to preserve the I/O address space from the mapping to the register
accessors. This also fixes the existing LCPA read and write warnings
without changing the generated code.

Fixes: c80edceff29e ("dmaengine: ste_dma40: Fix cyclic transfer residue")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610090216.pjMRxhRL-lkp@intel.com/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20261010-dma40-smatch-fix-v1-1-26ca10043957@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c    | 4 ++--
 drivers/dma/ste_dma40_ll.c | 8 ++++----
 drivers/dma/ste_dma40_ll.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c93068fc757bf..4f1af65b46712 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -509,7 +509,7 @@ struct d40_chan {
 	u32				 src_def_cfg;
 	u32				 dst_def_cfg;
 	struct d40_def_lcsp		 log_def;
-	struct d40_log_lli_full		*lcpa;
+	struct d40_log_lli_full __iomem	*lcpa;
 	/* Runtime reconfiguration */
 	dma_addr_t			runtime_addr;
 	enum dma_transfer_direction	runtime_direction;
@@ -617,7 +617,7 @@ struct d40_base {
 	/* Physical half channels */
 	struct d40_phy_res		 *phy_res;
 	struct d40_lcla_pool		  lcla_pool;
-	void				 *lcpa_base;
+	void __iomem			 *lcpa_base;
 	dma_addr_t			  phy_lcpa;
 	resource_size_t			  lcpa_size;
 	struct kmem_cache		 *desc_slab;
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 4c489b126cb27..3be7f5b1abb08 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -333,10 +333,10 @@ static void d40_log_lli_link(struct d40_log_lli *lli_dst,
 		(dlos << D40_MEM_LCSP1_SLOS_POS);
 }
 
-void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
-			   struct d40_log_lli *lli_dst,
-			   struct d40_log_lli *lli_src,
-			   int next, unsigned int flags)
+void d40_log_lli_lcpa_write(struct d40_log_lli_full __iomem *lcpa,
+			    struct d40_log_lli *lli_dst,
+			    struct d40_log_lli *lli_src,
+			    int next, unsigned int flags)
 {
 	d40_log_lli_link(lli_dst, lli_src, next, flags);
 
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 55090cb310579..ca9d076493610 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -455,7 +455,7 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width1, u32 data_width2);
 
-void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
+void d40_log_lli_lcpa_write(struct d40_log_lli_full __iomem *lcpa,
 			    struct d40_log_lli *lli_dst,
 			    struct d40_log_lli *lli_src,
 			    int next, unsigned int flags);
-- 
2.53.0



