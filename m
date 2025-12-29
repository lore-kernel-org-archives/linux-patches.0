Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5451B334C10;
	Mon, 29 Dec 2025 16:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025954; cv=none; b=GiG+xujnzCTyRS7nPQXqFH4NS+wGaBqXU8xtB0N4yvJ8f+v2orND+94YfYqRe5ISCA9bCfY0KVJjjNcdqEHRnU0oBEZJSG8JhC+yTaIGhGldXHcSUxvC4w22lSL1a6Zp0DTFzwToVg7ZzjKisXHTNns0R4DAVaroI/A9G2QNfQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025954; c=relaxed/simple;
	bh=ZGs1wGRffliGte0amoN2FTJ09JD81JNFfa0PLAaXWpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCPm5OyPIA4D2cM8Prxerq/vOaAhTBIaNDh47Ju+64ivo40CyV3gIZgbF4oZqqlvG65mOJZqqBmIXsv9hdW6aYVHRo/IY+oBr7/I8fCXasxtdo91vAPTyD9ZmartIWbwqMKvUJGHPOsWLARcRFXcuyYMeR1pIreCmyOYvcUVlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPm3LAS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPm3LAS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA9FC4CEF7;
	Mon, 29 Dec 2025 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025953;
	bh=ZGs1wGRffliGte0amoN2FTJ09JD81JNFfa0PLAaXWpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPm3LAS6qkIi0+1HNGbDS4OxgU2TmQqhIeByzHX0eB2i9CFmYHckxk7WFh/pjT6O5
	 mQjd89EzpTM1+1O9A5SZU5RLkgaenvqObEXTOgifC5bEddwPMtR9jwDYE1ixufq4vW
	 FPukbi6zYURS9AMUteFgPvPkSiNXW46WtJXTSl7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 396/430] dt-bindings: PCI: qcom,pcie-sm8550: Add missing required power-domains and resets
Date: Mon, 29 Dec 2025 17:13:18 +0100
Message-ID: <20251229160738.889415734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit e60c6f34b9f3a83f96006243c0ef96c134520257 upstream.

Commit b8d3404058a6 ("dt-bindings: PCI: qcom,pcie-sm8550: Move SM8550 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: b8d3404058a6 ("dt-bindings: PCI: qcom,pcie-sm8550: Move SM8550 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-8-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8550.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8550.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8550.yaml
@@ -83,6 +83,11 @@ properties:
       - const: pci # PCIe core reset
       - const: link_down # PCIe link down reset
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


