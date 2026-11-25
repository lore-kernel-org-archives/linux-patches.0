Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625331;
	b=as16lntukfP+7YEdYXqN0Wa5sp/Ar19HllifmnFlrBtlfY2pW2F3sdUy2nEZYQY3WSw1
	 Cp5HZDq4WTjdpLrIoDgq29IPsbbz18t4u3dp/8Ui/skw8FpOh8ZL8HIyjCHR1mZJ1Va0e
	 1231ElPK9boiC6yN6n/9Byse7CVIFrx/RC0ld+mlH3imSXHB4NGHoK6OVHyITDGidChQ3
	 UNiE/JkQPr9sC+OwbTv27US7XZpx4sHZDh36nvWJMd6fHmtdR4Y45kJ93c8OF5Qxf96QB
	 z9ks5Qijent3J1e1S/eY8UNOFcB/VVk+GslbfgDb1zVqt2+i6Fu4MftBeanAAGzLJTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7m9sUEDd6+ImqsGYjmH2hBD8DK+2vjT7NyqMdpgxqdg=;
	b=r3r0FjzT7ATO6Xh2x6+4Mt+Bm2Vi8qqYqaHdIkLOfQoxrND1cGjJ90YJ0Uq7JkKbMeNO
	 +x5+UVceTOHMqLmXY2+HpPh6rf4A4hLSZ40reioP930ba3yzSNTyyJ5qna83HnpefLXrV
	 FyQTG8s3wSwDXvoPIR8iuWJaBqfG4+peJ0jvCYK9YozhAw0XrNCW7Ey2rEbdUegaM3Rh3
	 D49/dm2iJ6+/Qp7HloUgN72LpH21Hf0DKrDvB96ZhdpHIEj5tPM+MO33ivHlYDGfaFMn/
	 yS8+QH5mKf0ophjEm25xxTt2RBYSGESfPoZL56iJ/6Ed2dqzEvowqpMe0i6Z+0TlJPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s60PX4ZM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96752606A31E;
	Wed, 25 Nov 2026 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s60PX4ZM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A281F000C6;
	Wed, 25 Nov 2026 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625331;
	bh=7m9sUEDd6+ImqsGYjmH2hBD8DK+2vjT7NyqMdpgxqdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s60PX4ZMIVfmXLT5gjmhvdnpRfUQejZnxxdjtGFnOZyVSh3YBuPIeMkXYcgr2h1zQ
	 bf/wBGU3mvDPXtAqZbE3LRh9sfhaStSeIOTpZFKIjf6BNgJIb7yyWz1uzTKrjE5C/9
	 oXLqxbCj1AgUrNbwATt10C7sWRW+Cg8F0p4j8uhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/816] dmaengine: ste_dma40: Preserve the LCPA I/O address space
Date: Wed, 25 Nov 2026 15:33:50 +0100
Message-ID: <20261125143900.352553021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c83eb05faa16..6699689deecae 100644
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



