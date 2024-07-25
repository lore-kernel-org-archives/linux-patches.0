Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100B11E895;
	Thu, 25 Jul 2024 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918775; cv=none; b=hiEroFgPPUSp/vhCOc8e9N0uOwjphhSBmw++nJ6wXFfG1FIKsheQImOasIxPC6MHHqHehqjYQrGhmnl/mNKoVJnbievS7CRRD0FrKEN4k2I8/PD4j3uPLUKfSxoZivgsKu8kubv1xAdvW/z8SSBKsqGNo6kcQE3ZRKJ3+plD1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918775; c=relaxed/simple;
	bh=kUaWLHmBT8tXsnm56g4qv7vcHyzJZieR7hmWJlIV7mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRRx5SWTqGF+6DxMi5ObObpeDuyk12byC6uEVaT2XP36zu1M7fEOdb8s8C0QY0ITKBjH4LLIUVlyxp8kGhss08JrFOoBl7FI91xp6dhnLHl9jj8igdYHtPTrlQJTZ6Y3DrxSSo2q2Uyp8un90NsU35dB/LfeJWrLDnCK/YG9H/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQLssnPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQLssnPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEDDC4AF07;
	Thu, 25 Jul 2024 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918774;
	bh=kUaWLHmBT8tXsnm56g4qv7vcHyzJZieR7hmWJlIV7mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQLssnPNqC3bLMAbzQtwxabA7XY2vbf3WWtKxYUGr9N216xM3xkjAuv9zleSEd+md
	 0DxjZFBP8pipLf5QRfROm0pbpnpucYyIsBlEm1rdbqEyoTEF7n1UO3458STKfYgDR9
	 FGP5Yq6s3YOT5olGVDFBLJmgTFv3AQ/7Xc0rcoAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 14/29] arm64: dts: qcom: qrb2210-rb1: switch I2C2 to i2c-gpio
Date: Thu, 25 Jul 2024 16:37:24 +0200
Message-ID: <20240725142732.213512444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit b7b545ccc08873e107aa24c461b1fdb123dd3761 upstream.

On the Qualcomm RB1 platform the I2C bus connected to the LT9611UXC
bridge under some circumstances can go into a state when all transfers
timeout. This causes both issues with fetching of EDID and with
updating of the bridge's firmware. While we are debugging the issue,
switch corresponding I2C bus to use i2c-gpio driver. While using
i2c-gpio no communication issues are observed.

This patch is asusmed to be a temporary fix, so it is implemented in a
non-intrusive manner to simply reverting it later.

Fixes: 616eda24edd4 ("arm64: dts: qcom: qrb2210-rb1: Set up HDMI")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20240605-rb12-i2c2g-pio-v2-1-946f5d6b6948@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index bb5191422660..8c27d52139a1 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -59,6 +59,17 @@ hdmi_con: endpoint {
 		};
 	};
 
+	i2c2_gpio: i2c {
+		compatible = "i2c-gpio";
+
+		sda-gpios = <&tlmm 6 GPIO_ACTIVE_HIGH>;
+		scl-gpios = <&tlmm 7 GPIO_ACTIVE_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		status = "disabled";
+	};
+
 	leds {
 		compatible = "gpio-leds";
 
@@ -199,7 +210,7 @@ &gpi_dma0 {
 	status = "okay";
 };
 
-&i2c2 {
+&i2c2_gpio {
 	clock-frequency = <400000>;
 	status = "okay";
 
-- 
2.45.2



