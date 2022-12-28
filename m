Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591E623AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DE6C433D2;
	Wed, 28 Dec 2022 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246632;
	bh=DAKJyQ1lT+RCLVmNbvt6+iEHVeuQoYcblZIZSvSS4WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrL+0UiJDjAm2OhNWVl3K77JlEeS4+5MgZAyE78ZMyZNR8Oh7U6wtqT84T5rdhUay
	 afix1pHBa7lbk6r2m65PrdRxmT8NpqSPyAIdVmcJB2kIdM77r6Tfm2dCJcnr2q4huJ
	 rXNwIVNtS+qlULVmAw4IAXOtdYxO7eLTtAYMtCyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Li Jun <jun.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>
Subject: [PATCH 6.1 1107/1146] dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
Date: Wed, 28 Dec 2022 15:44:06 +0100
Message-Id: <20221228144400.226133287@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

commit 5c1f7f1090947d494c30042123e0ec846f696336 upstream.

usb suspend clock has a gate shared with usb_root_clk.

Fixes: 9c140d9926761 ("clk: imx: Add support for i.MX8MP clock driver")
Cc: stable@vger.kernel.org # v5.19+
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1664549663-20364-1-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/imx8mp-clock.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -324,8 +324,9 @@
 #define IMX8MP_CLK_CLKOUT2_SEL			317
 #define IMX8MP_CLK_CLKOUT2_DIV			318
 #define IMX8MP_CLK_CLKOUT2			319
+#define IMX8MP_CLK_USB_SUSP			320
 
-#define IMX8MP_CLK_END				320
+#define IMX8MP_CLK_END				321
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1


