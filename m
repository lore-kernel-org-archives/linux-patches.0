Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401426D6DC;
	Mon,  8 Jan 2024 15:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRDAjCyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697DDC433CA;
	Mon,  8 Jan 2024 15:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726864;
	bh=xufhh18Nj1AMyKU1rZPRi36A6s3+mQ6j+rPS08RkE/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRDAjCyZTEMC1nJBufRk6kzMVDO5DJcNoXeOzSj4A+bIRmR1Hkqygr9s/cY943Vax
	 1ucaBwtvksM2IoxKnutHdPL0sH6vjK5pViSRC+Oag/GQjGXBuOQbn/0SuohT62OEl2
	 DRTcNNElL6NlAHXATMQKOQqYevc5YVkA7eRg7auQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Jai Luthra <j-luthra@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/124] dmaengine: ti: k3-psil-am62: Fix SPI PDMA data
Date: Mon,  8 Jan 2024 16:08:31 +0100
Message-ID: <20240108150606.902631267@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Ronald Wahl <rwahl@gmx.de>

[ Upstream commit 744f5e7b69710701dc225020769138f8ca2894df ]

AM62x has 3 SPI channels where each channel has 4 TX and 4 RX threads.
This also fixes the thread numbers.

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: 5ac6bfb58777 ("dmaengine: ti: k3-psil: Add AM62x PSIL and PDMA data")
Reviewed-by: Jai Luthra <j-luthra@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20231030190113.16782-1-rwahl@gmx.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-psil-am62.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ti/k3-psil-am62.c b/drivers/dma/ti/k3-psil-am62.c
index 2b6fd6e37c610..1272b1541f61e 100644
--- a/drivers/dma/ti/k3-psil-am62.c
+++ b/drivers/dma/ti/k3-psil-am62.c
@@ -74,7 +74,9 @@ static struct psil_ep am62_src_ep_map[] = {
 	PSIL_SAUL(0x7505, 21, 35, 8, 36, 0),
 	PSIL_SAUL(0x7506, 22, 43, 8, 43, 0),
 	PSIL_SAUL(0x7507, 23, 43, 8, 44, 0),
-	/* PDMA_MAIN0 - SPI0-3 */
+	/* PDMA_MAIN0 - SPI0-2 */
+	PSIL_PDMA_XY_PKT(0x4300),
+	PSIL_PDMA_XY_PKT(0x4301),
 	PSIL_PDMA_XY_PKT(0x4302),
 	PSIL_PDMA_XY_PKT(0x4303),
 	PSIL_PDMA_XY_PKT(0x4304),
@@ -85,8 +87,6 @@ static struct psil_ep am62_src_ep_map[] = {
 	PSIL_PDMA_XY_PKT(0x4309),
 	PSIL_PDMA_XY_PKT(0x430a),
 	PSIL_PDMA_XY_PKT(0x430b),
-	PSIL_PDMA_XY_PKT(0x430c),
-	PSIL_PDMA_XY_PKT(0x430d),
 	/* PDMA_MAIN1 - UART0-6 */
 	PSIL_PDMA_XY_PKT(0x4400),
 	PSIL_PDMA_XY_PKT(0x4401),
@@ -141,7 +141,9 @@ static struct psil_ep am62_dst_ep_map[] = {
 	/* SAUL */
 	PSIL_SAUL(0xf500, 27, 83, 8, 83, 1),
 	PSIL_SAUL(0xf501, 28, 91, 8, 91, 1),
-	/* PDMA_MAIN0 - SPI0-3 */
+	/* PDMA_MAIN0 - SPI0-2 */
+	PSIL_PDMA_XY_PKT(0xc300),
+	PSIL_PDMA_XY_PKT(0xc301),
 	PSIL_PDMA_XY_PKT(0xc302),
 	PSIL_PDMA_XY_PKT(0xc303),
 	PSIL_PDMA_XY_PKT(0xc304),
@@ -152,8 +154,6 @@ static struct psil_ep am62_dst_ep_map[] = {
 	PSIL_PDMA_XY_PKT(0xc309),
 	PSIL_PDMA_XY_PKT(0xc30a),
 	PSIL_PDMA_XY_PKT(0xc30b),
-	PSIL_PDMA_XY_PKT(0xc30c),
-	PSIL_PDMA_XY_PKT(0xc30d),
 	/* PDMA_MAIN1 - UART0-6 */
 	PSIL_PDMA_XY_PKT(0xc400),
 	PSIL_PDMA_XY_PKT(0xc401),
-- 
2.43.0



