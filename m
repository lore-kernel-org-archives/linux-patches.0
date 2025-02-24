Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA78A2A8D0;
	Mon, 24 Feb 2025 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408348; cv=none; b=R7uJLDhaaAcyL1NeX4LRcBhgpbTa5PjmvMHR8+cR1FrdGZ3UfJxEEIE557+S6uwsGHX2Pa9kOiB2z/b2JTxwWskgz9JjZeBEnoTCpyR5y3+GmvFIeTqRNmbXIP+m2IjNdiZj2+ZXJdcekqC3WYRpvIi3ZhvDHHBDTXCizXJP7lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408348; c=relaxed/simple;
	bh=uNOy3P9gCbZt8OQxlFw2sCNzqlbiTEGew0M7fJ2EdFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHrm0A0nJUmmPgbOYhEs2tjyBShG+wyl2wHOWxSUMqqk82pNIz9v5tHF9MeXRrFe9jPB1kQamHRojNSpiX6YcIKjWKpNTF9kWogKvq3tDmsX2zxEOQ49d/q8t1ixiEost7tQht633fR76pKM0rqqawQKISaQGkzR2WVTKNXuing=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRpbcTUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRpbcTUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE09C4CED6;
	Mon, 24 Feb 2025 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408348;
	bh=uNOy3P9gCbZt8OQxlFw2sCNzqlbiTEGew0M7fJ2EdFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRpbcTUo9hWVZ9skhubTyjAEZmND5Hp0DRUHyNlQKVWJkx+s1ipGnMPaPCO+6oJDC
	 uw2or/82hqBFWo7BLQ+WgtzYfuPdSsH9XWkIdulhEU+GRx2ow9Xn6E5JfzMyhbDptM
	 PzmGJ3QJvvFLwt+z5DUirfS8XbA7PiYVyQiVyvSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/154] arm64: dts: mediatek: mt8183: Disable DSI display output by default
Date: Mon, 24 Feb 2025 15:33:51 +0100
Message-ID: <20250224142608.343272351@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts | 4 ----
 arch/arm64/boot/dts/mediatek/mt8183.dtsi        | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts b/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
index 61a6f66914b86..dbdee604edab4 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
@@ -522,10 +522,6 @@
 	status = "okay";
 };
 
-&dsi0 {
-	status = "disabled";
-};
-
 &dpi0 {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&dpi_func_pins>;
diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 5cb6bd3c5acbb..92c41463d10e3 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1835,6 +1835,7 @@
 			resets = <&mmsys MT8183_MMSYS_SW0_RST_B_DISP_DSI0>;
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
+			status = "disabled";
 		};
 
 		dpi0: dpi@14015000 {
-- 
2.39.5



