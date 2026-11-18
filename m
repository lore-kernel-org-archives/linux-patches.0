Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030983;
	b=cV9jxc12U9BK2f/pSHKQFOw7i4Jb5FEMzlqJ1htXq1THezakM2asyFjDQSn83lXTHS+m
	 h4iGHlW30rw6Bj0QkrSApBLoPNiwgmKxbIfeV1OsK7dVG7q0s/C3yWNFGOgu4nM8oqanU
	 oujZ16MR/3r7psqP32fnhoB/+PQdZOqNBL+vl5ziBJyD+y1QxNKQTfek9UpnoMGe81JhL
	 E1ow85sDhTNLtf5zkIE9Fqi8iCGj0x96eUmIVNawTrQRo6G+Nf3teV8u5+MnKvMuxeo4n
	 svKg4s96EzTRg6ZIoBTPIFnyTxHxjtmshZv/nw3SSKMIQxTCcMaQI3gVwd8eUkpuE3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mipycupB00jqq4lSytTtPpj3bmZ8lNM90NoK+rmpS+w=;
	b=G/voZ5ghL2ptuOqTIyuaBkmrLQLBPrxCvZ/dQX5Zp2IxTanuz2Ywo5Cm+Rf3s1gqCbAv
	 BRPTzfkri6vvE07gIOEGZB3bCfjL+ty6dwmlw62EhXTFvqGpOCf++R0OQfXwUBPz+Q4Mr
	 7spzwoVyd+RrhK7OYBrhmIOAel7O2OA13cD9DNqjfmAD7cx6onst3Ryl2JrOjoI+jLHkh
	 9QVGedeMRyPy7j40rZ1wKjwyl+AAXNgFBToI8IeNar3HL8PXg2dWYS7DpTGI57DWk3IlG
	 fUaW2DTITHLKgAopWVAd+OInWyrE+93zBbw8OY8qz5F7C5lRPeiHEGd2WtK8eKSR69w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/d0QS3j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91BE606A331;
	Wed, 18 Nov 2026 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/d0QS3j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A14F1F000C4;
	Wed, 18 Nov 2026 19:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030983;
	bh=mipycupB00jqq4lSytTtPpj3bmZ8lNM90NoK+rmpS+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/d0QS3jPyj+BOCiL1oqN+nhg4g34jUc/5AooCi+8d+dSbToRW0DiWKbueJ9XthiS
	 JNYi6brRbsdfJFXLU9zBVmsyMghFDHo9x79xeQYg0Vm/a8aI1jLmg71RKMRQ//umJZ
	 PoDS0W0AqvFC98fruexJEQwSDE8WKW8ybC30UkKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0897/1756] dmaengine: ste_dma40: Fix event group bounds
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118150045.739016396@linuxfoundation.org>
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
index c0c495e89ef27..aeb0e66dbfdbe 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -79,6 +79,10 @@ struct stedma40_platform_data {
 #define D40_LCLA_LINK_PER_EVENT_GRP 128
 #define D40_LCLA_END D40_LCLA_LINK_PER_EVENT_GRP
 
+/* Number of event groups per hardware register layout */
+#define D40_EVENT_GROUPS_V4A 4
+#define D40_EVENT_GROUPS_V4B 5
+
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
 
@@ -507,6 +511,7 @@ struct d40_chan {
  * @high_prio_clear: the high priority clear register
  * @interrupt_en: the interrupt enable register
  * @interrupt_clear: the interrupt clear register
+ * @num_event_groups: number of supported event groups
  * @il: the pointer to struct d40_interrupt_lookup
  * @il_size: the size of d40_interrupt_lookup array
  * @init_reg: the pointer to the struct d40_reg_val
@@ -521,6 +526,7 @@ struct d40_gen_dmac {
 	u32				 high_prio_clear;
 	u32				 interrupt_en;
 	u32				 interrupt_clear;
+	u32				 num_event_groups;
 	struct d40_interrupt_lookup	*il;
 	u32				 il_size;
 	struct d40_reg_val		*init_reg;
@@ -1752,6 +1758,11 @@ static int d40_validate_conf(struct d40_chan *d40c,
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
@@ -1768,8 +1779,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		invalid_dev_type = conf->dev_type >= max_dev_type;
 	}
 
-	if (invalid_dev_type ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
+	if (invalid_dev_type) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
@@ -1934,8 +1944,12 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1955,8 +1969,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 		return -EINVAL;
 
 	/* Find logical channel */
-	for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
+	for (j = 0; j < d40c->base->num_phy_chans; j += D40_GROUP_SIZE) {
 		int phy_num = j + event_group * 2;
+		if (phy_num + 1 >= num_phy_chans)
+			break;
 
 		if (d40c->dma_cfg.use_fixed_channel) {
 			i = d40c->dma_cfg.phy_channel;
@@ -3304,6 +3320,7 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
 	if (base->plat_data->num_of_phy_chans == 14) {
+		base->gen_dmac.num_event_groups = D40_EVENT_GROUPS_V4B;
 		base->gen_dmac.backup = d40_backup_regs_v4b;
 		base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4B;
 		base->gen_dmac.interrupt_en = D40_DREG_CPCMIS;
@@ -3317,6 +3334,7 @@ static int __init d40_hw_detect_init(struct platform_device *pdev,
 		base->gen_dmac.init_reg = dma_init_reg_v4b;
 		base->gen_dmac.init_reg_size = ARRAY_SIZE(dma_init_reg_v4b);
 	} else {
+		base->gen_dmac.num_event_groups = D40_EVENT_GROUPS_V4A;
 		if (base->rev >= 3) {
 			base->gen_dmac.backup = d40_backup_regs_v4a;
 			base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4A;
-- 
2.53.0



