Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1831B24E4AF;
	Mon, 13 Apr 2026 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096731; cv=none; b=RS7ToyqnSnU27qXqkA0UuKtgeN+eOMB7/EhUBFJCASEtzGdG8k5+kY409aIc1t2i5cvLJtPOHQTFUdLJwzz89hmN60fsfWN7W290ZiukL4S2AZLMHyKCiAitvAOo8VquL/Fg1g7hiYnMLYv6AGnigvlggY+opPPUQK53QFzsv5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096731; c=relaxed/simple;
	bh=A6L2uBe7DcWg/NziCIN7B7R7afWvSL4cwYtLwnhLqMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6w4qP3rBq+h77w4+hZnClowuuOtCQbroErB2wdx3pHCPNd8sitwnOFbLlYqzQOt7chsZJNPzvbq6q9i5E/r76Cz4pQNGVEeRoz7+2+b8ZPlFD3JZi1qcpCDbgBusYjgKKSktWh9h0CeDE9g8ciY+9npAb7oUhM7ns4d3om6I2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6pY9Aqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6pY9Aqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65126C2BCAF;
	Mon, 13 Apr 2026 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096730;
	bh=A6L2uBe7DcWg/NziCIN7B7R7afWvSL4cwYtLwnhLqMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6pY9Aqhj2Kz0nG7eE9YWtwQDS9qk9eWYw5K2Y+zD7LEXX8h6Lnv3Do9vKQVI9024
	 FpTfZoYkVR5h25rUawJ98ij7OQuhqq2h1iWKQQw1tOvS+Qm4ZYuoDka4UKgKd8erIN
	 ZX8SH7byG6O4Rk3KEg4j9ZTJtN0W5W9gojKXhCi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.12 40/70] arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges
Date: Mon, 13 Apr 2026 18:00:35 +0200
Message-ID: <20260413155729.676559359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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
@@ -122,6 +122,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0xf0000000 0x10000000>;
+		dma-ranges = <0x0 0x0 0x0 0x40000000>;
 
 		crg: clock-reset-controller@8a22000 {
 			compatible = "hisilicon,hi3798cv200-crg", "syscon", "simple-mfd";


