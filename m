Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024799;
	b=DgO5Jp5Q+Vc0zoNZVIjZNRvobJ/5yx4axuxPR8eEai9u5m7og15fmYn+s3eZEDvwPa2Z
	 c5haRjsSziyDqRxLJozw4sS1aEpQxFXkYtIWlcC3F451XWojIbj2AfC0BQnMheTV2ubXA
	 /TwDA02zXXymKESMSTCBhyH/lcpiE6umWEWFOj0ueahcy4kXwBcBLkT9rpq/hWHiSb1yT
	 lzdtTL3McGhmugLoov1S6xjwsESE7+Cj4HnplkLgrDJYA7q9Z1pauAFzY+eOutb558+ER
	 bkjpc3wVDB+Vx3PeRta9Nx1PFFcBu/zbtkPG84HZ4GXbLJ0kuBOE7l25FkbN0VIhzrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VfmuVkY5/jh0PSqy6XEk2/CILEDX7JYuekzz0aw+b1I=;
	b=Am+gOcs0BJzDxCbJGiTN1qEsGx4uLHeZklMNmPXJSmLrD+3TGsdurGEZnJlYWsDJN3LN
	 i6K4O4Shvyjus0W6WzUuv4AhOl+wioVwu2AFoTevYyYa+uRo6v9j42fl3qmBbD9hr0r0b
	 EOchfVWVdpuHNxah9XTzaVAiPrF+RxhuMjTYpYms42YCr2rVwKdP/Wrhsfb1QCYb44KVZ
	 vVJvtkhj4ZVg5ErszSBGMmn4d+mfITC6EJwwIamZZIq8ikmCNH9QCuVEU3YPG4fMrBHvO
	 w63eZRQXj3X+8Vvud7bueSV/OffZV1KZGroF9TULFs4EITxU04uWMWGbfbgvW0M+6kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JO8Ex/+Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA8606A31C;
	Wed, 18 Nov 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JO8Ex/+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329AA1F000C4;
	Wed, 18 Nov 2026 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024799;
	bh=VfmuVkY5/jh0PSqy6XEk2/CILEDX7JYuekzz0aw+b1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JO8Ex/+YamHNeaC1qLAO8RUeqBbqSStd00GzRiNlY42RuswK0eGndP8Du29XdFJzh
	 NnF43WnAQfTvAP3cMS2H2/1I/X46YCYSrIFya4JddtSZn0WtoNkJd6dddW73tRFWd8
	 wdWzi6faBENsQDBBZYjTFjf0W7HPns42spI1No3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0852/2151] arm64: dts: imx93-9x9-qsb: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118150153.289874589@linuxfoundation.org>
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
index 197c8f8b7f669..d06d1add4bd03 100644
--- a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
@@ -76,7 +76,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -212,7 +212,7 @@ &cm33 {
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



