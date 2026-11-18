Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056449;
	b=HHvV4bYg1ifmXeO7P1IBye0Q9UAl5WOHJ/ABC2S5EdPIlYMtVpXQvV1kStTnJwXp4Tgc
	 fXlgR/4ACrxP6lpHQ2Iu/KHyPFmXt801RKtAlI/aqLSgA4bi9YqCbq1U0AfSIz2WJOp1Y
	 Ky2y92V2xua0oUQOvdKCFjMuYII1JLTsTsCn1PT94+KdqE/p8mPTDkn79JRDOOB4UeGvG
	 CQhO/5i7mzLrfjD5sHgvMFYykoVUzYTIKs2I30Fa7hI8iTjl5/O1kTe4g/H52aUqG1fAo
	 Lz4zkbFcy7ilhvbbiWmLavR8vx4tAnUNjs/UiyYzsd4AKNERpvvFjjD5fU20M4me/4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RhnwCMqQOeJrKN0XG16pgqtEODpST+iS40HIAjF++Kk=;
	b=0xAr9tqp1VNOu3+Qo3AroLScvoN44sES8ZqqJnjBMr2DWnrujCPYK/rHovG72jCvTnKr
	 F79CJrTXTyTSTnGmhNB+05z/+71uFapT5zd2yPd3Xu8oZKEcGRWdER7Q9LGvR4QKnapz9
	 ifm3CPyClU/WqV6TmNVhPpRvYi1MT5PQhLLK7j8xzzPkgKEtfhsFVArK1rTQVlAv/b23c
	 jUEuAbjdG0uv4NaDLn1DX20hDTCEyqTWgYlfpGJifrQGNjlKs2PQPEfmgj0A7f3h9r/TH
	 Po2B5gUZTKYsR7iTJM/RQnhvp+SvD/YO0L466HPH3qpsglsv08qRW9IwLakQLANAGBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiEDKJJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8850F606A320;
	Thu, 19 Nov 2026 02:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiEDKJJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94C81F000C4;
	Thu, 19 Nov 2026 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056449;
	bh=RhnwCMqQOeJrKN0XG16pgqtEODpST+iS40HIAjF++Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiEDKJJFfRlI7NSJTb6YJW9fY1cilTLJdbSsy+Ya6Vj+0gmouZCzR7ZY73gLpQIzo
	 OpaKH61zcIde18Xz28d7EUNACYeMR3bNY4EEH6aL2x15sr/S1FMJnj+Td/6BJSM/Se
	 xmiKLldtr2V9uVuUj/l62OThh+AtKNfqcRlZ26bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1951/2214] irqchip/gic-v3-its: Give the percpu rdist struct its own flags field
Date: Wed, 18 Nov 2026 16:00:27 +0100
Message-ID: <20261118150129.038510022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit c0cdc89072a3e1ae3981437f385de14b7bba8fd8 ]

Later patches will require tracking some per-rdist status. Reuse the bytes
"lost" to padding within the __percpu rdist struct as a flags field, and
re-encode ->lpi_enabled within said flags.

No change in functionality intended.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211027151506.2085066-2-valentin.schneider@arm.com
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 8 +++++---
 include/linux/irqchip/arm-gic-v3.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 450f9860c4557..92dd132c86fa0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -46,6 +46,8 @@
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
 #define RDIST_FLAGS_RD_TABLES_PREALLOCATED	(1 << 1)
 
+#define RD_LOCAL_LPI_ENABLED                    BIT(0)
+
 static u32 lpi_id_bits;
 
 /*
@@ -3086,7 +3088,7 @@ static void its_cpu_init_lpis(void)
 	phys_addr_t paddr;
 	u64 val, tmp;
 
-	if (gic_data_rdist()->lpi_enabled)
+	if (gic_data_rdist()->flags & RD_LOCAL_LPI_ENABLED)
 		return;
 
 	val = readl_relaxed(rbase + GICR_CTLR);
@@ -3200,7 +3202,7 @@ static void its_cpu_init_lpis(void)
 	/* Make sure the GIC has seen the above */
 	dsb(sy);
 out:
-	gic_data_rdist()->lpi_enabled = true;
+	gic_data_rdist()->flags |= RD_LOCAL_LPI_ENABLED;
 	pr_info("GICv3: CPU%d: using %s LPI pending table @%pa\n",
 		smp_processor_id(),
 		gic_data_rdist()->pend_page ? "allocated" : "reserved",
@@ -5189,7 +5191,7 @@ static int redist_disable_lpis(void)
 	 *
 	 * If running with preallocated tables, there is nothing to do.
 	 */
-	if (gic_data_rdist()->lpi_enabled ||
+	if ((gic_data_rdist()->flags & RD_LOCAL_LPI_ENABLED) ||
 	    (gic_rdists->flags & RDIST_FLAGS_RD_TABLES_PREALLOCATED))
 		return 0;
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c55180f1cf811..599dbb519d4d3 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -616,7 +616,7 @@ struct rdists {
 		void __iomem	*rd_base;
 		struct page	*pend_page;
 		phys_addr_t	phys_base;
-		bool		lpi_enabled;
+		u64             flags;
 		cpumask_t	*vpe_table_mask;
 		void		*vpe_l1_base;
 	} __percpu		*rdist;
-- 
2.53.0



