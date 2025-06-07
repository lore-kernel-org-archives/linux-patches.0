Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5FF1F8723;
	Sat,  7 Jun 2025 10:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290919; cv=none; b=ObuwKaSvIEYPLh38+QXuUq6xN5/k/rLDmgh3hUfd5oQNMV5gz/6DJPRTmtgh2PdGfQNBzumbLFK4rAgPF6UW7hgaaEmyHfWCMcsjk5oYl7lcue/lF9O2UrvQQPSs+C2STEZ1L7yQ8qxNtbwZMrw2qz5+UgHAqt0810z5IBjG1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290919; c=relaxed/simple;
	bh=sbItSKibkDTEXKtcUYcyDTlHuyn4WSdz+s/XVXp3sDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4tB3BdIBjiNBWeqVo0I5OSgSMABpdFi8bWZAUD9oW6SwLoJYZkgJPjbM7y/tF/pTfE7xafja0q1cBKGiuUsprjXxPXq0h99tdoQcC/wTEAUKjoicuZEH3JPTi9TIeOGlhNkuadAAGJWLV8N8bE2zAnekaEFNsdafmBfeGDJnK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhpk8uil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhpk8uil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AA9C4CEE4;
	Sat,  7 Jun 2025 10:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290919;
	bh=sbItSKibkDTEXKtcUYcyDTlHuyn4WSdz+s/XVXp3sDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhpk8uil95bdAuzUwhTCoh9oqns5sYMRVLWsOjmg/ZMEsAuoFFL1Fal4KCJMzl34P
	 PxyYQWlxcStKBWOeDdrmB9gynVH3KRt/LCbUNyoRgi4560z16cOS2rNbR+4uTUwQf1
	 V4gZqt0d2D0EV+DqE4yToj2lPeRrrBkm0i6e1hNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 22/24] dt-bindings: usb: cypress,hx3: Add support for all variants
Date: Sat,  7 Jun 2025 12:07:53 +0200
Message-ID: <20250607100718.911865818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 Documentation/devicetree/bindings/usb/cypress,hx3.yaml |   19 ++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

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
 


