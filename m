Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC48142E86;
	Wed,  5 Feb 2025 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763510; cv=none; b=M1YhFf+ZsiD19NjrZuREj85+1zULhaWJLni40GEocmSk/qXbif0knhm+l7wQRm8CTT61iww0BLbqBUJPzG6Z8feeokIM5lPOSo8muqJeTKS6GgnXq17lWCtSIfcEx/FfYCVhsAbTbSuJX8VFoiOyR4uHm/A0BxMurZJBLW/bVTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763510; c=relaxed/simple;
	bh=qz3h06YDCywDp48nd09K6Jcy3vXuPMS7b4Q+gzWxbo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1BeTupRWvSiWdXfKieJAHH6J2GMVid8IJp0Ba8Hog8shXAY3LtxwwThPp0qUC1FHYGlcpeK+C29B10swE5SDqqEqu7+OpD/cZ6b2gZKMFgMEdqKHWPeAh/uy9gz/3rTWcaZ5drQa+m1UNC5VcXQIBayzcJfgKYBovl3MoOKwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ey2IDIyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ey2IDIyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DA9C4CED1;
	Wed,  5 Feb 2025 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763510;
	bh=qz3h06YDCywDp48nd09K6Jcy3vXuPMS7b4Q+gzWxbo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ey2IDIyPv55xNaGqO2XIqWEtQ2qgwfZg7X4HV55//DQVJhMi23UKTBwGkemh8tIHs
	 9umlmpR7PtKhIgCucNEvdYwWjqXwQ+82jzmhvqkq0OxxZnZD3w+90K2CKRiSPNU2I+
	 Pdb/vszljzUJ+KW2YfGLuoGp7wtv/+bh8V07SUig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/393] dt-bindings: mfd: bd71815: Fix rsense and typos
Date: Wed,  5 Feb 2025 14:39:54 +0100
Message-ID: <20250205134423.162542329@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 6856edf7ead8c54803216a38a7b227bcb3dadff7 ]

The sense resistor used for measuring currents is typically some tens of
milli Ohms. It has accidentally been documented to be tens of mega Ohms.
Fix the size of this resistor and a few copy-paste errors while at it.

Drop the unsuitable 'rohm,charger-sense-resistor-ohms' property (which
can't represent resistors smaller than one Ohm), and introduce a new
'rohm,charger-sense-resistor-micro-ohms' property with appropriate
minimum, maximum and default values instead.

Fixes: 4238dc1e6490 ("dt_bindings: mfd: Add ROHM BD71815 PMIC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/0efd8e9de0ae8d62ee4c6b78cc565b04007a245d.1731430700.git.mazziesaccount@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/mfd/rohm,bd71815-pmic.yaml       | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml b/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
index 05747e012516e..ab26b1bd567fd 100644
--- a/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/rohm,bd71815-pmic.yaml
@@ -50,15 +50,15 @@ properties:
     minimum: 0
     maximum: 1
 
-  rohm,charger-sense-resistor-ohms:
-    minimum: 10000000
-    maximum: 50000000
+  rohm,charger-sense-resistor-micro-ohms:
+    minimum: 10000
+    maximum: 50000
     description: |
-      BD71827 and BD71828 have SAR ADC for measuring charging currents.
-      External sense resistor (RSENSE in data sheet) should be used. If
-      something other but 30MOhm resistor is used the resistance value
-      should be given here in Ohms.
-    default: 30000000
+      BD71815 has SAR ADC for measuring charging currents. External sense
+      resistor (RSENSE in data sheet) should be used. If something other
+      but a 30 mOhm resistor is used the resistance value should be given
+      here in micro Ohms.
+    default: 30000
 
   regulators:
     $ref: ../regulator/rohm,bd71815-regulator.yaml
@@ -67,7 +67,7 @@ properties:
 
   gpio-reserved-ranges:
     description: |
-      Usage of BD71828 GPIO pins can be changed via OTP. This property can be
+      Usage of BD71815 GPIO pins can be changed via OTP. This property can be
       used to mark the pins which should not be configured for GPIO. Please see
       the ../gpio/gpio.txt for more information.
 
@@ -113,7 +113,7 @@ examples:
             gpio-controller;
             #gpio-cells = <2>;
 
-            rohm,charger-sense-resistor-ohms = <10000000>;
+            rohm,charger-sense-resistor-micro-ohms = <10000>;
 
             regulators {
                 buck1: buck1 {
-- 
2.39.5



