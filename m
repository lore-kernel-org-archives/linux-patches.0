Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8D6231A24;
	Mon, 10 Mar 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630523; cv=none; b=e/MOpJqyUoZLYPFeSXO9Bm5kKp7a38Uj52TC1JlhDMTRD6MtZpiX/io2IaLLquJJu1kxCdhJZoSJomLqQ5yVEisrAJmfrY+Zj+OAJ8KinSQFgzxvzUCBTC2ruUNeGQOa9zPab2EwN0a4UL8UN/Z+gb5ZtAHlpIorbuMqgSTpuA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630523; c=relaxed/simple;
	bh=mqz9Ai+6TCWOG7gSVWZdnC/wzIXhL5Y31IWVntpKccU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz1eTYFhRJvDzslbVjbic5SVLoyyHOi7RUyZYNJHy9K388Yv4gNq0nQDaNSIJe79wxzc4+bhh9S+V/bUSPQhJTxqfTVmzT6Zv4wy/9gpDtH7ZJajIR7O6MqPSWFgDb9qfs8oiMP4OyljOxB2TiiXGbVIVgtIxyhwxeBFPjgAQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yukkZfkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yukkZfkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A296C4CEF1;
	Mon, 10 Mar 2025 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630522;
	bh=mqz9Ai+6TCWOG7gSVWZdnC/wzIXhL5Y31IWVntpKccU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yukkZfkJ9+vOs3FwQax8npAAWbHHBsnkYsEfF+nVEBa3GkpZsj76R27tVQ77TOlCR
	 njfhIP+i6m07zMBeOX2YU98ybRN2+VDLy1rxzsJfJthwCc8uPrV/bovPSi8hMWUMY9
	 dKo5vfeKQ/if9dkOjALktkv6UE9sj045y2wPf++k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/620] arm64: dts: mediatek: mt8183: Disable DSI display output by default
Date: Mon, 10 Mar 2025 18:04:49 +0100
Message-ID: <20250310170603.082857911@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 26f6e91fa29a58fdc76b47f94f8f6027944a490c ]

Most SoC dtsi files have the display output interfaces disabled by
default, and only enabled on boards that utilize them. The MT8183
has it backwards: the display outputs are left enabled by default,
and only disabled at the board level.

Reverse the situation for the DSI output so that it follows the
normal scheme. For ease of backporting the DPI output is handled
in a separate patch.

Fixes: 88ec840270e6 ("arm64: dts: mt8183: Add dsi node")
Fixes: 19b6403f1e2a ("arm64: dts: mt8183: add mt8183 pumpkin board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241025075630.3917458-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 712ac1826d686..68395d4c89303 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1236,6 +1236,7 @@ dsi0: dsi@14014000 {
 			clock-names = "engine", "digital", "hs";
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
+			status = "disabled";
 		};
 
 		mutex: mutex@14016000 {
-- 
2.39.5



