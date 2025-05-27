Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF427D766;
	Tue, 27 May 2025 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364971; cv=none; b=gCDj5R+zEAHjT0dXJq/FdkYghWAtqv9RJJjXkpH5kqH0N+As7M8MtNsqa5se5iJHYImszLrksh+K7CBh/Md/dPD1sbmGwnr1fCX/f4cO37fVYRfuCu3EPg5g3yPwy0oA/f7xAaymwzL/4pDikFDWmgL0SJHcX9Pk7ZyeKC07Wl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364971; c=relaxed/simple;
	bh=nzmgAGxEgzwRytXSRwiGVT2NeYowN6j3a0oQpweQ9kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWwBaPXyNKD7/yhOluyYzng32pyE1QWjd/sUkCHcXxGtWgBLTTCpDnh9Fa/J7a3qqN7A3bpKg6HaI7+1YBqUZCFR+dltKqqOp+Y4K/x1qTCRrOwBe/XQznMHHH0IvrvbsQrMeqeFytIlXFe2F3TAHqjYVxMhzAramPNOAMrCzKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSqL7Os6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSqL7Os6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94759C4CEE9;
	Tue, 27 May 2025 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364971;
	bh=nzmgAGxEgzwRytXSRwiGVT2NeYowN6j3a0oQpweQ9kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSqL7Os6Wec6jtsIoBXrTR7dUjv6iE5EDJl87MavmyrDhbYd3EPg3Kwcrx5V3SytX
	 w1AdbbJyQnfAJgd202bkVClT/LiaarXM7ZVoRyEjQAbNhPIg+gLGfre5PbdVNL5DH5
	 JPjMH9BTMNA2pVmnJGDhPfhsD4UeRR4Jn1zDqzcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/626] soc: mediatek: mtk-mutex: Add DPI1 SOF/EOF to MT8188 mutex tables
Date: Tue, 27 May 2025 18:21:59 +0200
Message-ID: <20250527162454.207042722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 694e0b7c1747603243da874de9cbbf8cb806ca44 ]

MT8188 uses DPI1 to output to the HDMI controller: add the
Start of Frame and End of Frame configuration for the DPI1
IP to the tables to unblock generation and sending of these
signals to the GCE.

Link: https://lore.kernel.org/r/20250212100012.33001-2-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-mutex.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/soc/mediatek/mtk-mutex.c b/drivers/soc/mediatek/mtk-mutex.c
index 5250c1d702eb9..aaa965d4b050a 100644
--- a/drivers/soc/mediatek/mtk-mutex.c
+++ b/drivers/soc/mediatek/mtk-mutex.c
@@ -155,6 +155,7 @@
 #define MT8188_MUTEX_MOD_DISP1_VPP_MERGE3	23
 #define MT8188_MUTEX_MOD_DISP1_VPP_MERGE4	24
 #define MT8188_MUTEX_MOD_DISP1_DISP_MIXER	30
+#define MT8188_MUTEX_MOD_DISP1_DPI1		38
 #define MT8188_MUTEX_MOD_DISP1_DP_INTF1		39
 
 #define MT8195_MUTEX_MOD_DISP_OVL0		0
@@ -289,6 +290,7 @@
 #define MT8188_MUTEX_SOF_DSI0			1
 #define MT8188_MUTEX_SOF_DP_INTF0		3
 #define MT8188_MUTEX_SOF_DP_INTF1		4
+#define MT8188_MUTEX_SOF_DPI1			5
 #define MT8195_MUTEX_SOF_DSI0			1
 #define MT8195_MUTEX_SOF_DSI1			2
 #define MT8195_MUTEX_SOF_DP_INTF0		3
@@ -301,6 +303,7 @@
 #define MT8188_MUTEX_EOF_DSI0			(MT8188_MUTEX_SOF_DSI0 << 7)
 #define MT8188_MUTEX_EOF_DP_INTF0		(MT8188_MUTEX_SOF_DP_INTF0 << 7)
 #define MT8188_MUTEX_EOF_DP_INTF1		(MT8188_MUTEX_SOF_DP_INTF1 << 7)
+#define MT8188_MUTEX_EOF_DPI1			(MT8188_MUTEX_SOF_DPI1 << 7)
 #define MT8195_MUTEX_EOF_DSI0			(MT8195_MUTEX_SOF_DSI0 << 7)
 #define MT8195_MUTEX_EOF_DSI1			(MT8195_MUTEX_SOF_DSI1 << 7)
 #define MT8195_MUTEX_EOF_DP_INTF0		(MT8195_MUTEX_SOF_DP_INTF0 << 7)
@@ -472,6 +475,7 @@ static const u8 mt8188_mutex_mod[DDP_COMPONENT_ID_MAX] = {
 	[DDP_COMPONENT_PWM0] = MT8188_MUTEX_MOD2_DISP_PWM0,
 	[DDP_COMPONENT_DP_INTF0] = MT8188_MUTEX_MOD_DISP_DP_INTF0,
 	[DDP_COMPONENT_DP_INTF1] = MT8188_MUTEX_MOD_DISP1_DP_INTF1,
+	[DDP_COMPONENT_DPI1] = MT8188_MUTEX_MOD_DISP1_DPI1,
 	[DDP_COMPONENT_ETHDR_MIXER] = MT8188_MUTEX_MOD_DISP1_DISP_MIXER,
 	[DDP_COMPONENT_MDP_RDMA0] = MT8188_MUTEX_MOD_DISP1_MDP_RDMA0,
 	[DDP_COMPONENT_MDP_RDMA1] = MT8188_MUTEX_MOD_DISP1_MDP_RDMA1,
@@ -686,6 +690,8 @@ static const u16 mt8188_mutex_sof[DDP_MUTEX_SOF_MAX] = {
 	[MUTEX_SOF_SINGLE_MODE] = MUTEX_SOF_SINGLE_MODE,
 	[MUTEX_SOF_DSI0] =
 		MT8188_MUTEX_SOF_DSI0 | MT8188_MUTEX_EOF_DSI0,
+	[MUTEX_SOF_DPI1] =
+		MT8188_MUTEX_SOF_DPI1 | MT8188_MUTEX_EOF_DPI1,
 	[MUTEX_SOF_DP_INTF0] =
 		MT8188_MUTEX_SOF_DP_INTF0 | MT8188_MUTEX_EOF_DP_INTF0,
 	[MUTEX_SOF_DP_INTF1] =
-- 
2.39.5



