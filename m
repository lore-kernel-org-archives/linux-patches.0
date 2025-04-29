Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F450229B05;
	Tue, 29 Apr 2025 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945294; cv=none; b=VInFMbeqLSRx4xui8BoHxviKyWORo8K6NWvztgR9dbWFoOgiVzXhAlkF7A1eeBVhfziyQVtLXdLUYyuQqzVvAIkONF1H5VDEURo7QJu+kKhXzplWAC2PbEnaVjtoQZ8uhHeX/hAp1Ex4r4VO0lsdKtP7MXJQAxpGNlrI6l5dsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945294; c=relaxed/simple;
	bh=0AK9ORFKuxa2qB3D0W/CaIZN7g2CF7Ucok8J8OJ9ync=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKdpEhPCD996VnI6/i32LLB5folnJZDPRXgqN+4pM6HEpjY4L2h6kCPukvQdKlMh3nGu92El7C9gRYWCKvxcWHtNZgPpCqlCpcNcv7jzUqvzY94Hy3r42+mAQg9VMkJ9FaSxB30BG2XQS8C83fezLt26iS5mK1qsUs8qiXdlpAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdCyy4TO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdCyy4TO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3133C4CEE3;
	Tue, 29 Apr 2025 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945294;
	bh=0AK9ORFKuxa2qB3D0W/CaIZN7g2CF7Ucok8J8OJ9ync=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdCyy4TOChz90l9bDjiiEL6JA97wmV3nAg7WFuVfYbqqH6QFa0vylcGQwTHmZykBW
	 j7re5smkaJ/wRJnUW/pDYjUO4cuoMx01eZ0qsF+DBx1CcSyCXk1FKLZw/W5nOj2lx4
	 w1njPgO7VZfEWw8/m589RBPT9GLsjNRQJZt5KKqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YH Huang <yh.huang@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.4 065/179] arm64: dts: mediatek: mt8173: Fix disp-pwm compatible string
Date: Tue, 29 Apr 2025 18:40:06 +0200
Message-ID: <20250429161052.040736335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1161,8 +1161,7 @@
 		};
 
 		pwm0: pwm@1401e000 {
-			compatible = "mediatek,mt8173-disp-pwm",
-				     "mediatek,mt6595-disp-pwm";
+			compatible = "mediatek,mt8173-disp-pwm";
 			reg = <0 0x1401e000 0 0x1000>;
 			#pwm-cells = <2>;
 			clocks = <&mmsys CLK_MM_DISP_PWM026M>,
@@ -1172,8 +1171,7 @@
 		};
 
 		pwm1: pwm@1401f000 {
-			compatible = "mediatek,mt8173-disp-pwm",
-				     "mediatek,mt6595-disp-pwm";
+			compatible = "mediatek,mt8173-disp-pwm";
 			reg = <0 0x1401f000 0 0x1000>;
 			#pwm-cells = <2>;
 			clocks = <&mmsys CLK_MM_DISP_PWM126M>,


