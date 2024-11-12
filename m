Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498FD213EE4;
	Tue, 12 Nov 2024 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407732; cv=none; b=UeprsdVxhlKL0yD1NmavxrcMmvXuwCKVDRcsS4HTgxat/96voL7AlbTIMTipNnYLQkSutq+CvDQuXfnBo+c6nLm1ezPIIBFf+AztEUhNGGh4piwNrkUwEqS9tA4M8ADIMCd9erSR0K8nGK+M3vs9NOpdbZ0Aqy6tAN01XspYg/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407732; c=relaxed/simple;
	bh=dphSEdx4h4661FOze0DOPF+zQFFCOkkLwjQlQWLYPbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfnGoFdckcedwtNA3zDdp9WyLuAyAOG37Gn17b+5d8AdbAbgR2dIQc4vvKOYDUBOZfC0ZRNInkiEisPhjpYfALHpvB269Bq6MDbxsEfvv3fNAJ7JPRiHdjgHPnpNhakcqa1FImRqZdJRuTSfD4NuTprQAsxcl8kowvW5wdr41Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkpzkNBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkpzkNBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9B1C4CED4;
	Tue, 12 Nov 2024 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407732;
	bh=dphSEdx4h4661FOze0DOPF+zQFFCOkkLwjQlQWLYPbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkpzkNBolLmFWnZstowgTWZf6a7RxdjqSN1IWwPJ3MjvbZAMRx4CNyJuezv+odpU6
	 LqWdgCyHqyn/9ID1bPciZHML2vfkY1bE6XtJWy49C/B0gc2YwB0MgiC+xN+RGo6NPN
	 mgtiLHU+bE+mu7/OtqFzyPANbtKMPzPWOmN8bhus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/119] arm64: dts: rockchip: Correct GPIO polarity on brcm BT nodes
Date: Tue, 12 Nov 2024 11:20:31 +0100
Message-ID: <20241112101849.598656367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <didi.debian@cknow.org>

[ Upstream commit 08846522d9a7bccf18d4f97c3f39d03c7a193970 ]

Paragraph "3.4 Power up Timing Sequence" of the AzureWave-CM256SM
datasheet mentions the following about the BT_REG_ON pin, which is
connected to GPIO0_C4_d:

  When this pin is low and WL_REG_ON is high,
  the BT section is in reset.

Therefor set that pin to GPIO_ACTIVE_HIGH so that it can be pulled low
for a reset.
If set to GPIO_ACTIVE_LOW, the following errors are observed:

  Bluetooth: hci0: command 0x0c03 tx timeout
  Bluetooth: hci0: BCM: Reset failed (-110)

So fix the GPIO polarity by setting it to ACTIVE_HIGH.
This also matches what other devices with the same BT device have.

Fixes: 2b6a3f857550 ("arm64: dts: rockchip: Fix reset-gpios property on brcm BT nodes")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20241018145053.11928-2-didi.debian@cknow.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi  | 2 +-
 arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 27d89f48c42bd..9944c9d4ca9fe 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -687,7 +687,7 @@
 		host-wakeup-gpios = <&gpio0 RK_PC3 GPIO_ACTIVE_HIGH>;
 		pinctrl-0 = <&bt_enable_h>, <&bt_host_wake_l>, <&bt_wake_h>;
 		pinctrl-names = "default";
-		shutdown-gpios = <&gpio0 RK_PC4 GPIO_ACTIVE_LOW>;
+		shutdown-gpios = <&gpio0 RK_PC4 GPIO_ACTIVE_HIGH>;
 		vbat-supply = <&vcc_wl>;
 		vddio-supply = <&vcca_1v8_pmu>;
 	};
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
index e9fa9bee995ae..1e36f73840dad 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
@@ -404,7 +404,7 @@
 		host-wakeup-gpios = <&gpio2 RK_PB1 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_h &bt_reg_on_h &bt_wake_host_h>;
-		shutdown-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_LOW>;
+		shutdown-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_HIGH>;
 		vbat-supply = <&vcc_3v3>;
 		vddio-supply = <&vcc_1v8>;
 	};
-- 
2.43.0



