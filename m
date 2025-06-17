Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896C52E92CD;
	Tue, 17 Jun 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175840; cv=none; b=cBdstHWEorJqkUGGZVuNCgNIpJQvqF2WxD63ioiwgtyNxpkau91QZttPCqapioNrpIOcNEMnptkS1YKWrQqaKu83wWdmMhPBY5/h5nkCFVWSEMnjNGjPD6ISNG3PH7TxxKWZJ1eZ/nYB0UBZ1a5pkjtq33ulJaZzw1zqPIayHhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175840; c=relaxed/simple;
	bh=yAzAa9Mg/zQx4IdnR9yg0NGCixpmxoKBTCyfiyTDn6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYhbnkwAOk/c6oNjpXbCr0mlInUxnNHwfLXUuiDh3OPkccT89KOc1Z3WBPUjg6To+sRtGV021He070wWeUOhQEEZc7izur4P8ssuulYtAXrKQs4VKt/B5JvuGkUvrpUu8bwZ4h9efxnC5ESlKG4VYfI/LdNWPwpUYl4A1fHgOsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVJV1S0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVJV1S0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D11C4CEE3;
	Tue, 17 Jun 2025 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175840;
	bh=yAzAa9Mg/zQx4IdnR9yg0NGCixpmxoKBTCyfiyTDn6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVJV1S0DUfJGQSMUbCOq8+xFsuo5FjzXX0IZzvrmlPkgyzHJZJjj14wzMcfB97rBi
	 a/WmPz4g51lopU6yu8g8Ql7HSEFJF2Sc98cN2B+z8I1D4t+0MqUzV8yQEK1AMgqCKX
	 3YvwWA+fOwVtp8PNUDdlTEknx6N+eRNi+KJhUQ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/512] dt-bindings: soc: fsl,qman-fqd: Fix reserved-memory.yaml reference
Date: Tue, 17 Jun 2025 17:22:14 +0200
Message-ID: <20250617152426.429976092@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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



