Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4887C8EB;
	Wed, 23 Apr 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419897; cv=none; b=d7zqemlO28K5HvFN4IaTcchfJGY5BAofLN2qqg8MmJw+UcqdnbAtsgrJj2/AXEh94p8mxs2B0o/3r2f6GnlQSZda3D98o7qlFZKs3UwvELdB0n7YUjHO9zDEqPRnHCTiXg1tfU4KUpI0Z1/fgNYZH+20a5gisbO1kmvcbd+7FMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419897; c=relaxed/simple;
	bh=N8a9FN8L16Pxj3IxMJhYU7hiywIaa7BuAouDQXEpLiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5URN871GLI8PBw0LLArqurWw0qzsHwFSbXVz6pu5YIKDYFnJD5CqL3ciMVoo6eQimj62RVwCIxAiKYucXZ0ejjb6MWpq+CKdFHYbfXDTh2HBzZrQ0cP5MAGv03QuAA+rPflkjke+j7WM1nBQBNLOnk7CCyYJZ14DAg/lIc+vM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQqgl9dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQqgl9dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F05DC4CEE2;
	Wed, 23 Apr 2025 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419897;
	bh=N8a9FN8L16Pxj3IxMJhYU7hiywIaa7BuAouDQXEpLiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQqgl9dXr1lNN+H2CKcNHZKoOxmvUQ9ddfAlhgmLei4/oCumBohPl/RhlZ9v/fOme
	 e3JVor8Gu0c+PcnjSlBFsLC9zxGAu2o4LUme8E5Fq7phiUgHmY0+oVBeQ6MWiREMgq
	 p60zZhbtYMaHTekb7AVgty4X3d/4UoN1BKyJo92Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/241] dt-bindings: soc: fsl: fsl,ls1028a-reset: Fix maintainer entry
Date: Wed, 23 Apr 2025 16:41:44 +0200
Message-ID: <20250423142622.149730455@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d5f49921707cc73376ad6cf8410218b438fcd233 ]

make dt_binding_check:

    Documentation/devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml: maintainers:0: 'Frank Li' does not match '@'
	    from schema $id: http://devicetree.org/meta-schemas/base.yaml#

Fix this by adding Frank's email address.

Fixes: 9ca5a7d9d2e05de6 ("dt-bindings: soc: fsl: Add fsl,ls1028a-reset for reset syscon node")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/185e1e06692dc5b08abcde2d3dd137c78e979d08.1744301283.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml b/Documentation/devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml
index 31295be910130..234089b5954dd 100644
--- a/Documentation/devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml
+++ b/Documentation/devicetree/bindings/soc/fsl/fsl,ls1028a-reset.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Freescale Layerscape Reset Registers Module
 
 maintainers:
-  - Frank Li
+  - Frank Li <Frank.Li@nxp.com>
 
 description:
   Reset Module includes chip reset, service processor control and Reset Control
-- 
2.39.5



