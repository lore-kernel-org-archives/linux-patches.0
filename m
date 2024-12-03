Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67181F76BA;
	Tue,  3 Dec 2024 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238825; cv=none; b=bGhk61FxLJo4wwEdh8Tisqe3P1abPQ1EWLYNFDyNVoT4LWh81e1dTePOSV8IqYE0itYc9c8MMiz09gyugZiKdL170rEa/m/wTHsSLgHptBpYCtTkDD9hq+mctopfjLE4zbKaH+WRn+QMpKXxxcCXU5MDlOqwow1k1EwzlCW/XFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238825; c=relaxed/simple;
	bh=qumD2na5SUz50RP9JG+v5eLG2/mojMWerzaunHtlMvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7iErah0EnKJcykX/uNNp5pBs8ySzb+wI7G+AfeQrosTN2c14V2lQKmglcaGLmSEeO05iemLWOk3JvZGVAslQsQNgVqEz0EJn4T6qY+3MNilY1pknsVX21ONaKoI+xGLGb1oQqV31Ft6kEmOvNLsuIkgGx00+MHt9p1Ph+m40L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxTzlPOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxTzlPOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B8C4CECF;
	Tue,  3 Dec 2024 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238825;
	bh=qumD2na5SUz50RP9JG+v5eLG2/mojMWerzaunHtlMvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxTzlPOVymyRtR4uHBgSWsO4d7LXYhTP8nNZeS1GCC5mN4k+WvFcqitHxYcD+XM1F
	 /QqyD5CMGBTqjqguSPUGgt40bdCycjVq8K9QVVLL8EMuTKFoYUhkNQjFtKbMPCt974
	 BaEy9+k44KhYi4PKweexo1FoCaGkyQNYRUavbFSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 378/817] clk: mediatek: drop two dead config options
Date: Tue,  3 Dec 2024 15:39:10 +0100
Message-ID: <20241203144010.600084254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



