Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD023272E56;
	Wed, 20 May 2026 18:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301933; cv=none; b=K7Oo8zx9ESYFCCGj7uZOxg07q6owW74dFYL3nUVYx2jDtbH8eD4cb5DF2AVfzZylxop3N8PI7/NiAUZLk4qzuKBkumstRVJ92eHyvE6rsYANtNEN23jMrbN/ng5fYfulTzpHPTEGJP6BLDmQiJSLYc0gQoR0FspGUIM0I+MiMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301933; c=relaxed/simple;
	bh=F1sOLH8Fo6GRzkSFiGAzE2dia44St03S3MeVkNu5ilQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCbjd/Q9aRjJ0kIAI3vxJd3RL4mB/1yNHcd3221fVnLY9EqFXQpUqicM+hhfuCnFTfsiWzGJsspoD3p8UhcfKRWhyE/Jgh0x2dj2i7CrKn+4glEtXXt0XtWbiPJ+1D4pvCrIh4J3/XrSvzAvblo1z2fQOjHRh1eo6gEAjvmYJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBomriQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBomriQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164441F000E9;
	Wed, 20 May 2026 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301932;
	bh=zlR3DbcRUIFrukFge0gw3wEzZGOYyNmDJoB1keh2rRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBomriQyBHdy0DWjZA/ozvQIqS0dhwZdwLczD/czCdbR3KBqn2LL6gRqqwE57JNM5
	 Daoif/6/oyfpY32SlmjKeDT8AogBp2sF8oGKn3lFSJsk5Mck/4G26kdPbYlMRZJSEi
	 MUecDe2Tncp9DcJFFqwVwRkYv3Yiyv2Hc1y2zkb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/508] dt-bindings: net: dsa: nxp,sja1105: make spi-cpol optional for sja1110
Date: Wed, 20 May 2026 18:18:16 +0200
Message-ID: <20260520162100.189220161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4d5f5cc6d031e..155719453b704 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -129,8 +129,6 @@ allOf:
     else:
       properties:
         spi-cpha: false
-      required:
-        - spi-cpol
 
 unevaluatedProperties: false
 
-- 
2.53.0



