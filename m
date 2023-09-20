Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D8330FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2894DC433C8;
	Wed, 20 Sep 2023 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212942;
	bh=Tei3u3hqLGpNkxROhihwM+04E3xzT1OTBo9gGJsvkXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtwV7VRr3R4+B9PIo8V+QSnD317aIayjG1brABOfuziIl5iiaM1d/1DP9wytN+2Xx
	 ZZOy57WFzsUlPla2++l9ZaZe5S+WhHips1KKjdHUA5p/3Z8z9l/i2EfazAwsT7bdKX
	 nbAuEsQ2uljfALKUq812mCvyRbxV0LXg4pPaUAZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/367] ARM: dts: s5pv210: use defines for IRQ flags in SMDKV210
Date: Wed, 20 Sep 2023 13:28:00 +0200
Message-ID: <20230920112901.242641586@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c272f1cc9492d61dac362d2064ec41ca97fcb1e2 ]

Replace hard-coded flags with defines for readability.  No functional
change.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200907161141.31034-19-krzk@kernel.org
Stable-dep-of: 982655cb0e7f ("ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index 1f20622da7194..1e1570d66d890 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -15,6 +15,7 @@
  */
 
 /dts-v1/;
+#include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/input/input.h>
 #include "s5pv210.dtsi"
 
@@ -42,7 +43,7 @@ ethernet@18000000 {
 		compatible = "davicom,dm9000";
 		reg = <0xA8000000 0x2 0xA8000002 0x2>;
 		interrupt-parent = <&gph1>;
-		interrupts = <1 4>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
 		local-mac-address = [00 00 de ad be ef];
 		davicom,no-eeprom;
 	};
-- 
2.40.1



