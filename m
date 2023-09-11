Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C43B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81748C433C8;
	Mon, 11 Sep 2023 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441014;
	bh=tg2NEEQG9i8rfLfBvAxAkdNPSxOhWiJg1XK+hDrccG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFR+0LU3Y95KkeacYVtLovy7eHAucBh6wUSkptb20w0c2IKXe6g66AaAZwxggDWPj
	 vN8SJbI05yQLQkjpWEWoFbk880ofFNTE3PsMFlJEAwhgl76mEy2CQsTSqMl88VIaow
	 eoc6uJkCO+nUZtBPrhKXtVmkxPoGbSo0psSmvZcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 266/739] ARM: dts: samsung: s3c6410-mini6410: correct ethernet reg addresses (split)
Date: Mon, 11 Sep 2023 15:41:05 +0200
Message-ID: <20230911134658.566208179@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit cf0cb2af6a18f28b84f9f1416bff50ca60d6e98a ]

The davicom,dm9000 Ethernet Controller accepts two reg addresses.

Fixes: a43736deb47d ("ARM: dts: Add dts file for S3C6410-based Mini6410 board")
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20230713152926.82884-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/s3c6410-mini6410.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/samsung/s3c6410-mini6410.dts b/arch/arm/boot/dts/samsung/s3c6410-mini6410.dts
index 17097da36f5ed..0b07b3c319604 100644
--- a/arch/arm/boot/dts/samsung/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/samsung/s3c6410-mini6410.dts
@@ -51,7 +51,7 @@ srom-cs1-bus@18000000 {
 
 		ethernet@18000000 {
 			compatible = "davicom,dm9000";
-			reg = <0x18000000 0x2 0x18000004 0x2>;
+			reg = <0x18000000 0x2>, <0x18000004 0x2>;
 			interrupt-parent = <&gpn>;
 			interrupts = <7 IRQ_TYPE_LEVEL_HIGH>;
 			davicom,no-eeprom;
-- 
2.40.1



