Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350F21CA03;
	Sat,  7 Jun 2025 10:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290997; cv=none; b=m9hbFt/IBfdIIerCFZmssZ9hZMaU5X9fQXkgifqf/T0K+qsXtbeY/qatknsKSaEd81kwxx3vJqKal58wqjMNyWl4QwKbsPWAWXC0TdfhFkrRLmIJHcGJz9YCVmUd0qsxMkKnGBbw5hqlX9GVuOnbRhh8jWr1Td2I6lf94aIGXnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290997; c=relaxed/simple;
	bh=92768wZlaxJnkjY1EpwPWQnm5lElzPYYKnNnDDvL+xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZajYsXys6irSPbETvwvAG9wV7Yvs+gZPbcxALP/C+Ej80d091w2I8wXbwpnXQTN2GfzHO/tQ3zdXzzibKnvN1nOT/ty5XWMadwSx6MsBmmNApdlPu7QUIRWKU37VUOqwLJ0ZSKiJSuoFHMvcDZ+FmTN30tYLw/J0/Ejd8bmAMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfB2CrVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfB2CrVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40389C4CEE4;
	Sat,  7 Jun 2025 10:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290997;
	bh=92768wZlaxJnkjY1EpwPWQnm5lElzPYYKnNnDDvL+xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfB2CrVL6TmxL1iNv2WJcbm+VC3LvoF6Noj6+H4y7rafpx8ek5JwyVFFslzGEFsZP
	 +yJDFRZMw1W8sYx6Sxjke0QYRMLbuLYqh5IFGg7PCgSFdZV0wSIMNDirPnNuw898O1
	 zatCDWagYVBwsgq0dOyX5Dj3c/55SZoeesTutRuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 23/24] dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property
Date: Sat,  7 Jun 2025 12:08:03 +0200
Message-ID: <20250607100718.606523750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 5b3a91b207c00a8d27f75ce8aaa9860844da72c8 upstream.

The ticket TKT0676370 shows the description of TX_VBOOST_LVL is wrong in
register PHY_CTRL3 bit[31:29].

  011: Corresponds to a launch amplitude of 1.12 V.
  010: Corresponds to a launch amplitude of 1.04 V.
  000: Corresponds to a launch amplitude of 0.88 V.

After updated:

  011: Corresponds to a launch amplitude of 0.844 V.
  100: Corresponds to a launch amplitude of 1.008 V.
  101: Corresponds to a launch amplitude of 1.156 V.

This will correct it accordingly.

Fixes: b2e75563dc39 ("dt-bindings: phy: imx8mq-usb: add phy tuning properties")
Cc: stable@vger.kernel.org
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250430094502.2723983-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/fsl,imx8mq-usb-phy.yaml
@@ -63,8 +63,7 @@ properties:
   fsl,phy-tx-vboost-level-microvolt:
     description:
       Adjust the boosted transmit launch pk-pk differential amplitude
-    minimum: 880
-    maximum: 1120
+    enum: [844, 1008, 1156]
 
   fsl,phy-comp-dis-tune-percent:
     description:


