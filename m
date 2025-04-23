Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1B27FD48;
	Wed, 23 Apr 2025 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419665; cv=none; b=YQZ8L2IlRRizaoOCvnXmhOAQaTO7x+AnUK+LnoFkdS/9ZH6nUrLNSff/KMUXjTABWDIQDSU6o+FJrOaGrERPSMnMT5PLQLhguqRPA8yg3ZX8o/T9sMbrYpKecM2ETITBsRMvSiqgeGBEXkHZjcey+s3kffEpk+AdrJXCxvIqxLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419665; c=relaxed/simple;
	bh=gaihpRDXku+Optpp8tm0kRtmXhrvLMUsyezJKfp380U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo7A+F8Y9ANCx1m5Oapotc5BAO9nKGPDdqWfRI0SoSIkz9wuSSqWxk3eW3S2BlQWVjvYlqygfgRHqigw3DZnLs7MSKbHY90kOrCR/e2QlRVrEUPuNJdRT8Yqzxetok5V2130pN8H5zg9MlRdSYYQ4bUZtON5hwuCsi7t3kZ0VGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xif4yMQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xif4yMQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D910C4CEE2;
	Wed, 23 Apr 2025 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419665;
	bh=gaihpRDXku+Optpp8tm0kRtmXhrvLMUsyezJKfp380U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xif4yMQ1PUfq0Gs9STvlJXtCW4D68qmcEQrr1FokDkWWmDMFbjE4XAZ51cQGr6D4X
	 5badQlRuXcykLxf41aoOtxD+YcIJd8WmUrHKXxbnHtZHndRd7pkx5KsAnFdKxQjrdb
	 m6BC3KG6f1oFQcNW2GgaI4176p+ff3oWKf304e9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/223] dt-bindings: soc: fsl: fsl,ls1028a-reset: Fix maintainer entry
Date: Wed, 23 Apr 2025 16:41:51 +0200
Message-ID: <20250423142618.719698835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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



