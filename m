Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664BF2ED84B;
	Tue, 17 Jun 2025 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177864; cv=none; b=hoKnNjmgQL5ie6yay+vFLY8qv0IJV7DsUDJHYvRqAEgEhgiKSeOp5GZzdBfeQmRncq6lgaE3I9p6qlDr2f13eeJyOoOhZvrbVABQaObt82k0vdQ0Y+f5QVNs/Jp4FYKDlrPMpMeYW3uTPDyWh071ccOZANcOp3biRZm2TcOBKA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177864; c=relaxed/simple;
	bh=NVn76SVDrEgOE5MN+/gz2RP2dsBiZ05JrdANSPSrzAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwwy5J7I/rmQmM8x/Ia0Gci5DJ+6Bzky6A/Vy1RndNr6OLWuFLChA9Jf/JMagaikq7qqGkcyyJERy/ZvJvsmmHR5hdQRhTiZwSx9y0hdFlGMUiC539TuFJ7DshsZyLw70NnVbt2e1OdGvz8tmYZoCDzZGYIlEHbhnosY7Z6C30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgEH6eHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgEH6eHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFADC4CEE3;
	Tue, 17 Jun 2025 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177864;
	bh=NVn76SVDrEgOE5MN+/gz2RP2dsBiZ05JrdANSPSrzAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgEH6eHH7Z5kog91gBM2TJK+pSrUhygX6pfXmfiuKUG4ljjb28XMMQCbz4C8tUA6o
	 tXlBF2sxvoJ79Y4yrysytUUoCTGZe90z8n0s86cyR/zHLY1Cfa5FRAj2DW26cX64QL
	 9m5DwgBk/0uYWttVuRcuOgxXFwN4cyWQOx+5dKws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 374/780] arm64: dts: imx8mp-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:21:22 +0200
Message-ID: <20250617152506.685888387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 6821ee17537938e919e8b86a541aae451f73165b ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 25a5ccdce767 ("arm64: dts: freescale: Introduce imx8mp-beacon-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-beacon-som.dtsi
index 15f7ab58db36c..88561df70d03a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-beacon-som.dtsi
@@ -257,6 +257,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



