Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6046430F80C;
	Tue, 21 Jul 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655708; cv=none; b=WPc6Asnct3Fv7vOzCMUPOf8y+DF5XjHEr/BmUMo9uxMM/I5GuK7rh0qcBPSyYPEuDvnJ3lcSEyNTEh1awRoFEMDh9QgyDHhkcOtDkJ7p3qBqpxVoPq9aCfyJbsWYt5Tp6t5i2k7g7OvFPCYWPyrF3in+K6kgRawXKZcShsOv1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655708; c=relaxed/simple;
	bh=GW911QXLDApkLz2dBEebs2+hyYbykb3DhICENqKVGXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFBoxHrrzSd1eJJ/yYgygMwxknjUr/hNE37tgahol+dWpymEtApJNrzKz7aqUDhpcCoq+bJyQPk37PYNT19hDq126z45coZ9VZFuInLfduqhGRDA6GWNPRZE0PR5XRIqkvj1CaCwmNTUvA/iVvaZkqQ8leDhwEc1jwebEBtdj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2ZfBuYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2ZfBuYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE43D1F000E9;
	Tue, 21 Jul 2026 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655707;
	bh=RjChu42GdFg8wxVFbnTsT1w2kF8Dc152NsdzEpDgpSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2ZfBuYU5IC9hlI072YIpDEswpp7cSYI3V4mI11qTcIXlQx3KiHGAB1pQY0KnFhAL
	 xVgC0vCe5EZdQYvmUEHr1QU7nvcvDvPuk64BMdLnvXEKeiRnwMK46sp8pkIbg64U/K
	 oVDWRQv2oBQ/Q6jGzXHtJNrk12cV2Tu9p4fshaiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weixin Guo <2298701336@qq.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0112/1611] arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc
Date: Tue, 21 Jul 2026 17:03:48 +0200
Message-ID: <20260721152517.371181859@linuxfoundation.org>
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

From: Weixin Guo <2298701336@qq.com>

[ Upstream commit 460bac478c5fe69054ffc60d607bba03bcaf909b ]

The RK809 PMIC interrupt pin on the Firefly ROC-RK3566-PC (Station M2)
is physically connected to GPIO0_A3 (RK_PA3) according to the board's
schematic.

Currently, the PMIC node incorrectly specifies RK_PA7 for the interrupt,
which prevents the PMIC from correctly signaling interrupts. (Note that
the pinctrl node 'pmic_int' correctly configures RK_PA3).

Fix this by updating the interrupts property to use RK_PA3.

Fixes: 30ac9b4e25d8 ("arm64: dts: rockchip: add dts for Firefly Station M2 rk3566")
Signed-off-by: Weixin Guo <2298701336@qq.com>
Link: https://patch.msgid.link/tencent_5035EEE630C845B1B51DEA4284DE23DCCE06@qq.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 7e499064e03579..985770e3a5e2cc 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -245,7 +245,7 @@ rk809: pmic@20 {
 		compatible = "rockchip,rk809";
 		reg = <0x20>;
 		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PA7 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <RK_PA3 IRQ_TYPE_LEVEL_LOW>;
 		clock-output-names = "rk808-clkout1", "rk808-clkout2";
 		assigned-clocks = <&cru I2S1_MCLKOUT_TX>;
 		assigned-clock-parents = <&cru CLK_I2S1_8CH_TX>;
-- 
2.53.0



