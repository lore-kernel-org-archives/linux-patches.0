Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2F0FC0B;
	Wed,  5 Feb 2025 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764409; cv=none; b=dckgq48ryyKSF9iKeRI2YRHArzRyCROfX7mQi2DPqHuYoomFU9dgIyXNEwIxy+DiZd/SF8lopyQmx357uEw/bK8hYTh7VNLlw3vBhzcO1GePsafOTh9y1RRLxj/N0bbOvC5bSMruvLim0pQ2dxmLfrtDbdskqlmJaqLQ9UL1yXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764409; c=relaxed/simple;
	bh=y6WXPYnfn7p4z6cd1BCsKKiSIolikHSdciKhH4YE+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4UaRcnh0Eyb4ufgdhaz0+B5Y6L0Zk9fslLlV4El1hS8M5jzHbGbVlNTr3CzBhvjDj5Q9Q8mmqtEcPnLmDUm9PNSwF/DI3PiqLdEeZCnbFrZvcEM8g3s6ZTum1q23RGqU29tNAxGaAMM+GcBnPVXN4SVOa0mTAhHltDBZxv1ado=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEF9Q9q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEF9Q9q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B72C4CED6;
	Wed,  5 Feb 2025 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764408;
	bh=y6WXPYnfn7p4z6cd1BCsKKiSIolikHSdciKhH4YE+FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEF9Q9q2uzz8vxyFZrzlNOObOgs5HrxKFnPM3tz5fY099FJOB1hzm1bw7+v3jFk4W
	 xhT3sZrVmVgECpdiyuXNqopzeiN1H/g+ve7IURVaJLg1QGkin/v1o17fU6X0I5E655
	 hr8DnuuuhNRBRIf4qS0rpODxQbg5hTFgwDIGZBlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/590] dt-bindings: clock: Add i.MX91 clock support
Date: Wed,  5 Feb 2025 14:37:56 +0100
Message-ID: <20250205134459.891779893@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit f029d870096fcd8565a2ee8c2d0078b9aaec4fdb ]

i.MX91 has similar Clock Control Module(CCM) design as i.MX93, only add
few new clock compared to i.MX93.
Add a new compatible string and some new clocks for i.MX91.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241023184651.381265-4-pengfei.li_1@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 32e9dea2645f ("dt-bindings: clock: imx93: Add SPDIF IPG clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/clock/imx93-clock.yaml | 1 +
 include/dt-bindings/clock/imx93-clock.h                  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/imx93-clock.yaml b/Documentation/devicetree/bindings/clock/imx93-clock.yaml
index ccb53c6b96c11..98c0800732ef5 100644
--- a/Documentation/devicetree/bindings/clock/imx93-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/imx93-clock.yaml
@@ -16,6 +16,7 @@ description: |
 properties:
   compatible:
     enum:
+      - fsl,imx91-ccm
       - fsl,imx93-ccm
 
   reg:
diff --git a/include/dt-bindings/clock/imx93-clock.h b/include/dt-bindings/clock/imx93-clock.h
index a1d0b326bb6bf..6c685067288b5 100644
--- a/include/dt-bindings/clock/imx93-clock.h
+++ b/include/dt-bindings/clock/imx93-clock.h
@@ -204,5 +204,10 @@
 #define IMX93_CLK_A55_SEL		199
 #define IMX93_CLK_A55_CORE		200
 #define IMX93_CLK_PDM_IPG		201
+#define IMX91_CLK_ENET1_QOS_TSN     202
+#define IMX91_CLK_ENET_TIMER        203
+#define IMX91_CLK_ENET2_REGULAR     204
+#define IMX91_CLK_ENET2_REGULAR_GATE		205
+#define IMX91_CLK_ENET1_QOS_TSN_GATE		206
 
 #endif
-- 
2.39.5



