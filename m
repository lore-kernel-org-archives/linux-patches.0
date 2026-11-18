Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061744;
	b=UHKFccHdyUe2MCf53/VmcWQkdGCGr//tKDbtdy18gZnFBcnYs6bFM6enNp1tnYSUtdXG
	 NtLNSvP2HajXqwDg7wWW+WS4t7EoZMsUYy2DFGRwr5LhYs1uZtwwo4M882h1BWslZaYV2
	 0TffB3HPoDm7mYXIJybr0LoarhRbgECvSE4DU5JHCq1DRYRD7JcxY1/bU9Zf6lr1jG4RO
	 xkVGv5UvHG3lHNvNzvm/XeLouXEEl2gSUON3/2aR3UUieodOVo5YzbignvkwGkBccY1qc
	 Fo8ANdyM/AxqyxE0AfQJjJfYVw9tGJMSmmIUhlkTbnCmuH8p/A2vFf0h3gn3Xs5yWCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0GbtVOsOXMP6tqpcqk8s5Ae/zNEvUAaSDZsUrETR/I=;
	b=n953Il3B1hzh75FWgzXbNHn1jwNro5Nb+WcExHKATKkB8aqTSf+E3mTznlkwj9u0XKVZ
	 oQFIBAT4VzSC1k2XqBFhQxbIGziFsOlE2Znc7P1/1b4ZMtvE9dwx+yPlmEZ+xC/phUYog
	 bbFG2lvatyp/CpTJ7pfz/2krpkeIQhgGI+LbFIRmqjBRQDj1Oq3+3xz68Cw32RE7eEKTH
	 acumRMPRN2eRaIYKRiHg7umsyENHurh3VA9kYQvIIO1mNWoXbgGe1aUJRtYtnWxqDdLpl
	 YNcddU1k6uLFqwKRY6QDiH/94Pmj8RdnHmbfIIRlolD+6J+XXzzl1TGe/Czw8QQIsSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJ4OiEiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC4606A332;
	Thu, 19 Nov 2026 04:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJ4OiEiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E991F000C4;
	Thu, 19 Nov 2026 04:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061744;
	bh=W0GbtVOsOXMP6tqpcqk8s5Ae/zNEvUAaSDZsUrETR/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJ4OiEiUPjZKXkqJv7SYr+tIloi9P3RrbeqOjsP35dENuFak0mmZWOvZ/yl3NkduB
	 KG6dnwfJqcyDu6HTGGclYozBuenBziJAOIN3KZD/0xIpsOOXXYut1io1VwSOq7u0u/
	 ten8MpwLMjo7Z3LsGY93OuY7LlJ2Zgpf8pXBLICg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1662/1848] irqchip/gic-v3-its: Give the percpu rdist struct its own flags field
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150029.379953508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7740ad6af91bd..805e023a66e4c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -46,6 +46,8 @@
 #define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
 #define RDIST_FLAGS_RD_TABLES_PREALLOCATED	(1 << 1)
 
+#define RD_LOCAL_LPI_ENABLED                    BIT(0)
+
 static u32 lpi_id_bits;
 
 /*
@@ -3071,7 +3073,7 @@ static void its_cpu_init_lpis(void)
 	phys_addr_t paddr;
 	u64 val, tmp;
 
-	if (gic_data_rdist()->lpi_enabled)
+	if (gic_data_rdist()->flags & RD_LOCAL_LPI_ENABLED)
 		return;
 
 	val = readl_relaxed(rbase + GICR_CTLR);
@@ -3185,7 +3187,7 @@ static void its_cpu_init_lpis(void)
 	/* Make sure the GIC has seen the above */
 	dsb(sy);
 out:
-	gic_data_rdist()->lpi_enabled = true;
+	gic_data_rdist()->flags |= RD_LOCAL_LPI_ENABLED;
 	pr_info("GICv3: CPU%d: using %s LPI pending table @%pa\n",
 		smp_processor_id(),
 		gic_data_rdist()->pend_page ? "allocated" : "reserved",
@@ -5162,7 +5164,7 @@ static int redist_disable_lpis(void)
 	 *
 	 * If running with preallocated tables, there is nothing to do.
 	 */
-	if (gic_data_rdist()->lpi_enabled ||
+	if ((gic_data_rdist()->flags & RD_LOCAL_LPI_ENABLED) ||
 	    (gic_rdists->flags & RDIST_FLAGS_RD_TABLES_PREALLOCATED))
 		return 0;
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 4172b0cce6844..6c68836f486a2 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -672,7 +672,7 @@ struct rdists {
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



