Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63702189908;
	Tue, 30 Jul 2024 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355572; cv=none; b=F5H4HFA73CKjTPRBZEVBL0WdKW7vYvlGd8AoekjvuO4uGOa5Rj1WJ4Wf9OC3fuxJDhIsYlUiz0CWUsdvcvn+rudtYxnxPX0vdC3sMJHIfzbqYuUPDb/IL3kuoE6PenYmlRWpoyIYcPDQc0poMe6RxaqA3Hz+BEvKuwWwc7JVmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355572; c=relaxed/simple;
	bh=9+qymqfUbCl4/XWwJfBgLW2hm7f6KIP+53dxzXW4T0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEXy0orUM5hBthLUmnQ8LJJmJND/XR/9/6mhoQn+vDhiBAWqoBX7Yf8WZU3tC3Q1l9xlN9fUpSrGs522901954a06os9NhrWfaJUsixsCYNJ0UpOHPehwNY5k4nLrWp98gWVR4KpfIKJbWTkbuZE/P6ONKJMFtEleVBR0W8xNiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDbCdBMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDbCdBMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10F2C32782;
	Tue, 30 Jul 2024 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355572;
	bh=9+qymqfUbCl4/XWwJfBgLW2hm7f6KIP+53dxzXW4T0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDbCdBMktzCxLWa7GuwmtJdMcQnoNUbZFRR4wvUYWND9Y9NcJwSBc3dGgHE6Or3nF
	 MsFb8DiqCMKECmSpCLaIzhXP5aVolpbjFWi0vQYbCm2hI91RhFghLbFKIsRlGE6YbK
	 i2mL2DBhRO/Dg12EMdPWIYjhewNxQw/bXjUecyT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/568] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Tue, 30 Jul 2024 17:42:57 +0200
Message-ID: <20240730151642.596578602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index 78cbc2df279e6..668d33d1ff0c1 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -732,7 +732,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0



