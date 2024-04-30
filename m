Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C4512D1F4;
	Tue, 30 Apr 2024 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474914; cv=none; b=cnj2krKoTqYOq+Y78h2yx9iwAXv2yL4pkGjX5kpg0ZJOwoWbS/Tig/SH8w5yXTNEItZiXio9ozowN6BMNEgvvWXdrRWoipsT89BsZRfw/7rCdWMdTodbYwiKDmj5ywtganAMOuDPTDLY1O34avKLbTmyKY4dMBs2Az4galPY+Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474914; c=relaxed/simple;
	bh=DzJuiWV+KrDI7Dr3M/c+4/xaYbozVuC1Au4h3ULn/3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq5VBmnIS8o8nrMA4mKNyMdPgH5aqPbXK8tkvjjFisT/RFies9HvHDFGXKwlqRFBpo+uGfvhQg2Cb1PcJo9t5HcU6MO/tp88WbW0+84py94WvA+lHVmP5QHnnUaq8+qmiy74sdLcaFtWpr59q93REPu3bPZryZoY3ORTyYCYYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXGlRNDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXGlRNDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC1C2BBFC;
	Tue, 30 Apr 2024 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474914;
	bh=DzJuiWV+KrDI7Dr3M/c+4/xaYbozVuC1Au4h3ULn/3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXGlRNDhsTg3A5RH7LLJOIILz+m722e65kBzskom44NDOg/loCH7dyyxtrskwdDQi
	 AZM70ld/KNYIfHOlQnmEG4upAfNtNlQLIYDR2Wtp6eArwWiXh/SL4sUbjnY0dCL1K5
	 ns1Uqn5w0Hn7d1MppN+GkMQUJrnK/y3Vs4Q3JOq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/138] arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:18 +0200
Message-ID: <20240430103051.576658362@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aaa042fba1ebf..5455bdc2df841 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -430,6 +430,11 @@
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



