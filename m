Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037331AB6C9;
	Tue,  3 Dec 2024 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241234; cv=none; b=UxBZcV0+vlUhmReIPJHObRFy35PqYozkxxvlx6RFjej4Cd6hPQNgyqLPvjQWzAKegPmEJHi52cKos7g8hnaLMrLNfRrMo3o8YfRb6xbZq1RTkJqhmxuqrsK7B3oqhWeEY/yqoisV1qJRTYhd9ppEakmGJd9qyn4xY9CI05v9h+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241234; c=relaxed/simple;
	bh=S7LtONp5AdB6AgwIeLBicwixjiXtZgRG6/FSsGdhBsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPAYDr5TcitTGZLSukyeg75YCfmXUYRqBLKp4I9+MBY71mGur5Tk1vq5qfJYdWWlPe8sdxGtD0kpFtedjTSSfuWTRYuNKiGS9UQQTrpgB6a+CF/pJk2rN2wcaErrxo4zKODiP3Sj5dYmjd4D8kNYWNiNCE54+HuDKkOoL/7LQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6T3DeKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6T3DeKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D80C4CECF;
	Tue,  3 Dec 2024 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241233;
	bh=S7LtONp5AdB6AgwIeLBicwixjiXtZgRG6/FSsGdhBsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6T3DeKbAoW1DXtRxl5AO4MNhQv2eR6iGZWqYex0lNETlaPEp9uSMRDGq+Th/rhhf
	 QQISFAaHvvdSV6KBpi1z36Pjx/sO/hnKiQKDihQI2wxt8RYFm9xJOx6nM0a1hp2ZFF
	 nE1Y6lIaB446nR/n1qQVLuAzO+V9dFEkyKvIknxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/826] clk: mediatek: drop two dead config options
Date: Tue,  3 Dec 2024 15:41:29 +0100
Message-ID: <20241203144757.881742767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

[ Upstream commit 98619dc3cecc2b3943d6abe1db235c868dc72f8d ]

Commit 0f471d31e5e8 ("clk: mediatek: Split MT8195 clock drivers and allow
module build") adds a number of new COMMON_CLK_MT8195_* config options.
Among those, the config options COMMON_CLK_MT8195_AUDSYS and
COMMON_CLK_MT8195_MSDC have no reference in the source tree and are not
used in the Makefile to include a specific file.

Drop the dead config options COMMON_CLK_MT8195_AUDSYS and
COMMON_CLK_MT8195_MSDC.

Fixes: 0f471d31e5e8 ("clk: mediatek: Split MT8195 clock drivers and allow module build")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Link: https://lore.kernel.org/r/20240927092232.386511-1-lukas.bulwahn@redhat.com
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/Kconfig | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
index 70a005e7e1b18..486401e1f2f19 100644
--- a/drivers/clk/mediatek/Kconfig
+++ b/drivers/clk/mediatek/Kconfig
@@ -887,13 +887,6 @@ config COMMON_CLK_MT8195_APUSYS
 	help
 	  This driver supports MediaTek MT8195 AI Processor Unit System clocks.
 
-config COMMON_CLK_MT8195_AUDSYS
-	tristate "Clock driver for MediaTek MT8195 audsys"
-	depends on COMMON_CLK_MT8195
-	default COMMON_CLK_MT8195
-	help
-	  This driver supports MediaTek MT8195 audsys clocks.
-
 config COMMON_CLK_MT8195_IMP_IIC_WRAP
 	tristate "Clock driver for MediaTek MT8195 imp_iic_wrap"
 	depends on COMMON_CLK_MT8195
@@ -908,14 +901,6 @@ config COMMON_CLK_MT8195_MFGCFG
 	help
 	  This driver supports MediaTek MT8195 mfgcfg clocks.
 
-config COMMON_CLK_MT8195_MSDC
-	tristate "Clock driver for MediaTek MT8195 msdc"
-	depends on COMMON_CLK_MT8195
-	default COMMON_CLK_MT8195
-	help
-	  This driver supports MediaTek MT8195 MMC and SD Controller's
-	  msdc and msdc_top clocks.
-
 config COMMON_CLK_MT8195_SCP_ADSP
 	tristate "Clock driver for MediaTek MT8195 scp_adsp"
 	depends on COMMON_CLK_MT8195
-- 
2.43.0



