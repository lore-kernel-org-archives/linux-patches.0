Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE262ECD39;
	Tue, 17 Jun 2025 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175358; cv=none; b=gzI8vqsUXCPlNmhkjFcMAQjcjFwUoU68u8S21qLf4zXxqhh4pNEd72uF3EYXHPmivHBzGTHFJ4wq+8MLZkA3Yz19dxQi8lsOKdGMPWzqj5KcD4zVvdMRs6Y1uSsb3FOvAU/7kpYKJEP5AaXSI94P9S4daKxOWc9d2847Jv6QcfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175358; c=relaxed/simple;
	bh=GeIrQ2Fx3tYAUh7F77ZuoEw1Vn/JAmIzdoyWsamLy8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJSL83XVE8j/Z6f2uKhYu/T3Qkb0UJY6YGQR/UVsJ+B7y4kEyKhDtbJzAshImwCuRfxhpuB1BP+J3F7f1QhjSRApDSIG1rKh5JcHrllIdIyiMD5wt1p+acsuCYVDYS2LIrxJSBCSr+pV+WOtlY2DT7VlcNuMvkwTtsETwSUJE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auVG1eDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auVG1eDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C53BC4CEF0;
	Tue, 17 Jun 2025 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175357;
	bh=GeIrQ2Fx3tYAUh7F77ZuoEw1Vn/JAmIzdoyWsamLy8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auVG1eDUiceVhMg6Jc/rKU7BEcfvALbfz203WWRmiHlUg+7kLAI5RLC194FWvIsKp
	 7clh2ijGQIDPKalcRTB+vAFS93Uc6jaAA9kDYhiNjH55+KN8RcS7RRIgvL+45f4PLh
	 P1o2CeIQxY2akdLwZUxP/4HxkiVK5rK+Ls5ZcdGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/356] arm64: dts: imx8mn-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:24:44 +0200
Message-ID: <20250617152345.019872885@linuxfoundation.org>
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
index 90073b16536f4..1760062e6ffcf 100644
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



