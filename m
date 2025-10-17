Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70173370F7;
	Fri, 17 Oct 2025 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714304; cv=none; b=Oiob6yZrdx+6DUOg/nYVyVb83skMJvqmdRtb9GzY1xSALCxXLNPzcHtVs/iKZBe20DOgemJOMlxaPqWaUEHzs5BIxwPBXE94Fx1kDed2C+EUoOKzE7iD2PKiaUd92/tpzTzTlpf0sKr8ZhcgLVYKkb1seCj58xqdfcYX3/owxxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714304; c=relaxed/simple;
	bh=UPm6lNSD51aJiDUdmdHAJlA1x81kKGWBd+VnIgGngSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/GDFw7ZEIUl93yXfu9gRllRnuFZn2hMQN5J5MhBO0x7ACwaNRsgPsqBknYfjfPwdqFfauvgXbpWvwqDwRzJtbiazICWpRPk9vWlxF3o5ozcK0n+MmMtMo/vixRi8vQX3AQZi0PKG+LrfXiqtK868BteCJaHcuvfEXkFyD0YyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LDMoIIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LDMoIIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F44C4CEE7;
	Fri, 17 Oct 2025 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714304;
	bh=UPm6lNSD51aJiDUdmdHAJlA1x81kKGWBd+VnIgGngSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LDMoIIfUYBGAHkWegJ0RyTUL/L49jkt8XM+CVSWIwK/G1nKC+iBkQetdPAU/NfXa
	 2KqSYFvVa05Uhjc9mdFO8KCh+lkwlPhLBKPmCAD816r8kD757wYJvofAJJ0CVbwpvf
	 067k4KunLzuTY99LwrdU6hAcXuAi8253BDj/vbrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 097/277] dt-bindings: phy: rockchip-inno-csi-dphy: make power-domains non-required
Date: Fri, 17 Oct 2025 16:51:44 +0200
Message-ID: <20251017145150.674452651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Michael Riesch <michael.riesch@collabora.com>

commit c254815b02673cc77a84103c4c0d6197bd90c0ef upstream.

There are variants of the Rockchip Innosilicon CSI DPHY (e.g., the RK3568
variant) that are powered on by default as they are part of the ALIVE power
domain.
Remove 'power-domains' from the required properties in order to avoid false
positives.

Fixes: 22c8e0a69b7f ("dt-bindings: phy: add compatible for rk356x to rockchip-inno-csi-dphy")
Cc: stable@kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Michael Riesch <michael.riesch@collabora.com>
Link: https://lore.kernel.org/r/20250616-rk3588-csi-dphy-v4-2-a4f340a7f0cf@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/rockchip-inno-csi-dphy.yaml |   15 +++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/phy/rockchip-inno-csi-dphy.yaml
+++ b/Documentation/devicetree/bindings/phy/rockchip-inno-csi-dphy.yaml
@@ -57,11 +57,24 @@ required:
   - clocks
   - clock-names
   - '#phy-cells'
-  - power-domains
   - resets
   - reset-names
   - rockchip,grf
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - rockchip,px30-csi-dphy
+              - rockchip,rk1808-csi-dphy
+              - rockchip,rk3326-csi-dphy
+              - rockchip,rk3368-csi-dphy
+    then:
+      required:
+        - power-domains
+
 additionalProperties: false
 
 examples:


