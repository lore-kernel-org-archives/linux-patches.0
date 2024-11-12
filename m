Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B64214406;
	Tue, 12 Nov 2024 10:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407227; cv=none; b=IJSSwt5QaQK4g6O9gA7XrKug2KYlTMsHghCuEGPXMAajsSgFf0dNkzomapihhVOmPyMmT13I8tsTDBwTepkTQLEGZbAfq6/7hC2z6m/bpdrmLTgm64sg5NCf1yhAqiSuohjM+kFLRN4nsd7v8vKdjqqoHmkvgaAYbDeXMr884Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407227; c=relaxed/simple;
	bh=fg9+C8+P+mhW0KnF5Omxci/FEuVrj/h6UW4EZTeTEww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc9Q2LiOky1VV/+KZChqKmRrnA8O0P6DB2+XDN51XD35hwi/RhLmHZmZSEqv79ELnweX3d2MwXiNS35LdnL4Rh4Tm1Ce8j6qRDctJ9HbNKdhvjJc0p6hKZkIJ1oyTmX14zJihdrVTq6o/qTIWAOVkFO0d2nzSC+KPM0gDE+VQv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4NCz/Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4NCz/Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59098C4CECD;
	Tue, 12 Nov 2024 10:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407226;
	bh=fg9+C8+P+mhW0KnF5Omxci/FEuVrj/h6UW4EZTeTEww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4NCz/DacBfBvTJrH8+HYOrVjCMh8lMz2fcmhYqAXznkiLAANj9JQRyBDBuLTBNg2
	 exoGj7wLVvw1ZTjeFPUNJaiAw/bdq6dGQZcTavzXV+++BP/Jkn5JkmrSbCONzjWyoi
	 APstxiWq3TAFXRFD34uv3HvjvELFV9uDDHoZqNOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/98] arm64: dts: rockchip: Fix wakeup prop names on PineNote BT node
Date: Tue, 12 Nov 2024 11:20:19 +0100
Message-ID: <20241112101844.437449517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <didi.debian@cknow.org>

[ Upstream commit 87299d6ee95a37d2d576dd8077ea6860f77ad8e2 ]

The "brcm,bluetooth.yaml" binding has 'device-wakeup-gpios' and
'host-wakeup-gpios' property names, not '*-wake-gpios'.
Fix the incorrect property names.

Note that the "realtek,bluetooth.yaml" binding does use the
'*-wake-gpios' property names.

Fixes: d449121e5e8a ("arm64: dts: rockchip: Add Pine64 PineNote board")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20241008113344.23957-4-didi.debian@cknow.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 8d61f824c12dc..52ab14308a5c1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -685,8 +685,8 @@
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&rk817 1>;
 		clock-names = "lpo";
-		device-wake-gpios = <&gpio0 RK_PC2 GPIO_ACTIVE_HIGH>;
-		host-wake-gpios = <&gpio0 RK_PC3 GPIO_ACTIVE_HIGH>;
+		device-wakeup-gpios = <&gpio0 RK_PC2 GPIO_ACTIVE_HIGH>;
+		host-wakeup-gpios = <&gpio0 RK_PC3 GPIO_ACTIVE_HIGH>;
 		reset-gpios = <&gpio0 RK_PC4 GPIO_ACTIVE_LOW>;
 		pinctrl-0 = <&bt_enable_h>, <&bt_host_wake_l>, <&bt_wake_h>;
 		pinctrl-names = "default";
-- 
2.43.0



