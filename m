Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017744;
	b=4BpB1cd0dkgRrPEB0RGtQgjJtOK5BO1Dss2iliUHzLDYsNtS93qoNZ60oDTmNJVOOlOH
	 lavV7b86eeuFoV3O74grV4lhidNfqUvu4R2ajPCJAQgoCpOy02MG4moyox3/0fVByFHOs
	 UvmhOvT9MEi/bkwSD/GEOP/Zj65qy76ErRnUX4zvlDjnl5Rc0aLzwFG4rCXBsYPwdWq/6
	 EpXzYYmNlf7vrcT0bd1eBQslfnUx3q5R6PMsJH87ejy1aBiVvcQbddFYP8ksuGm/RrgZo
	 tLrr3uKhHNYU/hKLQ8qc0B9Py1KnQWffFlhJO0hyrg0WkhJvdfUkywAivTT8LRQOoNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmzFp2sz0h8GZ/eSwr1eOoCWJukQnTPn6/mU3hqBd8c=;
	b=UBlXUMcrwk1+L0+figSDtX2ePGchYlnZ1bGhmmsG9AzYiMMgXNxiqKHwcdPv2bOT90dC
	 +ot3awxpIMU259C8ds5jcr2reKqcCLw3z3dWtPgg13hiRNHS+v1rKCubFfIkX/REuRrWk
	 vtKlyZvanF78BY0oFUiO+3fTyPHvGuo2oqvV0UChvWSRrB2m5mX5R8MIofb8uQNbCpkfo
	 s320SmKGsghVmCKl1j2rK4JI1U+tIpjFJv6iOXpdNPqIOW2Fybkg07tHUgrjQQBK2WTen
	 8GyCRYhiKJcHXT+0Lu1zeTqn6FJAI8ls8jG/P4S2eP4460ErNUHyxxq85DEqZI7vIhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVt8bLx8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CCC606A320;
	Wed, 18 Nov 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVt8bLx8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E261F000C4;
	Wed, 18 Nov 2026 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017744;
	bh=kmzFp2sz0h8GZ/eSwr1eOoCWJukQnTPn6/mU3hqBd8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVt8bLx8/C9BFk2+ejkLG+qyY0yeWIp8H+v/kzM+49Ss7ny72K2lWAaz2H57MeucX
	 +uTR5HKIQdgdPCJYvr1a2iwXMiCGRKPv5jLhddzSCSCdAKnISJDqSlWRb7B3dNrs7d
	 l7W7rh/prwTtvXzejIAmEH5+mNRY61NrsMXuFQL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0992/2651] arm64: dts: imx8qm-mek: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118150323.615408397@linuxfoundation.org>
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

[ Upstream commit c712a46c10d38ce7869a9d81d7986e844a4e9f24 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: 52c9971edd4f ("arm64: dts: imx8qm-mek: add cm4 remote-proc and related memory region")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index 9e49ac377162b..8b67fb5d670da 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -44,57 +44,57 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		vdev0vring0: memory@90000000 {
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
 
-		rsc_table0: memory@900ff000 {
+		rsc_table0: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdev2vring0: memory@90100000 {
+		vdev2vring0: vdev2vring0@90100000 {
 			reg = <0 0x90100000 0 0x8000>;
 			no-map;
 		};
 
-		vdev2vring1: memory@90108000 {
+		vdev2vring1: vdev2vring1@90108000 {
 			reg = <0 0x90108000 0 0x8000>;
 			no-map;
 		};
 
-		vdev3vring0: memory@90110000 {
+		vdev3vring0: vdev3vring0@90110000 {
 			reg = <0 0x90110000 0 0x8000>;
 			no-map;
 		};
 
-		vdev3vring1: memory@90118000 {
+		vdev3vring1: vdev3vring1@90118000 {
 			reg = <0 0x90118000 0 0x8000>;
 			no-map;
 		};
 
-		rsc_table1: memory@901ff000 {
+		rsc_table1: rsc-table@901ff000 {
 			reg = <0 0x901ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
@@ -456,7 +456,7 @@ imx8qm-cm4-0 {
 		mboxes = <&lsio_mu5 0 1
 			  &lsio_mu5 1 1
 			  &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table0>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>, <&pd IMX_SC_R_M4_0_MU_1A>;
 
@@ -471,7 +471,7 @@ imx8qm-cm4-1 {
 		mboxes = <&lsio_mu6 0 1
 			  &lsio_mu6 1 1
 			  &lsio_mu6 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev2vring0>, <&vdev2vring1>,
+		memory-region = <&vdev0buffer>, <&vdev2vring0>, <&vdev2vring1>,
 				<&vdev3vring0>, <&vdev3vring1>, <&rsc_table1>;
 		power-domains = <&pd IMX_SC_R_M4_1_PID0>, <&pd IMX_SC_R_M4_1_MU_1A>;
 
-- 
2.53.0



