Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994221419B5;
	Tue, 27 Feb 2024 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042254; cv=none; b=Mf7jFPRfjnFHShIx6TgK1tSoS18dwLlstcQZTbF0Lo91fPyhFYTGiRKB3Vxipo+T0N7iOIE9qdRCKDXP14Q8XC1UJItBZ8uyqKrEly1p+h9lqnWk12QPrWeBLLgVEKqOyV8tPO1MAXDQz9o5eqTHvWdpFlUb40ctIBjA5nPnCKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042254; c=relaxed/simple;
	bh=f7K5HBNtrAz74U/GybPyGCFskuO9XYU4DTrQzZE6w1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcdKn0xyJ8/55a961+0fGkJmi7VRDBEsewS/lPyiWWf573YkGrkXOmo4teP5saKsxBGLUhIylMFDx2oOocUh+y9p3mPVhOZyKi8H65Z6/67k/YrYnamRgZJSrvmBSwVg6fWlI9d30UVeL0ZoWqU0Jhanlm23tIQtH+joe/hXv3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2jte5S7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2jte5S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7591C433F1;
	Tue, 27 Feb 2024 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042254;
	bh=f7K5HBNtrAz74U/GybPyGCFskuO9XYU4DTrQzZE6w1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2jte5S7H9xYXvTPrDbxvx0UvCZ+9sBuUnDFib0tRyrFoALoyYm1gEXd0Et0CBi41
	 2sCkWyM/6xY96TEa8gDAnzkRoqcQEosTj6a8+QCA3c2jZEjPZkOkrCJke1hRTkq0DX
	 uZhXk5TVFHhzHzI2DdFsCfIH8R6cAXIYl6u/129c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/299] arm64: dts: imx8mp: Disable UART4 by default on Data Modul i.MX8M Plus eDM SBC
Date: Tue, 27 Feb 2024 14:25:26 +0100
Message-ID: <20240227131632.700619143@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit f03869698bc3bd6d9d2d9f216b20da08a8c2508a ]

UART4 is used as CM7 coprocessor debug UART and may not be accessible from
Linux in case it is protected by RDC. The RDC protection is set up by the
platform firmware. UART4 is not used on this platform by Linux. Disable
UART4 by default to prevent boot hangs, which occur when the RDC protection
is in place.

Fixes: 562d222f23f0 ("arm64: dts: imx8mp: Add support for Data Modul i.MX8M Plus eDM SBC")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
index 13674dc64be9d..116bf9738a8a4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
@@ -484,7 +484,7 @@
 &uart4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart4>;
-	status = "okay";
+	status = "disabled";
 };
 
 &usb3_phy0 {
-- 
2.43.0



