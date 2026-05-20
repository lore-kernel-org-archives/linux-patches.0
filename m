Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7233769E0;
	Wed, 20 May 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300867; cv=none; b=X0w3CmI1XHjoGMjj4rmt5LKfN7bNPUQd3aJZOBOtsQQR/SJFaYSqT57389PJvqGCc/cp+s6D8kc8+2VcwF/yBomyDjmycEliZVhxQiTcC/cqvEOa+/8NcnAEqfyMbxkffgXUHvUcGEE4DFdOfBsoYh68GahIY7LgdB4mI1WOpbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300867; c=relaxed/simple;
	bh=7uwzOi4jvyc6e53sjJObZWVF0pt+GjDNiT48nQyIkpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuqBgPymvtwfU0TxdrMhPqQEVy7v/qjW1iu6hgtHl+LHjqXUBhWSzsmgyMle6wH4R6pmUr9LAy5wuXhb4h3XosHMCU9y4ScizcTmC7+CJE5nUPmHyBVocfAptAwZg+jNtAHoPcbmFtNXMlfZ5jIkLWw5s08NevVt9iwkRht8UGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+8ew4Uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+8ew4Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9B41F000E9;
	Wed, 20 May 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300866;
	bh=VWX4Bnm8VdVeul6yJD2NJoipoaWLMiw+vN9SSTvXA7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+8ew4UvxuGCf/DMN8mMvEUwiUcF3Ir6akeEjnemQJuGjDV2vMq65MUoo094ko9to
	 d0/lx+VayuzanCoB7ifHwEqXtY3pIN5r3cwVBKE2GRoqVbxmkbSuXLuZd9mdh3J98m
	 lz3yM2NRGLI8lQI1dS5nqMNLvopFr7Jz8NCmIkxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/666] arm64: dts: lx2160a: change zeros to hexadecimal in pinmux nodes
Date: Wed, 20 May 2026 18:18:32 +0200
Message-ID: <20260520162117.742408825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 03241620d2b9915c9e3463dbc56e9eb95ad43c08 ]

Replace some stray zeros from decimal to hexadecimal format within
pinmux nodes.

No functional change intended.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 83e618df6f4b9..15a5691c40060 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1718,7 +1718,7 @@ pinmux_i2crv: pinmux@70010012c {
 			pinctrl-single,function-mask = <0x7>;
 
 			i2c1_pins: iic2-i2c-pins {
-				pinctrl-single,bits = <0x0 0 0x7>;
+				pinctrl-single,bits = <0x0 0x0 0x7>;
 			};
 
 			gpio0_31_30_pins: iic2-gpio-pins {
@@ -1730,7 +1730,7 @@ esdhc0_cd_wp_pins: iic2-sdhc-pins {
 			};
 
 			i2c2_pins: iic3-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 3)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 3)>;
 			};
 
 			gpio0_29_28_pins: iic3-gpio-pins {
@@ -1738,7 +1738,7 @@ gpio0_29_28_pins: iic3-gpio-pins {
 			};
 
 			i2c3_pins: iic4-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 6)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 6)>;
 			};
 
 			gpio0_27_26_pins: iic4-gpio-pins {
@@ -1746,7 +1746,7 @@ gpio0_27_26_pins: iic4-gpio-pins {
 			};
 
 			i2c4_pins: iic5-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 9)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 9)>;
 			};
 
 			gpio0_25_24_pins: iic5-gpio-pins {
@@ -1754,7 +1754,7 @@ gpio0_25_24_pins: iic5-gpio-pins {
 			};
 
 			i2c5_pins: iic6-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 12)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 12)>;
 			};
 
 			gpio0_23_22_pins: iic6-gpio-pins {
-- 
2.53.0



