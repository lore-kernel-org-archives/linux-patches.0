Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AC01E895;
	Thu, 25 Jul 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918778; cv=none; b=PdGVnz2vpXilFYj+7MrifpEwDlf23jWVldoQmPj/xdKawKBu+MPxDq95IEITvSTIMlcheC3HqFyu0Flzl4kgBkX/7t5ot2Sy9UmL7m3G39BS6o7cpBvGwtqPLZd7Di+79SVx0DzBIyWYHq6d/VnupcLr+7bWGaT2R/QFxuxQHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918778; c=relaxed/simple;
	bh=bpLtI3P0/4CL8vy5ntJ9Q0tMbMtQGueeelF6PKyFFxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzWpOlnMv9YEZHVwHe/YYNhMY0lOrYJXk/M+tcX+34r73XEp2jYPft3Vlx2hS3Gxz7po3qYlrFmaqu9rfujARedcMBBsw9Sl9PR6/L1zFh2TQvCTL2NMKERHpEMtOtswLVzYAhMR1IHDq3pVQpD6Q+yt/yn44zzRPq8iqRsrEZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTGcdnSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTGcdnSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC89AC116B1;
	Thu, 25 Jul 2024 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918778;
	bh=bpLtI3P0/4CL8vy5ntJ9Q0tMbMtQGueeelF6PKyFFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTGcdnSQnbsY5dJKcJ2C6vml/luejkTC5LCKIjxpuF8OexwIZahgCIzMDs0pBpucH
	 FsDxaDrcNyMUNRTlCZtDPHz2sXONb2/W43QBXY7e6I3/hygmYjf7I4OsYQpQB9VJZS
	 b5M+nNHfRh0028CEfXOEd/rVzNRvJoP5dIfPIkLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 15/29] arm64: dts: qcom: qrb4210-rb2: switch I2C2 to i2c-gpio
Date: Thu, 25 Jul 2024 16:37:25 +0200
Message-ID: <20240725142732.250394434@linuxfoundation.org>
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
@@ -60,6 +60,17 @@
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
 
@@ -190,7 +201,7 @@
 	};
 };
 
-&i2c2 {
+&i2c2_gpio {
 	clock-frequency = <400000>;
 	status = "okay";
 


