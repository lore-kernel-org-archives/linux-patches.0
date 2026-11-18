Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030367;
	b=KmMga6vJjgQX8ToWM63iS20WqhzT7zfqXHWtBEpABLFmPkMRZBeNjUkqUpnPIYT88k9/
	 ksHVPRxWck54ci3QPNmFXSDNU3Oyj8W5pgDESeNk0BRpRahKRcA4CGiSntNQQZ/xdDU/6
	 FyNONMx0PHE5de9e0Cnr/FQGzdNO/I7feuImkkxBVFu7/ZpyWsg8RSR3dS/mVi4GKr+Fz
	 RG1RIq0wMQPDF1QaGBKASo44ojpz1b0iEN3MNmSNPHxjU6RS54F9QL8ZDcf8wxkWMwoc4
	 SHw5y95tF+Sbacsgylcyz2hbagp6eZscPv3EtCy0z95VwKhlBXACYvZF4z2gfFamH7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgnaSLATx5kMdKndZutZ9ofaIMWS+3SLtHiOZhFqVY8=;
	b=zEB4JGTUMPHGDC34XKzizcAOLEiQMOunhowbSD/IQD7QfcQR+IQiP8u7BAdlrtmzXdXs
	 50DXbMNgXCJMxL3RgwpNPlp1exa70/kh/BNGXLfRxBxMPLyQhT7z8krNum/OxFvbb3hdx
	 RlGWbns3VRKd3M09I/7ZfF6qxpufsq/EiNR20uclcuNywSjmhPdP+1w1dkvRektwLa8eA
	 xmKvTEY/M43AP4DvKfvMFd3OHgyRrI0dhD/gtc7XY1O6mM5o3HpHixfFm+z81X7fOBebJ
	 9k8SgHfx2nr0dZRQrihBICXYFh6Oa9R4x89b7Zl0Rf/PgdXFx7EjbRcLgh74Be3Fe0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMYyvqHv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A02606B101;
	Wed, 18 Nov 2026 19:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMYyvqHv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE091F000C5;
	Wed, 18 Nov 2026 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030367;
	bh=SgnaSLATx5kMdKndZutZ9ofaIMWS+3SLtHiOZhFqVY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMYyvqHvybRPfCb9vcxmVIfeYs0TxWXQ9LZQxuS0HpjaRMqxDgkMow7w/7by+PV8y
	 s6khj/3890d9TqDD+t+1tdw8du3sESk3Pn1Ax7LVtGciC0cWyVtN7FE7a+14rI/amB
	 YHW5zA9WFmts36O4GHgAtwwvRXMEF8injtNeYuOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0678/1756] arm64: dts: imx93-9x9-qsb: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150036.253943930@linuxfoundation.org>
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

[ Upstream commit 475a58b82921cc89805b31e0bc1df91681124a3d ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 0565d20cd8c2 ("arm64: dts: freescale: Support i.MX93 9x9 Quick Start Board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
index 8856835834a04..8fd209e847d09 100644
--- a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
@@ -53,7 +53,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -100,7 +100,7 @@ &cm33 {
 	mboxes = <&mu1 0 1>,
 		 <&mu1 1 1>,
 		 <&mu1 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



