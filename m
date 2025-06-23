Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434A2253B47;
	Mon, 23 Jun 2025 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685603; cv=none; b=XQ04myXxuhP5xjjDssgJPOLRFULHr19pAKOjP2UpCnNcE1hlV/FfASXn6DwltSSPVswQf6pskrrs33fJvCO7TbBgrMCBf/BpFT290wXKCOKvEG72tm6g5hxyp3kxiCd0b5LHO00JNIzzBLBf9fM6Uv4ZrTLwdenaP2a9lwdaomU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685603; c=relaxed/simple;
	bh=pMTp9b5q8/g0GLzZ2e2G32bYnljWUAKxh5+Uk8ha/ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l85jVygFSSQUrCKzzY/uuj35RTynnMPnPHMebdMiPfkyRIxNQW/JBrQxqVad4aLfuMcuZc4YUICVbKW2rD4DpQG51JM5gWscwXZ33bRZxjQhKAEmqa9PVxan7yw5mQoaxu85WVD/6wiJEIVUbL85lqSVxYha5p1unJWJ/J00hYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbw5W7WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbw5W7WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB529C4CEEA;
	Mon, 23 Jun 2025 13:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685603;
	bh=pMTp9b5q8/g0GLzZ2e2G32bYnljWUAKxh5+Uk8ha/ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbw5W7WWR3aZAZiL/85E2s5aIIDaECCHZpCernQI57ud+5CUOjSQA1wts5uIpFK21
	 hG5UPr3ni2/LPrJiR7ghzrqqT6RQSQMdHq//1nWHgC/UE3x/YB3b6QlwtBD7QVIDd/
	 ipQ8W4yLdZpLUeBS+qPRrikOIGqkyVmr5zFNcGaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/355] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130628.694603367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b88c3c99b007e..34b2e862b7083 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -194,6 +194,7 @@
 	rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



