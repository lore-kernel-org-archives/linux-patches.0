Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6D134D4F1;
	Tue, 16 Dec 2025 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887683; cv=none; b=l5HsdoOQoMY21PxaTOCWpv/MablaSBEDsI5WQLBSaxcq2AlgP4LFrUkyiJZcB365t6LVJPIaXf1FmaTeHfA2kYxMW3uGNgJgaI2uD8Pg0IdYrkRSdsTHgtuZii7U0obkaQ1aROdCiqHMGz/wru3Lv93t76QD6RpOG3lt6AkXl3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887683; c=relaxed/simple;
	bh=VlJTFW2o2K7P/FmjCVDi3WQDUQWoZcPRSJput8InFZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYWl3BzBmrVRISTToaB5hPvsuKA9W8KK6092/13FSUVM6udwIe56S8SVHNu5xxvLW4b1aCMIi92MDMVbI+a4L1IbVGAgXTlVv7g4Dt9nJmB2+n3nDLc+56YADVxH2Bbs7PCL3bVlkLZxSVXM1U2bwuT337zk31mX6HAtZmZoEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOb3Nxjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOb3Nxjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF10C4CEF1;
	Tue, 16 Dec 2025 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887683;
	bh=VlJTFW2o2K7P/FmjCVDi3WQDUQWoZcPRSJput8InFZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOb3NxjfczW/piIwYDAUNT+8tao7hxHzIkria6YHFLbiY5lv3LtHMTW/c8T0PsoKI
	 yUo0Rwfkc5VWp/PgrQ4Vbzxh4lLyUc8yVhZr7gQrGExWN8DE7GtgI5Yc1pDunxcw1i
	 4mPI+CGlY2BVo+05dVF88KHLgzDYljuarF4/McD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/614] arm64: dts: imx95-tqma9596sa: reduce maximum FlexSPI frequency to 66MHz
Date: Tue, 16 Dec 2025 12:11:12 +0100
Message-ID: <20251216111412.419329482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 461be3802562b2d41250b40868310579a32f32c1 ]

66 MHz is the maximum FlexPI clock frequency in normal/overdrive mode
when RXCLKSRC = 0 (Default)

Fixes: 91d1ff322c47 ("arm64: dt: imx95: Add TQMa95xxSA")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
index c3bb61ea67961..16c40d11d3b5d 100644
--- a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
@@ -115,7 +115,7 @@ &flexspi1 {
 	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <80000000>;
+		spi-max-frequency = <66000000>;
 		spi-tx-bus-width = <4>;
 		spi-rx-bus-width = <4>;
 		vcc-supply = <&reg_1v8>;
-- 
2.51.0



