Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132628801;
	Tue, 30 Apr 2024 11:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475833; cv=none; b=gQ4vF7iTdP8ItuRZzBDkDcRbKjikl7aPPJIeJiLq7DbIDQ3P1zN0Tc6PnBtBrFLIVBGND3QPErbyj6FPrS3NP4PdkJr6Vtka2HSAdISGQ5Z/ZeP4pUHoj/jB7dUjSkzzKBF4M1b0gW+c/Y7VyuNc+wUBH5lEnEGfrMHCd94Lk+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475833; c=relaxed/simple;
	bh=g9WL2HxjbBW5Mo6W6slDYENElOmw2RZwwrCkaXG79Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/wjPssd0iv8sNiYQtxMVXjpdkOT1bRH+gZ7Ci7uzl0AidNc+JqQzaUbyX/rV8cIUjH5fbxBlSsiC9GVykY5FcQvHbctZ9gf7KfF1UDyD51vsgu7H7L9JUuCh0QPKDFuG+LI8uIaQZgpbxbWuwHQ9xAANPRsNJo2KqlMF71+3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um6oILc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um6oILc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79043C2BBFC;
	Tue, 30 Apr 2024 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475832;
	bh=g9WL2HxjbBW5Mo6W6slDYENElOmw2RZwwrCkaXG79Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um6oILc3B9RtuE/mqW661ERR1hmlOtaHFze/eSaWER0cGyBSsugH/c4LwXJISuJZY
	 IUv4WE71luhXGo0boPZx8aDQODMjy4/ANUN8soAGm7WmjxnVqQJZextUkU4US1VT/B
	 uXcSiNNadm+rsBn4LmluKtZZ1hO+EaFRCffkoxPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/80] arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:39 +0200
Message-ID: <20240430103043.625656293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit 945a7c8570916650a415757d15d83e0fa856a686 ]

The PCIE_WAKE# has a diode used as a level-shifter, and is used as an
input pin. While the SoC default is to enable the pull-up, the core
rk3399 pinconf for this pin opted for pull-none. So as to not disturb
the behaviour of other boards which may rely on pull-none instead of
pull-up, set the needed pull-up only for RK3399 Puma.

Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-2-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 14d343aae53f4..1c10baa25ffa3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -390,6 +390,11 @@
 	gpio1830-supply = <&vcc_1v8>;
 };
 
+&pcie_clkreqn_cpm {
+	rockchip,pins =
+		<2 RK_PD2 RK_FUNC_GPIO &pcfg_pull_up>;
+};
+
 &pinctrl {
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
-- 
2.43.0



