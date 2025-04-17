Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6989925525C;
	Thu, 17 Apr 2025 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916022; cv=none; b=US3Ikgnd2qFs34vF/YrKoSlEk0J9MlzpH/orp2onu0DRfBelgofAYSJKFWkTHoOHfuSUq4nT97ZXKaSp9FZ8L7PrMcPlvufVQclZOHaRt7dZJFoXuCg/rBFpsSjNa/IOFh9pZg3+7x+Cvi55K6UCctdAyhA5nY4onAFOs5xw5XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916022; c=relaxed/simple;
	bh=3y3PMm0tVQAUjU/Xvmx+6nF/hzWgLIoEsPBnM6eDK2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4CVPOCBhWxEWHbfOqUnEkn0BsFAoKHCOEIyuySQMLHjiGsfK1TaQpyGskcir5RyoDD/1wGT554t4TOHjHaEfLy5IINJybvyXzDd0P6Z1hLLxYVn8NnvoOVcoMEUuP/vhwnY2pYay/vZRbw0gXb4imP8+jRjEqcdBilCvEkMENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDPlYaBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDPlYaBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F6BC4CEE4;
	Thu, 17 Apr 2025 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916022;
	bh=3y3PMm0tVQAUjU/Xvmx+6nF/hzWgLIoEsPBnM6eDK2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDPlYaBAIXnnGU6aorURM3OEqnYWj54w5J3kUByi8NL/MiwdRd62JrxKXcrluBUFW
	 vGmz+Ht0U2ysCjNOjK+njeXPRy2DpoKwjeJmsCRRFYxiyILxbGg+xXrLzBH7kL8Cfe
	 uJuPxd3qD3LvujnbM235bR8OG7kP5AbNZoYp2Xtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 288/393] arm64: dts: exynos: gs101: disable pinctrl_gsacore node
Date: Thu, 17 Apr 2025 19:51:37 +0200
Message-ID: <20250417175119.199687812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit 168e24966f10ff635b0ec9728aa71833bf850ee5 upstream.

gsacore registers are not accessible from normal world.

Disable this node, so that the suspend/resume callbacks
in the pinctrl driver don't cause a Serror attempting to
access the registers.

Fixes: ea89fdf24fd9 ("arm64: dts: exynos: google: Add initial Google gs101 SoC support")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: tudor.ambarus@linaro.org
Cc: andre.draszik@linaro.org
Cc: kernel-team@android.com
Cc: willmcvicker@google.com
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250106-contrib-pg-pinctrl_gsacore_disable-v1-1-d3fc88a48aed@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -1451,6 +1451,7 @@
 			/* TODO: update once support for this CMU exists */
 			clocks = <0>;
 			clock-names = "pclk";
+			status = "disabled";
 		};
 
 		cmu_top: clock-controller@1e080000 {


