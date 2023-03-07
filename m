Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F2BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CADC433EF;
	Tue,  7 Mar 2023 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212030;
	bh=HnLrCH3iQXSmyQVxV6BMxPB+jKxEXYwkmL3FfWW3lFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfTgdjaE8eae5GI9sxUxBTOKx09nkHOp+C4GHv1Cy+o3gq6iiWLb3u56q67UYTVhY
	 G8vh22Pevn8QzNeBPTYtY25IUSKoVZNpLN62iiB8nDtflzsVj7G6s/My6oMdlNY+uX
	 ql7MJWrnmmYC2cJ8BXTa5rUqKw2i/H59x/8TOAmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/885] arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix supply name of USB controller node
Date: Tue,  7 Mar 2023 17:49:49 +0100
Message-Id: <20230307170004.131892176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit a69cb1042cea840bc7b60fea1c26a6b259e68bf2 ]

Fixes:
usb@ffe09080: 'phy-supply' does not match any of the regexes: '^usb@[0-9a-f]+$', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-4-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 22fd43b5fd73c..1916c007cba58 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -303,7 +303,7 @@ &uart_AO_B {
 
 &usb {
 	status = "okay";
-	phy-supply = <&usb_pwr>;
+	vbus-supply = <&usb_pwr>;
 };
 
 &spicc1 {
-- 
2.39.2



