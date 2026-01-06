Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3DD2F619A;
	Tue,  6 Jan 2026 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720551; cv=none; b=mxwYz8FK+N5GzMGVDjgUfYLvAZLI6cK3qoMEmduX+GPZ90eGtpG0+byewenSMQcbKN9uSUXRwu+dgj54eowwlt/ULT8co99Xf9kyRUHCgSlq+SVwFhq4ZAMd5pxYvTj96w1wAichiJKyT66WnQfwQrKYwe/azjsce7IqlV00p6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720551; c=relaxed/simple;
	bh=IwLx200u3GSbztm1ukLzkj+F2B6GLR1sIaQFjGzC2Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZRVeu64uDr8my7phyAzwik/MZiXijZ53289z3+Q3KErWdyw9Thief1rJIw7sQt7SGaJSr4vEoDGd9eb57KTZRlcbw/FVHVO3Kl3IESKTRQonPlX4UcHOFVaAMHaNFTsdpweV4OCEegnAWjziG32fn6W2wQJXNyXyK+9dds2jUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfRE3X/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfRE3X/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4CDC116C6;
	Tue,  6 Jan 2026 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720551;
	bh=IwLx200u3GSbztm1ukLzkj+F2B6GLR1sIaQFjGzC2Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfRE3X/+sl+mYD0DuXDaC0mY1CIUMU8N2oJM2VOXlG1xFi9/YfIpwyKmoRfR6JbwG
	 D6mzQpxIuNmuBVeAQSaXVbkoVhV3zsqEojk/TBtpZ/3KMFZn6byqnReNXX/G3vyzH/
	 mB0oIN7W+1x7im7CJKXsi/WtdJ1ZUhLHzPIG2MRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 271/567] dt-bindings: PCI: qcom,pcie-sm8550: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:53 +0100
Message-ID: <20260106170501.350643752@linuxfoundation.org>
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
@@ -78,6 +78,11 @@ properties:
       - const: pci # PCIe core reset
       - const: link_down # PCIe link down reset
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


