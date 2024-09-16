Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75413155CBA;
	Mon, 16 Sep 2024 12:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488290; cv=none; b=cTovi3G3nxXzp6LpOxqohh6HJbDImkGXqX/NkonKTo07w1zfoctfOyWe6ku3QvvphT09rxoMJ9WWs/H7r6Q7velV7trYRtBYqYdHCnDd5oscdYioulrriTHOEM8qrzHVymxdn/SpuSFXlDaKdCI8IBZHbcv+V+kgb+ZV1THezIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488290; c=relaxed/simple;
	bh=0D0m6ZoB+Gjob1IHVUrjrTFjnjg+JMqdeDta62H9UG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzkpZwqpaGHL0xsNv4Gw7Qtz9dI/8h/KzuKcGXmwN7gSPm9+tR4ohKZjjESwFQgBoIVHQc1/U7/LTxbCxcPkapbo5KpW774aVSIHSP1V75TX1L6Rh9ELvDnXcepG2MxNqanYG0qsPj9TiySD/9N5//+z2B8CUE7CjDgDdhQYnWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFl/RNEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFl/RNEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF85EC4CEC4;
	Mon, 16 Sep 2024 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488290;
	bh=0D0m6ZoB+Gjob1IHVUrjrTFjnjg+JMqdeDta62H9UG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFl/RNEFxJMqCJ/OTyfGjcjfRP4oZhgPgXc9FPPDq9XHTLwT1bxJX5PREwgXfUuyc
	 JjeLuHiHGXF/9QpxLAWOFjMxg93LRKyGzM7myvyvqDJqksFv8ZcbDuK2G91ZUkU6w9
	 sLNwSDvT+L0rPBCOvbrGV7/MdTXhfti3KRPn/m3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Wu <xingyu.wu@starfivetech.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 061/121] riscv: dts: starfive: jh7110-common: Fix lower rate of CPUfreq by setting PLL0 rate to 1.5GHz
Date: Mon, 16 Sep 2024 13:43:55 +0200
Message-ID: <20240916114231.184003791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingyu Wu <xingyu.wu@starfivetech.com>

[ Upstream commit 61f2e8a3a94175dbbaad6a54f381b2a505324610 ]

CPUfreq supports 4 cpu frequency loads on 375/500/750/1500MHz.
But now PLL0 rate is 1GHz and the cpu frequency loads become
250/333/500/1000MHz in fact.

The PLL0 rate should be default set to 1.5GHz and set the
cpu_core rate to 500MHz in safe.

Fixes: e2c510d6d630 ("riscv: dts: starfive: Add cpu scaling for JH7110 SoC")
Signed-off-by: Xingyu Wu <xingyu.wu@starfivetech.com>
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/starfive/jh7110-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
index 68d16717db8c..51d85f447626 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
@@ -354,6 +354,12 @@ spi_dev0: spi@0 {
 	};
 };
 
+&syscrg {
+	assigned-clocks = <&syscrg JH7110_SYSCLK_CPU_CORE>,
+			  <&pllclk JH7110_PLLCLK_PLL0_OUT>;
+	assigned-clock-rates = <500000000>, <1500000000>;
+};
+
 &sysgpio {
 	i2c0_pins: i2c0-0 {
 		i2c-pins {
-- 
2.43.0



