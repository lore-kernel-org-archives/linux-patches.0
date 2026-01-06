Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD13559DA;
	Tue,  6 Jan 2026 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720531; cv=none; b=e0WjHCu4x9qmJd0Ywq3aJwCLTP3uxE+df3f8uyemMzVPD57A4Rm7DPTluK20WDbY9Esq4nk1/e9eUuy5sJB3vIMWe2kVLNlG8BZF1AXd10ONR7harCvHXhAN6YMBHnGNH1AuPQ5G0YUuVJPJZJP5QqR/fTL3d9j+/ww+otMp0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720531; c=relaxed/simple;
	bh=HHAQ2A38BHjBHqLRhhdL8lBSiT5A4ITbAbiqZStpRpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLWuWbz+PkYQr0+9f5E0RViPc8w196rz4Ytt+7fJtYUhGiq2k21ZntE2CKJTanqJ2EcXB5CXRnMjTBaB7l1CePCk4YY2+yiN/zx+sNg+p/LM0H4Iyp0zGvtxcIT8v70ShvvWDLh3K0RapyRKcjbSpotHeBTWynKLTMPBqVRYVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzpiyw7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzpiyw7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C9FC116C6;
	Tue,  6 Jan 2026 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720531;
	bh=HHAQ2A38BHjBHqLRhhdL8lBSiT5A4ITbAbiqZStpRpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzpiyw7R+PQRxEqdbvh3bPaomW24vApxVajFnb69s3SkysJwH1qxwncrV6753CFJR
	 yQg1yyd5JIrdpySssTjbGbTdaYpQNE0KrTE1lhBO48H5Q/N0sl/bJ4dwW9VM0pPhN9
	 IqSw4uqR84JDqJZD727D6B9XmsHBr4Nu4IUj0JEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 265/567] dt-bindings: PCI: qcom,pcie-sc7280: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:47 +0100
Message-ID: <20260106170501.128183330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ef99c2efeacac7758cc8c2d00e3200100a4da16c upstream.

Commit 756485bfbb85 ("dt-bindings: PCI: qcom,pcie-sc7280: Move SC7280 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 756485bfbb85 ("dt-bindings: PCI: qcom,pcie-sc7280: Move SC7280 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-2-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sc7280.yaml
@@ -74,6 +74,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


