Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D79717592;
	Tue, 30 Apr 2024 11:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476492; cv=none; b=QVMjvChZQEtnBEnehr3MJiblZxBhwLfij8b0nEa23PX98B1BBegArMsB6cpq0nXKFkXUdCUMGAIctPYzsMRU4keGmJRlqOb+rHETRF+qZSfIDe26OHDlCDzUjC4JslJuW2O0zkrASVAdYTfw+8bBGMBkNxAegLdaIjYjdiZZOt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476492; c=relaxed/simple;
	bh=2xAmWcQmfHMPht1W6m5I7K1MvyWK1U3GBHpX30AuzOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agBRIqp+mJw2gUI8NgiXRv8u2QKXXduefkf8rtSNmALcU6j7fsrGPY8jUNOHYoHbY5Sk2XA9bIQtHaD+fHFwfXpQSrQ8vuzy3W0G5T+VDmqIHN+KzwVZ8HsqG8jZKLy58FVFjgZ9B1qoqD8avq3QtpminR9jIs48ET/yEgv/YgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrwCq70F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrwCq70F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA023C2BBFC;
	Tue, 30 Apr 2024 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476492;
	bh=2xAmWcQmfHMPht1W6m5I7K1MvyWK1U3GBHpX30AuzOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrwCq70FDo4TAaWzJIe0aQeqGo+ay+5vUUryv7yFHvCxz61ZVrtYR7/eEiTFs5rpO
	 3DueY5+vJmsonFWOHkx2l6WSQwgAr3wyWEPYDj1CztnRQXkuN/0s3YeFv1X8OYqYHC
	 UgIv1zlLxEBOMAcmgsVe0dxu/JM4YY6mcx5TMouQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/110] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to vpp/vdosys
Date: Tue, 30 Apr 2024 12:39:41 +0200
Message-ID: <20240430103047.932298971@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 96b0c1528ef41fe754f5d1378b1db6c098a2e33f ]

Add the missing mediatek,gce-client-reg property to the vppsys and
vdosys nodes to allow them to use the GCE. This prevents the "can't
parse gce-client-reg property" error from being printed and should
result in better performance.

Fixes: 6aa5b46d1755 ("arm64: dts: mt8195: Add vdosys and vppsys clock nodes")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-2-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 414cbe3451270..8f33b3226435a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1492,6 +1492,7 @@
 			compatible = "mediatek,mt8195-vppsys0";
 			reg = <0 0x14000000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_1400XXXX 0 0x1000>;
 		};
 
 		smi_sub_common_vpp0_vpp1_2x1: smi@14010000 {
@@ -1597,6 +1598,7 @@
 			compatible = "mediatek,mt8195-vppsys1";
 			reg = <0 0x14f00000 0 0x1000>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce1 SUBSYS_14f0XXXX 0 0x1000>;
 		};
 
 		larb5: larb@14f02000 {
@@ -1982,6 +1984,7 @@
 			reg = <0 0x1c01a000 0 0x1000>;
 			mboxes = <&gce0 0 CMDQ_THR_PRIO_4>;
 			#clock-cells = <1>;
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c01XXXX 0xa000 0x1000>;
 		};
 
 		larb20: larb@1b010000 {
-- 
2.43.0



