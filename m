Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482E1FA270;
	Tue,  3 Dec 2024 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240451; cv=none; b=Fe9gSnNrQ+BUnzlsVaBJyrc/ib9eg6BxtrqCzsA4IgF1RPtCMfB1MAz5zuk7J+dDvPy7USGNO1lS7VdQMixEPqSxloP9rBwRJ66/D/XxdPm8cIPTO3Jw70jKWOxVbSMYekYA8FfMK9X0QYITduuecwE02z/jIz0Zux41VvF/kTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240451; c=relaxed/simple;
	bh=5zC2bGUE6PpoLPEuKhReczUPiImuEM6KGcgpJfGAUvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbTSlQtXrwXvSlxb11Hq/7uZh/ENnUwoTxIPB067F33TFtCafSMyFtTriYl8sxw+RUlRaTP9kOl16IauguaNCuotTDQyIVX7TJHsfo67DlwzB0Ktx1eNQBy9QFBKReCDZOXgGcwcT2XN8Yp9T4seFJaNrp1YtT0Vs5+ZgRTKcpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRKGc7CK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRKGc7CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E83C4CECF;
	Tue,  3 Dec 2024 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240451;
	bh=5zC2bGUE6PpoLPEuKhReczUPiImuEM6KGcgpJfGAUvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRKGc7CKdnlLD5k3gbmuGi3kirAFmMDJWRjy6L8/Y3TFeYt27geuT0GPkjKYY5F8S
	 RsVJlcm3ykJF3O4HEVkTqwXf9nug3gDLt3kM8e+y+IapmqcUwfQ8WiwlikSntMtZrx
	 SIS/+0Tc1AX3xAjkcJ/sUCGb/n8gqtAy7vyu0Xhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/826] arm64: dts: mt8195: Fix dtbs_check error for mutex node
Date: Tue,  3 Dec 2024 15:37:14 +0100
Message-ID: <20241203144747.918823667@linuxfoundation.org>
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

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 0fc557b539a1e11bdc5053a308b12d84ea754786 ]

The mutex node in mt8195.dtsi was triggering a dtbs_check error:
  mutex@1c101000: 'clock-names', 'reg-names' do not match any of the
                  regexes: 'pinctrl-[0-9]+'

This seems no need by inspecting the DT schemas and other reference boards,
so drop 'clock-names' and 'reg-names' in mt8195.dtsi.

Fixes: 92d2c23dc269 ("arm64: dts: mt8195: add display node for vdosys1")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002051620.2050-4-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index e89ba384c4aaf..3a2ba8aac66bb 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3331,11 +3331,9 @@ &larb19 &larb21 &larb24 &larb25
 		mutex1: mutex@1c101000 {
 			compatible = "mediatek,mt8195-disp-mutex";
 			reg = <0 0x1c101000 0 0x1000>;
-			reg-names = "vdo1_mutex";
 			interrupts = <GIC_SPI 494 IRQ_TYPE_LEVEL_HIGH 0>;
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			clocks = <&vdosys1 CLK_VDO1_DISP_MUTEX>;
-			clock-names = "vdo1_mutex";
 			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x1000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_VDO1_STREAM_DONE_ENG_0>;
 		};
-- 
2.43.0



