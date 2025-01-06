Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCBC146D40;
	Mon,  6 Jan 2025 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177581; cv=none; b=dyeN4CGVgsL9Q8visR0/35z0r/M2R4whqw0tedBIDwqCfbdX49cOshLiKoLdSg/Ak5HLNPuRAC8anNacZ2qsBKM7lgo6WxYzKqMBrAc+2NbIvR2qIwJhXT3IzNNI1zvoI046gD8uthzfpjlvK+tDT4GGAa4NoKcfUI7gLhy6JcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177581; c=relaxed/simple;
	bh=TzSknap+OxCCiJT6z7KFjMGSN7SZI+JMS9fnHTpnAWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5xmvply0Jxw6f3z17wgQvvqTA6VsXlCwd9hPj87oJXcEy3579pzsodtL8+TdabZYTIALpLB4Vh14tAlGOtFZMvNE5ZZnlHCmTkdL1VsbO1OEp7cPd8c8rVSlrt7Y7HWmPOGkt5TNxJh8R3mm7Pl4T1trZffJN1A2MQj3s8l0QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRCo336K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRCo336K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C73C4CED2;
	Mon,  6 Jan 2025 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177581;
	bh=TzSknap+OxCCiJT6z7KFjMGSN7SZI+JMS9fnHTpnAWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRCo336K+lpwduycGbPNRvgnv6ZGTSmYIOvc34djJ4sFZPlp6OYovEqx6Q0JSavb0
	 x/8aAV0dbGC8jfcG6j7RcmcjGEfwwEVS2K+Sq5pqYQ/OGm3IuWEB51oG3WoQJu1Tv1
	 uAnawWwo6y6AO7LZX0V3hu6xkporlompvu+BYTKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 210/222] dt-bindings: display: adi,adv7533: Drop single lane support
Date: Mon,  6 Jan 2025 16:16:54 +0100
Message-ID: <20250106151158.714903498@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit ee8f9ed57a397605434caeef351bafa3ec4dfdd4 upstream.

As per [1] and [2], ADV7535/7533 supports only 2-, 3-, or 4-lane. Drop
unsupported 1-lane from bindings.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7535.pdf
[2] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7533.pdf

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-3-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7533.yaml
@@ -87,7 +87,7 @@ properties:
   adi,dsi-lanes:
     description: Number of DSI data lanes connected to the DSI host.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [ 1, 2, 3, 4 ]
+    enum: [ 2, 3, 4 ]
 
   ports:
     description:


