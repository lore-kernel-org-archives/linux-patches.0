Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21D8415F3C;
	Tue, 21 Jul 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658484; cv=none; b=ZJBgUg17wv2/XE7LP5dyL3ZPoWA/IBdWK30K6UndMubRxUY/rAfo3dk02S4W8IczLBC2KGuCq0ffSzlpkU9TWDkIn9t8Frvy9wVsJIaYAL1AonIvAnNih57I1Y0VHr+DLFqP8r3/jk4L1tn17Ff5J0WMvpTjuMq1A4Kxknn2GiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658484; c=relaxed/simple;
	bh=vAFAGMKdIRUc8vXdvuUbY6t1of1A1eu9VHp/dBqoxs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHNG2gt/SjCyGdsjmw1y2yCbKyw/KKhPYJ7PoyZBxeATXjj90s1psEx1LZO7O0qq7cqy+FumkMDLZPuIGRikpVqvJt/9eFDNnRVWAif8MVC0ANSXG6yBFj0qer36/wGQxz9QRTo6Ogbin7/uaT7xI2xzYmNqyluBlngK71vZhl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRPvlNVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRPvlNVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B481F00A3D;
	Tue, 21 Jul 2026 18:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658481;
	bh=6w1DVeKA8zNRni0J6Va6E08DC7S64L5ylLJOflGp/M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRPvlNVn69AtmB37MfDoN6+xaKKW9VFqNqmOour7JbJ8GqjcgDJsEfUMX5fn3KEwE
	 RbMxMb3mdCbFTQDwl+qI90nzbj8TZDu9RJhBAYXOwLX2YEFAgnXtwsGKUj0FdOKEDx
	 iJGaJdPgWxQH+R2DXgdyArTbCC3EoxRkwDiAEny8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1117/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Enable internal ADC reference
Date: Tue, 21 Jul 2026 17:20:33 +0200
Message-ID: <20260721152540.544912383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


