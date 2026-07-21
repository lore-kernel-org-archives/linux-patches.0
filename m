Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB1446A5EC;
	Tue, 21 Jul 2026 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648548; cv=none; b=ChEEbQytINm+5FeZH/13FKDXNx+cWpd6eyOnFbGDHOBZFrDxfZpDQyDIcWOZT3bHtPddVPMudNE2pVYyTjybmBV6F9z7lFvN/aUUdz7PuOvW+WHjGClW8z5POLxaCG3aEGXQaGa7WKB2Zz3laWn9nvyHf2wOKXp6KHw4i4Zdt0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648548; c=relaxed/simple;
	bh=dNJ8JW3ziyDn2LhKs2u+SgUIs4KwDIO6EU8UDf8p+do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4mhCUYXMmViK6vntbfc9XpOata/v+LpZFZmIN9b8CJ8Y2jIklo0VAVRTNqZrqN5DHA/EwL6fLPTwL067i7N5pexJ2xle3gjHFu4+qaEryJlUZgDXdxiXdua5cff+xS4P+tzLMG0SGjHUkpDh50wZVjmCIwniQA/rq+QaO6BZwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XdBbT0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XdBbT0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD771F000E9;
	Tue, 21 Jul 2026 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648547;
	bh=JnS4Z/elweJryhD5rdEBrEB9lXWmvvoP7gmlEv0khZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XdBbT0MKINO53EL+zwEWBYnZebsbqFeSsLMqAYmLHTSsUAdDxu/iNzIlLSzLL6sh
	 PFLD47Ng58Kr0/xEuQR/FWpM/K392JIYRZw2vBZNetSOUcxMpp5PNofkCoFlf6IWIf
	 LXYLPUPm5BOt7NyEoX4/nKuB1WypDlznxNj2TEMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0241/2077] arm64: dts: imx95-19x19-evk: Fix PCIe EP vpcie-supply
Date: Tue, 21 Jul 2026 16:58:34 +0200
Message-ID: <20260721152558.360917026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 041fd838fabba8..49400bc9ba919b 100644
--- a/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-19x19-evk.dts
@@ -550,7 +550,7 @@ &pcie0 {
 &pcie0_ep {
 	pinctrl-0 = <&pinctrl_pcie0>;
 	pinctrl-names = "default";
-	vpcie-supply = <&reg_pcie0>;
+	vpcie-supply = <&reg_m2_pwr>;
 	status = "disabled";
 };
 
-- 
2.53.0



