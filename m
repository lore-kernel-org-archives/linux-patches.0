Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030353;
	b=hV69cXNbgZypFS7aYL9sV/a1KSMiUOl07k9TXNpcniGLs7DULnVCZpjTohUikAxdVoCi
	 uRAw+Hjr8CbXJZcOSt4TTKMrp91Q3BjwknjpvDV1TdyxokLaPKTMCqwI0pOUZHGMYQq4u
	 Ch5PXUovZEb/BjZWCkDfGs2V0w1PNDwefIwa/hwQ7DcCtwfd0UmNGdxmurObVO+Qn486A
	 cYhxRdkUEMYMZF01sU/Q6VzS2QfSAqr4N4c2Am3lzFeIOxTdzkHqpWTK9GmyiZApuPXuZ
	 PA1EGSUG7zzDuuf2bzLuOOB53d8RYC6gkb9jEcjRimLeF0QLsq/LJk5bRKLyru41nRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VddIcLFjqZ4VFaZj4xwOz/SA5nOZa/t1RWbpnx+BFbc=;
	b=voXxANagsQ4No8Ni3wP4TaG0/mArVAPecfiGb+4uIbgZVbckue6xIqY4q7GedAaluh32
	 iPk1caOiVmX9ttTVzinQmWN0m1sY1YosA8aXB4Oj6yEWEp/hpbefjmH2wOSKwIXkd8DF0
	 p9qxKL1eh3k7tAAwjQB7DxhhWNsQdgC55YgBq11886/enIE3QelOQZOxpx72DeLE8MqdG
	 u6WmUxZy+IjK+gsQIPyFkp0O831e9y43ZDZWgWrA4ZJIodqCFWLyjdn57HS32NVHWhvnh
	 m5hT2N42VKX71IhMPw9PrE6Q+z7r0pd7Jjh8d8DIkTtjl7r86jizAW/20tS1ZXVYC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvjcKasE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56741606B101;
	Wed, 18 Nov 2026 19:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvjcKasE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1761F000C4;
	Wed, 18 Nov 2026 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030353;
	bh=VddIcLFjqZ4VFaZj4xwOz/SA5nOZa/t1RWbpnx+BFbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvjcKasEjRAmF0+Jol58FHPYaPmXC5hgnRI0TsJAm5qvCZaLlB7/J3DtR8AiG/8rl
	 JkJDAiBc1wTKqX1PtgdEtN7DA6ikWrckzDILoJTiaAaoN+jNMv+AOGuerAdmDrxeYZ
	 v5EhcmtJxDPzmgoPQaRKahlZM5z0lb1KesWJHfdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0674/1756] arm64: dts: imx8dxl-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150036.106270867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4caaecc192277..f6232014ffb15 100644
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



