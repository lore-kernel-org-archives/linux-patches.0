Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017752;
	b=jyIRtiCVjFZLAK1mJX/OP1EJdkW051yYJoJnJW5fX3GldM/3XLZ4KQJibwL238+GkgIs
	 OqrrzHRH/oWZFEp9vvweJcMGqs0yHs+qZF73rqkIpo2iCnkg5cNBuflWly8YeLMUZFOdJ
	 7Pe6GXBH6t/vPyYZS3u2aoOT8s0MIVRT5epylJiNhDYD8jBbdo14AQUtsNq+VC09qlW5M
	 n+t3WQ5P5nyOgO8QLvtLGU12Q6h/I3xpi92p1Ic446HUUzPrDXOhk/QyzItb6B+ikBkyJ
	 6vlPJDFvcuhTN4SxTxAUaAii2DipWT9tYj7MURmWQocxbqU1ZIP/ddk3oAm6/QJs8Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QtTBiKwF59ww2PYks0BbR274qlRU4ZWPmYDhkdelBbY=;
	b=tR+X6WhUU8bUf0M1w5jUJozJy3sLflD7GG93Pzupz0lBYSDF2Xx7z1KLcfcppNBuG4NE
	 v12lqM5ihTpeCQ2EAyCgpXsiZ/FxgqA5eBp430EZ4sJsvi9QJHljOjqBuQ9M5gzN+UagW
	 cTfOWxqL7wJHY3cbToWRMJtGB8OQzSvWlN+amV9Cq6CFR5G4IjsiPJLP7xv3ZBvTPKpx6
	 VDPZkQPT+xrop6OrO+a6OFlLktiC/LAMZ8dNRKk9AUlfO9zcvsVzO/IvESVgHblCQTOlH
	 PcxZIEvcvCyXh8HquhUBbwwq5Qsy5FiGA9B4YBM4TMw1oLzVScDcDitHGq/NRmo5VPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zxwcthRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94DC606A331;
	Wed, 18 Nov 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zxwcthRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EE11F000C9;
	Wed, 18 Nov 2026 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017752;
	bh=QtTBiKwF59ww2PYks0BbR274qlRU4ZWPmYDhkdelBbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxwcthRj67H7o1oSPMjMj6mF6H9aYWYsNMXKQUBmwk+R5mj/ZDjAKddB1kLzXR4RB
	 6RnYReRxZ5dBeNeiyLNoGd+sbMxrrYBkHSYol1e8wwO8fBzVu9s310FvZ2e6QEj7QE
	 cC5aLXMmIBt5cJkzg1xMHds10Pa+5jFXZQl51IKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0994/2651] arm64: dts: imx8qxp-mek: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:14 +0100
Message-ID: <20261118150323.685248880@linuxfoundation.org>
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

[ Upstream commit a9f3cf4354022ca0b4a0d12eab7af9858f71c9f7 ]

The imx_rproc driver uses node names to identify reserved memory regions.
It checks for "vdev0buffer" to skip mapping, "rsc-table" to locate the
resource table, and "vdev" prefix to filter vdev regions.

Rename the reserved memory nodes to use the expected names so the driver
can correctly identify and handle each region.

Fixes: 5fa302590f17 ("arm64: dts: imx8qxp-mek: add cm4 and related nodes")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 857a6e5122283..6322ff471175c 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -27,7 +27,7 @@ imx8x_cm4: imx8x-cm4 {
 		mboxes = <&lsio_mu5 0 1
 			  &lsio_mu5 1 1
 			  &lsio_mu5 3 1>;
-		memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+		memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 				<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 		power-domains = <&pd IMX_SC_R_M4_0_PID0>,
 				<&pd IMX_SC_R_M4_0_MU_1A>;
@@ -242,32 +242,32 @@ reserved-memory {
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
 
-		rsc_table: memory@900ff000 {
+		rsc_table: rsc-table@900ff000 {
 			reg = <0 0x900ff000 0 0x1000>;
 			no-map;
 		};
 
-		vdevbuffer: memory@90400000 {
+		vdev0buffer: vdev0buffer@90400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x90400000 0 0x100000>;
 			no-map;
-- 
2.53.0



