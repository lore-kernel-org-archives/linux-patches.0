Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017884;
	b=gos/WsHzgAC0CzdeVe72CMMbWQbt5A3AFcs9yG2uHieLEsVFpduw5bapm3IOcTbu7UHQ
	 dlTAdcITe6HZtn18LFikmPae8TeWKNO0mJ5MTdJSV11BxKg+8RpgwHGTtToKea6GRoz0Z
	 qIBLKPj0OXAOrykbEuEFUsciBQaIlDearkvlRBLq0dJcwp7FSXPhW02woCkZxNK0PeXIO
	 nwtP5uwTwhf7DVL1DcTJulMYDkf3QlsuRxtwVUrPIkhq8ISCfowcCfv7dyRBZtmuyJaHw
	 T5Tc1PFUzk69iAss8+tJHE9Ldj3AuVhG1AucPDzYV1Sy1H/fpGElBaP5TWGDvccgH8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FeBYLvXkNU6WpZz2LzLM7RKWPv9X1MTSdAknZbm02yY=;
	b=cRJFkLpPKSfXlussSYLlwSP+MmNPuIANuArCxCJz2zWPY8yvo5R7GTp36EjqQUaLFEXx
	 lyaPYTvQKJyxt48N3NLcLT/gysj9wZCKkMeUAStaMlZU3EEoqU2wQzf8KTJcGWCJODoaw
	 rjOvImrgJGrbwZuaxFQE36GgNc7Ga96+e8+GrDdKpnEuPBaRVCaqDOf9dgRpXqKy9UNjq
	 eh7Iaoz+8/bdInO1O50qiK0XxtZyZMbLhN9O6ixb1K7yjzshekzOWOrFHTW1/FvabAh2S
	 XQQN9X4u8ya9KGYm3NLZHDOh5uWKa/WTbMb/rMm/g1OX8SuizT6W4DsB1ibmpsV+jSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/0TcVIz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C6F606A320;
	Wed, 18 Nov 2026 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/0TcVIz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B41F000C4;
	Wed, 18 Nov 2026 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017884;
	bh=FeBYLvXkNU6WpZz2LzLM7RKWPv9X1MTSdAknZbm02yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/0TcVIzv9fY3OxNQ8eRW9JoMVZjSyCdiSZHsoXZM8oqmtMY6Htmu6H9GJ1trMVFr
	 u7hMRbslYUCZaJIkVE+r2dx3Bld+mZ0yXhsrB8qL9m/ay6/pfUbs1TGtQ25u4sfEeo
	 //5cJ96o9vv8TA2xQc5RXMngXpjeYTXhELfCr5b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1002/2651] arm64: dts: imx93-11x11-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118150323.987068816@linuxfoundation.org>
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

[ Upstream commit 7e92e62246c472418230b48c05e9296835b26b07 ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 3eb100e56195 ("arm64: dts: imx93: Extract common EVK description into shared dtsi")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-evk-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk-common.dtsi b/arch/arm64/boot/dts/freescale/imx93-11x11-evk-common.dtsi
index f48e7947cf647..c57a2040b9c2f 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk-common.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk-common.dtsi
@@ -67,7 +67,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -170,7 +170,7 @@ &cm33 {
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



