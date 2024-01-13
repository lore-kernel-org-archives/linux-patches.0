Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809261848;
	Sat, 13 Jan 2024 09:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MH8xE9me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5158C433C7;
	Sat, 13 Jan 2024 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139792;
	bh=JmgRHh+TQdpTyPJz9wf+5eZUnvedMrDvP4c87FRfx/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MH8xE9meBBDc411PIL+mraPsHOJVrkYYbMUVLtbFo5CWWN+YjMenAkes2Tmm+v4zc
	 ua9jDxO0arNdznYFlpij2HdAvUEUEnMFxoMO/ac7MeVw46dRwnGuk572+xgmiQ2j0v
	 WXPUKaaAmP4Kx+OsGSILlp6dA+9TjizoLj7jHJug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 31/38] ath10k: Get rid of "per_ce_irq" hw param
Date: Sat, 13 Jan 2024 10:50:07 +0100
Message-ID: <20240113094207.405595161@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 7f86551665121931ecd6d327e019e7a69782bfcd ]

As of the patch ("ath10k: Keep track of which interrupts fired, don't
poll them") we now have no users of this hardware parameter.  Remove
it.

Suggested-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200709082024.v2.2.I083faa4e62e69f863311c89ae5eb28ec5a229b70@changeid
Stable-dep-of: 170c75d43a77 ("ath10k: Don't touch the CE interrupt registers after power up")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/core.c |   13 -------------
 drivers/net/wireless/ath/ath10k/hw.h   |    3 ---
 2 files changed, 16 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -118,7 +118,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -154,7 +153,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -217,7 +215,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -252,7 +249,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -287,7 +283,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -325,7 +320,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -366,7 +360,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -414,7 +407,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -459,7 +451,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -494,7 +485,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -531,7 +521,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -573,7 +562,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
-		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
@@ -601,7 +589,6 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = TARGET_HL_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL_DUAL_MAC,
-		.per_ce_irq = true,
 		.shadow_reg_support = true,
 		.rri_on_ddr = true,
 		.hw_filter_reset_required = false,
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -590,9 +590,6 @@ struct ath10k_hw_params {
 	/* Target rx ring fill level */
 	u32 rx_ring_fill_level;
 
-	/* target supporting per ce IRQ */
-	bool per_ce_irq;
-
 	/* target supporting shadow register for ce write */
 	bool shadow_reg_support;
 


