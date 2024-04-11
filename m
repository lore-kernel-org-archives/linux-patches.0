Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B0513B5B9;
	Thu, 11 Apr 2024 10:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830085; cv=none; b=L7pgcK+ep2b/gPjCupqTe+9XWQDDjfkw4VbGISsjK7HgDr9z5JRHvAUZJoQpDM08K2i6G2HiTErClHcGC6xJ6r1o+tWjmIoIsqm85/Z6S593qQFV6Qtxl/c+I/iAJGeTiaYQuEqucp+FtPp1C2S4H+Fv6JwliONJheZw6/eWrlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830085; c=relaxed/simple;
	bh=aqgiBtkQJjB9w+R8ciew5t1RMXIpavEAXzIR/vECTsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsL4YqiDv+RrusN3PTJYv9RcknNK5nExox7tISx4xsMUAKDAcdWL9XHfH5X7oS16Ao1boUMs6Edw5QpuueKkzBG5uJ/JgZf7A/m/aXKK3BrTtyBjfdpYntAWagQYs+3UY1AkGbSUpQ6V08Y3Mg5Etfs08XDPCFtyypdNKZXd00w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9+F3Ytw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9+F3Ytw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092D0C433F1;
	Thu, 11 Apr 2024 10:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830084;
	bh=aqgiBtkQJjB9w+R8ciew5t1RMXIpavEAXzIR/vECTsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9+F3Ytw5XepbWIgj6durMy2sUT5VVGMeUhKfl/UscEnTck/i4gEbBqi4eOFhKzr9
	 b6l/BsUCtStZoZNg5YZggATQ/QW6s21BvxfOXl68l6qUAzF0BMFISt/VNPb8o+6pY4
	 P59fmfMsEQ+gPMEiPmPr72xFkz7LXCER1paylkO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Liu <quic_huliu@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 012/143] arm64: dts: qcom: qcm6490-idp: Add definition for three LEDs
Date: Thu, 11 Apr 2024 11:54:40 +0200
Message-ID: <20240411095421.280307174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Liu <quic_huliu@quicinc.com>

[ Upstream commit 8385383cc2c2f7039ecc57864043112cdc7026c7 ]

Add definition for three LEDs to make sure they can
be enabled base on QCOM LPG LED driver.

Signed-off-by: Hui Liu <quic_huliu@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240126-lpg-v6-1-f879cecbce69@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
index 74f5a43d53db9..d58d4f5dc3173 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
@@ -5,6 +5,7 @@
 
 /dts-v1/;
 
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 #include "sc7280.dtsi"
 #include "pm7325.dtsi"
@@ -415,6 +416,33 @@ vreg_bob_3p296: bob {
 	};
 };
 
+&pm8350c_pwm {
+	status = "okay";
+
+	multi-led {
+		color = <LED_COLOR_ID_RGB>;
+		function = LED_FUNCTION_STATUS;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		led@1 {
+			reg = <1>;
+			color = <LED_COLOR_ID_RED>;
+		};
+
+		led@2 {
+			reg = <2>;
+			color = <LED_COLOR_ID_GREEN>;
+		};
+
+		led@3 {
+			reg = <3>;
+			color = <LED_COLOR_ID_BLUE>;
+		};
+	};
+};
+
 &qupv3_id_0 {
 	status = "okay";
 };
-- 
2.43.0



