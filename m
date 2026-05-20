Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CE9312825;
	Wed, 20 May 2026 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298456; cv=none; b=VSmHw5b85cpmXgK5TQ1NEb9pPBdv7IejnllMZVu+lDoqU+lzCD2nbERNPJtLM8/NWuiB/wG2fb2Jo9c3HM04swJ39escsCZtU/x/D+uIaTqvNQhli0A5cgl4b7tBUTCQrBNDdj2CX7R2FeSOYaZVyYHE5R3Tig2AVEfSThjOMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298456; c=relaxed/simple;
	bh=eCSeVju3pQ0Wf2QgRdkB4t7ERMBJgaVX80syj/9SI50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZjVMl1TImbyaqnrkVUckfwYhkjVCT9nXvvnAiDdfZuVWVFCTAhx1zBnAT3KOrglSB0FaNUvO3Dp+vYd8Y7LajzXXxjrjLwb0oCzi7IoxJVnvAQ6IOnAotUaKr7rZCSRhqDqUcdlS66Oio1CemY2vZwnYYoH6GvjnNDDAJjVdeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqxtU4Yz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqxtU4Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05711F000E9;
	Wed, 20 May 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298455;
	bh=CBFEVCwjgScy3m+scWSQl2XbMsXTEQnfdIaMmn+OzmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqxtU4Yz1VDhwY16zUUeFbpt/8w7fnKkAcNkOUBuQ1F/E/pPmLgeM8AFewmdzPcyN
	 BVcoHypwv+yjbFz3xKQXQOH+wi/JCv4v/uXVytBFAIdCXIQ02cNCTczNeZQN7gWsnm
	 OVmHk38ZkhvLwvqXFnZ3x92a22nC2jwrw7RNysT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annette Kobou <annette.kobou@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 417/957] arm64: dts: imx8mp-kontron: Fix boot order for PMIC and RTC
Date: Wed, 20 May 2026 18:15:00 +0200
Message-ID: <20260520162143.565944673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annette Kobou <annette.kobou@kontron.de>

[ Upstream commit 130d90114c5255a7a729158da8fd8298a02017f1 ]

The PMIC provides a level-shifter for the I2C lines to the RTC. As the
level shifter needs to be enabled before the RTC can be accessed, make sure
that the PMIC driver is probed first.

As the PMIC also provides the supply voltage for the RTC through the 3.3V
regulator, simply express this in the DT to create the required dependency.

Avoid sporadic boot hangs that occurred when the RTC was accessed before
the level-shifter was enabled.

Fixes: 946ab10e3f40f ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Annette Kobou <annette.kobou@kontron.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
index b97bfeb1c30f8..bc1a261bb000e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
@@ -330,6 +330,12 @@ rv3028: rtc@52 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_rtc>;
 		interrupts-extended = <&gpio3 24 IRQ_TYPE_LEVEL_LOW>;
+		/*
+		 * While specifying the vdd-supply is normally not strictly necessary,
+		 * here it also makes sure that the PMIC driver enables the level-
+		 * shifter for the RTC before the RTC is probed.
+		 */
+		vdd-supply = <&reg_vdd_3v3>;
 	};
 };
 
-- 
2.53.0



