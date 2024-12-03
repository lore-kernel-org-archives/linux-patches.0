Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BB81FA16E;
	Tue,  3 Dec 2024 15:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240436; cv=none; b=PcLrhzYMF6G64NB6o8ZjLheSnZqyaYpOqK87sNmPa6sIIG4kxGh9gdoFjeFJ5DuWjsTw5XDYlfbrkxRd/uchJQoWTWuoQvaLWb6m3AJi5UZkJq8lAZRwufzVUwUNofGtMGoIOj6INOOZwaJAcdWeysf+OeEaD81aT6yO97cyr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240436; c=relaxed/simple;
	bh=x+tfE/y/w9YdRV1scpiahIEc1oq3vxi+xbKtQXCYCcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK9AMFYK/vxQJ6Z1tL/8bEabBwyXry6Kj9OlIc7kZr+x2Wh1CU0GwUkCE6uH//CBBeTS/Y1lA2a879sBsY7KiXZcrw/JD9G6Cb5Q7OFH0N3itaHpec1Du7FP3anun11ws2/QFhfIRPhFP0f238nL0lJPtk90yAi40On6QETxn18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7RhMUUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7RhMUUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C0C4CECF;
	Tue,  3 Dec 2024 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240435;
	bh=x+tfE/y/w9YdRV1scpiahIEc1oq3vxi+xbKtQXCYCcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7RhMUUHhuLSJXecRiuP6SlyVsyVcz+oi5m4yRYyctKO8R/xPwImcAGS+BUSC7CAP
	 LatLHOGp8t1X7eEGCHBAq7XGvl0neKT0S1CHL54cP1iEWv4uUFl9tySnpwfUit+TdP
	 +WguS5ZzrvaMXjIafChYN/lyNanbu9/Y0oRkbs7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/826] arm64: dts: mediatek: mt8188: Fix USB3 PHY port default status
Date: Tue,  3 Dec 2024 15:37:40 +0100
Message-ID: <20241203144748.931005562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 6bb64877a41561bc78e0f4e9e04d524a0155d6aa ]

The T-PHY controller at 0x11e40000 controls two underlying USB2 and USB3
PHY ports. The USB3 port works normally just like the others, so there's
no point in disabling it separately. Otherwise, board DTs would have to
enable both the T-PHY controller and one of its sub-nodes in particular,
which is slightly redundant and confusing.

Remove the status line in the u3port1 node, so it's ready to be used
once the T-PHY controller is enabled.

Fixes: 9461e0caac9e ("arm64: dts: Add MediaTek MT8188 dts and evaluation board and Makefile")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241021081311.543625-1-fshao@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188.dtsi b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
index 02a5bb4dbd1f8..91beef22e0a9c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -1689,7 +1689,6 @@ u3port1: usb-phy@700 {
 					 <&clk26m>;
 				clock-names = "ref", "da_ref";
 				#phy-cells = <1>;
-				status = "disabled";
 			};
 		};
 
-- 
2.43.0



