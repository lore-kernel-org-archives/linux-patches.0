Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D76FC0B;
	Wed,  5 Feb 2025 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763612; cv=none; b=Oi5XdKja/LsCwZZpdpf/Fr/bYMEobECDjcK+PZ0R5uO4kb+xzC4cuPZuitgb+Z7+sNhLSKDuZDK/L+hjOPY5ah/BUn2TKDBiRiSjvxr618k+Vt3Khu4XA+cHtdvfAs/un5lPM0OWzFWYN/SogliN6HGF7QfKIPXns1kI9LgwCIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763612; c=relaxed/simple;
	bh=pPW481xathx+9lEjQakqHzx1+r54h/O6cfzd9zCG/EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouj7y8ybgg7c1m8UAoIAaINIazzqtrE6e5oofjRO7T1UETJBK4V49DI4qAmRyo0xxMAq+6y6LMirpi27yg/yz1oysORCV/zLICyq7ZklkSNlhxlMeckvIQ9q6G+KGJ+sv279wPI0jwCm4D3LMnfjur0qQlVuxywe16PZNAQ2THM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC6fXhhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC6fXhhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC30C4CED1;
	Wed,  5 Feb 2025 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763612;
	bh=pPW481xathx+9lEjQakqHzx1+r54h/O6cfzd9zCG/EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GC6fXhhCYzP+yWXqsRwnrpLkInvV6f8z1lVI1cnDPDAd/yKVD8DCyvuBVrelVbfZa
	 pr71Vp/g1DLx8dwujGYffuVAUIGsAZ1gsZsx65YoRTaW7PhZsNxjAlxd8K+hByvxfY
	 LOuuD5vRs/UmFsOdgs6bz+j4oQZi75vWkhJuuTYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/393] dt-bindings: leds: class-multicolor: Fix path to color definitions
Date: Wed,  5 Feb 2025 14:39:44 +0100
Message-ID: <20250205134422.784232688@linuxfoundation.org>
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
index e850a8894758d..bb40bb9e036ee 100644
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



