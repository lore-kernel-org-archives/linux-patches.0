Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373781BE222;
	Tue,  2 Jul 2024 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940613; cv=none; b=fZOeKLYQJLTHwt2v8RBVDDFG23hTiekrjC7WcWJNFCAcPjonjMhZcoQ96kKgVdHRFazHm6SBlNUF4+SRTfPggUvzvOi6GUcvXc9zDZROW1BERaUkAwlZqDoxi1HwVgmuVtFP81K/teJS8MFoTDIsAEOUdCtGN+dDugAm4JHSp1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940613; c=relaxed/simple;
	bh=7VcgX98JP45XxDQV+K9qcXRoEmj8aEPO827lJj77gdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KU1BLLcI3yjSNUknhnUHSFQ40AZ5Gfsx64jKcJlKMAKaSGyBWTi2ep5b6xToVBWPzXwCJ7kAaX/EHtNH+ucRADB/PBok8ZsnHj2RDWTqW62dPHDv6gUsop8/NNRSR9T+qptcd5G4IMHjkNisqKWMc4P6++bVb8dMwjV66qfo+DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hv6/CxhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hv6/CxhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66D7C116B1;
	Tue,  2 Jul 2024 17:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940613;
	bh=7VcgX98JP45XxDQV+K9qcXRoEmj8aEPO827lJj77gdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hv6/CxhZOdpwaA99QzowzZBMVRYyUQvz3CK7W83wwkxzKVWDxEKjPzghyWeIV1MIj
	 iIXAd5wDAkDWzmOjPcO9egny4K2wrU9cOlPACm7tP35wGlDAllzeD1XOeWaCpykPF/
	 cqjo0orsxRa+r8NYA2QoBXkjxk2fUgdXmSuJfRj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 207/222] arm64: dts: rockchip: set correct pwm0 pinctrl on rk3588-tiger
Date: Tue,  2 Jul 2024 19:04:05 +0200
Message-ID: <20240702170251.899349991@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit a21d2cc2f9039023105bf9f9bf1acf324d5ebf9d ]

PWM0 on rk3588-tiger is connected to the BLT_CTRL pin of the Q7 connector
meant as the name implies to control a backlight device.

Therefore set the correct M1 pinctrl variant for it. The M0 variant
cannot ever be used because that pin is routed to a connector pin on the
Q7 connector that is reserved for CAN use and the pin reachable by the M2
variant is reserved for the embedded MCU on the SoM.

Fixes: 6173ef24b35b ("arm64: dts: rockchip: add RK3588-Q7 (Tiger) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20240603192254.2441025-1-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
index 1eb2543a5fde6..64ff1c90afe2c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi
@@ -324,6 +324,11 @@
 	};
 };
 
+&pwm0 {
+	pinctrl-0 = <&pwm0m1_pins>;
+	pinctrl-names = "default";
+};
+
 &saradc {
 	vref-supply = <&vcc_1v8_s0>;
 	status = "okay";
-- 
2.43.0



