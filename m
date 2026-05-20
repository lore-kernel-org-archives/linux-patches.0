Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C8331220;
	Wed, 20 May 2026 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297808; cv=none; b=A3CeKjM7C86T/dp2fzG1vCB7j6gPl67OmT3Qrxk+wFIBPpL4fq8oUUB8rirDbg77LYDsoXIdUVnSQ+feKoxaJsMeXyIxjMzvWadmnWiHesE+BW5epf/iGQW4ONOL21Wi7L0nrFHzCyYKpw3hYNsdQ/uv3A9Ni76mHFRFtQIw6kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297808; c=relaxed/simple;
	bh=AqUSZ+N9MnklwzZsk4N6o3mIH/3xfDC3HQvPxBZQSes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJDnHoNupbJ22wnoBaMEGHol6EvbRv8U2oYZPWGyBsrGLvxlKcRwl5S3GCxg2fO6Q73T5a6fMh3enjDXyjU4TKb41mr+knRYUDkEV4h13NyIKxEewLaz38qPzwfXM/PZoJPVmuS03diyUniB/nyrEsBsa+ZjxQaB1fE8XNM0Wac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXEYK9FW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXEYK9FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574C81F00893;
	Wed, 20 May 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297806;
	bh=He/+PFplIzpyf6DPQV6lkdqu9s7+dhP6j32wOVjtPNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXEYK9FWUiQzy+BNaHwfw9weC/5rebkFcLtV63vuYZ7+9ASdeprXZWXfTmSwmNXMQ
	 klMrs50bxxLOtzE4FhbnifksXS0dYp8pbqFvqR60zppW+uXnNMRI5cmfxi23iuIICB
	 /Jgn1fUDscqlxvDIK/+9vLMZEB+YlwwBaWzbDCaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/957] dt-bindings: net: dsa: nxp,sja1105: make spi-cpol optional for sja1110
Date: Wed, 20 May 2026 18:10:52 +0200
Message-ID: <20260520162138.218991678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9dd914b0734c..941f9a25bbea0 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -140,8 +140,6 @@ allOf:
     else:
       properties:
         spi-cpha: false
-      required:
-        - spi-cpol
 
 unevaluatedProperties: false
 
-- 
2.53.0



