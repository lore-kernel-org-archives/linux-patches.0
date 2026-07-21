Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF15326D44;
	Tue, 21 Jul 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655859; cv=none; b=n/Q53F1y4zrzqFQCDuLZ9pAYN1NT3SdETkEeFOc9GHyZYf3CJr78IoocGs7PVueUKNTjT3GdPL6WDlcLqvLSoA8PpN9jstZxQ5Y0lzHiMy0VafzdyS9FajnQDyop0Dez/PPu/3sT0uMcaXgLdr8eU1guoqZ7z36AlfbJczKdKc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655859; c=relaxed/simple;
	bh=eukcXXfe3Lqu5Nc+nwsh2aqvROS9hHz0wcvGC4WrkJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZrNzMf3lE8Sa3+NBhTPs2n1QVyhElLPuacAZZOBUunCwmjkWuskJ6yOh+Emhoa3Ydr2qxSS6ttlr6LixvQBfP/q4Uoa7PQfrq0L4f5ipqIMY7UalLk8w3j1mvqhpASCwWANdyUGvQniciJPN4tQF9NkkJpu0KrKSd8MdFcrAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2BdV4Kp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2BdV4Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48451F000E9;
	Tue, 21 Jul 2026 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655858;
	bh=FcrelptLZXvPEVcj1Z6ge+G4tsTcHhQKQdeWwUn2jwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2BdV4KpPg3O/2f2502bkX25bPZBfTB12Wu8slfh5o1zi1hKWHcT5i501JHfQH3XW
	 fGQeerIYeDLcBpsyS801eqf/6ikbPKX8t46D3ktTtv4JwrzxcnvIRbQE2GdSQzuILX
	 VMXRF4b6MnkPWZQTxuON/qqsqumvptx4Cscn2jd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0168/1611] arm64: dts: imx95-19x19-evk: Fix PCIe EP vpcie-supply
Date: Tue, 21 Jul 2026 17:04:44 +0200
Message-ID: <20260721152518.671077219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 596d0f9f4fefffbf783ab26cfa90cf50f5dd6bb0 ]

The vpcie-supply property should reference the regulator that controls
the actual M.2 power supply, not the W_DISABLE1# signal.
On imx95-19x19-evk:
- reg_pcie0 controls M.2 W_DISABLE1# signal
- reg_m2_pwr controls the actual M.2 power supply

Fix the vpcie-supply to use reg_m2_pwr for proper power control in
PCIe endpoint mode.

Fixes: 58bea81052d0 ("arm64: dts: imx95: add pcie1 ep overlay file and create pcie-ep dtb files")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts b/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
index 9f968feccef67c..513c52901e6cfe 100644
--- a/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
@@ -548,7 +548,7 @@ &pcie0 {
 &pcie0_ep {
 	pinctrl-0 = <&pinctrl_pcie0>;
 	pinctrl-names = "default";
-	vpcie-supply = <&reg_pcie0>;
+	vpcie-supply = <&reg_m2_pwr>;
 	status = "disabled";
 };
 
-- 
2.53.0



