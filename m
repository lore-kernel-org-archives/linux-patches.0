Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F7112C487;
	Tue, 30 Apr 2024 11:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475060; cv=none; b=fuunf2Xz/oYD3Ed9hux6kwUQA9FW+2f3sqaQ6z5rGfVlVpefu5m6W+PIsEd8ofDfWYCXao3dt05bEI5Y9CCPwPttwp70/DWptakMq7Ay41Upm6M/izczXB+D5W4wL7BR0rkC2uaRcl2B5a9ip7Z5kdKtCBO4eJOqkgupGfC6jWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475060; c=relaxed/simple;
	bh=NfLl1y8kG80UKA//yfmbq4erA7Y3Lp8x/L3Ce1N+j+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeUimaktd1wEC4DAIH7KHRC+CzKSFaawnUcJOXBleU5hvSnfaZ4u/iDaBrzO0hLDFjXJ/6CMbwLhCJ9p55TeLGBLuewkvgKc42pDrW6/g7UET6wUj9SFObTJ4LBO+5+YbgajcVznFlzbh9YXaJamKL5+OE8CDqcOCros7udvukQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqzfPMP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqzfPMP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29064C2BBFC;
	Tue, 30 Apr 2024 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475059;
	bh=NfLl1y8kG80UKA//yfmbq4erA7Y3Lp8x/L3Ce1N+j+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqzfPMP2SQDwjE7rsbCZCE5QkIgVb6anQIBNl2DvCsHgMe9StAooZIMa8c4YFNCCV
	 X+UpzSD9D65rLcC0YppVu887s7eeAYAz1YMqqJeUxYePj8D1LPtNaodI+bBayyPptp
	 r6qV0I2wrpjlCthWVd9bwAGQL344DryjahsZFaE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 118/138] arm64: dts: rockchip: enable internal pull-up for Q7_THRM# on RK3399 Puma
Date: Tue, 30 Apr 2024 12:40:03 +0200
Message-ID: <20240430103052.880800879@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iskander Amara <iskander.amara@theobroma-systems.com>

commit 0ac417b8f124427c90ec8c2ef4f632b821d924cc upstream.

Q7_THRM# pin is connected to a diode on the module which is used
as a level shifter, and the pin have a pull-down enabled by
default. We need to configure it to internal pull-up, other-
wise whenever the pin is configured as INPUT and we try to
control it externally the value will always remain zero.

Signed-off-by: Iskander Amara <iskander.amara@theobroma-systems.com>
Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240308085243.69903-1-iskander.amara@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -436,6 +436,16 @@
 };
 
 &pinctrl {
+	pinctrl-names = "default";
+	pinctrl-0 = <&q7_thermal_pin>;
+
+	gpios {
+		q7_thermal_pin: q7-thermal-pin {
+			rockchip,pins =
+				<0 RK_PA3 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+	};
+
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
 			rockchip,pins =


