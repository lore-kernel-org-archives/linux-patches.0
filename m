Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8812C46B;
	Tue, 30 Apr 2024 10:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474003; cv=none; b=tKfv1CPxuWrmImwcN0uS/xEMQCUyUZgpc31WP39rKqpBOmnfO6NOa+4uidaf8L1wclJ16CJYAFf1m1as76pexeS1wNaK+ulV+MwmySXhREMHd7Nv6BFKyrYkCPRFFICjAEHBhM3mCj0CjSVh+poLLPCSo8KrvfC4hbAZe7rZ7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474003; c=relaxed/simple;
	bh=S7ysZL141fAamMuVIO0Cod4xpfUKoBcTJ3mfXevFUMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHdBzZoDBAtL1DLwBOZU6SVMYI8xa6/kVGiW0TahZdoI+EeTy9POdTVwIqxLcYPJDQTlAjyKAKKiicDcr/xwfsuJ0VAiV9aXeLPZU0FEWl0Fr9BkBcK8sWJPQMmz7faCdGyAM5lO6U5yiw281tPO3ep7mrTIT2SgviUWGLr/I4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m16Zi7gO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m16Zi7gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6D8C4AF14;
	Tue, 30 Apr 2024 10:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474002;
	bh=S7ysZL141fAamMuVIO0Cod4xpfUKoBcTJ3mfXevFUMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m16Zi7gOw/fUt64taxGc+obIQyk+oKpFqXw7TNyv9wyrVORN+J1Y94cxw8/2u8Xqs
	 K/tL7ug7RxxwY6QFBigLOR32rDaiC0Jh8YHlufLd0gQ6mO69RayGUQlAVNCekcLqd1
	 tOYJbiy5Ury3rLORnOt8OWJxsBn/+HFweXbBnvdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammed Efe Cetin <efectn@protonmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 032/228] arm64: dts: rockchip: mark system power controller and fix typo on orangepi-5-plus
Date: Tue, 30 Apr 2024 12:36:50 +0200
Message-ID: <20240430103104.743799002@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammed Efe Cetin <efectn@protonmail.com>

[ Upstream commit 08cd20bdecd9cfde5c1aec6146fa22ca753efea1 ]

Mark the PMIC as system power controller, so the board will shut-down
properly and fix the typo on rk806_dvs1_null pins property.

Fixes: 236d225e1ee7 ("arm64: dts: rockchip: Add board device tree for rk3588-orangepi-5-plus")
Signed-off-by: Muhammed Efe Cetin <efectn@protonmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20240407173210.372585-1-efectn@6tel.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
index 3e660ff6cd5ff..e74871491ef56 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-orangepi-5-plus.dts
@@ -486,6 +486,7 @@
 		pinctrl-0 = <&pmic_pins>, <&rk806_dvs1_null>,
 			    <&rk806_dvs2_null>, <&rk806_dvs3_null>;
 		spi-max-frequency = <1000000>;
+		system-power-controller;
 
 		vcc1-supply = <&vcc5v0_sys>;
 		vcc2-supply = <&vcc5v0_sys>;
@@ -507,7 +508,7 @@
 		#gpio-cells = <2>;
 
 		rk806_dvs1_null: dvs1-null-pins {
-			pins = "gpio_pwrctrl2";
+			pins = "gpio_pwrctrl1";
 			function = "pin_fun0";
 		};
 
-- 
2.43.0



