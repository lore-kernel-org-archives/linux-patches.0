Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1FB21C182;
	Sat,  7 Jun 2025 10:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290934; cv=none; b=tQK5CDzjMqESA0h3Jy5z2Md3nwu6RBHpR1uhYiaY7deTtiRmxyGrpww1kEleMLpV16AXmV9D6HEc0xjIaph3QUllWNzqsy7lkZGJMt7FRfh0sG4iro/5Iovlx+neGAHRLVDFXT+sHmC8Gh5W2xaB6O7oSj1lnzXVKt0f27XfKtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290934; c=relaxed/simple;
	bh=si81Xuk42NFbnSVZ+91BAnUCeKCv/D0yyWb64C+BAhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAFMXTeeDepqF8nHIxRPsBhcAsZY0NEVae27+EpU5mhhyUQq5YP1rVtuZOsYx4CgNZZfiI5hkwLBY0LBqUPf4UGp9/UQFoAhKwXt2uK8PHEKKBnyOBetKD90FuORKvDjLYDEFuPD/1qh987fmhSVeRXGsqY/NCEJ4yY0x/eH9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V399PSCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V399PSCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199EBC4CEED;
	Sat,  7 Jun 2025 10:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290934;
	bh=si81Xuk42NFbnSVZ+91BAnUCeKCv/D0yyWb64C+BAhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V399PSCTTyZwl95yn6VQ/hlqEKdxyyQ/s6jFmYe/z7FzRynJFHCgcISEloVQ2MiVl
	 x0DkjRNOovH9IYRPCWY8rTyA6bBS5PBX8jlW7rQzka+J62Ygvqvb+hSV6tw5nsKsHU
	 O0WmyPosjpBJgwh1EXpOkRdX9ZVaiTp5p+rhA3hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 23/24] dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property
Date: Sat,  7 Jun 2025 12:07:54 +0200
Message-ID: <20250607100718.950411107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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
@@ -58,8 +58,7 @@ properties:
   fsl,phy-tx-vboost-level-microvolt:
     description:
       Adjust the boosted transmit launch pk-pk differential amplitude
-    minimum: 880
-    maximum: 1120
+    enum: [844, 1008, 1156]
 
   fsl,phy-comp-dis-tune-percent:
     description:


