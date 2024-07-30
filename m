Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E55187FF2;
	Tue, 30 Jul 2024 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355759; cv=none; b=t+r66twXLLGoClQW+ZZoYfbffFzHQu9pG52Ps0wud/EJGQon0hA/wO0COHlYeLwDe4STv3gXH6uAqlgDpD91XxD6riq0tglOhXSjOqSNAlNl2KSBUx2Ek7A3YWFy/rQHhCc7TsMCGrc/T6ucKTWybcCufdw0CP2NkZbLTln4+TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355759; c=relaxed/simple;
	bh=cXzr0t3WgYOfA/+Z/Q4IFfC4nnuyVckZYYhhGXJgHGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaZ9mYIh8wr5zDxRdVCUPx0eXVe8+JT4I+UHq3TX10pC1hkFAk/ToIwUlB6ZAUjkLXhMJD1M3w2v8DRmzXTy1wYL5HNXePp1vphk3kaCZWu2AseeflqLa4aFJwpqk+w4+WgZN9zW8bKf8BDMtmCc4qOEbQ8hHrPolcSBCydkpHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBVuVl81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBVuVl81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93834C32782;
	Tue, 30 Jul 2024 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355759;
	bh=cXzr0t3WgYOfA/+Z/Q4IFfC4nnuyVckZYYhhGXJgHGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBVuVl81NerwUDF3KaBvvhqLzVg4e69NF6GW3I3Ia/KMtAqWmWwHj6y2dIzkCv7MM
	 RrCu+YK+0v7soozBM0KYSbLHy6r5JPmxeStA+oCgY7R092Mqo8sXkQCbE9COTcxfYo
	 7NhvYRRXWqnTE2rOaK8jRMBX79L9H1uC798NrqDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/809] arm64: dts: ti: k3-am62p5-sk: Fix pinmux for McASP1 TX
Date: Tue, 30 Jul 2024 17:39:22 +0200
Message-ID: <20240730151728.034971188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit e96e36ce1fdcf08a70e3f09cbe2da02b073c58ac ]

On SK-AM62P, McASP1 uses two pins for communicating with the codec over
I2S protocol. One of these pins (AXR0) is used for audio playback (TX)
so the direction of the pin should be OUTPUT.

Fixes: c00504ea42c0 ("arm64: dts: ti: k3-am62p5-sk: Updates for SK EVM")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-7-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
index 78d4d44e8bd4e..fb980d46e3041 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -207,7 +207,7 @@ main_mcasp1_pins_default: main-mcasp1-default-pins {
 		pinctrl-single,pins = <
 			AM62PX_IOPAD(0x0090, PIN_INPUT, 2) /* (U24) GPMC0_BE0n_CLE.MCASP1_ACLKX */
 			AM62PX_IOPAD(0x0098, PIN_INPUT, 2) /* (AA24) GPMC0_WAIT0.MCASP1_AFSX */
-			AM62PX_IOPAD(0x008c, PIN_INPUT, 2) /* (T25) GPMC0_WEn.MCASP1_AXR0 */
+			AM62PX_IOPAD(0x008c, PIN_OUTPUT, 2) /* (T25) GPMC0_WEn.MCASP1_AXR0 */
 			AM62PX_IOPAD(0x0084, PIN_INPUT, 2) /* (R25) GPMC0_ADVn_ALE.MCASP1_AXR2 */
 		>;
 	};
-- 
2.43.0



