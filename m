Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342C746D2B9;
	Tue, 21 Jul 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654003; cv=none; b=qsJwtKGZ+xPcYa5qbL+TBuu5H7WPOixk8K79LqfU6Fgb+lk29dvNgIp0iGGLZ9sfZ/+y/3T1nksHYUHt02egKJbzt6RxArp/AGbNt1VBcA3sHJaDUwCDVFW25l8Z+mWGnN6Eu+TKgyUisPb4mcAWJXJzSEgvMETV1aat7KYZkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654003; c=relaxed/simple;
	bh=HYhyrRSRwrBB3E8xXw4xQtE6ANUEljQhBWTjzF/SNWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBDjrYTnN+Sy7Rp274DwPjfwTQQSmWdtE939Zjo8R1SrsIQjjQjucMkWehzNRNQSDQAmioFvkMrnC2iSHtfhxolNDlbjmUXNY4QYBGFTY96KLqIPVLnl6JQ/n7MC1RttRPmtwx6mXqvVaWQhV7kjC5t8rkGlgyDsCMFscaC0Ts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vk7uy7ZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vk7uy7ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8281F000E9;
	Tue, 21 Jul 2026 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654002;
	bh=mHPIyA0hun5I+ACLcOXKVJ5cmMYTozhhxAyOu4aooI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vk7uy7ZWDe7i/nHfQ7QX62iLyx7HCRpD8kpf1mWqVZgcudaSiM1//jdW4zfRy5r2/
	 jPPAD35Bl8Dg+UCdnbTrXKrpHnNK3EsmENwcSG9Y51L8Zw120L7LMuj0pCKrNkZqAZ
	 9RuPOVkO0MpCEuaI8Pohpafu3o3T+Ur8d+H6jF8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 7.1 1540/2077] ARM: dts: stm32: stm32mp15x-mecio1-io: Enable internal ADC reference
Date: Tue, 21 Jul 2026 17:20:13 +0200
Message-ID: <20260721152629.100049069@linuxfoundation.org>
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

From: David Jander <david@protonic.nl>

commit c84f22405085d91cd5f0c5b967318371c07904ba upstream.

Switch the ADC reference supply from the general 3.3V rail to the
internal 2.5V VREFBUF regulator. The ADC circuits on this board are
designed for the internal 2.5V reference. Without this change, all ADC
measurement values are incorrect.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-2-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -95,7 +95,7 @@
 	pinctrl-names = "default";
 	vdd-supply = <&v3v3>;
 	vdda-supply = <&v3v3>;
-	vref-supply = <&v3v3>;
+	vref-supply = <&vrefbuf>;
 	status = "okay";
 };
 
@@ -362,6 +362,13 @@
 	phy-supply = <&v3v3>;
 };
 
+&vrefbuf {
+	regulator-min-microvolt = <2500000>;
+	regulator-max-microvolt = <2500000>;
+	vdda-supply = <&v3v3>;
+	status = "okay";
+};
+
 &pinctrl {
 	adc12_pins_mecsbc: adc12-ain-mecsbc-0 {
 		pins {


