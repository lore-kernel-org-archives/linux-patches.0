Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D3151988;
	Wed,  5 Feb 2025 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766251; cv=none; b=nPBUq//Py3EkR5OutO45GCR0PPjgyo2PpN3H5AZcq0RQNa3ThdGlmiUqeX60e4aTyskwQ6Icar3V34CXn9ze7QSlG/zI4HiZ4Bf2FFoNF195mCegauj7L5INN1/vomvLSGE61t3aq584lkgLNlrd0a3OWHnPwwDZKqii9/Hu6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766251; c=relaxed/simple;
	bh=Y6WdemQ/SdDRXEotXfhi04jmqjMQLl4ZrdxoRVE3JuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eeaIz2o8tJPYcVxpUAhiQli1cKzBFh7rH2Fo13IYJ2O6M5DtKx9jaAQ3Hlg/6lq3rasHZpXcMNqNd9GSDhaP4aI4gc954/lJB+lss8YzfgrT+K/tMqpzgOyyEUofwAnKa3YUPKhyVO59VNw4QTbZoXjTZzT8Xt9i9/DXigM9+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck5zfivt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck5zfivt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0679FC4CED1;
	Wed,  5 Feb 2025 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766251;
	bh=Y6WdemQ/SdDRXEotXfhi04jmqjMQLl4ZrdxoRVE3JuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck5zfivtyFQ/ApCfG5Ny2sgRz5cdE4YxVabJBubisfUTmcDopKwO1+EjtcscHS+9r
	 UIxQv3dKmeoWvfHhX+mRk/Lukdk6cWCUqOATottW+KiFqQrHzZ70/CIrn8ZoCQ1hTH
	 x3Wc5JoFiSRpSIk3As3qZdwjrNs+9pWRfn4aHktY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Macek <wmacek@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/590] arm64: dts: mediatek: mt8186: Move wakeup to MTU3 to get working suspend
Date: Wed,  5 Feb 2025 14:40:59 +0100
Message-ID: <20250205134506.909248054@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 253b4e96f5783fddede1b82274a7b4e0aa57d761 ]

The current DT has the wakeup-source and mediatek,syscon-wakeup
properties in the XHCI nodes, which configures USB wakeup after powering
down the XHCI hardware block. However, since the XHCI controller is
behind an MTU3 (USB3 DRD controller), the MTU3 only gets powered down
after USB wakeup has been configured, causing the system to detect a
wakeup, and results in broken suspend support as the system resumes
immediately.

Move the wakeup properties to the MTU3 nodes so that USB wakeup is only
enabled after the MTU3 has powered down.

With this change in place, it is possible to suspend and resume, and
also to wakeup through USB, as tested on the Google Steelix (Lenovo 300e
Yoga Chromebook Gen 4).

Fixes: f6c3e61c5486 ("arm64: dts: mediatek: mt8186: Add MTU3 nodes")
Reported-by: Wojciech Macek <wmacek@google.com>
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241106-mt8186-suspend-with-usb-wakeup-v1-1-07734a4c8236@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 148c332018b0d..ac34ba3afacb0 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -1570,6 +1570,8 @@
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
+			wakeup-source;
+			mediatek,syscon-wakeup = <&pericfg 0x420 2>;
 			status = "disabled";
 
 			usb_host0: usb@11200000 {
@@ -1583,8 +1585,6 @@
 					 <&infracfg_ao CLK_INFRA_AO_SSUSB_TOP_XHCI>;
 				clock-names = "sys_ck", "ref_ck", "mcu_ck", "dma_ck", "xhci_ck";
 				interrupts = <GIC_SPI 294 IRQ_TYPE_LEVEL_HIGH 0>;
-				mediatek,syscon-wakeup = <&pericfg 0x420 2>;
-				wakeup-source;
 				status = "disabled";
 			};
 		};
@@ -1636,6 +1636,8 @@
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
+			wakeup-source;
+			mediatek,syscon-wakeup = <&pericfg 0x424 2>;
 			status = "disabled";
 
 			usb_host1: usb@11280000 {
@@ -1649,8 +1651,6 @@
 					 <&infracfg_ao CLK_INFRA_AO_SSUSB_TOP_P1_XHCI>;
 				clock-names = "sys_ck", "ref_ck", "mcu_ck", "dma_ck","xhci_ck";
 				interrupts = <GIC_SPI 324 IRQ_TYPE_LEVEL_HIGH 0>;
-				mediatek,syscon-wakeup = <&pericfg 0x424 2>;
-				wakeup-source;
 				status = "disabled";
 			};
 		};
-- 
2.39.5



