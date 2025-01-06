Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A848634A;
	Mon,  6 Jan 2025 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176931; cv=none; b=uEqsCruIur6WHS8byq+Ejh1vrn/A/m+KGwYs7xQXrUTFuHSCpnjM0A4NJ7ce3vPI2BNVcKRdHOMFp4lNq89WMDyQByhlT8Dwv205qfc0dKuceDojnvMt62CRr9ASH4CsawkPrFWYfVZB52iqEjES9SM/xzwHN1nAeNw99Rgit3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176931; c=relaxed/simple;
	bh=FGLetRI16W8YGHWDmcfr0L4rx+mB9qzaQTPDS9KGnzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srOwnP/NLO8Kn9wPRngnSPDdmbXbBHrdqj77tQbBTkqA2ZRiSpP4gHN/4ee3BqBfkKBIoqf9iCawx6aS0A0dsq1SyTB+/pqnXKG4JORftDvNDprLUagH1xZYD0bIuXPhCZpdWEtjL08zmjTxcevDynrOKxMxu0J0XUV3/HVKzXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eogNhR9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eogNhR9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E4AC4CED2;
	Mon,  6 Jan 2025 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176930;
	bh=FGLetRI16W8YGHWDmcfr0L4rx+mB9qzaQTPDS9KGnzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eogNhR9+7o4EmD5z1B2iVYvOfX/KXJGurspR3BmsrI5Vd5ZFFXpw9jQq4T3cYFmDI
	 heMR/RExBFKCll0urz7cgZmxqXjJauXxgzE3kyFSCuxwLmU05m1nvDOKfY6v7KzxYf
	 bGaBteQFz0/F8XjdS9cflXceI35p+YTpLeDtAzn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.1 76/81] dt-bindings: display: adi,adv7533: Drop single lane support
Date: Mon,  6 Jan 2025 16:16:48 +0100
Message-ID: <20250106151132.297244360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


