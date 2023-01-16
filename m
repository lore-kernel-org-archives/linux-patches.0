Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC76346B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D4C433EF;
	Mon, 16 Jan 2023 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885267;
	bh=bhB3u7KRuIDhfOGfS9S4Rehu1Wi2ISGA2qR3xKaEZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E72oWKjpQAwYaSDzd+AzhhXfhukvjfpgJIzFRhxqMGZcRnGd8oFPb8k9ROcToeBU7
	 o4tYljuF+qOLWBZtpcPoX/lk3RA4eTgmMkoyVA/MF2G9Wb0vQ5f3zzwBsac31VTAu3
	 FL/XbWHMfaUIm8E7DkcGkhqtiNo506eg02GLWpZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Li Jun <jun.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/64] dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
Date: Mon, 16 Jan 2023 16:51:29 +0100
Message-Id: <20230116154744.380724729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 5c1f7f1090947d494c30042123e0ec846f696336 ]

usb suspend clock has a gate shared with usb_root_clk.

Fixes: 9c140d9926761 ("clk: imx: Add support for i.MX8MP clock driver")
Cc: stable@vger.kernel.org # v5.19+
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1664549663-20364-1-git-send-email-jun.li@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx8mp-clock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index 0ba16b76eb2f..d7e513243dd2 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -328,8 +328,9 @@
 #define IMX8MP_CLK_CLKOUT2_SEL			317
 #define IMX8MP_CLK_CLKOUT2_DIV			318
 #define IMX8MP_CLK_CLKOUT2			319
+#define IMX8MP_CLK_USB_SUSP			320
 
-#define IMX8MP_CLK_END				320
+#define IMX8MP_CLK_END				321
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
-- 
2.35.1



