Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A978184540;
	Tue, 26 Aug 2025 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213846; cv=none; b=GV4ZrKklbxpd1ZAolV/CQl/QJjSzfrm7MLbjicwRHB18pLLeJ4RBy9Cx8bdG+gLjXxuh9QsxanisqIl3iXXuvC7wg+uKwhAC8brc4O71oIIHrQKZv7Dxs12dvOYZSCQCG9teJThmhG+g6LaY4EbT72hlgPfCUg2s8uL3//QPCAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213846; c=relaxed/simple;
	bh=i+7Goe3w9kAOQJOIQnfUPSjfjTslwBjlk6/KU20RnCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/86p9UY+Fn8iyB7VeK7oKBBM/3yIuWmo0jhGosYyJZIK9B89P5eLqcO4Zpi3/Ph3dLVw+OCXhSBw6YWe8jYvR3xYa782+YLLLqmIi/eOddI+efJJ/ukL1K0EfgtbGhr5QTwGbDI30+icwQTUwJEtfxMHOHehBDIQfEmU4Fbgy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVXuGg76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVXuGg76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3176C4CEF1;
	Tue, 26 Aug 2025 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213846;
	bh=i+7Goe3w9kAOQJOIQnfUPSjfjTslwBjlk6/KU20RnCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVXuGg76gNRfXsFrPGBNfG7wKTmOwjJCxjqPlTSbnIhJ67PMH/CZX/8JUiCPR4K3P
	 pj3bi9dNm9NuRcTgdSUCcQgmiZeCIZchobk9BcReAy0/8E0bqxnSVUP7xD+IE/VUwE
	 lgE0ZlQPKMOiXPlZSJje1cjiZ756fxXOCBLDdqFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/587] arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support
Date: Tue, 26 Aug 2025 13:10:50 +0200
Message-ID: <20250826111005.731037618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

[ Upstream commit 265f70af805f33a0dfc90f50cc0f116f702c3811 ]

For eMMC, High Speed DDR mode is not supported [0], so remove
mmc-ddr-1_8v flag which adds the capability.

[0] https://www.ti.com/lit/gpn/am625

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250707191250.3953990-1-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
[ adapted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -531,7 +531,6 @@
 		clock-names = "clk_ahb", "clk_xin";
 		assigned-clocks = <&k3_clks 57 6>;
 		assigned-clock-parents = <&k3_clks 57 8>;
-		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
 		ti,trm-icp = <0x2>;
 		bus-width = <8>;


