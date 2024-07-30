Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAADD1A6191;
	Tue, 30 Jul 2024 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356230; cv=none; b=smpUg/VutgRN69E54d045CYcxpe+OeT/WbC2yXWN9Qr9nycdXDHszH3PZvmE5S7Fo9aSIUNpOfvQuupMethPN+kTbYy/fAjRkJnNQdCpDm1QsAkhdPT+dtl5G/Ft62Fhfs+hwHhdwET+T4V3m55YR8IFAIT0Ckdmas17hdx6Xgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356230; c=relaxed/simple;
	bh=K2o/ZHXy994IGLZq7/Pv+ojkyC1MEQ3Iw3D7oQVq3aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMa3GvoyLFJxciQ2vev8W8Qid6hJkjcqK5Z0qcc6+PWNBrAEJWrhRpqHJQ+Jbu1JfgX+9DwWmL6/fEAhQk6ZgPIcBMMCb8om09ZHtdClvDXbRD1OtDcB64qBlxVPHycuGeLheMx5y0B6F+65dWQioLKNdHMNc/k0u0tpDh/vptQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSyUW4qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSyUW4qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D495C32782;
	Tue, 30 Jul 2024 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356230;
	bh=K2o/ZHXy994IGLZq7/Pv+ojkyC1MEQ3Iw3D7oQVq3aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSyUW4qZeZpDq3nmtmhX6610hO7tWG+qNoq48bgPL4t79YHHrQq0mCWTwQNQvDgSz
	 1McpeEvy/oAHmxGgzoeZOLz6j+KvCfTOXu22wYuXg7izgik5OzEaf6kAZK5bGv590i
	 ncL88EtbOd0zbO7fzKC5BHnnUGNFtzCkpXUHN49M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 131/809] arm64: dts: rockchip: fix regulator name for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:40:07 +0200
Message-ID: <20240730151729.790299130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 2dad31528de9ea8b05245ce6ac4f76ebf8dae947 ]

Make the regulator name the same as those marked by schematics.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240630150010.55729-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index 89e84e3a92629..93987c8740f7b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -39,9 +39,9 @@ status_led: led-status {
 		};
 	};
 
-	dc_12v: dc-12v-regulator {
+	vcc12v_dcin: vcc12v-dcin-regulator {
 		compatible = "regulator-fixed";
-		regulator-name = "dc_12v";
+		regulator-name = "vcc12v_dcin";
 		regulator-always-on;
 		regulator-boot-on;
 		regulator-min-microvolt = <12000000>;
@@ -65,7 +65,7 @@ vcc3v3_sys: vcc3v3-sys-regulator {
 		regulator-boot-on;
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
-		vin-supply = <&dc_12v>;
+		vin-supply = <&vcc12v_dcin>;
 	};
 
 	vcc5v0_sys: vcc5v0-sys-regulator {
@@ -75,7 +75,7 @@ vcc5v0_sys: vcc5v0-sys-regulator {
 		regulator-boot-on;
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
-		vin-supply = <&dc_12v>;
+		vin-supply = <&vcc12v_dcin>;
 	};
 
 	vcc5v0_usb_host: vcc5v0-usb-host-regulator {
-- 
2.43.0



