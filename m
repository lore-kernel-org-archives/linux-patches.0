Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC471494D9;
	Fri,  6 Dec 2024 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496084; cv=none; b=jaImOnKkCk+WuXaV8XK7A1pKXwmETYslyG3YumgLlLtmfU22yzepZwbqLnGwbtdnSob5RtVzt7M58wRglwxCMmEgbDjHkPUTuJre7UAJtrbdRGuo0yYGjxeZrFXI+kO3vD66h+dLfwUlpsSWuHpXFTvURTQQPtIhVJ+4T4idPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496084; c=relaxed/simple;
	bh=9FvRdZMEdLhWgIpMYYOFdTnjQPPFaN6GWaz508gGLVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7UG2xl4fL0T6VBxj4G/9GhbPeZfeHit4qpd56ecY81b/KJMmYo3wEKXPROT2jMFfq+taUZ8UnSMZ0IY+qsnfb3wP9+J5tm3TbS4WygK2kwyy+Gm94h16zciqvYtOWpH9WPYNnptpBJPjYEtk9Bwn1w7Rtvnk6OCyMRZ1uAwCRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhsZ9OI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhsZ9OI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E175DC4CEDE;
	Fri,  6 Dec 2024 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496084;
	bh=9FvRdZMEdLhWgIpMYYOFdTnjQPPFaN6GWaz508gGLVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhsZ9OI15gRqXMkdFVu6JWwgAly5m0wR6UdBRG+CHEd3UZYTU854SOVjL1qJYYNOL
	 tFK1yG9WIDruSrv4IiPa8CxwvRKTmHIyO8v55dIENFd06lgXpUGuxZ+yYiVdEN00No
	 BIe1Vxw1nI2by0MwwoapLUHwes8S0X50pLk52hcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.12 015/146] arm64: dts: mediatek: mt8186-corsola: Fix GPU supply coupling max-spread
Date: Fri,  6 Dec 2024 15:35:46 +0100
Message-ID: <20241206143528.255702036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

commit 2f1aab0cb0661d533f008e4975325080351cdfc8 upstream.

The GPU SRAM supply is supposed to be always at least 0.1V higher than
the GPU supply. However when the DT was upstreamed, the spread was
incorrectly set to 0.01V.

Fixes: 8855d01fb81f ("arm64: dts: mediatek: Add MT8186 Krabby platform based Tentacruel / Tentacool")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241021140537.3049232-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
index 0c0b3ac59745..eb06b343a540 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
@@ -1336,7 +1336,7 @@ mt6366_vgpu_reg: vgpu {
 				regulator-allowed-modes = <MT6397_BUCK_MODE_AUTO
 							   MT6397_BUCK_MODE_FORCE_PWM>;
 				regulator-coupled-with = <&mt6366_vsram_gpu_reg>;
-				regulator-coupled-max-spread = <10000>;
+				regulator-coupled-max-spread = <100000>;
 			};
 
 			mt6366_vproc11_reg: vproc11 {
@@ -1545,7 +1545,7 @@ mt6366_vsram_gpu_reg: vsram-gpu {
 				regulator-ramp-delay = <6250>;
 				regulator-enable-ramp-delay = <240>;
 				regulator-coupled-with = <&mt6366_vgpu_reg>;
-				regulator-coupled-max-spread = <10000>;
+				regulator-coupled-max-spread = <100000>;
 			};
 
 			mt6366_vsram_others_reg: vsram-others {
-- 
2.47.1



