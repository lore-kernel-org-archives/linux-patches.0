Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560F817592;
	Tue, 30 Apr 2024 11:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476279; cv=none; b=nn3n2eMUdAOXP2xWoXKvR6nxNasI/Y18rtW79vC5dwZQchGZG00JLgl8dYdEx6dnkxdpVQr1J+pMiYbwa7Il+Vy2MubViiMki4POn6epbv7gLhriN5Nqp9roOETYOEWfAf8PwL/itfuNLW7fjU1N/uMrf2JkfNTnCxvKkPHf5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476279; c=relaxed/simple;
	bh=OEZ9oXwKggg/X2MCUWUdeSinCN+dgXipmDJW76SxbZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOjwETryjT/jXLtSlt4ibfQj8ZExrmc2hYKULTQgbDGDSVjWfiR+CNDDT3j/ow9P4IagoGwb4aAqWASSoAgZN5Q+WgeLpk2+m07LdkFTFIcTn48UIVx7V2JyLQMcfbuHFNxvh+MmyBhCUwwWGjyoR23moBxHfF9TMw8NVdgBOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrxPfnbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrxPfnbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D289FC2BBFC;
	Tue, 30 Apr 2024 11:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476279;
	bh=OEZ9oXwKggg/X2MCUWUdeSinCN+dgXipmDJW76SxbZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrxPfnbGkSbxBz3cMKmj7Opk4mv1+YBZIJdrK1yy6F3hTZmMvMdTlHWMxBMb1311q
	 iJh9XSkPm1bCRfrFKjJv16B4VRFvCS0KHoVlOe5BX0max8Af6l+x85h665bnbPZLDJ
	 saGBYDHjcdj5LJaIVdhdmxj7NtwP3IAf4OycHlo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskander Amara <iskander.amara@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.4 091/107] arm64: dts: rockchip: enable internal pull-up for Q7_THRM# on RK3399 Puma
Date: Tue, 30 Apr 2024 12:40:51 +0200
Message-ID: <20240430103047.344503249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,6 +431,16 @@
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


