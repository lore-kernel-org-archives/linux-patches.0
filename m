Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFEB8BE8;
	Tue, 30 Jul 2024 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355624; cv=none; b=VcVrWVMcdx7tcKxFL2G3VHGl944RrCc3o2UoxaPTtotF0YkGcilR+p3IYPIl8wBtUlmM6RCK64jeQ21Sl0NEok6S1aNS3BEwA/bnUkGyfsoUbBycYYqq5saSSY5zg/4+jV6MGJACbVPGsweUqYv/1m53zWBuklSh1bOOmE6b8aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355624; c=relaxed/simple;
	bh=yQqSf56tNLSEVP/UNK1Xh4K9nnB1qoLPclHS6EKP+Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErPvI3aKXfg7YRs1gM+DOFAI3/jQiphnQFCR7LjJXtgIAYVOTaAhzUgwQn01CPdNPReKSiil1uXXj+UwmH5Sb8ofmAGGdVbovDellJSdCVR5d3Bt2Mjr4wGmvlXILc+u7BzBrh4gE6i6kPq+pLy+JYoK3GsB2rylOnH/tGAyya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzC8mBd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzC8mBd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE7DC32782;
	Tue, 30 Jul 2024 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355624;
	bh=yQqSf56tNLSEVP/UNK1Xh4K9nnB1qoLPclHS6EKP+Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzC8mBd0sN5GyBaOrX4nzE8mWtSdL09DHbNvchalMWEc5LJ/8FUiNHzWV/11ieiNT
	 TMDaC/gbJ0RE6WHD6tz32SEMpLYs30Rm6Wvqag2sbgrso5GodHrdpiuLjqtczzV9x7
	 k+s5T6+M2E7MO8CGnoumjjRHC+S4GdE+cBAXpa8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/568] arm64: dts: mediatek: mt8183-kukui: Fix the value of `dlg,jack-det-rate` mismatch
Date: Tue, 30 Jul 2024 17:43:02 +0200
Message-ID: <20240730151642.792185832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 95173af725e6f41eb470466a52ddf2054439409c ]

According to Documentation/devicetree/bindings/sound/dialog,da7219.yaml,
the value of `dlg,jack-det-rate` property should be "32_64" instead of
"32ms_64ms".

Fixes: dc0ff0fa3a9b ("ASoC: da7219: Add Jack insertion detection polarity")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20240613-jack-rate-v2-1-ebc5f9f37931@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
index 2c69e7658dba6..b9a6fd4f86d4a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
@@ -28,7 +28,7 @@ da7219_aad {
 			dlg,btn-cfg = <50>;
 			dlg,mic-det-thr = <500>;
 			dlg,jack-ins-deb = <20>;
-			dlg,jack-det-rate = "32ms_64ms";
+			dlg,jack-det-rate = "32_64";
 			dlg,jack-rem-deb = <1>;
 
 			dlg,a-d-btn-thr = <0xa>;
-- 
2.43.0



