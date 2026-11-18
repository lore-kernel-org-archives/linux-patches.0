Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032665;
	b=YOYiAqr4bImL7ERAUj+ffQlwzePk7Kc0aufMRF8b5lci5zqzDB9IbHoeuHXnKutdyNoE
	 bhVrpXL5ZPiQ9m5r2Z2lAdkRFzH5gFaQ5hnUzT4aFpNIgAvUEoyuYVGhnU0O455HYVE19
	 gl8tUjYlgIT8LOIlBYPXqH3yIF9pFKn3MUUoVQPgPjPpVNkf9ueDXWn9dpDdSVpV1H961
	 2a3Rww4Fic9RbC7qsaZkNjGmyCUe5LhoITcfXIXN7ZPeA7mwrQF7bJqXAvLzPi905JMu6
	 CnAAtFghVxk8m0xawBw1Z7LnD42cpg7x33967VmRE2uXzxWcy1P4xIVRPmlxMubZAig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IE7M6D+bf89MSu1YROAXvuGtnWfFfDWa4PzwAkxOxzU=;
	b=EwMBPfoXgNbN6M48Motoc0KLiI6oKGFaS8VyokI0FuZwnA/youAHqHVOrfD14Q57rz8U
	 ynE8pJ2qzDHi7vl2Ac/lZvTC7VQnMuRJ1CV6IAh9sTXaLmSHlnHhW62W4xYTyAwp3L9rM
	 9vXG0NB7NGF3X5fvplfBAfSsAcb2Um1qEkx5ani4ZPjQU8oklkebQqUNcNuidsSo1ffk3
	 jtR17zg+sp9vaOLHiMI8JGxTmyDztKjyBKv7LswVZb2/ohtU4ajBpCmsVkQHfARLnphYZ
	 lWsafnYh1kahX2SGhvXWhPpolW0d/W0qPuyPTUBBvCjhW1RmE/OyNzEHhnLefcE++3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atypzCUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093E0606A31C;
	Wed, 18 Nov 2026 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=atypzCUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9511F000C4;
	Wed, 18 Nov 2026 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032664;
	bh=IE7M6D+bf89MSu1YROAXvuGtnWfFfDWa4PzwAkxOxzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atypzCUegZWg3fpIBWEFaAZ9soTLhwhZ01c3q7J5ruXY1uWWEapXx5SABjPAPtxSp
	 kwuzUd4L8snURJgKt9P+Xp2TZgUF+OCeYbRpklYGzqTHce3lH+NYUPorPWGH2KO4jL
	 ghTxELl+NDU7lG5gpJpTlNY2F+K5euu6tjE8ieM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1465/1756] net: stmmac: Correct usage of maximum queue number macros
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150107.365490484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 352bc4513ec3907db71cb5674fb93a76fc341ca9 ]

The maximum numbers of each Rx and Tx queues are defined by
MTL_MAX_RX_QUEUES and MTL_MAX_TX_QUEUES respectively.

There are some places where Rx and Tx are used in reverse. There is no
issue when the Tx and Rx macros have the same value, but should correct
usage of macros for maximum queue number to keep consistency and prevent
unexpected mistakes.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://patch.msgid.link/20250221051818.4163678-1-hayashi.kunihiko@socionext.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9dd534187819 ("net: stmmac: Track the TX DMA threshold per queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 03786c7f2b1fc..9881b34416c91 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -101,8 +101,8 @@ struct stmmac_rxq_stats {
 /* Updates on each CPU protected by not allowing nested irqs. */
 struct stmmac_pcpu_stats {
 	struct u64_stats_sync syncp;
-	u64_stats_t rx_normal_irq_n[MTL_MAX_TX_QUEUES];
-	u64_stats_t tx_normal_irq_n[MTL_MAX_RX_QUEUES];
+	u64_stats_t rx_normal_irq_n[MTL_MAX_RX_QUEUES];
+	u64_stats_t tx_normal_irq_n[MTL_MAX_TX_QUEUES];
 };
 
 /* Extra statistic and debug information exposed by ethtool */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 041f43008ce8b..db7bea0fcafe4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -263,7 +263,7 @@ struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
 	u32 tx_coal_timer[MTL_MAX_TX_QUEUES];
-	u32 rx_coal_frames[MTL_MAX_TX_QUEUES];
+	u32 rx_coal_frames[MTL_MAX_RX_QUEUES];
 
 	int hwts_tx_en;
 	bool tx_path_in_lpi_mode;
@@ -271,8 +271,7 @@ struct stmmac_priv {
 	int sph;
 	int sph_cap;
 	u32 sarc_type;
-
-	u32 rx_riwt[MTL_MAX_TX_QUEUES];
+	u32 rx_riwt[MTL_MAX_RX_QUEUES];
 	int hwts_rx_en;
 
 	void __iomem *ioaddr;
@@ -350,7 +349,7 @@ struct stmmac_priv {
 	char int_name_sfty[IFNAMSIZ + 10];
 	char int_name_sfty_ce[IFNAMSIZ + 10];
 	char int_name_sfty_ue[IFNAMSIZ + 10];
-	char int_name_rx_irq[MTL_MAX_TX_QUEUES][IFNAMSIZ + 14];
+	char int_name_rx_irq[MTL_MAX_RX_QUEUES][IFNAMSIZ + 14];
 	char int_name_tx_irq[MTL_MAX_TX_QUEUES][IFNAMSIZ + 18];
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.53.0



