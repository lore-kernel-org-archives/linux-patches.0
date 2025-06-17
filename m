Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F6828E8;
	Tue, 17 Jun 2025 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176499; cv=none; b=bLg3bnE/Oirz3em6wm/8E8HRGRBmANICTNDGSH28SP9jttEm3QsMvGRlMmfT78w+iHuDitTZo1UChlTaiThaIVMZw4Q3uQ6OYLSHnHjQnzgySL0G1qgbvEUwb9WAAIHCWQ2/T4O9la8bI59Pd2p48FkxoIluW0MSSv55o6ogcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176499; c=relaxed/simple;
	bh=CK/WWCXMNJmG5iD7DcpVpuxbloIUEDZtTV74cj3pPIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM7Ds32nQwF3f6PVDH3tGUZPL1MhI7FiZ01t9ae1HJJMsUt0xC0Qi8sQ3dgG1tU6pXAE9Fu3TnTlSxoBpFL2RTlluO9yyGmPp1X47Wq7fRrchKdZN/6GP8ymJByNXAH76LxmqomtQXB6cTrit3/7EtpkjVUIVgoiOyDV+EpG/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkEWz2L+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkEWz2L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8F3C4CEE3;
	Tue, 17 Jun 2025 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176495;
	bh=CK/WWCXMNJmG5iD7DcpVpuxbloIUEDZtTV74cj3pPIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkEWz2L+klyKBALhGI6dpXwp+iBLqSXHcEeNGJDaN4ZJC3/NePKeE5cB3eIXyB2Bb
	 qiWMJTR9JajPl2I+iTUe15oKZj6iE19YrpA/7u+23V8SVJ+4tkeO89EI/y+Ob0nvhK
	 4c163cKL8sER8G2RBbpC0aw/gyUVyQ2BauOZf+kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/356] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Tue, 17 Jun 2025 17:26:38 +0200
Message-ID: <20250617152349.581501167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9c5de448351e9..0523bd0da80c7 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -448,6 +448,8 @@ sdhci0: mmc@4f80000 {
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



