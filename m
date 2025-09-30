Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22442F6167;
	Tue, 30 Sep 2025 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246025; cv=none; b=CDkCrl0dZtlyqll4qEnvHM0uvkvoP9FqKv8hYm1NSQ0iz6MGXB7mAVASNyuBek8fS5c5KSfiC0b9P803YmmekHElgXqCVAxNCdnko+VrMfUSZ8GaKdcm2Sl8NFNe6HVQkS/+U44V1dT5vJR94VW+cv0NrOtGCumI6ocapI3fOgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246025; c=relaxed/simple;
	bh=zTlkye9rEBRcx2qBvKLc/RKpPsHqZFX/4I8HDJThXhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfDk8Q1f/ZqFITQfs3nZk2YMtuuGEvDngCY5E9kUMCY3M1LoHhUZFJdB/XUPGcPI8fLJmQunwt/VpEvQkCkb58/MSwv/akip2dDgXCOWn/dje4bN4TS/tRznIwiYHe/MqYME0NzZsV5kq3gChmHSKRLu5O4zgUVwTQB+nvV3FPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LndKTWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LndKTWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07726C4CEF0;
	Tue, 30 Sep 2025 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246025;
	bh=zTlkye9rEBRcx2qBvKLc/RKpPsHqZFX/4I8HDJThXhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LndKTWRQW8/MWA7Hb3dWOMCEAJQc1ksylfpa7IQ6OAJrp2Lq5zif7li4980mEdbw
	 +KP46INfTM4qnFlmGnMHhoxU0Y4uAWS5+vTSRJso+IEjM+tqfL4xnmMJAsJf2z+hwp
	 gGeb58XMbMxJB0GahjW1LKPbqtZKpSAs1zApklKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 29/89] arm64: dts: imx8mp: Correct thermal sensor index
Date: Tue, 30 Sep 2025 16:47:43 +0200
Message-ID: <20250930143823.114687871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a50342f976d25aace73ff551845ce89406f48f35 ]

The TMU has two temperature measurement sites located on the chip. The
probe 0 is located inside of the ANAMIX, while the probe 1 is located near
the ARM core. This has been confirmed by checking with HW design team and
checking RTL code.

So correct the {cpu,soc}-thermal sensor index.

Fixes: 30cdd62dce6b ("arm64: dts: imx8mp: Add thermal zones support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 40e847bc0b7f8..62cf525ab714b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -283,7 +283,7 @@
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 0>;
+			thermal-sensors = <&tmu 1>;
 			trips {
 				cpu_alert0: trip0 {
 					temperature = <85000>;
@@ -313,7 +313,7 @@
 		soc-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 1>;
+			thermal-sensors = <&tmu 0>;
 			trips {
 				soc_alert0: trip0 {
 					temperature = <85000>;
-- 
2.51.0



