Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017741;
	b=Orm55RA9uSZzu2xAjFK1JyqfkAK+/1rX18rItiOV3V7aJZyw+YUPpya4s9p/GSqJjO6R
	 3/tZTRCz+BDp+UEOQw3CJ+hmSqj6G2APKzxPzHmGGIesH/JyHoqGafgMp8p04Lc1Ib252
	 AX4I9WY4ZBY3TcfvDYRHZlBPsODQkzMsuwyr34sa7G2Yzx/5XadwLQy7krrBwab+k/Sk8
	 UTlI8uiQm2vuVa5y0lSaaalbHtmxewXO5jBiw/ROkJQwqZzAjou3CuhnEI0XA1LELpTpR
	 1U4XPLnu4usAq4ZKGpjIwEfXwyZUh0HHnxqtFmMBUDsVrCexyoL/5eDonDJLGPUGUyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m773r1o8KZKQKEt55EfvVpPzNzy8aQhEvV/uU8ARa4k=;
	b=YVuJ6xEjRLsciy6F0eJXcQOzZd+RcC8IPwKUnTzneH71APyPoReNs/9hF2559oo22kQ1
	 bgFtJcOg7zR2E1qwlcTxrWV/wzNog5HpPSp2oB+0z8mKpMWtwqZit8iNll6dFJwFZRyZ2
	 kAMhSDJCzSxXYdWw6tMMbig5loT9lfCrbpKbrl3cSAyQcVF/qzYR8GcyfyafIUhKiG316
	 L+CNe8H49Bwmr21el3iuotjt7sZHY6S5VdoBC8KWJzscvp2Qrasy9AQMrKyrrd4Gie5HQ
	 G11Z6Mt25vJECXZtjpA3piaBO1IiYrDnMlmtZAfg05FCBRC1wqtk3hS2Z+xrL/pH+qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1o4UI6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC74606A31C;
	Wed, 18 Nov 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1o4UI6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B781F000C4;
	Wed, 18 Nov 2026 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017741;
	bh=m773r1o8KZKQKEt55EfvVpPzNzy8aQhEvV/uU8ARa4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1o4UI6Ces3Tyg5E9UFOuS/RYccpElNY8F2tyhOUommth0uNJMS8zmU8FCt7ccsVR
	 Hm9lRlg1TU7gaSrrTElRDp05eRRssQuUvG43mW3gAndx/1DBdJBE7NQCAUgECfwUdc
	 IyiHGxbWgKfoWS+IANJFN4cxGgeaaVw3j4oUEOe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0991/2651] arm64: dts: imx8dxl-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118150323.579856518@linuxfoundation.org>
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

[ Upstream commit c4e5f1a143799651aba2c4f66860b63b56786306 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: ee39dbd9a6cb ("arm64: dts: imx8dxl-evk: add imx8dxl_cm4, lsio mu5, related memory region")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 0ede0c7ed422c..71eff3efa6d32 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -29,7 +29,7 @@ imx8dxl-cm4 {
 		clocks = <&clk_dummy>;
 		mbox-names = "tx", "rx", "rxdb";
 		mboxes = <&lsio_mu5 0 1 &lsio_mu5 1 1 &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 		fsl,resource-id = <IMX_SC_R_M4_0_PID0>;
@@ -65,32 +65,32 @@ linux,cma {
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



