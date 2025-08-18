Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0358320CDB;
	Mon, 18 Aug 2025 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523109; cv=none; b=YJGwSRl9dZ/PP1/xkA0HI56L52St6ECU8PwNQf4893XamXbIQxOsfJXpxgeExSKeBlClmHNEUQUVSg34wHKBDyFgXg7zrGHFZH2feuLd8TYl1/EPTsLH+aiJLc8oQPXL0nRjZNbFHSwTE6qgwSUUQt97icFVl+8EXRFYIySFYHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523109; c=relaxed/simple;
	bh=uHfFmg+/oq6XatJGSyZ8B8DRmbUXM44kXVoL9ULYDzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIOdAVBcV0ManPT9Ya10fSjDb7eryxCFCGTpjuLQwFyjvNiX3sufCp3kTbMqc//4VMCH1RL1JXtXqEEzFlSJnOl4qfowsG4iFgZv8q/1AvFAbuh1w2y+lsJVOvOxwnwAinS0obNAalTpShudZmcqEaduhpI+BV+XPXrhBypwfb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2HlJ4wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2HlJ4wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4023EC4CEEB;
	Mon, 18 Aug 2025 13:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523109;
	bh=uHfFmg+/oq6XatJGSyZ8B8DRmbUXM44kXVoL9ULYDzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2HlJ4wYijdvutVTrlNqgj1zvPD5YTlcGtOce7hNTQHbjadNpkXjtZPa3vfF9dmed
	 nDNFOTkRfxpI/iDhvmRLTqdtsI5sSsHyk+QxAMBxhbbewdDbTni0HRV+SPN/v3LlKZ
	 GHXDtU2s0ozSzx8gtEm/COGByo4yoYK4O2Yd4WSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 073/515] riscv: dts: thead: Add APB clocks for TH1520 GMACs
Date: Mon, 18 Aug 2025 14:40:59 +0200
Message-ID: <20250818124501.197429454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit a7f75e2883c4bd57b12c3be61bb926929adad9c0 ]

Describe perisys-apb4-hclk as the APB clock for TH1520 SoC, which is
essential for accessing GMAC glue registers.

Fixes: 7e756671a664 ("riscv: dts: thead: Add TH1520 ethernet nodes")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Tested-by: Drew Fustini <fustini@kernel.org>
Link: https://patch.msgid.link/20250808093655.48074-5-ziyao@disroot.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/thead/th1520.dtsi | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/boot/dts/thead/th1520.dtsi b/arch/riscv/boot/dts/thead/th1520.dtsi
index 527336417765..0aae4e6a5b33 100644
--- a/arch/riscv/boot/dts/thead/th1520.dtsi
+++ b/arch/riscv/boot/dts/thead/th1520.dtsi
@@ -286,8 +286,9 @@ gmac1: ethernet@ffe7060000 {
 			reg-names = "dwmac", "apb";
 			interrupts = <67 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "macirq";
-			clocks = <&clk CLK_GMAC_AXI>, <&clk CLK_GMAC1>;
-			clock-names = "stmmaceth", "pclk";
+			clocks = <&clk CLK_GMAC_AXI>, <&clk CLK_GMAC1>,
+				 <&clk CLK_PERISYS_APB4_HCLK>;
+			clock-names = "stmmaceth", "pclk", "apb";
 			snps,pbl = <32>;
 			snps,fixed-burst;
 			snps,multicast-filter-bins = <64>;
@@ -308,8 +309,9 @@ gmac0: ethernet@ffe7070000 {
 			reg-names = "dwmac", "apb";
 			interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "macirq";
-			clocks = <&clk CLK_GMAC_AXI>, <&clk CLK_GMAC0>;
-			clock-names = "stmmaceth", "pclk";
+			clocks = <&clk CLK_GMAC_AXI>, <&clk CLK_GMAC0>,
+				 <&clk CLK_PERISYS_APB4_HCLK>;
+			clock-names = "stmmaceth", "pclk", "apb";
 			snps,pbl = <32>;
 			snps,fixed-burst;
 			snps,multicast-filter-bins = <64>;
-- 
2.50.1



