Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8920881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21649C4339B;
	Fri, 10 Mar 2023 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459526;
	bh=Xl+e2qo875gBBbQc2gsClJk2Jb9u8F80gs1jYWI9Aqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=da45mymd1nz/Zx5FVIzshnKls3hT3EbLjx1Za276V3aGvVueohGPHdic8nC2rUKRN
	 V3tidjCB+/Pb9B5AoD8Y3cTUiy3fxZwaW+DOc1Z0vjjiOLynDa6xVw/57BOURAUx3z
	 SPsdWMGssULlMrS8epE23j9VvQLwtEbkeKQ6Bu40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/529] arm64: dts: amlogic: meson-gx-libretech-pc: fix update button name
Date: Fri, 10 Mar 2023 14:32:56 +0100
Message-Id: <20230310133806.522215160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 6bb506ed36968207a8832f0143ebc127f0770eef ]

Fixes:
 adc-keys: 'update-button' does not match any of the regexes: '^button-', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-10-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
index c2480bab8d337..27e964bfa947a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
@@ -17,7 +17,7 @@ adc-keys {
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1800000>;
 
-		update-button {
+		button-update {
 			label = "update";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <1300000>;
-- 
2.39.2



