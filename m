Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3F13AA5F;
	Fri,  6 Dec 2024 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497325; cv=none; b=pSKhTkkFAgumPn36xIKJllTZ7RNJjKcmVzZVteu2qJ1l337nlkndNcKCjhdSPDKR5rCZFnr5LzD5gL1IbdqJdzaMoiNRhitiQa+ZsuUCb326sVMOz4X7G0crPcVVjbWBST6Iku32jbX9pNX1UuEplH5+pX+rsO1oI14NjoLrX4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497325; c=relaxed/simple;
	bh=BS+POV1ErYG7Jn15gRcVZNm3YktYLkY/iGOnrEGgrXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nae18zEgpU7fGRp/eH6jWrLb+EUkKxbWhZhcmzlLKqXigtf2m14UZ0pBA3SmhS1h6i1N8JEDj4yhlCTy9F5I6lcRMexndluteDqXbn7kuf2XisNZ+cG/n+9ZhpYt45YlYadqLyC3Qz5MA2Rl6K6o5E4fo9IHFQZ5+1HhPz2m2sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY3Fuv+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY3Fuv+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C700C4CED1;
	Fri,  6 Dec 2024 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497324;
	bh=BS+POV1ErYG7Jn15gRcVZNm3YktYLkY/iGOnrEGgrXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY3Fuv+RCwmU/kweqTigO/s5WJN/mt1B23ovDF0bgODFguHBTjwZw6Abhk6jSoram
	 XMHGA/a2ItQ2ON7P/M/ZpiyO/tycVj75gkkxVv0r5FbY6nPWqwsVU+6/nNAlzoFOdN
	 3kP8XoC00X2be29mHLZVsPuS0nAeRU3GJRFNqe4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/676] clk: mediatek: drop two dead config options
Date: Fri,  6 Dec 2024 15:31:19 +0100
Message-ID: <20241206143703.487718728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48b42d11111cd..8ad02c1f035b3 100644
--- a/drivers/clk/mediatek/Kconfig
+++ b/drivers/clk/mediatek/Kconfig
@@ -878,13 +878,6 @@ config COMMON_CLK_MT8195_APUSYS
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
@@ -899,14 +892,6 @@ config COMMON_CLK_MT8195_MFGCFG
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



