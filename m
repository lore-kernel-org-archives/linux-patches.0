Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F48527CCF0;
	Tue, 27 May 2025 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367380; cv=none; b=fwwES/54QRYIjvS++OOHrxA0E4UsE/WxGt0ltM0JoIdwwqNYGZtxO+wuA4C9JO6NgWHAMavvAKAx+a1Lr2burKF5WhXPZwejd+NIFqbueEE/vKi6eWgMqTJj0qsxl/wLof/wM9NM8FvP6pQ6YNsgqWBrsjGPaomATO4S9+U6hDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367380; c=relaxed/simple;
	bh=AMwIDlj9i/5e43FbK/Md/ITSEBXfgmO5VylEuxuvNU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEVQ/bATO2rfQ7nuTf6AuGaFyiRCV4AoehLDnxyEW/VOnF8Gt0qXw4Y+JrsokLHUtRsXdlWjuINFKL+/GYMeS5KT290uJVu3qwifhDNSKZyDApz3Wwk8cJMv09mC3qn9UIO2E6wjbj8pW9bm2Xm5GnYlGYEuBDXtRV9aH8X/1O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uw45nxMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uw45nxMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602EEC4CEE9;
	Tue, 27 May 2025 17:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367376;
	bh=AMwIDlj9i/5e43FbK/Md/ITSEBXfgmO5VylEuxuvNU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw45nxMPBJSOs0bGteeg9frfC/ltCRr4hq9RiRbVE67BI7o2eht/2kUDtoh2C/xAM
	 8+ackw1nRjM+/zFYpG5op6XrPa5BZPK9SD0rx6XzzSv2QiBXQPFJE+T1SpCgR684cf
	 w0Uiz3zuLv4NXQLLNYHYT1cV/AeChSNNe7NXTg6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 367/783] net: stmmac: Correct usage of maximum queue number macros
Date: Tue, 27 May 2025 18:22:44 +0200
Message-ID: <20250527162528.028736914@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index e25db747a81a5..c660eb933f24b 100644
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
index f05cae103d836..dae279ee2c280 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -257,7 +257,7 @@ struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
 	u32 tx_coal_timer[MTL_MAX_TX_QUEUES];
-	u32 rx_coal_frames[MTL_MAX_TX_QUEUES];
+	u32 rx_coal_frames[MTL_MAX_RX_QUEUES];
 
 	int hwts_tx_en;
 	bool tx_path_in_lpi_mode;
@@ -265,8 +265,7 @@ struct stmmac_priv {
 	int sph;
 	int sph_cap;
 	u32 sarc_type;
-
-	u32 rx_riwt[MTL_MAX_TX_QUEUES];
+	u32 rx_riwt[MTL_MAX_RX_QUEUES];
 	int hwts_rx_en;
 
 	void __iomem *ioaddr;
@@ -343,7 +342,7 @@ struct stmmac_priv {
 	char int_name_sfty[IFNAMSIZ + 10];
 	char int_name_sfty_ce[IFNAMSIZ + 10];
 	char int_name_sfty_ue[IFNAMSIZ + 10];
-	char int_name_rx_irq[MTL_MAX_TX_QUEUES][IFNAMSIZ + 14];
+	char int_name_rx_irq[MTL_MAX_RX_QUEUES][IFNAMSIZ + 14];
 	char int_name_tx_irq[MTL_MAX_TX_QUEUES][IFNAMSIZ + 18];
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.39.5



