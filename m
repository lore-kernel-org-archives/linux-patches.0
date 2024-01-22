Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1906024F;
	Tue, 23 Jan 2024 00:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970790; cv=none; b=vBRPHfuRJhY7ecxytMgfqF6GFuI+LdtSgr3ALWuT2wHq4pjPlsIrB4NnUJ6V6vkgZY/b45GamaB/+8G6rrbzOlgHdlEiTdLV11WOXmhorr/Xna8wMBigToggiJmUOwWr1aWIlWj2DldL7+7CdpW9DvOmWF1qrR7BX54ca1qn/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970790; c=relaxed/simple;
	bh=msqp7pFrVRAT4/4k1nDmtK6DM95uY1ptTaP1CbyDr+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKbB4zTVxxQj5fNQZJqlN6cseE0HqT4pXh7qfYAK6ZtPLuHx0RZg/NuTHh/9SqifbqoWuY+V2/FpRNOQ3QfGUODz7G6C1wXw6CUDF3KNXktGhy72rFBrxU+YPTXBwcOMeNnluEcQ0DlU6dAN0/thhIC7Wvy9XijIgJiI1rioKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn66oPmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn66oPmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE30C433F1;
	Tue, 23 Jan 2024 00:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970790;
	bh=msqp7pFrVRAT4/4k1nDmtK6DM95uY1ptTaP1CbyDr+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn66oPmbCOkGITgRO5OgS/uDQbQJOejQP7Bb073DYo4W6+KEZmigK/zkjH3ZVch6x
	 /V/MSH3yebAkpG5+pDO65sSu0BeqYhGddqChlAzTD1CA4fHnAzL/tO4rlVc2MmRTYo
	 pzT0PsDPku/2rW4sDcNLLn4sM0UoUIsMbwVpyiWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/417] arm64: dts: qcom: sc8280xp: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:19 -0800
Message-ID: <20240122235754.846394863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6c4a9c7ea486da490400c84ba2768c90d228c283 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.7.I1c8ab71570f6906fd020decb80675f05fbe1fe74@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 405835ad28bc..7e3aaf5de3f5 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1653,7 +1653,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc8280xp", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



