Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D3336CE19;
	Wed, 20 May 2026 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300758; cv=none; b=ZU/vH4LML5dM9VZlvtNHgiTC9Z1lY5STJ1XyCTlCT+5XM9FrcdK42mxtR10np62BTVcE6DzzFsgqDVYYX2P5xzu3b7RvXj/eue/iVkupgq/YhTlSRjmzr9+G0SPAycLH6jAEDdqjwSFgLdcNw0d8cl1r9XxouRwuVQivkX3ozBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300758; c=relaxed/simple;
	bh=EkqvMHfHtRAo+QObK8rNbNu7LvsedYTZyBbpQN2uGJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oARB7fYTnHcMjuCjOOZp9b42DjZ1hsNK0zHu5Ru4U5oL3NXDcgStaJ2Z+aTDLtKow9B0OtfPwNIdp7g467QdHyVpa4oZQxdIsNzgvRN+wlKb1MhLnQKMmJQa9SLwSqs26G+iN5EBC9ICrXtPs3gWPhlQ4+CMjbTpQ6DZ3xqhFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sup8iy3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sup8iy3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA1F1F000E9;
	Wed, 20 May 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300756;
	bh=7bUQHXBX28MAi3oQonbQeFaDPraxnPHjsVuB2BZ8xXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sup8iy3p0LIkwLCEMHvUn9q1E1pVEnk/h0FjkuQy7vzS0R7N6EM9hCZTVJ6GNJV3K
	 yhOUbhJwsbqP7/1jXr8Bs5QNvoSTQ5iP48Kn8bVJiEaNIn7pV4BibWpADo+knkGTuk
	 xOlNUroqdHGzAjHx/R/MJWvh5fQNOy48ml2IGpos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/666] arm64: dts: ti: k3-am62-lp-sk: Enable internal pulls for MMC0 data pins
Date: Wed, 20 May 2026 18:18:25 +0200
Message-ID: <20260520162117.588251572@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit ee2a9d9c9e6c9643fb7e45febcaedfbc038e483a ]

AM62 LP SK board does not have external pullups on MMC0 DAT1-DAT7
pins [0]. Enable internal pullups on DAT1-DAT7 considering:
- without a host-side pullup, these lines rely solely on the eMMC
  device's internal pullup (R_int, 10-150K per JEDEC), which may
  exceed the recommended 50K max for 1.8V VCCQ
- JEDEC JESD84-B51 Table 200 requires host-side pullups (R_DAT,
  10K-100K) on all data lines to prevent bus floating

[0] https://www.ti.com/lit/zip/SPRR471

Fixes: a0b8da04153e ("arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260223233731.2690472-4-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
index 4609f366006e4..f050886e67c6d 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
@@ -80,13 +80,13 @@ main_mmc0_pins_default: main-mmc0-default-pins {
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (V3) MMC0_CMD */
 			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (Y1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (V2) MMC0_DAT0 */
-			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (V1) MMC0_DAT1 */
-			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (W2) MMC0_DAT2 */
-			AM62X_IOPAD(0x208, PIN_INPUT, 0) /* (W1) MMC0_DAT3 */
-			AM62X_IOPAD(0x204, PIN_INPUT, 0) /* (Y2) MMC0_DAT4 */
-			AM62X_IOPAD(0x200, PIN_INPUT, 0) /* (W3) MMC0_DAT5 */
-			AM62X_IOPAD(0x1fc, PIN_INPUT, 0) /* (W4) MMC0_DAT6 */
-			AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (V4) MMC0_DAT7 */
+			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (V1) MMC0_DAT1 */
+			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (W2) MMC0_DAT2 */
+			AM62X_IOPAD(0x208, PIN_INPUT_PULLUP, 0) /* (W1) MMC0_DAT3 */
+			AM62X_IOPAD(0x204, PIN_INPUT_PULLUP, 0) /* (Y2) MMC0_DAT4 */
+			AM62X_IOPAD(0x200, PIN_INPUT_PULLUP, 0) /* (W3) MMC0_DAT5 */
+			AM62X_IOPAD(0x1fc, PIN_INPUT_PULLUP, 0) /* (W4) MMC0_DAT6 */
+			AM62X_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (V4) MMC0_DAT7 */
 		>;
 	};
 
-- 
2.53.0



