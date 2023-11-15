Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6993BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9j7F3VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C744C433CB;
	Wed, 15 Nov 2023 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076234;
	bh=eRQgf/zHMzvEKq4Wcdayyxtw7z6iWf4SuOSAlYR2zOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9j7F3VMHEQOfoJ6NsIp42K9YFF/Nc0s4qsWs6yBAs+hKl5m8hUf8n0p0Fgzc/H+c
	 AdeN9j7HXtP5/9lHnZ1BgfDsqbYn7hj41Cm1kAPlSt7k2Lf9dqdjR4FOaeXC4+JoOt
	 8qHGW4oWZ2S3JbcjCec3UcBcqE3HSrf6ochrSzk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 160/550] clk: imx: Select MXC_CLK for CLK_IMX8QXP
Date: Wed, 15 Nov 2023 14:12:24 -0500
Message-ID: <20231115191611.793556579@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index f6b82e0b9703a..db3bca5f4ec9c 100644
--- a/drivers/clk/imx/Kconfig
+++ b/drivers/clk/imx/Kconfig
@@ -96,6 +96,7 @@ config CLK_IMX8QXP
 	depends on (ARCH_MXC && ARM64) || COMPILE_TEST
 	depends on IMX_SCU && HAVE_ARM_SMCCC
 	select MXC_CLK_SCU
+	select MXC_CLK
 	help
 	  Build the driver for IMX8QXP SCU based clocks.
 
-- 
2.42.0



