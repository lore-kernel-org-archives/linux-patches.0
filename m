Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF9352016;
	Wed, 20 May 2026 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295735; cv=none; b=MPcQadgV3lIaO4IhfpqtfK+eMrHu5g9NsRuwPs4m4r+nV1IwlsSRb2qHDPCF1oBvb/ac8WBx7sbzKMynCwZ0grjLrLgcYDXPr6Iixv9Ewp+nwf2gVbAU8DM/9cEZ+isT0dJ/2x/+9lHaMnXInlrOyQlale0dmMkVu1L3GQmN3zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295735; c=relaxed/simple;
	bh=/FXsVzaTqngRSJtl/ug6dYBalb+WkULIIMkNQQdu7DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuKzPGXc1DsjZmmUwqT5CArfhaXGIMY7Joa1/CXUZjvzsFm1sjpDbxrAtXEkq9GcU5vnxPaD7A5rP0+5fBKBL06d4z7I+QVkEGGolTIM2B7umlYKWsUrDTojwYCdTIzh0LuQPBnwbj56mLC4lV/UG8vNzaiXsNIcca3aJ2gvjOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOl6Ugql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOl6Ugql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D551F000E9;
	Wed, 20 May 2026 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295734;
	bh=bCpcPlfsOeTB8Z3ll5No/6YZKjq9Kp7aFPvFyAOJRFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOl6Ugqlz9YWAHf3M786JJfH7AppTUg1WpynZ+oh9xL3lGkAQ1q/chXdDlyH2Q6si
	 UmTqWBQMxVIByjyUvzyxQjujXmahJmCT9J2o8uiqy8G/JBCmTzMTLoBJHZhF0jHvrS
	 ypLpIuw9Kn0chBrhFLRVe0urMmIbZziDtuH3hVr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0533/1146] arm64: dts: ti: k3-am62l3-evm: Disable MMC1 internal pulls on data pins
Date: Wed, 20 May 2026 18:13:03 +0200
Message-ID: <20260520162200.244170332@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 02532ba56362907b6aca3e8289c4a9247ef83325 ]

AM62L EVM has external 47K pullups on MMC1 DAT1-DAT3 pins [0].
Disable internal pullups on DAT1-DAT3 so that each line has a
single pullup source:
- with both pullups enabled, the effective parallel resistance on
  DAT1-3 (~24.2K) creates a ~2x mismatch vs DAT0 (47K external
  only). Removing internal pullups results in DAT1-3 matching DAT0 at 47K
- 47K external alone is within the recommended range for 1.8V
  signaling (10K min, 50K recommended max)
- both internal and external pullups enabled equals unnecessary power
  consumption

[0] https://www.ti.com/lit/zip/SPRCAL6

Fixes: 00fb4c73b67d ("arm64: dts: ti: k3-am62l: add initial reference board file")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260223233731.2690472-3-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62l3-evm.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts b/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
index cae04cce33736..bd876c68aa347 100644
--- a/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
@@ -272,9 +272,9 @@ mmc1_pins_default: mmc1-default-pins {
 			AM62LX_IOPAD(0x0230, PIN_INPUT, 0) /* (Y3) MMC1_CMD */
 			AM62LX_IOPAD(0x0228, PIN_OUTPUT, 0) /* (Y2) MMC1_CLK */
 			AM62LX_IOPAD(0x0224, PIN_INPUT, 0) /* (AA1) MMC1_DAT0 */
-			AM62LX_IOPAD(0x0220, PIN_INPUT_PULLUP, 0) /* (Y4) MMC1_DAT1 */
-			AM62LX_IOPAD(0x021c, PIN_INPUT_PULLUP, 0) /* (AA2) MMC1_DAT2 */
-			AM62LX_IOPAD(0x0218, PIN_INPUT_PULLUP, 0) /* (AB2) MMC1_DAT3 */
+			AM62LX_IOPAD(0x0220, PIN_INPUT, 0) /* (Y4) MMC1_DAT1 */
+			AM62LX_IOPAD(0x021c, PIN_INPUT, 0) /* (AA2) MMC1_DAT2 */
+			AM62LX_IOPAD(0x0218, PIN_INPUT, 0) /* (AB2) MMC1_DAT3 */
 			AM62LX_IOPAD(0x0234, PIN_INPUT, 0) /* (B6) MMC1_SDCD */
 		>;
 		bootph-all;
-- 
2.53.0



