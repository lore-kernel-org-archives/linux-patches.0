Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040891;
	b=OkGN6n/wmhPK90hgz121XwVbZ/DOn/c4F9X9rOXVWtuVC61bH1XU8IHXUHX40Jxfm7nJ
	 hl8lBWreUk+D/zCQ0fcozeSFpEj4lUg2Ko3fs8dunW3kmuRX/Is5PFI/iWWV1sOs39DTr
	 ArWNF03uUk2UUZREFbl+VTTxyjyZWR+Wd+UFqEowk5IxyiDxkq1XvaCIKfPMFpdmJPrci
	 JyDouGaZV8seh3EpOlXm/oy3YY9hUcDrF8nFd0ltIPViyO2PENBbkLdhI1wRRiPKtwxOs
	 hvkrxr3LOdVvAKo2DGZzfd7YJDMh6g7ik24KIu4izgpaHlqgWxOLXzaWeUS5wgGsZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44YK8MuPlSTZR12wPk8/TpFWLHq7X3+OnUfM6LQBZ7w=;
	b=47FMS2OxN20VyKHjkRiaDt3d2SaDBCe64zbpUcpF64xtEX6lf/wYNa8aF7GYrzsLO1/t
	 2PGrlbgtQNu0+x0UFodeJOGOK4K8gO4He3FYg03MoR6ptz7Gv5yLhupv+jNwOEw0AQtjo
	 P2qlWbcJzS88MYEVBti91LYInMdz0b7CiV9WqPzSwQELN6snu4iT2WpwhRitb55EP9Ota
	 1mI7QQTDy666h6Nk74qhBamtCi4kOaS/ALtHC6mJEdNIWGGLLR2OPvIQVvVFkvy6J35NK
	 qCm23Fh/VaR2lOjz2jih+2m6V9arp+G8HLEYRaOr+B4Y5i/BDX6YzOCW/D06N3QXFZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGWABCnH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD61606A31C;
	Wed, 18 Nov 2026 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGWABCnH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43BB1F000C4;
	Wed, 18 Nov 2026 22:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040891;
	bh=44YK8MuPlSTZR12wPk8/TpFWLHq7X3+OnUfM6LQBZ7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGWABCnHT9Rz/ipKz7pzox1zu3c3SE1n+KoB7m0db1/hIZcYs2kTuE2DsvFgvRqRC
	 NOSQPFfguMpst618IB6Ddws26Bkp2RP3U6LPKzZ8QR48dKdt8HB4ra96ziaHXJEK+M
	 auxeUcigr977mCDtgl6XAKv/hBcukDqkPKMJC1Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2617/3318] dmaengine: ste_dma40: Fix event group bounds
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150439.630637079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit e66a9dbe04c71249cfb2a544c9c25d1b3b761fba ]

The dev_type validation can allow values whose derived event group has no
matching physical channel pair. d40_allocate_channel() then indexes
phy_res with j + event_group * 2, and __d40_set_prio_rt() uses the same
group to select priority and realtime registers.

The physical-mode validation also compares dev_type with the number of
physical channels. However, dev_type identifies an event line: DB8500 has
eight physical channels but 64 source and 64 destination event lines. The
event group determines which physical channel pair can serve an event, so
the physical channel count is not a valid dev_type limit.

Reject dev_type values outside the hardware event-group range, remove the
incorrect physical channel count limit, and stop the physical-channel
search before a partial final channel group can index past phy_res.

Fixes: 26955c07dcf3 ("dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Assisted-by: LLM
Link: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-20-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 83c2642e788ae..b95794262df3b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -81,6 +81,10 @@ struct stedma40_platform_data {
 #define D40_LCLA_LINK_PER_EVENT_GRP 128
 #define D40_LCLA_END D40_LCLA_LINK_PER_EVENT_GRP
 
+/* Number of event groups per hardware register layout */
+#define D40_EVENT_GROUPS_V4A 4
+#define D40_EVENT_GROUPS_V4B 5
+
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
 
@@ -509,6 +513,7 @@ struct d40_chan {
  * @high_prio_clear: the high priority clear register
  * @interrupt_en: the interrupt enable register
  * @interrupt_clear: the interrupt clear register
+ * @num_event_groups: number of supported event groups
  * @il: the pointer to struct d40_interrupt_lookup
  * @il_size: the size of d40_interrupt_lookup array
  * @init_reg: the pointer to the struct d40_reg_val
@@ -523,6 +528,7 @@ struct d40_gen_dmac {
 	u32				 high_prio_clear;
 	u32				 interrupt_en;
 	u32				 interrupt_clear;
+	u32				 num_event_groups;
 	struct d40_interrupt_lookup	*il;
 	u32				 il_size;
 	struct d40_reg_val		*init_reg;
@@ -1754,6 +1760,11 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
 	bool invalid_dev_type = conf->dev_type < 0;
 
+	if (!invalid_dev_type &&
+	    D40_TYPE_TO_GROUP(conf->dev_type) >=
+	    d40c->base->gen_dmac.num_event_groups)
+		invalid_dev_type = true;
+
 	if (!conf->dir) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
@@ -1770,8 +1781,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		invalid_dev_type = conf->dev_type >= max_dev_type;
 	}
 
-	if (invalid_dev_type ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
+	if (invalid_dev_type) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
@@ -1936,8 +1946,12 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 				}
 			}
 		} else
-			for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
+			for (j = 0; j < d40c->base->num_phy_chans;
+			     j += D40_GROUP_SIZE) {
 				int phy_num = j  + event_group * 2;
+				if (phy_num + 1 >= num_phy_chans)
+					break;
+
 				for (i = phy_num; i < phy_num + 2; i++) {
 					if (d40_alloc_mask_set(&phys[i],
 							       is_src,
@@ -1957,8 +1971,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 		return -EINVAL;
 
 	/* Find logical channel */
-	for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
+	for (j = 0; j < d40c->base->num_phy_chans; j += D40_GROUP_SIZE) {
 		int phy_num = j + event_group * 2;
+		if (phy_num + 1 >= num_phy_chans)
+			break;
 
 		if (d40c->dma_cfg.use_fixed_channel) {
 			i = d40c->dma_cfg.phy_channel;
@@ -3278,6 +3294,7 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
 	if (base->plat_data->num_of_phy_chans == 14) {
+		base->gen_dmac.num_event_groups = D40_EVENT_GROUPS_V4B;
 		base->gen_dmac.backup = d40_backup_regs_v4b;
 		base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4B;
 		base->gen_dmac.interrupt_en = D40_DREG_CPCMIS;
@@ -3291,6 +3308,7 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 		base->gen_dmac.init_reg = dma_init_reg_v4b;
 		base->gen_dmac.init_reg_size = ARRAY_SIZE(dma_init_reg_v4b);
 	} else {
+		base->gen_dmac.num_event_groups = D40_EVENT_GROUPS_V4A;
 		if (base->rev >= 3) {
 			base->gen_dmac.backup = d40_backup_regs_v4a;
 			base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4A;
-- 
2.53.0



