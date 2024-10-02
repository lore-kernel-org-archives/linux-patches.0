Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECCB1D040D;
	Wed,  2 Oct 2024 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880580; cv=none; b=olSIDYZilbD7zhWy61oKoMUEXUsMJksbolCIpIYpLb40BwvN5GYkef77OePz0cN1K4fXOZFMdNioHuKBYaKNKhVVyYT/nnJ9OliGLrCM/IyAFll21TIHWqr3JVk+jd/Rzw+nm0IXpLRrlXR28cAPR41z/bcjtMWXOYPmoC1mtA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880580; c=relaxed/simple;
	bh=kIjRvqnnEC3kETJPKb6N7L9Qk/ohn6YIUcjmuqS2gOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PliiWo7A3XePu619sbaTiLtHDBSCsdwW/zFoPFSP+mE/88ziQxvBtLxh8tkzLZafJfQTRp3zGHkO2er2JIS7uwqZgSJmf2Bi9xBjt3u3/7dTByT6+H3iVRVqi7KLOlp+XHvMg0hkYZFjRKND8y2p1dP24rsQDYbKE/6fLyacd4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/izECPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/izECPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15F9C4CEC2;
	Wed,  2 Oct 2024 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880580;
	bh=kIjRvqnnEC3kETJPKb6N7L9Qk/ohn6YIUcjmuqS2gOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/izECPdhKrrOZJ6DSela++rcgHoHr8moTo+eiKSIm4P73FUxZ0tRC4+LsWbIz7yu
	 FJ/stNhEh1ZkYRpjESCsZ34ONvOgkRnDU6ofJlnB+qbvTSm3z61PIVGmeFqthKhu7L
	 GL4Qi4vTZpnnoQiCB9URpKNeVgXC+WyemyezfjAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Han Xu <han.xu@nxp.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/538] dt-bindings: spi: nxp-fspi: support i.MX93 and i.MX95
Date: Wed,  2 Oct 2024 15:02:19 +0200
Message-ID: <20241002125812.177119782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 18ab9e9e8889ecba23a5e8b7f8924f09284e33d8 ]

Add i.MX93/95 flexspi compatible strings, which are compatible with
i.MX8MM

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Han Xu <han.xu@nxp.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://msgid.link/r/20240122091510.2077498-2-peng.fan@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 12736adc43b7 ("dt-bindings: spi: nxp-fspi: add imx8ulp support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/spi/spi-nxp-fspi.yaml  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml b/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
index 7fd5911454800..4a5f41bde00f3 100644
--- a/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
@@ -15,12 +15,18 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - nxp,imx8dxl-fspi
-      - nxp,imx8mm-fspi
-      - nxp,imx8mp-fspi
-      - nxp,imx8qxp-fspi
-      - nxp,lx2160a-fspi
+    oneOf:
+      - enum:
+          - nxp,imx8dxl-fspi
+          - nxp,imx8mm-fspi
+          - nxp,imx8mp-fspi
+          - nxp,imx8qxp-fspi
+          - nxp,lx2160a-fspi
+      - items:
+          - enum:
+              - nxp,imx93-fspi
+              - nxp,imx95-fspi
+          - const: nxp,imx8mm-fspi
 
   reg:
     items:
-- 
2.43.0



