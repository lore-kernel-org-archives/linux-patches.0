Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB6202C38;
	Tue, 17 Jun 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175348; cv=none; b=DJ2foHPgo4st5Cs+31l8W182NN4wQxrVz0yFA6vGiGvgtZEUv0TouMY8cnjXoFZOyy9v3hnxlhYqzLVV+/8X8604uIFIi9qC2o/qGefBVxRsVHATUsBoZczxr5DC7fz9+FTgMAhBEmiHT8Bsdru00fhiNQDjXtc+I9RkFHg1zwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175348; c=relaxed/simple;
	bh=+mg0ztrN35vZyumNvhk1GozbyYRKVHpl2PUkHOrqxJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcOmbqtdgzn7bSZc5nbZdzJtU+5xEcSqAztSr1/S0CS/IqmZU8yjdMcGbjGAhveth1/TctmTwQr2mECmyTwloY/m5549GeQx2dI6BJcQo/o1dxn5Lqj7G1J5KJk48+dXlWlJjpBA4lFs+gHZ5LLWH3D2sJCgELz1B0g1dp0ainc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlRwr/f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlRwr/f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E517C4CEE3;
	Tue, 17 Jun 2025 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175348;
	bh=+mg0ztrN35vZyumNvhk1GozbyYRKVHpl2PUkHOrqxJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlRwr/f8sSc+JDfLlq2+PoBZOgZ2Y26Cfm6tfQWpy3/ZGFKJPqOEqnSjm2Dg70xzb
	 6sLjEXLkOLVQKjUAezgtx3CZLO4zGKb9jRzBkGHVuRGVERIgKGDPDyqLh1tjXZoQQC
	 PD1z+ZKql7UBEbzRG+1Wb8dFueRqBUnvnv4T3JmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/356] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:24:43 +0200
Message-ID: <20250617152344.980577851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f264102bdb274..8ab0e45f2ad31 100644
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



