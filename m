Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9AD7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5F7C4339B;
	Mon, 24 Apr 2023 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342369;
	bh=Y8pfIOkvI8DbVkY0AgmIYTqARb5Mg8n2xhkW7FIHm1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrNSSRaO87bBT9XThSY5sck69gshKYu9X1re/SwqurmnVd8aPmsLosYvUyZXk+Ry4
	 CLrF7R7QJOlGOAlUey5BYZoaquIixqxDhzVbfhDeEoTmgunZp/3cJxguUh57BKZDKH
	 1420/Bq8zaZ1T8jJVA/PQlEc0h0wRMOidcBLZl40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/73] arm64: dts: meson-g12-common: specify full DMC range
Date: Mon, 24 Apr 2023 15:16:17 +0200
Message-Id: <20230424131129.164387658@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
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
index 899cfe416aef4..369334076467a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1610,10 +1610,9 @@
 
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



