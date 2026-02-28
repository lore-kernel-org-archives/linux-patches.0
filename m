Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF87D346AD3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302080; cv=none; b=rrL0jEXjPHTThJGcg7q9seSI+VgQFjB8XBf0xwZcnVzblyfRpk0sdIMzD2fseBT/l42VhO8u8GKAZ6tIcmnAbhWaNj0i/BhEzIRmxrTTPTg8zxmjK3U/ZCn1XX5DCt1QZ+XjZnAnyqLJcT0Ldihk+EJh2pbW5rZ/2oXvdQBCAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302080; c=relaxed/simple;
	bh=oJRk5CEFJdWaxPzFlasNuLusJiUE0CTCh+WZYNdiXUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7pkDiW3oKbz5seuNg5SFqL010t9E6y1fuEf8lBIJCh2QLiMUMPZrTtvRKmMU9ad7xF9eIxNtJQa91BKuMjM2/1L46h7DerCimVkphcWDZSh6TrTaWhU/VkBdY0DGP3sont0GcMy+hXbljw36/cLiJkqDLQI7TBkEcYClUvjyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbDcOD3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbDcOD3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61925C19425;
	Sat, 28 Feb 2026 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302079;
	bh=oJRk5CEFJdWaxPzFlasNuLusJiUE0CTCh+WZYNdiXUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbDcOD3ALeLLpK3X/4p8X7ivus6f1vDFUev2SIH34k+KbxvD9iNvkK9pmkElf2oh2
	 sFlt2t1+cpui50jSvtAkyIXUSezxMam0tiOT3r+5w37dMu19H4mBYrIe+DMfbqaIxq
	 nW3AO8Q8L6/1bwegpDeAXDYiOkely0r1DNLUXMq4aerU6u+RbNUrQBFCVtjepjF/IX
	 BXpabd3gOC7efhMScisvD6qUTH7aVHxkfa7UXTkiCu3ihAY6Opd1txBr8FKPj2BNcI
	 ZGczXEAFGnYOBwFdLzLkf/QeeKOoqIZ5dgfn+eO53lhVDCMZ6L9bDxlxNNKaGSRAX0
	 YYN3Myf/4uQTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/283] arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
Date: Sat, 28 Feb 2026 13:03:23 -0500
Message-ID: <20260228180709.1583486-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 8401527abb5e3a00c867b6597b8e1b29c80c9824 ]

As per datasheet of the HDMI protection IC the CEC_IC pin has been
configured as open-drain.

Fixes: 418d1d840e42 ("arm64: dts: freescale: add initial device tree for TQMa8MPQL with i.MX8MP")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 258e90cc16ff3..5430b62a3b282 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -810,7 +810,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000010>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_hoggpio2: hoggpio2grp {
-- 
2.51.0

