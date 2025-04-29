Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD371C6B4;
	Tue, 29 Apr 2025 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946825; cv=none; b=Aqqcwr3kmWi7apIS5iDOdYb7z4QwRMXx+mydfUTPgJxwZrIgI9FDpWQasYccmisIwPezsyK2qO4cVWuX8gcgUrxzRzTXVdWdZ2SURSUAZTZFzCHVuzyxiOa/6bD4etNaAREne72sRR1AyNbp4UxRS+V5QZ6QWePvn6AEKi7i79o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946825; c=relaxed/simple;
	bh=Vj3emwHhZsH2wpIMrICNTcQrmsxGbxs4zy1uug1CY4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uitl1wqNfbq7Us5xMf+AQvd0f6knhwaH+26YLVbSRQp3h6gNV0V+xx2atl1W3Pt8sIJr3RZ8Iq8tx7u2l27gS3loSoZGjdE8PYTrYUci3Psr+tW8T1QMslUCPjvIkiFi97qqVDei/fMh5qujLaNgeeTYCJ8byCB+Cb5XuV1lJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZR2Dinc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZR2Dinc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4464C4CEE3;
	Tue, 29 Apr 2025 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946825;
	bh=Vj3emwHhZsH2wpIMrICNTcQrmsxGbxs4zy1uug1CY4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZR2Dinc7AIuUTrt3LetKSZfU+uIWLSbfJUJbrPAL0/1x2AkQ3WAQfVkIx3+XN8Yp
	 yZKPAiHKlF96+cG0vWJ3YfDQi3RP706dxpf3CeUo/aRO28Ql621L0343W1KP/8UVqs
	 INQDvUbf7BmZ/Xozp+kyWlgH7nxUfbnqqj65ujAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YH Huang <yh.huang@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.10 082/286] arm64: dts: mediatek: mt8173: Fix disp-pwm compatible string
Date: Tue, 29 Apr 2025 18:39:46 +0200
Message-ID: <20250429161111.225930809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 46ad36002088eff8fc5cae200aa42ae9f9310ddd upstream.

The MT8173 disp-pwm device should have only one compatible string, based
on the following DT validation error:

    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pwm@1401e000: compatible: 'oneOf' conditional failed, one must be fixed:
	    ['mediatek,mt8173-disp-pwm', 'mediatek,mt6595-disp-pwm'] is too long
	    'mediatek,mt8173-disp-pwm' is not one of ['mediatek,mt6795-disp-pwm', 'mediatek,mt8167-disp-pwm']
	    'mediatek,mt8173-disp-pwm' is not one of ['mediatek,mt8186-disp-pwm', 'mediatek,mt8188-disp-pwm', 'mediatek,mt8192-disp-pwm', 'mediatek,mt8195-disp-pwm', 'mediatek,mt8365-disp-pwm']
	    'mediatek,mt8173-disp-pwm' was expected
	    'mediatek,mt8183-disp-pwm' was expected
	    from schema $id: http://devicetree.org/schemas/pwm/mediatek,pwm-disp.yaml#
    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pwm@1401f000: compatible: 'oneOf' conditional failed, one must be fixed:
	    ['mediatek,mt8173-disp-pwm', 'mediatek,mt6595-disp-pwm'] is too long
	    'mediatek,mt8173-disp-pwm' is not one of ['mediatek,mt6795-disp-pwm', 'mediatek,mt8167-disp-pwm']
	    'mediatek,mt8173-disp-pwm' is not one of ['mediatek,mt8186-disp-pwm', 'mediatek,mt8188-disp-pwm', 'mediatek,mt8192-disp-pwm', 'mediatek,mt8195-disp-pwm', 'mediatek,mt8365-disp-pwm']
	    'mediatek,mt8173-disp-pwm' was expected
	    'mediatek,mt8183-disp-pwm' was expected
	    from schema $id: http://devicetree.org/schemas/pwm/mediatek,pwm-disp.yaml#

Drop the extra "mediatek,mt6595-disp-pwm" compatible string.

Fixes: 61aee9342514 ("arm64: dts: mt8173: add MT8173 display PWM driver support node")
Cc: YH Huang <yh.huang@mediatek.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250108083424.2732375-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1193,8 +1193,7 @@
 		};
 
 		pwm0: pwm@1401e000 {
-			compatible = "mediatek,mt8173-disp-pwm",
-				     "mediatek,mt6595-disp-pwm";
+			compatible = "mediatek,mt8173-disp-pwm";
 			reg = <0 0x1401e000 0 0x1000>;
 			#pwm-cells = <2>;
 			clocks = <&mmsys CLK_MM_DISP_PWM026M>,
@@ -1204,8 +1203,7 @@
 		};
 
 		pwm1: pwm@1401f000 {
-			compatible = "mediatek,mt8173-disp-pwm",
-				     "mediatek,mt6595-disp-pwm";
+			compatible = "mediatek,mt8173-disp-pwm";
 			reg = <0 0x1401f000 0 0x1000>;
 			#pwm-cells = <2>;
 			clocks = <&mmsys CLK_MM_DISP_PWM126M>,


