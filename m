Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC8B46AA71;
	Tue, 21 Jul 2026 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648274; cv=none; b=iOWp1zJqcEEOq+GnJn33lGgS8huubYay2M05LQqCSeArKu5aCx6vEhySBfASHFjrr66tLqFcBQCUApviuChBL7VXe2La8wVDvqIKw0H4nr4Bgq6Kv63xPN6+xOLEb+EHXqEDQnKvV6miPPe5E2/qy/VTm/Q9I9x0WaayLW0ungU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648274; c=relaxed/simple;
	bh=4fX1c5V869E6ikz1xPdILVXZjyYEzTYCAp9p+b/bFho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8BX4OpyUb9dEfxly5mJh2PW8i7DXx9gq9eN93d+XJrrexOEG1mz3uLsb+93HYuZK1tnfk10phTume2934WWEf2x+i4dwBVmf9ZNnxH0c+9TYtmYSl5nrmYzysCeLDN41YkAXQ5RUoWxg2bgcme8ZLgWrtisByAQ7XNHFc2phVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VANx096Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VANx096Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641E11F000E9;
	Tue, 21 Jul 2026 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648272;
	bh=rR0Tw6spM21FrEuJ69QkjFyq7aS9Y+4X5k20+nZtMng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VANx096QHx989nEKSfLrS1TM3zGLF7Myh1vDE5dxftI6S1uGJqlbY7LUY5vMZEHJT
	 exzOWYwSVtFAdinAvE1M1X7xlNyyfsS5tzO4i8dnFxB6/lQ0AJ5S7ZjYz6omQ7Q85K
	 N2UFy1dGArv1fOkdK0sdO5C7Fhk+ndoEOUeOIGpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0138/2077] riscv: dts: microchip: remove gpio hogs from beaglev-fire
Date: Tue, 21 Jul 2026 16:56:51 +0200
Message-ID: <20260721152555.944091729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 7ab032833b2f0dd3b51d71e6756ebe7efc61eed4 ]

sd-det-hog should be cd-gpios, but when the mmc-spi-slot was added, the
"cd-" prefix was omitted and the collision with the hog was not noticed.

vio-enable-hog is just a regulator that can be modelled as such.

Fixes: 1088d49b62648 ("riscv: dts: microchip: enable qspi adc/mmc-spi-slot on BeagleV Fire")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/microchip/mpfs-beaglev-fire.dts  | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts b/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
index 0e1b0b8d394b90..6e9653827cfe25 100644
--- a/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
+++ b/arch/riscv/boot/dts/microchip/mpfs-beaglev-fire.dts
@@ -77,6 +77,15 @@ imx219_vddl: fixedregulator-2 {
 		regulator-max-microvolt = <1200000>;
 	};
 
+	regulator-1v8-syzygy {
+		compatible = "regulator-fixed";
+		gpios = <&gpio2 30 GPIO_ACTIVE_HIGH>;
+		regulator-name = "syzygy_1v8";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-always-on;
+		enable-active-high;
+	};
 };
 
 &gpio0 {
@@ -118,20 +127,6 @@ &gpio2 {
 			  "P8_PIN27", "P8_PIN28", "P8_PIN29", "P8_PIN30", "M2_W_DISABLE1",
 			  "M2_W_DISABLE2", "VIO_ENABLE", "SD_DET";
 	status = "okay";
-
-	vio-enable-hog {
-		gpio-hog;
-		gpios = <30 30>;
-		output-high;
-		line-name = "VIO_ENABLE";
-	};
-
-	sd-det-hog {
-		gpio-hog;
-		gpios = <31 31>;
-		input;
-		line-name = "SD_DET";
-	};
 };
 
 &i2c0 {
@@ -316,7 +311,7 @@ channel@7 {
 	mmc@1 {
 		compatible = "mmc-spi-slot";
 		reg = <1>;
-		gpios = <&gpio2 31 1>;
+		cd-gpios = <&gpio2 31 GPIO_ACTIVE_LOW>;
 		voltage-ranges = <3300 3300>;
 		spi-max-frequency = <5000000>;
 		disable-wp;
-- 
2.53.0



