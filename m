Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBF2E7199;
	Tue, 17 Jun 2025 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176702; cv=none; b=VIyfkkPkYHk41b1tojgiIxHPZMr2msmgSGwWpolLVvTThZdxVqTYR1Dtz8zQ25U7Yt9+6uYrp2cLIMBYWKFVov1UmG3slP51QSMTROh8Oxf4ZKmlTxCzC7qhI3gTqfS2+JyDoLefEZlPwy+NaATaVSfSEKAPyPyR9VJTFwhQoY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176702; c=relaxed/simple;
	bh=UGZVR/idQ53ZkCRoDZw8EyS2zr9V4GNg8yt1CyNDYuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaKRg0N1wC3EH7Xw9jZgdvTOcJ1GKy4s8zcozKN7wyER3FwZciD5XeAwyMUmDvfBPnTZ3MvOdQbvfBuKzlcE5BL8V9LHletp9MW70/cqejE7lrvD7/TLonerL/GIKU9ULEDliZk3mNXhktOApXcJaJCujNqLzj86InV4qxTR374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjT7Ywe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjT7Ywe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C620C4CEE3;
	Tue, 17 Jun 2025 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176702;
	bh=UGZVR/idQ53ZkCRoDZw8EyS2zr9V4GNg8yt1CyNDYuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjT7Ywe/2OJ5Xi7U6nwNlwfYKv0OygCAYC2dj3tMZmO6n7fghvnL4E8Ms+ZmSeykP
	 T2+Nx1tv6I1fPPoHYtIZvYAJ44sMq3zlbzqtKWtdkfsrn2geyuVPRJQK6EAtnwUaqO
	 d2ppAD23fHW6FIsYWT80KwO1oADRI5g9NSvYOVBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/512] arm64: dts: imx8mp-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:23:24 +0200
Message-ID: <20250617152429.265599947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



