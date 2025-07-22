Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA02F0C49;
	Tue, 22 Jul 2025 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193387; cv=none; b=HeX+d/szZq2mcPGEr3cavdYxwD/uBlseqVXs+hjNZSjuvzlDCRa/VjitnJAurc2VG3XzPpIwRdozAlBRIOChnhGkjPd2sgZwj4zfQcpvxLuZvKSbMte5teoy29xmi661GPmDwwhFb6OopeYV9L3IcBDb4Q9rMDzysSJZW2WlEvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193387; c=relaxed/simple;
	bh=dqCFkix4ZRSEc4kCXzPFWD3mojdK0JTYr6nTyryjOwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+n0stAftWEbp5O9wAdN/9tmP4z7V0LeJu5HyfI/eZ0UZPOM6Cm8sBJus3RQwhBz0QrfC3NNPFWhkt2T66LUwubfFuqqnuZzP0tpBuUXKnmOEV43fywYBHilIiBaCd4OrZyPHYatjuEKoP4dXk/33XO+8u072pJ89LapQqn6HDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKKRetqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKKRetqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BFCC4CEFD;
	Tue, 22 Jul 2025 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193386;
	bh=dqCFkix4ZRSEc4kCXzPFWD3mojdK0JTYr6nTyryjOwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKKRetqplAzPQMvmBcfBvF3m6UlTkb7J08n023QlFwg4GvhU4VTRi3lKJZREHz2Hv
	 xN3IThBjBCn4CtQB5jyCmYjXZOPxVpfKCc6jVRzlrsS/EPV8Quz6ZpEjJcWigsEo/f
	 QVaX6loxQLqV7/EYffzebUFkZUWLpeVoyZNHqR3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.15 077/187] soundwire: Revert "soundwire: qcom: Add set_channel_map api support"
Date: Tue, 22 Jul 2025 15:44:07 +0200
Message-ID: <20250722134348.596692484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

commit 834bce6a715ae9a9c4dce7892454a19adf22b013 upstream.

This reverts commit 7796c97df6b1b2206681a07f3c80f6023a6593d5.

This patch broke Dragonboard 845c (sdm845). I see:

    Unexpected kernel BRK exception at EL1
    Internal error: BRK handler: 00000000f20003e8 [#1]  SMP
    pc : qcom_swrm_set_channel_map+0x7c/0x80 [soundwire_qcom]
    lr : snd_soc_dai_set_channel_map+0x34/0x78
    Call trace:
     qcom_swrm_set_channel_map+0x7c/0x80 [soundwire_qcom] (P)
     sdm845_dai_init+0x18c/0x2e0 [snd_soc_sdm845]
     snd_soc_link_init+0x28/0x6c
     snd_soc_bind_card+0x5f4/0xb0c
     snd_soc_register_card+0x148/0x1a4
     devm_snd_soc_register_card+0x50/0xb0
     sdm845_snd_platform_probe+0x124/0x148 [snd_soc_sdm845]
     platform_probe+0x6c/0xd0
     really_probe+0xc0/0x2a4
     __driver_probe_device+0x7c/0x130
     driver_probe_device+0x40/0x118
     __device_attach_driver+0xc4/0x108
     bus_for_each_drv+0x8c/0xf0
     __device_attach+0xa4/0x198
     device_initial_probe+0x18/0x28
     bus_probe_device+0xb8/0xbc
     deferred_probe_work_func+0xac/0xfc
     process_one_work+0x244/0x658
     worker_thread+0x1b4/0x360
     kthread+0x148/0x228
     ret_from_fork+0x10/0x20
    Kernel panic - not syncing: BRK handler: Fatal exception

Dan has also reported following issues with the original patch
https://lore.kernel.org/all/33fe8fe7-719a-405a-9ed2-d9f816ce1d57@sabinyo.mountain/

Bug #1:
The zeroeth element of ctrl->pconfig[] is supposed to be unused.  We
start counting at 1.  However this code sets ctrl->pconfig[0].ch_mask = 128.

Bug #2:
There are SLIM_MAX_TX_PORTS (16) elements in tx_ch[] array but only
QCOM_SDW_MAX_PORTS + 1 (15) in the ctrl->pconfig[] array so it corrupts
memory like Yongqin Liu pointed out.

Bug 3:
Like Jie Gan pointed out, it erases all the tx information with the rx
information.

Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Acked-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250709174949.8541-1-amit.pundir@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/qcom.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 295a46dc2be7..0f45e3404756 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -156,7 +156,6 @@ struct qcom_swrm_port_config {
 	u8 word_length;
 	u8 blk_group_count;
 	u8 lane_control;
-	u8 ch_mask;
 };
 
 /*
@@ -1049,13 +1048,9 @@ static int qcom_swrm_port_enable(struct sdw_bus *bus,
 {
 	u32 reg = SWRM_DP_PORT_CTRL_BANK(enable_ch->port_num, bank);
 	struct qcom_swrm_ctrl *ctrl = to_qcom_sdw(bus);
-	struct qcom_swrm_port_config *pcfg;
 	u32 val;
 
-	pcfg = &ctrl->pconfig[enable_ch->port_num];
 	ctrl->reg_read(ctrl, reg, &val);
-	if (pcfg->ch_mask != SWR_INVALID_PARAM && pcfg->ch_mask != 0)
-		enable_ch->ch_mask = pcfg->ch_mask;
 
 	if (enable_ch->enable)
 		val |= (enable_ch->ch_mask << SWRM_DP_PORT_CTRL_EN_CHAN_SHFT);
@@ -1275,26 +1270,6 @@ static void *qcom_swrm_get_sdw_stream(struct snd_soc_dai *dai, int direction)
 	return ctrl->sruntime[dai->id];
 }
 
-static int qcom_swrm_set_channel_map(struct snd_soc_dai *dai,
-				     unsigned int tx_num, const unsigned int *tx_slot,
-				     unsigned int rx_num, const unsigned int *rx_slot)
-{
-	struct qcom_swrm_ctrl *ctrl = dev_get_drvdata(dai->dev);
-	int i;
-
-	if (tx_slot) {
-		for (i = 0; i < tx_num; i++)
-			ctrl->pconfig[i].ch_mask = tx_slot[i];
-	}
-
-	if (rx_slot) {
-		for (i = 0; i < rx_num; i++)
-			ctrl->pconfig[i].ch_mask = rx_slot[i];
-	}
-
-	return 0;
-}
-
 static int qcom_swrm_startup(struct snd_pcm_substream *substream,
 			     struct snd_soc_dai *dai)
 {
@@ -1331,7 +1306,6 @@ static const struct snd_soc_dai_ops qcom_swrm_pdm_dai_ops = {
 	.shutdown = qcom_swrm_shutdown,
 	.set_stream = qcom_swrm_set_sdw_stream,
 	.get_stream = qcom_swrm_get_sdw_stream,
-	.set_channel_map = qcom_swrm_set_channel_map,
 };
 
 static const struct snd_soc_component_driver qcom_swrm_dai_component = {
-- 
2.50.1



