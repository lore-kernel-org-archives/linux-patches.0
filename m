Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017870;
	b=yw+18krWlLXJz24MjoV+RCbBOY2/5rvRSRNg1/wrBiCzsuaOaBsNIoAklYlkFjjDOBuH
	 G7KoScNvpi4KjwkP3mnW9tS1/e85l+WQKhipVICpitNBCIq7aSFqDv/s2+QyZq2jCJ3s5
	 8e89tgEPaXwLD2J9Etj0kDI3GYRAymo3Mqsf5jYDOD1frWwc0vlT/9/RLll9p694Hyi3a
	 B13uCMa/IUvkFhe+mSQKJGsrwVPaWQlBgAnWkO3gWeyoZ6TySSpwJJLLaHK6GLCOCeFRX
	 hfNlY+/3Og2iVEfpYp/TLODU9GmZiptogy5EFX4pn3crala78yNf0BUFwAlXZAAPpLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKkYGiZTWrdrbBAzskh08LzKCHydpYI6x/QaTa1cv8w=;
	b=fXGbSg2e4U9RRvKpVGuZggvjhDtXg3Xxu9ZNqI/2qqqucpnUnkVjoxIbQlgT2oEJwZ9B
	 0FaNaOcryFJZhBHrGapIY8xlAm1ulLu1ZBtPv2uPY0zwqXjYGfimtWN+qdm3466XxHfPC
	 bC8ZUq9cJi/M7mu2Btyjb+N09CYntXooM5Qula8ouPedYXkTidEJis4UBNaewlBwu4Gok
	 yUYDVnlQVNQAfB4qn6kl3X2Y1G/f/5rEZ3KMH/lEqlSQHUmNwmm6XWQJp7JK3j7BYOiVd
	 c510pRJSTMmcw0jLNbKGin6fUqOPhQOKaV0+XgaZ8Zqc4ToriTJY4ps8luQg6rFeDrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkH9DliG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249DF606A31C;
	Wed, 18 Nov 2026 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkH9DliG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1551F000CD;
	Wed, 18 Nov 2026 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017870;
	bh=kKkYGiZTWrdrbBAzskh08LzKCHydpYI6x/QaTa1cv8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkH9DliGe+Ip5FZvvecL4wGf4gmYzzgf0GYSNNT1M3F2UTU8UoALvlx98/IT0nyrm
	 EYJW/iA/UgkH7U6tluOWoqbvQFNhfrQv+8ry12f4BpWEhhD8pID4FyKWTZTU1xyrBf
	 82oHNwCwCyw8N95EhSdKlTvKHmF8RzLZyqgWCG5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1001/2651] arm64: dts: imx8dxl-sr-som: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150323.948432967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit d8aa7355f91ed71502f588d33200a211f24f58ef ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: ef873f01a1b1 ("arm64: dts: imx8dxl: Add SolidRun SoM and HummingBoard")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi
index 93a0eb4d7f770..83d22ae373c3b 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi
@@ -26,7 +26,7 @@ imx8dxl-cm4 {
 		clocks = <&clk_dummy>;
 		mboxes = <&lsio_mu5 0 1 &lsio_mu5 1 1 &lsio_mu5 3 1>;
 		mbox-names = "tx", "rx", "rxdb";
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 		fsl,entry-address = <0x34fe0000>;
@@ -103,32 +103,32 @@ linux,cma {
 			linux,cma-default;
 		};
 
-		vdev0vring0: memory0@90000000 {
+		vdev0vring0: vdev0vring0@90000000 {
 			reg = <0 0x90000000 0 0x8000>;
 			no-map;
 		};
 
-		vdev0vring1: memory@90008000 {
+		vdev0vring1: vdev0vring1@90008000 {
 			reg = <0 0x90008000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring0: memory@90010000 {
+		vdev1vring0: vdev1vring0@90010000 {
 			reg = <0 0x90010000 0 0x8000>;
 			no-map;
 		};
 
-		vdev1vring1: memory@90018000 {
+		vdev1vring1: vdev1vring1@90018000 {
 			reg = <0 0x90018000 0 0x8000>;
 			no-map;
 		};
 
-		rsc_table: memory-rsc-table@900ff000 {
+		rsc_table: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory-vdevbuffer@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
-- 
2.53.0



