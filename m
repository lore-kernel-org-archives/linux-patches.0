Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9F51ACEDA;
	Mon, 23 Jun 2025 21:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712916; cv=none; b=M0u9qTVr29T7s+PeP3RLwyLLCjm5BbU/qLZOcsRV/h1QG6abvwVbOgoaLtDQxou54KFX4TWduKpRltrjfTlxaLLxvm1QPpIISUwl5GealPe9sJIkqaUPyUKTCvcs7sqNkw9Qgt/BG1hOX2OmhjxeaV+gXd7fDBKRN/1msSbIlvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712916; c=relaxed/simple;
	bh=oHBHhDDgJLIwNP0T4wX9BmFRBUwLSXwQsSmH2bkLD3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkApF7lJxlz8+ZChn8xyvyY3vmFAimThXKUmiiPkeLmfjBNrO6I1gIVxlZMM6mukC/P4XO2Qy2sdyWVHtUk0xwo218gjR6ObpYHdkQgs+eVtUFLUE6IOn8D0IncYwXudfQFsKe23VIJU7L7NgW4pqf6ax5XXObaHgAusDrWGxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPG+50v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPG+50v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E8C4CEEA;
	Mon, 23 Jun 2025 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712916;
	bh=oHBHhDDgJLIwNP0T4wX9BmFRBUwLSXwQsSmH2bkLD3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPG+50v1bsajxJz4eZ3HV1bvSrWePIWlZf8iw4ex3YxXkqFEkbAsAbx8DBhBJ7N7H
	 ZQhI602FCarJl68/vdFK8+RdhLK5XeZ3xpoQmWpfesvVvq3n4I0NxE5xDHWkiIsVCN
	 YjwuLw/7lq8Ksyu5s5DtP+nCC1vCcPyHvnDvIp74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/355] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Mon, 23 Jun 2025 15:05:13 +0200
Message-ID: <20250623130630.130894371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit f55c9f087cc2e2252d44ffd9d58def2066fc176e ]

For am65x, add missing ITAPDLYSEL values for Default Speed and High
Speed SDR modes to sdhci0 node according to the device datasheet [0].

[0] https://www.ti.com/lit/gpn/am6548

Fixes: eac99d38f861 ("arm64: dts: ti: k3-am654-main: Update otap-del-sel values")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://lore.kernel.org/r/20250429173009.33994-1-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index ec7b22fae7fd3..ec7d444b228d1 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -280,6 +280,8 @@ sdhci0: sdhci@4f80000 {
 		ti,otap-del-sel-ddr50 = <0x5>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
+		ti,itap-del-sel-legacy = <0xa>;
+		ti,itap-del-sel-mmc-hs = <0x1>;
 		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 	};
-- 
2.39.5



