Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF40288C01;
	Tue, 22 Jul 2025 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192735; cv=none; b=h9qo+Af/pAAmMHg6Ni5mzBPLAvKdxUrb2kVlXXA8/Mc9rUZjDjDgX7w/Xm8oobozcm9ZRDBOPNJGOu6WBI72vbsuRF8R42ItUfhzNEY+x0lNUe6Ft5z2HVDVnic94/Ui/xtimWDtzHfdm1+KUAXPy6+1MLKclYGXCiIs8NagvIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192735; c=relaxed/simple;
	bh=mbGIytzGu8stPNHRxTRguXGs8GJeUaUK2BG2BQvbV9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMWm8jXxEAeZlV4OdDuqyLzDtKLobgU7ECZ84rYoUCPj0e5PUf4uqGDAQkUHfg6Z5QbvJmQX5hfkVkOjRjqGdHv432hojU9gj8ZRPEiR4dZBWIPOW5Q6kRq87BwETcaBFsjeNxib5lNtEnucROl8854rQhUNSRtn0PE1CLSZsMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpugiUIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpugiUIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F078C4CEEB;
	Tue, 22 Jul 2025 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192735;
	bh=mbGIytzGu8stPNHRxTRguXGs8GJeUaUK2BG2BQvbV9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpugiUIulrP5n590/HMeME6EH4RHCZNsSjAiiP89W4v+wK6N9fcNthYC9j4qpy+dj
	 vl5txE1mCSeKu/1QPDGmpv8J7M5g9YsmM7PAJR92DVjifhdE1DjUKKh6/94W9rRfYf
	 uIYnO2eQgq/T/4vlWdlkDtnfJ5IKKdQytxWhFE54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meng Li <Meng.Li@windriver.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 042/158] arm64: dts: add big-endian property back into watchdog node
Date: Tue, 22 Jul 2025 15:43:46 +0200
Message-ID: <20250722134342.310377980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meng Li <Meng.Li@windriver.com>

commit 720fd1cbc0a0f3acdb26aedb3092ab10fe05e7ae upstream.

Watchdog doesn't work on NXP ls1046ardb board because in commit
7c8ffc5555cb("arm64: dts: layerscape: remove big-endian for mmc nodes"),
it intended to remove the big-endian from mmc node, but the big-endian of
watchdog node is also removed by accident. So, add watchdog big-endian
property back.

In addition, add compatible string fsl,ls1046a-wdt, which allow big-endian
property.

Fixes: 7c8ffc5555cb ("arm64: dts: layerscape: remove big-endian for mmc nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 0baf256b4400..983b2f0e8797 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -687,11 +687,12 @@ lpuart5: serial@29a0000 {
 		};
 
 		wdog0: watchdog@2ad0000 {
-			compatible = "fsl,imx21-wdt";
+			compatible = "fsl,ls1046a-wdt", "fsl,imx21-wdt";
 			reg = <0x0 0x2ad0000 0x0 0x10000>;
 			interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(2)>;
+			big-endian;
 		};
 
 		edma0: dma-controller@2c00000 {
-- 
2.50.1



