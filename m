Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642E02EF2B0;
	Tue, 17 Jun 2025 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177129; cv=none; b=Yhc3Fwc7ePZhhVtFhG7P8AnoxE55fvTs3Hk4UfHhc1I1eu7pF03oBFzPcmzpDwYb/Jh738GtawLt7h6WUsVRGTUqPzUqAWx69LFfOXPVPsDbzyaox+P5cMrPSfl7blMW4vCJO0B18/0Ili9dJur6zxyGnS7RZ7w28qc3J9RXvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177129; c=relaxed/simple;
	bh=yv/kf/4U1RwoxFZpUvKXyArVINh9Ht1z7jcOisSn3Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIIRUPqF0guvU9ts8LzUjwTkItKm+XnD5/nCjQIKytC0FEyPeslBlNc722LCs/6jHQleXc/6Bvic8mxAPSDAGgRnw7Bpd7srBnLW9aMDIkKf/EFdA0ER4oRRQXVYno8Mx8SNwLeQktSI+GxGGk7e0/m+09SEWVXhwsfpLZd3RF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqsRxLym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqsRxLym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BD1C4CEF0;
	Tue, 17 Jun 2025 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177129;
	bh=yv/kf/4U1RwoxFZpUvKXyArVINh9Ht1z7jcOisSn3Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqsRxLymAw1gVYXQ+VYJ8uvVgpgDy8n4SGm6lg/xpD7rDMZCIJuhkbUHQPVNY18f5
	 pB4TXyAmdg72nuSszK1gc0xpZ9A2VXw3t9K4VrOuO1Ub2YLldeng618QOy3J4nmtN1
	 PF6TzwuOzdEwOYkOKcrhpviBwKipAKqN6fJfskXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 264/780] dt-bindings: soc: fsl,qman-fqd: Fix reserved-memory.yaml reference
Date: Tue, 17 Jun 2025 17:19:32 +0200
Message-ID: <20250617152502.204686231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 1090c38bbfd9ab7f22830c0e8a5c605e7d4ef084 ]

The reserved-memory.yaml reference needs the full path. No warnings were
generated because the example has the wrong compatible string, so fix
that too.

Fixes: 304a90c4f75d ("dt-bindings: soc: fsl: Convert q(b)man-* to yaml format")
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250507154231.1590634-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml b/Documentation/devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml
index de0b4ae740ff2..a975bce599750 100644
--- a/Documentation/devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml
+++ b/Documentation/devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml
@@ -50,7 +50,7 @@ required:
   - compatible
 
 allOf:
-  - $ref: reserved-memory.yaml
+  - $ref: /schemas/reserved-memory/reserved-memory.yaml
 
 unevaluatedProperties: false
 
@@ -61,7 +61,7 @@ examples:
         #size-cells = <2>;
 
         qman-fqd {
-            compatible = "shared-dma-pool";
+            compatible = "fsl,qman-fqd";
             size = <0 0x400000>;
             alignment = <0 0x400000>;
             no-map;
-- 
2.39.5



