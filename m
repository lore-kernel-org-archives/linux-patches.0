Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B426D6DC;
	Mon,  8 Jan 2024 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBNPPjY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9D3C433C8;
	Mon,  8 Jan 2024 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726898;
	bh=90hgttIimNU26HQcijFL7hjqUniYL0H/Ua84K7ZN1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBNPPjY7zxAAiepomtA6QLEqLJOZ5CRF9gEiONxECeDvpFt3rrEIY02D8R9dwYlvX
	 t1JbTgd344lR0e0drW7fnZugk+3KIRT5lakXNR/RqTSEUDf8WlbKYV3yVLPTqfNTJ0
	 4QQdjVYv064i9P9JqA7DFZjg4Vi+CFoHcxi4LSi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/124] dmaengine: ti: k3-psil-am62a: Fix SPI PDMA data
Date: Mon,  8 Jan 2024 16:08:32 +0100
Message-ID: <20240108150606.943031207@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit be37542afbfcd27b3bb99a135abf9b4736b96f75 ]

AM62Ax has 3 SPI channels where each channel has 4x TX and 4x RX
threads. Also fix the thread numbers to match what the firmware expects
according to the PSI-L device description.

Link: http://downloads.ti.com/tisci/esd/latest/5_soc_doc/am62ax/psil_cfg.html [1]
Fixes: aac6db7e243a ("dmaengine: ti: k3-psil-am62a: Add AM62Ax PSIL and PDMA data")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20231123-psil_fix-v1-1-6604d80819be@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-psil-am62a.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ti/k3-psil-am62a.c b/drivers/dma/ti/k3-psil-am62a.c
index ca9d71f914220..4cf9123b0e932 100644
--- a/drivers/dma/ti/k3-psil-am62a.c
+++ b/drivers/dma/ti/k3-psil-am62a.c
@@ -84,7 +84,9 @@ static struct psil_ep am62a_src_ep_map[] = {
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
@@ -95,8 +97,6 @@ static struct psil_ep am62a_src_ep_map[] = {
 	PSIL_PDMA_XY_PKT(0x4309),
 	PSIL_PDMA_XY_PKT(0x430a),
 	PSIL_PDMA_XY_PKT(0x430b),
-	PSIL_PDMA_XY_PKT(0x430c),
-	PSIL_PDMA_XY_PKT(0x430d),
 	/* PDMA_MAIN1 - UART0-6 */
 	PSIL_PDMA_XY_PKT(0x4400),
 	PSIL_PDMA_XY_PKT(0x4401),
@@ -151,7 +151,9 @@ static struct psil_ep am62a_dst_ep_map[] = {
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
@@ -162,8 +164,6 @@ static struct psil_ep am62a_dst_ep_map[] = {
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



