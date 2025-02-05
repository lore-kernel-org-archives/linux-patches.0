Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900E115198D;
	Wed,  5 Feb 2025 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764872; cv=none; b=rc0gEmtobayUSBG/9NyXjXDOpOPpaGH4D3IkWv2KMKkC/8+lWRUk+U7smViq90zl+LbVy+i3mCIV5bJA58/riY9j9oR+KE7+U5BwICSpT9MPmHXRrbOiS/2BHf/OwSs1dZy5b+3+hSoUZAuOvdGxKlV3POv2mkU5OmDo1x3BFqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764872; c=relaxed/simple;
	bh=R8z8sE0jnoF6TbdvL/hW0K9sDm0idY2pcwx8A0GO2U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFTa+i/7MwYLFTMlTpvPRL6cj110tn2BbkqqC2Zri4DZTkKXWL+WAipArza7yL3OrZWqTSr5/JjTEE6s/qMHMhWSpHEpaKjaI6F7H8XjEFTWDCEHf2lTY2by1KF20iAdDgUd08jEnCNaWo4wenEDPWFAzT6xqqhRIxFStzb1rqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sw/1KyOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sw/1KyOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE0C4CED1;
	Wed,  5 Feb 2025 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764872;
	bh=R8z8sE0jnoF6TbdvL/hW0K9sDm0idY2pcwx8A0GO2U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sw/1KyOEKJ8ZI3/cvPFYTS+aPG1XyAUDyaa9AO5X9j8k47hNpAlxGHJl5Oe8VtKIN
	 XI5JMXE4IulKQjADM6NsecmY8g3HUDmVD4qS4Jqe6OTk5m6xIxZ2j+M0sPhOGTSaKa
	 2cOCCUxj/4jfhaAbIbnY2Rw6PILmdozDIc/5jeJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/393] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:42:10 +0100
Message-ID: <20250205134428.372646862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 9545ba142865b9099d43c972b9ebcf463606499a ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 16ea61fc5614 ("arm64: dts: mt8173-evb: Add PMIC support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index f9a84825b5cad..f6a70f22bd0c4 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -308,7 +308,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6397regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
-- 
2.39.5



