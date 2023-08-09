Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4915AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA2C433C8;
	Wed,  9 Aug 2023 10:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578304;
	bh=er2JIqZGYj+2BymmVfuPjdRYFlrla6/6GmsJC4ke744=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jziV4e7/b+R9x7Bi4vq9+I8NRxJIYLmVj/tJSFxmTs5md6oQml8DpYR/jWYHMHlMk
	 Js+OXXkDjdskaK3hUUaMgDxY6h7kJZI9Bhs13hSomjpocD1xmgZEA7WHgmNYOYQ+P2
	 A0XeQYkdD0GiPp240dfcGI8eQtXa+fKb/uPzCphY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yashwanth Varakala <y.varakala@phytec.de>,
	Cem Tenruh <c.tenruh@phytec.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/127] arm64: dts: phycore-imx8mm: Correction in gpio-line-names
Date: Wed,  9 Aug 2023 12:39:59 +0200
Message-ID: <20230809103637.041452591@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yashwanth Varakala <y.varakala@phytec.de>

[ Upstream commit 1ef0aa137a96c5f0564f2db0c556a4f0f60ce8f5 ]

Remove unused nINT_ETHPHY entry from gpio-line-names in gpio1 nodes of
phyCORE-i.MX8MM and phyBOARD-Polis-i.MX8MM devicetrees.

Fixes: ae6847f26ac9 ("arm64: dts: freescale: Add phyBOARD-Polis-i.MX8MM support")
Signed-off-by: Yashwanth Varakala <y.varakala@phytec.de>
Signed-off-by: Cem Tenruh <c.tenruh@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-phyboard-polis-rdk.dts | 2 +-
 arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-phyboard-polis-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mm-phyboard-polis-rdk.dts
index 4a3df2b77b0be..6720ddf597839 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-phyboard-polis-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-phyboard-polis-rdk.dts
@@ -141,7 +141,7 @@
 };
 
 &gpio1 {
-	gpio-line-names = "nINT_ETHPHY", "LED_RED", "WDOG_INT", "X_RTC_INT",
+	gpio-line-names = "", "LED_RED", "WDOG_INT", "X_RTC_INT",
 		"", "", "", "RESET_ETHPHY",
 		"CAN_nINT", "CAN_EN", "nENABLE_FLATLINK", "",
 		"USB_OTG_VBUS_EN", "", "LED_GREEN", "LED_BLUE";
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
index 3e5e7d861882f..9d9b103c79c77 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
@@ -111,7 +111,7 @@
 };
 
 &gpio1 {
-	gpio-line-names = "nINT_ETHPHY", "", "WDOG_INT", "X_RTC_INT",
+	gpio-line-names = "", "", "WDOG_INT", "X_RTC_INT",
 		"", "", "", "RESET_ETHPHY",
 		"", "", "nENABLE_FLATLINK";
 };
-- 
2.40.1



