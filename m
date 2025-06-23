Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A10219E0;
	Mon, 23 Jun 2025 21:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713580; cv=none; b=CTObSyzXsU5uhokKvnPRdenyEWMWW1TMD5ObFQztByxmP0LDkABU1pPnUlKCpwYIjNiq3Wvye0hCQHa7nk22OWGpS6EGhEEmGY3PXDruZqDdL257rXt46zvb8vJRbji9CTV4Eno+qyJPb5d4RnoPIkbvQP30UkdbkszhpP9M6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713580; c=relaxed/simple;
	bh=NmdJ3+UKWawHoQ7ciAMKBg27m1/GNTEpBVrso2xqRDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey4Kmkd0lwaGE3NN9AFOzpQkTS+XZjTqEyZG5SJ3BjAI/7Wx7ERXdgawJj5xxNd83KljoBH9SnTvZv4S3YOeY4UVyihl9uGP7c45GCU647KepPWh0uXjdlPaRaLzhiqZPvUEb+NMsiQW+EvpZnDhH+6qG+8Gd9FsMKY1lOW23iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+FNoh11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+FNoh11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4114C4CEEA;
	Mon, 23 Jun 2025 21:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713580;
	bh=NmdJ3+UKWawHoQ7ciAMKBg27m1/GNTEpBVrso2xqRDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+FNoh11s5cdP5xmE6Sxo36jjcTAEgunch2TS4MYX3wesXg4Zowt631ScRT0S5ukF
	 y5fFEeyVPnraCLifaEtPRRWXcjEB0Tb4WIJFhQXBDNIwuv+PSH4RgMyORQPyzecg1s
	 UimmVrHe5BL89eSziZ+h+PsFeKlgZcevhHIa9XYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/508] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Mon, 23 Jun 2025 15:02:36 +0200
Message-ID: <20250623130648.026537812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2e98d456666d63f897ba153210bcef9d78ba0f3a ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index cf07987ccc10b..140e251094fa4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -231,6 +231,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



