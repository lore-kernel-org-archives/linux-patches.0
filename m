Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178E5BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE9C433D2;
	Tue,  7 Mar 2023 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208990;
	bh=kEgzrc592J3t4DbkpMD6mNAr4qf0rg/ky1D7SUV3UWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkkxTXktD5NTSEfbAiZgQ4QJYXeY5Wxh93nPZ6k+U47K7QlcYxv1/KnTcINjHzw8T
	 TXGLVDuljFcb9B+CTPYe6Ca8rscN1xzkxTxyokbsvESR2Y0qkfZNGM4+eBXYww7B2z
	 aplpihv6jwqjUMwIrM6F/MkMYlNaU1IHD2qPBodU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0075/1001] arm64: dts: amlogic: meson-gxl-s905w-jethome-jethub-j80: fix invalid rtc node name
Date: Tue,  7 Mar 2023 17:47:27 +0100
Message-Id: <20230307170025.345030635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 11172a97c092eaeb0a65c6434df0fc73f886a495 ]

Fixes:
pcf8563@51: $nodename:0: 'pcf8563@51' does not match '^rtc(@.*|-[0-9a-f])*$'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-7-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
index bb7412070cb26..a18d6d241a5ad 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
@@ -239,7 +239,7 @@ &i2c_B {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c_b_pins>;
 
-	pcf8563: pcf8563@51 {
+	pcf8563: rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 		status = "okay";
-- 
2.39.2



