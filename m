Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2271FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A59C433D2;
	Fri,  3 Feb 2023 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419615;
	bh=jdlW2UpGV39iIb1jZylNHSlBWFgLrecPOvBrOD8Te6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvJcrHwZ7KuLhH68w/Ti6czEhVUOGOl0uHgyLQ7v8ULJbxxw5iFpM7Fh0eS165RjH
	 ECiKAsi4OuAdq75l5/2mSQjBy3COWZ2/PrTf+zsLLeUb0XqjrpcFmLu6evySoqvFOS
	 6wgHeRpRt89Dr3yYMic/N8AvQgS7N6ho3vcxAOrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/80] ARM: dts: imx: Fix pca9547 i2c-mux node name
Date: Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101017.879957801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f78985f9f58380eec37f82c8a2c765aa7670fc29 ]

"make dtbs_check":

    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: $nodename:0: 'i2c-switch@70' does not match '^(i2c-?)?mux'
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml
    arch/arm/boot/dts/imx53-ppd.dtb: i2c-switch@70: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'i2c@0', 'i2c@1', 'i2c@2', 'i2c@3', 'i2c@4', 'i2c@5', 'i2c@6', 'i2c@7' were unexpected)
	    From schema: Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.yaml

Fix this by renaming the PCA9547 node to "i2c-mux", to match the I2C bus
multiplexer/switch DT bindings and the Generic Names Recommendation in
the Devicetree Specification.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ppd.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index f346673d34ea..0cb5f01f02d1 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -462,7 +462,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.0



