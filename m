Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DAC7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D57C433D2;
	Mon, 24 Apr 2023 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342982;
	bh=uOOAHxGpEVE0S3mBFrPUezoTj9VkFZXc7BOKm1bVx1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svyUpWrqgvDE8/GHQxgK3epKNUfKmCe700saaSQG0rjskORzyxejBgEG/+aqqfoDE
	 SWY/dDCkJYN0SO1ywe1nlEgzVx5TFElWmlQ8WmdVy3W4JMbFWJx2mUqaOjCmz95xg7
	 bv0sHO63pTbr2jiu3yclQE+uZEPrRJXwpyThy3Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 005/110] arm64: dts: meson-g12-common: specify full DMC range
Date: Mon, 24 Apr 2023 15:16:27 +0200
Message-Id: <20230424131136.336155077@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit aec4353114a408b3a831a22ba34942d05943e462 ]

According to S905X2 Datasheet - Revision 07:
DRAM Memory Controller (DMC) register area spans ff638000-ff63a000.

According to DeviceTree Specification - Release v0.4-rc1:
simple-bus nodes do not require reg property.

Fixes: 1499218c80c99a ("arm64: dts: move common G12A & G12B modes to meson-g12-common.dtsi")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230327120932.2158389-2-mgonzalez@freebox.fr
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index c063a144e0e7b..ba36af9e20cf2 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1571,10 +1571,9 @@
 
 			dmc: bus@38000 {
 				compatible = "simple-bus";
-				reg = <0x0 0x38000 0x0 0x400>;
 				#address-cells = <2>;
 				#size-cells = <2>;
-				ranges = <0x0 0x0 0x0 0x38000 0x0 0x400>;
+				ranges = <0x0 0x0 0x0 0x38000 0x0 0x2000>;
 
 				canvas: video-lut@48 {
 					compatible = "amlogic,canvas";
-- 
2.39.2



