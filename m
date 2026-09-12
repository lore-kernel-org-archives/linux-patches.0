Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEBA1E5B9F;
	Sat, 12 Sep 2026 07:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199641; cv=none; b=GE5UC5/9pToC35nT8bO5h7HN41gT0IZFECcCWdv14CCjfGW1TFj2HfbcJqMbDdVN7M2WuStOwT9abSmQ7NH6AAhBOBJoCjRXjmsCrkxrtqHaGNeTdZZnojI+p6YUXRwvbC2E21X1X2ZUZsrAd6QRbD7Pnt5CCOKlEpEd+lCHRv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199641; c=relaxed/simple;
	bh=aJ5Z3O8SoDi6gEPAyq+hs9s8tJ34dRTs6cjCaXTaGEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nld38Hb1TovnZx9YYztxDojH+rzkMVnhsjdNsqgAMUEs4ENaWrBJywRCqPHLXgwZk1GnWKzAJD2rDYOrEhaodOBd9Wj0VbyLF+uupn4iK8FWcqXOmGvELeMhTUiyCXkRZvJgD0yrixXy1Q0gGUTwsg1ZA872CgzCHwjR19zO0yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzWcgf+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzWcgf+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF3B1F000FF;
	Sat, 12 Sep 2026 07:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199640;
	bh=dg1EvE2lkAsSssNJMCG9H3fj3xWszEQg8p/brcmTWDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzWcgf+S4TXxFAPDcsAwmAC/w777KtdNPQSb/r9R4qDlYI/Vd6VsjydKDeX59m0bf
	 u6blBOjiBSKWr7dsVmC2V+BT2hPY5JfTydd4ZxkZINFwS4T6wSfjTKl4k5lufjPPRn
	 I70t8j140RoP4B8/Mo0G+7ppGumSYF+3ICCOzVW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0625/1815] riscv: dts: thead: th1520: remove pclk for I2C1
Date: Sat, 12 Sep 2026 08:39:35 +0200
Message-ID: <20260912065703.551733181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit 5ed8cdb56cd90859e0c7f269b4a7c2b1571419b2 ]

The I2C1 node added previously to the th1520.dtsi file has two clocks
set -- one "ref" clock (CLK_I2C1) and one "pclk" (CLK_PERI_APB_PCLK).

However, the CLK_I2C1 clock is just a clock gate with the
CLK_PERI_APB_PCLK clock as its input. In addition, when it's gated,
reading registers from the I2C controller returns fixed value (the last
read value) for all registers. These facts indicate that the CLK_I2C1
clock is the true APB clock fed into the I2C controller instead of a
dedicated reference clock.

Leave only the CLK_I2C1 clock as the `clocks` property of the I2C1
device node and remove `clock-names` property, which represents the I2C
controller only takes a single clock both as the APB clock and the
reference clock.

Fixes: 2f60e3516330 ("riscv: dts: thead: Add TH1520 I2C1 controller")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Link: https://lore.kernel.org/r/20260714074515.1959352-2-zhengxingda@iscas.ac.cn
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/thead/th1520.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/thead/th1520.dtsi b/arch/riscv/boot/dts/thead/th1520.dtsi
index 94932c51b7e39..db23624696b73 100644
--- a/arch/riscv/boot/dts/thead/th1520.dtsi
+++ b/arch/riscv/boot/dts/thead/th1520.dtsi
@@ -415,8 +415,7 @@ i2c1: i2c@ffe7f24000 {
 			compatible = "thead,th1520-i2c", "snps,designware-i2c";
 			reg = <0xff 0xe7f24000 0x0 0x4000>;
 			interrupts = <45 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk CLK_I2C1>, <&clk CLK_PERI_APB_PCLK>;
-			clock-names = "ref", "pclk";
+			clocks = <&clk CLK_I2C1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
-- 
2.53.0



