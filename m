Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE924DCF6;
	Mon, 13 Apr 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097047; cv=none; b=GZp0v5j75yb74pqyIkfnL8gHxt/kEwXWOlJl8qQTkj8BA5tkRSYuG07hDAvi6J3wACDglpsZ+xaupVDQRLkEOAeqmZyGAFPMvRvpgj1fI0wBTA/fm0EQQgdu3NWzEHBSdZQu70CDkgr/Mmc2VGK36UxKPNnORCrWya3g+ZgwjhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097047; c=relaxed/simple;
	bh=ewJgxeIXcbn59i3zpPux0F2zb2MDea5UKolcqFPq5Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djSPg9pAD3V2xPHhcG/mYA81Mf5AbiEW0nE9MLIQXpAJhgADJGKSpeMT+cvwb6rRo32cOAcBVC7yGjrTZFfob1jDViDYiiVSkPfGwjK0Gvs0aNw40w6JOCH6gfKpXO06+k7omS0+gcaLpmtDbI2lR0RdKleyc+CsBBmYVyzGOhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmqQWvY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmqQWvY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C602C2BCAF;
	Mon, 13 Apr 2026 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097046;
	bh=ewJgxeIXcbn59i3zpPux0F2zb2MDea5UKolcqFPq5Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmqQWvY5lK/L5+6YHljQEI3T9uSdlsDZaz7+WJzEzthp0BjqftE6dJgGkJhpPtK9K
	 RfGEwZAtNYs07f2dPbhHfI3jtrjlTiqAsAl2FYMuLAY8vMeF2k4B5OcWq6eQg3wv8V
	 H/a7mS+w1BP/c6Hsp/IYnxYlB0N54X7Kc1+uUrQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.1 41/55] arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges
Date: Mon, 13 Apr 2026 18:01:15 +0200
Message-ID: <20260413155726.367830949@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawnguo@kernel.org>

commit 1af997cad473d505248df6d9577183bb91f69670 upstream.

Reboot starts failing on Poplar since commit 8424ecdde7df ("arm64: mm:
Set ZONE_DMA size based on devicetree's dma-ranges"), which effectively
changes zone_dma_bits from 30 to 32 for arm64 platforms that do not
properly define dma-ranges in device tree.  It's unclear how Poplar reboot
gets broken by this change exactly, but a dma-ranges limiting zone_dma to
the first 1 GB fixes the regression.

Fixes: 2f20182ed670 ("arm64: dts: hisilicon: add dts files for hi3798cv200-poplar board")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
@@ -81,6 +81,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0xf0000000 0x10000000>;
+		dma-ranges = <0x0 0x0 0x0 0x40000000>;
 
 		crg: clock-reset-controller@8a22000 {
 			compatible = "hisilicon,hi3798cv200-crg", "syscon", "simple-mfd";


