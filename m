Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62357415B9D;
	Sat, 12 Sep 2026 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202251; cv=none; b=fX09bbrnoMsjRMCIfT7O3RzeF+YhwDwHL0ZfOZGkE5hCpi4fO5eI3a3/gu3PiXizahD73Q4Yril4kV+wdYqSkxSchldWhtTq48sPUV5JRDqF9JBAYXSRWhWqj3W/4yNyka+d+p0PLP7B/w6MuCll41f4jAc2myEZ0ENdUrD38dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202251; c=relaxed/simple;
	bh=UEGSEJt63q3Dkz0jGIJju1y9p75f4zoEMhMxNyxNVCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/Fr9Br4NHtiROyZfmC/APNzjxIAo2fjVM+wLnUCE+RgozbpfQzjbAx0u6LHxLHtCH+3rVjdNdxkR6Kg2eGVAKQUuhe2kucxyz0BLxjHmr/awdC3NYy4enSa+a10PYt2DP+n72xwW3/m4ey3P77EEVHM+BwW7b2DfDQyHLCnqQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PR6joASf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PR6joASf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341881F000FF;
	Sat, 12 Sep 2026 08:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202250;
	bh=RpqmAwkD/qc+6UZMkDX5H+rP7MF/g5sPHiccBYuDQKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PR6joASfelH38oJPVxmoz5yceJqBE2o1GR+aweEpbKWdp7cyjsSdnIMp0U2ArEVDe
	 h+QoeT+xNVlfKQFGqGN+gHXBYLAUTjdTVVI0A+hI7JdjYcKLzwELYABe4i6A+l6mwd
	 wOYaHidUdfEvou/fk4FbWGM3fbdD9RU4JI0phO5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1164/1815] arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node
Date: Sat, 12 Sep 2026 08:48:34 +0200
Message-ID: <20260912065716.340627963@linuxfoundation.org>
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 197df050a10fe216971b45a79f07195c86a02236 ]

MDIO clock index changed from 62:3 to 81:0 to match proper clock
definition in the SoC device tree. Clock Id 81:0 belongs to ICSSG0
core clock, where as 62 belongs to EQEP2 device.

See: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am64x/clocks.html

Fixes: c9087e3898a1d0 ("arm64: dts: ti: k3-am64-main: Add ICSSG nodes")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260706092229.82674-1-m-malladi@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index 1b1d3970888b8..a9a83781d40f5 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -1401,7 +1401,7 @@ tx_pru0_1: txpru@c000 {
 		icssg0_mdio: mdio@32400 {
 			compatible = "ti,davinci_mdio";
 			reg = <0x32400 0x100>;
-			clocks = <&k3_clks 62 3>;
+			clocks = <&k3_clks 81 0>;
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.53.0



