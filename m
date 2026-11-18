Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030493;
	b=dukY77/XHo5mFX2TI4R/eHbBdYlLS4cH6qO+VkDPszZgA+er6mS1YFiDWZ53W0tZoVM8
	 Na98t2uWhbfz0iADoldQhUBKk1BNH4TwaPiKCJFY0ayqfazF+O7c/TWezikgc6ZgFQThz
	 wjdM0bc1rRFT6Gpy68kuFdtRT9gU/+L9Q9GUZ/ZHn6Z+gk3im61GJ064SbUpHD0iCwSyM
	 gCVYqBybb27F3OGa4xmIaYoJVRdtbFig/KTeve68AKN9yaxo/pYqWyG4189+HRjKQRUhM
	 6kw6m+QsKOre9nlKAPAc0VD9sAX4FMi2v+97gJlEo7l/Dxor9QcJ5Y9q4tgPLrPf61Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JekceuWcSuKPmGICAQAAbuDHHPZ0u3tMRph7+1Oo48g=;
	b=Kyzb7OakkJFL/gIyMX/tJog7jj0oJdhZGg11DKQirUpp8H0pntWglJLO45WzOFbNgTM5
	 bAGj4kYqk3bZ5EFYBokYPwTKo4AiYThQH97ofoMgaa+z5jUFQAucIbQ63NEOm/iRnIMwu
	 8lbM1Q7s51Y0t4I1cjrunLbAdRXhmFt9DflyqkjMWutx/AKnnHVYi8BpxMmyxvYSiJCYD
	 pm/3UBE0/Cb3onZl/SX7h70vwWIM3pDGnvbWc5gm5eHNrBsK79ZI4AI7klwEA60+jvEPK
	 RI8ciq67HGvr/L0HueWrfeHJkvO5iLeRUWUy6XgBPoITA15wjbmb0aUYL0q1rkOAfEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mvJZIjB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367CB606BB75;
	Wed, 18 Nov 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvJZIjB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322241F000C4;
	Wed, 18 Nov 2026 19:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030492;
	bh=JekceuWcSuKPmGICAQAAbuDHHPZ0u3tMRph7+1Oo48g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvJZIjB/H24ewIiNnRzsDMBue1P0e4EQyFQgwFjWlJr7aR7sNNSLbn/7Zg2IFmdCj
	 f0CQYTx9etr4YWSUsyb0gcLT62EQ9Wf8rpUQRCVTV50nqH7rLdDYe6O2GPak0NSlWK
	 j/Ud5Bnyv00Ywn6W/LxJ7Dl+swYGmeFIVE0yDqAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0723/1756] dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150038.482827563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 3309f5c888602c647f50c1921c9b60759fa86c21 ]

There are no properties in DTS or Linux drivers called
"core-vcc-supplies" or "hdmi-mux-supplies", so the binding probably
wanted "-supply" properties instead (which are defined in the top-level
properties of the binding).

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 2f14bc38d88a ("dt-bindings: display/msm: hdmi: split and convert to yaml")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752661/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-7-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/hdmi.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/hdmi.yaml b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
index d4a2033afea8d..680d88d3ced3b 100644
--- a/Documentation/devicetree/bindings/display/msm/hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
@@ -128,7 +128,7 @@ allOf:
             - const: core
             - const: master_iface
             - const: slave_iface
-        core-vcc-supplies: false
+        core-vcc-supply: false
 
   - if:
       properties:
@@ -151,7 +151,7 @@ allOf:
             - const: core
             - const: alt_iface
             - const: extp
-        hdmi-mux-supplies: false
+        hdmi-mux-supply: false
 
   - if:
       properties:
-- 
2.53.0



