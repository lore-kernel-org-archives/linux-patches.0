Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D84E364D4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp+vrst8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCEAC433C8;
	Wed, 15 Nov 2023 22:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085748;
	bh=vB3ID4fGcfi/AizR5rva5d7aHWEBP8NfYQQXWiANYcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp+vrst8O87TlR5IYufmkMSVgEsn+TSnKxI7aElX9E+Kc6wT+xLPYwqApNVihkZHb
	 N7LwEqdtVCr0GTKMg71LB52py7vO66jWOg4nlAIUwHAYITW5W5wTEfpj1m+Z7P3+KX
	 u0aRAkjrARw3nbcB52PWMJTwrO4o+xYbyuSqQucI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/119] clk: imx: Select MXC_CLK for CLK_IMX8QXP
Date: Wed, 15 Nov 2023 17:00:17 -0500
Message-ID: <20231115220133.472835020@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 317e69c49b4ceef8aebb47d771498ccb3571bdf9 ]

If the i.MX8QXP clock provider is built-in but the MXC_CLK is
built as module, build fails:

aarch64-linux-ld: drivers/clk/imx/clk-imx8-acm.o: in function `imx8_acm_clk_probe':
clk-imx8-acm.c:(.text+0x3d0): undefined reference to `imx_check_clk_hws'

Fix that by selecting MXC_CLK in case of CLK_IMX8QXP.

Fixes: c2cccb6d0b33 ("clk: imx: add imx8qxp clk driver")
Closes: https://lore.kernel.org/all/8b77219e-b59e-40f1-96f1-980a0b2debcf@infradead.org/
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/Kconfig b/drivers/clk/imx/Kconfig
index 1ac0c7990392d..087170a9b1484 100644
--- a/drivers/clk/imx/Kconfig
+++ b/drivers/clk/imx/Kconfig
@@ -30,5 +30,6 @@ config CLK_IMX8QXP
 	bool "IMX8QXP SCU Clock"
 	depends on ARCH_MXC && IMX_SCU && ARM64
 	select MXC_CLK_SCU
+	select MXC_CLK
 	help
 	  Build the driver for IMX8QXP SCU based clocks.
-- 
2.42.0



