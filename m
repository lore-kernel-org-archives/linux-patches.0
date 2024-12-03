Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C741FA826;
	Tue,  3 Dec 2024 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240458; cv=none; b=b7XzfrzBIwx7OJXzALBAC0w+XmtE5aQLNkH+oO/77AQz277NbPsOiVVmkD82StEYXKSnXwiE+CKv2B1BfbNxqbuI0rIkCGAK0h6PaZjXZ0CHlkcJGRTuZBPS8qI4qwiX2AEE2DK98mkSRcP9LE8tpuu+LT2/MkyD8dmZ1/gPKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240458; c=relaxed/simple;
	bh=Uhbksr926N57CW8L2Mply8/+5NImd+0GmNthlSnHkWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnoXm1KjlTvcS/hlR3K29Ju5soKEXbBuKb4yoi5WY/189EuTsuDz09Po+OQ9Jz+y7dsoVT5N7+G0aGht2IHWroGr+pL4SCiIGszX/rz7YWNfIsseQ/1wr/IVuWiaMR1HlXWwLrsN1MeG7yyeMF45tbV5OqUpaciKWW/j+yGotXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXfEyqwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXfEyqwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9733C4CECF;
	Tue,  3 Dec 2024 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240458;
	bh=Uhbksr926N57CW8L2Mply8/+5NImd+0GmNthlSnHkWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXfEyqwSLvLIvV/vAVmdD3dH1QgD+uV+JITQisl3S6axFQQsaNS28ImtTE7s/T/Vh
	 x7sNuBr+y8ddRW1xk76NCRrbUDe2HibD/0D7b08kj5RahPD5HFHGP6iCW+snxGA7wb
	 x3gsmQwmQo3zmXAeKt/eJvlyvgmJ5norw9botweI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/826] arm64: dts: mediatek: mt8183-kukui: Disable DPI display interface
Date: Tue,  3 Dec 2024 15:37:16 +0100
Message-ID: <20241203144747.997096131@linuxfoundation.org>
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

From: Alper Nebi Yasak <alpernebiyasak@gmail.com>

[ Upstream commit 377548f05bd0905db52a1d50e5b328b9b4eb049d ]

Commit 009d855a26fd ("arm64: dts: mt8183: add dpi node to mt8183") adds
a device-tree node for the DPI display interface that feeds the external
display pipeline, to enable HDMI support on the Pumpkin board.

However, the external display is not fully described on Chrome devices,
blocked by further work on DP / USB-C muxing graph bindings. This
incomplete description currently breaks internal display at least on the
Cozmo board. The same issue was found and fixed on MT8186 devices with
commit 3079fb09ddac ("arm64: dts: mediatek: mt8186-corsola: Disable DPI
display interface"), but the MT8183 change wasn't merged until then.

Disable the external display interface for the Kukui device family until
the necessary work is done, like in the MT8186 Corsola case.

Fixes: 009d855a26fd ("arm64: dts: mt8183: add dpi node to mt8183")
Link: https://lore.kernel.org/linux-mediatek/20240821042836.2631815-1-wenst@chromium.org/
Signed-off-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Reviewed-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240916162956.267340-1-alpernebiyasak@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 22924f61ec9ed..07ae3c8e897b7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -290,6 +290,11 @@ dsi_out: endpoint {
 	};
 };
 
+&dpi0 {
+	/* TODO Re-enable after DP to Type-C port muxing can be described */
+	status = "disabled";
+};
+
 &gic {
 	mediatek,broken-save-restore-fw;
 };
-- 
2.43.0



