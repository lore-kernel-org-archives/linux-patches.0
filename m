Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D67D44C97;
	Sun,  1 Sep 2024 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208151; cv=none; b=jrxKtI85F6/u1IREyzPQlERWEo7Mg8vEuKqbmoXiCzTJI+X1N/4UQ304G6SetNzWXoiK1AvaaSi2BEG2+zgw5JPdSwdDzH/ubIykFZdjo1AbyO5LRzkbwQ6cb+Xh0sSoLl5WO2jihS0SVDyi+0GqyMkSq31R6owgy+Q381Omjoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208151; c=relaxed/simple;
	bh=fknHJlbWnLDZdg+DKfFNFATV6sMSowVD0fLk781H5Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdSItBagAhJhevs2hpkUg8rnxw7b+PPPjg5WacREpNRWTkx07c64H2eBXHUqCLDFBzhbdZ3PjG9LPyAHvgNsguyYFZ5oOpided4HLzdBeuK2JPgnGC81se7I3nURBCKfgmyVu5u/szJzYWRI5NAxrgfB0qGoJPSwvhriw+Km57Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vcwH6Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vcwH6Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495E8C4CEC3;
	Sun,  1 Sep 2024 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208150;
	bh=fknHJlbWnLDZdg+DKfFNFATV6sMSowVD0fLk781H5Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vcwH6HknUzHi2bcTQKnnc+WocFYekn7cV8kKbUtpFb25DjTCk9MP1LNVgSglSBgs
	 vUZOLVxp7YpkEcIm/dqaToqqhdxZ8p6nNvWBqBkzuFoiUw0fKoDqS/92lE1MS/olSk
	 PCAYCy1wvXFD+DEpEjczAjythof841m2ByK0fNyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 88/93] arm64: dts: imx93: add nvmem property for eqos
Date: Sun,  1 Sep 2024 18:17:15 +0200
Message-ID: <20240901160811.045560910@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0d4fbaffbdcaec3fce29445b00324f470ee403c4 ]

Add nvmem properties for eqos to get mac address.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 109f256285dd ("arm64: dts: imx93: update default value for snps,clk-csr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 1b7260d2a0fff..8ca5c7b6fbf03 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -810,6 +810,8 @@
 				assigned-clock-rates = <100000000>, <250000000>;
 				intf_mode = <&wakeupmix_gpr 0x28>;
 				snps,clk-csr = <0>;
+				nvmem-cells = <&eth_mac2>;
+				nvmem-cell-names = "mac-address";
 				status = "disabled";
 			};
 
@@ -895,6 +897,10 @@
 				reg = <0x4ec 0x6>;
 			};
 
+			eth_mac2: mac-address@4f2 {
+				reg = <0x4f2 0x6>;
+			};
+
 		};
 
 		s4muap: mailbox@47520000 {
-- 
2.43.0



