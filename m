Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD5199E9F;
	Thu, 25 Jul 2024 14:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918320; cv=none; b=hBx2noWEzMOdXADCEpk7ad18BAsHXHVOZd2uZQKMCqbvmPR5qemM8ER1QX4jaYmBwBm8WddG4PT9a3CNcfxsR0KpPBtyzCG0e++2CHTZNXxeg1/G8gobg9xRWVMyyTGZds8dHc2BF+tUnAkbCODufufgzcTwluT+OWMzrO4a8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918320; c=relaxed/simple;
	bh=gy0vVZxV0uKcHdZO3lpgwIE4oFYyJ43cg9+D/JBg9dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4yssafQ8O82RY6L2YI0YBe0zjVoQtHQ8kO0C90qy/5VQG6WLToy0YyBY9xbspq65BcyuKvUAkzic8DqAMMT7m7PJE/8ZDLamqgDZf7J+mWbJd3o/o+itUZ4dcoGRYmgPqR7fIREqPP10ui+awLxGLw7R2qXfTCAH4d5JnNKie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqHnaAav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqHnaAav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B133C116B1;
	Thu, 25 Jul 2024 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918319;
	bh=gy0vVZxV0uKcHdZO3lpgwIE4oFYyJ43cg9+D/JBg9dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqHnaAav22/1lfwywyzyoK+EixxyLmErI+ETI4hkst8n/afHI6GppUEOVMSNBMRRp
	 2sjRLaQvdL8BYjGNXrh/0IX48jGctlnFaAHcg8toXIp81VQsiIlj2AXIxXY0eby4Bc
	 Pzq/ayGoZ9saQyWxXp4OII4lQu/V/6GD/fNFe6Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 14/29] arm64: dts: qcom: qrb2210-rb1: switch I2C2 to i2c-gpio
Date: Thu, 25 Jul 2024 16:36:30 +0200
Message-ID: <20240725142732.352238624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -59,6 +59,17 @@
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
 
@@ -199,7 +210,7 @@
 	status = "okay";
 };
 
-&i2c2 {
+&i2c2_gpio {
 	clock-frequency = <400000>;
 	status = "okay";
 


