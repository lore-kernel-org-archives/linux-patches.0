Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CAD375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301715; cv=none; b=HAlQnKG3m62pMAZfzwRZXzUXiqwhxWQ4sV9UjDZUJWRY9xVYyLFupsmi8UUuFPOwlVH/oqZ2Ka/HM3Xy1L3qQ6FVJvN9Z7Y95qeNv1tFeBCgwzpF4CNyRaEXjv7Hbg/d7shwsAhL7+lcSb8llGgiPhiieWgwtj8XJvE2csMEDSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301715; c=relaxed/simple;
	bh=Qq/kfotNG0E6OkYpBlaCUEx4NN9W+EDvZoUbeRpcl1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkUWaYbUH23eiXHqb9D5VVZkNEy04W5Svl5hyvMHqPZYqKrViN3hTx2/RHvOiW6GseuOfRl4D40D7CvYE6G70wcIHeJUR068qgBtGEWqLL/QhXQakgX28M2QqGOm8DCFclt4+mWKH7eZNd3FZghCYf7arlRr0HmIvzHI3FCgeis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDyLibVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDyLibVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5ABC19423;
	Sat, 28 Feb 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301715;
	bh=Qq/kfotNG0E6OkYpBlaCUEx4NN9W+EDvZoUbeRpcl1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDyLibVfFInO5WU7SnUZQ/8wOypDvY0www5yCaYi8JdTNzRN7TgXIorDWztX3ywT3
	 vhM3b7rO1oy5p1K04vdT5TF8pcYGjswSZ0Kd211jfH6if21RjQrS+3ovz6lVkqT9Cf
	 xU08NXJBTLLZINZNI4wxpfOVXAHFJDtSIWAKVltzdktczufDq55QuGd+nJiYWOeo5u
	 RsBnUYUn2G9OhGX5IA/D8EEn9pVUUNdJoQk8RoRQxZICn05gl8CZZbVmVXI+eGi1ZF
	 diNupLGU2dF9dnFtkxc2nd+CpeOB9irJkSy9zsxM63IzFzF0vrPzHeIS/LvRpPiMIC
	 sIGDQGgaSELsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/385] arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node
Date: Sat, 28 Feb 2026 12:55:33 -0500
Message-ID: <20260228180011.1568201-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b1fc81a986c9b8089db31e21a372cc8b6514e900 ]

Rename "piins-bt-wakeup" to "pins-bt-wakeup" to fix a dtbs_check
warning happening due to this typo.

Fixes: 055ef10ccdd4 ("arm64: dts: mt8183: Add jacuzzi pico/pico6 board")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
index cce326aec1aa5..40af5656d6f15 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
@@ -91,7 +91,7 @@ bluetooth@2 {
 
 &pio {
 	bt_pins_wakeup: bt-pins-wakeup {
-		piins-bt-wakeup {
+		pins-bt-wakeup {
 			pinmux = <PINMUX_GPIO42__FUNC_GPIO42>;
 			input-enable;
 		};
-- 
2.51.0

