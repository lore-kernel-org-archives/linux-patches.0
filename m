Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AC51DF27F;
	Tue, 12 Aug 2025 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023361; cv=none; b=LW9JVGudUhOrsbbP2ASWHdbuULu/fEiKa+cQOBx+erFd8IBLCeHKE0pWtQXz5s5EuLWmgZk5HgPRc9zK4H3+/7Rq1var6liu4XNuG1vD/i+MJdcoUXaW2lVccE+Hm/6V2Abm4xvnw8Vi3R2EloVWtGGe7NYJt3vYj3jLfqCq9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023361; c=relaxed/simple;
	bh=3+6eWTrXULcGbw7H9izSRr4xsFzxd/aQ16Fu/V8V7rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baG2XnsPG1B3k66knBV4AhIdl3fHK7YMekvp45BMta6vy6GIjZNZrSovWWFKNfwh61LGti37Ar5lR4aa9G36V24Xinc7gUa/+1xoTBKeiqULxRNMmNdygwiyKy9ozfRBLwODkqbaU31v6j7kKx5MJ5sQ6DSu3jQN2V7DHBVwR2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJYD3T7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJYD3T7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5235CC4CEF0;
	Tue, 12 Aug 2025 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023358;
	bh=3+6eWTrXULcGbw7H9izSRr4xsFzxd/aQ16Fu/V8V7rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJYD3T7Xq+IaBZXj3NQ2e+JOOrV0t3RtXUE3evmvOHLL+Hf7HgJaaw9GA5KM2pBiN
	 vMxKwje+6EvTzk5TpGd5oSCvg/l4F6aIHScLLWDH7PnBKTZEcGdcSUW31YPQnHeh4N
	 vl5KddO3KaBeRIwCSGfl28BK0x4FArH0p+N7IPko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 055/627] arm64: dts: ti: k3-am62p-verdin: Enable pull-ups on I2C_3_HDMI
Date: Tue, 12 Aug 2025 19:25:50 +0200
Message-ID: <20250812173421.423524731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit cb2d9c00770e2e6c51864704b5d98c9a0ddccaf9 ]

Enable internal bias pull-ups on the SoC-side I2C_3_HDMI that do not have
external pull resistors populated on the SoM. This ensures proper
default line levels.

Fixes: 87f95ea316ac ("arm64: dts: ti: Add Toradex Verdin AM62P")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20250529102601.452859-1-ghidoliemanuele@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
index 226398c37fa9..d90d13287076 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
@@ -717,8 +717,8 @@ AM62PX_MCU_IOPAD(0x0010, PIN_INPUT, 7) /* (D10) MCU_SPI0_D1.MCU_GPIO0_4 */ /* SO
 	/* Verdin I2C_3_HDMI */
 	pinctrl_mcu_i2c0: mcu-i2c0-default-pins {
 		pinctrl-single,pins = <
-			AM62PX_MCU_IOPAD(0x0044, PIN_INPUT, 0) /* (E11) MCU_I2C0_SCL */ /* SODIMM 59 */
-			AM62PX_MCU_IOPAD(0x0048, PIN_INPUT, 0) /* (D11) MCU_I2C0_SDA */ /* SODIMM 57 */
+			AM62PX_MCU_IOPAD(0x0044, PIN_INPUT_PULLUP, 0) /* (E11) MCU_I2C0_SCL */ /* SODIMM 59 */
+			AM62PX_MCU_IOPAD(0x0048, PIN_INPUT_PULLUP, 0) /* (D11) MCU_I2C0_SDA */ /* SODIMM 57 */
 		>;
 	};
 
-- 
2.39.5



