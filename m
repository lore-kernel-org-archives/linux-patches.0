Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16B2285065;
	Tue, 17 Jun 2025 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176668; cv=none; b=J/JcqjoVMDDH8XWbg0V6/RrskRPHoI2sDnba/V4wkb1egM4JKBVuJI1fQsKmvy80GdDCYcmDAbxiqcLwBiL1hSa5ih/lkAJtFL3mWqFr0wrXFfLaYAfXgDS9Z0iMeWw1CSfpWWtR79b9FTYogf/Vne2/VqKMnvsRveIkhHkD8MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176668; c=relaxed/simple;
	bh=NQoaT6JTvWxe+iIGCIb/qhn/7p7jYrhHrdYdtf9Yw+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyqhTlkYrQowggjMV/GKV7HlpGMzXBZRMfosXzazN8xNRn7lkp1EVImz/2OPhR80OYxa9NFkfossStEsub8RiilGM1JJVyjHSGO9Qn0tXUz7m4Uc/UlFtRK+TlhEDoIctZEmwcPzjIOteYe7h+PnyfgqZYIwUS5rZxTQ7KXXUzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jRf7289; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jRf7289"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F78C4CEE3;
	Tue, 17 Jun 2025 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176667;
	bh=NQoaT6JTvWxe+iIGCIb/qhn/7p7jYrhHrdYdtf9Yw+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jRf7289tI3GMzltqrvjr3tIqTkTIzP4OISv6VcHGcGNLML59z5EenLEppzpA2OK1
	 U64DEKuQIaIM7/hhU0nuA5YfZ/OZYiaQVWMbdsJ/HZPA1tN3CPVqV3ibt35XhlY12w
	 E0tkHBLCTnfKDOIg3bCgCBUGNp/M/lSO/zHENLQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/512] arm64: dts: imx8mn-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:23:23 +0200
Message-ID: <20250617152429.225007542@linuxfoundation.org>
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
index 2a64115eebf1c..bb11590473a4c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -242,6 +242,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



