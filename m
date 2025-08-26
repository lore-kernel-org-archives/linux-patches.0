Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476FA20330;
	Tue, 26 Aug 2025 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208320; cv=none; b=SXb0CCbxphEFMFDtYhBYx8W7dIcFAcXmQQWtKGaaV5dWl0zYWwGzO++brHFWZsU+Ptt2aUnRIU4W98pzjRiMSv4dHrvWxZw281YGxsDgfTl7/hQAtyaTGqGwOVccVl7YfSqOKvfWF4iap5sj0c/Dgemqx7ekS4zjukXGb6BzxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208320; c=relaxed/simple;
	bh=wuj/yY/VQQEPLNGznMR9CJSGrRifeYh9MJcuEVzsz0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3HGJPUXvVoo7f/PHMD8Wgn87KD+DIIvOHUvRGwSPtGhM04nfNzbbEXYdu5cJx8Q2iFiTdSPrfu+DnNFwsYRuhPoCDkj73gAHo+0w25FMsOtkZvwj8X/0Gy7OupQrZ5DWVEfCAMzEWAoSUlCXRf8ihKWCd/QJICSboEyy2H+QSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQf+rFTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQf+rFTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DAC4CEF1;
	Tue, 26 Aug 2025 11:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208320;
	bh=wuj/yY/VQQEPLNGznMR9CJSGrRifeYh9MJcuEVzsz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQf+rFTPq69DTxm+uLHQiUIya4qXJFaaRCo9QPxyC2GLLHR9feEDjk4qtxT3cJjFp
	 8ROwj4e4LWJ1mSlzLr4O3VTdqony7SGrDrj6mfkRfq+gpCzufIAO/x8CDaqWLBYL0d
	 Ro3qvdBy45jCAN2SNFODapKHHutKQrWLjdn0+G6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 039/322] arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support
Date: Tue, 26 Aug 2025 13:07:34 +0200
Message-ID: <20250826110916.331866911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

commit 265f70af805f33a0dfc90f50cc0f116f702c3811 upstream.

For eMMC, High Speed DDR mode is not supported [0], so remove
mmc-ddr-1_8v flag which adds the capability.

[0] https://www.ti.com/lit/gpn/am625

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250707191250.3953990-1-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -553,7 +553,6 @@
 		clocks = <&k3_clks 57 5>, <&k3_clks 57 6>;
 		clock-names = "clk_ahb", "clk_xin";
 		bus-width = <8>;
-		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
 		ti,clkbuf-sel = <0x7>;
 		ti,otap-del-sel-legacy = <0x0>;


