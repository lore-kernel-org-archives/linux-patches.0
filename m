Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024791;
	b=IZgTtmjMc8LQM1wHTfkW2WbEQi2p6FaCPzoFFO1+xKl4a4lkRx2QG/KequVxY59TS9rD
	 M+gi8LA7ChJymMVHp0EIM48sD3wjOmoLZu/nJs5fbbkRZyNBT83rfS1OI2Y1FM0pDrTWi
	 uV8KgwFEMzHsMkzhFu49vpO6G3F8i/jBtk+n9/sO2vkK/BmVlBZr8p86TqYTALDs9dTm2
	 sicuwyrYX1usT0gcCyDreshvVhipyy9kyTjJXnqn1Bkdudvl1geCcUj1mbgVOBRIGq2VT
	 GlKgEX8sCmY6ksF+kGSbRrH9fAiKMg/uCG9sfm4biD1vXmVXP2JISEKB8eZdY7V4QYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYs8sX/vyLgUz039mzLahhMH3yu5CcccGR4kkT5zRus=;
	b=0L2vPnNRpW0ikllu4MBt7KBahicX/UGVnNsfr1elyWRVXftigVIztS8iRlBROmzs/7cP
	 qeBMKM2qYLXgK3rk5x2J522sEJOfrlmm62JGljwyDxjk8seo1W2xaA7rmGieMrCfWq+WL
	 lDmdRckIIQQ5922Tjf+l+XyTCt0aH9rWBACfVdUnpETqXdLPLIEuLKl2ZJk8iABYsE+zz
	 TAQXnWTIkEj561upTi5QrndR2l5oJ7wsYMxGk+em9oWeVI2efNG+w6S6W3yUwwNHVlsAY
	 zzbaWl9chiwWRfgVQH40U0V9i6gsWSSbS9hqYu0eXoVbK5U+DICwvojAZ6N9Z38PpyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCduuC08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6066A606A31C;
	Wed, 18 Nov 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCduuC08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B51F000C4;
	Wed, 18 Nov 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024791;
	bh=cYs8sX/vyLgUz039mzLahhMH3yu5CcccGR4kkT5zRus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCduuC08xZHUgaFs0IXF87edGTsmf3U66qF+t7/S2IBBzYiA38Nrz8IgjkeFvwBrf
	 qVHntkUsb1RsoSnpOiafwdI7pqB7M3dAzTIaX1UIttgeAPeKIByMzlBK09HgDNlmQi
	 /l11ePu2ILbbcv1bid79NKU2bueQd3UACsMJ320c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0850/2151] arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:05 +0100
Message-ID: <20261118150153.212136281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f55e49b75c65c3e38e7bbe1d735f79128a50126e ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 014fbffa25a7 ("arm64: dts: imx8ulp-evk: enable CM33 node")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 5dea66c1e7aa0..48a3e40053299 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -67,7 +67,7 @@ vdev1vring1: vdev1vring1@aff18000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a8400000 {
+		vdev0buffer: vdev0buffer@a8400000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa8400000 0 0x100000>;
 			no-map;
@@ -126,7 +126,7 @@ &cm33 {
 	mboxes = <&mu 0 1>,
 		 <&mu 1 1>,
 		 <&mu 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



