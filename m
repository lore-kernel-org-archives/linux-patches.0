Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9523208;
	Fri, 17 Oct 2025 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713229; cv=none; b=DTHO4cJCIQvkaNeUFPq3M0C+EQpOmqHdyfEa4OzM9v7uYrhD4lTuSjMw8P1OjeF6iNLlvT5QB+zj1n7J7lKoU75EvTcVZ3g7U0whXEyFLaGfdhM3Tz4YIfREWmbeksRDPaGFy0FHK27o4VZDo4o/LWYl42jmZFvZcDmpdjBCbNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713229; c=relaxed/simple;
	bh=lGECs1ZFfda0ijWqJnRBKbqTh7Ahap7VMdoyZb8KQ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQov04I364BOvyxLMh5Wb7vsQ2djlaSP1hOKvkj5TN5iG+SgPdeBWmNPHGul+B9eh7PxnPw5eId+fn1Q6BOnW6Of7YuKezBjzJfn17VbeY3WtT0EHL5RvrqOC0UhfW5WG77K/OoNoAsLn0OEbjZh30pyp4zrTPsjkH4LC2LmSJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bphlc67j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bphlc67j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF61AC4CEE7;
	Fri, 17 Oct 2025 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713229;
	bh=lGECs1ZFfda0ijWqJnRBKbqTh7Ahap7VMdoyZb8KQ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bphlc67jKmQnIm9SlzNvv0H7+BtApl/vanzYe4AL4/v0VbHVnZ54JMgEO6Y/89FBW
	 oiMOmCy/4N5QG0DSc83bN/BEciDYu4RCrUo72oEVwH5uZJB4BY4K7yuIB4bVBeH6mc
	 mDUVmx/8nZR5+ym3kqPINDaEIToeIXd2vJ/BSwBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 059/168] dt-bindings: phy: rockchip-inno-csi-dphy: make power-domains non-required
Date: Fri, 17 Oct 2025 16:52:18 +0200
Message-ID: <20251017145131.196136583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


