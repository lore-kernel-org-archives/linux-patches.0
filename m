Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDAC273D6B;
	Tue, 12 Aug 2025 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023453; cv=none; b=dWNe+jXnGMZj/c+KJeOgXBoDGoQj0lLNPQptH9qt84yEw8gsZ8oQ35iMBdK4bi0tCTRp69OWJTk427P+dr+MnKm9ZlrD9Bv76GIMTSB2w7bSRiCDnSjzvBs3H4TzZ89sFGqVNalbXxvL2Jy6cx4So5ettGSE/6vKD4DAP0+D9+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023453; c=relaxed/simple;
	bh=YQbca+1WtXh1RxmhYP6tLQD9vynGk+GIdkYkscFTn4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RweH2oWupDeal5RjdeT+uEI1EVqttoXey5OP7MiXQ7diGvLbtFTFsx5G730a5NeWN7tGUo1siSHth/Pk1ix4kUoNhcfVtoEd7LlbLcYoBNhO5edaGHGwvpNQHZKtu4iob65I1M2xc92xS19nn4Ei33vW6dsLFfAaiIyiJvMszW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2r4pxkjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2r4pxkjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EACEC4CEF0;
	Tue, 12 Aug 2025 18:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023453;
	bh=YQbca+1WtXh1RxmhYP6tLQD9vynGk+GIdkYkscFTn4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2r4pxkjqkqufaeQi9YhioqYJ2I69y48YhquI5L2vHNNd8PDKaK5Ira2ocCmzukC4x
	 M8OrcjiKQoD/eEvdmMf7IeQkUjOiTQ/yPnoTUdQwps3/a96jBo09YE9oHcdlGlDwaR
	 ACMvFDg2wkN5afPA3x01IW5alaoi8X3CYAi9GXY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 084/627] arm64: dts: imx8mp-venice-gw74xx: update name of M2SKT_WDIS2# gpio
Date: Tue, 12 Aug 2025 19:26:19 +0200
Message-ID: <20250812173422.500682190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 26a6a9cde64a890997708007d9de25809970eac9 ]

The GW74xx D revision has added a M2SKT_WDIS2# GPIO which routes to the
W_DISABLE2# pin of the M.2 socket. Update the gpio name for consistency.

Fixes: 6a5d95b06d93 ("arm64: dts: imx8mp-venice-gw74xx: add M2SKT_GPIO10 gpio configuration")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 568d24265ddf..12de7cf1e853 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -301,7 +301,7 @@ &gpio2 {
 &gpio3 {
 	gpio-line-names =
 		"", "", "", "", "", "", "m2_rst", "",
-		"", "", "", "", "", "", "m2_gpio10", "",
+		"", "", "", "", "", "", "m2_wdis2#", "",
 		"", "", "", "", "", "", "", "",
 		"", "", "", "", "", "", "", "";
 };
@@ -310,7 +310,7 @@ &gpio4 {
 	gpio-line-names =
 		"", "", "m2_off#", "", "", "", "", "",
 		"", "", "", "", "", "", "", "",
-		"", "", "m2_wdis#", "", "", "", "", "",
+		"", "", "m2_wdis1#", "", "", "", "", "",
 		"", "", "", "", "", "", "", "rs485_en";
 };
 
@@ -811,14 +811,14 @@ pinctrl_hog: hoggrp {
 			MX8MP_IOMUXC_GPIO1_IO09__GPIO1_IO09	0x40000040 /* DIO0 */
 			MX8MP_IOMUXC_GPIO1_IO11__GPIO1_IO11	0x40000040 /* DIO1 */
 			MX8MP_IOMUXC_SAI1_RXD0__GPIO4_IO02	0x40000040 /* M2SKT_OFF# */
-			MX8MP_IOMUXC_SAI1_TXD6__GPIO4_IO18	0x40000150 /* M2SKT_WDIS# */
+			MX8MP_IOMUXC_SAI1_TXD6__GPIO4_IO18	0x40000150 /* M2SKT_WDIS1# */
 			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x40000040 /* M2SKT_PIN20 */
 			MX8MP_IOMUXC_SD1_STROBE__GPIO2_IO11	0x40000040 /* M2SKT_PIN22 */
 			MX8MP_IOMUXC_SD2_CLK__GPIO2_IO13	0x40000150 /* PCIE1_WDIS# */
 			MX8MP_IOMUXC_SD2_CMD__GPIO2_IO14	0x40000150 /* PCIE3_WDIS# */
 			MX8MP_IOMUXC_SD2_DATA3__GPIO2_IO18	0x40000150 /* PCIE2_WDIS# */
 			MX8MP_IOMUXC_NAND_DATA00__GPIO3_IO06	0x40000040 /* M2SKT_RST# */
-			MX8MP_IOMUXC_NAND_DQS__GPIO3_IO14	0x40000040 /* M2SKT_GPIO10 */
+			MX8MP_IOMUXC_NAND_DQS__GPIO3_IO14	0x40000150 /* M2KST_WDIS2# */
 			MX8MP_IOMUXC_SAI3_TXD__GPIO5_IO01	0x40000104 /* UART_TERM */
 			MX8MP_IOMUXC_SAI3_TXFS__GPIO4_IO31	0x40000104 /* UART_RS485 */
 			MX8MP_IOMUXC_SAI3_TXC__GPIO5_IO00	0x40000104 /* UART_HALF */
-- 
2.39.5



