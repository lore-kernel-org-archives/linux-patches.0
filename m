Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358D5230BC2;
	Mon, 23 Jun 2025 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686079; cv=none; b=rVkgFU7D01h3P+DbC1SyO8e4FEAIENAbfPzF4MqGeIR95iu2cxCn6mirEvEb+AEGlhjHyuihJ7JSYJNPPycPsogukxd35WXPLm1v36d4Av6GnaR7cy7e0ZEdru+MnrabUzwI5aCO37RT7ogStI+28MIKaogiKdjtTdYDJpcYsA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686079; c=relaxed/simple;
	bh=2GigGKsf0FsqaWHCRhyagZ93SyfYtbTzg7Ja4p3fPMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3aGWplfpIK232OMGe0HXoQAV//XAt5yz3UwkZkh88nwII5dZBiE/E33VmDFWxRyqoCsoirzxwqX2xB8BGtggGxc4HwxgJzlobu4P/IYfkenTae+ZnInjdYpUTQ47z6ckjg5VuLVDEJ4tS4KnUZu+J5LymC1f1hdSS3HhahPItI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR3qKsH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR3qKsH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C923C4CEEA;
	Mon, 23 Jun 2025 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686079;
	bh=2GigGKsf0FsqaWHCRhyagZ93SyfYtbTzg7Ja4p3fPMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BR3qKsH4SOWbS4GT7PyzqGDMXgjhmcC4W9YBCfTplVaOFSIfiNvRtJCHCNJrB77/v
	 59Z7GgJ/KN41S0IYBPHxbo5bKL7gB5Z+dPQF+hpOIfMzM4vkTrVxCycY6Xmto8cl1e
	 d21JbWSU5BQBQ/Tjx2qP3PRbOfugS0FG4wpKEeRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/411] arm64: dts: imx8mn-beacon: Fix RTC capacitive load
Date: Mon, 23 Jun 2025 15:03:42 +0200
Message-ID: <20250623130635.343863675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit c3f03bec30efd5082b55876846d57b5d17dae7b9 ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 36ca3c8ccb53 ("arm64: dts: imx: Add Beacon i.MX8M Nano development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index 3b2d627a03428..4c339b06c87e5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -240,6 +240,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



