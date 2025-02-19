Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BEA1E5B8F;
	Wed, 19 Feb 2025 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956141; cv=none; b=YP0pPOkcZ9U/12PODtWlPbbciOyydAhli6aIsdCx3oWxeRAZpzH/k7DZFSoX3Q9rd6EQLRnsAZAO+nds/qDKES/T1+xLjoFdUEbNdhGb7U5ouAQr6/6bCUojN1zEGkKxphDXgGIEadBf2Y8guUi4uQjafwtIFIp1sk2BTqdsEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956141; c=relaxed/simple;
	bh=JJgem6AGJKcXWg/8UeZETanl4i1Bkdba7UqELw+jQ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku+9WBXsioVq03i5hHWLQf3/HqfU5KO0Mmk8Yn1crBvQByY3KlVFGS7G05OFQdnu0E4dXwMJMcCF6VCxxhcn8rTHlAjpuVXNWCyiEFJO00xdnWK0iFGapjXbgijkflJAqs6R0Wwl/Uyg+kOpxeLSDCMW2+bxyO9D9fD3VariqjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv79Ebno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv79Ebno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE7C4CEE6;
	Wed, 19 Feb 2025 09:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956141;
	bh=JJgem6AGJKcXWg/8UeZETanl4i1Bkdba7UqELw+jQ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lv79EbnoewVpjRz0iGW1EaeN9eku62YtAIxaxumGYxrtFamTcYlkwZrcE2IZ0/MiZ
	 BMgxxiLaRAeKwtjqKPXNThA/nCKwHM0G4C04y3Z7jJ0zzLd8Uwkktpt9bXs3Tx6m/e
	 Iy2MT1SV0iXDWMQ6d+pFGv0j8eR94MS37COEe9W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/578] dt-bindings: leds: class-multicolor: Fix path to color definitions
Date: Wed, 19 Feb 2025 09:20:51 +0100
Message-ID: <20250219082654.742883930@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 609bc99a4452ffbce82d10f024a85d911c42e6cd ]

The LED color definitions have always been in
include/dt-bindings/leds/common.h in upstream.

Fixes: 5c7f8ffe741daae7 ("dt: bindings: Add multicolor class dt bindings documention")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/a3c7ea92e90b77032f2e480d46418b087709286d.1731588129.git.geert+renesas@glider.be
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/leds/leds-class-multicolor.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
index 31840e33dcf55..3452cc9ef3373 100644
--- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
@@ -27,7 +27,7 @@ properties:
     description: |
       For multicolor LED support this property should be defined as either
       LED_COLOR_ID_RGB or LED_COLOR_ID_MULTI which can be found in
-      include/linux/leds/common.h.
+      include/dt-bindings/leds/common.h.
     enum: [ 8, 9 ]
 
 required:
-- 
2.39.5



