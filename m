Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488BFC18;
	Thu, 25 Jul 2024 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918743; cv=none; b=Ot0ITUxvsBEHWD7jIfig0ztGmD8n0z0mRIQLvPxrYwH8QH0I7/TO+GkOr7z5p8X0hN8nRvck/xWr566N5B7jpxGiyKm9Jz9M8GLtsDyxkhbfPFVGvcdynup906PdfKYDnuMaMuPOvQgSnOmAqpmcoktc/CkV0f1dQPrtFhuFgEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918743; c=relaxed/simple;
	bh=AzNzEtJRaa9eoMifnNo9Ak9mmm0EVKFkQhg3bfWGdEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2r3U1sK/T4mPYUeaevVxLCNv2rdaVE9qeIz89IqFZsekV0v4rmBM/EalQ7TzP+o3b9YTK7aa/LSz57kj9DvtkXV2F3Mxd6JHB+OaXTBjIPQf25CxQx6W8niMocv1sLwcAYnP79HqO7JNjDlZIPSyK27ludK0M0JU3HX7gcXwQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBx7VzGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBx7VzGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237F6C32782;
	Thu, 25 Jul 2024 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918743;
	bh=AzNzEtJRaa9eoMifnNo9Ak9mmm0EVKFkQhg3bfWGdEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBx7VzGsK7qoh1+QoYYvyZWKpNT4PuCNGDnaxDwVvOEC93Asi6cpkbSjgMK74Twnm
	 jhvjVfZiEmhAj/LjjUiXWODt9i9sXTahbQE7Uz6JnY0aCSTBkslgU3r3HEZILQb++j
	 PrEa8JNlH5rp7Yr/x827XOVo05UPBQZEk1dUAC7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 09/16] arm64: dts: qcom: qrb4210-rb2: switch I2C2 to i2c-gpio
Date: Thu, 25 Jul 2024 16:37:22 +0200
Message-ID: <20240725142729.255319868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit f77e7bd40c3c2d79685e9cc80de874b69a976f55 upstream.

On the Qualcomm RB2 platform the I2C bus connected to the LT9611UXC
bridge under some circumstances can go into a state when all transfers
timeout. This causes both issues with fetching of EDID and with
updating of the bridge's firmware. While we are debugging the issue,
switch corresponding I2C bus to use i2c-gpio driver. While using
i2c-gpio no communication issues are observed.

This patch is asusmed to be a temporary fix, so it is implemented in a
non-intrusive manner to simply reverting it later.

Fixes: f7b01e07e89c ("arm64: dts: qcom: qrb4210-rb2: Enable display out")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20240605-rb12-i2c2g-pio-v2-2-946f5d6b6948@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -57,6 +57,17 @@
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
 
@@ -187,7 +198,7 @@
 	};
 };
 
-&i2c2 {
+&i2c2_gpio {
 	clock-frequency = <400000>;
 	status = "okay";
 


