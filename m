Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B6168C7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11D7C4339B;
	Mon,  8 May 2023 11:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543642;
	bh=hNwT2XPXfrM0qa/w+rJHWnhrTUuC/p2Z9y753f/6sVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOTlYw35knrDIF6VjWX1jqDAwDPeNOOmIMM9jTO3ntdhH/mBALJ7YcxRF39yWWsW3
	 uHXE9vUgKcNIeHWMrOw8tCK6VpY/tgFswjZfLH9DfCcCTmn2SUgmiu14kcPkOZXhgu
	 G7Q/NGzyj+EvOTUmr6fgI+FHcl6rA4L1y0Ny8X6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 155/694] arm64: dts: amlogic: meson-g12b-radxa-zero2: fix pwm clock names
Date: Mon,  8 May 2023 11:39:50 +0200
Message-Id: <20230508094437.462300276@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit db217e84d0a3f4183ea5b6d5929e55b73128fcb2 ]

Fixes the following bindings check error:
 - pwm@2000: clock-names: 'oneOf' conditional failed, one must be fixed:
	['clkin4'] is too short
	'clkin4' is not one of ['clkin0', 'clkin1']
	'clkin0' was expected
 - pwm@7000: clock-names: 'oneOf' conditional failed, one must be fixed:
	['clkin3'] is too short
	'clkin3' is not one of ['clkin0', 'clkin1']
	'clkin0' was expected
 - pwm@19000: clock-names: 'oneOf' conditional failed, one must be fixed:
	['clkin2'] is too short
	'clkin2' is not one of ['clkin0', 'clkin1']
	'clkin0' was expected

Fixes: d747e7f76a5f ("arm64: dts: meson: add support for Radxa Zero2")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230207-b4-amlogic-bindings-fixups-v2-v1-4-93b7e50286e7@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-radxa-zero2.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-radxa-zero2.dts b/arch/arm64/boot/dts/amlogic/meson-g12b-radxa-zero2.dts
index 9a60c5ec20725..890f5bfebb030 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-radxa-zero2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-radxa-zero2.dts
@@ -360,7 +360,7 @@
 	pinctrl-0 = <&pwm_e_pins>;
 	pinctrl-names = "default";
 	clocks = <&xtal>;
-	clock-names = "clkin2";
+	clock-names = "clkin0";
 	status = "okay";
 };
 
@@ -368,7 +368,7 @@
 	pinctrl-0 = <&pwm_ao_a_pins>;
 	pinctrl-names = "default";
 	clocks = <&xtal>;
-	clock-names = "clkin3";
+	clock-names = "clkin0";
 	status = "okay";
 };
 
@@ -376,7 +376,7 @@
 	pinctrl-0 = <&pwm_ao_d_e_pins>;
 	pinctrl-names = "default";
 	clocks = <&xtal>;
-	clock-names = "clkin4";
+	clock-names = "clkin1";
 	status = "okay";
 };
 
-- 
2.39.2



