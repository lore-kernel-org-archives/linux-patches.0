Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B773BF2E7;
	Thu, 15 Jan 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496550; cv=none; b=KgrviJIj8g/kBlcUFbGC3AkAVAlrIxqMDShZqzn3SRS3f1PhCyhPigYmQqXZETSGqcU8RCnTZyfSfa9dsXXg9DSBB1MwGVE1VLmxPj1D/0n3D+KFAbrIATuPy/oOe+JbDTkbs03uYRlvYp9Wsdzt8e/bcnAn/Pl1csaypQtidg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496550; c=relaxed/simple;
	bh=AKriqnetDojCNaZelgQfDw6QToRkj2BtodAN4Lf8JNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i75KNKAvuliyVsOCChZ2MXQ+WlLC9036rugrfBC8wHebJi3xBv0pMmVlnFPDc563DP/ohUCd375D2loAmLzMsFpxmh0HHtFQErHyyR2bCKGqR1APps9IWdBmNqmfApYa2t+VkiqxdmsYhchp05dP3ePr2F4zfQ4CcJWpYLFzm4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpstO+6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpstO+6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286A0C19422;
	Thu, 15 Jan 2026 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496549;
	bh=AKriqnetDojCNaZelgQfDw6QToRkj2BtodAN4Lf8JNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpstO+6lAfQHEH1nGTpw3UT7c4vVAK3krKHBtleEI9I/yO0uGt3bB8tzFIOngxw/j
	 A5BJ1GisYdhWzcb5DbkmdaFsMDYDkY5/zHJ3Kpy1kNRmhP0ryfFTap682fkRkDh2q9
	 i9yKtrRXz/zmzGPMM+cG1eqE1h1Roh1vI4ZJTDbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/119] arm64: dts: ti: k3-am62-lp-sk-nand: Rename pinctrls to fix schema warnings
Date: Thu, 15 Jan 2026 17:47:46 +0100
Message-ID: <20260115164153.801434519@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit cf5e8adebe77917a4cc95e43e461cdbd857591ce ]

Rename pinctrl nodes to comply with naming conventions required by
pinctrl-single schema.

Fixes: e569152274fec ("arm64: dts: ti: am62-lp-sk: Add overlay for NAND expansion card")
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20251127122733.2523367-3-w.egorov@phytec.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso b/arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso
index 173ac60723b64..b4daa674eaa1e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am62-lp-sk-nand.dtso
@@ -14,7 +14,7 @@
 };
 
 &main_pmx0 {
-	gpmc0_pins_default: gpmc0-pins-default {
+	gpmc0_pins_default: gpmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x003c, PIN_INPUT, 0) /* (K19) GPMC0_AD0 */
 			AM62X_IOPAD(0x0040, PIN_INPUT, 0) /* (L19) GPMC0_AD1 */
-- 
2.51.0



