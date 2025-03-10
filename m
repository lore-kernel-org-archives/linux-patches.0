Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B3422B59D;
	Mon, 10 Mar 2025 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628697; cv=none; b=SNeTO2N+F1SF0B2hVmE/TGPNUBom+MEQZWG/CT3wNVwg6rk3OyVB5kxZUq5HNQv7PeYro8WVEsl5y7qHH6ydjtM5wqwGAa5EJmgmPtawtbGiBEDUFbc/r9BjITMxK4CGahZyALWPMftv3pU7+MJHn3iOOcNIXlEvT93Mc3xFe5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628697; c=relaxed/simple;
	bh=wpbUZinsMBtFJzrzfiv51ydG1oxOSZUxcuia1BqpD0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbWS+aKWo/uIoAozi9kAOYpQA5fbN5FMPpdJKmRhRSkV3iz8zwdGAVOrzB3LvdR7kNOJXSS0RBCBEg5cVQ7SgfN8JELfelUlrQAcOX42tSUGT9PPnNcDonON2B+PbN9GDpYqWSe6VlS4bR0GpwRdJ++HKNs8xKgbvuD856C6DTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHQWQS+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHQWQS+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFE6C4CEE5;
	Mon, 10 Mar 2025 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628696;
	bh=wpbUZinsMBtFJzrzfiv51ydG1oxOSZUxcuia1BqpD0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHQWQS+qhNGfBuZN8zKUMO1BmnnCpVlOxezzC4DR1yAtjSu+ggT6FC0j+AW3BEll9
	 u1jkIk73U1VpCtpZHVUok5lPfUf9rh+Ihu9whXHm1KUr9801IX3uWcm7AAJaoT5N+7
	 ctqK81nxUfaKfw0HEHZTF54wPnw+vuYtjG0eYSCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/620] dt-bindings: leds: class-multicolor: Fix path to color definitions
Date: Mon, 10 Mar 2025 17:58:03 +0100
Message-ID: <20250310170547.042774069@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12693483231f7..71fcd10cb9bc0 100644
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



