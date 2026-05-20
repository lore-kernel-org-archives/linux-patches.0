Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED9352022;
	Wed, 20 May 2026 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294875; cv=none; b=FpjNluW2NJLoEnm15mZcp228n0WnOP9WGMJR5tiS6t6FXUpZPugq+FlnQNYatiePk9LXW1y5qdYR91LXBTUMMjTwTMMeNnYYD7QruEBpFgKc09qFhC6MoC4ooDUBzZWsLJQArXqrxJOIdy/ZOm/uSMm9CQuSMzo5ZskRuV4HtQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294875; c=relaxed/simple;
	bh=M4JieUn98nx8/7GPnT2Kggtr2ZVJK6XgfEm4N9fJ7Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoQH7nirx48sjrbRrnPvFbmZhw0C0XsZHr83ESeo/iT6c6T5eIIAeCwMUoMN0i1HA79MjWTa0yjQz40tom0+P5yjeY7wtatGxVV/pooN/VtTGjFRz4Lp4FY564Cudk+LfpbSQbDzsBCIELAKUU4lcCxYCrmiNiFjfWrYc5Veml8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCBqtty9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCBqtty9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1B31F000E9;
	Wed, 20 May 2026 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294874;
	bh=BLJP6bOEFjF86kvOze14/dG1dJ/eUa2/MLY1ykzrWLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCBqtty9pVpyZkqWQpXab3a3qqMDIYeMuSGsfolGgJpfvl+58t3T9zB4TDB7CH4Cj
	 RfcX2cVslSiKedBIIwAbJY9VJDj65M3WEkMxopN3TvmnjM75llG92WjKwiNgDbiVHY
	 JMD6G7nIXW9FGrjsFdQ3+L2pShUBC3TuVLe7J35I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0204/1146] dt-bindings: net: dsa: nxp,sja1105: make spi-cpol optional for sja1110
Date: Wed, 20 May 2026 18:07:34 +0200
Message-ID: <20260520162152.885935287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 600f01dc4bd0c736b3ffea9f7976136d8bf1b136 ]

Currently, the binding requires 'spi-cpha' for SJA1105 and 'spi-cpol'
for SJA1110.

However, the SJA1110 supports both SPI modes 0 and 2. Mode 2
(cpha=0, cpol=1) is used by the NXP LX2160 Bluebox 3.

On the SolidRun i.MX8DXL HummingBoard Telematics, mode 0 is stable,
while forcing mode 2 introduces CRC errors especially during bursts.

Drop the requirement on spi-cpol for SJA1110.

Fixes: af2eab1a8243 ("dt-bindings: net: nxp,sja1105: document spi-cpol/cpha")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260409-imx8dxl-sr-som-v2-1-83ff20629ba0@solid-run.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 607b7fe8d28ee..0486489114cd8 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -143,8 +143,6 @@ allOf:
     else:
       properties:
         spi-cpha: false
-      required:
-        - spi-cpol
 
 unevaluatedProperties: false
 
-- 
2.53.0



