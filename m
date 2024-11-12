Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045F1BD031;
	Tue, 12 Nov 2024 10:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407603; cv=none; b=e2rpKVrAD0cXnAXsU0nj979MyZrw2GLrJj4KBYJ6xLf3g4c9sfTKh/iXL85FaD3ffsNXvXZkwcmL5Dl6n2lJG9Ygp+qPcprevaEeM4UmYoiwpcCHYhLkc1lLaILCtFf1k7bILVkeLhNzhWaUzZsPLnAUpZEm+IlKhN/Orce+aNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407603; c=relaxed/simple;
	bh=syQM+QKZviJfqK0IjrFHTkH+KfYjCwyhrQb0PSyQOJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5n0WXcTRS9ckomKPGPXw2kbLd7H+33GZZnCQ1r0QF7bexbKrEodAamgU5OxcSjcuiqZ6Vk++kXj0+u0hL0QxE68yer8hP+OanmuM3ObVfy2EjKsMRjBbhxV2Xm0ozeM4mcDCLZzPRIEgL84mu6299Qdqv3b7KkjjKuZYFyhyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLL+qhbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLL+qhbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B254C4CECD;
	Tue, 12 Nov 2024 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407602;
	bh=syQM+QKZviJfqK0IjrFHTkH+KfYjCwyhrQb0PSyQOJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLL+qhbScCqW5NMCH/taQ+Fdplx0HkFjAr9BU59/69qi736nR+tiHwtD+EsK6YOoo
	 pNyjwFhn9KQl5EOk7AgidDWZOWMQcWSRCjaknHZxWHFl1v/iBqdBRsxt2hajv5k/Q0
	 X7+iUTfmTqriqYMQou1Jue99zhzfF+X28pLeBtgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/119] arm64: dts: rockchip: Fix reset-gpios property on brcm BT nodes
Date: Tue, 12 Nov 2024 11:20:13 +0100
Message-ID: <20241112101848.919367623@linuxfoundation.org>
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

[ Upstream commit 2b6a3f857550e52b1cd4872ebb13cb3e3cf12f5f ]

For most compatibles, the "brcm,bluetooth.yaml" binding doesn't allow
the 'reset-gpios' property, but there is a 'shutdown-gpios' property.

Page 12 of the AzureWave-CM256SM datasheet (v1.9) has the following wrt
pin 34 'BT_REG_ON' (connected to GPIO0_C4_d on the PineNote):

  Used by PMU to power up or power down the internal regulators used
  by the Bluetooth section. Also, when deasserted, this pin holds the
  Bluetooth section in reset. This pin has an internal 200k ohm pull
  down resistor that is enabled by default.

So it is safe to replace 'reset-gpios' with 'shutdown-gpios'.

Fixes: d449121e5e8a ("arm64: dts: rockchip: Add Pine64 PineNote board")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20241008113344.23957-5-didi.debian@cknow.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi  | 2 +-
 arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 42f9507c01da1..27d89f48c42bd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -685,9 +685,9 @@
 		clock-names = "lpo";
 		device-wakeup-gpios = <&gpio0 RK_PC2 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PC3 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpio0 RK_PC4 GPIO_ACTIVE_LOW>;
 		pinctrl-0 = <&bt_enable_h>, <&bt_host_wake_l>, <&bt_wake_h>;
 		pinctrl-names = "default";
+		shutdown-gpios = <&gpio0 RK_PC4 GPIO_ACTIVE_LOW>;
 		vbat-supply = <&vcc_wl>;
 		vddio-supply = <&vcca_1v8_pmu>;
 	};
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
index 45de2630bb503..e9fa9bee995ae 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3.dtsi
@@ -402,9 +402,9 @@
 		clock-names = "lpo";
 		device-wakeup-gpios = <&gpio2 RK_PB2 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio2 RK_PB1 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_h &bt_reg_on_h &bt_wake_host_h>;
+		shutdown-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_LOW>;
 		vbat-supply = <&vcc_3v3>;
 		vddio-supply = <&vcc_1v8>;
 	};
-- 
2.43.0



