Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC41BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2725C433A0;
	Tue,  7 Mar 2023 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212043;
	bh=068jDOsDVjFz9fffEUC8LMNHniQ23B84+s4CraJECiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOTs5m+3O5bqlCJ5kUrWA2MGz3qJot265K8DyYFn3mjYWmGRp4rD9AA/YFI5nGBdT
	 Zz/bchFM5xEnWqcSEVVO5GvVOT7Chlb08OQVzgTldgdqYljHGBNrwNcsLbo39tUSL7
	 YhLSak8lNC5vXuwLcreUTUpjruivlFO9ZBY0fM6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/885] arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix invalid rtc node name
Date: Tue,  7 Mar 2023 17:49:53 +0100
Message-Id: <20230307170004.324463266@linuxfoundation.org>
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

[ Upstream commit 956f52025c5dd92c80c12e31c99c854086a6fc55 ]

Fixes:
pcf8563@51: $nodename:0: 'pcf8563@51' does not match '^rtc(@.*|-[0-9a-f])*$'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-8-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 1916c007cba58..e1605a9b0a13f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -217,7 +217,7 @@ &i2c1 {
 	pinctrl-names = "default";
 
 	/* RTC */
-	pcf8563: pcf8563@51 {
+	pcf8563: rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 		status = "okay";
-- 
2.39.2



