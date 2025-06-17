Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003592EB5C5;
	Tue, 17 Jun 2025 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174199; cv=none; b=ug/LU6JhfTTlwIv2sAJfG8lBgMJ0t/E9DWhOvTYnBLorO09osJjXOBP4NFKwm7c8V9vFo+DwdshvVyvKWQOhOP6n3dpFD8CEIF4nnUHh+O9QulbXuwU1aviZDlhZo5wpoX0sb4Zc/VcQVOlLBe+Nkchvswz2kAdfhdHc3IaLUSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174199; c=relaxed/simple;
	bh=olbo6HOFBsoBO0ywJyTwPfwNhi23H10pG4qERW3F2A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxe004oSdTCeJ90KRXOSgQGInjt1cHAt2/SdVcTr06gBo/kxJhddrC1uh73q+nPUYPloC3UwMUd9ZtEk+73/eepVMazwSEgaL08fLTBY3fLmog6KTy6U5JB+4bbfbbOZqOTy0o22NoBfCU2ur0ngXwH8Q53OZfQ0TvojV9cXTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBwtOfvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBwtOfvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE5BC4CEE3;
	Tue, 17 Jun 2025 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174198;
	bh=olbo6HOFBsoBO0ywJyTwPfwNhi23H10pG4qERW3F2A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBwtOfvXBGA6Y447VqMbOMzVj88yLaAKNPR/XNMr8JK5xd21TwiKdDndUUz1JWhbC
	 xBc2Z5cZ8d2ISYkD0aPq83BeKBXdEoWn7VN/90YyyztmSZiHyhn3xe4SCwxaol/FBK
	 LdoCMsa2JoHztsgxLkaZi91KJsVLdjk3bMYZuQQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 015/356] dt-bindings: usb: cypress,hx3: Add support for all variants
Date: Tue, 17 Jun 2025 17:22:10 +0200
Message-ID: <20250617152338.850217100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>

commit 1ad4b5a7de16806afc1aeaf012337e62af04e001 upstream.

The Cypress HX3 hubs use different default PID value depending
on the variant. Update compatibles list.
Becasuse all hub variants use the same driver data, allow the
dt node to have two compatibles: leftmost which matches the HW
exactly, and the second one as fallback.

Fixes: 1eca51f58a10 ("dt-bindings: usb: Add binding for Cypress HX3 USB 3.0 family")
Cc: stable@vger.kernel.org # 6.6
Cc: stable@vger.kernel.org # Backport of the patch ("dt-bindings: usb: usb-device: relax compatible pattern to a contains") from list: https://lore.kernel.org/linux-usb/20250418-dt-binding-usb-device-compatibles-v2-1-b3029f14e800@cherry.de/
Cc: stable@vger.kernel.org # Backport of the patch in this series fixing product ID in onboard_dev_id_table in drivers/usb/misc/onboard_usb_dev.c driver
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Reviewed-by: "Rob Herring (Arm)" <robh@kernel.org>
Link: https://lore.kernel.org/r/20250425-onboard_usb_dev-v2-2-4a76a474a010@thaumatec.com
[taken with Greg's blessing]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/usb/cypress,hx3.yaml  | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/cypress,hx3.yaml b/Documentation/devicetree/bindings/usb/cypress,hx3.yaml
index 1033b7a4b8f9..d6eac1213228 100644
--- a/Documentation/devicetree/bindings/usb/cypress,hx3.yaml
+++ b/Documentation/devicetree/bindings/usb/cypress,hx3.yaml
@@ -14,9 +14,22 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - usb4b4,6504
-      - usb4b4,6506
+    oneOf:
+      - enum:
+          - usb4b4,6504
+          - usb4b4,6506
+      - items:
+          - enum:
+              - usb4b4,6500
+              - usb4b4,6508
+          - const: usb4b4,6504
+      - items:
+          - enum:
+              - usb4b4,6502
+              - usb4b4,6503
+              - usb4b4,6507
+              - usb4b4,650a
+          - const: usb4b4,6506
 
   reg: true
 
-- 
2.49.0



