Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AD51A83E7;
	Wed,  5 Feb 2025 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766473; cv=none; b=uGJQsaAmqp3dibcH7EYMmneW2iT4f6CED8CC/gNIssJfdsBrlV47QfT0ixOt3K3MKFt8P//N9BrhKaVq7D/w0OX6axc46jsUm1uG3bqQ5xdVjRN8a2MFkSTZ2rP4eLX4XyhZdb18U5E1D1wc1klLGueCL4MoNYGzGfobCH+qgu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766473; c=relaxed/simple;
	bh=QMl5L3R6E6pwPElOaW62Fgg0cnYmZFv8q3WLmiQMH2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpoJXrHW9DXTInjNZOxiM8/mMn47rCFnGIDB5lGT0TwJIDy9yXBMzDy9nBpDyprQY5W65I+Y0OjA1KmhPa6/tA7t6E5S6HYEqo2QpGpuvttALCAHUDgKBycYVqpphUW5CaPfbYIYDzDwMB61jb/9R1GWMgAwTU09+GdKcYj4yZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMlxMDtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMlxMDtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A84C4CED6;
	Wed,  5 Feb 2025 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766473;
	bh=QMl5L3R6E6pwPElOaW62Fgg0cnYmZFv8q3WLmiQMH2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMlxMDtNhVqfuUiNI8096uRmxFo51o7aHcZ9LquNwGnZGhA0g8uSkGoKxGrAN5fIg
	 u/oJhTjpAjkvdcBqoLHVJdZuV+X8ArnQgNXrjOBpP4TdPu38EQ1eavKfh3JXvw165+
	 KwY8JRJlISZwHCkDHbrQl2Z3UFUj/nVln6qfbpvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mamta Shukla <mamta.shukla@leica-geosystems.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/590] arm: dts: socfpga: use reset-name "stmmaceth-ocp" instead of "ahb"
Date: Wed,  5 Feb 2025 14:41:22 +0100
Message-ID: <20250205134507.784752605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Mamta Shukla <mamta.shukla@leica-geosystems.com>

[ Upstream commit 62a40a0d5634834790f7166ab592be247390d857 ]

The ahb reset is deasserted in probe before first register access, while the
stmmacheth-ocp reset needs to be asserted every time before changing the phy
mode in Arria10[1].

Changed in Upstream to "ahb"(331085a423b  arm64: dts: socfpga: change the
reset-name of "stmmaceth-ocp" to "ahb" ).This change was intended for arm64
socfpga and it is not applicable to Arria10.

Further with STMMAC-SELFTEST Driver enabled, ethtool test also FAILS.
$ ethtool -t eth0
[  322.946709] socfpga-dwmac ff800000.ethernet eth0: entered promiscuous mode
[  323.374558] socfpga-dwmac ff800000.ethernet eth0: left promiscuous mode
The test result is FAIL
The test extra info:
 1. MAC Loopback                 0
 2. PHY Loopback                 -110
 3. MMC Counters                 -110
 4. EEE                          -95
 5. Hash Filter MC               0
 6. Perfect Filter UC            -110
 7. MC Filter                    -110
 8. UC Filter                    0
 9. Flow Control                 -110
10. RSS                          -95
11. VLAN Filtering               -95
12. VLAN Filtering (perf)        -95
13. Double VLAN Filter           -95
14. Double VLAN Filter (perf)    -95
15. Flexible RX Parser           -95
16. SA Insertion (desc)          -95
17. SA Replacement (desc)        -95
18. SA Insertion (reg)           -95
19. SA Replacement (reg)         -95
20. VLAN TX Insertion            -95
21. SVLAN TX Insertion           -95
22. L3 DA Filtering              -95
23. L3 SA Filtering              -95
24. L4 DA TCP Filtering          -95
25. L4 SA TCP Filtering          -95
26. L4 DA UDP Filtering          -95
27. L4 SA UDP Filtering          -95
28. ARP Offload                  -95
29. Jumbo Frame                  -110
30. Multichannel Jumbo           -95
31. Split Header                 -95
32. TBS (ETF Scheduler)          -95

[  324.881327] socfpga-dwmac ff800000.ethernet eth0: Link is Down
[  327.995360] socfpga-dwmac ff800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

Link:[1] https://www.intel.com/content/www/us/en/docs/programmable/683711/21-2/functional-description-of-the-emac.html
Fixes: 331085a423b ("arm64: dts: socfpga: change the reset-name of "stmmaceth-ocp" to "ahb")
Signed-off-by: Mamta Shukla <mamta.shukla@leica-geosystems.com>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/intel/socfpga/socfpga_arria10.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/intel/socfpga/socfpga_arria10.dtsi b/arch/arm/boot/dts/intel/socfpga/socfpga_arria10.dtsi
index 6b6e77596ffa8..b108265e9bde4 100644
--- a/arch/arm/boot/dts/intel/socfpga/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/intel/socfpga/socfpga_arria10.dtsi
@@ -440,7 +440,7 @@
 			clocks = <&l4_mp_clk>, <&peri_emac_ptp_clk>;
 			clock-names = "stmmaceth", "ptp_ref";
 			resets = <&rst EMAC0_RESET>, <&rst EMAC0_OCP_RESET>;
-			reset-names = "stmmaceth", "ahb";
+			reset-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
@@ -460,7 +460,7 @@
 			clocks = <&l4_mp_clk>, <&peri_emac_ptp_clk>;
 			clock-names = "stmmaceth", "ptp_ref";
 			resets = <&rst EMAC1_RESET>, <&rst EMAC1_OCP_RESET>;
-			reset-names = "stmmaceth", "ahb";
+			reset-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
@@ -480,7 +480,7 @@
 			clocks = <&l4_mp_clk>, <&peri_emac_ptp_clk>;
 			clock-names = "stmmaceth", "ptp_ref";
 			resets = <&rst EMAC2_RESET>, <&rst EMAC2_OCP_RESET>;
-			reset-names = "stmmaceth", "ahb";
+			reset-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
-- 
2.39.5



