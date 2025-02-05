Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38751151980;
	Wed,  5 Feb 2025 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764916; cv=none; b=bygCsAOHnou/YBp+v04EhZGcqWoocTqb5bVCsxudcFNyJzMcz71HpuG3OrEoljVkM+qnHyfu3/BIOvvbJDHZh+Be/o7PXlsTJv9vlQKz1T+jc7AkPFnbo/ydfbKRA7uT5eLfQGP1TjtCocNuaMVfOB86vqcP1D53HpJdVviSefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764916; c=relaxed/simple;
	bh=twmry58AA4L53e9jwZMl7WaX434biV6bS38CWGZ1yzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6D2NioQhZYtyCqR8asABVevvT9zXlqPUWIkcXEoW7USulf39NnDBO7MzfigkKHfPdcP8qnYj7pwYo2CFjf9q9VYhHBt1LSjTe+3GMkVr31lrFYviC0UXpbN7Bw7Ma2/NkHsat090Lbwlu8WBsI2rK969IEkoNdgyP5XaZJiPIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWuKBmhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWuKBmhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B106FC4CED1;
	Wed,  5 Feb 2025 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764916;
	bh=twmry58AA4L53e9jwZMl7WaX434biV6bS38CWGZ1yzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWuKBmhw3YtxaqCfAkmntP1E2HiS/+V0zFxtEpt4CFPVrteG/TEdEVEgF+rq0lG1+
	 fovGJWxSK3jK3bG2qmOeC9SvRG82ek1YzT4JaKtOJ0m4FuqO12/yGclfAKaqp6yk5R
	 Kc0uTzQ+3T77ZvAgjsWLDlnNamrgWEveZyDQOWpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mamta Shukla <mamta.shukla@leica-geosystems.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/393] arm: dts: socfpga: use reset-name "stmmaceth-ocp" instead of "ahb"
Date: Wed,  5 Feb 2025 14:42:14 +0100
Message-ID: <20250205134428.529625725@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f36063c57c7f2..72c55e5187ca8 100644
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



